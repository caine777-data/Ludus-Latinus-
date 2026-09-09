import 'cursus_honorum.dart';

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
  String email;
  String tesseraCode;
  String? lastSyncDate;
  String? lastDailyQuestDate;
  List<String> decodedEpigraphs;

  UserProfile({
    this.id = 'defaut',
    this.nomHeros = 'Marcus',
    this.genre = 'garcon',
    this.sesterces = 50,
    this.streakDays = 1,
    List<String>? completedLessons,
    List<String>? restoredMonuments,
    Map<String, int>? srsScores,
    this.email = '',
    this.tesseraCode = 'SPQR-7A2B-9C1D',
    this.lastSyncDate,
    this.lastDailyQuestDate,
    List<String>? decodedEpigraphs,
  })  : completedLessons = completedLessons ?? [],
        restoredMonuments = restoredMonuments ?? [],
        srsScores = srsScores ?? {},
        decodedEpigraphs = decodedEpigraphs ?? [];

  bool get isRegistered => email.isNotEmpty;

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

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    var rawCompte = json['compte'] as Map<String, dynamic>? ?? {};
    var rawCompleted = json['completed'] as List<dynamic>? ?? [];
    var rawMonuments = json['forum_monuments'] as List<dynamic>? ?? [];
    var rawEpigraphs = json['decoded_epigraphs'] as List<dynamic>? ?? [];

    return UserProfile(
      id: json['id'] as String? ?? 'defaut',
      nomHeros: json['nom_heros'] as String? ?? 'Marcus',
      genre: json['genre'] as String? ?? 'garcon',
      sesterces: json['sesterces'] as int? ?? 50,
      streakDays: json['streak'] as int? ?? 1,
      completedLessons: rawCompleted.map((e) => e.toString()).toList(),
      restoredMonuments: rawMonuments.map((e) => e.toString()).toList(),
      email: rawCompte['email'] as String? ?? '',
      tesseraCode: rawCompte['tessera'] as String? ?? 'SPQR-1001-A2B3',
      lastSyncDate: rawCompte['derniere_sync'] as String?,
      lastDailyQuestDate: json['last_daily_quest_date'] as String?,
      decodedEpigraphs: rawEpigraphs.map((e) => e.toString()).toList(),
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
      'last_daily_quest_date': lastDailyQuestDate,
      'decoded_epigraphs': decodedEpigraphs,
      'compte': {
        'email': email,
        'tessera': tesseraCode,
        'derniere_sync': lastSyncDate,
      },
    };
  }
}
