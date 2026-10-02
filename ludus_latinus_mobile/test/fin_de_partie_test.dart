import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/ui/features/duel/duel_screen.dart';

const Map<String, String> kDuelReponses = {
  'Que signifie « Lupus » ?': 'Le loup',
  'Quel est le cas du sujet et de son attribut en latin ?': 'Le Nominatif',
  'Quel cas latin exprime le Complément d\'Objet Direct (COD) ?': 'L\'Accusatif',
  'Quel cas latin exprime la possession (complément du nom) ?': 'Le Génitif',
  'Quel cas latin correspond au COI et à l\'attribution ?': 'Le Datif',
  'Quel cas exprime les compléments de moyen, de temps et de lieu ?': 'L\'Ablatif',
  'Quel cas sert à interpeller directement quelqu\'un ?': 'Le Vocatif',
  'Que signifie « Bellum » ?': 'La guerre',
  'Que signifie « Pax » ?': 'La paix',
  'Qui est le dieu romain de la guerre ?': 'Mars',
  'Que signifie « Gladius » ?': 'Le glaive',
  'Comment s\'appelle le grand bouclier rectangulaire romain ?': 'Le Scutum',
  'Que désigne le « Pilum » lancé par les légionnaires ?': 'Le javelot lourd',
  'Comment appelle-t-on le casque de bronze du guerrier romain ?': 'La Galea',
  'Que signifie « Rex » (3e déclinaison) ?': 'Le roi',
  'Que signifie « Civis » ?': 'Le citoyen',
  'Que signifie « Urbs » ?': 'La ville',
  'Que signifie « Miles » ?': 'Le soldat / guerrier',
  'Que signifie « Dux » ?': 'Le chef / général',
  'Que signifie « Hostis » ?': 'L\'ennemi',
  'Quel suffixe caractérise l\'imparfait latin ?': '-ba-',
  'Que signifie « Veni, vidi, vici » prononcé par César ?': 'Je suis venu, j\'ai vu, j\'ai vaincu',
  'Que signifie « Alea iacta est » ?': 'Le sort en est jeté',
  'Que disaient les gladiateurs : « Morituri te salutant » ?': 'Ceux qui vont mourir te saluent',
  'Qui est le roi de l\'Olympe brandissant la foudre ?': 'Jupiter',
  'Quelle déesse romaine incarne la sagesse et la stratégie ?': 'Minerve',
  'Comment s\'appelle le corps d\'armée d\'élite de 5000 soldats ?': 'La Légion (Legio)',
  'Quel officier commande une centurie d\'environ 80 hommes ?': 'Le Centurion',
  'Comment appelle-t-on la célèbre formation sous les boucliers ?': 'La Tortue (Testudo)',
  'Que signifie l\'abréviation « SPQR » ?': 'Le Sénat et le Peuple Romain',
  'Que signifie « Virtus » chez les Romains ?': 'Le courage viril et la vaillance',
  'Que désigne « Castra » en latin ?': 'Le camp militaire fortifié',
};

void main() {
  Future<GameRepository> monterDuel(
    WidgetTester tester, {
    bool quotaAtteint = false,
  }) async {
    // Petit écran : 360 x 640 points logiques (720 x 1280 physique, ratio 2.0).
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final repo = GameRepository(dataService: DataService(), storageService: StorageService());
    repo.profile.sesterces = 0;
    // Défi du jour complété aujourd'hui pour isoler le barème pur du Duel.
    repo.profile.lastDailyQuestDate = DateTime.now().toIso8601String().substring(0, 10);

    if (quotaAtteint) {
      repo.profile.recompensesJeux = {'duel': 3};
      repo.profile.recompensesJeuxDate = DateTime.now().toIso8601String().substring(0, 10);
    } else {
      repo.profile.recompensesJeux = {};
    }

    await tester.pumpWidget(MaterialApp(home: DuelScreen(repo: repo)));
    await tester.pump();

    // Passer la cinématique d'entrée du boss si elle est affichée.
    final passerFinder = find.text('PASSER');
    if (passerFinder.evaluate().isNotEmpty) {
      await tester.tap(passerFinder);
      await tester.pump(const Duration(milliseconds: 500));
    }

    return repo;
  }

  Future<void> gagnerDuel(WidgetTester tester) async {
    // Crixus a 100 PV. La posture Gravis par défaut inflige 51 dégâts par bonne réponse.
    // Deux bonnes réponses suffisent pour terrasser le boss. La question suivante
    // peut mettre plus d'un tour de boucle à s'afficher : on prévoit de la marge.
    for (int coup = 0; coup < 6; coup++) {
      if (find.textContaining("TRIOMPHE DANS L'ARÈNE").evaluate().isNotEmpty) {
        break;
      }

      String? bonneReponse;
      for (final entry in kDuelReponses.entries) {
        if (find.text(entry.key).evaluate().isNotEmpty) {
          bonneReponse = entry.value;
          break;
        }
      }

      expect(bonneReponse, isNotNull, reason: 'Une question du Duel doit être affichée à l\'écran');

      final repFinder = find.widgetWithText(InkWell, bonneReponse!);
      // Faire défiler avec ensureVisible si la réponse est en bas d'écran.
      await tester.ensureVisible(repFinder);
      await tester.tapAt(tester.getTopLeft(repFinder) + const Offset(20, 15));
      await tester.pump();

      // Délai de 1 seconde entre les questions (ou déclenchement immédiat de la victoire).
      await tester.pump(const Duration(milliseconds: 1100));
    }
  }

  testWidgets('Victoire au Duel sur petit écran (360x640) - Quota non atteint', (tester) async {
    final repo = await monterDuel(tester, quotaAtteint: false);
    await gagnerDuel(tester);

    // Vérification du panneau de victoire et de la récompense
    expect(find.textContaining("TRIOMPHE DANS L'ARÈNE"), findsOneWidget);
    expect(find.text('+15 Sesterces remportés'), findsOneWidget);
    expect(find.text('Quitter'), findsOneWidget);
    expect(find.text('Boss Suivant'), findsOneWidget);
    expect(repo.profile.sesterces, 15);
  });

  testWidgets('Victoire au Duel sur petit écran (360x640) - Quota atteint (Pour la gloire)', (tester) async {
    final repo = await monterDuel(tester, quotaAtteint: true);

    await gagnerDuel(tester);

    // Vérification du panneau de victoire avec quota atteint
    expect(find.textContaining("TRIOMPHE DANS L'ARÈNE"), findsOneWidget);
    expect(find.text('Pour la gloire : 3 duels payés par jour'), findsOneWidget);
    expect(find.text('Quitter'), findsOneWidget);
    expect(find.text('Boss Suivant'), findsOneWidget);
    expect(repo.profile.sesterces, 0);
  });
}
