import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../core/game_juice.dart';
import '../../../data/models/world.dart';
import '../../../data/models/lesson.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import '../lesson/lesson_screen.dart';
import '../../core/avatar_assets.dart';

/// La Carte d'Aventure de la Via Appia inspirée de l'esthétique de Monument Valley.
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

  // Le pion du héros : une seule position, la prochaine leçon à faire.
  final GlobalKey _pawnKey = GlobalKey();
  String? _pawnLessonId;
  bool _pawnJustMoved = false;

  @override
  void initState() {
    super.initState();
    _activeFilter = widget.initialClassFilter == 0 ? 0 : widget.initialClassFilter;
    _pawnLessonId = _nextLessonId();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToPawn(animate: false));
  }

  /// Première leçon non terminée, dans l'ordre de la Via Appia.
  String? _nextLessonId() {
    for (final w in widget.repo.worlds) {
      for (final l in w.lessons) {
        if (!widget.repo.isLessonCompleted(l.id)) return l.id;
      }
    }
    return null;
  }

  void _scrollToPawn({bool animate = true}) {
    final ctx = _pawnKey.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      alignment: 0.35,
      duration: animate ? const Duration(milliseconds: 900) : Duration.zero,
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _openLesson(Lesson lesson) async {
    AudioService().playCardFlip();
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LessonScreen(repo: widget.repo, lesson: lesson)),
    );
    if (!mounted) return;
    final next = _nextLessonId();
    if (next != _pawnLessonId) {
      // Le héros avance : le pion « tombe » sur la nouvelle borne et la carte le suit.
      setState(() {
        _pawnLessonId = next;
        _pawnJustMoved = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(milliseconds: 250));
        if (mounted) _scrollToPawn();
      });
    }
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
        title: const Text('VIA APPIA'),
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
                  '${profile.sesterces} HS',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5,
                    color: Color(0xFF7A5901),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: RomanColors.imperialGold),
            tooltip: 'Harmonia Antiqua (Audio)',
            onPressed: () => RomanAudioModal.show(context),
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
                      'Épopée Romaine : $completedCount / $totalLessons leçons',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: RomanColors.imperialPurple,
                      ),
                    ),
                    Text(
                      '${(progressRatio * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: RomanColors.laurelGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                RomanElasticProgressBar(
                  value: progressRatio,
                  height: 7,
                  backgroundColor: const Color(0xFFEBE3D7),
                  color: RomanColors.imperialGold,
                  ghostColor: RomanColors.laurelGreen.withValues(alpha: 0.4),
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
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _LessonLegendPill(icon: '📜', label: 'Quiz Grammaire'),
                    _LessonLegendPill(icon: '🧩', label: 'Syntaxe'),
                    _LessonLegendPill(icon: '✏️', label: 'Déclinaisons'),
                    _LessonLegendPill(icon: '⚔️', label: 'Boss Arène'),
                  ],
                ),
              ],
            ),
          ),
          const RomanMeanderDivider(height: 8, color: RomanColors.imperialGold),

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
                      // Tout est construit d'avance (113 bornes au plus) pour que la
                      // carte puisse défiler jusqu'au pion où qu'il soit.
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            for (var index = 0; index < worlds.length; index++)
                              _buildWorldSection(context, worlds[index], index),
                          ],
                        ),
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
        // Bannière du monde : son décor illustré, le titre posé dessus.
        _WorldBanner(world: world),

        // Sentinelle Lupulus veillant sur le tronçon de la voie romaine
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedLupulusAvatar(
                size: 38,
                onTap: () {
                  HapticFeedback.lightImpact();
                  AudioService().playWheelClick();
                },
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: RomanColors.palatinCream,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: RomanColors.marbleBorder, width: 0.9),
                    boxShadow: const [
                      BoxShadow(color: Color(0x0C000000), offset: Offset(0, 2), blurRadius: 4),
                    ],
                  ),
                  child: Text(
                    '« Monde ${world.id.replaceAll(RegExp(r'\D'), '')} : que ta marche soit triomphale ! »',
                    style: const TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      color: RomanColors.imperialPurple,
                    ),
                  ),
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

          // Le joueur se tient sur une seule borne : sa prochaine leçon.
          final bool isCurrentActive = lesson.id == _pawnLessonId;

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
    final avatarImg = AvatarAssets.medaillon(profile, taille: 48);

    return GestureDetector(
      onTap: isUnlocked
          ? () => _openLesson(lesson)
          : () {
              AudioService().playError();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🔒 Complète l\'étape précédente pour débloquer cette borne !'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pin du Joueur si c'est la leçon active
          if (isCurrentActive) ...[
            _HeroPawn(
              key: _pawnKey,
              avatarImg: avatarImg,
              arriving: _pawnJustMoved,
              onArrived: () => _pawnJustMoved = false,
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
                if (isCurrentActive) ...[
                  const BoxShadow(
                    color: Color(0x66FFD54F),
                    blurRadius: 18,
                    spreadRadius: 4,
                  ),
                  const BoxShadow(
                    color: Color(0x44FF8F00),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ] else if (isCompleted) ...[
                  const BoxShadow(
                    color: Color(0x334CAF50),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ] else ...[
                  const BoxShadow(
                    color: Color(0x22000000),
                    offset: Offset(0, 5),
                    blurRadius: 6,
                  ),
                ],
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
          // Carte descriptive et type de la leçon
          Container(
            constraints: const BoxConstraints(maxWidth: 135),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isCurrentActive
                  ? const Color(0xFFFFF9E6)
                  : Colors.white.withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isCurrentActive
                    ? RomanColors.imperialGold
                    : isCompleted
                        ? const Color(0xFFB4E3C4)
                        : RomanColors.marbleBorder,
                width: isCurrentActive ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: isCurrentActive ? const Color(0x22D4AF37) : const Color(0x0A000000),
                  offset: const Offset(0, 2),
                  blurRadius: isCurrentActive ? 6 : 3,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Type badge pill
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_getLessonTypeIcon(lesson.type), style: const TextStyle(fontSize: 10)),
                    const SizedBox(width: 3),
                    Text(
                      _getLessonTypeShortLabel(lesson.type),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: _getLessonTypeColor(lesson.type),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  lesson.title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
                    color: isUnlocked ? RomanColors.charcoal : Colors.black45,
                  ),
                ),
                const SizedBox(height: 2),
                if (isCompleted)
                  Text(
                    '★' * widget.repo.starsForLesson(lesson.id).clamp(0, 3) + '☆' * (3 - widget.repo.starsForLesson(lesson.id).clamp(0, 3)),
                    style: const TextStyle(fontSize: 11, color: RomanColors.imperialGold, fontWeight: FontWeight.bold),
                  )
                else if (isCurrentActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: RomanColors.goldLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '▶ À JOUER',
                      style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF7A5901)),
                    ),
                  )
                else if (!isUnlocked)
                  const Icon(Icons.lock_rounded, size: 10, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _getLessonTypeIcon(String type) {
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

  static String _getLessonTypeShortLabel(String type) {
    switch (type) {
      case 'quiz':
        return 'Quiz';
      case 'puzzle':
        return 'Syntaxe';
      case 'trou':
        return 'Déclinaisons';
      case 'arene':
        return 'Boss Arène';
      case 'decodeur':
        return 'Épigraphie';
      default:
        return 'Leçon';
    }
  }

  static Color _getLessonTypeColor(String type) {
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

/// Pion du héros : il sautille doucement sur sa borne, et tombe en rebondissant
/// quand il vient d'avancer d'une leçon.
/// Bannière d'un monde sur la Via Appia : décor illustré, bandeau SPQR et titre.
/// Sans illustration (monde ajouté plus tard), on retombe sur le dégradé bordeaux.
class _WorldBanner extends StatelessWidget {
  final World world;

  const _WorldBanner({required this.world});

  String get _numero => world.id.replaceAll(RegExp(r'\D'), '');

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      height: 168,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: RomanColors.imperialGold, width: 1.8),
        boxShadow: const [
          BoxShadow(color: Color(0x28000000), offset: Offset(0, 4), blurRadius: 8),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/mondes/${world.id}.webp',
              fit: BoxFit.cover,
              // Les décors gardent le ciel en haut : on cadre un peu sous le centre.
              alignment: const Alignment(0, 0.25),
              errorBuilder: (_, __, ___) => const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5A121E), Color(0xFF380912)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            // Voile sombre en bas : le titre blanc reste lisible sur tous les décors.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00000000), Color(0x00000000), Color(0xCC1E0508)],
                  stops: [0, 0.45, 1],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                decoration: const BoxDecoration(
                  color: RomanColors.imperialGold,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  'S • P • Q • R  •  MONDE $_numero',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Color(0xFF2C1E0A),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 12,
              child: Text(
                world.title.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.8,
                  shadows: [Shadow(color: Color(0xAA000000), blurRadius: 6)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroPawn extends StatefulWidget {
  final String avatarImg;
  final bool arriving;
  final VoidCallback onArrived;

  const _HeroPawn({super.key, required this.avatarImg, required this.arriving, required this.onArrived});

  @override
  State<_HeroPawn> createState() => _HeroPawnState();
}

class _HeroPawnState extends State<_HeroPawn> with TickerProviderStateMixin {
  late final AnimationController _hop = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))
    ..repeat(reverse: true);
  late final AnimationController _drop = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

  @override
  void initState() {
    super.initState();
    if (widget.arriving) {
      _drop.forward().then((_) {
        widget.onArrived();
        AudioService().playStar();
      });
    } else {
      _drop.value = 1;
    }
  }

  @override
  void dispose() {
    _hop.dispose();
    _drop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_hop, _drop]),
      builder: (context, child) {
        final drop = Curves.bounceOut.transform(_drop.value);
        final hop = Curves.easeInOut.transform(_hop.value) * 5;
        return Transform.translate(
          offset: Offset(0, -120 * (1 - drop) - hop),
          child: Opacity(opacity: _drop.value.clamp(0.0, 1.0), child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: RomanColors.goldLight,
          border: Border.all(color: RomanColors.imperialGold, width: 2),
          boxShadow: const [BoxShadow(color: Color(0x33000000), offset: Offset(0, 3), blurRadius: 4)],
        ),
        child: ClipOval(
          child: Image.asset(
            widget.avatarImg,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Center(child: Text('📍', style: TextStyle(fontSize: 16))),
          ),
        ),
      ),
    );
  }
}

class _LessonLegendPill extends StatelessWidget {
  final String icon;
  final String label;

  const _LessonLegendPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 10)),
        const SizedBox(width: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 9.5, color: Colors.black54, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

/// Peintre personnalisé pour l'arrière-plan de la chaussée romaine et des collines du Latium.
class ViaAppiaBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Collines du Latium sous lumière dorée
    final hillPaint1 = Paint()
      ..color = const Color(0x0CA0522D)
      ..style = PaintingStyle.fill;
    final hillPath1 = Path()
      ..moveTo(0, size.height * 0.18)
      ..quadraticBezierTo(size.width * 0.45, size.height * 0.12, size.width, size.height * 0.22)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hillPath1, hillPaint1);

    // 2. Silhouette d'aqueduc romain à arcades dans le lointain
    final aqueductPaint = Paint()
      ..color = const Color(0x167A5901)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const double archW = 36.0;
    const double archH = 20.0;
    final double yAqueduct = size.height * 0.14;
    double xArch = 12;
    while (xArch < size.width - 12) {
      canvas.drawArc(
        Rect.fromLTWH(xArch, yAqueduct, archW, archH * 2),
        math.pi,
        math.pi,
        false,
        aqueductPaint,
      );
      // Piliers de l'aqueduc
      canvas.drawLine(Offset(xArch, yAqueduct + archH), Offset(xArch, yAqueduct + archH + 18), aqueductPaint);
      xArch += archW + 6;
    }
    // Ligne supérieure de l'aqueduc
    canvas.drawLine(Offset(0, yAqueduct), Offset(size.width, yAqueduct), aqueductPaint);

    // 3. Chaussée de la Via Appia (pavés polygonaux en basalte)
    final roadBorderPaint = Paint()
      ..color = const Color(0x1CC5B396)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 36;

    final roadPath = Path();
    roadPath.moveTo(size.width * 0.5, 0);
    roadPath.cubicTo(
      size.width * 0.26, size.height * 0.33,
      size.width * 0.74, size.height * 0.66,
      size.width * 0.5, size.height,
    );
    canvas.drawPath(roadPath, roadBorderPaint);

    // Pavés transversaux de basalte romain
    final stoneLinePaint = Paint()
      ..color = const Color(0x1E8D6E63)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (double y = 40; y < size.height; y += 60) {
      canvas.drawLine(Offset(size.width * 0.46, y), Offset(size.width * 0.54, y + 2), stoneLinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}