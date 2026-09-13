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

  bool get isDue =>
      DateTime.now().isAfter(nextReviewDate) ||
      DateTime.now().isAtSameMomentAs(nextReviewDate);

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
  List<String> completedLessons;
  List<String> restoredMonuments;
  Map<String, int> srsScores;
  Map<String, SrsCardProgress> srsCards;
  String email;
  String tesseraCode;
  String? lastSyncDate;
  String? lastDailyQuestDate;
  List<String> decodedEpigraphs;
  bool isDarkMode;
  Map<String, String> equippedGoodies;
  List<String> ownedGoodies;

  UserProfile({
    this.id = 'defaut',
    this.nomHeros = 'Marcus',
    this.genre = 'garcon',
    this.sesterces = 50,
    this.streakDays = 1,
    List<String>? completedLessons,
    List<String>? restoredMonuments,
    Map<String, int>? srsScores,
    Map<String, SrsCardProgress>? srsCards,
    this.email = '',
    this.tesseraCode = 'SPQR-7A2B-9C1D',
    this.lastSyncDate,
    this.lastDailyQuestDate,
    List<String>? decodedEpigraphs,
    this.isDarkMode = false,
    Map<String, String>? equippedGoodies,
    List<String>? ownedGoodies,
  })  : completedLessons = completedLessons ?? [],
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

  bool get isDailyQuestCompletedToday {
    if (lastDailyQuestDate == null) return false;
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return lastDailyQuestDate == todayStr;
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
          reason: 'Termine 2 étapes sur la Via Appia pour entrer dans l\'Arène',
          progress: prog,
        );
      case 'taverne':
        final prog = (completedLessons.length / taverneRequiredLessons).clamp(0.0, 1.0);
        return (
          isUnlocked: isTaverneUnlocked,
          reason: 'Débloqué au Palier II (6 étapes sur la Via Appia)',
          progress: prog,
        );
      case 'cesar':
        final prog = (completedLessons.length / cesarRequiredLessons).clamp(0.0, 1.0);
        return (
          isUnlocked: isCesarUnlocked,
          reason: 'Débloqué au Palier III : L\'Armée (12 étapes sur la Via Appia)',
          progress: prog,
        );
      case 'marche':
        final prog = (completedLessons.length / marcheTrajanRequiredLessons).clamp(0.0, 1.0);
        return (
          isUnlocked: isMarcheTrajanUnlocked,
          reason: 'Débloqué au Palier IV : Vie Quotidienne (18 étapes sur la Via Appia)',
          progress: prog,
        );
      case 'pantheon':
        final prog = (completedLessons.length / pantheonRequiredLessons).clamp(0.0, 1.0);
        return (
          isUnlocked: isPantheonUnlocked,
          reason: 'Restaure 1 édifice au Forum ou termine 4 étapes',
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
      streakDays: json['streak'] as int? ?? 1,
      completedLessons: rawCompleted.map((e) => e.toString()).toList(),
      restoredMonuments: rawMonuments.map((e) => e.toString()).toList(),
      srsCards: parsedSrs,
      email: rawCompte['email'] as String? ?? '',
      tesseraCode: rawCompte['tessera'] as String? ?? 'SPQR-1001-A2B3',
      lastSyncDate: rawCompte['derniere_sync'] as String?,
      lastDailyQuestDate: json['last_daily_quest_date'] as String?,
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
      'completed': completedLessons,
      'forum_monuments': restoredMonuments,
      'srs_cards': srsCards.map((k, v) => MapEntry(k, v.toJson())),
      'last_daily_quest_date': lastDailyQuestDate,
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
