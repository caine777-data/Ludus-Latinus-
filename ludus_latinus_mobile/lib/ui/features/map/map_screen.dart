import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../../data/models/world.dart';
import '../../../data/models/lesson.dart';
import '../../../data/repositories/game_repository.dart';
import '../lesson/lesson_screen.dart';

/// La Carte d''Aventure de la Via Appia inspirée de l''esthétique de Monument Valley.
class MapScreen extends StatefulWidget {
  final GameRepository repo;
  final int initialClassFilter;

  const MapScreen({
    super.key,
    required this.repo,
    this.initialClassFilter = 0,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late int _activeFilter; // 0 = Tous, 1 = 5ème, 2 = 4ème, 3 = 3ème

  @override
  void initState() {
    super.initState();
    _activeFilter = widget.initialClassFilter == 0 ? 0 : widget.initialClassFilter;
  }

  List<World> _getFilteredWorlds() {
    final all = widget.repo.worlds;
    if (_activeFilter == 0) return all;

    final classes = widget.repo.classes;
    if (classes.isEmpty) return all;

    int classIdx = (_activeFilter - 1).clamp(0, classes.length - 1);
    final targetClass = classes[classIdx];
    return all.where((w) => targetClass.mondesIds.contains(w.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final worlds = _getFilteredWorlds();
    final profile = widget.repo.profile;
    final totalLessons = widget.repo.worlds.fold<int>(0, (sum, w) => sum + w.lessons.length);
    final completedCount = profile.completedLessons.length;
    final progressRatio = totalLessons > 0 ? (completedCount / totalLessons).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('VIA APPIA PANORAMIQUE'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: RomanColors.goldLight,
              borderRadius: BorderRadius.circular(14),
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
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5,
                    color: Color(0xFF7A5901),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Barre Supérieure Flottante : Progression & Filtres Cursus
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0C000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Épopée Romaine :  /  étapes',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: RomanColors.imperialPurple,
                      ),
                    ),
                    Text(
                      '%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: RomanColors.laurelGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progressRatio,
                    minHeight: 7,
                    backgroundColor: const Color(0xFFEBE3D7),
                    valueColor: const AlwaysStoppedAnimation<Color>(RomanColors.imperialGold),
                  ),
                ),
                const SizedBox(height: 10),
                // Filtres de classes
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildClassChip(0, 'Tout le Cycle 4'),
                      const SizedBox(width: 6),
                      _buildClassChip(1, '5ème • Origines'),
                      const SizedBox(width: 6),
                      _buildClassChip(2, '4ème • République'),
                      const SizedBox(width: 6),
                      _buildClassChip(3, '3ème • Empire'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Chaussée Romaine de la Via Appia
          Expanded(
            child: worlds.isEmpty
                ? const Center(child: Text('Aucune étape trouvée pour ce cursus.'))
                : Stack(
                    children: [
                      // Arrière-plan subtil : collines et aqueduc
                      Positioned.fill(
                        child: CustomPaint(
                          painter: ViaAppiaBackgroundPainter(),
                        ),
                      ),
                      // Liste défilante des mondes et bornes milliaires
                      ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemCount: worlds.length,
                        itemBuilder: (context, index) {
                          final world = worlds[index];
                          return _buildWorldSection(context, world, index);
                        },
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassChip(int index, String label) {
    final isSelected = _activeFilter == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: RomanColors.imperialPurple,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : RomanColors.charcoal,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 11,
      ),
      backgroundColor: RomanColors.palatinCream,
      side: BorderSide(
        color: isSelected ? RomanColors.imperialPurple : Colors.transparent,
      ),
      onSelected: (val) {
        if (val) {
          HapticFeedback.selectionClick();
          setState(() => _activeFilter = index);
        }
      },
    );
  }

  Widget _buildWorldSection(BuildContext context, World world, int worldIndex) {
    return Column(
      children: [
        // 🏛️ Arc de Triomphe Monumental SPQR
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5A121E), Color(0xFF380912)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: RomanColors.imperialGold, width: 1.8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x28000000),
                offset: Offset(0, 4),
                blurRadius: 8,
              )
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                decoration: const BoxDecoration(
                  color: RomanColors.imperialGold,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🌿 ', style: TextStyle(fontSize: 12)),
                    Text(
                      'S • P • Q • R  •  PARCOURS ',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Color(0xFF2C1E0A),
                      ),
                    ),
                    const Text(' 🌿', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🏛️', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        world.title.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Étapes milliaires en serpentin naturel
        ...List.generate(world.lessons.length, (lessonIndex) {
          final lesson = world.lessons[lessonIndex];
          final isCompleted = widget.repo.isLessonCompleted(lesson.id);
          final isUnlocked = isCompleted ||
              lessonIndex == 0 ||
              widget.repo.isLessonCompleted(world.lessons[lessonIndex - 1].id);

          // Alternance en serpentin doux (-50, 0, 50, 0)
          final pattern = lessonIndex % 4;
          final double offsetFactor = (pattern == 0)
              ? -50
              : (pattern == 1)
                  ? 0
                  : (pattern == 2)
                      ? 50
                      : 0;

          // Détection si c''est la leçon active où se tient le joueur
          final bool isCurrentActive = isUnlocked && !isCompleted;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Transform.translate(
              offset: Offset(offsetFactor, 0),
              child: _buildMilestoneNode(
                context,
                lesson: lesson,
                index: lessonIndex + 1,
                isCompleted: isCompleted,
                isUnlocked: isUnlocked,
                isCurrentActive: isCurrentActive,
              ),
            ),
          );
        }),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMilestoneNode(
    BuildContext context, {
    required Lesson lesson,
    required int index,
    required bool isCompleted,
    required bool isUnlocked,
    required bool isCurrentActive,
  }) {
    final profile = widget.repo.profile;
    final avatarImg = profile.genre == 'fille'
        ? 'assets/images/avatar_fille_medaillon_48.png'
        : 'assets/images/avatar_garcon_medaillon_48.png';

    return GestureDetector(
      onTap: isUnlocked
          ? () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonScreen(repo: widget.repo, lesson: lesson),
                ),
              );
            }
          : () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🔒 Complète l''étape précédente pour débloquer cette borne !'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pin du Joueur si c''est la leçon active
          if (isCurrentActive) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: RomanColors.goldLight,
                      border: Border.all(color: RomanColors.imperialGold, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33000000),
                          offset: Offset(0, 3),
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        avatarImg,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Text('📍', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Borne Milliaire 3D en Marbre
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isCompleted
                    ? [const Color(0xFF2E7D47), const Color(0xFF1B5E32)]
                    : isCurrentActive
                        ? [const Color(0xFFF7D878), const Color(0xFFC79820)]
                        : isUnlocked
                            ? [const Color(0xFFF0EAE1), const Color(0xFFD6C8B8)]
                            : [const Color(0xFFC8C2BA), const Color(0xFF9E978F)],
              ),
              border: Border.all(
                color: isCurrentActive
                    ? Colors.white
                    : isCompleted
                        ? const Color(0xFFB4E3C4)
                        : Colors.white70,
                width: isCurrentActive ? 3.0 : 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: isCurrentActive
                      ? const Color(0x40D4AF37)
                      : const Color(0x22000000),
                  offset: const Offset(0, 5),
                  blurRadius: isCurrentActive ? 10 : 6,
                ),
              ],
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 30)
                  : isUnlocked
                      ? Text(
                          _toRoman(index),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'serif',
                            color: isCurrentActive
                                ? const Color(0xFF2C1E0A)
                                : RomanColors.charcoal,
                          ),
                        )
                      : const Icon(Icons.lock_rounded, color: Colors.white70, size: 22),
            ),
          ),
          const SizedBox(height: 6),
          // Titre de l''étape
          Container(
            constraints: const BoxConstraints(maxWidth: 150),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: RomanColors.marbleBorder),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  offset: Offset(0, 2),
                  blurRadius: 3,
                )
              ],
            ),
            child: Text(
              lesson.title,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
                color: isUnlocked ? RomanColors.charcoal : Colors.black45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _toRoman(int n) {
    const map = [
      [10, 'X'],
      [9, 'IX'],
      [5, 'V'],
      [4, 'IV'],
      [1, 'I'],
    ];
    String res = '';
    for (var pair in map) {
      int val = pair[0] as int;
      String sym = pair[1] as String;
      while (n >= val) {
        res += sym;
        n -= val;
      }
    }
    return res.isEmpty ? '' : res;
  }
}

/// Peintre personnalisé pour l''arrière-plan de la chaussée romaine et des collines du Latium.
class ViaAppiaBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x06000000)
      ..style = PaintingStyle.fill;

    // Décor doux géométrique façon Monument Valley
    final path = Path();
    path.moveTo(0, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.15, size.width, size.height * 0.25);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    // Ligne centrale en pointillé suggérant la voie romaine
    final roadPaint = Paint()
      ..color = const Color(0x18C5B396)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24;

    final roadPath = Path();
    roadPath.moveTo(size.width * 0.5, 0);
    roadPath.cubicTo(
      size.width * 0.3, size.height * 0.33,
      size.width * 0.7, size.height * 0.66,
      size.width * 0.5, size.height,
    );
    canvas.drawPath(roadPath, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}