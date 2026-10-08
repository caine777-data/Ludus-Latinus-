/// Catégories de goodies pour l'avatar du citoyen romain.
enum GoodieCategory {
  toge,
  couronne,
  accessoire,
  compagnon,
}

extension GoodieCategoryExt on GoodieCategory {
  String get titre {
    switch (this) {
      case GoodieCategory.toge:
        return 'Toges & Armures';
      case GoodieCategory.couronne:
        return 'Couronnes & Casques';
      case GoodieCategory.accessoire:
        return 'Insignes & Armes';
      case GoodieCategory.compagnon:
        return 'Compagnons Romains';
    }
  }

  String get titreLatin {
    switch (this) {
      case GoodieCategory.toge:
        return 'Vestimenta';
      case GoodieCategory.couronne:
        return 'Coronae & Galeae';
      case GoodieCategory.accessoire:
        return 'Insignia & Arma';
      case GoodieCategory.compagnon:
        return 'Comites SPQR';
    }
  }

  String get icone {
    switch (this) {
      case GoodieCategory.toge:
        return '🏛️';
      case GoodieCategory.couronne:
        return '🌿';
      case GoodieCategory.accessoire:
        return '⚔️';
      case GoodieCategory.compagnon:
        return '🐺';
    }
  }
}

/// Modèle d'un objet (goodie/cosmétique) achetable à la boutique.
class GoodieItem {
  final String id;
  final String nom;
  final String nomLatin;
  final GoodieCategory categorie;
  final int prix;
  final String icone;
  final String description;

  const GoodieItem({
    required this.id,
    required this.nom,
    required this.nomLatin,
    required this.categorie,
    required this.prix,
    required this.icone,
    required this.description,
  });

  bool get isGratuit => prix == 0;
}

/// Catalogue complet des 19 goodies antiques de la Taberna Romana.
const List<GoodieItem> kCatalogueBoutique = [
  // 1. TOGES & ARMURES (Vestimenta)
  GoodieItem(
    id: 'lin_blanc',
    nom: 'Toge de lin blanc',
    nomLatin: 'Toga Pura',
    categorie: GoodieCategory.toge,
    prix: 0,
    icone: '🏛️',
    description: 'La toge de laine écrue portée par tous les jeunes citoyens romains.',
  ),
  GoodieItem(
    id: 'praetexta',
    nom: 'Toge bordée de pourpre',
    nomLatin: 'Toga Praetexta',
    categorie: GoodieCategory.toge,
    prix: 35,
    icone: '🟣',
    description: 'Bordée d’une bande de pourpre phénicienne, symbole des enfants nobles et des magistrats.',
  ),
  GoodieItem(
    id: 'lorica',
    nom: 'Cuirasse de légionnaire',
    nomLatin: 'Lorica Segmentata',
    categorie: GoodieCategory.toge,
    prix: 70,
    icone: '🛡️',
    description: 'Armure d’acier articulée portée par les légions romaines invincibles.',
  ),
  GoodieItem(
    id: 'imperiale',
    nom: 'Toge impériale dorée',
    nomLatin: 'Toga Picta',
    categorie: GoodieCategory.toge,
    prix: 120,
    icone: '✨',
    description: 'Toge de pourpre entièrement brodée d’or, réservée aux généraux en plein Triomphe.',
  ),
  GoodieItem(
    id: 'lorica_squamata',
    nom: 'Armure d’écailles prétorienne',
    nomLatin: 'Lorica Squamata',
    categorie: GoodieCategory.toge,
    prix: 95,
    icone: '🛡️',
    description: 'Armure d’écailles de fer et d’airain portée par les officiers d’élite de l’Empereur.',
  ),

  // 2. COURONNES & CASQUES (Coronae & Galeae)
  GoodieItem(
    id: 'aucune',
    nom: 'Tête découverte',
    nomLatin: 'Sine Corona',
    categorie: GoodieCategory.couronne,
    prix: 0,
    icone: '👤',
    description: 'Chevelure au vent, sans ornement particulier.',
  ),
  GoodieItem(
    id: 'laurier_bronze',
    nom: 'Lauriers de bronze',
    nomLatin: 'Corona Aenea',
    categorie: GoodieCategory.couronne,
    prix: 25,
    icone: '🌿',
    description: 'Couronne de feuilles martelées offerte aux jeunes apprentis valeureux.',
  ),
  GoodieItem(
    id: 'galea_centurio',
    nom: 'Casque de centurion',
    nomLatin: 'Galea Cristata',
    categorie: GoodieCategory.couronne,
    prix: 60,
    icone: '🪖',
    description: 'Casque de bronze massif orné d’un panache de crin écarlate transversal.',
  ),
  GoodieItem(
    id: 'laurier_or',
    nom: 'Couronne de lauriers d’or',
    nomLatin: 'Corona Triumphalis',
    categorie: GoodieCategory.couronne,
    prix: 85,
    icone: '🌿',
    description: 'Le symbole absolu de gloire des poètes illustres et des empereurs romains.',
  ),
  GoodieItem(
    id: 'diademe_vestale',
    nom: 'Diadème d’argent de Minerve',
    nomLatin: 'Diadema Minervae',
    categorie: GoodieCategory.couronne,
    prix: 110,
    icone: '💎',
    description: 'Fin diadème d’argent serti en hommage à la déesse de la sagesse et des arts.',
  ),
  GoodieItem(
    id: 'corona_obsidionalis',
    nom: 'Couronne obsidionale d’herbe',
    nomLatin: 'Corona Obsidionalis',
    categorie: GoodieCategory.couronne,
    prix: 140,
    icone: '🌾',
    description: 'La plus sacrée des distinctions militaires romaines, tressée avec l’herbe du camp sauvé.',
  ),

  // 3. INSIGNES & ARMES (Insignia & Arma)
  GoodieItem(
    id: 'stylet',
    nom: 'Stylet d’écolier',
    nomLatin: 'Stilus Aeneus',
    categorie: GoodieCategory.accessoire,
    prix: 0,
    icone: '✏️',
    description: 'Stylet de bronze permettant de graver la cire sur sa Tabula Cerata.',
  ),
  GoodieItem(
    id: 'volumen',
    nom: 'Parchemin d’orateur',
    nomLatin: 'Volumen Papyri',
    categorie: GoodieCategory.accessoire,
    prix: 20,
    icone: '📜',
    description: 'Rouleau de papyrus précieux calligraphié par les érudits de la bibliothèque d’Alexandrie.',
  ),
  GoodieItem(
    id: 'gladius',
    nom: 'Glaive d’honneur',
    nomLatin: 'Gladius Honoris',
    categorie: GoodieCategory.accessoire,
    prix: 45,
    icone: '⚔️',
    description: 'Épée courte à double tranchant gravée au nom de la République romaine.',
  ),
  GoodieItem(
    id: 'scutum',
    nom: 'Bouclier Scutum SPQR',
    nomLatin: 'Scutum Legionis',
    categorie: GoodieCategory.accessoire,
    prix: 75,
    icone: '🛡️',
    description: 'Grand bouclier rouge incurvé arborant les foudres d’or de Jupiter Capitolin.',
  ),
  GoodieItem(
    id: 'vexillum_spqr',
    nom: 'Étendard pourpre de la Légion',
    nomLatin: 'Vexillum Legionis',
    categorie: GoodieCategory.accessoire,
    prix: 95,
    icone: '🚩',
    description: 'Étendard flottant pourpre aux aigles d’or, guidant les cohortes vers le triomphe.',
  ),
  GoodieItem(
    id: 'fasces',
    nom: 'Faisceau consulaire',
    nomLatin: 'Fasces Lictoriae',
    categorie: GoodieCategory.accessoire,
    prix: 130,
    icone: '🏛️',
    description: 'Les faisceaux de verges entourant la hache, insigne suprême des consuls romains.',
  ),

  // 4. COMPAGNONS ROMAINS (Comites)
  GoodieItem(
    id: 'aucun',
    nom: 'Aucun compagnon',
    nomLatin: 'Solus',
    categorie: GoodieCategory.compagnon,
    prix: 0,
    icone: '🐾',
    description: 'Tu parcours les rues de Rome en solitaire.',
  ),
  GoodieItem(
    id: 'lupulus_jr',
    nom: 'Lupulus Jr le louveteau',
    nomLatin: 'Lupulus Catulus',
    categorie: GoodieCategory.compagnon,
    prix: 40,
    icone: '🐺',
    description: 'Le descendant fidèle de la Louve Capitoline, joueur et toujours prêt pour l’aventure.',
  ),
  GoodieItem(
    id: 'noctua',
    nom: 'Chouette de Minerve',
    nomLatin: 'Noctua Minervae',
    categorie: GoodieCategory.compagnon,
    prix: 65,
    icone: '🦉',
    description: 'Oiseau nocturne de Minerve, déesse de la sagesse, réputé veiller sur les études des savants.',
  ),
  GoodieItem(
    id: 'aquila',
    nom: 'Aigle d’or des Légions',
    nomLatin: 'Aquila Legionaria',
    categorie: GoodieCategory.compagnon,
    prix: 90,
    icone: '🦅',
    description: 'Le rapace sacré planant au-dessus des aigles d’argent des cohortes.',
  ),
  GoodieItem(
    id: 'cerberus_pullus',
    nom: 'Chiot Cerbère loyal',
    nomLatin: 'Cerberus Pullus',
    categorie: GoodieCategory.compagnon,
    prix: 110,
    icone: '🐕',
    description: 'Fidèle gardien à quatre pattes, compagnon des maisons romaines depuis des siècles.',
  ),
  GoodieItem(
    id: 'equus',
    nom: 'Quadrige blanc du Circus',
    nomLatin: 'Equus Cursorius',
    categorie: GoodieCategory.compagnon,
    prix: 125,
    icone: '🐎',
    description: 'Fier coursier blanc galopant sur le sable rouge du Circus Maximus.',
  ),
  GoodieItem(
    id: 'pegasus_aureus',
    nom: 'Pégase ailé céleste',
    nomLatin: 'Pegasus Aureus',
    categorie: GoodieCategory.compagnon,
    prix: 160,
    icone: '🐎',
    description: 'Coursier ailé né des mythes antiques, cher aux poètes et aux artistes.',
  ),
];
