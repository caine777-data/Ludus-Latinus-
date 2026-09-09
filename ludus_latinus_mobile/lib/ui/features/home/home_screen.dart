import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../../data/repositories/game_repository.dart';
import '../map/map_screen.dart';
import '../memoria/memoria_screen.dart';
import '../forum/forum_screen.dart';
import '../thesaurus/thesaurus_screen.dart';
import '../taverne/taverne_screen.dart';
import '../account/account_screen.dart';
import '../marche/marche_trajan_screen.dart';
import '../cesar/cesar_screen.dart';
import '../pantheon/pantheon_screen.dart';
import '../circus/circus_screen.dart';
import '../duel/duel_screen.dart';

/// Tableau de bord d''accueil mobile au niveau artistique et architectural de Monument Valley.
class HomeScreen extends StatefulWidget {
  final GameRepository repo;

  const HomeScreen({super.key, required this.repo});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedClassIndex = 0; // 0 = 5ème, 1 = 4ème, 2 = 3ème
  final List<String> _classTitles = ['5ème • Origines', '4ème • République', '3ème • Empire'];

  @override
  Widget build(BuildContext context) {
    final profile = widget.repo.profile;
    final avatarImg = profile.genre == 'fille'
        ? 'assets/images/avatar_fille_medaillon_140.png'
        : 'assets/images/avatar_garcon_medaillon_140.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text('LUDUS LATINUS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.casino_outlined, color: RomanColors.imperialPurple, size: 26),
            tooltip: 'Taverne des Dés Romains (Alea Iacta Est)',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TaverneScreen(repo: widget.repo)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: RomanColors.imperialPurple, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AccountScreen(repo: widget.repo)),
              );
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: widget.repo,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Carte Héros & Statistiques (Marbre Travertin sculpté)
                RomanCard(
                  child: Row(
                    children: [
                      RomanMedallion(
                        imagePath: avatarImg,
                        size: 64,
                        fallbackEmoji: profile.genre == 'fille' ? '👸' : '🤴',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AccountScreen(repo: widget.repo)),
                          );
                        },
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Citoyen ',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                color: RomanColors.imperialPurple,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              ' leçons conquises sur la Via Appia',
                              style: const TextStyle(fontSize: 11.5, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: RomanColors.goldLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: RomanColors.imperialGold),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('🪙', style: TextStyle(fontSize: 13)),
                                const SizedBox(width: 4),
                                Text(
                                  ' HS',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7A5901),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0EC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('🔥', style: TextStyle(fontSize: 12)),
                                const SizedBox(width: 3),
                                Text(
                                  ' jours',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // 2. Mascotte Lupulus vivante avec bulle de dialogue
                LupulusDialogue(
                  emotion: 'joie',
                  message: '« Salve  ! Rome ne s’est pas faite en un jour. Poursuis ta marche triomphale ! »',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🐺 Lupulus t''encourage : "Per aspera ad astra !"'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // 3. Sélecteur de Classe du Collège (Onglets Romains)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_classTitles.length, (index) {
                      final isSelected = _selectedClassIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(_classTitles[index]),
                          selected: isSelected,
                          selectedColor: RomanColors.imperialPurple,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : RomanColors.charcoal,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 12,
                          ),
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: isSelected ? RomanColors.imperialPurple : const Color(0xFFE2D6C5),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              HapticFeedback.selectionClick();
                              setState(() => _selectedClassIndex = index);
                            }
                          },
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 14),

                // 4. Bannière Héroïque « La Via Appia » (Style Monument Valley)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5A121E), Color(0xFF330811)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3344101A),
                        offset: Offset(0, 6),
                        blurRadius: 14,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFFF0D0),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/logo_centurion_64.png',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Text('🏛️', style: TextStyle(fontSize: 18)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'LA VIA APPIA',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontFamily: 'serif',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Chaussée pavée polygonale • 26 étapes milliaires • Cycle 4',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Color(0xFFE5D5C5)),
                      ),
                      const SizedBox(height: 16),
                      RomanButton(
                        text: '▶ AVANCER SUR LA ROUTE',
                        isLarge: true,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MapScreen(
                                repo: widget.repo,
                                initialClassFilter: _selectedClassIndex,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 5. Carte « Défi du Jour » (+25 HS)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBF0),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      const Text('🎯', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Défi du Jour : Memoria Velox',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7A4E0B),
                              ),
                            ),
                            Text(
                              'Révise 5 flashcards au dojo pour remporter 25 sesterces !',
                              style: TextStyle(fontSize: 11.5, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: RomanColors.imperialPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => MemoriaScreen(repo: widget.repo)),
                          );
                        },
                        child: const Text('Relever'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // 6. Grille des 4 Ateliers du Forum avec vraies illustrations antiques
                const Text(
                  'Ateliers du Forum Romanum',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.4,
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
                  childAspectRatio: 1.28,
                  children: [
                    _buildArtworkTile(
                      imagePath: 'assets/images/musee_circus.png',
                      fallbackIcon: '🃏',
                      title: 'Memoria Velox',
                      subtitle: 'Flashcards 3D Leitner',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MemoriaScreen(repo: widget.repo)),
                        );
                      },
                    ),
                    _buildArtworkTile(
                      imagePath: 'assets/images/musee_thermes.png',
                      fallbackIcon: '🏛️',
                      title: 'Forum Imperiale',
                      subtitle: 'Restaure 6 édifices',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ForumScreen(repo: widget.repo)),
                        );
                      },
                    ),
                    _buildArtworkTile(
                      imagePath: 'assets/images/musee_louve.png',
                      fallbackIcon: '📖',
                      title: 'Thesaurus',
                      subtitle: 'Dictionnaire & Tables',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ThesaurusScreen(repo: widget.repo)),
                        );
                      },
                    ),
                    _buildArtworkTile(
                      imagePath: 'assets/images/logo_centurion_64.png',
                      fallbackIcon: '📜',
                      title: 'Tabularium',
                      subtitle: 'Compte & Tessera',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AccountScreen(repo: widget.repo)),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // 7. Grille des Jeux & Défis de l'Empire
                const Text(
                  'Jeux & Défis de l\'Empire',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.4,
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
                  childAspectRatio: 1.28,
                  children: [
                    _buildArtworkTile(
                      imagePath: 'assets/images/boss_mercure_140.png',
                      fallbackIcon: '🎲',
                      title: 'Alea Iacta Est',
                      subtitle: 'Taverne & Dés Romains',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => TaverneScreen(repo: widget.repo)),
                        );
                      },
                    ),
                    _buildArtworkTile(
                      imagePath: 'assets/images/lupulus/lupulus_savant.png',
                      fallbackIcon: '🏺',
                      title: 'Marché de Trajan',
                      subtitle: 'Chiffres Romains & Étal',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MarcheTrajanScreen(repo: widget.repo)),
                        );
                      },
                    ),
                    _buildArtworkTile(
                      imagePath: 'assets/images/lupulus/lupulus_imperator.png',
                      fallbackIcon: '📜',
                      title: 'Atelier de César',
                      subtitle: 'Cryptographie Militaire',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CesarScreen(repo: widget.repo)),
                        );
                      },
                    ),
                    _buildArtworkTile(
                      imagePath: 'assets/images/trophee_triomphe_medaillon_130.png',
                      fallbackIcon: '🏆',
                      title: 'Le Panthéon',
                      subtitle: 'Album des Reliques',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PantheonScreen(repo: widget.repo)),
                        );
                      },
                    ),
                    _buildArtworkTile(
                      imagePath: 'assets/images/circus/chariot_bleu.png',
                      fallbackIcon: '🏎️',
                      title: 'Circus Maximus',
                      subtitle: 'Course de Chars & Turbo',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CircusMaximusScreen(repo: widget.repo)),
                        );
                      },
                    ),
                    _buildArtworkTile(
                      imagePath: 'assets/images/boss_gladiateur_140.png',
                      fallbackIcon: '⚔️',
                      title: 'Colosseum Duellum',
                      subtitle: 'Arène des Champions',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DuelScreen(repo: widget.repo)),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildArtworkTile({
    required String imagePath,
    required String fallbackIcon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: RomanColors.marbleBorder, width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              offset: Offset(0, 3),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: RomanColors.goldLight,
                border: Border.all(color: RomanColors.imperialGold, width: 1.2),
              ),
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Center(
                    child: Text(fallbackIcon, style: const TextStyle(fontSize: 22)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: RomanColors.imperialPurple,
              ),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}