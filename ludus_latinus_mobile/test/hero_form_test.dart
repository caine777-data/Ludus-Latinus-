import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/profile.dart';
import 'package:ludus_latinus_mobile/ui/features/settings/hero_form.dart';

void main() {
  Widget monter(void Function(String, String) onChanged, {String genre = 'garcon', String prenom = ''}) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: HeroForm(
            profile: UserProfile(),
            genreInitial: genre,
            prenomInitial: prenom,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  testWidgets('Le prénom saisi est transmis tel quel, accents compris', (tester) async {
    String? prenom;
    await tester.pumpWidget(monter((p, g) => prenom = p));
    await tester.enterText(find.byType(TextField), 'Léa-Livia');
    expect(prenom, 'Léa-Livia');
  });

  testWidgets('Changer de genre garde le prénom déjà saisi', (tester) async {
    String? prenom;
    String? genre;
    await tester.pumpWidget(monter((p, g) {
      prenom = p;
      genre = g;
    }, prenom: 'Titus'));
    await tester.tap(find.text('Une Romaine'));
    await tester.pump();
    expect(genre, 'fille');
    expect(prenom, 'Titus');
  });

  testWidgets('Le prénom est limité à 18 caractères', (tester) async {
    String? prenom;
    await tester.pumpWidget(monter((p, g) => prenom = p));
    await tester.enterText(find.byType(TextField), 'Aaaaaaaaaaaaaaaaaaaaaaaa');
    await tester.pump();
    final champ = tester.widget<TextField>(find.byType(TextField));
    expect(champ.controller!.text.length, lessThanOrEqualTo(18));
    expect(prenom!.length, lessThanOrEqualTo(18));
  });
}
