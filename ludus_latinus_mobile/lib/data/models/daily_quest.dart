/// Modèle des quêtes quotidiennes rotatives de Ludus Latinus.
class DailyQuest {
  final String id;
  final String titre;
  final String description;
  final String icone;
  final int recompense;
  final String routeCible; // 'colosseum', 'cesar', 'circus', 'marche', 'memoria', 'forum'

  const DailyQuest({
    required this.id,
    required this.titre,
    required this.description,
    required this.icone,
    required this.recompense,
    required this.routeCible,
  });

  /// Liste des défis quotidiens disponibles dans l'Empire.
  static const List<DailyQuest> pool = [
    DailyQuest(
      id: 'quest_memoria',
      titre: 'Défi de Memoria Velox',
      description: 'Donne 5 bonnes traductions dans Memoria Velox !',
      icone: '🃏',
      recompense: 10,
      routeCible: 'memoria',
    ),
    DailyQuest(
      id: 'quest_circus',
      titre: 'Défi du Circus Maximus',
      description: 'Prends les rênes d\'un quadrige et triomphe dans l\'arène du Grand Cirque !',
      icone: '🐎',
      recompense: 10,
      routeCible: 'circus',
    ),
    DailyQuest(
      id: 'quest_cesar',
      titre: 'Défi de l\'Atelier de César',
      description: 'Déchiffre un message militaire crypté à la cire pour le compte des légions !',
      icone: '📜',
      recompense: 10,
      routeCible: 'cesar',
    ),
    DailyQuest(
      id: 'quest_duel',
      titre: 'Défi du Colosseum Duellum',
      description: 'Terrasse un champion dans l\'arène du Colisée !',
      icone: '⚔️',
      recompense: 10,
      routeCible: 'duel',
    ),
    DailyQuest(
      id: 'quest_marche',
      titre: 'Défi du Marché de Trajan',
      description: 'Gère un étal d\'argentarius et réussis le compte des sesterces romains !',
      icone: '🏺',
      recompense: 10,
      routeCible: 'marche',
    ),
    DailyQuest(
      id: 'quest_taverne',
      titre: 'Défi de la Taverne des Dés',
      description: 'Bats Gaius l\'aubergiste aux dés, à Alea Iacta Est !',
      icone: '🎲',
      recompense: 10,
      routeCible: 'taverne',
    ),
  ];

  /// Sélectionne la quête du jour de façon déterministe selon la date courante,
  /// parmi les activités déjà débloquées : on ne promet pas un jeu verrouillé.
  static DailyQuest getTodayQuest([DateTime? date, bool Function(DailyQuest quest)? isAvailable]) {
    final now = date ?? DateTime.now();
    final candidates = isAvailable == null ? pool : pool.where(isAvailable).toList();
    final choices = candidates.isEmpty ? [pool.first] : candidates;
    // Indexation cyclique sur le jour de l'année
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return choices[dayOfYear % choices.length];
  }
}
