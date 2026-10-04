import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/ui/features/home/home_screen.dart';

/// Un élève a vu des textes « écrits à la verticale » sur l'accueil : une
/// colonne de texte écrasée par ses voisins jusqu'à n'avoir la place que d'une
/// ou deux lettres par ligne. Ce test affiche l'accueil sur des téléphones
/// étroits, avec une police agrandie, et signale tout texte de plus de quatre
/// lettres coincé dans moins de 48 points de large.
void main() {
  final cas = <(double, double)>[
    (320, 1.0),
    (360, 1.0),
    (360, 1.3),
    (412, 1.3),
    (360, 1.6),
  ];

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
      expect(ecrases, isEmpty, reason: ecrases.join('\n'));
    });
  }
}
