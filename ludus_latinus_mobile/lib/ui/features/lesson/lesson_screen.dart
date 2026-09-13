import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../core/particles_overlay.dart';
import '../../core/lottie_effects.dart';
import '../../core/latin_pronunciation_modal.dart';
import '../../core/game_juice.dart';
import '../../../data/models/lesson.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import 'widgets/word_puzzle_widget.dart';
import 'widgets/cloze_fill_widget.dart';
import 'widgets/case_decoder_widget.dart';
import 'widgets/arena_challenge_widget.dart';

/// Écran de cours et d''exercice QCM 2x2 tactile au style épuré Monument Valley.
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
  bool _showHint = false;
  final GlobalKey<RomanScreenShakeState> _shakeKey = GlobalKey<RomanScreenShakeState>();

  void _submitAnswer(int index) {
    if (isAnswered) return;

    final correct = (index == widget.lesson.answer);
    HapticFeedback.mediumImpact();

    setState(() {
      selectedOption = index;
      isAnswered = true;
      isCorrect = correct;
    });

    if (isCorrect) {
      _handleSuccess();
    } else {
      AudioService().playError();
      _shakeKey.currentState?.shake(intensity: ShakeIntensity.light);
    }
  }

  void _handleSuccess() {
    AudioService().playTriumph();
    AudioService().playSesterces();
    RomanLottieEffects.showCoinShower(context);
    RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
    widget.repo.completeLesson(widget.lesson.id, 10);
    _showTriumphModal();
  }

  void _showTriumphModal() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Arc de Triomphe romain animé en tête de modale
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x28000000),
                    offset: Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  'assets/cinematics/triumph_arc.webp',
                  height: 96,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/victoire_320.png',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: RomanColors.goldLight,
                    border: Border.all(color: RomanColors.imperialGold, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        offset: Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/lupulus/lupulus_triomphe_180.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Text('👑', style: TextStyle(fontSize: 40)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const RomanWaxSeal(size: 60, label: 'SPQR'),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'VICTORIA ! TRIOMPHE !',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: RomanColors.imperialPurple,
                fontFamily: 'serif',
              ),
            ),
            const RomanMeanderDivider(height: 10, strokeWidth: 1.2, margin: EdgeInsets.symmetric(vertical: 6)),
            const SizedBox(height: 6),
            Text(
              widget.lesson.explanation ?? 'Excellente maîtrise du latin antique !',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: RomanColors.goldLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: RomanColors.imperialGold),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🪙 ', style: TextStyle(fontSize: 16)),
                  const Text(
                    '+',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF7A5901),
                    ),
                  ),
                  RollingSestercesCounter(
                    value: 10,
                    initialValue: 0,
                    showIcon: false,
                    duration: const Duration(milliseconds: 700),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF7A5901),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'remportés !',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF7A5901),
                    ),
                  ),
                ],
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
                        '${widget.repo.profile.completedLessons.length} / 26 leçons',
                        style: const TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  RomanElasticProgressBar(
                    value: (widget.repo.profile.completedLessons.length / 26.0).clamp(0.0, 1.0),
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
              text: 'CONTINUER L''AVENTURE ▶',
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

  String _getLessonIllustration() {
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
    return 'assets/images/musee_trophee_5eme.png';
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

  String _getHintForLesson(Lesson lesson) {
    if (lesson.explanation != null && lesson.explanation!.trim().isNotEmpty) {
      return lesson.explanation!;
    }
    final t = '${lesson.title} ${lesson.question ?? ''}'.toLowerCase();
    if (t.contains('cas') || t.contains('déclinaison') || t.contains('nominatif') || t.contains('accusatif')) {
      return 'Repère le rôle du mot : le Nominatif est le sujet (qui agit ?), l\'Accusatif est le COD (terminaison en -m au singulier, en -s au pluriel).';
    }
    if (t.contains('verbe') || t.contains('temps') || t.contains('parfait') || t.contains('imparfait')) {
      return 'Regarde bien la désinence du verbe : le suffixe -ba- marque l\'imparfait, tandis que le parfait indique une action achevée.';
    }
    if (t.contains('nombre') || t.contains('pluriel') || t.contains('singulier')) {
      return 'Observe attentivement la désinence finale : le singulier et le pluriel possèdent des terminaisons distinctes dans chaque déclinaison.';
    }
    return 'Cherche un mot français de la même famille étymologique pour retrouver la racine latine !';
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final illustration = _getLessonIllustration();

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: RomanColors.imperialPurple),
            tooltip: 'Prononciation Latine',
            onPressed: () {
              HapticFeedback.lightImpact();
              LatinPronunciationModal.show(context, lesson.latin ?? lesson.title);
            },
          ),
        ],
      ),
      body: RomanScreenShake(
        key: _shakeKey,
        child: SingleChildScrollView(
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
                  Row(
                    children: [
                      const Text('🪙 +10 HS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF7A5901))),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: widget.repo.isLessonCompleted(lesson.id)
                              ? const Color(0xFFE8F5E9)
                              : RomanColors.goldLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.repo.isLessonCompleted(lesson.id) ? '✓ Validée ⭐⭐⭐' : '🎯 Cycle 4',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: widget.repo.isLessonCompleted(lesson.id)
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFF7A5901),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 1. Illustration Héroïque Antique
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
                  Text(
                    lesson.content,
                    style: const TextStyle(fontSize: 13.5, height: 1.5, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  const ParchmentCallout(
                    title: "Le Savais-tu ? 💡",
                    content: "À Rome, les élèves écrivaient sur des tablettes de cire (tabulae) à l''aide d''un poinçon de bronze appelé stilus !",
                    isTip: true,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.end,
                    children: [
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
                          '🗣️ Prononciation',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          final phrase = lesson.latin ?? lesson.title;
                          LatinPronunciationModal.show(context, phrase);
                        },
                      ),
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
                        icon: const Icon(Icons.history_edu_rounded, size: 16),
                        label: const Text(
                          '📜 Anatomia • Décrypteur',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => _showDecrypterSheet(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 3. Exercice Interactif Pédagogique (adapté selon le type : QCM, Puzzle, Trou, Décodeur, Arène)
            _buildInteractiveExerciseSection(lesson),
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
      );
    } else if (lesson.type == 'decodeur' && lesson.words.isNotEmpty) {
      return CaseDecoderWidget(
        words: lesson.words,
        expectedRoles: lesson.roles,
        latinPhrase: lesson.latin,
        onCompleted: _handleSuccess,
      );
    } else if (lesson.type == 'arene' && lesson.questions.isNotEmpty) {
      return ArenaChallengeWidget(
        boss: lesson.boss,
        questions: lesson.questions,
        onCompleted: _handleSuccess,
      );
    } else if (lesson.options.isNotEmpty) {
      return _buildQcmExerciseCard(lesson);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildQcmExerciseCard(Lesson lesson) {
    return RomanCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📜 ', style: TextStyle(fontSize: 16)),
              Expanded(
                child: Text(
                  lesson.question ?? 'Choisis la bonne réponse :',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: RomanColors.imperialPurple,
                  ),
                ),
              ),
              if (!isAnswered) ...[
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _showHint = !_showHint;
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _showHint ? const Color(0xFFFFF3E0) : RomanColors.goldLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _showHint ? Colors.orange.shade700 : RomanColors.imperialGold,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('💡', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          _showHint ? 'Masquer' : 'Indice',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: _showHint ? Colors.orange.shade900 : const Color(0xFF7A5901),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (_showHint && !isAnswered) ...[
            const SizedBox(height: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0C475), width: 1.2),
                boxShadow: const [
                  BoxShadow(color: Color(0x0A000000), offset: Offset(0, 2), blurRadius: 4),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: RomanColors.palatinCream,
                      border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/lupulus/lupulus_aide_180.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Text('🐺', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'INDICE BIENVEILLANT DE LUPULUS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Color(0xFF8A5B00),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _getHintForLesson(lesson),
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),

          // Grille 2x2 des options tactiles
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.25,
            ),
            itemCount: lesson.options.length,
            itemBuilder: (context, optIndex) {
              final optionText = lesson.options[optIndex];
              final isSelected = (selectedOption == optIndex);
              const romanNumerals = ['I', 'II', 'III', 'IV'];
              final numeral = romanNumerals[optIndex.clamp(0, 3)];

              Color btnColor = Colors.white;
              Color textColor = RomanColors.charcoal;
              Color borderColor = RomanColors.marbleBorder;
              Color sealColor = const Color(0xFF8E1724); // Cire rouge impériale
              Color stampColor = const Color(0xFFFFDF85); // Or estampé
              String sealLabel = numeral;

              if (isAnswered) {
                if (optIndex == lesson.answer) {
                  btnColor = const Color(0xFFE8F5E9);
                  textColor = const Color(0xFF1B5E20);
                  borderColor = RomanColors.laurelGreen;
                  sealColor = const Color(0xFF1B5E20);
                  sealLabel = '✓';
                } else if (isSelected) {
                  btnColor = const Color(0xFFFFEBEE);
                  textColor = const Color(0xFFB71C1C);
                  borderColor = const Color(0xFFB71C1C);
                  sealColor = const Color(0xFF8B2500);
                  sealLabel = '✗';
                } else {
                  sealColor = const Color(0xFF9E8E81);
                  stampColor = Colors.white70;
                }
              }

              return InkWell(
                onTap: isAnswered ? null : () => _submitAnswer(optIndex),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: btnColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor, width: isSelected ? 2.0 : 1.4),
                    boxShadow: [
                      BoxShadow(
                        color: isAnswered && optIndex == lesson.answer
                            ? RomanColors.laurelGreen.withOpacity(0.25)
                            : const Color(0x0F000000),
                        offset: const Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      RomanWaxSeal(
                        size: 28,
                        label: sealLabel,
                        sealColor: sealColor,
                        stampColor: stampColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            optionText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          if (isAnswered && !isCorrect)
            _buildMagisterPedagogicalFeedback(context),
        ],
      ),
    );
  }

  void _showDecrypterSheet(BuildContext context) {
    HapticFeedback.mediumImpact();
    final latinSentence = widget.lesson.latin ?? 'Senatus Populusque Romanus urbem aedificat';
    final words = latinSentence.split(' ');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            int selectedWordIdx = 0;
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Text('🔬 ', style: TextStyle(fontSize: 22)),
                      const Expanded(
                        child: Text(
                          'ANATOMIA SENTENTIAE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'serif',
                            letterSpacing: 1,
                            color: RomanColors.imperialPurple,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Radiographie syntaxique : touche chaque mot latin pour analyser son cas grammatical et sa fonction.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(words.length, (idx) {
                      final word = words[idx];
                      final isSel = selectedWordIdx == idx;
                      Color caseCol = _guessCaseColor(word);

                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setSheetState(() => selectedWordIdx = idx);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel ? caseCol : caseCol.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: caseCol, width: isSel ? 2 : 1.2),
                          ),
                          child: Text(
                            word,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'serif',
                              color: isSel ? Colors.white : caseCol,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 18),
                  _buildWordAnatomyCard(words[selectedWordIdx.clamp(0, words.length - 1)]),
                  const SizedBox(height: 16),
                  RomanButton(
                    text: 'Fermer le Décrypteur',
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _guessCaseColor(String word) {
    final w = word.toLowerCase().replaceAll(RegExp(r'[^\w\s]+'), '');
    if (w.endsWith('am') || w.endsWith('um') || w.endsWith('as') || w.endsWith('os') || w.endsWith('em') || w.endsWith('es')) {
      return CaseColors.accusative;
    } else if (w.endsWith('ae') || w.endsWith('i') || w.endsWith('is') || w.endsWith('us') || w.endsWith('ei')) {
      return CaseColors.genitive;
    } else if (w.endsWith('t') || w.endsWith('nt') || w.endsWith('at') || w.endsWith('et') || w.endsWith('it') || w.endsWith('est') || w.endsWith('sunt')) {
      return RomanColors.imperialGold;
    } else if (w.endsWith('o') || w.endsWith('e') || w.endsWith('u') || w.endsWith('ibus')) {
      return CaseColors.ablative;
    }
    return CaseColors.nominative;
  }

  Widget _buildWordAnatomyCard(String rawWord) {
    final word = rawWord.replaceAll(RegExp(r'[^\w\s]+'), '');
    final color = _guessCaseColor(word);
    String cas = 'Nominatif (Sujet)';
    String desinence = 'Terminaison en -a ou -us';
    String role = 'Indique qui accomplit l''action ou de qui l''on parle.';

    if (color == CaseColors.accusative) {
      cas = 'Accusatif (Complément d''Objet Direct)';
      desinence = 'Terminaison en -m ou -s';
      role = 'Désigne l''être ou la chose qui subit directement l''action du verbe.';
    } else if (color == CaseColors.genitive) {
      cas = 'Génitif (Complément du Nom)';
      desinence = 'Terminaison en -ae, -i ou -is';
      role = 'Marque l''appartenance, la possession ou l''origine.';
    } else if (color == RomanColors.imperialGold) {
      cas = 'Verbe (Action / État)';
      desinence = 'Désinence verbale personnelle';
      role = 'Noyau prédicatif qui exprime ce qui se passe dans la proposition.';
    } else if (color == CaseColors.ablative) {
      cas = 'Ablatif (Complément Circonstanciel)';
      desinence = 'Terminaison en -o, -e, -u ou -ibus';
      role = 'Précise le lieu, le temps, le moyen ou la manière.';
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: RomanColors.palatinCream,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.6), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                word,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'serif',
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  cas,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.volume_up_rounded, size: 20, color: RomanColors.imperialPurple),
                tooltip: 'Prononciation latine certifiée',
                onPressed: () => LatinPronunciationModal.show(context, word),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('• Désinence : $desinence', style: const TextStyle(fontSize: 12, color: Colors.black87)),
          const SizedBox(height: 2),
          Text('• Rôle : $role', style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildMagisterPedagogicalFeedback(BuildContext context) {
    final chosenOptText = (selectedOption != null && selectedOption! < widget.lesson.options.length)
        ? widget.lesson.options[selectedOption!]
        : 'Réponse sélectionnée';

    // Analyse pédagogique contextuelle du piège
    String distractorAnalysis = 'Cette option semblait tentante, mais elle ne correspond pas à la règle antique énoncée ci-dessus.';
    final lowerChosen = chosenOptText.toLowerCase();
    if (lowerChosen.contains('[k]') || lowerChosen.contains('[s]') || lowerChosen.contains('ou') || lowerChosen.contains('pronon')) {
      distractorAnalysis = 'Attention à la prononciation classique restituée : à l\'époque de Cicéron, le C claquait toujours [K] et le V sonnait [OU] / [W] !';
    } else if (lowerChosen.contains('accusatif') || lowerChosen.contains('nominatif') || lowerChosen.contains('ablatif')) {
      distractorAnalysis = 'Piège de cas classique : vérifie bien qui fait l\'action (nominatif) et qui la subit (accusatif en -m/-s).';
    } else if (lowerChosen.contains('singulier') || lowerChosen.contains('pluriel')) {
      distractorAnalysis = 'Vérifie bien le nombre (singulier vs pluriel) en observant attentivement la désinence finale.';
    }

    final explanation = widget.lesson.explanation;

    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE28B68), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11E28B68),
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
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
                    errorBuilder: (_, __, ___) => const Center(
                      child: Text('🏛️', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONSEIL DU MAGISTER LUPULUS',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'serif',
                        letterSpacing: 0.8,
                        color: Color(0xFF94381E),
                      ),
                    ),
                    Text(
                      'Échec instructif • Analyse de l\'erreur',
                      style: TextStyle(fontSize: 10.5, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5DA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Piège antique',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFB71C1C)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Choix de l'élève
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12, color: RomanColors.charcoal),
              children: [
                const TextSpan(text: 'Tu as choisi : ', style: TextStyle(fontWeight: FontWeight.w600)),
                TextSpan(
                  text: '« $chosenOptText »',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB71C1C)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Décryptage
          Text(
            distractorAnalysis,
            style: const TextStyle(fontSize: 12, color: Color(0xFF66301D), height: 1.35),
          ),

          if (explanation != null && explanation.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: RomanColors.marbleBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡 ', style: TextStyle(fontSize: 14)),
                  Expanded(
                    child: Text(
                      'Indice du parchemin : $explanation',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: RomanColors.imperialPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Boutons d'action : Réessayer + Écouter la prononciation
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      isAnswered = false;
                      selectedOption = null;
                      _showHint = true;
                    });
                  },
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Réessayer avec l\'indice'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF94381E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    textStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {
                  final phrase = widget.lesson.latin ?? widget.lesson.title;
                  LatinPronunciationModal.show(context, phrase);
                },
                icon: const Icon(Icons.volume_up_rounded, size: 16),
                label: const Text('Écouter'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: RomanColors.imperialPurple,
                  side: const BorderSide(color: RomanColors.imperialPurple),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  textStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}