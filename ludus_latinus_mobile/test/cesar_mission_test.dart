import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/ui/features/cesar/cesar_screen.dart';

void main() {
  Future<GameRepository> monter(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);
    final repo = GameRepository(dataService: DataService(), storageService: StorageService());
    repo.profile.sesterces = 0;
    await tester.pumpWidget(MaterialApp(home: CesarScreen(repo: repo)));
    // Mission 1 : clé +3. La roue part de +1.
    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pump();
    return repo;
  }

  final bonne = kMissionsCesar[0].traduction;

  testWidgets('La bonne clé ne paie rien : il faut encore choisir la traduction', (tester) async {
    final repo = await monter(tester);
    expect(find.text('QUE DIT LE MESSAGE ?'), findsOneWidget);
    expect(find.text('Traduction : $bonne'), findsNothing);
    expect(repo.profile.sesterces, 0);
    expect(repo.isMissionCesarReussie(0), isFalse);
  });

  testWidgets('Bonne traduction du premier coup : 10 HS, une seule fois', (tester) async {
    final repo = await monter(tester);
    await tester.tap(find.text(bonne));
    await tester.pump(const Duration(seconds: 1));
    expect(repo.isMissionCesarReussie(0), isTrue);
    expect(repo.profile.sesterces, GameRepository.gainMissionCesar);
    expect(repo.validerMissionCesar(0, 10), 0);
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });

  testWidgets('Après une erreur, la mission ne rapporte que la moitié', (tester) async {
    final repo = await monter(tester);
    final fausse = kMissionsCesar[1].traduction;
    final finder = find.text(fausse);
    // Les deux fausses traductions sont tirées au hasard parmi les 5 autres.
    final mauvaise = finder.evaluate().isNotEmpty
        ? fausse
        : kMissionsCesar.skip(1).map((m) => m.traduction).firstWhere((t) => find.text(t).evaluate().isNotEmpty);
    await tester.tap(find.text(mauvaise));
    await tester.pump();
    expect(repo.isMissionCesarReussie(0), isFalse);
    expect(repo.profile.sesterces, 0);
    await tester.tap(find.text(bonne));
    await tester.pump(const Duration(seconds: 1));
    expect(repo.profile.sesterces, GameRepository.gainMissionCesar ~/ 2);
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
  testWidgets('Un message libre tiré des leçons, payé comme une partie', (tester) async {
    tester.view.physicalSize = const Size(1080, 6000);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);
    final data = DataService();
    await tester.runAsync(data.loadDataset);
    final repo = GameRepository(dataService: data, storageService: StorageService());
    repo.profile.sesterces = 0;
    await tester.pumpWidget(MaterialApp(home: CesarScreen(repo: repo)));
    // L'onglet est au bout d'une rangée qui défile.
    await tester.ensureVisible(find.text('Message libre ∞'));
    await tester.pump();
    await tester.tap(find.text('Message libre ∞'));
    await tester.pump();

    // La clé est inconnue : on tourne la roue jusqu'à voir apparaître les traductions.
    for (var i = 0; i < 26 && find.text('QUE DIT LE MESSAGE ?').evaluate().isEmpty; i++) {
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();
    }
    expect(find.text('QUE DIT LE MESSAGE ?'), findsOneWidget);

    // Les traductions proposées viennent des puzzles du monde 1, seul monde atteint.
    final monde1 = repo.worlds.first.lessons.where((l) => l.type == 'puzzle').map((l) => '« ${l.solution} »').toList();
    final bonne = monde1.firstWhere((t) => find.text(t).evaluate().isNotEmpty);
    // Il peut y avoir deux puzzles au monde 1 : on cherche celle qui déclenche la victoire.
    await tester.tap(find.text(bonne));
    await tester.pump(const Duration(seconds: 1));
    if (repo.profile.sesterces == 0) {
      final autre = monde1.firstWhere((t) => t != bonne && find.text(t).evaluate().isNotEmpty);
      await tester.tap(find.text(autre));
      await tester.pump(const Duration(seconds: 1));
      expect(repo.profile.sesterces, GameRepository.gainMissionCesar ~/ 2);
    } else {
      expect(repo.profile.sesterces, GameRepository.gainMissionCesar);
    }
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}
