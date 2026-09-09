/// Monument du Forum Romain à restaurer.
class ForumMonument {
  final String id;
  final String nom;
  final String titreFr;
  final int cout;
  final String bonus;
  final String description;
  final String couleurToit;

  const ForumMonument({
    required this.id,
    required this.nom,
    required this.titreFr,
    required this.cout,
    required this.bonus,
    required this.description,
    required this.couleurToit,
  });

  factory ForumMonument.fromJson(Map<String, dynamic> json) {
    return ForumMonument(
      id: json['id'] as String? ?? '',
      nom: json['nom'] as String? ?? '',
      titreFr: json['titre_fr'] as String? ?? '',
      cout: json['cout'] as int? ?? 100,
      bonus: json['bonus'] as String? ?? '',
      description: json['description'] as String? ?? '',
      couleurToit: json['couleur_toit'] as String? ?? '#d4af37',
    );
  }
}
