import 'package:flutter/material.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../../data/models/lesson.dart';
import '../../../data/repositories/game_repository.dart';

/// Écran de cours et d'exercice interactif adapté à l'écran tactile.
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

    setState(() {
      selectedOption = index;
      isAnswered = true;
      isCorrect = (index == widget.lesson.answer);
    });

    if (isCorrect) {
      widget.repo.completeLesson(widget.lesson.id, 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up, color: RomanColors.laurelGreen),
            tooltip: 'Prononcer en Latin',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('🔊 Prononciation : "${lesson.latin ?? lesson.title}"'),
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
            // 1. Contenu du Cours avec Parchemins
            RomanCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: RomanColors.imperialPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    lesson.content,
                    style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  const ParchmentCallout(
                    title: "Le Savais-tu ? 💡",
                    content: "En latin classique, la lettre C se prononce toujours [K] comme dans Circus (« Kirkous ») !",
                    isTip: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. Zone d'Exercice (Quiz / QCM Romain)
            if (lesson.options.isNotEmpty) ...[
              RomanCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.question ?? 'Choisis la bonne réponse :',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: RomanColors.imperialPurple,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Grille des options tactiles
                    ...List.generate(lesson.options.length, (optIndex) {
                      final optionText = lesson.options[optIndex];
                      final isSelected = (selectedOption == optIndex);

                      Color btnColor = Colors.white;
                      Color textColor = Colors.black87;
                      Color borderColor = RomanColors.imperialGold;

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

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: InkWell(
                          onTap: isAnswered ? null : () => _submitAnswer(optIndex),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: btnColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: borderColor, width: 1.5),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, offset: Offset(0, 1), blurRadius: 2),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: textColor.withOpacity(0.5)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${optIndex + 1}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    optionText,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    if (isAnswered) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isCorrect ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isCorrect ? RomanColors.laurelGreen : Colors.red,
                          ),
                        ),
                        child: Text(
                          isCorrect
                              ? '✓ Triomphe ! ${lesson.explanation ?? "Excellente réponse !"}\n+10 Sesterces remportés ! 🪙'
                              : '✗ Erreur antique. Révise bien la leçon avant de réessayer.',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isCorrect ? const Color(0xFF166534) : const Color(0xFF991B1B),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Center(
                        child: RomanButton(
                          text: isCorrect ? 'Terminer & Continuer' : 'Réessayer',
                          onPressed: () {
                            if (isCorrect) {
                              Navigator.pop(context);
                            } else {
                              setState(() {
                                isAnswered = false;
                                selectedOption = null;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
