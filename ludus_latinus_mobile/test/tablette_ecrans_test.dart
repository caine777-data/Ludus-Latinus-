import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/profile.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/l10n/app_localizations.dart';
import 'package:ludus_latinus_mobile/ui/core/widgets.dart';
import 'package:ludus_latinus_mobile/ui/features/account/account_screen.dart';
import 'package:ludus_latinus_mobile/ui/features/cesar/cesar_screen.dart';
import 'package:ludus_latinus_mobile/ui/features/forum/forum_screen.dart';
import 'package:ludus_latinus_mobile/ui/features/marche/marche_trajan_screen.dart';
import 'package:ludus_latinus_mobile/ui/features/memoria/memoria_screen.dart';
import 'package:ludus_latinus_mobile/ui/features/pantheon/pantheon_screen.dart';
import 'package:ludus_latinus_mobile/ui/features/settings/settings_screen.dart';
import 'package:ludus_latinus_mobile/ui/features/taverne/taverne_screen.dart';
import 'package:ludus_latinus_mobile/ui/features/thesaurus/thesaurus_screen.dart';

class _StockageMemoire extends StorageService {
  @override
  Future<void> saveProfile(UserProfile profile) async {}
}

/// Sur une tablette 10 pouces en paysage (1280 × 800 points), chaque écran garde
/// une colonne de 900 points au plus, et son contenu occupe bien la hauteur :
/// un défaut de mise en page avait vidé la Taverne sans qu'aucun test ne le voie.
void main() {
  late GameRepository repo;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final data = DataService();
    await data.loadDataset();
    repo = GameRepository(dataService: data, storageService: _StockageMemoire());
    // Assez de leçons pour ouvrir tous les jeux.
    for (final w in data.worlds.take(4)) {
      for (final l in w.lessons) {
        repo.completeLesson(l.id, 3);
      }
    }
  });

  final ecrans = <String, Widget Function()>{
    'Taverne': () => TaverneScreen(repo: repo),
    'Atelier de César': () => CesarScreen(repo: repo),
    'Marché de Trajan': () => MarcheTrajanScreen(repo: repo),
    'Memoria': () => MemoriaScreen(repo: repo),
    'Forum': () => ForumScreen(repo: repo),
    'Compte': () => AccountScreen(repo: repo),
    'Réglages': () => SettingsScreen(repo: repo),
    'Panthéon': () => PantheonScreen(repo: repo),
    'Thesaurus': () => ThesaurusScreen(repo: repo),
  };

  for (final e in ecrans.entries) {
    testWidgets('Tablette : ${e.key} en colonne, contenu visible', (tester) async {
      // La police de test déborde dans des titres : bruit sans rapport ici.
      final ancien = FlutterError.onError;
      FlutterError.onError = (d) {
        if (!d.toString().contains('overflowed')) ancien?.call(d);
      };
      addTearDown(() => FlutterError.onError = ancien);
      tester.view.physicalSize = const Size(2560, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: e.value(),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      final colonnes = find.byType(ColonneLecture);
      expect(colonnes, findsWidgets);
      var plusHaute = 0.0;
      for (final el in colonnes.evaluate()) {
        final taille = tester.getSize(find.byWidget(el.widget));
        expect(tester.getSize(find.descendant(of: find.byWidget(el.widget), matching: find.byType(ConstrainedBox)).first).width,
            lessThanOrEqualTo(900));
        // Une colonne écrasée à zéro (contenu caché par une autre) fait échouer.
        expect(taille.height, greaterThan(40));
        if (taille.height > plusHaute) plusHaute = taille.height;
      }
      // Le corps de l'écran occupe plus de la moitié de la hauteur (800 points),
      // et lui seul : une barre du bas qui s'étire vers le haut ferait échouer.
      expect(plusHaute, greaterThan(400));
      expect(colonnes.evaluate().where((el) => tester.getSize(find.byWidget(el.widget)).height > 400).length, 1);
    });
  }
}
