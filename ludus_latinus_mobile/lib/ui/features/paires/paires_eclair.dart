import 'dart:math' as math;

import '../../../data/models/thesaurus_entry.dart';
import '../../../data/models/vocab_question.dart';

/// Paires éclair : relier des mots latins à leur traduction contre la montre.
///
/// Trois manches de cinq paires, une minute en tout, une erreur coûte trois
/// secondes. Les mots viennent des mondes que l'élève a déjà atteints : le jeu
/// fait réviser, il n'apprend pas de mot nouveau. Logique séparée de l'écran
/// pour être testée.
class PartiePaires {
  static const int pairesParManche = 5;
  static const int nbManches = 3;
  static const int dureeSecondes = 60;
  static const int penaliteSecondes = 3;
  static const int totalPaires = pairesParManche * nbManches;

  /// Mots de chaque manche ; la traduction de `manches[m][i]` est l'entrée i.
  final List<List<ThesaurusEntry>> manches;

  /// Ordre d'affichage des traductions de la manche en cours (indices dans la manche).
  List<int> ordreFrancais = [];

  /// Indices (dans la manche) des paires déjà trouvées.
  final Set<int> trouvees = {};

  /// Mots latins sur lesquels l'élève s'est trompé : le rappel de fin de
  /// partie les montre en premier, pour qu'il les révise.
  final Set<ThesaurusEntry> ratees = {};

  /// Mots reliés juste au moins une fois.
  final Set<ThesaurusEntry> reussies = {};

  final math.Random _hasard;
  int manche = 0;
  int erreurs = 0;
  int pairesTrouvees = 0;

  PartiePaires._(this.manches, this._hasard) {
    if (manches.isNotEmpty) _melanger();
  }

  /// Tire une partie parmi les mots des [mondes] atteints. La partie est vide
  /// (`estJouable` faux) s'il y a moins de cinq mots distincts.
  factory PartiePaires.tirer({
    required List<ThesaurusEntry> dictionnaire,
    required Set<String> mondes,
    math.Random? hasard,
  }) {
    final rnd = hasard ?? math.Random();
    // Un seul mot par forme latine et par traduction : deux mots traduits
    // « grand » dans la même manche rendraient la paire ambiguë.
    final latinsVus = <String>{};
    final francaisVus = <String>{};
    final pool = <ThesaurusEntry>[
      for (final e in dictionnaire)
        if (e.cat != 'Devise' &&
            mondes.contains(e.monde) &&
            latinsVus.add(VocabQuestion.shortLatin(e).toLowerCase()) &&
            francaisVus.add(VocabQuestion.shortFrench(e).toLowerCase()))
          e,
    ];
    if (pool.length < pairesParManche) return PartiePaires._(const [], rnd);

    // On parcourt le paquet mélangé ; au monde 1 (9 mots), les mots
    // reviennent d'une manche à l'autre, jamais deux fois dans la même.
    final manches = <List<ThesaurusEntry>>[];
    var paquet = <ThesaurusEntry>[];
    for (var m = 0; m < nbManches; m++) {
      final manche = <ThesaurusEntry>[];
      var tirages = 0;
      while (manche.length < pairesParManche) {
        if (paquet.isEmpty) paquet = [...pool]..shuffle(rnd);
        final e = paquet.removeLast();
        tirages++;
        if (manche.contains(e)) continue;
        // Pas deux traductions qui se recoupent dans une manche (« la famille /
        // maisonnée » et « la maison / la maisonnée ») : l'élève hésiterait
        // sans que ce soit sa faute. Si le paquet est trop petit pour l'éviter
        // après deux tours, on l'accepte plutôt que de tourner sans fin.
        final tolere = tirages > pool.length * 2;
        if (!tolere && manche.any((d) => seRecoupent(d, e))) continue;
        manche.add(e);
      }
      manches.add(manche);
    }
    return PartiePaires._(manches, rnd);
  }

  /// Petits mots ignorés quand on compare deux traductions.
  static const _motsVides = {
    'le', 'la', 'les', 'l', 'un', 'une', 'des', 'de', 'du', 'd', 'et', 'ou', 'se', 's', 'en', 'à', 'au', 'aux',
  };

  /// Mots pleins d'une traduction : « la maison / la maisonnée » → {maison, maisonnée}.
  static Set<String> motsDuSens(ThesaurusEntry e) => VocabQuestion.shortFrench(e)
      .toLowerCase()
      .split(RegExp(r"[^a-zà-ÿœæ]+"))
      .where((m) => m.isNotEmpty && !_motsVides.contains(m))
      .toSet();

  /// Vrai si les deux traductions partagent un mot plein.
  static bool seRecoupent(ThesaurusEntry a, ThesaurusEntry b) =>
      motsDuSens(a).intersection(motsDuSens(b)).isNotEmpty;

  bool get estJouable => manches.isNotEmpty;
  bool get estGagnee => estJouable && manche >= nbManches;
  List<ThesaurusEntry> get mots => manches[manche.clamp(0, nbManches - 1)];

  /// Mots joués jusqu'ici (manches commencées), les ratés d'abord, sans doublon.
  List<ThesaurusEntry> get motsAReviser {
    final joues = {for (final m in manches.take((manche + 1).clamp(0, nbManches))) ...m};
    return [...ratees, ...joues.where((e) => !ratees.contains(e))];
  }

  String latin(int i) => VocabQuestion.shortLatin(mots[i]);
  String francais(int i) => VocabQuestion.shortFrench(mots[i]);

  void _melanger() {
    ordreFrancais = List.generate(pairesParManche, (i) => i)..shuffle(_hasard);
  }

  /// L'élève relie le mot latin [iLatin] à la traduction affichée en position
  /// [positionFrancais]. Renvoie vrai si la paire est juste ; quand la manche
  /// est complète, la suivante est préparée.
  bool relier(int iLatin, int positionFrancais) {
    final iFrancais = ordreFrancais[positionFrancais];
    if (iLatin != iFrancais) {
      erreurs++;
      ratees.add(mots[iLatin]);
      return false;
    }
    trouvees.add(iLatin);
    reussies.add(mots[iLatin]);
    pairesTrouvees++;
    if (trouvees.length == pairesParManche) {
      manche++;
      trouvees.clear();
      if (manche < nbManches) _melanger();
    }
    return true;
  }
}
