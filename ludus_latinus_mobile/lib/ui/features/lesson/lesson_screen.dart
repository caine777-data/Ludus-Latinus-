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
      AudioService().playTriumph();
      AudioService().playSesterces();
      RomanLottieEffects.showCoinShower(context);
      RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
      widget.repo.completeLesson(widget.lesson.id, 10);
      _showTriumphModal();
    } else {
      AudioService().playError();
      _shakeKey.currentState?.shake(intensity: ShakeIntensity.light);
    }
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
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: RomanColors.goldLight,
                border: Border.all(color: RomanColors.imperialGold, width: 2),
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

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final illustration = _getLessonIllustration();

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_outlined, color: RomanColors.imperialPurple),
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

            const SizedBox(height: 14),

            // 2. Parchemin de Leçon
            RomanCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        icon: const Icon(Icons.biotech_outlined, size: 16),
                        label: const Text(
                          '🔬 Anatomia • Décrypteur',
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

            // 3. Question et Grille QCM Tactile 2x2
            if (lesson.options.isNotEmpty) ...[
              RomanCard(
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
                      ],
                    ),
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
                        const romanSeals = ['[I]', '[II]', '[III]', '[IV]'];

                        Color btnColor = Colors.white;
                        Color textColor = RomanColors.charcoal;
                        Color borderColor = RomanColors.marbleBorder;

                        if (isAnswered) {
                          if (optIndex == lesson.answer) {
                            btnColor = RomanColors.laurelGreen;
                            textColor = Colors.white;
                            borderColor = RomanColors.laurelGreen;
                          } else if (isSelected) {
                            btnColor = const Color(0xFF8B2500);
                            textColor = Colors.white;
                            borderColor = const Color(0xFF8B2500);
                          }
                        }

                        return InkWell(
                          onTap: isAnswered ? null : () => _submitAnswer(optIndex),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: btnColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor, width: 1.5),
                              boxShadow: const [
                                BoxShadow(color: Color(0x0A000000), offset: Offset(0, 2), blurRadius: 4),
                              ],
                            ),
                            child: Row(
                              children: [
                                Text(
                                  romanSeals[optIndex.clamp(0, 3)],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    fontFamily: 'serif',
                                    color: isAnswered && (optIndex == lesson.answer || isSelected)
                                        ? Colors.white70
                                        : RomanColors.imperialPurple,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      optionText,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
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
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
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
                icon: const Icon(Icons.volume_up_outlined, size: 20, color: RomanColors.imperialPurple),
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
                icon: const Icon(Icons.volume_up_outlined, size: 16),
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