import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/ui/features/marche/marche_trajan_screen.dart';

void main() {
  Future<GameRepository> monter(WidgetTester tester, {List<String> dejaPayes = const []}) async {
    tester.view.physicalSize = const Size(1080, 5000);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);
    final repo = GameRepository(dataService: DataService(), storageService: StorageService());
    repo.profile.sesterces = 0;
    // Défi du jour déjà fait : on ne mesure ici que le paiement de l'étal.
    repo.profile.lastDailyQuestDate = DateTime.now().toIso8601String().substring(0, 10);
    repo.profile.recompensesUniques.addAll(dejaPayes);
    await tester.pumpWidget(MaterialApp(home: MarcheTrajanScreen(repo: repo)));
    return repo;
  }

  Future<void> composer(WidgetTester tester, String romain) async {
    for (final lettre in romain.split('')) {
      // La saisie s'affiche aussi au-dessus du clavier : la tuile est le dernier « X ».
      await tester.tap(find.text(lettre).last);
      await tester.pump();
    }
    await tester.tap(find.textContaining('PAYER'));
    await tester.pump();
  }

  // Premier article : amphore d'huile à 25 HS, soit XXV.
  testWidgets('Un étal réussi paie une fois et s\'en souvient', (tester) async {
    final repo = await monter(tester);
    await composer(tester, 'XXV');
    expect(repo.profile.sesterces, GameRepository.gainMarcheEtal);
    expect(repo.estDejaPaye('marche:etal:0'), isTrue);
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });

  String romain(int n) {
    const valeurs = [100, 90, 50, 40, 10, 9, 5, 4, 1];
    const lettres = ['C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I'];
    final b = StringBuffer();
    var reste = n;
    for (var i = 0; i < valeurs.length; i++) {
      while (reste >= valeurs[i]) {
        b.write(lettres[i]);
        reste -= valeurs[i];
      }
    }
    return b.toString();
  }

  testWidgets('Un étal déjà payé revient avec un prix au hasard, payé comme une partie', (tester) async {
    final repo = await monter(tester, dejaPayes: ['marche:etal:0']);
    final etiquette = find.textContaining(RegExp(r'^\d+ SESTERCES$'));
    final prix = int.parse((tester.widget<Text>(etiquette).data ?? '').split(' ').first);
    await composer(tester, romain(prix));
    expect(repo.profile.sesterces, GameRepository.gainMarcheEtal);
    expect(repo.recompensesRestantes('marche'), 2);
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });

  testWidgets('Réussi après une erreur, l\'étal ne paie pas', (tester) async {
    final repo = await monter(tester);
    await composer(tester, 'XXIIIII');
    await tester.tap(find.text('RAZ'));
    await tester.pump();
    await composer(tester, 'XXV');
    expect(repo.profile.sesterces, 0);
    expect(repo.estDejaPaye('marche:etal:0'), isFalse);
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
