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
  List<String> completedLessons;
  /// Meilleur nombre d'étoiles (1 à 3) obtenu par leçon.
  Map<String, int> lessonStars;
  List<String> restoredMonuments;
  Map<String, int> srsScores;
  Map<String, SrsCardProgress> srsCards;
  String email;
  String tesseraCode;
  String? lastSyncDate;
  String? lastDailyQuestDate;
  String? taverneRewardDate;
  int taverneRewardCount;
  List<String> decodedEpigraphs;
  bool isDarkMode;
  Map<String, String> equippedGoodies;
  List<String> ownedGoodies;

  UserProfile({
    this.id = 'defaut',
    this.nomHeros = 'Marcus',
    this.genre = 'garcon',
    this.sesterces = 50,
    this.streakDays = 0,
    this.lastActivityDate,
    this.introSeen = false,
    List<String>? completedLessons,
    Map<String, int>? lessonStars,
    List<String>? restoredMonuments,
    Map<String, int>? srsScores,
    Map<String, SrsCardProgress>? srsCards,
    this.email = '',
    this.tesseraCode = 'SPQR-7A2B-9C1D',
    this.lastSyncDate,
    this.lastDailyQuestDate,
    this.taverneRewardDate,
    this.taverneRewardCount = 0,
    List<String>? decodedEpigraphs,
    this.isDarkMode = false,
    Map<String, String>? equippedGoodies,
    List<String>? ownedGoodies,
  })  : completedLessons = completedLessons ?? [],
        lessonStars = lessonStars ?? {},
        restoredMonuments = restoredMonuments ?? [],
        srsScores = srsScores ?? {},
        srsCards = srsCards ?? {},
        decodedEpigraphs = decodedEpigraphs ?? [],
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

  bool get isRegistered => email.isNotEmpty;

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

  /// Nombre de lancers de la Taverne encore récompensés aujourd'hui.
  static const int taverneRewardsPerDay = 3;

  int get taverneRewardsLeftToday =>
      taverneRewardDate == _todayStr ? (taverneRewardsPerDay - taverneRewardCount).clamp(0, taverneRewardsPerDay) : taverneRewardsPerDay;

  /// Consomme un lancer récompensé. Renvoie false si le quota du jour est atteint.
  bool consumeTaverneReward() {
    if (taverneRewardDate != _todayStr) {
      taverneRewardDate = _todayStr;
      taverneRewardCount = 0;
    }
    if (taverneRewardCount >= taverneRewardsPerDay) return false;
    taverneRewardCount++;
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

  bool get isPantheonUnlocked => restoredMonuments.isNotEmpty || completedLessons.length >= 4;
  int get pantheonRequiredLessons => 4;

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
      case 'marche':
        final prog = (completedLessons.length / marcheTrajanRequiredLessons).clamp(0.0, 1.0);
        return (
          isUnlocked: isMarcheTrajanUnlocked,
          reason: 'Termine 18 leçons pour ouvrir le Marché de Trajan',
          progress: prog,
        );
      case 'pantheon':
        final prog = (completedLessons.length / pantheonRequiredLessons).clamp(0.0, 1.0);
        return (
          isUnlocked: isPantheonUnlocked,
          reason: 'Termine 4 leçons ou restaure 1 édifice du Forum',
          progress: prog,
        );
      default:
        return (isUnlocked: true, reason: '', progress: 1.0);
    }
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    var rawCompte = json['compte'] as Map<String, dynamic>? ?? {};
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
      completedLessons: rawCompleted.map((e) => e.toString()).toList(),
      // Les leçons validées avant l'arrivée des étoiles gardent 3 étoiles.
      lessonStars: {
        for (final id in rawCompleted) id.toString(): 3,
        for (final e in rawStars.entries) e.key: (e.value as num?)?.toInt().clamp(1, 3) ?? 1,
      },
      restoredMonuments: rawMonuments.map((e) => e.toString()).toList(),
      srsCards: parsedSrs,
      email: rawCompte['email'] as String? ?? '',
      tesseraCode: rawCompte['tessera'] as String? ?? 'SPQR-1001-A2B3',
      lastSyncDate: rawCompte['derniere_sync'] as String?,
      lastDailyQuestDate: json['last_daily_quest_date'] as String?,
      taverneRewardDate: json['taverne_reward_date'] as String?,
      taverneRewardCount: json['taverne_reward_count'] as int? ?? 0,
      decodedEpigraphs: rawEpigraphs.map((e) => e.toString()).toList(),
      isDarkMode: json['dark_mode'] as bool? ?? false,
      equippedGoodies: parsedEquipped,
      ownedGoodies: parsedOwned,
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
      'completed': completedLessons,
      'lesson_stars': lessonStars,
      'forum_monuments': restoredMonuments,
      'srs_cards': srsCards.map((k, v) => MapEntry(k, v.toJson())),
      'last_daily_quest_date': lastDailyQuestDate,
      'taverne_reward_date': taverneRewardDate,
      'taverne_reward_count': taverneRewardCount,
      'decoded_epigraphs': decodedEpigraphs,
      'dark_mode': isDarkMode,
      'equipped_goodies': equippedGoodies,
      'owned_goodies': ownedGoodies,
      'compte': {
        'email': email,
        'tessera': tesseraCode,
        'derniere_sync': lastSyncDate,
      },
    };
  }
}
