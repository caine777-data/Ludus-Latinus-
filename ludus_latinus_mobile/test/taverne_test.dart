import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/ui/features/taverne/taverne_screen.dart';

void main() {
  test('Les totaux s\'écrivent en chiffres romains', () {
    const attendus = {4: 'IV', 9: 'IX', 14: 'XIV', 19: 'XIX', 21: 'XXI', 24: 'XXIV', 6: 'VI', 20: 'XX'};
    attendus.forEach((n, r) => expect(chiffreRomain(n), r));
  });

  test('Ad XXI : la manche commence avec deux dés, et dépasser XXI fait perdre', () {
    for (var graine = 0; graine < 50; graine++) {
      final p = PartieAdXXI(hasard: math.Random(graine));
      expect(p.desJoueur.length, 2);
      while (!p.joueurArrete) {
        p.encoreUnDe();
      }
      expect(p.joueurDepasse, isTrue, reason: 'à force de tirer, on dépasse');
      expect(p.issue, IssueManche.perdue);
      expect(p.tourDeGaius(), isFalse, reason: 'Gaius ne joue pas si on a déjà perdu');
    }
  });

  test('Ad XXI : Gaius tire jusqu\'à XVII au moins, puis on compare', () {
    for (var graine = 0; graine < 200; graine++) {
      final p = PartieAdXXI(hasard: math.Random(graine));
      p.arreter();
      while (p.tourDeGaius()) {}
      expect(p.totalGaius, greaterThanOrEqualTo(PartieAdXXI.seuilGaius));
      final attendu = p.totalGaius > 21 || p.totalJoueur > p.totalGaius
          ? IssueManche.gagnee
          : p.totalJoueur < p.totalGaius
              ? IssueManche.perdue
              : IssueManche.egalite;
      expect(p.issue, attendu);
    }
  });

  testWidgets('L\'écran affiche les règles, deux dés et un total en chiffres romains', (tester) async {
    tester.view.physicalSize = const Size(1080, 3000);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);
    final repo = GameRepository(dataService: DataService(), storageService: StorageService());
    await tester.pumpWidget(MaterialApp(home: TaverneScreen(repo: repo)));
    expect(find.textContaining('AD XXI'), findsOneWidget);
    expect(find.text('🎲 Encore un dé'), findsOneWidget);
    expect(find.textContaining(RegExp(r'^Total : [IVX]+$')), findsOneWidget);
    // On s'arrête : Gaius joue, la manche se termine.
    await tester.tap(find.text('✋ Je m\'arrête'));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 750));
    }
    expect(find.text('🎲 NOUVELLE MANCHE'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}
