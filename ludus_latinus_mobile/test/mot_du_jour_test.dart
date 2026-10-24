import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/mot_du_jour.dart';
import 'package:ludus_latinus_mobile/data/models/profile.dart';
import 'package:ludus_latinus_mobile/data/models/thesaurus_entry.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/l10n/app_localizations.dart';
import 'package:ludus_latinus_mobile/ui/features/mot_du_jour/mot_du_jour_screen.dart';

/// Stockage en mémoire : les tests n'écrivent pas de fichier de sauvegarde.
class _StockageMemoire extends StorageService {
  @override
  Future<void> saveProfile(UserProfile profile) async {}
}

void main() {
  late DataService data;
  late List<ThesaurusEntry> dico;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    data = DataService();
    await data.loadDataset();
    dico = data.thesaurus;
  });

  const b = EtatLettre.bienPlacee;
  const m = EtatLettre.malPlacee;
  const a = EtatLettre.absente;

  test('Couleurs : bien placée, mal placée, absente', () {
    expect(MotDuJour.evaluer('AMICUS', 'AMICUS'), [b, b, b, b, b, b]);
    expect(MotDuJour.evaluer('CAMISU', 'AMICUS'), [m, m, m, m, m, m]);
    expect(MotDuJour.evaluer('AMICIS', 'AMICUS'), [b, b, b, b, a, b]);
    expect(MotDuJour.evaluer('SOCIUS', 'AMICUS'), [a, a, m, m, b, b]);
  });

  test('Lettre en double : pas plus de jaunes que la cible n\'en contient', () {
    // AMARE contre AMICUS : un seul A dans la cible, déjà bien placé.
    expect(MotDuJour.evaluer('AMARE', 'AMICUS').sublist(0, 5), [b, b, a, a, a]);
    // ESSE contre SERO : le premier S est mal placé, le second absent.
    expect(MotDuJour.evaluer('ESSE', 'SERO'), [m, m, a, a]);
  });

  test('Mots jouables : 4 à 6 lettres simples, mondes atteints seulement', () {
    final mots = MotDuJour.candidats(dico, {'monde1', 'monde2'});
    expect(mots, isNotEmpty);
    for (final e in mots) {
      expect(MotDuJour.forme(e), matches(RegExp(r'^[A-Z]{4,6}$')));
      expect({'monde1', 'monde2'}, contains(e.monde));
    }
    expect(MotDuJour.candidats(dico, {'monde1'}), isNotEmpty, reason: 'jouable dès le premier monde');
  });

  test('Le choix évite les mots déjà vus tant qu\'il en reste', () {
    final mots = MotDuJour.candidats(dico, {'monde1', 'monde2'});
    final vus = [for (final e in mots.skip(1)) MotDuJour.forme(e)];
    final choix = MotDuJour.choisir(mots, DateTime(2026, 10, 24), vus)!;
    expect(MotDuJour.forme(choix), MotDuJour.forme(mots.first));
  });

  test('L\'indice ne donne pas la réponse et écarte les dérivés déplacés', () {
    final lupa = dico.firstWhere((e) => MotDuJour.forme(e) == 'LUPA');
    expect(MotDuJour.indice(lupa).toLowerCase(), isNot(contains('lupanar')));
    final atrium = dico.firstWhere((e) => MotDuJour.forme(e) == 'ATRIUM');
    expect(MotDuJour.indice(atrium).toLowerCase(), isNot('atrium'));
  });

  test('Le mot du jour reste le même dans la journée, et se paie une fois', () {
    final repo = GameRepository(dataService: data, storageService: _StockageMemoire());
    repo.profile.sesterces = 0;
    final mot = repo.motDuJour()!;
    // Une leçon faite entre deux essais ne change pas le mot.
    repo.profile.completedLessons.add(data.worlds[1].lessons.first.id);
    expect(MotDuJour.forme(repo.motDuJour()!), MotDuJour.forme(mot));
    expect(repo.proposerMotDuJour('XXXX'), 0);
    expect(repo.proposerMotDuJour(MotDuJour.forme(mot)), GameRepository.gainMotDuJour);
    expect(repo.motDuJourTermine, isTrue);
    expect(repo.proposerMotDuJour(MotDuJour.forme(mot)), 0);
    expect(repo.profile.sesterces, GameRepository.gainMotDuJour);
  });

  testWidgets('Taper un mot au clavier puis valider remplit une rangée', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    final repo = GameRepository(dataService: data, storageService: _StockageMemoire());
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MotDuJourScreen(repo: repo),
    ));
    await tester.pumpAndSettle();
    final cible = repo.profile.motDuJour!;
    // Valider trop tôt affiche une alerte au lieu de compter l'essai.
    await tester.tap(find.text('VALIDER'));
    await tester.pump();
    expect(find.text('Le mot a ${cible.length} lettres.'), findsOneWidget);
    for (final l in ('Z' * cible.length).split('')) {
      await tester.tap(find.text(l).last);
    }
    await tester.tap(find.text('VALIDER'));
    await tester.pump();
    expect(repo.profile.motDuJourEssais, ['Z' * cible.length]);
  });
}
