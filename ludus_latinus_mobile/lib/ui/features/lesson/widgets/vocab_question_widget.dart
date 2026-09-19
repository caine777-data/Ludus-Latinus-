import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../data/models/vocab_question.dart';
import '../../../../data/services/audio_service.dart';
import '../../../core/themes.dart';
import '../../../core/widgets.dart';

/// Question de vocabulaire à 4 choix. Après une erreur, la bonne réponse est
/// montrée avec l'exemple du Thesaurus : la question sera reposée en fin de série.
class VocabQuestionWidget extends StatefulWidget {
  final VocabQuestion question;
  final String progressLabel;
  final void Function(bool correct) onAnswered;

  const VocabQuestionWidget({
    super.key,
    required this.question,
    required this.progressLabel,
    required this.onAnswered,
  });

  @override
  State<VocabQuestionWidget> createState() => _VocabQuestionWidgetState();
}

class _VocabQuestionWidgetState extends State<VocabQuestionWidget> {
  int? _selected;

  bool get _answered => _selected != null;
  bool get _correct => _selected == widget.question.answer;

  void _choose(int i) {
    if (_answered) return;
    setState(() => _selected = i);
    if (i == widget.question.answer) {
      AudioService().playCorrect();
    } else {
      AudioService().playError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    const letters = ['A', 'B', 'C', 'D'];

    return RomanCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.progressLabel,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: RomanColors.goldDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            q.prompt,
            style: const TextStyle(fontSize: 17, height: 1.3, fontWeight: FontWeight.bold, color: RomanColors.imperialPurple),
          ),
          const SizedBox(height: 12),
          ...List.generate(q.options.length, (i) {
            Color bg = Colors.white;
            Color border = RomanColors.marbleBorder;
            Color text = RomanColors.charcoal;
            String seal = letters[i];
            Color sealColor = const Color(0xFF8E1724);
            if (_answered && i == q.answer) {
              bg = const Color(0xFFE8F5E9);
              border = RomanColors.laurelGreen;
              text = const Color(0xFF1B5E20);
              seal = '✓';
              sealColor = const Color(0xFF1B5E20);
            } else if (_answered && i == _selected) {
              bg = const Color(0xFFFFEBEE);
              border = const Color(0xFFB71C1C);
              text = const Color(0xFFB71C1C);
              seal = '✗';
              sealColor = const Color(0xFF8B2500);
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: _answered ? null : () => _choose(i),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  constraints: const BoxConstraints(minHeight: 54),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: border, width: 1.4),
                  ),
                  child: Row(
                    children: [
                      RomanWaxSeal(size: 30, label: seal, sealColor: sealColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          q.options[i],
                          style: TextStyle(fontSize: 15, height: 1.3, fontWeight: FontWeight.w600, color: text),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (_answered) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _correct ? const Color(0xFFF1F8F3) : const Color(0xFFFFF7F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _correct ? RomanColors.laurelGreen.withOpacity(0.4) : const Color(0xFFE28B68)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _correct ? 'Optime !' : 'Retiens bien : la question reviendra à la fin.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _correct ? const Color(0xFF1B5E20) : const Color(0xFF94381E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${q.entry.latin} : ${q.entry.fr}',
                    style: const TextStyle(fontSize: 13.5, color: RomanColors.charcoal, height: 1.35),
                  ),
                  if (q.entry.ex.isNotEmpty)
                    Text(
                      '« ${q.entry.ex} » ${q.entry.exFr}',
                      style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.black54, height: 1.35),
                    ),
                  if (q.entry.etym.isNotEmpty)
                    Text(
                      'En français : ${q.entry.etym}',
                      style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.35),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                widget.onAnswered(_correct);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: RomanColors.imperialPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('CONTINUER'),
            ),
          ],
        ],
      ),
    );
  }
}
