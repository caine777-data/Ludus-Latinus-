import 'lesson.dart';

/// Représente un Monde / Parcours d'apprentissage dans Ludus Latinus.
class World {
  final String id;
  final String title;
  final String? subtitle;
  final String? icon;
  final List<Lesson> lessons;
  /// Ce que le monde travaille du programme officiel (ligne « Au programme »).
  final ProgrammeMonde? programme;

  const World({
    required this.id,
    required this.title,
    this.subtitle,
    this.icon,
    required this.lessons,
    this.programme,
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
      programme: json['programme'] is Map<String, dynamic>
          ? ProgrammeMonde.fromJson(json['programme'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Notion de langue et thème culturel du programme de LCA (BO du 17 mars 2016)
/// travaillés dans un monde.
class ProgrammeMonde {
  final String langue;
  final String culture;

  const ProgrammeMonde({required this.langue, required this.culture});

  factory ProgrammeMonde.fromJson(Map<String, dynamic> json) => ProgrammeMonde(
        langue: json['langue'] as String? ?? '',
        culture: json['culture'] as String? ?? '',
      );
}

/// Texte de la page « Pour les professeurs ».
class ProgrammeLca {
  final String reference;
  final String presentation;
  final List<String> ecarts;
  final String relecture;
  final String contact;

  const ProgrammeLca({
    required this.reference,
    required this.presentation,
    required this.ecarts,
    required this.relecture,
    required this.contact,
  });

  factory ProgrammeLca.fromJson(Map<String, dynamic> json) => ProgrammeLca(
        reference: json['reference'] as String? ?? '',
        presentation: json['presentation'] as String? ?? '',
        ecarts: [for (final e in json['ecarts'] as List<dynamic>? ?? []) e.toString()],
        relecture: json['relecture'] as String? ?? '',
        contact: json['contact'] as String? ?? '',
      );
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
