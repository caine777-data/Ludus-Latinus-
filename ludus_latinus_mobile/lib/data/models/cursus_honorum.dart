/// Système républicain du Cursus Honorum pour Ludus Latinus.
class CursusHonorum {
  final String titre;
  final String sousTitre;
  final String badge;
  final String description;
  final int leconsRequises;
  final int monumentsRequis;
  final int sestercesRequis;

  const CursusHonorum({
    required this.titre,
    required this.sousTitre,
    required this.badge,
    required this.description,
    required this.leconsRequises,
    required this.monumentsRequis,
    required this.sestercesRequis,
  });

  static const List<CursusHonorum> echelons = [
    CursusHonorum(
      titre: 'Tiro',
      sousTitre: 'Apprenti du Forum',
      badge: '🌱',
      description: 'Le jeune disciple qui découvre les premiers mystères de la langue latine.',
      leconsRequises: 0,
      monumentsRequis: 0,
      sestercesRequis: 0,
    ),
    CursusHonorum(
      titre: 'Civis Romanus',
      sousTitre: 'Citoyen de plein droit',
      badge: '🏛️',
      description: 'Porteur de la toge virile, admis aux comices et reconnu par la cité.',
      leconsRequises: 3,
      monumentsRequis: 0,
      sestercesRequis: 50,
    ),
    CursusHonorum(
      titre: 'Quaestor',
      sousTitre: 'Trésorier du Peuple',
      badge: '🪙',
      description: 'Gestionnaire rigoureux des finances publiques et de l\'Aérarium de Saturne.',
      leconsRequises: 7,
      monumentsRequis: 1,
      sestercesRequis: 100,
    ),
    CursusHonorum(
      titre: 'Aedilis',
      sousTitre: 'Édile des Bâtiments & des Jeux',
      badge: '🎭',
      description: 'Organisateur des grands jeux du cirque et gardien des temples sacrés.',
      leconsRequises: 12,
      monumentsRequis: 2,
      sestercesRequis: 200,
    ),
    CursusHonorum(
      titre: 'Praetor',
      sousTitre: 'Préteur & Juge Suprême',
      badge: '⚖️',
      description: 'Magistrat du droit et de la justice romaine, entouré de ses licteurs.',
      leconsRequises: 18,
      monumentsRequis: 3,
      sestercesRequis: 350,
    ),
    CursusHonorum(
      titre: 'Consul',
      sousTitre: 'Chef Suprême de la République',
      badge: '👑',
      description: 'Plus haute magistrature de Rome, commandant des légions et du Sénat.',
      leconsRequises: 22,
      monumentsRequis: 5,
      sestercesRequis: 500,
    ),
    CursusHonorum(
      titre: 'Censor',
      sousTitre: 'Gardien des Mœurs & des Fastes',
      badge: '🦅',
      description: 'Dignité suprême de la République veillant sur le rang de chaque citoyen.',
      leconsRequises: 26,
      monumentsRequis: 6,
      sestercesRequis: 800,
    ),
  ];

  static CursusHonorum getRank(int completedLessons, int restoredMonuments, int sesterces) {
    CursusHonorum current = echelons.first;
    for (final e in echelons) {
      if (completedLessons >= e.leconsRequises &&
          restoredMonuments >= e.monumentsRequis &&
          sesterces >= e.sestercesRequis) {
        current = e;
      }
    }
    return current;
  }

  static CursusHonorum? getNextRank(CursusHonorum current) {
    int idx = echelons.indexOf(current);
    if (idx >= 0 && idx < echelons.length - 1) {
      return echelons[idx + 1];
    }
    return null;
  }
}
