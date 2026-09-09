/// Carte de vocabulaire pour le dojo de répétition espacée (Memoria Velox).
class SrsCard {
  final String id;
  final String latin;
  final String genre;
  final String francais;
  final String etymologie;
  final String exemple;
  final String exempleFr;
  final String categorie;

  const SrsCard({
    required this.id,
    required this.latin,
    required this.genre,
    required this.francais,
    required this.etymologie,
    required this.exemple,
    required this.exempleFr,
    required this.categorie,
  });

  factory SrsCard.fromJson(Map<String, dynamic> json) {
    return SrsCard(
      id: json['id'] as String? ?? '',
      latin: json['latin'] as String? ?? '',
      genre: json['genre'] as String? ?? '',
      francais: json['francais'] as String? ?? '',
      etymologie: json['etymologie'] as String? ?? '',
      exemple: json['exemple'] as String? ?? '',
      exempleFr: json['exemple_fr'] as String? ?? '',
      categorie: json['categorie'] as String? ?? 'Vocabulaire',
    );
  }
}
