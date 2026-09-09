import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../../data/models/lesson.dart';
import '../../../data/repositories/game_repository.dart';

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
      widget.repo.completeLesson(widget.lesson.id, 10);
      _showTriumphModal();
    } else {
      HapticFeedback.vibrate();
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
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🪙 ', style: TextStyle(fontSize: 16)),
                  Text(
                    '+10 Sesterces remportés !',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF7A5901),
                    ),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('🔊 Prononciation : ""'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                        childAspectRatio: 2.1,
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
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    if (isAnswered && !isCorrect) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F0),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.redAccent),
                        ),
                        child: Row(
                          children: [
                            const Text('🤔 ', style: TextStyle(fontSize: 18)),
                            const Expanded(
                              child: Text(
                                'Erreur antique. Relis le parchemin et retente ta chance !',
                                style: TextStyle(fontSize: 12, color: Color(0xFF991B1B)),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isAnswered = false;
                                  selectedOption = null;
                                });
                              },
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}