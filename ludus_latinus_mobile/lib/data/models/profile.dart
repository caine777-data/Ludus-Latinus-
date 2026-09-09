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
  })  : completedLessons = completedLessons ?? [],
        restoredMonuments = restoredMonuments ?? [],
        srsScores = srsScores ?? {};

  bool get isRegistered => email.isNotEmpty;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    var rawCompte = json['compte'] as Map<String, dynamic>? ?? {};
    var rawCompleted = json['completed'] as List<dynamic>? ?? [];
    var rawMonuments = json['forum_monuments'] as List<dynamic>? ?? [];

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
      'compte': {
        'email': email,
        'tessera': tesseraCode,
        'derniere_sync': lastSyncDate,
      },
    };
  }
}
