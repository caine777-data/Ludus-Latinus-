import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../core/particles_overlay.dart';
import '../../core/lottie_effects.dart';
import '../../core/latin_pronunciation_modal.dart';
import '../../core/game_juice.dart';
import '../../core/markdown_lite.dart';
import '../../../data/models/lesson.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import 'widgets/word_puzzle_widget.dart';
import 'widgets/cloze_fill_widget.dart';
import 'widgets/case_decoder_widget.dart';
import 'widgets/arena_challenge_widget.dart';

/// Écran de cours et d'exercice QCM 2x2 tactile au style épuré Monument Valley.
class LessonScreen extends StatefulWidget {
  final GameRepository repo;
  final Lesson lesson;

  const LessonScreen({
    super.key,
    required this.repo,
    required this.lesson,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int? selectedOption;
  bool isAnswered = false;
  bool isCorrect = false;
  final GlobalKey<RomanScreenShakeState> _shakeKey = GlobalKey<RomanScreenShakeState>();

  // Étoiles : 3 du premier coup, 2 avec une erreur ou un indice, 1 au-delà.
  int _mistakes = 0;
  bool _hintUsed = false;
  // Réponses de QCM écartées : essayées à tort ou barrées par l'indice.
  final Set<int> _eliminated = {};
  late List<int> _order;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _exerciseKey = GlobalKey();
  bool _exerciseVisible = false;

  int get _stars {
    final aids = _mistakes + (_hintUsed ? 1 : 0);
    if (aids == 0) return 3;
    if (aids == 1) return 2;
    return 1;
  }

  @override
  void initState() {
    super.initState();
    _order = List.generate(widget.lesson.options.length, (i) => i);
    _scrollController.addListener(_updateExerciseVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateExerciseVisibility());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateExerciseVisibility() {
    final box = _exerciseKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !mounted) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final visible = top < MediaQuery.of(context).size.height * 0.85;
    if (visible != _exerciseVisible) setState(() => _exerciseVisible = visible);
  }

  void _scrollToExercise() {
    HapticFeedback.selectionClick();
    final ctx = _exerciseKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 450), curve: Curves.easeOutCubic, alignment: 0.02);
    }
  }

  void _submitAnswer(int index) {
    if (isAnswered || _eliminated.contains(index)) return;

    final correct = (index == widget.lesson.answer);
    HapticFeedback.mediumImpact();

    setState(() {
      selectedOption = index;
      isAnswered = true;
      isCorrect = correct;
      if (!correct) {
        _mistakes++;
        _eliminated.add(index);
      }
    });

    if (isCorrect) {
      _handleSuccess();
    } else {
      AudioService().playError();
      _shakeKey.currentState?.shake(intensity: ShakeIntensity.light);
    }
  }

  /// Indice qui aide sans donner la réponse : Lupulus barre une mauvaise réponse.
  void _useHint() {
    final candidates = _order
        .where((i) => i != widget.lesson.answer && !_eliminated.contains(i))
        .toList();
    if (candidates.isEmpty) return;
    HapticFeedback.lightImpact();
    AudioService().playCardFlip();
    candidates.shuffle();
    setState(() {
      _hintUsed = true;
      _eliminated.add(candidates.first);
    });
  }

  void _retry() {
    HapticFeedback.lightImpact();
    setState(() {
      isAnswered = false;
      selectedOption = null;
      // Mélanger évite de retrouver la réponse par simple élimination de position.
      _order.shuffle();
    });
  }

  void _handleSuccess() {
    final result = widget.repo.completeLesson(widget.lesson.id, _stars);
    if (result.worldCompleted) {
      // Seule la fin d'un monde mérite le grand triomphe.
      HapticFeedback.heavyImpact();
      AudioService().playTriumph();
      RomanLottieEffects.showCoinShower(context);
      RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
    } else if (result.firstTime) {
      HapticFeedback.mediumImpact();
      AudioService().playSesterces();
    } else {
      HapticFeedback.lightImpact();
      AudioService().playCardFlip();
    }
    _showResultSheet(result);
  }

  void _showResultSheet(LessonResult result) {
    final String title;
    final String subtitle;
    if (result.worldCompleted) {
      title = 'MONDE TERMINÉ !';
      subtitle = result.worldTitle ?? 'Toutes les leçons de ce monde sont validées.';
    } else if (result.stars == 3) {
      title = 'Optime !';
      subtitle = 'Réussi du premier coup.';
    } else if (result.stars == 2) {
      title = 'Bene !';
      subtitle = 'Réussi avec une aide. Refais la leçon plus tard pour décrocher 3 étoiles.';
    } else {
      title = 'Leçon réussie';
      subtitle = 'Il a fallu plusieurs essais : relis la leçon et retente-la bientôt.';
    }
    final explanation = widget.lesson.explanation;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: result.worldCompleted ? 84 : 64,
              height: result.worldCompleted ? 84 : 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: RomanColors.goldLight,
                border: Border.all(color: RomanColors.imperialGold, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  result.worldCompleted
                      ? 'assets/images/lupulus/lupulus_triomphe_180.png'
                      : 'assets/images/lupulus/lupulus_joie_180.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: result.worldCompleted ? 20 : 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.6,
                color: RomanColors.imperialPurple,
                fontFamily: 'serif',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                final filled = i < result.stars;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Icon(
                    filled ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 34,
                    color: filled ? RomanColors.imperialGold : const Color(0xFFCFC3B3),
                  ),
                );
              }),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13.5, color: Colors.black87, height: 1.35),
            ),
            if (explanation != null && explanation.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8F3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: RomanColors.laurelGreen.withOpacity(0.35)),
                ),
                child: Text(
                  explanation,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13.5, color: Color(0xFF1B4D2E), height: 1.35),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: RomanColors.goldLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: RomanColors.imperialGold),
              ),
              child: Text(
                result.sestercesGained > 0
                    ? '+${result.sestercesGained} HS'
                    : (result.improved
                        ? 'Nouveau record : ${result.stars} ★'
                        : (result.bestStars > result.stars
                            ? 'Leçon déjà validée (record : ${result.bestStars} ★)'
                            : 'Leçon déjà validée : pas de nouveaux sesterces')),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF7A5901),
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Jauge de Progression du Cursus avec physique de ressort élastique
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progression du Cursus',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: RomanColors.imperialPurple),
                      ),
                      Text(
                        '${widget.repo.profile.completedLessons.length} / ${widget.repo.worlds.fold<int>(0, (s, w) => s + w.lessons.length)} leçons',
                        style: const TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  RomanElasticProgressBar(
                    value: (widget.repo.profile.completedLessons.length / widget.repo.worlds.fold<int>(0, (s, w) => s + w.lessons.length).clamp(1, 100000)).clamp(0.0, 1.0),
                    color: RomanColors.imperialGold,
                    ghostColor: RomanColors.laurelGreen.withOpacity(0.4),
                    backgroundColor: const Color(0xFFEBE3D7),
                    height: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            RomanButton(
              text: 'CONTINUER ▶',
              isLarge: true,
              onPressed: () {
                Navigator.pop(context); // ferme la modale
                Navigator.pop(context); // retourne à la carte
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Illustration liée au thème de la leçon, ou null : mieux vaut aucune
  /// image qu'une coupe « CHAMPION » sans rapport avec le sujet.
  String? _getLessonIllustration() {
    final title = widget.lesson.title.toLowerCase();
    if (title.contains('gladiat') || title.contains('arène')) {
      return 'assets/images/musee_gladiateur.png';
    } else if (title.contains('légion') || title.contains('armée') || title.contains('milit')) {
      return 'assets/images/musee_legion.png';
    } else if (title.contains('louve') || title.contains('romulus') || title.contains('fondat')) {
      return 'assets/images/musee_louve.png';
    } else if (title.contains('circus') || title.contains('course') || title.contains('char')) {
      return 'assets/images/musee_circus.png';
    } else if (title.contains('therme') || title.contains('bain') || title.contains('vie')) {
      return 'assets/images/musee_thermes.png';
    } else if (title.contains('dieu') || title.contains('mythe') || title.contains('pégase')) {
      return 'assets/images/musee_pegase.png';
    }
    return null;
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
        return 'Épreuve d\'Arène / Combat';
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

  String _getLupulusCostumeForLesson(Lesson lesson) {
    final t = '${lesson.title} ${lesson.latin ?? ''}'.toLowerCase();
    if (t.contains('gladiat') || t.contains('arène') || t.contains('combat')) {
      return 'assets/images/lupulus/lupulus_gladiateur_180.png';
    } else if (t.contains('légion') || t.contains('armée') || t.contains('milit') || t.contains('soldat')) {
      return 'assets/images/lupulus/lupulus_centurion_180.png';
    } else if (t.contains('empereur') || t.contains('césar') || t.contains('imperator') || t.contains('triomphe')) {
      return 'assets/images/lupulus/lupulus_imperator_180.png';
    } else if (t.contains('dieu') || t.contains('mythe') || t.contains('philosoph') || t.contains('sénat')) {
      return 'assets/images/lupulus/lupulus_philosophe_180.png';
    }
    return 'assets/images/lupulus/lupulus_savant_180.png';
  }

  String _getLupulusGreetingForLesson(Lesson lesson) {
    final t = '${lesson.title} ${lesson.latin ?? ''}'.toLowerCase();
    if (t.contains('gladiat') || t.contains('combat')) {
      return '« Salve pugnator ! Dans l\'arène, la précision du mot frappe aussi fort que le glaive ! »';
    } else if (t.contains('légion') || t.contains('armée')) {
      return '« Salve legionarie ! La discipline grammaticale est le bouclier des légions ! »';
    } else if (t.contains('dieu') || t.contains('mythe')) {
      return '« Salve discipule ! Que Minerve et Apollon inspirent ta mémoire mythologique ! »';
    }
    return '« Salve discipule ! Observe bien les racines latines, elles éclairent la langue française ! »';
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final illustration = _getLessonIllustration();
    final hasLatin = lesson.latin != null && lesson.latin!.trim().isNotEmpty;
    final bestStars = widget.repo.starsForLesson(lesson.id);

    return Scaffold(
      appBar: AppBar(
        // Le titre complet est affiché dans la page : la barre reste lisible.
        title: const Text('LEÇON'),
        actions: [
          if (hasLatin)
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: RomanColors.imperialPurple),
            tooltip: 'Prononciation latine',
            onPressed: () {
              HapticFeedback.lightImpact();
              LatinPronunciationModal.show(context, lesson.latin!);
            },
          ),
        ],
      ),
      // Raccourci vers l'exercice tant qu'il n'est pas à l'écran.
      bottomNavigationBar: _exerciseVisible
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                child: RomanButton(
                  text: 'À L\'EXERCICE ↓',
                  isLarge: true,
                  onPressed: _scrollToExercise,
                ),
              ),
            ),
      body: RomanScreenShake(
        key: _shakeKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 0. Bandeau d'Identification Académique Officiel
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0C000000),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _getLessonTypeColor(lesson.type).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _getLessonTypeColor(lesson.type), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_getLessonTypeIcon(lesson.type), style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          _getLessonTypeTitle(lesson.type),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _getLessonTypeColor(lesson.type),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: bestStars > 0 ? const Color(0xFFE8F5E9) : RomanColors.goldLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      bestStars > 0
                          ? '✓ Validée ${'★' * bestStars}${'☆' * (3 - bestStars)}'
                          : 'Jusqu\'à +${GameRepository.rewardForStars(3)} HS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: bestStars > 0 ? const Color(0xFF2E7D32) : const Color(0xFF7A5901),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 1. Illustration liée au thème (absente si aucune ne correspond)
            if (illustration != null)
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: RomanColors.palatinCream,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: RomanColors.marbleBorder, width: 1.2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    offset: Offset(0, 3),
                    blurRadius: 8,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  illustration,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Text('🏛️', style: TextStyle(fontSize: 48)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            const RomanMeanderDivider(height: 12, strokeWidth: 1.2),
            const SizedBox(height: 4),

            // 2. Parchemin de Leçon
            RomanParchmentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: RomanColors.goldLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: RomanColors.imperialGold, width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              _getLupulusCostumeForLesson(lesson),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(
                                child: Text('🐺', style: TextStyle(fontSize: 18)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getLupulusGreetingForLesson(lesson),
                            style: const TextStyle(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              color: RomanColors.imperialPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    lesson.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: RomanColors.imperialPurple,
                      fontFamily: 'serif',
                    ),
                  ),
                  const SizedBox(height: 8),
                  MarkdownLite(lesson.content),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.end,
                    children: [
                      // La prononciation latine n'a de sens que sur une phrase latine.
                      if (lesson.latin != null && lesson.latin!.trim().isNotEmpty)
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: RomanColors.imperialPurple,
                          backgroundColor: RomanColors.goldLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: RomanColors.imperialGold, width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        ),
                        icon: const Icon(Icons.record_voice_over_outlined, size: 16),
                        label: const Text(
                          'Prononciation',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          LatinPronunciationModal.show(context, lesson.latin!);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 3. Exercice Interactif Pédagogique (adapté selon le type : QCM, Puzzle, Trou, Décodeur, Arène)
            KeyedSubtree(key: _exerciseKey, child: _buildInteractiveExerciseSection(lesson)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildInteractiveExerciseSection(Lesson lesson) {
    if (lesson.type == 'puzzle' && lesson.words.isNotEmpty) {
      return WordPuzzleWidget(
        availableWords: lesson.words,
        targetSolution: lesson.solution ?? lesson.latin ?? lesson.words.join(' '),
        latinPhrase: lesson.latin,
        onCompleted: _handleSuccess,
        onMistake: () => _mistakes++,
      );
    } else if (lesson.type == 'trou') {
      return ClozeFillWidget(
        consigne: lesson.consigne,
        avant: lesson.avant,
        apres: lesson.apres,
        solution: lesson.solution ?? '',
        options: lesson.options,
        latinComplet: lesson.latinComplet,
        onCompleted: _handleSuccess,
        onMistake: () => _mistakes++,
      );
    } else if (lesson.type == 'decodeur' && lesson.words.isNotEmpty) {
      return CaseDecoderWidget(
        words: lesson.words,
        expectedRoles: lesson.roles,
        latinPhrase: lesson.latin,
        onCompleted: _handleSuccess,
        onMistake: () => _mistakes++,
      );
    } else if (lesson.type == 'arene' && lesson.questions.isNotEmpty) {
      return ArenaChallengeWidget(
        boss: lesson.boss,
        questions: lesson.questions,
        onCompleted: _handleSuccess,
        onMistake: () => _mistakes++,
      );
    } else if (lesson.options.isNotEmpty) {
      return _buildQcmExerciseCard(lesson);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildQcmExerciseCard(Lesson lesson) {
    final canUseHint = !isAnswered &&
        _order.any((i) => i != lesson.answer && !_eliminated.contains(i)) &&
        _order.where((i) => !_eliminated.contains(i)).length > 2;

    return RomanCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lesson.question ?? 'Choisis la bonne réponse :',
            style: const TextStyle(
              fontSize: 16,
              height: 1.3,
              fontWeight: FontWeight.bold,
              color: RomanColors.imperialPurple,
            ),
          ),
          const SizedBox(height: 12),

          // Réponses empilées : texte entier, même taille pour toutes.
          ...List.generate(_order.length, (pos) {
            final optIndex = _order[pos];
            final optionText = lesson.options[optIndex];
            final isSelected = selectedOption == optIndex;
            final isStruck = _eliminated.contains(optIndex) && !(isAnswered && isSelected);
            const letters = ['A', 'B', 'C', 'D', 'E', 'F'];

            Color btnColor = Colors.white;
            Color textColor = RomanColors.charcoal;
            Color borderColor = RomanColors.marbleBorder;
            Color sealColor = const Color(0xFF8E1724);
            String sealLabel = letters[pos.clamp(0, letters.length - 1)];

            if (isAnswered && isCorrect && optIndex == lesson.answer) {
              btnColor = const Color(0xFFE8F5E9);
              textColor = const Color(0xFF1B5E20);
              borderColor = RomanColors.laurelGreen;
              sealColor = const Color(0xFF1B5E20);
              sealLabel = '✓';
            } else if (isAnswered && isSelected && !isCorrect) {
              // Seule la réponse choisie est marquée : la bonne n'est pas révélée.
              btnColor = const Color(0xFFFFEBEE);
              textColor = const Color(0xFFB71C1C);
              borderColor = const Color(0xFFB71C1C);
              sealColor = const Color(0xFF8B2500);
              sealLabel = '✗';
            } else if (isStruck) {
              btnColor = const Color(0xFFF4F1EC);
              textColor = const Color(0xFF9E958B);
              sealColor = const Color(0xFFB8AEA3);
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: (isAnswered || isStruck) ? null : () => _submitAnswer(optIndex),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  constraints: const BoxConstraints(minHeight: 56),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: btnColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor, width: isSelected ? 2.0 : 1.4),
                  ),
                  child: Row(
                    children: [
                      RomanWaxSeal(size: 30, label: sealLabel, sealColor: sealColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          optionText,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.3,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            decoration: isStruck ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          if (canUseHint)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _useHint,
                icon: const Icon(Icons.lightbulb_outline_rounded, size: 18),
                label: const Text('Indice : barrer une mauvaise réponse (−1 ★)'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF7A5901),
                  textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                ),
              ),
            ),

          if (isAnswered && !isCorrect) _buildMagisterPedagogicalFeedback(context),
        ],
      ),
    );
  }

  Widget _buildMagisterPedagogicalFeedback(BuildContext context) {
    final lesson = widget.lesson;
    final chosenOptText = (selectedOption != null && selectedOption! < lesson.options.length)
        ? lesson.options[selectedOption!]
        : 'Réponse sélectionnée';

    // Rappel de méthode, jamais la solution.
    String advice = 'Relis le passage de la leçon juste au-dessus : la réponse s\'y trouve.';
    final lowerChosen = chosenOptText.toLowerCase();
    if (lowerChosen.contains('accusatif') || lowerChosen.contains('nominatif') || lowerChosen.contains('ablatif')) {
      advice = 'Vérifie qui fait l\'action (nominatif) et qui la subit (accusatif), puis réessaie.';
    } else if (lowerChosen.contains('singulier') || lowerChosen.contains('pluriel')) {
      advice = 'Observe la terminaison du mot : c\'est elle qui indique le singulier ou le pluriel.';
    }

    final remaining = _order.where((i) => !_eliminated.contains(i)).length;
    final canUseHint = remaining > 2;

    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE28B68), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: RomanColors.goldLight,
                  border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/lupulus/lupulus_reflexion_180.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Pas tout à fait…',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'serif',
                    color: Color(0xFF94381E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13.5, color: RomanColors.charcoal, height: 1.35),
              children: [
                const TextSpan(text: 'Tu as choisi : '),
                TextSpan(
                  text: '« $chosenOptText »',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB71C1C)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            advice,
            style: const TextStyle(fontSize: 13.5, color: Color(0xFF66301D), height: 1.35),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: _retry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Réessayer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF94381E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  textStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              if (canUseHint)
                OutlinedButton.icon(
                  onPressed: () {
                    _useHint();
                    _retry();
                  },
                  icon: const Icon(Icons.lightbulb_outline_rounded, size: 18),
                  label: const Text('Réessayer avec un indice'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF7A5901),
                    side: const BorderSide(color: RomanColors.imperialGold),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    textStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
