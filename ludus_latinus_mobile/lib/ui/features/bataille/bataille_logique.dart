import 'dart:math';

import '../../../data/models/album.dart';
import '../../../data/models/thesaurus_entry.dart';

/// Règles de la Bataille des Légendes, sans interface (testables).
///
/// L'élève et Crassus ont chacun une main de 5 cartes. À chaque manche, l'élève
/// pose une carte, Crassus en pose une face cachée, puis une question de latin
/// décide qui choisit la caractéristique comparée : l'élève s'il répond juste,
/// Crassus sinon. Premier à 3 manches, 5 manches au plus.

/// Taille d'une main, et nombre de cartes à posséder pour ouvrir le jeu.
const int tailleMain = 5;
const int cartesPourJouer = 3;
const int manchesPourGagner = 3;

enum Caracteristique { attaque, defense }

int valeur(CarteAlbum carte, Caracteristique c) => c == Caracteristique.attaque ? carte.attaque : carte.defense;

/// Complète la main de l'élève avec des cartes « de prêt » tant qu'il n'en a pas
/// 5 : des cartes qu'il ne possède pas, communes d'abord, puis rares.
List<CarteAlbum> cartesDePret(List<CarteAlbum> possedees, List<CarteAlbum> toutes, Random alea) {
  final manque = tailleMain - possedees.length;
  if (manque <= 0) return const [];
  final ids = possedees.map((c) => c.id).toSet();
  final candidates = <CarteAlbum>[];
  for (final rarete in const ['commune', 'rare', 'epique', 'legendaire']) {
    final dispo = toutes.where((c) => c.rarete == rarete && !ids.contains(c.id)).toList()..shuffle(alea);
    candidates.addAll(dispo);
  }
  return candidates.take(manque).toList();
}

/// Main de Crassus : pour chaque carte de l'élève, une carte de même rareté
/// (prise hors de la main de l'élève quand c'est possible), pour une partie
/// équitable quel que soit l'avancement de l'album.
List<CarteAlbum> mainDeCrassus(List<CarteAlbum> mainJoueur, List<CarteAlbum> toutes, Random alea) {
  final prises = mainJoueur.map((c) => c.id).toSet();
  final main = <CarteAlbum>[];
  for (final carte in mainJoueur) {
    var choix = toutes.where((c) => c.rarete == carte.rarete && !prises.contains(c.id)).toList();
    if (choix.isEmpty) choix = toutes.where((c) => !prises.contains(c.id)).toList();
    if (choix.isEmpty) choix = List.of(toutes);
    final tiree = choix[alea.nextInt(choix.length)];
    prises.add(tiree.id);
    main.add(tiree);
  }
  return main;
}

/// Adversaires de la Bataille. Cléopâtre s'ouvre après 5 victoires contre Crassus.
enum Adversaire { crassus, cleopatre }

const List<String> _raretes = ['commune', 'rare', 'epique', 'legendaire'];

/// Main de Cléopâtre, plus difficile : pour chaque carte de l'élève, une carte
/// d'une rareté au-dessus quand il en reste, sinon de même rareté.
List<CarteAlbum> mainDeCleopatre(List<CarteAlbum> mainJoueur, List<CarteAlbum> toutes, Random alea) {
  final prises = mainJoueur.map((c) => c.id).toSet();
  final main = <CarteAlbum>[];
  for (final carte in mainJoueur) {
    final rang = _raretes.indexOf(carte.rarete);
    final visee = _raretes[(rang + 1).clamp(0, _raretes.length - 1)];
    var choix = toutes.where((c) => c.rarete == visee && !prises.contains(c.id)).toList();
    if (choix.isEmpty) choix = toutes.where((c) => c.rarete == carte.rarete && !prises.contains(c.id)).toList();
    if (choix.isEmpty) choix = toutes.where((c) => !prises.contains(c.id)).toList();
    if (choix.isEmpty) choix = List.of(toutes);
    final tiree = choix[alea.nextInt(choix.length)];
    prises.add(tiree.id);
    main.add(tiree);
  }
  return main;
}

/// Après une mauvaise réponse, Crassus choisit la caractéristique où son
/// avance est la plus grande (ou son retard le plus petit).
Caracteristique choixDeCrassus(CarteAlbum joueur, CarteAlbum crassus) {
  final ecartAttaque = crassus.attaque - joueur.attaque;
  final ecartDefense = crassus.defense - joueur.defense;
  return ecartDefense > ecartAttaque ? Caracteristique.defense : Caracteristique.attaque;
}

/// 1 : la carte de l'élève l'emporte ; -1 : celle de Crassus ; 0 : égalité.
int comparer(CarteAlbum joueur, CarteAlbum crassus, Caracteristique c) =>
    valeur(joueur, c).compareTo(valeur(crassus, c)).sign;

/// Question d'une manche : le latin à traduire (une devise de carte ou un mot du
/// vocabulaire), les quatre réponses proposées et la bonne. L'énoncé lui-même
/// est rédigé par l'écran, dans la langue de l'interface.
class QuestionBataille {
  final String latin;
  final bool estDevise;
  final List<String> reponses;
  final String bonne;
  const QuestionBataille(this.latin, this.estDevise, this.reponses, this.bonne);
}

/// Question de la manche : le plus souvent la devise de la carte posée (pour
/// apprendre ses cartes), sinon un mot du vocabulaire des mondes déjà vus.
QuestionBataille questionPour(
  CarteAlbum carte,
  List<CarteAlbum> toutes,
  List<ThesaurusEntry> vocabulaire,
  Random alea,
) {
  if (vocabulaire.length < 4 || alea.nextInt(100) < 60) {
    final autres = toutes.where((c) => c.id != carte.id && c.traduction != carte.traduction).toList()..shuffle(alea);
    final reponses = [carte.traduction, ...autres.take(3).map((c) => c.traduction)]..shuffle(alea);
    return QuestionBataille(carte.citation, true, reponses, carte.traduction);
  }
  final melange = List.of(vocabulaire)..shuffle(alea);
  final mot = melange.first;
  final autres = melange.skip(1).where((e) => e.fr != mot.fr).take(3).map((e) => e.fr);
  final reponses = [mot.fr, ...autres]..shuffle(alea);
  return QuestionBataille(mot.latin, false, reponses, mot.fr);
}

enum IssuePartie { enCours, victoire, defaite, egalite }

/// État d'une partie. Les cartes jouées quittent la main.
class PartieBataille {
  final List<CarteAlbum> mainJoueur;
  final List<CarteAlbum> mainCrassus;
  final Set<String> pretees;
  int pointsJoueur = 0;
  int pointsCrassus = 0;
  int manche = 0;

  PartieBataille({required this.mainJoueur, required this.mainCrassus, this.pretees = const {}});

  bool get finie =>
      pointsJoueur >= manchesPourGagner ||
      pointsCrassus >= manchesPourGagner ||
      mainJoueur.isEmpty ||
      mainCrassus.isEmpty;

  IssuePartie get issue {
    if (!finie) return IssuePartie.enCours;
    if (pointsJoueur > pointsCrassus) return IssuePartie.victoire;
    if (pointsCrassus > pointsJoueur) return IssuePartie.defaite;
    return IssuePartie.egalite;
  }

  /// Crassus pose une carte de sa main, au hasard.
  CarteAlbum carteDeCrassus(Random alea) => mainCrassus[alea.nextInt(mainCrassus.length)];

  /// Joue la manche : retire les deux cartes et compte le point.
  int jouer(CarteAlbum joueur, CarteAlbum crassus, Caracteristique c) {
    final resultat = comparer(joueur, crassus, c);
    mainJoueur.remove(joueur);
    mainCrassus.remove(crassus);
    manche++;
    if (resultat > 0) pointsJoueur++;
    if (resultat < 0) pointsCrassus++;
    return resultat;
  }
}
