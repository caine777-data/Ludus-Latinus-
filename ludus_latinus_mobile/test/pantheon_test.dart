import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/carte_pantheon.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/ui/features/pantheon/pantheon_screen.dart';

/// Le Panthéon est un album : une carte par monde, gagnée quand toutes les
/// leçons du monde sont faites.
Future<GameRepository> depotCharge(WidgetTester tester) async {
  final repo = GameRepository(dataService: DataService(), storageService: StorageService());
  await tester.runAsync(() => repo.dataService.loadDataset());
  return repo;
}

void terminerMonde(GameRepository repo, int rang) {
  for (final l in repo.worlds[rang - 1].lessons) {
    repo.profile.completedLessons.add(l.id);
  }
}

void main() {
  group('Données du Panthéon', () {
    test('26 cartes, une par monde, avec image attendue au format carte_mondeNN.png', () {
      final brut = File('assets/data/pantheon.json').readAsStringSync();
      final cartes = ((json.decode(brut) as Map<String, dynamic>)['cartes'] as List)
          .map((c) => CartePantheon.fromJson(c as Map<String, dynamic>))
          .toList();
      expect(cartes.length, 26);
      expect(cartes.map((c) => c.monde), List.generate(26, (i) => i + 1));
      for (final c in cartes) {
        expect(c.nom, isNotEmpty);
        expect(c.devise, isNotEmpty);
        expect(c.traduction, isNotEmpty);
        expect(c.image, 'assets/images/pantheon/carte_monde${c.monde.toString().padLeft(2, '0')}.png');
        expect(c.imageRepli, 'assets/images/mondes/monde${c.monde}.webp');
      }
      expect(cartes[15].devise, 'Veni, vidi, vici.');
    });

    testWidgets('chaque carte correspond à un monde du dataset', (tester) async {
      final repo = await depotCharge(tester);
      expect(repo.cartesPantheon.length, 26);
      for (final c in repo.cartesPantheon) {
        expect(repo.worlds.any((w) => w.id == c.mondeId), isTrue, reason: c.mondeId);
        expect(repo.carteDuMonde(c.mondeId), isNotNull);
      }
    });
  });

  group('Carte gagnée selon les leçons terminées', () {
    testWidgets('un monde entamé ne donne rien, un monde terminé donne sa carte', (tester) async {
      final repo = await depotCharge(tester);
      final carte1 = repo.carteDuMonde('monde1')!;
      final carte2 = repo.carteDuMonde('monde2')!;

      repo.profile.completedLessons.add(repo.worlds[0].lessons.first.id);
      expect(repo.isCarteGagnee(carte1), isFalse);

      terminerMonde(repo, 1);
      expect(repo.isCarteGagnee(carte1), isTrue);
      expect(repo.isCarteGagnee(carte2), isFalse);
      expect(repo.mondesTermines, {'monde1'});
    });

    testWidgets('la dernière leçon d\'un monde annonce la carte gagnée', (tester) async {
      final repo = await depotCharge(tester);
      final lecons = repo.worlds[2].lessons;
      for (final l in lecons.take(lecons.length - 1)) {
        expect(repo.completeLesson(l.id, 3).carteGagnee, isNull);
      }
      final dernier = repo.completeLesson(lecons.last.id, 3);
      expect(dernier.worldCompleted, isTrue);
      expect(dernier.carteGagnee?.nom, 'Jupiter');
      // Refaire la leçon ne redonne pas l'annonce.
      expect(repo.completeLesson(lecons.last.id, 3).carteGagnee, isNull);
    });
  });

  group('Écran du Panthéon', () {
    Future<void> monter(WidgetTester tester, GameRepository repo) async {
      tester.view.physicalSize = const Size(360 * 3, 2400);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(home: PantheonScreen(repo: repo)));
      await tester.pump(const Duration(milliseconds: 300));
    }

    testWidgets('carte gagnée : nom, devise, traduction ; autres cartes cachées', (tester) async {
      final repo = await depotCharge(tester);
      terminerMonde(repo, 1);
      await monter(tester, repo);

      expect(find.text('1 / 26 cartes'), findsOneWidget);
      expect(find.text('La Louve du Capitole'), findsOneWidget);
      expect(find.text('Lupa Romulum et Remum nutrit.'), findsOneWidget);
      expect(find.text('La louve nourrit Romulus et Rémus.'), findsOneWidget);
      final devise = tester.widget<Text>(find.text('Lupa Romulum et Remum nutrit.'));
      expect(devise.style?.fontStyle, FontStyle.italic);

      // La carte du monde 2 ne se dévoile pas tant que le monde n'est pas terminé.
      expect(find.text('La Mosaïque du chien'), findsNothing);
      expect(find.text('Cave canem !'), findsNothing);
      expect(
        find.text('Termine le monde 2 : ${repo.worlds[1].title} pour la débloquer'),
        findsOneWidget,
      );
    });

    testWidgets('aucun monde terminé : toutes les cartes sont cachées', (tester) async {
      final repo = await depotCharge(tester);
      await monter(tester, repo);
      expect(find.text('0 / 26 cartes'), findsOneWidget);
      expect(find.text('La Louve du Capitole'), findsNothing);
      expect(
        find.text('Termine le monde 1 : ${repo.worlds[0].title} pour la débloquer'),
        findsOneWidget,
      );
    });

    testWidgets('repli : sans carte_mondeNN.png, l\'image du monde est affichée', (tester) async {
      final repo = await depotCharge(tester);
      terminerMonde(repo, 3);
      await monter(tester, repo);
      // Laisse la tentative de chargement du PNG absent échouer, puis le repli se charger.
      for (var i = 0; i < 5; i++) {
        await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
        await tester.pump();
      }

      final images = tester
          .widgetList<Image>(find.byType(Image))
          .map((i) => i.image)
          .whereType<AssetImage>()
          .map((a) => a.assetName)
          .toList();
      expect(images, contains('assets/images/pantheon/carte_monde03.png'));
      expect(images, contains('assets/images/mondes/monde3.webp'));
    });
  });
}
