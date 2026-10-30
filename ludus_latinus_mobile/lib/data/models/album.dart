/// Album « Héros et Créatures » : 66 cartes, gagnées par un succès ou achetées
/// à prix fixe à la Taberna, sans tirage au hasard.
/// Les données viennent du bloc `album` du dataset (content/album_mobile.py).
library;

/// Familles de cartes, dans l'ordre d'affichage de l'album.
const List<String> famillesAlbum = ['heros', 'divinites', 'monstres', 'monuments'];

class CarteAlbum {
  final String id;
  final String nom;
  final String nomLatin;
  final String categorie;
  final String rarete;
  final int attaque;
  final int defense;
  final String citation;
  final String traduction;
  final String anecdote;
  final String image;

  /// Prix à la Taberna ; null pour une carte qui se gagne par un succès.
  final int? prix;

  const CarteAlbum({
    required this.id,
    required this.nom,
    required this.nomLatin,
    required this.categorie,
    required this.rarete,
    required this.attaque,
    required this.defense,
    required this.citation,
    required this.traduction,
    required this.anecdote,
    required this.image,
    this.prix,
  });

  factory CarteAlbum.fromJson(Map<String, dynamic> json) => CarteAlbum(
        id: json['id'] as String,
        nom: json['nom'] as String? ?? '',
        nomLatin: json['nom_latin'] as String? ?? '',
        categorie: json['categorie'] as String? ?? 'heros',
        rarete: json['rarete'] as String? ?? 'commune',
        attaque: json['atk'] as int? ?? 0,
        defense: json['def'] as int? ?? 0,
        citation: json['citation'] as String? ?? '',
        traduction: json['traduction'] as String? ?? '',
        anecdote: json['anecdote'] as String? ?? '',
        image: json['image'] as String? ?? '',
        prix: json['prix'] as int?,
      );
}

/// Un succès : la statistique suivie, le seuil à atteindre et la carte gagnée.
class SuccesAlbum {
  final String carteId;
  final String stat;
  final int seuil;
  final String texte;

  const SuccesAlbum({required this.carteId, required this.stat, required this.seuil, required this.texte});

  factory SuccesAlbum.fromJson(Map<String, dynamic> json) => SuccesAlbum(
        carteId: json['carte'] as String,
        stat: json['stat'] as String,
        seuil: json['seuil'] as int? ?? 1,
        texte: json['texte'] as String? ?? '',
      );
}
