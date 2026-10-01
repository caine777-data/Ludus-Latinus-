import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/latin_epigraph.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/ui/core/latin_epigraph_modal.dart';

void main() {
  final stele = LatinEpigraph.catalogue['templum_saturni']!;

  Future<GameRepository> monter(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);
    final repo = GameRepository(dataService: DataService(), storageService: StorageService());
    repo.profile.sesterces = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: LatinEpigraphModal(epigraph: stele, repo: repo)),
    ));
    return repo;
  }

  Future<void> examinerTout(WidgetTester tester) async {
    for (final token in stele.tokens) {
      await tester.tap(find.widgetWithText(ActionChip, token.texteGraver));
      await tester.pump();
    }
  }

  /// Le fragment demandé est le seul texte gravé affiché pendant l'épreuve.
  EpigraphToken fragmentDemande() =>
      stele.tokens.firstWhere((t) => find.text(t.texteGraver).evaluate().isNotEmpty);

  testWidgets('Avant l\'épreuve, la traduction complète est cachée et rien n\'est payé', (tester) async {
    final repo = await monter(tester);
    expect(find.text(stele.traductionComplete), findsNothing);
    final bouton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(bouton.onPressed, isNull);
    expect(repo.profile.sesterces, 0);
  });

  testWidgets('Trois bonnes réponses du premier coup : récompense entière', (tester) async {
    final repo = await monter(tester);
    await examinerTout(tester);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.widgetWithText(OutlinedButton, fragmentDemande().traduction));
      await tester.pump();
    }
    expect(repo.isEpigraphDecoded(stele.monumentId), isTrue);
    expect(repo.profile.sesterces, stele.recompense);
    expect(find.text(stele.traductionComplete), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });

  testWidgets('Après une erreur, la stèle ne rapporte que la moitié', (tester) async {
    final repo = await monter(tester);
    await examinerTout(tester);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    final bonne = fragmentDemande().traduction;
    final fausse = stele.tokens
        .map((t) => t.traduction)
        .firstWhere((t) => t != bonne && find.widgetWithText(OutlinedButton, t).evaluate().isNotEmpty);
    await tester.tap(find.widgetWithText(OutlinedButton, fausse));
    await tester.pump();
    expect(repo.isEpigraphDecoded(stele.monumentId), isFalse);
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.widgetWithText(OutlinedButton, fragmentDemande().traduction));
      await tester.pump();
    }
    expect(repo.profile.sesterces, (stele.recompense + 1) ~/ 2);
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}
