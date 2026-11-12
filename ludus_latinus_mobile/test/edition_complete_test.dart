import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/profile.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/achat_service.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/l10n/app_localizations.dart';
import 'package:ludus_latinus_mobile/ui/features/edition/edition_complete_screen.dart';

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

  GameRepository depot(AchatService achats) =>
      GameRepository(dataService: data, storageService: _StockageMemoire(), achats: achats);

  test('Sans achat : mondes 1 à 3 et premières leçons ouverts, le reste réservé', () {
    final repo = depot(AchatSimule());
    final mondes = repo.worlds;
    for (final l in mondes.take(GameRepository.mondesGratuits).expand((m) => m.lessons)) {
      expect(repo.leconReservee(l), isFalse, reason: l.id);
    }
    for (final m in mondes.skip(GameRepository.mondesGratuits)) {
      expect(repo.leconReservee(m.lessons.first), isFalse, reason: 'première leçon de ${m.id}');
      for (final l in m.lessons.skip(1)) {
        expect(repo.leconReservee(l), isTrue, reason: l.id);
      }
    }
    final reservees = mondes.expand((m) => m.lessons).where(repo.leconReservee).length;
    expect(repo.nombreLeconsDeLEdition, reservees);
  });

  test('Une leçon déjà réussie reste ouverte', () {
    final repo = depot(AchatSimule());
    final lecon = repo.worlds[GameRepository.mondesGratuits].lessons[1];
    repo.completeLesson(lecon.id, 3);
    expect(repo.leconReservee(lecon), isFalse);
  });

  test('L\'achat ouvre tout et prévient l\'interface', () async {
    final achats = AchatSimule();
    final repo = depot(achats);
    var notifie = false;
    repo.addListener(() => notifie = true);
    await achats.acheter();
    expect(notifie, isTrue);
    expect(repo.worlds.expand((m) => m.lessons).where(repo.leconReservee), isEmpty);
  });

  test('Édition offerte (test fermé, PC) : rien n\'est réservé ni à vendre', () {
    final repo = depot(AchatOffert());
    expect(repo.achats.estPayant, isFalse);
    expect(repo.worlds.expand((m) => m.lessons).where(repo.leconReservee), isEmpty);
  });

  test('L\'achat mémorisé vaut pour l\'appareil', () async {
    final dossier = await Directory.systemTemp.createTemp('ludus_edition');
    addTearDown(() => dossier.delete(recursive: true));
    final stockage = StorageService(dossier: dossier.path);
    expect(await stockage.lireEditionComplete(), isFalse);
    await stockage.ecrireEditionComplete();
    expect(await StorageService(dossier: dossier.path).lireEditionComplete(), isTrue);
  });

  testWidgets('Écran d\'achat : prix, achat, puis remerciement', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    final repo = depot(AchatSimule());
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('fr'),
      home: EditionCompleteScreen(repo: repo),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Débloquer pour 3,99 €'), findsOneWidget);
    expect(find.textContaining('${repo.nombreLeconsDeLEdition} autres leçons'), findsOneWidget);
    await tester.tap(find.text('Débloquer pour 3,99 €'));
    await tester.pumpAndSettle();
    expect(find.text('Merci ! Toute la Via Appia est ouverte.'), findsOneWidget);
  });
}
