import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../core/particles_overlay.dart';
import '../../core/lottie_effects.dart';
import '../../core/cinematic_player.dart';
import '../../core/game_juice.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
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
import '../lesson/lesson_screen.dart';
import '../../../data/models/cursus_honorum.dart';
import '../../../data/models/daily_quest.dart';
import '../../../data/models/profile.dart';
import '../../../data/models/lesson.dart';
import '../../../data/models/world.dart';

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
            icon: Icon(
              widget.repo.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              color: widget.repo.isDarkMode ? RomanColors.imperialGold : RomanColors.imperialPurple,
              size: 22,
            ),
            tooltip: widget.repo.isDarkMode ? 'Mode Lux Romana (Jour)' : 'Mode Noctis Romana (Nuit)',
            onPressed: () {
              HapticFeedback.lightImpact();
              AudioService().playCardFlip();
              widget.repo.toggleThemeMode();
            },
          ),
          IconButton(
            icon: Icon(
              AudioService().isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
              color: widget.repo.isDarkMode ? RomanColors.imperialGold : RomanColors.imperialPurple,
              size: 24,
            ),
            tooltip: 'Harmonia Antiqua (Réglages Audio & Bruitages)',
            onPressed: () {
              RomanAudioModal.show(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.casino_outlined, color: RomanColors.imperialPurple, size: 26),
            tooltip: 'Taverne des Dés Romains (Alea Iacta Est)',
            onPressed: () {
              AudioService().playDiceRoll();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TaverneScreen(repo: widget.repo)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: RomanColors.imperialPurple, size: 28),
            tooltip: 'Tabularium & Profil',
            onPressed: () {
              AudioService().playCardFlip();
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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
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
                            InkWell(
                              onTap: () => _showCursusHonorumModal(context, profile),
                              borderRadius: BorderRadius.circular(8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: RomanColors.goldLight,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: RomanColors.imperialGold, width: 1),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(profile.cursusRank.badge, style: const TextStyle(fontSize: 12)),
                                        const SizedBox(width: 3),
                                        Text(
                                          profile.cursusRank.titre,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF684900),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.info_outline, size: 14, color: RomanColors.imperialGold),
                                ],
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              profile.nomHeros,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                color: RomanColors.imperialPurple,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${profile.completedLessons.length} / ${widget.repo.worlds.fold<int>(0, (sum, w) => sum + w.lessons.length)} leçons conquises',
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
                            child: RollingSestercesCounter(
                              value: profile.sesterces,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7A5901),
                              ),
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
                                  '${profile.streakDays} jours',
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
                  emotion: 'normal',
                  message: '« Salve ${profile.nomHeros} ! Rome ne s’est pas faite en un jour. Poursuis ta marche triomphale ! »',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🐺 Lupulus t\'adresse son salut légionnaire : "Per aspera ad astra !"'),
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

                const SizedBox(height: 10),
                const RomanMeanderDivider(height: 12, strokeWidth: 1.2, margin: EdgeInsets.symmetric(vertical: 4)),
                const SizedBox(height: 8),

                // 3.bis Section Pédagogique : Leçons du Programme Officiel du Collège
                _buildCurriculumLessonsSection(),

                const SizedBox(height: 16),

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
                          AudioService().playTriumph();
                          RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
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

                // 5. Carte « Défi du Jour » dynamique (+25 HS)
                Builder(
                  builder: (context) {
                    final dailyQuest = DailyQuest.getTodayQuest();
                    final isDone = profile.isDailyQuestCompletedToday;

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDone ? const Color(0xFFF2FBF5) : const Color(0xFFFFFBF0),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDone ? RomanColors.laurelGreen : RomanColors.imperialGold,
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(isDone ? '🌿' : dailyQuest.icone, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dailyQuest.titre,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isDone ? const Color(0xFF166534) : const Color(0xFF7A4E0B),
                                  ),
                                ),
                                Text(
                                  isDone
                                      ? 'Défi accompli ! Reviens demain pour une nouvelle quête.'
                                      : dailyQuest.description,
                                  style: const TextStyle(fontSize: 11.5, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (isDone)
                            const RomanWaxSeal(
                              size: 40,
                              label: 'SPQR',
                              sealColor: RomanColors.laurelGreen,
                              stampColor: Color(0xFFFFDF85),
                            )
                          else
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: RomanColors.imperialPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {
                                RomanLottieEffects.showChestReward(
                                  context,
                                  sestercesReward: dailyQuest.recompense,
                                  questTitle: dailyQuest.titre,
                                  onClaim: () {
                                    widget.repo.completeDailyQuest(dailyQuest.recompense);
                                    setState(() {});
                                    _navigateToQuestTarget(context, dailyQuest.routeCible);
                                  },
                                );
                              },
                              child: Text('🎁 +${dailyQuest.recompense} HS'),
                            ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 18),

                // 6. Grille des 4 Ateliers du Forum avec vraies illustrations antiques
                const Text(
                  '🏛️ Ateliers du Forum Romanum (Pratique & Outils)',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.4,
                    color: RomanColors.imperialPurple,
                  ),
                ),
                const SizedBox(height: 10),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth >= 520;
                    return GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: isDesktop ? 3.4 : 1.32,
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
                    );
                  },
                ),
                const SizedBox(height: 18),

                // 7. Grille des Jeux & Défis de l'Empire
                const Text(
                  '⚔️ Jeux & Défis de l\'Empire (Loisirs & Arène)',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.4,
                    color: RomanColors.imperialPurple,
                  ),
                ),
                const SizedBox(height: 10),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth >= 520;
                    return GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: isDesktop ? 3.4 : 1.32,
                      children: [
                        _buildArtworkTile(
                          imagePath: 'assets/images/boss_mercure_140.png',
                          fallbackIcon: '🎲',
                          title: 'Alea Iacta Est',
                          subtitle: 'Taverne & Dés Romains',
                          onTap: () {
                            AudioService().playDiceRoll();
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
                            AudioService().playSesterces();
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
                            AudioService().playWheelClick();
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
                            AudioService().playTriumph();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => PantheonScreen(repo: widget.repo)),
                            );
                          },
                        ),
                        _buildArtworkTile(
                          imagePath: 'assets/images/circus/chariot_bleu.png',
                          fallbackIcon: '🐎',
                          title: 'Circus Maximus',
                          subtitle: 'Course de Chars & Turbo',
                          onTap: () {
                            AudioService().playCrowdCheer();
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
                            AudioService().playSwordClash();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => DuelScreen(repo: widget.repo)),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
        },
      ),
    );
  }

  List<Lesson> _getLessonsForClass(int classIndex) {
    if (widget.repo.classes.isEmpty) return [];
    final classIdx = classIndex.clamp(0, widget.repo.classes.length - 1);
    final targetClass = widget.repo.classes[classIdx];
    final classWorlds = widget.repo.worlds
        .where((w) => targetClass.mondesIds.contains(w.id))
        .toList();
    final lessons = <Lesson>[];
    for (final w in classWorlds) {
      lessons.addAll(w.lessons);
    }
    return lessons;
  }

  String _getLessonTypeTitle(String type) {
    switch (type) {
      case 'quiz':
        return 'QCM Grammaire & Vocabulaire';
      case 'puzzle':
        return 'Syntaxe & Ordre des Mots';
      case 'trou':
        return 'Déclinaisons & Cas Latins';
      case 'arene':
        return 'Épreuve d\'Arène';
      case 'decodeur':
        return 'Épigraphie & Décodage';
      default:
        return 'Leçon & Exercice';
    }
  }

  String _getLessonTypeIcon(String type) {
    switch (type) {
      case 'quiz':
        return '📜';
      case 'puzzle':
        return '🧩';
      case 'trou':
        return '✏️';
      case 'arene':
        return '⚔️';
      case 'decodeur':
        return '🔍';
      default:
        return '🏛️';
    }
  }

  Color _getLessonTypeColor(String type) {
    switch (type) {
      case 'quiz':
        return const Color(0xFF1E5B94);
      case 'puzzle':
        return const Color(0xFFB37400);
      case 'trou':
        return RomanColors.imperialPurple;
      case 'arene':
        return const Color(0xFFB3261E);
      case 'decodeur':
        return const Color(0xFF0D6E6E);
      default:
        return RomanColors.imperialPurple;
    }
  }

  Widget _buildCurriculumLessonsSection() {
    final classLessons = _getLessonsForClass(_selectedClassIndex);
    if (classLessons.isEmpty) return const SizedBox.shrink();

    final completedInClass = classLessons.where((l) => widget.repo.isLessonCompleted(l.id)).length;
    final totalInClass = classLessons.length;
    final ratio = (completedInClass / totalInClass).clamp(0.0, 1.0);

    // Première leçon non complétée (ou dernière si tout est fini)
    final activeLesson = classLessons.firstWhere(
      (l) => !widget.repo.isLessonCompleted(l.id),
      orElse: () => classLessons.last,
    );
    final isActiveCompleted = widget.repo.isLessonCompleted(activeLesson.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // En-tête de section académique
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text('📚 ', style: TextStyle(fontSize: 16)),
                Text(
                  'PROGRAMME ${_classTitles[_selectedClassIndex].toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: RomanColors.imperialPurple,
                    fontFamily: 'serif',
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: RomanColors.goldLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: RomanColors.imperialGold, width: 1),
              ),
              child: Text(
                '$completedInClass / $totalInClass terminées',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A5901),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Jauge de progression du niveau
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            backgroundColor: const Color(0xFFEADBCE),
            valueColor: const AlwaysStoppedAnimation<Color>(RomanColors.laurelGreen),
          ),
        ),
        const SizedBox(height: 12),

        // Carte V.I.P : Leçon Prioritaire / Suivante
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: RomanColors.imperialGold, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14D4AF37),
                offset: Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Type de leçon pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _getLessonTypeColor(activeLesson.type).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getLessonTypeColor(activeLesson.type),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_getLessonTypeIcon(activeLesson.type), style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          _getLessonTypeTitle(activeLesson.type),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _getLessonTypeColor(activeLesson.type),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Statut
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isActiveCompleted ? const Color(0xFFE8F5E9) : const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isActiveCompleted ? '✓ MAÎTRISÉE ⭐⭐⭐' : '▶ LEÇON SUIVANTE',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: isActiveCompleted ? const Color(0xFF2E7D32) : const Color(0xFFB37400),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Titre de la leçon
              Text(
                activeLesson.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: RomanColors.imperialPurple,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 4),

              // Extrait ou consigne
              Text(
                activeLesson.content.isNotEmpty
                    ? (activeLesson.content.length > 100
                        ? '${activeLesson.content.substring(0, 100)}...'
                        : activeLesson.content)
                    : (activeLesson.question ?? 'Exercice interactif du collège.'),
                style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.3),
              ),
              const SizedBox(height: 14),

              // Boutons d'action : Commencer la leçon
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        AudioService().playTriumph();
                        RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LessonScreen(repo: widget.repo, lesson: activeLesson),
                          ),
                        );
                      },
                      icon: Icon(
                        isActiveCompleted ? Icons.replay_rounded : Icons.play_arrow_rounded,
                        size: 20,
                      ),
                      label: Text(
                        isActiveCompleted ? 'RÉVISER LA LEÇON' : 'COMMENCER LA LEÇON ▶',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RomanColors.imperialPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
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
                    icon: const Icon(Icons.map_outlined, size: 16),
                    label: const Text('Via Appia', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: RomanColors.imperialPurple,
                      side: const BorderSide(color: RomanColors.imperialPurple),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Bandeau de défilement horizontal de TOUTES les leçons du niveau
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Feuilleter toutes les étapes de ce niveau :',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Colors.black54),
            ),
            Text(
              '${classLessons.length} étapes',
              style: const TextStyle(fontSize: 11, color: RomanColors.imperialPurple, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),

        SizedBox(
          height: 104,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: classLessons.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, idx) {
              final l = classLessons[idx];
              final isDone = widget.repo.isLessonCompleted(l.id);
              final isCurrent = (l.id == activeLesson.id);

              return InkWell(
                onTap: () {
                  AudioService().playCardFlip();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonScreen(repo: widget.repo, lesson: l),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 140,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? RomanColors.goldLight
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCurrent
                          ? RomanColors.imperialGold
                          : isDone
                              ? const Color(0xFFC8E6C9)
                              : RomanColors.marbleBorder,
                      width: isCurrent ? 1.8 : 1.0,
                    ),
                    boxShadow: const [
                      BoxShadow(color: Color(0x0A000000), offset: Offset(0, 2), blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: _getLessonTypeColor(l.type).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${_getLessonTypeIcon(l.type)} ${idx + 1}',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: _getLessonTypeColor(l.type),
                              ),
                            ),
                          ),
                          if (isDone)
                            const Text('⭐⭐⭐', style: TextStyle(fontSize: 9))
                          else if (isCurrent)
                            const Text('📍 ICI', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF7A5901))),
                        ],
                      ),
                      Text(
                        l.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: RomanColors.charcoal,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            isDone ? Icons.check_circle : Icons.play_circle_outline,
                            size: 13,
                            color: isDone ? Colors.green : RomanColors.imperialPurple,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            isDone ? 'Maîtrisée' : 'Explorer',
                            style: TextStyle(
                              fontSize: 9.5,
                              color: isDone ? Colors.green.shade700 : RomanColors.imperialPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildArtworkTile({
    required String imagePath,
    required String fallbackIcon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 210;

        return InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 14 : 10,
              vertical: isWide ? 10 : 8,
            ),
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
            child: isWide
                ? Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: RomanColors.goldLight,
                          border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x15000000),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: RomanColors.imperialPurple,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: RomanColors.imperialGold,
                        size: 20,
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
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
                              child: Text(fallbackIcon, style: const TextStyle(fontSize: 20)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: RomanColors.imperialPurple,
                        ),
                      ),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10, color: Colors.black54),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  void _navigateToQuestTarget(BuildContext context, String target) {
    switch (target) {
      case 'memoria':
        Navigator.push(context, MaterialPageRoute(builder: (_) => MemoriaScreen(repo: widget.repo)));
        break;
      case 'circus':
        Navigator.push(context, MaterialPageRoute(builder: (_) => CircusMaximusScreen(repo: widget.repo)));
        break;
      case 'cesar':
        Navigator.push(context, MaterialPageRoute(builder: (_) => CesarScreen(repo: widget.repo)));
        break;
      case 'duel':
        Navigator.push(context, MaterialPageRoute(builder: (_) => DuelScreen(repo: widget.repo)));
        break;
      case 'marche':
        Navigator.push(context, MaterialPageRoute(builder: (_) => MarcheTrajanScreen(repo: widget.repo)));
        break;
      case 'taverne':
        Navigator.push(context, MaterialPageRoute(builder: (_) => TaverneScreen(repo: widget.repo)));
        break;
      case 'forum':
        Navigator.push(context, MaterialPageRoute(builder: (_) => ForumScreen(repo: widget.repo)));
        break;
      default:
        Navigator.push(context, MaterialPageRoute(builder: (_) => MemoriaScreen(repo: widget.repo)));
    }
  }

  void _showCursusHonorumModal(BuildContext context, UserProfile profile) {
    AudioService().playCardFlip();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final currentRank = profile.cursusRank;
        final nextRank = CursusHonorum.getNextRank(currentRank);

        return Container(
          height: MediaQuery.of(ctx).size.height * 0.85,
          decoration: const BoxDecoration(
            color: RomanColors.palatinCream,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(color: Colors.black45, blurRadius: 20, offset: Offset(0, -4)),
            ],
          ),
          child: Column(
            children: [
              // Barre de tirage
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 44,
                height: 4.5,
                decoration: BoxDecoration(
                  color: RomanColors.marbleBorder,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),

              // En-tête
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: RomanColors.goldLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: RomanColors.imperialGold),
                      ),
                      child: const Text('🦅', style: TextStyle(fontSize: 22)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'CURSUS HONORUM',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: RomanColors.imperialGold,
                            ),
                          ),
                          Text(
                            'Carrière des Honneurs Romains',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'serif',
                              color: RomanColors.imperialPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: RomanColors.marbleBorder),

              // Carte du Rang Actuel
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5A121E), Color(0xFF2C070F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        RomanLottieEffects.showLaurelTriumph(
                          context,
                          title: currentRank.titre,
                          subtitle: currentRank.sousTitre,
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const RomanLottieWidget(
                            assetName: 'laurel_wreath.json',
                            width: 60,
                            height: 60,
                            repeat: true,
                          ),
                          Text(currentRank.badge, style: const TextStyle(fontSize: 22)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TON RANG ACTUEL : ${currentRank.titre.toUpperCase()}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: RomanColors.imperialGold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            currentRank.sousTitre,
                            style: const TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            nextRank != null
                                ? 'Prochain rang : ${nextRank.titre} (${nextRank.leconsRequises} leçons, ${nextRank.monumentsRequis} édifice(s), ${nextRank.sestercesRequis} HS)'
                                : '👑 Tu as atteint le sommet du Cursus Honorum !',
                            style: const TextStyle(fontSize: 11, color: Color(0xFFFFD54F), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Boutons Cinématiques Antiques
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: RomanColors.imperialPurple,
                          side: const BorderSide(color: RomanColors.imperialPurple, width: 1.2),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.play_circle_fill_rounded, size: 16),
                        label: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'TRIOMPHE (ARC)',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                        ),
                        onPressed: () {
                          RomanCinematicOverlay.showTriumph(
                            context,
                            rankTitle: currentRank.titre,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF8A5B00),
                          side: const BorderSide(color: RomanColors.imperialGold, width: 1.2),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.play_circle_outline, size: 16, color: RomanColors.imperialGold),
                        label: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'INTRO (AIGLE)',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                        ),
                        onPressed: () {
                          RomanCinematicOverlay.showIntro(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Liste des 7 échelons
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: CursusHonorum.echelons.length,
                  itemBuilder: (context, index) {
                    final rank = CursusHonorum.echelons[index];
                    final isCurrent = (rank.titre == currentRank.titre);
                    final isUnlocked = profile.completedLessons.length >= rank.leconsRequises &&
                        profile.restoredMonuments.length >= rank.monumentsRequis &&
                        profile.sesterces >= rank.sestercesRequis;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? const Color(0xFFFFF9E6)
                            : isUnlocked
                                ? Colors.white
                                : const Color(0xFFF5F2EC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isCurrent
                              ? RomanColors.imperialGold
                              : isUnlocked
                                  ? RomanColors.marbleBorder
                                  : Colors.transparent,
                          width: isCurrent ? 1.8 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isUnlocked ? RomanColors.goldLight : Colors.grey.shade300,
                              border: Border.all(
                                color: isUnlocked ? RomanColors.imperialGold : Colors.grey.shade400,
                              ),
                            ),
                            child: Text(isUnlocked ? rank.badge : '🔒', style: const TextStyle(fontSize: 20)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      rank.titre,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isUnlocked ? RomanColors.charcoal : Colors.grey,
                                      ),
                                    ),
                                    if (isCurrent) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: RomanColors.imperialPurple,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'TOI',
                                          style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Text(
                                  rank.sousTitre,
                                  style: TextStyle(fontSize: 11, color: isUnlocked ? RomanColors.imperialPurple : Colors.grey),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Requis : ${rank.leconsRequises} leçons • ${rank.monumentsRequis} édifice(s) • ${rank.sestercesRequis} HS',
                                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}