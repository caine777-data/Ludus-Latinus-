/// Chiffres d'équilibre du Duel, sans aucune dépendance à Flutter : ce que
/// l'écran affiche et ce que le code applique viennent de cette seule classe,
/// donc le texte ne peut pas promettre autre chose que le calcul.
library;

/// Les trois postures. Le barème est volontairement lisible :
/// lourde = 50 dégâts et riposte x1,5 ; vive = 35 dégâts et riposte x1 ;
/// parade = 25 dégâts et riposte x0,5.
enum CombatStance {
  gravis('Ictus Gravis', 'Attaque Lourde', '⚔️'),
  celox('Fuga Celox', 'Attaque Vive', '💨'),
  scutum('Scuti Paratio', 'Parade au Scutum', '🛡️');

  final String latin;
  final String francais;
  final String emoji;

  const CombatStance(this.latin, this.francais, this.emoji);

  String get nom => francais;
  String get titre => latin;

  /// Dégâts infligés au boss par une bonne réponse.
  int get degats => DuelEquilibre.degatsDeBase(this);

  /// Multiplicateur de la riposte du boss en cas d'erreur.
  double get riposteMult => DuelEquilibre.multiplicateurRiposte(this);

  /// Texte affiché à l'élève : exactement ce que fait le code.
  String get description => DuelEquilibre.description(this);
}

class DuelEquilibre {
  const DuelEquilibre._();

  /// Points de vie du joueur à chaque combat.
  static const int pvJoueur = 100;

  /// Points de vie de chaque boss, du premier au dernier.
  static const List<int> pvBoss = [100, 130, 160, 200, 250];

  /// Dégâts de la riposte de chaque boss (avant multiplicateur de posture).
  static const List<int> attaqueBoss = [20, 25, 30, 35, 40];

  /// Coup critique de l'attaque vive : réponse en [secondesCritique] secondes
  /// au plus, dégâts x[multCritique], et [bonusCritique] points de plus.
  static const int secondesCritique = 4;
  static const double multCritique = 1.25;
  static const int bonusCritique = 10;

  static int degatsDeBase(CombatStance p) => switch (p) {
        CombatStance.gravis => 50,
        CombatStance.celox => 35,
        CombatStance.scutum => 25,
      };

  static double multiplicateurRiposte(CombatStance p) => switch (p) {
        CombatStance.gravis => 1.5,
        CombatStance.celox => 1.0,
        CombatStance.scutum => 0.5,
      };

  /// Dégâts d'une bonne réponse ; [critique] ne compte que pour l'attaque vive.
  static int degats(CombatStance p, {bool critique = false}) {
    final base = degatsDeBase(p);
    if (critique && p == CombatStance.celox) return (base * multCritique).round();
    return base;
  }

  /// Dégâts encaissés par le joueur en cas d'erreur au boss d'indice [boss].
  static int riposte(CombatStance p, int boss) =>
      (attaqueBoss[boss] * multiplicateurRiposte(p)).round();

  /// Nombre de bonnes réponses (sans critique) pour battre le boss d'indice [boss].
  static int reponsesPourVaincre(CombatStance p, int boss) =>
      (pvBoss[boss] / degats(p)).ceil();

  /// Nombre d'erreurs qui mettent le joueur à terre (la dernière est fatale).
  static int erreursPourPerdre(CombatStance p, int boss) =>
      (pvJoueur / riposte(p, boss)).ceil();

  /// Fenêtre de mondes récents pour les questions du boss d'indice [boss] :
  /// les [fenetre] derniers rangs de mondes. `null` : tous les mondes atteints.
  /// Les deux premiers boss piochent partout, les trois derniers de plus en
  /// plus près des mondes les plus récents.
  static int? fenetreMondes(int boss) => switch (boss) {
        < 2 => null,
        2 => 6,
        3 => 4,
        _ => 3,
      };

  static String description(CombatStance p) {
    final d = degats(p);
    final r = (multiplicateurRiposte(p) * 100).round();
    return switch (p) {
      CombatStance.gravis =>
        'Bonne réponse : $d dégâts. Erreur : riposte à $r % (la plus forte).',
      CombatStance.celox =>
        'Bonne réponse : $d dégâts, ${degats(p, critique: true)} et '
            '+$bonusCritique pts en moins de $secondesCritique s. Erreur : riposte à $r %.',
      CombatStance.scutum =>
        'Bonne réponse : $d dégâts (les plus faibles). Erreur : riposte réduite à $r %.',
    };
  }
}
