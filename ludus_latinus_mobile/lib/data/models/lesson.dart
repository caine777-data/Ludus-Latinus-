/// Représente une leçon ou un exercice interactif dans Ludus Latinus.
class Lesson {
  final String id;
  final String type; // 'quiz', 'puzzle', 'trou', 'arene', 'lecon', etc.
  final String title;
  final String content;
  final String? question;
  final List<String> options;
  final int answer;
  final String? explanation;
  final String? latin;
  final List<String> words;
  final String? solution;

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
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    var rawOptions = json['options'] as List<dynamic>? ?? [];
    var rawWords = json['mots'] as List<dynamic>? ?? [];

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
      solution: json['solution'] as String?,
    );
  }
}
