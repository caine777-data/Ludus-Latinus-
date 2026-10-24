import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/thesaurus_entry.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/l10n/app_localizations.dart';
import 'package:ludus_latinus_mobile/ui/features/paires/paires_eclair.dart';
import 'package:ludus_latinus_mobile/ui/features/paires/paires_screen.dart';

void main() {
  late DataService data;
  late List<ThesaurusEntry> dico;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    data = DataService();
    await data.loadDataset();
    dico = data.thesaurus;
  });

  test('Au seul monde 1, la partie est jouable et ne pioche que ses mots', () {
    for (var graine = 0; graine < 20; graine++) {
      final p = PartiePaires.tirer(dictionnaire: dico, mondes: {'monde1'}, hasard: math.Random(graine));
      expect(p.estJouable, isTrue);
      expect(p.manches.length, PartiePaires.nbManches);
      for (final manche in p.manches) {
        expect(manche.length, PartiePaires.pairesParManche);
        expect(manche.toSet().length, PartiePaires.pairesParManche, reason: 'un mot deux fois dans une manche');
        expect(manche.every((e) => e.monde == 'monde1'), isTrue);
      }
    }
  });

  test('Sans monde atteint, pas de partie', () {
    expect(PartiePaires.tirer(dictionnaire: dico, mondes: const {}).estJouable, isFalse);
  });

  test('Relier juste fait avancer les manches jusqu\'à la victoire, une erreur est comptée', () {
    final p = PartiePaires.tirer(dictionnaire: dico, mondes: {'monde1', 'monde2'}, hasard: math.Random(3));
    // Erreur volontaire : le mot 0 relié à une autre traduction.
    final fausse = p.ordreFrancais.indexWhere((i) => i != 0);
    expect(p.relier(0, fausse), isFalse);
    expect(p.erreurs, 1);
    for (var m = 0; m < PartiePaires.nbManches; m++) {
      expect(p.manche, m);
      for (var i = 0; i < PartiePaires.pairesParManche; i++) {
        expect(p.relier(i, p.ordreFrancais.indexOf(i)), isTrue);
      }
    }
    expect(p.estGagnee, isTrue);
    expect(p.pairesTrouvees, PartiePaires.totalPaires);
  });

  testWidgets('L\'écran affiche la règle, puis cinq mots latins et le chrono', (tester) async {
    final repo = GameRepository(dataService: data, storageService: StorageService());
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: PairesScreen(repo: repo),
    ));
    await tester.pumpAndSettle();
    expect(find.text('COMMENCER'), findsOneWidget);
    await tester.tap(find.text('COMMENCER'));
    await tester.pump();
    expect(find.text('Manche 1 sur 3'), findsOneWidget);
    expect(find.text('60 s'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('59 s'), findsOneWidget);
    // On quitte l'écran : le chrono doit s'arrêter avec lui.
    await tester.pumpWidget(const SizedBox());
  });
}
