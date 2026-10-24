import 'cursus_honorum.dart';

/// Progression d'une carte dans le système de répétition espacée Leitner (SM-2).
class SrsCardProgress {
  final int box; // 1 à 5
  final DateTime nextReviewDate;
  final int totalReviews;
  final int lapses;

  const SrsCardProgress({
    this.box = 1,
    required this.nextReviewDate,
    this.totalReviews = 0,
    this.lapses = 0,
  });

  // Un seul appel à DateTime.now() : deux appels successifs pouvaient tomber
  // dans la même milliseconde et rendre une carte neuve « pas encore due ».
  bool get isDue => !DateTime.now().isBefore(nextReviewDate);

  factory SrsCardProgress.initial() {
    return SrsCardProgress(
      box: 1,
      nextReviewDate: DateTime.now(),
      totalReviews: 0,
      lapses: 0,
    );
  }

  factory SrsCardProgress.fromJson(Map<String, dynamic> json) {
    return SrsCardProgress(
      box: (json['box'] as int?) ?? 1,
      nextReviewDate: json['next_review'] != null
          ? DateTime.tryParse(json['next_review'].toString()) ?? DateTime.now()
          : DateTime.now(),
      totalReviews: (json['total_reviews'] as int?) ?? 0,
      lapses: (json['lapses'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'box': box,
      'next_review': nextReviewDate.toIso8601String(),
      'total_reviews': totalReviews,
      'lapses': lapses,
    };
  }

  /// Calcule la progression suite à une réponse réussie (Leitner box progression)
  /// Box 1: +1 jour
  /// Box 2: +3 jours
  /// Box 3: +7 jours
  /// Box 4: +14 jours
  /// Box 5: +30 jours
  SrsCardProgress onSuccess() {
    final newBox = (box < 5) ? box + 1 : 5;
    final Duration interval;
    switch (newBox) {
      case 1:
        interval = const Duration(days: 1);
        break;
      case 2:
        interval = const Duration(days: 3);
        break;
      case 3:
        interval = const Duration(days: 7);
        break;
      case 4:
        interval = const Duration(days: 14);
        break;
      case 5:
      default:
        interval = const Duration(days: 30);
        break;
    }
    return SrsCardProgress(
      box: newBox,
      nextReviewDate: DateTime.now().add(interval),
      totalReviews: totalReviews + 1,
      lapses: lapses,
    );
  }

  /// Calcule la réinitialisation suite à un échec (retour en Boîte 1)
  SrsCardProgress onFailure() {
    return SrsCardProgress(
      box: 1,
      nextReviewDate: DateTime.now(),
      totalReviews: totalReviews + 1,
      lapses: lapses + 1,
    );
  }
}

/// Profil du joueur et sauvegarde de sa progression.
class UserProfile {
  String id;
  String nomHeros;
  String genre; // 'garcon' ou 'fille'
  int sesterces;
  int streakDays;
  /// Dernier jour (AAAA-MM-JJ) où l'élève a validé une leçon ou révisé.
  String? lastActivityDate;
  /// Vrai une fois la vidéo d'introduction vue (elle ne se joue qu'au premier lancement).
  bool introSeen;
  /// Vrai une fois le héros choisi (prénom, fille ou garçon) au premier lancement.
  bool heroChoisi;
  /// Niveaux (identifiants de classe : 5eme, 4eme, 3eme) dont la vidéo d'entrée a été vue.
  List<String> niveauxVus;
  List<String> completedLessons;
  /// Meilleur nombre d'étoiles (1 à 3) obtenu par leçon.
  Map<String, int> lessonStars;
  List<String> restoredMonuments;
  Map<String, int> srsScores;
  Map<String, SrsCardProgress> srsCards;
  String? lastDailyQuestDate;

  /// Victoires payées aujourd'hui, par jeu (« circus », « duel »).
  String? recompensesJeuxDate;
  Map<String, int> recompensesJeux;

  /// Missions de César déjà payées (numéros 0 à 5).
  List<int> missionsCesar;

  /// Exercices payés une seule fois (« marche:etal:3 »…).
  List<String> recompensesUniques;

  /// Meilleur résultat par jeu : 'circus' (points), 'duel' et 'memoria'
  /// (bonnes réponses d'affilée).
  Map<String, int> records;
  List<String> decodedEpigraphs;
  bool isDarkMode;
  /// Mode lecture confort : texte plus espacé, pour les élèves dyslexiques
  /// ou qui lisent avec peine.
  bool lectureConfort;
  Map<String, String> equippedGoodies;
  List<String> ownedGoodies;

  /// Compteurs des succès de l'album (« duels_gagnes », « courses_finies »…).
  Map<String, int> compteurs;

  /// Gladiateurs du Duel déjà vaincus (nom du boss).
  List<String> gladiateursVaincus;

  /// Cartes de l'album « Héros et Créatures » obtenues, dans l'ordre d'obtention.
  List<String> cartesAlbum;

  /// Rappel quotidien : désactivé par défaut, proposé après la première leçon.
  bool rappelActif;
  bool rappelPropose;
  /// Dernier rang du Cursus Honorum et jeux du Ludi déjà annoncés à l'élève.
  /// Null tant que l'appli ne les a jamais relevés (ancienne sauvegarde) :
  /// on note alors l'état du moment sans rien annoncer.
  String? rangAnnonce;
  List<String>? jeuxAnnonces;
  /// Heure du rappel, en minutes depuis minuit (17 h 30 par défaut).
  int rappelMinutes;

  /// Objectif du jour : 1 à 3 activités (une leçon réussie, ou 10 cartes Memoria).
  int objectifJour;
  /// Jour des compteurs ci-dessous (« AAAA-MM-JJ ») : ils repartent de zéro chaque jour.
  String? activiteDate;
  int leconsDuJour;
  int revisionsDuJour;
  /// Jour où l'objectif a été atteint et payé (5 sesterces, une fois par jour).
  String? objectifRecompenseDate;

  UserProfile({
    this.id = 'defaut',
    this.nomHeros = 'Marcus',
    this.genre = 'garcon',
    this.sesterces = 50,
    this.streakDays = 0,
    this.lastActivityDate,
    this.introSeen = false,
    this.heroChoisi = false,
    List<String>? niveauxVus,
    List<String>? completedLessons,
    Map<String, int>? lessonStars,
    List<String>? restoredMonuments,
    Map<String, int>? srsScores,
    Map<String, SrsCardProgress>? srsCards,
    this.lastDailyQuestDate,
    this.recompensesJeuxDate,
    Map<String, int>? recompensesJeux,
    List<int>? missionsCesar,
    List<String>? recompensesUniques,
    Map<String, int>? records,
    List<String>? decodedEpigraphs,
    this.isDarkMode = false,
    this.lectureConfort = false,
    Map<String, String>? equippedGoodies,
    List<String>? ownedGoodies,
    Map<String, int>? compteurs,
    List<String>? gladiateursVaincus,
    List<String>? cartesAlbum,
    this.rappelActif = false,
    this.rappelPropose = false,
    this.rangAnnonce,
    this.jeuxAnnonces,
    this.rappelMinutes = 17 * 60 + 30,
    this.objectifJour = 1,
    this.activiteDate,
    this.leconsDuJour = 0,
    this.revisionsDuJour = 0,
    this.objectifRecompenseDate,
  })  : compteurs = compteurs ?? {},
        gladiateursVaincus = gladiateursVaincus ?? [],
        cartesAlbum = cartesAlbum ?? [],
        completedLessons = completedLessons ?? [],
        niveauxVus = niveauxVus ?? [],
        lessonStars = lessonStars ?? {},
        restoredMonuments = restoredMonuments ?? [],
        srsScores = srsScores ?? {},
        srsCards = srsCards ?? {},
        decodedEpigraphs = decodedEpigraphs ?? [],
        recompensesJeux = recompensesJeux ?? {},
        missionsCesar = missionsCesar ?? [],
        recompensesUniques = recompensesUniques ?? [],
        records = records ?? {},
        equippedGoodies = equippedGoodies ?? {
          'toge': 'lin_blanc',
          'couronne': 'aucune',
          'accessoire': 'stylet',
          'compagnon': 'aucun',
        },
        ownedGoodies = ownedGoodies ?? [
          'lin_blanc',
          'aucune',
          'stylet',
          'aucun',
        ];

  SrsCardProgress getCardProgress(String cardId) {
    return srsCards[cardId] ?? SrsCardProgress.initial();
  }

  void updateCardSrs(String cardId, {required bool success}) {
    final current = getCardProgress(cardId);
    srsCards[cardId] = success ? current.onSuccess() : current.onFailure();
  }

  String getEquippedGoodie(String categoryKey) {
    return equippedGoodies[categoryKey] ??
        (categoryKey == 'toge'
            ? 'lin_blanc'
            : categoryKey == 'couronne'
                ? 'aucune'
                : categoryKey == 'accessoire'
                    ? 'stylet'
                    : 'aucun');
  }

  bool isGoodieOwned(String goodieId) {
    return ownedGoodies.contains(goodieId);
  }

  bool isGoodieEquipped(String categoryKey, String goodieId) {
    return getEquippedGoodie(categoryKey) == goodieId;
  }

  static String _dateStr(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static String get _todayStr => _dateStr(DateTime.now());

  /// Remet les compteurs du jour à zéro quand la date a changé.
  void _jourCourant([DateTime? now]) {
    final jour = _dateStr(now ?? DateTime.now());
    if (activiteDate == jour) return;
    activiteDate = jour;
    leconsDuJour = 0;
    revisionsDuJour = 0;
  }

  /// Activités du jour : une par leçon réussie, une par tranche de 10 cartes Memoria.
  int activitesDuJour([DateTime? now]) {
    final jour = _dateStr(now ?? DateTime.now());
    if (activiteDate != jour) return 0;
    return leconsDuJour + revisionsDuJour ~/ 10;
  }

  /// Leçon ou révision faite aujourd'hui (la série est déjà prolongée).
  bool aJoueAujourdhui([DateTime? now]) => lastActivityDate == _dateStr(now ?? DateTime.now());

  bool objectifAtteintAujourdhui([DateTime? now]) => objectifRecompenseDate == _dateStr(now ?? DateTime.now());

  void noterLeconDuJour([DateTime? now]) {
    _jourCourant(now);
    leconsDuJour++;
  }

  void noterRevisionDuJour([DateTime? now]) {
    _jourCourant(now);
    revisionsDuJour++;
  }

  /// Vrai, une fois par jour, au moment où l'objectif vient d'être atteint.
  bool validerObjectif([DateTime? now]) {
    if (objectifAtteintAujourdhui(now)) return false;
    if (activitesDuJour(now) < objectifJour) return false;
    objectifRecompenseDate = _dateStr(now ?? DateTime.now());
    return true;
  }

  /// Série de jours consécutifs d'apprentissage. Elle retombe à 0 si l'élève
  /// n'a rien fait ni aujourd'hui ni hier.
  int currentStreak([DateTime? now]) {
    final today = now ?? DateTime.now();
    final todayStr = _dateStr(today);
    final yesterdayStr = _dateStr(today.subtract(const Duration(days: 1)));
    if (lastActivityDate == todayStr || lastActivityDate == yesterdayStr) return streakDays;
    return 0;
  }

  /// À appeler après une leçon validée ou une révision : met à jour la série.
  void recordActivity([DateTime? now]) {
    final today = now ?? DateTime.now();
    final todayStr = _dateStr(today);
    if (lastActivityDate == todayStr) return;
    final yesterdayStr = _dateStr(today.subtract(const Duration(days: 1)));
    streakDays = lastActivityDate == yesterdayStr ? streakDays + 1 : 1;
    lastActivityDate = todayStr;
  }

  bool get isDailyQuestCompletedToday {
    if (lastDailyQuestDate == null) return false;
    return lastDailyQuestDate == _todayStr;
  }

  /// Victoires payées ouvertes par chaque activité du jour (leçon, tranche
  /// de 10 cartes Memoria), et plafond du jour tous jeux confondus.
  /// Avant, chaque jeu payait 3 victoires par jour sans condition : un élève
  /// qui ne faisait que jouer gagnait dix fois plus que celui qui faisait sa
  /// leçon. Le jeu devient la récompense de la leçon, sans être retiré.
  static const int victoiresParActivite = 2;
  static const int victoiresPayeesMax = 6;

  /// Victoires encore payées aujourd'hui, tous jeux confondus.
  int victoiresPayeesRestantes([DateTime? now]) {
    final jour = _dateStr(now ?? DateTime.now());
    final utilisees = recompensesJeuxDate == jour ? recompensesJeux.values.fold(0, (a, b) => a + b) : 0;
    final ouvertes = (activitesDuJour(now) * victoiresParActivite).clamp(0, victoiresPayeesMax);
    return (ouvertes - utilisees).clamp(0, victoiresPayeesMax);
  }

  /// Consomme une victoire payée pour [jeu]. Renvoie false s'il n'en reste pas.
  bool prendreRecompense(String jeu, [DateTime? now]) {
    if (victoiresPayeesRestantes(now) <= 0) return false;
    final jour = _dateStr(now ?? DateTime.now());
    if (recompensesJeuxDate != jour) {
      recompensesJeuxDate = jour;
      recompensesJeux.clear();
    }
    recompensesJeux[jeu] = (recompensesJeux[jeu] ?? 0) + 1;
    return true;
  }

  CursusHonorum get cursusRank => CursusHonorum.getRank(
        completedLessons.length,
        restoredMonuments.length,
        sesterces,
      );

  List<String> get unlockedMonuments => restoredMonuments;

  // --- Conditions de Déblocage Progressif (Progressive Disclosure) ---
  // 1. Circus Maximus : accessible dès le premier jour
  bool get isCircusUnlocked => true;
  int get circusRequiredLessons => 0;

  // 2. Colosseum Duellum : accessible après au moins 2 leçons réussies
  bool get isColosseumUnlocked => completedLessons.length >= 2;
  int get colosseumRequiredLessons => 2;

  bool get isTaverneUnlocked => completedLessons.length >= 6;
  int get taverneRequiredLessons => 6;

  bool get isCesarUnlocked => completedLessons.length >= 12;
  int get cesarRequiredLessons => 12;

  bool get isMarcheTrajanUnlocked => completedLessons.length >= 18;
  int get marcheTrajanRequiredLessons => 18;

  /// Ouvert dès le départ : les 26 cartes face cachée montrent ce qu'il y a à gagner.
  bool get isPantheonUnlocked => true;

  ({bool isUnlocked, String reason, double progress}) getUnlockStatusForGame(String gameKey) {
    switch (gameKey) {
      case 'circus':
        return (
          isUnlocked: true,
          reason: 'Prêt pour la course de chars épiques !',
          progress: 1.0,
        );
      case 'duel':
        final prog = (completedLessons.length / colosseumRequiredLessons).clamp(0.0, 1.0);
        return (
          isUnlocked: isColosseumUnlocked,
          reason: 'Termine 2 leçons pour entrer dans l\'Arène',
          progress: prog,
        );
      case 'taverne':
        final prog = (completedLessons.length / taverneRequiredLessons).clamp(0.0, 1.0);
        return (
          isUnlocked: isTaverneUnlocked,
          reason: 'Termine 6 leçons pour ouvrir la Taverne',
          progress: prog,
        );
      case 'cesar':
        final prog = (completedLessons.length / cesarRequiredLessons).clamp(0.0, 1.0);
        return (
          isUnlocked: isCesarUnlocked,
          reason: 'Termine 12 leçons pour ouvrir l\'Atelier de César',
          progress: prog,
        );
      case 'bataille':
        return (
          isUnlocked: cartesAlbum.length >= 3,
          reason: 'Gagne 3 cartes de l\'album pour défier Crassus',
          progress: (cartesAlbum.length / 3).clamp(0.0, 1.0),
        );
      case 'marche':
        final prog = (completedLessons.length / marcheTrajanRequiredLessons).clamp(0.0, 1.0);
        return (
          isUnlocked: isMarcheTrajanUnlocked,
          reason: 'Termine 18 leçons pour ouvrir le Marché de Trajan',
          progress: prog,
        );
      default:
        return (isUnlocked: true, reason: '', progress: 1.0);
    }
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // Une ancienne sauvegarde peut contenir un bloc 'compte' (faux compte cloud
    // retiré) : on ne le lit plus, il est simplement ignoré.
    var rawCompleted = json['completed'] as List<dynamic>? ?? [];
    var rawMonuments = json['forum_monuments'] as List<dynamic>? ?? [];
    var rawEpigraphs = json['decoded_epigraphs'] as List<dynamic>? ?? [];
    var rawEquipped = json['equipped_goodies'] as Map<String, dynamic>? ?? {};
    var rawOwned = json['owned_goodies'] as List<dynamic>? ?? [];
    var rawSrs = json['srs_cards'] as Map<String, dynamic>? ?? {};
    var rawStars = json['lesson_stars'] as Map<String, dynamic>? ?? {};

    Map<String, String> parsedEquipped = {
      'toge': rawEquipped['toge']?.toString() ?? 'lin_blanc',
      'couronne': rawEquipped['couronne']?.toString() ?? 'aucune',
      'accessoire': rawEquipped['accessoire']?.toString() ?? 'stylet',
      'compagnon': rawEquipped['compagnon']?.toString() ?? 'aucun',
    };

    List<String> parsedOwned = rawOwned.isNotEmpty
        ? rawOwned.map((e) => e.toString()).toList()
        : ['lin_blanc', 'aucune', 'stylet', 'aucun'];

    Map<String, SrsCardProgress> parsedSrs = {};
    rawSrs.forEach((key, val) {
      if (val is Map<String, dynamic>) {
        parsedSrs[key] = SrsCardProgress.fromJson(val);
      }
    });

    return UserProfile(
      id: json['id'] as String? ?? 'defaut',
      nomHeros: json['nom_heros'] as String? ?? 'Marcus',
      genre: json['genre'] as String? ?? 'garcon',
      sesterces: json['sesterces'] as int? ?? 50,
      streakDays: json['streak'] as int? ?? 0,
      lastActivityDate: json['last_activity_date'] as String?,
      // Un profil qui a déjà progressé ne revoit pas l'introduction.
      introSeen: json['intro_seen'] as bool? ?? rawCompleted.isNotEmpty,
      // Un profil qui a déjà progressé a déjà son héros : on ne le lui redemande pas.
      heroChoisi: json['hero_choisi'] as bool? ?? rawCompleted.isNotEmpty,
      niveauxVus: (json['niveaux_vus'] as List?)?.map((e) => e.toString()).toList(),
      completedLessons: rawCompleted.map((e) => e.toString()).toList(),
      // Les leçons validées avant l'arrivée des étoiles gardent 3 étoiles.
      lessonStars: {
        for (final id in rawCompleted) id.toString(): 3,
        for (final e in rawStars.entries) e.key: (e.value as num?)?.toInt().clamp(1, 3) ?? 1,
      },
      restoredMonuments: rawMonuments.map((e) => e.toString()).toList(),
      srsCards: parsedSrs,
      lastDailyQuestDate: json['last_daily_quest_date'] as String?,
      recompensesJeuxDate: json['recompenses_jeux_date'] as String?,
      recompensesJeux: (json['recompenses_jeux'] as Map?)
          ?.map((k, v) => MapEntry(k.toString(), (v as num?)?.toInt() ?? 0)),
      missionsCesar: (json['missions_cesar'] as List?)?.map((e) => (e as num).toInt()).toList(),
      recompensesUniques: (json['recompenses_uniques'] as List?)?.map((e) => e.toString()).toList(),
      records: (json['records'] as Map?)?.map((k, v) => MapEntry(k.toString(), (v as num?)?.toInt() ?? 0)),
      decodedEpigraphs: rawEpigraphs.map((e) => e.toString()).toList(),
      isDarkMode: json['dark_mode'] as bool? ?? false,
      lectureConfort: json['lecture_confort'] as bool? ?? false,
      equippedGoodies: parsedEquipped,
      ownedGoodies: parsedOwned,
      compteurs: (json['compteurs'] as Map?)?.map((k, v) => MapEntry(k.toString(), (v as num?)?.toInt() ?? 0)),
      gladiateursVaincus: (json['gladiateurs_vaincus'] as List?)?.map((e) => e.toString()).toList(),
      cartesAlbum: (json['cartes_album'] as List?)?.map((e) => e.toString()).toList(),
      rappelActif: json['rappel_actif'] as bool? ?? false,
      rappelPropose: json['rappel_propose'] as bool? ?? false,
      rangAnnonce: json['rang_annonce'] as String?,
      jeuxAnnonces: (json['jeux_annonces'] as List?)?.map((e) => e.toString()).toList(),
      rappelMinutes: json['rappel_minutes'] as int? ?? 17 * 60 + 30,
      objectifJour: (json['objectif_jour'] as int? ?? 1).clamp(1, 3),
      activiteDate: json['activite_date'] as String?,
      leconsDuJour: json['lecons_du_jour'] as int? ?? 0,
      revisionsDuJour: json['revisions_du_jour'] as int? ?? 0,
      objectifRecompenseDate: json['objectif_recompense_date'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom_heros': nomHeros,
      'genre': genre,
      'sesterces': sesterces,
      'streak': streakDays,
      'last_activity_date': lastActivityDate,
      'intro_seen': introSeen,
      'hero_choisi': heroChoisi,
      'niveaux_vus': niveauxVus,
      'completed': completedLessons,
      'lesson_stars': lessonStars,
      'forum_monuments': restoredMonuments,
      'srs_cards': srsCards.map((k, v) => MapEntry(k, v.toJson())),
      'last_daily_quest_date': lastDailyQuestDate,
      'recompenses_jeux_date': recompensesJeuxDate,
      'recompenses_jeux': recompensesJeux,
      'missions_cesar': missionsCesar,
      'recompenses_uniques': recompensesUniques,
      'records': records,
      'decoded_epigraphs': decodedEpigraphs,
      'dark_mode': isDarkMode,
      'lecture_confort': lectureConfort,
      'equipped_goodies': equippedGoodies,
      'owned_goodies': ownedGoodies,
      'compteurs': compteurs,
      'gladiateurs_vaincus': gladiateursVaincus,
      'cartes_album': cartesAlbum,
      'rappel_actif': rappelActif,
      'rappel_propose': rappelPropose,
      'rang_annonce': rangAnnonce,
      'jeux_annonces': jeuxAnnonces,
      'rappel_minutes': rappelMinutes,
      'objectif_jour': objectifJour,
      'activite_date': activiteDate,
      'lecons_du_jour': leconsDuJour,
      'revisions_du_jour': revisionsDuJour,
      'objectif_recompense_date': objectifRecompenseDate,
    };
  }
}
