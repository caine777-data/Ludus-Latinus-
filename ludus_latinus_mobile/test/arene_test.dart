import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/ui/features/lesson/widgets/arena_challenge_widget.dart';

void main() {
  final questions = <Map<String, dynamic>>[
    for (var i = 1; i <= 3; i++)
      {
        'question': 'Question $i ?',
        'options': ['bonne $i', 'fausse $i a', 'fausse $i b', 'fausse $i c'],
        'answer': 0,
        'explanation': 'Explication $i.',
      },
  ];

  Future<List<int>> monter(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);
    // [réussites, erreurs]
    final compteurs = [0, 0];
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: ArenaChallengeWidget(
            boss: const {'nom': 'Le Boss', 'icone': '⚔️', 'pv': 3},
            questions: questions,
            onCompleted: () => compteurs[0]++,
            onMistake: () => compteurs[1]++,
          ),
        ),
      ),
    ));
    return compteurs;
  }

  Future<void> seTromper(WidgetTester tester, String reponse) async {
    await tester.tap(find.text(reponse));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));
  }

  testWidgets('Trois bonnes réponses : l\'explication s\'affiche, puis la victoire', (tester) async {
    final compteurs = await monter(tester);
    for (var i = 1; i <= 3; i++) {
      await tester.tap(find.text('bonne $i'));
      await tester.pump();
      expect(find.textContaining('Explication $i.'), findsOneWidget);
      expect(compteurs[0], 0, reason: 'la victoire attend le bouton');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
    }
    expect(compteurs, [1, 0]);
  });

  testWidgets('Une erreur coûte une vie, sans donner l\'explication', (tester) async {
    final compteurs = await monter(tester);
    await seTromper(tester, 'fausse 1 a');
    expect(compteurs[1], 1);
    expect(find.byIcon(Icons.favorite), findsNWidgets(2));
    expect(find.textContaining('Explication 1.'), findsNothing);
    expect(find.text('Question 1 ?'), findsOneWidget);
  });

  testWidgets('Trois erreurs : l\'arène est perdue et se retente', (tester) async {
    final compteurs = await monter(tester);
    await seTromper(tester, 'fausse 1 a');
    await seTromper(tester, 'fausse 1 b');
    await seTromper(tester, 'fausse 1 c');
    expect(find.text('Question 1 ?'), findsNothing);
    expect(find.text('Retenter l\'arène'), findsOneWidget);
    expect(compteurs[0], 0);

    await tester.tap(find.text('Retenter l\'arène'));
    await tester.pump();
    expect(find.text('Question 1 ?'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsNWidgets(3));
  });
}
