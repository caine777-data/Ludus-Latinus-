import 'lesson.dart';

/// Représente un Monde / Parcours d'apprentissage dans Ludus Latinus.
class World {
  final String id;
  final String title;
  final String? subtitle;
  final String? icon;
  final List<Lesson> lessons;

  const World({
    required this.id,
    required this.title,
    this.subtitle,
    this.icon,
    required this.lessons,
  });

  factory World.fromJson(Map<String, dynamic> json) {
    var rawLessons = json['lessons'] as List<dynamic>? ?? [];
    List<Lesson> parsedLessons = rawLessons
        .map((l) => Lesson.fromJson(l as Map<String, dynamic>))
        .toList();

    return World(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Monde',
      subtitle: json['subtitle'] as String?,
      icon: json['icon'] as String?,
      lessons: parsedLessons,
    );
  }
}

/// Classe du collège (5ème, 4ème, 3ème).
class SchoolClass {
  final String id;
  final String titre;
  final String sousTitre;
  final String icone;
  final String description;
  final List<String> mondesIds;

  const SchoolClass({
    required this.id,
    required this.titre,
    required this.sousTitre,
    required this.icone,
    required this.description,
    required this.mondesIds,
  });

  factory SchoolClass.fromJson(Map<String, dynamic> json) {
    var rawIds = json['mondes_ids'] as List<dynamic>? ?? [];
    return SchoolClass(
      id: json['id'] as String? ?? '',
      titre: json['titre'] as String? ?? '',
      sousTitre: json['sous_titre'] as String? ?? '',
      icone: json['icone'] as String? ?? '🏛️',
      description: json['description'] as String? ?? '',
      mondesIds: rawIds.map((e) => e.toString()).toList(),
    );
  }
}
