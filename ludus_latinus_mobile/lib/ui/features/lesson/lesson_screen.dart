import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../core/particles_overlay.dart';
import '../../core/lottie_effects.dart';
import '../../core/latin_pronunciation_modal.dart';
import '../../core/game_juice.dart';
import '../../core/markdown_lite.dart';
import '../../core/cinematic_player.dart';
import '../../../data/models/lesson.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import 'widgets/word_puzzle_widget.dart';
import 'widgets/cloze_fill_widget.dart';
import 'widgets/case_decoder_widget.dart';
import 'widgets/arena_challenge_widget.dart';
import 'widgets/vocab_question_widget.dart';
import 'widgets/grammar_question_widget.dart';
import 'illustrations_lecons.dart';
import '../../../data/models/vocab_question.dart';
import '../../../l10n/l10n.dart';

/// Écran de cours et d'exercice QCM 2x2 tactile au style épuré Monument Valley.
/// Largeur maximale du contenu d'une leçon, en points.
const double largeurLecture = 760;

/// Hauteur du bandeau illustré : 140 points sur téléphone ; sur tablette (600
/// points de large et plus), proportionnelle à la colonne de lecture (rapport
/// 2,4), plafonnée à 280.
double hauteurBandeau(double largeurEcran) {
  if (largeurEcran < 600) return 140;
  final colonne = (largeurEcran < largeurLecture + 32 ? largeurEcran : largeurLecture + 32) - 32;
  return (colonne / 2.4).clamp(140.0, 280.0);
}

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

  // Série d'exercices : l'exercice principal, puis des questions de vocabulaire
  // du monde. Une question ratée est reposée à la fin de la série.
  late final List<VocabQuestion> _vocabQueue;
  final Map<VocabQuestion, int> _requeued = {};
  bool _mainDone = false;
  int _vocabIndex = 0;

  // Question de grammaire facultative : juste après l'exercice principal.
  bool _grammarDone = false;
  bool get _hasGrammar => widget.lesson.grammaire != null;
  bool get _inGrammar => _mainDone && _hasGrammar && !_grammarDone;

  int get _totalSteps => 1 + (_hasGrammar ? 1 : 0) + _vocabQueue.length;
  int get _currentStep => _mainDone ? _vocabIndex + 2 + (_hasGrammar ? 1 : 0) : 1;

  List<VocabQuestion> _buildVocabQueue() {
    final lesson = widget.lesson;
    String textOf(Lesson l) => [l.content, l.latin ?? '', l.question ?? '', ...l.options, ...l.words].join(' ');

    // Texte de toutes les leçons jusqu'à celle-ci : on n'interroge que des mots déjà vus.
    String worldId = '';
    final known = StringBuffer();
    outer:
    for (final w in widget.repo.worlds) {
      for (final l in w.lessons) {
        known.write(' ${textOf(l)}');
        if (l.id == lesson.id) {
          worldId = w.id;
          break outer;
        }
      }
    }
    return VocabQuestion.forLesson(
      dictionary: widget.repo.thesaurus,
      worldId: worldId,
      lessonText: textOf(lesson),
      knownText: known.toString(),
      count: 3,
    );
  }

  void _onMainDone() {
    if (!_hasGrammar && _vocabQueue.isEmpty) {
      _handleSuccess();
      return;
    }
    AudioService().playCorrect();
    setState(() => _mainDone = true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToExercise());
  }

  void _onGrammarDone() {
    if (_vocabQueue.isEmpty) {
      _grammarDone = true;
      _handleSuccess();
      return;
    }
    AudioService().playCorrect();
    setState(() => _grammarDone = true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToExercise());
  }

  void _onVocabAnswered(bool correct) {
    final q = _vocabQueue[_vocabIndex];
    if (!correct) {
      _mistakes++;
      // Reposée au plus deux fois, pour ne jamais bloquer l'élève.
      final n = _requeued[q] ?? 0;
      if (n < 2) {
        _requeued[q] = n + 1;
        _vocabQueue.add(q);
      }
    }
    if (_vocabIndex + 1 >= _vocabQueue.length) {
      _handleSuccess();
      return;
    }
    setState(() => _vocabIndex++);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToExercise());
  }

  @override
  void initState() {
    super.initState();
    _vocabQueue = _buildVocabQueue();
    AudioService().enterMusic(MusicTrack.lecon);
    _order = List.generate(widget.lesson.options.length, (i) => i)..shuffle();
    _scrollController.addListener(_updateExerciseVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _updateExerciseVisibility();
      // Première leçon d'un niveau : sa vidéo d'entrée, une seule fois. On la
      // lance ici plutôt qu'à l'ouverture, car les leçons s'ouvrent depuis la
      // carte comme depuis l'accueil.
      final niveau = widget.repo.enterLevelOf(widget.lesson.id);
      if (niveau != null && mounted) {
        await RomanCinematicOverlay.showLevel(context, niveau);
      }
    });
  }

  @override
  void dispose() {
    AudioService().leaveMusic(MusicTrack.lecon);
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

    annoncerAuLecteur(context, correct ? context.l10n.a11yCorrect : context.l10n.a11yWrong);
    if (isCorrect) {
      _onMainDone();
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
    AudioService().playHint();
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

  Future<void> _handleSuccess() async {
    final result = widget.repo.completeLesson(widget.lesson.id, _stars);
    if (result.worldCompleted) {
      // Seule la fin d'un monde mérite le grand triomphe : la vidéo (avec sa
      // propre bande-son), puis les lauriers sur le bilan.
      HapticFeedback.heavyImpact();
      await RomanCinematicOverlay.showTriumph(
        context,
        subtitle: result.worldTitle != null ? context.l10n.lessonWorldCompleteNamed(result.worldTitle!) : context.l10n.lessonWorldComplete,
      );
      if (!mounted) return;
      AudioService().playWorldComplete();
      if (result.carteGagnee != null) {
        // La fanfare du monde d'abord, puis le tintement de la carte gagnée.
        Future.delayed(const Duration(milliseconds: 2200), () {
          if (mounted) AudioService().playCardObtained();
        });
      }
      RomanLottieEffects.showCoinShower(context);
      RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
    } else {
      // Son de bonne réponse ; le bilan joue ensuite une note par étoile,
      // puis le tintement des pièces quand elles tombent dans la bourse.
      AudioService().playCorrect();
    }
    _showResultSheet(result);
  }

  void _showResultSheet(LessonResult result) {
    final String title;
    final String subtitle;
    if (result.worldCompleted) {
      title = context.l10n.lessonWorldCompleteUpper;
      subtitle = result.worldTitle ?? context.l10n.lessonWorldAllValidated;
    } else if (result.stars == 3) {
      title = context.l10n.lessonResultPerfect;
      subtitle = context.l10n.lessonResultPerfectHint;
    } else if (result.stars == 2) {
      title = context.l10n.lessonResultGood;
      subtitle = context.l10n.lessonResultGoodHint;
    } else {
      title = context.l10n.lessonResultPassed;
      subtitle = context.l10n.lessonResultPassedHint;
    }
    final explanation = widget.lesson.explanation;

    // isScrollControlled + défilement : sans eux, la fenêtre était bornée à
    // 9/16 de l'écran et le bouton « Continuer » disparaissait sous le bord.
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
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
                  lupulusAnimation(result.worldCompleted ? LupulusMood.triomphe : LupulusMood.joie),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/lupulus/lupulus_joie_180.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
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
            _ResultStars(stars: result.stars),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13.5, color: Colors.black87, height: 1.35),
            ),
            if (result.carteGagnee != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: RomanColors.goldLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: RomanColors.imperialGold),
                ),
                child: Text(
                  context.l10n.lessonNewCard(result.carteGagnee!.nom),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7A5901),
                    height: 1.3,
                  ),
                ),
              ),
            ],
            if (explanation != null && explanation.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8F3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: RomanColors.laurelGreen.withValues(alpha: 0.35)),
                ),
                child: Text(
                  explanation,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13.5, color: Color(0xFF1B4D2E), height: 1.35),
                ),
              ),
            ],
            const SizedBox(height: 12),
            if (result.sestercesGained > 0)
              _CoinReward(amount: result.sestercesGained, delay: Duration(milliseconds: 350 + 300 * result.stars))
            else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: RomanColors.goldLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: RomanColors.imperialGold),
              ),
              child: Text(
                    (result.improved
                        ? context.l10n.lessonNewRecord(result.stars)
                        : (result.bestStars > result.stars
                            ? context.l10n.lessonAlreadyDoneRecord(result.bestStars)
                            : context.l10n.lessonAlreadyDoneNoReward)),
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
                      Text(
                        context.l10n.lessonCursusProgress,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: RomanColors.imperialPurple),
                      ),
                      Text(
                        context.l10n.lessonCursusCount(widget.repo.profile.completedLessons.length, widget.repo.worlds.fold<int>(0, (s, w) => s + w.lessons.length)),
                        style: const TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  RomanElasticProgressBar(
                    value: (widget.repo.profile.completedLessons.length / widget.repo.worlds.fold<int>(0, (s, w) => s + w.lessons.length).clamp(1, 100000)).clamp(0.0, 1.0),
                    color: RomanColors.imperialGold,
                    ghostColor: RomanColors.laurelGreen.withValues(alpha: 0.4),
                    backgroundColor: const Color(0xFFEBE3D7),
                    height: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            RomanButton(
              text: context.l10n.lessonContinue,
              isLarge: true,
              onPressed: () {
                Navigator.pop(context); // ferme la modale
                Navigator.pop(context); // retourne à la carte
              },
            ),
          ],
        ),
        ),
        ),
      ),
    );
  }

  /// Illustration liée au thème de la leçon, ou null : mieux vaut aucune
  /// image qu'une coupe « CHAMPION » sans rapport avec le sujet.
  String? _getLessonIllustration() {
    // Image propre à la leçon (4e et 3e) en priorité, sinon repli sur le thème.
    final propre = illustrationDeLecon(widget.lesson.id);
    if (propre != null) return propre;
    final title = widget.lesson.title.toLowerCase();
    if (title.contains('gladiat') || title.contains('arène')) {
      return 'assets/images/musee_gladiateur.jpg';
    } else if (title.contains('légion') || title.contains('armée') || title.contains('milit')) {
      return 'assets/images/musee_legion.jpg';
    } else if (title.contains('louve') || title.contains('romulus') || title.contains('fondat')) {
      return 'assets/images/musee_louve.jpg';
    } else if (title.contains('circus') || title.contains('course') || title.contains('char')) {
      return 'assets/images/musee_circus.jpg';
    } else if (title.contains('therme') || title.contains('bain') || title.contains('vie')) {
      return 'assets/images/musee_thermes.jpg';
    } else if (title.contains('dieu') || title.contains('mythe') || title.contains('pégase')) {
      return 'assets/images/musee_pegase.jpg';
    }
    return null;
  }

  String _getLessonTypeTitle(String type) {
    switch (type) {
      case 'quiz':
        return context.l10n.lessonTypeQuiz;
      case 'puzzle':
        return context.l10n.lessonTypePuzzle;
      case 'trou':
        return context.l10n.lessonTypeCloze;
      case 'arene':
        return context.l10n.lessonTypeArena;
      case 'decodeur':
        return context.l10n.lessonTypeDecoder;
      default:
        return context.l10n.lessonTypeDefault;
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
      return context.l10n.lupulusGreetingGladiator;
    } else if (t.contains('légion') || t.contains('armée')) {
      return context.l10n.lupulusGreetingLegion;
    } else if (t.contains('dieu') || t.contains('mythe')) {
      return context.l10n.lupulusGreetingMyth;
    }
    return context.l10n.lupulusGreetingDefault;
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
        title: Text(context.l10n.lessonLabel),
        actions: [
          if (hasLatin)
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: RomanColors.imperialPurple),
            tooltip: context.l10n.lessonLatinPronunciation,
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
                  text: context.l10n.lessonToExercise,
                  isLarge: true,
                  onPressed: _scrollToExercise,
                ),
              ),
            ),
      body: RomanScreenShake(
        key: _shakeKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          // Sur tablette, la leçon garde une largeur de lecture (760 points au
          // plus) au lieu de s'étirer d'un bord à l'autre ; le défilement reste
          // possible sur toute la largeur.
          padding: EdgeInsets.symmetric(
            horizontal: (MediaQuery.sizeOf(context).width - largeurLecture) / 2 > 16
                ? (MediaQuery.sizeOf(context).width - largeurLecture) / 2
                : 16,
            vertical: 16,
          ),
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
              // Wrap : sur petit écran ou en police agrandie, la pastille des
              // étoiles passe à la ligne au lieu d'écraser le type de leçon.
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _getLessonTypeColor(lesson.type).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _getLessonTypeColor(lesson.type), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_getLessonTypeIcon(lesson.type), style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            _getLessonTypeTitle(lesson.type),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _getLessonTypeColor(lesson.type),
                            ),
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
                          ? context.l10n.lessonValidatedStars('★' * bestStars, '☆' * (3 - bestStars))
                          : context.l10n.lessonUpToReward(GameRepository.rewardForStars(3)),
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
              // 140 points sur téléphone ; plus haut sur une colonne large, pour que
              // la scène 16:9 ne soit pas réduite à une bande où les têtes sont coupées.
              height: hauteurBandeau(MediaQuery.sizeOf(context).width),
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
                  // Les images de leçon sont des scènes 16:9 composées pour un
                  // bandeau : on remplit. Les pièces du musée restent entières.
                  fit: illustration.startsWith('assets/images/lecons/') ? BoxFit.cover : BoxFit.contain,
                  width: double.infinity,
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
                        label: Text(
                          context.l10n.lessonPronunciation,
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
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
            KeyedSubtree(
              key: _exerciseKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Le cours est en haut d'une longue page : on le rouvre dans un
                  // volet, sans perdre la question en cours.
                  if (lesson.type != 'arene' && lesson.content.trim().isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => _revoirLeCours(lesson),
                        icon: const Text('📖', style: TextStyle(fontSize: 16)),
                        label: Text(
                          context.l10n.lessonReviewCourse,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: RomanColors.imperialPurple),
                        ),
                      ),
                    ),
                  _buildExerciseStep(lesson),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
  }

  void _revoirLeCours(Lesson lesson) {
    HapticFeedback.selectionClick();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: RomanColors.palatinCream,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, controleur) => SafeArea(
          top: false,
          child: ListView(
            controller: controleur,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                lesson.title,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: RomanColors.imperialPurple),
              ),
              const SizedBox(height: 10),
              MarkdownLite(lesson.content),
              const SizedBox(height: 16),
              RomanButton(text: context.l10n.lessonBackToExercise, onPressed: () => Navigator.of(context).pop()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseStep(Lesson lesson) {
    if (_inGrammar) {
      return GrammarQuestionWidget(
        key: ValueKey('grammaire_${lesson.id}'),
        question: lesson.grammaire!,
        progressLabel: context.l10n.lessonProgressGrammar(_totalSteps),
        onCompleted: _onGrammarDone,
        onMistake: () => _mistakes++,
      );
    }
    if (_mainDone && _grammarDone == _hasGrammar && _vocabIndex < _vocabQueue.length) {
      return VocabQuestionWidget(
        key: ValueKey('vocab_$_vocabIndex'),
        question: _vocabQueue[_vocabIndex],
        progressLabel: context.l10n.lessonProgressVocab(_currentStep, _totalSteps),
        onAnswered: _onVocabAnswered,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_totalSteps > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4),
            child: Text(
              context.l10n.lessonProgressFirst(_totalSteps),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: RomanColors.goldDark),
            ),
          ),
        _buildInteractiveExerciseSection(lesson),
      ],
    );
  }

  Widget _buildInteractiveExerciseSection(Lesson lesson) {
    if (lesson.type == 'puzzle' && lesson.words.isNotEmpty) {
      return WordPuzzleWidget(
        availableWords: lesson.words,
        targetSolution: lesson.solution ?? lesson.latin ?? lesson.words.join(' '),
        latinPhrase: lesson.latin,
        onCompleted: _onMainDone,
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
        onCompleted: _onMainDone,
        onMistake: () => _mistakes++,
      );
    } else if (lesson.type == 'decodeur' && lesson.words.isNotEmpty) {
      return CaseDecoderWidget(
        words: lesson.words,
        expectedRoles: lesson.roles,
        latinPhrase: lesson.latin,
        traduction: lesson.traduction,
        onCompleted: _onMainDone,
        onMistake: () => _mistakes++,
      );
    } else if (lesson.type == 'arene' && lesson.questions.isNotEmpty) {
      return ArenaChallengeWidget(
        boss: lesson.boss,
        questions: lesson.questions,
        onCompleted: _onMainDone,
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
            lesson.question ?? context.l10n.lessonChooseAnswer,
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

            // Pour le lecteur d'écran : un bouton « Réponse A : … », avec son
            // état ; le barré et les couleurs ne lui disent rien.
            final peutToucher = !(isAnswered || isStruck);
            final etat = isStruck
                ? context.l10n.a11yStruck
                : (sealLabel == '✓' ? context.l10n.a11yCorrect : (sealLabel == '✗' ? context.l10n.a11yWrong : null));
            return Semantics(
              button: true,
              enabled: peutToucher,
              label: context.l10n.a11yAnswer(letters[pos.clamp(0, letters.length - 1)], optionText) +
                  (etat == null ? '' : ', $etat'),
              onTap: peutToucher ? () => _submitAnswer(optIndex) : null,
              excludeSemantics: true,
              child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: peutToucher ? () => _submitAnswer(optIndex) : null,
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
            ));
          }),

          if (canUseHint)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _useHint,
                icon: const Icon(Icons.lightbulb_outline_rounded, size: 18),
                label: Text(context.l10n.lessonHintButton),
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
        : context.l10n.lessonSelectedAnswer;

    // Rappel de méthode, jamais la solution.
    String advice = context.l10n.lessonAdviceReread;
    final lowerChosen = chosenOptText.toLowerCase();
    if (lowerChosen.contains('accusatif') || lowerChosen.contains('nominatif') || lowerChosen.contains('ablatif')) {
      advice = context.l10n.lessonAdviceCases;
    } else if (lowerChosen.contains('singulier') || lowerChosen.contains('pluriel')) {
      advice = context.l10n.lessonAdviceNumber;
    }

    // Explication propre à l'option réellement choisie (indice dans les données, pas dans _order).
    String? explicationChoisie;
    final choisie = selectedOption;
    if (choisie != null && choisie >= 0 && choisie < lesson.explications.length) {
      final e = lesson.explications[choisie].trim();
      if (e.isNotEmpty) explicationChoisie = e;
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
                    lupulusAnimation(LupulusMood.encouragement),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      'assets/images/lupulus/lupulus_reflexion_180.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.l10n.lessonNotQuite,
                  style: const TextStyle(
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
                TextSpan(text: context.l10n.lessonYouChose),
                TextSpan(
                  text: context.l10n.lessonChosenQuote(chosenOptText),
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
          if (explicationChoisie != null) ...[
            const SizedBox(height: 6),
            Text(
              explicationChoisie,
              style: const TextStyle(fontSize: 13.5, color: Color(0xFF66301D), height: 1.35),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: _retry,
                icon: const Icon(Icons.refresh, size: 18),
                label: Text(context.l10n.lessonRetry),
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
                  label: Text(context.l10n.lessonRetryWithHint),
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

/// Les étoiles du bilan apparaissent une à une, avec une note chacune.
class _ResultStars extends StatefulWidget {
  final int stars;
  const _ResultStars({required this.stars});

  @override
  State<_ResultStars> createState() => _ResultStarsState();
}

class _ResultStarsState extends State<_ResultStars> with SingleTickerProviderStateMixin {
  static const _step = 300; // ms entre deux étoiles
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350 + 3 * _step + 400),
  );
  int _played = 0;

  @override
  void initState() {
    super.initState();
    _c.addListener(() {
      final elapsed = _c.value * _c.duration!.inMilliseconds;
      while (_played < widget.stars && elapsed >= 350 + _played * _step) {
        _played++;
        AudioService().playStar();
        HapticFeedback.lightImpact();
      }
    });
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = _c.duration!.inMilliseconds;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final filled = i < widget.stars;
            final start = (350 + i * _step) / total;
            final t = ((_c.value - start) / (400 / total)).clamp(0.0, 1.0);
            final scale = filled ? Curves.elasticOut.transform(t) : 1.0;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.star_outline_rounded, size: 40, color: Color(0xFFCFC3B3)),
                  if (filled)
                    Transform.scale(
                      scale: scale,
                      child: const Icon(Icons.star_rounded, size: 40, color: RomanColors.imperialGold),
                    ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}

/// Récompense en sesterces : des pièces tombent dans la bourse puis le montant défile.
class _CoinReward extends StatefulWidget {
  final int amount;
  final Duration delay;
  const _CoinReward({required this.amount, required this.delay});

  @override
  State<_CoinReward> createState() => _CoinRewardState();
}

class _CoinRewardState extends State<_CoinReward> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  bool _started = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (!mounted) return;
      setState(() => _started = true);
      _c.forward();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) AudioService().playLessonDone();
      });
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          return Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              // Pièces qui tombent, décalées, vers la bourse.
              for (var i = 0; i < 5; i++)
                Builder(builder: (context) {
                  final t = ((_c.value - i * 0.08) / 0.6).clamp(0.0, 1.0);
                  final y = Curves.easeIn.transform(t);
                  return Positioned(
                    bottom: 20 + (1 - y) * 44,
                    left: null,
                    child: Transform.translate(
                      offset: Offset((i - 2) * 16.0 * (1 - y), 0),
                      child: Opacity(
                        opacity: _started ? (t < 1 ? 1.0 : 0.0) : 0.0,
                        child: const Text('🪙', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  );
                }),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: RomanColors.goldLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: RomanColors.imperialGold, width: 1.4),
                ),
                child: Text(
                  context.l10n.lessonRewardFloat((widget.amount * Curves.easeOut.transform(((_c.value - 0.4) / 0.6).clamp(0.0, 1.0))).round()),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF7A5901)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
