import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/ui/features/account/account_screen.dart';
import 'package:ludus_latinus_mobile/ui/features/boutique/boutique_modal.dart';
import 'package:ludus_latinus_mobile/ui/features/home/home_screen.dart';
import 'package:ludus_latinus_mobile/ui/features/map/map_screen.dart';
import 'package:ludus_latinus_mobile/ui/features/memoria/memoria_screen.dart';

/// Un élève a vu des textes « écrits à la verticale » sur l'accueil : une
/// colonne de texte écrasée par ses voisins jusqu'à n'avoir la place que d'une
/// ou deux lettres par ligne. Ce test affiche l'accueil et les autres écrans
/// sur des téléphones étroits, avec une police agrandie, et signale tout texte
/// de plus de quatre lettres coincé dans moins de 48 points de large.
void main() {
  final cas = <(double, double)>[
    (320, 1.0),
    (360, 1.0),
    (360, 1.3),
    (412, 1.3),
    (360, 1.6),
  ];

  List<String> trouverEcrases() {
    final ecrases = <String>[];
    for (final element in find.byType(RichText).evaluate()) {
      final boite = element.renderObject as RenderParagraph?;
      if (boite == null || !boite.hasSize) continue;
      final texte = boite.text.toPlainText().trim();
      final lettres = texte.replaceAll(RegExp(r'[^A-Za-zÀ-ÿ]'), '');
      if (lettres.length > 4 && boite.size.width < 48 && boite.size.height > boite.size.width) {
        ecrases.add('« $texte » : ${boite.size.width.toStringAsFixed(0)} x ${boite.size.height.toStringAsFixed(0)}');
      }
    }
    return ecrases;
  }

  // 1. Onglet Accueil (Cursus)
  group('Accueil', () {
    for (final (largeur, police) in cas) {
      testWidgets('Accueil : aucun texte écrasé ($largeur points, police x$police)', (tester) async {
        tester.view.physicalSize = Size(largeur * 3, 2400);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(tester.view.reset);
        final repo = GameRepository(dataService: DataService(), storageService: StorageService());
        await tester.pumpWidget(MediaQuery(
          data: MediaQueryData(size: Size(largeur, 800), textScaler: TextScaler.linear(police)),
          child: MaterialApp(home: HomeScreen(repo: repo)),
        ));
        await tester.pump(const Duration(milliseconds: 500));

        final ecrases = trouverEcrases();
        expect(ecrases, isEmpty, reason: ecrases.join('\n'));
      });
    }
  });

  // 2. Onglet Bibliotheca
  group('Bibliotheca', () {
    for (final (largeur, police) in cas) {
      testWidgets('Bibliotheca : aucun texte écrasé ($largeur points, police x$police)', (tester) async {
        tester.view.physicalSize = Size(largeur * 3, 2400);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(tester.view.reset);
        final repo = GameRepository(dataService: DataService(), storageService: StorageService());
        await tester.pumpWidget(MediaQuery(
          data: MediaQueryData(size: Size(largeur, 800), textScaler: TextScaler.linear(police)),
          child: MaterialApp(home: HomeScreen(repo: repo)),
        ));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.tap(find.text('Bibliotheca'), warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 500));

        final ecrases = trouverEcrases();
        expect(ecrases, isEmpty, reason: ecrases.join('\n'));
      });
    }
  });

  // 3. Onglet Ludi
  group('Ludi', () {
    for (final (largeur, police) in cas) {
      testWidgets(
        'Ludi : aucun texte écrasé ($largeur points, police x$police)',
        (tester) async {
          tester.view.physicalSize = Size(largeur * 3, 2400);
          tester.view.devicePixelRatio = 3.0;
          addTearDown(tester.view.reset);
          final repo = GameRepository(dataService: DataService(), storageService: StorageService());
          await tester.pumpWidget(MediaQuery(
            data: MediaQueryData(size: Size(largeur, 800), textScaler: TextScaler.linear(police)),
            child: MaterialApp(home: HomeScreen(repo: repo)),
          ));
          await tester.pump(const Duration(milliseconds: 500));
          await tester.tap(find.text('Ludi'), warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 500));

          final ecrases = trouverEcrases();
          expect(ecrases, isEmpty, reason: ecrases.join('\n'));
        },
      );
    }
  });

  // 4. Écran du compte (account_screen.dart)
  group('Compte', () {
    for (final (largeur, police) in cas) {
      testWidgets(
        'Compte : aucun texte écrasé ($largeur points, police x$police)',
        (tester) async {
          tester.view.physicalSize = Size(largeur * 3, 2400);
          tester.view.devicePixelRatio = 3.0;
          addTearDown(tester.view.reset);
          final repo = GameRepository(dataService: DataService(), storageService: StorageService());
          await tester.pumpWidget(MediaQuery(
            data: MediaQueryData(size: Size(largeur, 800), textScaler: TextScaler.linear(police)),
            child: MaterialApp(home: AccountScreen(repo: repo)),
          ));
          await tester.pump(const Duration(milliseconds: 500));

          final ecrases = trouverEcrases();
          expect(ecrases, isEmpty, reason: ecrases.join('\n'));
        },
      );
    }
  });

  // 5. La boutique (BoutiqueModal)
  group('Boutique', () {
    for (final (largeur, police) in cas) {
      testWidgets(
        'Boutique : aucun texte écrasé ($largeur points, police x$police)',
        (tester) async {
          tester.view.physicalSize = Size(largeur * 3, 2400);
          tester.view.devicePixelRatio = 3.0;
          addTearDown(tester.view.reset);
          final repo = GameRepository(dataService: DataService(), storageService: StorageService());
          await tester.pumpWidget(MediaQuery(
            data: MediaQueryData(size: Size(largeur, 800), textScaler: TextScaler.linear(police)),
            child: MaterialApp(home: Scaffold(body: BoutiqueModal(repo: repo))),
          ));
          await tester.pump(const Duration(milliseconds: 500));

          final ecrases = trouverEcrases();
          expect(ecrases, isEmpty, reason: ecrases.join('\n'));
        },
      );
    }
  });

  // 6. Memoria
  group('Memoria', () {
    for (final (largeur, police) in cas) {
      testWidgets('Memoria : aucun texte écrasé ($largeur points, police x$police)', (tester) async {
        tester.view.physicalSize = Size(largeur * 3, 2400);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(tester.view.reset);
        final repo = GameRepository(dataService: DataService(), storageService: StorageService());
        await tester.pumpWidget(MediaQuery(
          data: MediaQueryData(size: Size(largeur, 800), textScaler: TextScaler.linear(police)),
          child: MaterialApp(home: MemoriaScreen(repo: repo)),
        ));
        await tester.pump(const Duration(milliseconds: 500));

        final ecrases = trouverEcrases();
        expect(ecrases, isEmpty, reason: ecrases.join('\n'));
      });
    }
  });

  // 7. La carte de la Via Appia (map_screen.dart)
  group('Via Appia', () {
    for (final (largeur, police) in cas) {
      testWidgets(
        'Via Appia : aucun texte écrasé ($largeur points, police x$police)',
        (tester) async {
          tester.view.physicalSize = Size(largeur * 3, 2400);
          tester.view.devicePixelRatio = 3.0;
          addTearDown(tester.view.reset);
          final repo = GameRepository(dataService: DataService(), storageService: StorageService());
          await tester.pumpWidget(MediaQuery(
            data: MediaQueryData(size: Size(largeur, 800), textScaler: TextScaler.linear(police)),
            child: MaterialApp(home: MapScreen(repo: repo)),
          ));
          await tester.pump(const Duration(milliseconds: 500));

          final ecrases = trouverEcrases();
          expect(ecrases, isEmpty, reason: ecrases.join('\n'));
        },
      );
    }
  });
}
