import 'package:flutter/foundation.dart';
import '../models/album.dart';
import '../models/daily_quest.dart';
import '../models/goodie_item.dart';
import '../models/carte_pantheon.dart';
import '../models/monument.dart';
import '../models/profile.dart';
import '../models/srs_card.dart';
import '../models/thesaurus_entry.dart';
import '../models/world.dart';
import '../services/data_service.dart';
import '../services/rappel_service.dart';
import '../services/storage_service.dart';

/// Résultat de la validation d'une leçon, pour doser la célébration.
class LessonResult {
  final int stars;
  final int bestStars;
  final int sestercesGained;
  final bool firstTime;
  /// Vrai si ce passage bat le meilleur nombre d'étoiles précédent.
  final bool improved;
  final bool worldCompleted;
  final String? worldTitle;
  /// Carte du Panthéon gagnée avec ce monde terminé, s'il y en a une.
  final CartePantheon? carteGagnee;

  const LessonResult({
    required this.stars,
    required this.bestStars,
    required this.sestercesGained,
    required this.firstTime,
    this.improved = false,
    required this.worldCompleted,
    this.worldTitle,
    this.carteGagnee,
  });
}

/// Repository principal qui expose l'état du jeu et de la progression à toute l'UI.
class GameRepository extends ChangeNotifier {
  final DataService dataService;
  final StorageService storageService;

  /// Rappels quotidiens (Android). Absent dans les tests.
  final RappelService? rappels;

  GameRepository({
    required this.dataService,
    required this.storageService,
    this.rappels,
  });

  // ------------------------------------------------------------------
  // Objectif du jour et rappel quotidien
  // ------------------------------------------------------------------

  /// Récompense de l'objectif du jour atteint.
  static const int gainObjectif = 5;

  /// Vrai quand l'objectif vient d'être atteint : l'accueil le fête une fois.
  bool objectifAAnnoncer = false;

  int get activitesDuJour => profile.activitesDuJour();
  bool get objectifAtteint => profile.objectifAtteintAujourdhui();

  /// Après une leçon ou une révision : objectif payé une fois par jour, et
  /// rappels reprogrammés (celui d'aujourd'hui saute si l'objectif est atteint).
  void _apresActivite() {
    if (profile.validerObjectif()) {
      profile.sesterces += gainObjectif;
      objectifAAnnoncer = true;
    }
    replanifierRappels();
  }

  void changerObjectif(int activites) {
    profile.objectifJour = activites.clamp(1, 3);
    // Un objectif abaissé peut déjà être atteint aujourd'hui.
    _apresActivite();
    storageService.saveProfile(profile);
    notifyListeners();
  }

  void reglerRappel({bool? actif, int? minutes}) {
    if (actif != null) profile.rappelActif = actif;
    if (minutes != null) profile.rappelMinutes = minutes;
    profile.rappelPropose = true;
    storageService.saveProfile(profile);
    replanifierRappels();
    notifyListeners();
  }

  /// La proposition du rappel, après la première leçon, n'est faite qu'une fois.
  void marquerRappelPropose() {
    profile.rappelPropose = true;
    storageService.saveProfile(profile);
    notifyListeners();
  }

  Future<void> replanifierRappels() async {
    await rappels?.planifier(
      actif: profile.rappelActif,
      minutes: profile.rappelMinutes,
      nom: profile.nomHeros,
      serie: profile.currentStreak(),
      joueAujourdhui: profile.aJoueAujourdhui(),
      faitAujourdhui: profile.objectifAtteintAujourdhui(),
    );
  }

  bool get isReady => dataService.isLoaded;

  UserProfile get profile => storageService.profile;
  List<SchoolClass> get classes => dataService.classes;
  List<World> get worlds => dataService.worlds;
  List<ThesaurusEntry> get thesaurus => dataService.thesaurus;
  List<List<String>> get glossaire => dataService.glossaire;
  List<ForumMonument> get monuments => dataService.monuments;
  List<SrsCard> get srsCards => dataService.srsCards;

  /// Cartes de Memoria : les mots du Thesaurus des mondes où l'élève a validé
  /// au moins une leçon. On ne révise que ce qu'on a rencontré ; avant, les
  /// 29 cartes arrivaient toutes d'un coup, mots de 4e compris, dès le départ.
  List<SrsCard> get memoriaCards {
    final mondesVus = {
      for (final w in worlds)
        if (w.lessons.any((l) => isLessonCompleted(l.id))) w.id,
    };
    final vus = <String>{};
    return [
      for (final e in thesaurus)
        if (e.monde.isNotEmpty && mondesVus.contains(e.monde) && vus.add(e.latin))
          SrsCard(
            id: 'th:${e.latin}',
            latin: e.latin,
            genre: e.genre,
            francais: e.fr,
            etymologie: e.etym,
            exemple: e.ex,
            exempleFr: e.exFr,
            categorie: e.cat,
            monde: e.monde,
          ),
    ];
  }

  /// Mondes où l'élève a validé au moins une leçon. Le premier monde compte
  /// toujours : on y entre dès le premier lancement.
  Set<String> get mondesAtteints => {
        if (worlds.isNotEmpty) worlds.first.id,
        for (final w in worlds)
          if (w.lessons.any((l) => isLessonCompleted(l.id))) w.id,
      };

  /// Rang (1 pour le monde 1) du monde le plus avancé parmi [mondesAtteints].
  int get rangMondeAtteint {
    var rang = 1;
    for (var i = 0; i < worlds.length; i++) {
      if (worlds[i].lessons.any((l) => isLessonCompleted(l.id))) rang = i + 1;
    }
    return rang;
  }

  /// Un monde est terminé quand toutes ses leçons sont validées.
  bool isWorldCompleted(World world) =>
      world.lessons.isNotEmpty && world.lessons.every((l) => isLessonCompleted(l.id));

  /// Identifiants des mondes terminés.
  Set<String> get mondesTermines => {
        for (final w in worlds)
          if (isWorldCompleted(w)) w.id,
      };

  List<CartePantheon> get cartesPantheon => dataService.cartesPantheon;

  // ------------------------------------------------------------------
  // Album « Héros et Créatures » : une carte par succès.
  // ------------------------------------------------------------------

  List<CarteAlbum> get cartesAlbum => dataService.cartesAlbum;
  List<SuccesAlbum> get succesAlbum => dataService.succesAlbum;

  CarteAlbum? carteAlbum(String id) {
    for (final c in cartesAlbum) {
      if (c.id == id) return c;
    }
    return null;
  }

  SuccesAlbum? succesDeLaCarte(String carteId) {
    for (final s in succesAlbum) {
      if (s.carteId == carteId) return s;
    }
    return null;
  }

  bool aLaCarte(String carteId) => profile.cartesAlbum.contains(carteId);

  /// Récompense en sesterces d'une carte, selon sa rareté.
  int sesterceDeLaCarte(CarteAlbum carte) => dataService.sesterceParRarete[carte.rarete] ?? 0;

  /// Cartes obtenues depuis la dernière annonce, à montrer à l'élève au
  /// retour à l'accueil (jamais en pleine partie).
  final List<CarteAlbum> cartesAAnnoncer = [];

  /// Valeur actuelle d'une statistique de succès (voir content/album_mobile.py).
  int valeurStat(String stat) {
    final p = profile;
    if (stat.startsWith('monde_termine:')) {
      final rang = int.tryParse(stat.split(':').last) ?? 0;
      if (rang < 1 || rang > worlds.length) return 0;
      return isWorldCompleted(worlds[rang - 1]) ? 1 : 0;
    }
    if (stat.startsWith('classe_terminee:')) {
      final id = stat.split(':').last;
      for (final c in classes) {
        if (c.id != id) continue;
        final mondes = worlds.where((w) => c.mondesIds.contains(w.id));
        return mondes.isNotEmpty && mondes.every(isWorldCompleted) ? 1 : 0;
      }
      return 0;
    }
    switch (stat) {
      case 'lecons_reussies':
        return p.completedLessons.length;
      case 'lecons_trois_etoiles':
        return p.lessonStars.values.where((e) => e >= 3).length;
      case 'mondes_termines':
        return mondesTermines.length;
      case 'serie_jours':
        return p.streakDays;
      case 'gladiateurs_vaincus':
        return p.gladiateursVaincus.length;
      case 'memoria_maitrises':
        return p.srsCards.values.where((c) => c.box >= 5).length;
      case 'missions_cesar':
        return p.missionsCesar.length;
      case 'epigraphes':
        return p.decodedEpigraphs.length;
      case 'monuments_restaures':
        return p.restoredMonuments.length;
    }
    // Les autres statistiques sont des compteurs d'événements des jeux.
    return p.compteurs[stat] ?? 0;
  }

  /// Ajoute 1 au compteur d'un événement de jeu (« duels_gagnes »…).
  void noterEvenement(String compteur) {
    profile.compteurs[compteur] = (profile.compteurs[compteur] ?? 0) + 1;
    storageService.saveProfile(profile);
    notifyListeners();
  }

  /// Un gladiateur du Duel vaincu : victoire, gladiateur retenu, combat parfait.
  void noterVictoireDuel(String gladiateur, {required bool sansFaute}) {
    profile.compteurs['duels_gagnes'] = (profile.compteurs['duels_gagnes'] ?? 0) + 1;
    if (sansFaute) profile.compteurs['duels_sans_faute'] = (profile.compteurs['duels_sans_faute'] ?? 0) + 1;
    if (!profile.gladiateursVaincus.contains(gladiateur)) profile.gladiateursVaincus.add(gladiateur);
    storageService.saveProfile(profile);
    notifyListeners();
  }

  /// Fin d'une partie de la Bataille des Légendes : victoire payée comme une
  /// partie d'arcade (3 par jour), série de victoires et record. Renvoie le gain.
  int noterBataille({required bool victoire}) {
    var gain = 0;
    if (victoire) {
      profile.compteurs['bataille_victoires'] = (profile.compteurs['bataille_victoires'] ?? 0) + 1;
      final serie = (profile.compteurs['bataille_serie'] ?? 0) + 1;
      profile.compteurs['bataille_serie'] = serie;
      if (serie > record('bataille')) profile.records['bataille'] = serie;
      gain = payerPartie('bataille', gainBataille);
    } else {
      profile.compteurs['bataille_serie'] = 0;
    }
    // payerPartie n'enregistre rien quand le quota du jour est atteint.
    storageService.saveProfile(profile);
    notifyListeners();
    return gain;
  }

  /// Vocabulaire des mondes déjà atteints, pour les questions des jeux.
  List<ThesaurusEntry> get vocabulaireAtteint {
    final atteints = mondesAtteints;
    final mots = thesaurus.where((e) => atteints.contains(e.monde)).toList();
    return mots.length >= 4 ? mots : thesaurus;
  }

  /// Donne les cartes dont le succès vient d'être atteint. Appelé à chaque
  /// changement de progression (voir [notifyListeners]) : aucun écran n'a à y
  /// penser. Renvoie les cartes nouvellement obtenues.
  List<CarteAlbum> verifierSucces() {
    if (!dataService.isLoaded) return const [];
    final nouvelles = <CarteAlbum>[];
    for (final s in succesAlbum) {
      if (profile.cartesAlbum.contains(s.carteId)) continue;
      if (valeurStat(s.stat) < s.seuil) continue;
      final carte = carteAlbum(s.carteId);
      if (carte == null) continue;
      profile.cartesAlbum.add(carte.id);
      profile.sesterces += sesterceDeLaCarte(carte);
      nouvelles.add(carte);
    }
    if (nouvelles.isNotEmpty) {
      storageService.saveProfile(profile);
      cartesAAnnoncer.addAll(nouvelles);
    }
    return nouvelles;
  }

  /// Toute mutation du profil passe par ici : on vérifie les succès avant de
  /// prévenir les écrans, qui affichent donc déjà la carte et ses sesterces.
  @override
  void notifyListeners() {
    verifierSucces();
    super.notifyListeners();
  }

  /// Carte du Panthéon rattachée à un monde (null si le monde n'en a pas).
  CartePantheon? carteDuMonde(String worldId) {
    for (final c in cartesPantheon) {
      if (c.mondeId == worldId) return c;
    }
    return null;
  }

  /// Une carte est gagnée quand son monde est terminé.
  bool isCarteGagnee(CartePantheon carte) => mondesTermines.contains(carte.mondeId);

  /// Classe (5eme, 4eme, 3eme) d'un monde de la Via Appia.
  String? classeDuMonde(String mondeId) {
    for (final c in classes) {
      if (c.mondesIds.contains(mondeId)) return c.id;
    }
    return null;
  }

  /// Gain d'une bonne réponse dans Memoria, sur une carte qui était à réviser.
  /// Volontairement modeste : Memoria sert à retenir, pas à s'enrichir.
  static const int gainMemoria = 2;

  Future<void> initialize() async {
    await dataService.loadDataset();
    await storageService.init();
    // Les rappels se recalent à chaque ouverture (série, prénom, heure).
    replanifierRappels();
    notifyListeners();
  }

  /// Sesterces gagnés à la première réussite d'une leçon, selon les étoiles.
  static int rewardForStars(int stars) => const {3: 10, 2: 7, 1: 4}[stars.clamp(1, 3)]!;

  int starsForLesson(String lessonId) => profile.lessonStars[lessonId] ?? 0;

  /// Valide une leçon. Les sesterces ne sont versés qu'à la première réussite,
  /// les étoiles gardent le meilleur résultat.
  LessonResult completeLesson(String lessonId, int stars) {
    stars = stars.clamp(1, 3);
    final firstTime = !isLessonCompleted(lessonId);
    final previousStars = starsForLesson(lessonId);

    int gain = 0;
    if (firstTime) {
      final base = rewardForStars(stars);
      // Bonus Temple de Saturne (+20%)
      final bonus = isMonumentRestored('templum_saturni') ? 0.20 : 0.0;
      gain = base + (base * bonus).round();
      storageService.addCompletedLesson(lessonId);
      storageService.addSesterces(gain);
    }
    if (stars > previousStars) {
      profile.lessonStars[lessonId] = stars;
    }
    profile.recordActivity();
    profile.noterLeconDuJour();
    _apresActivite();
    storageService.saveProfile(profile);

    World? world;
    for (final w in worlds) {
      if (w.lessons.any((l) => l.id == lessonId)) {
        world = w;
        break;
      }
    }
    final worldCompleted = firstTime && world != null && isWorldCompleted(world);

    notifyListeners();
    return LessonResult(
      stars: stars,
      bestStars: stars > previousStars ? stars : previousStars,
      sestercesGained: gain,
      firstTime: firstTime,
      improved: !firstTime && stars > previousStars,
      worldCompleted: worldCompleted,
      worldTitle: world?.title,
      carteGagnee: worldCompleted ? carteDuMonde(world.id) : null,
    );
  }

  void addSesterces(int amount) {
    storageService.addSesterces(amount);
    notifyListeners();
  }

  bool isLessonCompleted(String lessonId) {
    return profile.completedLessons.contains(lessonId);
  }

  bool isMonumentRestored(String monumentId) {
    return profile.restoredMonuments.contains(monumentId);
  }

  bool restoreMonument(String monumentId, int cost) {
    bool ok = storageService.unlockMonument(monumentId, cost);
    if (ok) notifyListeners();
    return ok;
  }

  SrsCardProgress getSrsProgress(String cardId) {
    return profile.getCardProgress(cardId);
  }

  void recordSrsReview(String cardId, {required bool success}) {
    profile.updateCardSrs(cardId, success: success);
    profile.recordActivity();
    profile.noterRevisionDuJour();
    _apresActivite();
    storageService.saveProfile(profile);
    notifyListeners();
  }

  void updateProfileName(String newName, String genre) {
    profile.nomHeros = newName;
    profile.genre = genre;
    storageService.saveProfile(profile);
    notifyListeners();
  }

  /// Prénom le plus long accepté : il doit tenir sur la carte du héros.
  static const int longueurMaxPrenom = 18;

  /// Choix du héros au premier lancement : il ne sera plus redemandé.
  void chooseHero(String prenom, String genre) {
    profile.heroChoisi = true;
    updateProfileName(prenom, genre);
  }

  /// Contenu du fichier de sauvegarde (progression de l'élève, JSON enveloppé).
  String exportSauvegarde() => storageService.exportProfileJson();

  /// Vrai si le contenu est une sauvegarde lisible : vérifié avant de demander
  /// à l'élève de confirmer le remplacement.
  bool estSauvegardeValide(String contenu) => StorageService.lireSauvegarde(contenu) != null;

  /// Remplace la progression par celle d'un fichier de sauvegarde. Retourne
  /// false, sans rien changer, si le contenu n'est pas une sauvegarde valide.
  /// On prévient les écouteurs : les écrans lisent `profile` à chaque rebuild,
  /// ils doivent donc se redessiner avec le profil importé.
  bool importerSauvegarde(String contenu) {
    final ok = storageService.importProfileJson(contenu);
    if (ok) notifyListeners();
    return ok;
  }

  bool isDailyQuestCompletedToday() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return profile.lastDailyQuestDate == today;
  }

  /// Défi du jour, choisi parmi les jeux déjà ouverts : on ne promet pas un jeu verrouillé.
  DailyQuest get defiDuJour => DailyQuest.getTodayQuest(
        null,
        (q) => profile.getUnlockStatusForGame(q.routeCible == 'colosseum' ? 'duel' : q.routeCible).isUnlocked,
      );

  /// À appeler quand l'élève réussit quelque chose dans un jeu. Si c'est le jeu
  /// du défi du jour, le défi est payé. Renvoie la prime versée (0 sinon).
  /// Avant, la prime tombait dès qu'on touchait le bouton, sans jouer.
  int accomplirDefi(String jeu) {
    if (isDailyQuestCompletedToday()) return 0;
    final defi = defiDuJour;
    if (defi.routeCible != jeu) return 0;
    profile.lastDailyQuestDate = DateTime.now().toIso8601String().substring(0, 10);
    profile.compteurs['quetes_du_jour'] = (profile.compteurs['quetes_du_jour'] ?? 0) + 1;
    storageService.addSesterces(defi.recompense);
    storageService.saveProfile(profile);
    notifyListeners();
    return defi.recompense;
  }

  void markIntroSeen() {
    if (profile.introSeen) return;
    profile.introSeen = true;
    storageService.saveProfile(profile);
  }

  /// Niveau (5e, 4e, 3e) dans lequel l'élève entre en ouvrant cette leçon,
  /// ou `null` s'il y est déjà entré. La vidéo d'entrée d'un niveau ne se
  /// joue qu'une fois : le niveau est marqué comme vu dès cet appel.
  ///
  /// Un élève qui a déjà validé une leçon du niveau (profil antérieur à ces
  /// vidéos) y est considéré comme entré : on ne lui impose pas la vidéo.
  SchoolClass? enterLevelOf(String lessonId) {
    World? world;
    for (final w in worlds) {
      if (w.lessons.any((l) => l.id == lessonId)) {
        world = w;
        break;
      }
    }
    if (world == null) return null;
    SchoolClass? niveau;
    for (final c in classes) {
      if (c.mondesIds.contains(world.id)) {
        niveau = c;
        break;
      }
    }
    if (niveau == null || profile.niveauxVus.contains(niveau.id)) return null;

    final dejaEntre = worlds
        .where((w) => niveau!.mondesIds.contains(w.id))
        .any((w) => w.lessons.any((l) => isLessonCompleted(l.id)));
    profile.niveauxVus.add(niveau.id);
    storageService.saveProfile(profile);
    return dejaEntre ? null : niveau;
  }

  int get taverneRewardsLeftToday => profile.taverneRewardsLeftToday;

  /// Réserve un lancer récompensé de la Taverne (3 par jour). Renvoie false si épuisé.
  bool consumeTaverneReward() {
    final ok = profile.consumeTaverneReward();
    storageService.saveProfile(profile);
    notifyListeners();
    return ok;
  }

  /// Barème des jeux d'arcade : une partie gagnée vaut à peu près une leçon (10 HS).
  static const int gainCircus = 12;
  static const int gainBataille = 12;
  static const int gainDuel = 15;
  static const int gainMissionCesar = 10;
  static const int gainMarcheEtal = 5;
  static const int gainMarcheRendu = 5;
  static const int gainMarcheNegociation = 10;

  int recompensesRestantes(String jeu) => profile.recompensesRestantes(jeu);

  /// Meilleur résultat de l'élève à ce jeu (0 s'il n'y a pas encore joué).
  int record(String jeu) => profile.records[jeu] ?? 0;

  /// Retient [valeur] si elle bat le record du jeu. Vrai si c'est un nouveau record.
  bool enregistrerRecord(String jeu, int valeur) {
    if (valeur <= record(jeu)) return false;
    profile.records[jeu] = valeur;
    storageService.saveProfile(profile);
    notifyListeners();
    return true;
  }

  /// Paie une partie gagnée d'un jeu d'arcade, dans la limite du jour.
  /// Renvoie le montant réellement versé (0 si le quota est atteint).
  /// Le défi du jour compte même quand le quota est atteint.
  int payerPartie(String jeu, int montant) {
    final prime = accomplirDefi(jeu);
    if (!profile.prendreRecompense(jeu)) return prime;
    storageService.addSesterces(montant);
    storageService.saveProfile(profile);
    notifyListeners();
    return montant + prime;
  }

  bool estDejaPaye(String cle) => profile.recompensesUniques.contains(cle);

  /// Exercice payé une seule fois, même après redémarrage (étals du Marché…).
  /// Renvoie le montant versé, 0 s'il l'avait déjà été.
  int payerUneFois(String cle, int montant) {
    if (estDejaPaye(cle)) return 0;
    profile.recompensesUniques.add(cle);
    storageService.addSesterces(montant);
    storageService.saveProfile(profile);
    notifyListeners();
    return montant;
  }

  bool isMissionCesarReussie(int index) => profile.missionsCesar.contains(index);

  /// Mission de César réussie : payée une seule fois, même après redémarrage.
  int validerMissionCesar(int index, int gain, {int total = 0}) {
    if (isMissionCesarReussie(index)) return 0;
    profile.missionsCesar.add(index);
    // Toutes les missions réussies : succès du Sceau impérial.
    if (total > 0 && profile.missionsCesar.length >= total) profile.compteurs['missions_cesar_toutes'] = 1;
    storageService.addSesterces(gain);
    storageService.saveProfile(profile);
    notifyListeners();
    return gain + accomplirDefi('cesar');
  }

  bool isEpigraphDecoded(String monumentId) {
    return profile.decodedEpigraphs.contains(monumentId);
  }

  void decodeEpigraph(String monumentId, int reward) {
    if (isEpigraphDecoded(monumentId)) return;
    profile.decodedEpigraphs.add(monumentId);
    storageService.addSesterces(reward);
    storageService.saveProfile(profile);
    notifyListeners();
  }

  /// Le mode sombre est masqué tant que les écrans n'utilisent pas les
  /// couleurs du thème (textes invisibles, cartes restées claires).
  static const bool modeSombreDisponible = false;

  bool get isDarkMode => modeSombreDisponible && profile.isDarkMode;

  void toggleThemeMode() {
    profile.isDarkMode = !profile.isDarkMode;
    storageService.saveProfile(profile);
    notifyListeners();
  }

  // --- BOUTIQUE ET GOODIES ROMAINS ---

  String getEquippedGoodie(GoodieCategory cat) {
    return profile.getEquippedGoodie(cat.name);
  }

  bool isGoodieOwned(String goodieId) {
    return profile.isGoodieOwned(goodieId);
  }

  bool isGoodieEquipped(GoodieCategory cat, String goodieId) {
    return profile.isGoodieEquipped(cat.name, goodieId);
  }

  bool buyGoodie(GoodieItem item) {
    if (profile.sesterces < item.prix) return false;
    if (profile.isGoodieOwned(item.id)) return false;

    profile.sesterces -= item.prix;
    profile.ownedGoodies.add(item.id);
    profile.compteurs['objets_achetes'] = (profile.compteurs['objets_achetes'] ?? 0) + 1;
    // Équipe automatiquement le nouvel objet acheté
    profile.equippedGoodies[item.categorie.name] = item.id;

    storageService.saveProfile(profile);
    notifyListeners();
    return true;
  }

  void equipGoodie(GoodieCategory cat, String goodieId) {
    if (!profile.isGoodieOwned(goodieId) && goodieId != 'aucune' && goodieId != 'aucun') {
      return;
    }
    profile.equippedGoodies[cat.name] = goodieId;
    storageService.saveProfile(profile);
    notifyListeners();
  }
}
