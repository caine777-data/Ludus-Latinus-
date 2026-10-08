import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/lesson.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/ui/features/lesson/lesson_screen.dart';

void main() {
  Lesson quiz({bool avecExplications = true}) => Lesson.fromJson({
        'id': 'test_expl',
        'type': 'quiz',
        'title': 'Test',
        'content': 'Contenu',
        'question': 'Quelle est la bonne ?',
        'options': ['Bonne', 'Fausse un', 'Fausse deux', 'Fausse trois'],
        'answer': 0,
        if (avecExplications) 'explications': ['', 'Raison un.', 'Raison deux.', 'Raison trois.'],
      });

  Future<void> monter(WidgetTester tester, Lesson lesson) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);
    final repo = GameRepository(dataService: DataService(), storageService: StorageService());
    await tester.pumpWidget(MaterialApp(home: LessonScreen(repo: repo, lesson: lesson)));
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> choisir(WidgetTester tester, String texte) async {
    final cible = find.text(texte);
    await tester.ensureVisible(cible);
    await tester.tap(cible);
    await tester.pump(const Duration(milliseconds: 600));
  }

  test('Lesson.fromJson lit explications, vide si absent', () {
    expect(quiz().explications.length, 4);
    expect(quiz(avecExplications: false).explications, isEmpty);
  });

  testWidgets('Chaque mauvaise option affiche sa propre explication', (tester) async {
    await monter(tester, quiz());

    await choisir(tester, 'Fausse deux');
    expect(find.text('Pas tout à fait…'), findsOneWidget);
    expect(find.text('Raison deux.'), findsOneWidget);
    expect(find.text('Raison un.'), findsNothing);

    await tester.tap(find.text('Réessayer'));
    await tester.pump(const Duration(milliseconds: 600));

    await choisir(tester, 'Fausse un');
    expect(find.text('Raison un.'), findsOneWidget);
    expect(find.text('Raison deux.'), findsNothing);
  });

  testWidgets('Sans explications, le bloc reste comme avant', (tester) async {
    await monter(tester, quiz(avecExplications: false));

    await choisir(tester, 'Fausse un');
    expect(find.text('Pas tout à fait…'), findsOneWidget);
    expect(find.textContaining('Raison'), findsNothing);
  });
}
