/// Une carte du Panthéon : l'élève la gagne en terminant le monde correspondant.
/// Les textes viennent de `assets/data/pantheon.json`.
class CartePantheon {
  /// Rang du monde (1 à 26).
  final int monde;
  final String nom;
  final String devise;
  final String traduction;
  final String image;

  const CartePantheon({
    required this.monde,
    required this.nom,
    required this.devise,
    required this.traduction,
    required this.image,
  });

  /// Identifiant du monde dans le dataset (`monde3` pour le rang 3).
  String get mondeId => 'monde$monde';

  /// Image de repli tant que l'illustration de la carte n'est pas déposée.
  String get imageRepli => 'assets/images/mondes/monde$monde.webp';

  factory CartePantheon.fromJson(Map<String, dynamic> json) {
    final monde = (json['monde'] as num?)?.toInt() ?? 0;
    return CartePantheon(
      monde: monde,
      nom: json['nom'] as String? ?? '',
      devise: json['devise'] as String? ?? '',
      traduction: json['traduction'] as String? ?? '',
      image: json['image'] as String? ??
          'assets/images/pantheon/carte_monde${monde.toString().padLeft(2, '0')}.jpg',
    );
  }
}
