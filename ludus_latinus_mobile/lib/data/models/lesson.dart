/// Représente une leçon ou un exercice interactif dans Ludus Latinus.
class Lesson {
  final String id;
  final String type; // 'quiz', 'puzzle', 'trou', 'arene', 'decodeur', etc.
  final String title;
  final String content;
  final String? question;
  final List<String> options;
  final int answer;
  final String? explanation;
  final String? latin;
  final List<String> words;
  final String? solution;
  final String? consigne;
  final String? avant;
  final String? apres;
  final String? latinComplet;
  final Map<String, dynamic>? boss;
  final List<Map<String, dynamic>> questions;
  final Map<String, String> roles;

  const Lesson({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    this.question,
    this.options = const [],
    this.answer = 0,
    this.explanation,
    this.latin,
    this.words = const [],
    this.solution,
    this.consigne,
    this.avant,
    this.apres,
    this.latinComplet,
    this.boss,
    this.questions = const [],
    this.roles = const {},
  });

  String? get bossName => boss?['nom'] as String? ?? boss?['name'] as String?;

  factory Lesson.fromJson(Map<String, dynamic> json) {
    var rawOptions = json['options'] as List<dynamic>? ?? [];
    var rawWords = json['mots'] as List<dynamic>? ?? [];
    var rawQuestions = json['questions'] as List<dynamic>? ?? [];

    Map<String, dynamic>? bossMap;
    if (json['boss'] is Map<String, dynamic>) {
      bossMap = json['boss'] as Map<String, dynamic>;
    } else if (json['boss'] is String) {
      bossMap = {'nom': json['boss'] as String};
    }

    Map<String, String> parsedRoles = {};
    final rawRoles = json['roles'];
    if (rawRoles is Map) {
      rawRoles.forEach((k, v) => parsedRoles[k.toString()] = v.toString());
    } else if (rawRoles is List) {
      for (final item in rawRoles) {
        if (item is Map) {
          final mot = item['mot']?.toString() ?? '';
          final cas = (item['cas'] ?? item['role'])?.toString() ?? '';
          if (mot.isNotEmpty) parsedRoles[mot] = cas;
        }
      }
    }

    return Lesson(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'quiz',
      title: json['title'] as String? ?? 'Leçon',
      content: json['content'] as String? ?? '',
      question: json['question'] as String?,
      options: rawOptions.map((e) => e.toString()).toList(),
      answer: json['answer'] as int? ?? 0,
      explanation: json['explanation'] as String?,
      latin: json['latin'] as String? ?? json['phrase_latine'] as String?,
      words: rawWords.map((e) => e.toString()).toList(),
      solution: json['solution'] as String? ?? json['reponse'] as String?,
      consigne: json['consigne'] as String?,
      avant: json['avant'] as String?,
      apres: json['apres'] as String?,
      latinComplet: json['latin_complet'] as String? ?? json['solution_complete'] as String?,
      boss: bossMap,
      questions: rawQuestions
          .whereType<Map<String, dynamic>>()
          .toList(),
      roles: parsedRoles,
    );
  }
}
