import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/profile.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/l10n/app_localizations.dart';
import 'package:ludus_latinus_mobile/ui/features/home/ecran_titre_screen.dart';

/// Stockage en mémoire : les tests n'écrivent pas de fichier de sauvegarde.
class _StockageMemoire extends StorageService {
  @override
  Future<void> saveProfile(UserProfile profile) async {}
}

void main() {
  late DataService data;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    data = DataService();
    await data.loadDataset();
  });

  /// Ouvre le titre par-dessus une page témoin, pour vérifier qu'on en sort.
  Future<GameRepository> ouvrir(WidgetTester tester, Size taille, {double police = 1, String? prenom}) async {
    tester.view.physicalSize = taille;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final repo = GameRepository(dataService: data, storageService: _StockageMemoire());
    if (prenom != null) {
      repo.profile
        ..heroChoisi = true
        ..nomHeros = prenom;
    }
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('fr'),
      builder: (context, enfant) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(police)),
        child: enfant!,
      ),
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => EcranTitreScreen(repo: repo)),
          ),
          child: const Text('témoin'),
        ),
      ),
    ));
    await tester.tap(find.text('témoin'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    return repo;
  }

  String imageAffichee(WidgetTester tester) =>
      (tester.widget<Image>(find.byType(Image)).image as AssetImage).assetName;

  testWidgets('Une image par orientation', (tester) async {
    await ouvrir(tester, const Size(1080, 2340));
    expect(imageAffichee(tester), contains('portrait'));
    await tester.pumpWidget(const SizedBox());
    await ouvrir(tester, const Size(2560, 1600));
    expect(imageAffichee(tester), contains('paysage'));
  });

  testWidgets('Premier lancement : le titre, sans salut ni autre élève', (tester) async {
    await ouvrir(tester, const Size(1080, 2340));
    expect(find.text('LUDUS LATINUS'), findsOneWidget);
    expect(find.textContaining('Salve'), findsNothing);
    expect(find.text('Changer d\'élève'), findsNothing);
  });

  testWidgets('L\'élève revenu est salué par son prénom', (tester) async {
    await ouvrir(tester, const Size(1080, 2340), prenom: 'Marcus');
    expect(find.text('Salve, Marcus !'), findsOneWidget);
  });

  testWidgets('Toucher l\'écran fait entrer, et un double appui ne sort qu\'une fois', (tester) async {
    await ouvrir(tester, const Size(1080, 2340));
    await tester.tapAt(const Offset(540, 1200));
    await tester.tapAt(const Offset(540, 1200));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(EcranTitreScreen), findsNothing);
    expect(find.text('témoin'), findsOneWidget);
  });

  testWidgets('La touche Entrée fait entrer', (tester) async {
    await ouvrir(tester, const Size(2560, 1600));
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(EcranTitreScreen), findsNothing);
  });

  for (final taille in const [Size(320, 568), Size(360, 800), Size(800, 500), Size(2560, 1600)]) {
    testWidgets('Rien ne déborde en $taille, police agrandie', (tester) async {
      await ouvrir(tester, taille, police: 1.5, prenom: 'Marcus Aurelius');
      expect(tester.takeException(), isNull);
    });
  }
}
