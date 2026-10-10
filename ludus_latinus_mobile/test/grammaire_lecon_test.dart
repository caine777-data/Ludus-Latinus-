import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/lesson.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/ui/features/lesson/lesson_screen.dart';
import 'package:ludus_latinus_mobile/ui/features/lesson/widgets/grammar_question_widget.dart';

void main() {
  const grammaire = {
    'question': 'Que veut dire « Magister sum. » ? (magister = le maître d\'école)',
    'options': [
      'Tu es le maître d\'école.',
      'Il est le maître d\'école.',
      'Nous sommes les maîtres d\'école.',
      'Je suis le maître d\'école.',
    ],
    'answer': 3,
    'explications': ['Raison tu.', 'Raison il.', 'Raison nous.', ''],
  };

  Lesson lecon({bool avecGrammaire = true}) => Lesson.fromJson({
        'id': 'test_gram',
        'type': 'quiz',
        'title': 'Test',
        'content': 'Contenu',
        'question': 'Question principale ?',
        'options': ['Bonne', 'Fausse un', 'Fausse deux', 'Fausse trois'],
        'answer': 0,
        if (avecGrammaire) 'grammaire': grammaire,
      });

  // La police de test (Ahem) est bien plus large que la vraie : les débordements
  // de l'en-tête et du bilan, qui existaient avant, y font du bruit. On ne garde
  // que ceux qui viennent de la carte de grammaire.
  List<String> ecouterDebordements() {
    final propres = <String>[];
    final ancien = FlutterError.onError;
    FlutterError.onError = (details) {
      final texte = details.toString();
      if (texte.contains('overflowed')) {
        if (texte.contains('grammar_question_widget.dart')) propres.add(texte);
        return;
      }
      ancien?.call(details);
    };
    addTearDown(() => FlutterError.onError = ancien);
    return propres;
  }

  Future<void> monter(WidgetTester tester, Lesson l, {double largeur = 400, double police = 1.0}) async {
    tester.view.physicalSize = Size(largeur * 2, 5000);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);
    final repo = GameRepository(dataService: DataService(), storageService: StorageService());
    await tester.pumpWidget(MediaQuery(
      data: MediaQueryData(size: Size(largeur, 2500), textScaler: TextScaler.linear(police)),
      child: MaterialApp(home: LessonScreen(repo: repo, lesson: l)),
    ));
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> choisir(WidgetTester tester, String texte) async {
    final cible = find.text(texte);
    await tester.ensureVisible(cible);
    await tester.tap(cible);
    await tester.pump(const Duration(milliseconds: 600));
  }

  test('Lesson.fromJson lit grammaire, absente par défaut', () {
    final g = lecon().grammaire!;
    expect(g.options.length, 4);
    expect(g.answer, 3);
    expect(g.explications[0], 'Raison tu.');
    expect(lecon(avecGrammaire: false).grammaire, isNull);
  });

  testWidgets('La grammaire vient après l\'exercice principal', (tester) async {
    ecouterDebordements();
    await monter(tester, lecon());
    expect(find.text('Question principale ?'), findsOneWidget);
    expect(find.text('Exercice de grammaire'), findsNothing);
    expect(find.textContaining('Magister sum'), findsNothing);
    expect(find.text('EXERCICE 1 / 2'), findsOneWidget);

    await choisir(tester, 'Bonne');
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Exercice de grammaire'), findsOneWidget);
    expect(find.textContaining('Magister sum'), findsOneWidget);
    expect(find.text('EXERCICE 2 / 2 • GRAMMAIRE'), findsOneWidget);
    expect(find.text('Question principale ?'), findsNothing);
  });

  testWidgets("Revoir le cours : le volet s'ouvre et se referme sur la question", (tester) async {
    ecouterDebordements();
    await monter(tester, lecon());
    await choisir(tester, 'Bonne');
    await tester.pump(const Duration(milliseconds: 600));

    await tester.ensureVisible(find.text('Revoir le cours'));
    await tester.tap(find.text('Revoir le cours'));
    await tester.pumpAndSettle();
    expect(find.text("Retour à l'exercice"), findsOneWidget);
    expect(find.text('Contenu'), findsNWidgets(2));

    await tester.tap(find.text("Retour à l'exercice"));
    await tester.pumpAndSettle();
    expect(find.text("Retour à l'exercice"), findsNothing);
    expect(find.text('Exercice de grammaire'), findsOneWidget);
  });

  testWidgets('Mauvaise réponse : son explication, puis la bonne fait avancer', (tester) async {
    ecouterDebordements();
    await monter(tester, lecon());
    await choisir(tester, 'Bonne');
    await tester.pump(const Duration(milliseconds: 600));

    await choisir(tester, 'Nous sommes les maîtres d\'école.');
    expect(find.text('Raison nous.'), findsOneWidget);
    expect(find.text('Raison tu.'), findsNothing);

    await choisir(tester, 'Il est le maître d\'école.');
    expect(find.text('Raison il.'), findsOneWidget);
    expect(find.text('Raison nous.'), findsNothing);
    // On est toujours sur la question.
    expect(find.text('Exercice de grammaire'), findsOneWidget);

    await choisir(tester, 'Je suis le maître d\'école.');
    await tester.pump(const Duration(seconds: 1));
    // Pas de vocabulaire dans ce test : la bonne réponse termine la leçon (bilan).
    expect(find.text('Leçon réussie'), findsOneWidget);
    await tester.pump(const Duration(seconds: 10));
  });

  testWidgets('Sans grammaire, la leçon se termine comme avant', (tester) async {
    ecouterDebordements();
    await monter(tester, lecon(avecGrammaire: false));
    await choisir(tester, 'Bonne');
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Exercice de grammaire'), findsNothing);
    expect(find.text('EXERCICE 1 / 1'), findsNothing);
    await tester.pump(const Duration(seconds: 10));
  });

  // Lisibilité : aucun texte écrasé ni débordement sur petits écrans, police agrandie.
  for (final (largeur, police) in <(double, double)>[(320, 1.0), (360, 1.0), (320, 1.3), (360, 1.3)]) {
    testWidgets('Carte de grammaire lisible ($largeur points, police x$police)', (tester) async {
      final debordements = ecouterDebordements();
      await monter(tester, lecon(), largeur: largeur, police: police);
      await choisir(tester, 'Bonne');
      await tester.pump(const Duration(milliseconds: 600));
      await choisir(tester, 'Nous sommes les maîtres d\'école.');

      final ecrases = <String>[];
      for (final element in find.descendant(of: find.byType(GrammarQuestionWidget), matching: find.byType(RichText)).evaluate()) {
        final boite = element.renderObject as RenderParagraph?;
        if (boite == null || !boite.hasSize) continue;
        final texte = boite.text.toPlainText().trim();
        final lettres = texte.replaceAll(RegExp(r'[^A-Za-zÀ-ÿ]'), '');
        if (lettres.length > 4 && boite.size.width < 48 && boite.size.height > boite.size.width) {
          ecrases.add('« $texte » : ${boite.size.width.toStringAsFixed(0)} x ${boite.size.height.toStringAsFixed(0)}');
        }
      }
      expect(ecrases, isEmpty, reason: ecrases.join('\n'));
      expect(debordements, isEmpty);
    });
  }
}
