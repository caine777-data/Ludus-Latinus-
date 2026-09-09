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
      description: 'Révise 5 flashcards antiques au dojo pour affûter ta mémoire latine !',
      icone: '🃏',
      recompense: 25,
      routeCible: 'memoria',
    ),
    DailyQuest(
      id: 'quest_circus',
      titre: 'Défi du Circus Maximus',
      description: 'Prends les rênes d\'un quadrige et triomphe dans l\'arène du Grand Cirque !',
      icone: '🏎️',
      recompense: 25,
      routeCible: 'circus',
    ),
    DailyQuest(
      id: 'quest_cesar',
      titre: 'Défi de l\'Atelier de César',
      description: 'Déchiffre un message militaire crypté à la cire pour le compte des légions !',
      icone: '📜',
      recompense: 25,
      routeCible: 'cesar',
    ),
    DailyQuest(
      id: 'quest_duel',
      titre: 'Défi du Colosseum Duellum',
      description: 'Défie un champion dans l\'arène et teste tes postures de combat !',
      icone: '⚔️',
      recompense: 25,
      routeCible: 'duel',
    ),
    DailyQuest(
      id: 'quest_marche',
      titre: 'Défi du Marché de Trajan',
      description: 'Gère un étal d\'argentarius et réussis le compte des sesterces romains !',
      icone: '🏺',
      recompense: 25,
      routeCible: 'marche',
    ),
    DailyQuest(
      id: 'quest_taverne',
      titre: 'Défi de la Taverne des Dés',
      description: 'Lance les dés romains à six faces et défie Gaius à Alea Iacta Est !',
      icone: '🎲',
      recompense: 25,
      routeCible: 'taverne',
    ),
  ];

  /// Sélectionne la quête du jour de façon déterministe selon la date courante.
  static DailyQuest getTodayQuest([DateTime? date]) {
    final now = date ?? DateTime.now();
    // Indexation cyclique sur le jour de l'année
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final index = dayOfYear % pool.length;
    return pool[index];
  }
}
