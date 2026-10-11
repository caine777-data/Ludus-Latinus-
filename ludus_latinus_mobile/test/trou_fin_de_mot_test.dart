import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/ui/features/lesson/widgets/cloze_fill_widget.dart';

Future<void> monter(WidgetTester tester, {required String avant, required String solution}) async {
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: ClozeFillWidget(
          avant: avant,
          apres: ' videt.',
          solution: solution,
          onCompleted: () {},
        ),
      ),
    ),
  ));
}

void main() {
  testWidgets('fin de mot : l\'élève sait qu\'il n\'écrit que la terminaison', (tester) async {
    await monter(tester, avant: 'Puer silv', solution: 'am');
    expect(find.text('✂️ Écris seulement la fin du mot'), findsOneWidget);
    expect(find.text('Puer'), findsOneWidget);
    expect(find.text('silv'), findsOneWidget);
    expect(find.text('fin'), findsOneWidget);
  });

  testWidgets('mot entier : la consigne le dit', (tester) async {
    await monter(tester, avant: 'Puer ', solution: 'silvam');
    expect(find.text('✍️ Écris le mot entier'), findsOneWidget);
    expect(find.text('mot'), findsOneWidget);
  });
}
