import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/ui/features/lesson/widgets/case_decoder_widget.dart';

Future<void> monter(WidgetTester tester, Widget w) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: SingleChildScrollView(child: w))));
  await tester.pump();
}

void main() {
  testWidgets('sans génitif dans la phrase, le bouton génitif est absent', (tester) async {
    await monter(
      tester,
      CaseDecoderWidget(
        words: const ['Puellam', 'lupus', 'videt'],
        expectedRoles: const {'0': 'cod', '1': 'sujet', '2': 'verbe'},
        onCompleted: () {},
      ),
    );
    expect(find.text('Compl. du nom (Génitif)'), findsNothing);
    expect(find.text('Sujet (Nominatif)'), findsOneWidget);
  });

  testWidgets('avec un génitif : quatre boutons, réussite et traduction affichée', (tester) async {
    var fini = false;
    await monter(
      tester,
      CaseDecoderWidget(
        words: const ['Mercator', 'vinum', 'domini', 'vendit'],
        expectedRoles: const {'0': 'sujet', '1': 'cod', '2': 'genitif', '3': 'verbe'},
        traduction: 'Le marchand vend le vin du maître.',
        onCompleted: () => fini = true,
      ),
    );
    expect(find.text('Compl. du nom (Génitif)'), findsOneWidget);

    // Le mot sélectionné avance tout seul après chaque attribution.
    for (final role in ['Sujet (Nominatif)', 'COD (Accusatif)', 'Compl. du nom (Génitif)', "Verbe d'action"]) {
      await tester.tap(find.widgetWithText(ElevatedButton, role));
      await tester.pump();
    }
    await tester.tap(find.text('VÉRIFIER LE DÉCODAGE ▶'));
    await tester.pump();

    expect(fini, isTrue);
    expect(find.textContaining('Le marchand vend le vin du maître.'), findsOneWidget);
  });
}
