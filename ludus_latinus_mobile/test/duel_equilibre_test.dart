import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/ui/features/duel/duel_equilibre.dart';
import 'package:ludus_latinus_mobile/ui/features/duel/duel_screen.dart';

void main() {
  group('Équilibre du Duel', () {
    test('les PV des boss montent d\'un boss à l\'autre', () {
      expect(DuelEquilibre.pvBoss, [100, 130, 160, 200, 250]);
      for (var i = 1; i < DuelEquilibre.pvBoss.length; i++) {
        expect(DuelEquilibre.pvBoss[i], greaterThan(DuelEquilibre.pvBoss[i - 1]));
      }
      expect(DuelEquilibre.attaqueBoss.length, DuelEquilibre.pvBoss.length);
    });

    test('dégâts par posture : lourde > vive > parade', () {
      expect(DuelEquilibre.degats(CombatStance.gravis), 50);
      expect(DuelEquilibre.degats(CombatStance.celox), 35);
      expect(DuelEquilibre.degats(CombatStance.scutum), 25);
      expect(DuelEquilibre.degats(CombatStance.celox, critique: true), 44);
      // Le critique n'existe que pour l'attaque vive.
      expect(DuelEquilibre.degats(CombatStance.gravis, critique: true), 50);
    });

    test('riposte par posture et par boss', () {
      expect(DuelEquilibre.riposte(CombatStance.gravis, 0), 30);
      expect(DuelEquilibre.riposte(CombatStance.celox, 0), 20);
      expect(DuelEquilibre.riposte(CombatStance.scutum, 0), 10);
      expect(DuelEquilibre.riposte(CombatStance.gravis, 4), 60);
      expect(DuelEquilibre.riposte(CombatStance.celox, 4), 40);
      expect(DuelEquilibre.riposte(CombatStance.scutum, 4), 20);
    });

    test('bonnes réponses pour vaincre et erreurs supportées', () {
      expect(DuelEquilibre.reponsesPourVaincre(CombatStance.gravis, 0), 2);
      expect(DuelEquilibre.reponsesPourVaincre(CombatStance.celox, 0), 3);
      expect(DuelEquilibre.reponsesPourVaincre(CombatStance.scutum, 0), 4);
      expect(DuelEquilibre.reponsesPourVaincre(CombatStance.gravis, 4), 5);
      expect(DuelEquilibre.reponsesPourVaincre(CombatStance.celox, 4), 8);
      expect(DuelEquilibre.reponsesPourVaincre(CombatStance.scutum, 4), 10);
      // Dernier boss : la lourde tombe à la 2e erreur, la parade tient 5 erreurs.
      expect(DuelEquilibre.erreursPourPerdre(CombatStance.gravis, 4), 2);
      expect(DuelEquilibre.erreursPourPerdre(CombatStance.celox, 4), 3);
      expect(DuelEquilibre.erreursPourPerdre(CombatStance.scutum, 4), 5);
    });

    test('la parade est un vrai choix : plus d\'erreurs permises, mais plus de réponses', () {
      for (var b = 0; b < DuelEquilibre.pvBoss.length; b++) {
        expect(DuelEquilibre.erreursPourPerdre(CombatStance.scutum, b),
            greaterThan(DuelEquilibre.erreursPourPerdre(CombatStance.gravis, b)));
        expect(DuelEquilibre.reponsesPourVaincre(CombatStance.scutum, b),
            greaterThan(DuelEquilibre.reponsesPourVaincre(CombatStance.gravis, b)));
      }
    });

    test('fenêtre de mondes : tous les mondes d\'abord, puis de plus en plus récents', () {
      expect(DuelEquilibre.fenetreMondes(0), isNull);
      expect(DuelEquilibre.fenetreMondes(1), isNull);
      expect(DuelEquilibre.fenetreMondes(2), 6);
      expect(DuelEquilibre.fenetreMondes(3), 4);
      expect(DuelEquilibre.fenetreMondes(4), 3);
    });

    test('les descriptions disent les vrais chiffres', () {
      expect(CombatStance.gravis.description, contains('50 dégâts'));
      expect(CombatStance.gravis.description, contains('150 %'));
      expect(CombatStance.celox.description, contains('35 dégâts'));
      expect(CombatStance.celox.description, contains('44'));
      expect(CombatStance.celox.description, contains('100 %'));
      expect(CombatStance.scutum.description, contains('25 dégâts'));
      expect(CombatStance.scutum.description, contains('50 %'));
      for (final p in CombatStance.values) {
        expect(p.description.contains('—'), isFalse);
      }
    });
  });

  group('Duel : lisibilité', () {
    for (final (largeur, police) in <(double, double)>[(320, 1.0), (360, 1.6), (360, 2.0)]) {
      testWidgets('aucun texte écrasé ni débordement ($largeur points, police x$police)', (tester) async {
        tester.view.physicalSize = Size(largeur * 2, 1280);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.reset);
        final repo = GameRepository(dataService: DataService(), storageService: StorageService());
        await tester.pumpWidget(MediaQuery(
          data: MediaQueryData(size: Size(largeur, 640), textScaler: TextScaler.linear(police)),
          child: MaterialApp(home: DuelScreen(repo: repo)),
        ));
        await tester.pump();
        final passer = find.text('PASSER');
        if (passer.evaluate().isNotEmpty) {
          await tester.tap(passer);
          await tester.pump(const Duration(milliseconds: 500));
        }
        for (final p in CombatStance.values) {
          await tester.ensureVisible(find.text(p.francais).first);
          await tester.tap(find.text(p.francais).first);
          await tester.pump();
          expect(find.text(p.description), findsOneWidget);
        }
        final exc = tester.takeException();
        expect(exc, isNull, reason: exc is FlutterError ? exc.toStringDeep() : '$exc');
        for (final element in find.byType(RichText).evaluate()) {
          final boite = element.renderObject as RenderParagraph?;
          if (boite == null || !boite.hasSize) continue;
          final lettres = boite.text.toPlainText().replaceAll(RegExp(r'[^A-Za-zÀ-ÿ]'), '');
          expect(lettres.length > 4 && boite.size.width < 48 && boite.size.height > boite.size.width, isFalse,
              reason: boite.text.toPlainText());
        }
      });
    }
  });
}
