import 'package:flutter/material.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../../data/repositories/game_repository.dart';
import '../map/map_screen.dart';
import '../memoria/memoria_screen.dart';
import '../forum/forum_screen.dart';
import '../thesaurus/thesaurus_screen.dart';
import '../account/account_screen.dart';

/// Tableau de bord d'accueil mobile de Ludus Latinus.
class HomeScreen extends StatelessWidget {
  final GameRepository repo;

  const HomeScreen({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final profile = repo.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏛️ LUDUS LATINUS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: RomanColors.imperialPurple),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AccountScreen(repo: repo)),
              );
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: repo,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Carte Héros & Statistiques
                RomanCard(
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: RomanColors.goldLight,
                          border: Border.all(color: RomanColors.imperialGold, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            profile.genre == 'fille' ? '👸' : '🤴',
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Citoyen ${profile.nomHeros}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: RomanColors.imperialPurple,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${profile.completedLessons.length} leçons conquises',
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Text('🪙', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 4),
                              Text(
                                '${profile.sesterces} HS',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB8860B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Text('🔥', style: TextStyle(fontSize: 14)),
                              const SizedBox(width: 2),
                              Text(
                                '${profile.streakDays} jours',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 2. Bouton Géant « Continuer la Via Appia »
                RomanCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        '🛣️ LA VIA APPIA',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: RomanColors.imperialPurple,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Poursuis ton épopée sur la grande voie romaine du Cycle 4 !',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                      const SizedBox(height: 14),
                      RomanButton(
                        text: '▶ En Route pour Rome',
                        isLarge: true,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => MapScreen(repo: repo)),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 3. Grille des 4 Modes d'Entraînement Tactiles
                const Text(
                  'Activités du Forum',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: RomanColors.imperialPurple,
                  ),
                ),
                const SizedBox(height: 10),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.25,
                  children: [
                    _buildHubTile(
                      icon: '🃏',
                      title: 'Memoria Velox',
                      subtitle: 'Flashcards SRS',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MemoriaScreen(repo: repo)),
                        );
                      },
                    ),
                    _buildHubTile(
                      icon: '🏛️',
                      title: 'Forum Imperiale',
                      subtitle: 'Reconstruis Rome',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ForumScreen(repo: repo)),
                        );
                      },
                    ),
                    _buildHubTile(
                      icon: '📖',
                      title: 'Thesaurus',
                      subtitle: 'Dictionnaire latin',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ThesaurusScreen(repo: repo)),
                        );
                      },
                    ),
                    _buildHubTile(
                      icon: '📜',
                      title: 'Tabularium',
                      subtitle: 'Compte & Cloud',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AccountScreen(repo: repo)),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHubTile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: RomanColors.imperialGold, width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: RomanColors.imperialPurple,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
