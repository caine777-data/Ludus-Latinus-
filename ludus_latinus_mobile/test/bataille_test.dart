import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/profile.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/l10n/app_localizations.dart';
import 'package:ludus_latinus_mobile/ui/features/bataille/bataille_logique.dart';
import 'package:ludus_latinus_mobile/ui/features/bataille/bataille_screen.dart';

class _StockageMemoire extends StorageService {
  @override
  Future<void> saveProfile(UserProfile profile) async {}
}

void main() {
  late DataService data;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    data = DataService();
    await data.loadDataset();
  });

  GameRepository depotAvec(List<String> cartes) {
    final stockage = _StockageMemoire();
    final profil = UserProfile(cartesAlbum: cartes);
    stockage.importProfileJson(json.encode({'format': StorageService.formatSauvegarde, 'profil': profil.toJson()}));
    return GameRepository(dataService: data, storageService: stockage);
  }

  group('Règles', () {
    test('Cartes de prêt : on complète jusqu\'à 5, communes d\'abord, jamais une carte possédée', () {
      final possedees = data.cartesAlbum.where((c) => c.rarete == 'commune').take(3).toList();
      final pret = cartesDePret(possedees, data.cartesAlbum, Random(1));
      expect(pret.length, 2);
      expect(pret.every((c) => c.rarete == 'commune'), isTrue);
      expect(pret.any((c) => possedees.contains(c)), isFalse);
      expect(cartesDePret(data.cartesAlbum.take(6).toList(), data.cartesAlbum, Random(1)), isEmpty);
    });

    test('Main de Crassus : même rareté carte à carte, sans doublon ni carte de l\'élève', () {
      final main = data.cartesAlbum.take(5).toList();
      final crassus = mainDeCrassus(main, data.cartesAlbum, Random(2));
      expect(crassus.length, 5);
      for (var i = 0; i < 5; i++) {
        expect(crassus[i].rarete, main[i].rarete);
      }
      expect(crassus.map((c) => c.id).toSet().length, 5);
      expect(crassus.any((c) => main.contains(c)), isFalse);
    });

    test('Crassus choisit la caractéristique qui l\'avantage', () {
      final lion = data.cartesAlbum.firstWhere((c) => c.id == 'mon_lion'); // 88 / 96
      final achille = data.cartesAlbum.firstWhere((c) => c.id == 'her_achille'); // 96 / 74
      expect(choixDeCrassus(achille, lion), Caracteristique.defense);
      expect(choixDeCrassus(lion, achille), Caracteristique.attaque);
      expect(comparer(achille, lion, Caracteristique.attaque), 1);
      expect(comparer(achille, lion, Caracteristique.defense), -1);
    });

    test('Partie : finie au 3e point, cartes jouées retirées', () {
      final p = PartieBataille(
        mainJoueur: data.cartesAlbum.take(5).toList(),
        mainCrassus: data.cartesAlbum.skip(5).take(5).toList(),
      );
      while (!p.finie) {
        p.jouer(p.mainJoueur.first, p.mainCrassus.first, Caracteristique.attaque);
      }
      expect(p.manche, lessThanOrEqualTo(5));
      expect(p.mainJoueur.length, 5 - p.manche);
      expect(p.issue, isNot(IssuePartie.enCours));
    });

    test('Question sur la devise : 4 réponses distinctes, dont la traduction', () {
      final carte = data.cartesAlbum.first;
      for (var graine = 0; graine < 20; graine++) {
        final q = questionPour(carte, data.cartesAlbum, const [], Random(graine));
        expect(q.estDevise, isTrue);
        expect(q.bonne, carte.traduction);
        expect(q.reponses.toSet().length, 4);
        expect(q.reponses, contains(q.bonne));
      }
    });
  });

  test('Récompense : victoire payée, série et record ; défaite remet la série à zéro', () {
    final repo = depotAvec(['her_romulus', 'her_julia', 'mon_borne']);
    final avant = repo.profile.sesterces;
    expect(repo.noterBataille(victoire: true), greaterThanOrEqualTo(GameRepository.gainBataille));
    repo.noterBataille(victoire: true);
    expect(repo.record('bataille'), 2);
    repo.noterBataille(victoire: false);
    expect(repo.profile.compteurs['bataille_serie'], 0);
    expect(repo.record('bataille'), 2);
    expect(repo.profile.sesterces, greaterThan(avant));
  });

  test('Déblocage : 3 cartes d\'album', () {
    expect(depotAvec(['her_romulus', 'her_julia']).profile.getUnlockStatusForGame('bataille').isUnlocked, isFalse);
    expect(depotAvec(['her_romulus', 'her_julia', 'mon_borne']).profile.getUnlockStatusForGame('bataille').isUnlocked,
        isTrue);
  });

  testWidgets('Une manche jouée de bout en bout, avec 3 cartes et 2 prêts', (tester) async {
    final ancien = FlutterError.onError;
    FlutterError.onError = (d) {
      if (!d.toString().contains('overflowed')) ancien?.call(d);
    };
    addTearDown(() => FlutterError.onError = ancien);
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final repo = depotAvec(['her_romulus', 'her_julia', 'mon_borne']);
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BatailleScreen(repo: repo),
    ));
    await tester.pump();

    expect(find.text('PRÊT'), findsNWidgets(2));
    await tester.tap(find.text('Combattre'));
    await tester.pump();
    expect(find.text('Pose une carte de ta main.'), findsOneWidget);

    // Pose la première carte de la main (Romulus, commune).
    await tester.tap(find.byType(InkWell).last);
    await tester.pump();
    final question = find.textContaining('« ');
    expect(question, findsWidgets);

    // Répond juste : cherche la réponse qui est la traduction d'une carte posée.
    final traductions = repo.cartesAlbum.map((c) => c.traduction).toSet();
    final vocabulaire = repo.vocabulaireAtteint.map((e) => e.fr).toSet();
    var repondu = false;
    for (final t in [...traductions, ...vocabulaire]) {
      if (find.text(t).evaluate().isEmpty) continue;
      await tester.tap(find.text(t).first);
      await tester.pump();
      repondu = true;
      break;
    }
    expect(repondu, isTrue);
    // Juste ou faux, la manche avance : choix de la caractéristique ou résultat.
    final choix = find.textContaining('Attaque ');
    if (choix.evaluate().isNotEmpty && find.text('Manche suivante').evaluate().isEmpty) {
      await tester.tap(choix.first);
      await tester.pump();
    }
    expect(find.text('Manche suivante'), findsOneWidget);
  });
}
