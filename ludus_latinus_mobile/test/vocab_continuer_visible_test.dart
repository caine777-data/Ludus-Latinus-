import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/thesaurus_entry.dart';
import 'package:ludus_latinus_mobile/data/models/vocab_question.dart';
import 'package:ludus_latinus_mobile/l10n/app_localizations.dart';
import 'package:ludus_latinus_mobile/ui/features/lesson/widgets/vocab_question_widget.dart';

// Audit T58 : après une réponse en vocabulaire, la correction poussait le bouton
// « Continuer » sous le bord de l'écran et l'élève croyait l'appli bloquée.
// L'écran doit défiler tout seul jusqu'au bouton.
void main() {
  const entree = ThesaurusEntry(
    latin: 'spelunca, -ae',
    cat: 'Nom',
    genre: 'fém. 1re décl.',
    fr: 'la grotte, la caverne',
    etym: 'spéléologie',
    ex: 'Ulixes in spelunca est.',
    exFr: 'Ulysse est dans la grotte.',
  );
  const question = VocabQuestion(
    prompt: 'Que signifie « spelunca » ?',
    options: ['le pain', 'la grotte, la caverne', "l'amie", 'la maison'],
    answer: 1,
    entry: entree,
  );

  testWidgets('Le bouton « Continuer » apparaît à l\'écran après la réponse', (tester) async {
    // Écran de téléphone, avec du contenu au-dessus de la question comme
    // dans une vraie leçon (le cours occupe le haut).
    tester.view.physicalSize = const Size(400 * 2.625, 800 * 2.625);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: ListView(
          children: [
            const SizedBox(height: 420),
            VocabQuestionWidget(question: question, progressLabel: 'EXERCICE 3 / 5', onAnswered: (_) {}),
          ],
        ),
      ),
    ));
    await tester.tap(find.text('la grotte, la caverne'));
    await tester.pumpAndSettle();

    final bouton = find.byType(ElevatedButton);
    expect(bouton, findsOneWidget);
    final bas = tester.getRect(bouton).bottom;
    expect(bas, lessThanOrEqualTo(800), reason: 'bouton hors de l\'écran (bas à $bas)');
  });
}
