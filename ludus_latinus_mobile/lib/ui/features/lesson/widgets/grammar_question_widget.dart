import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../data/models/lesson.dart';
import '../../../../data/services/audio_service.dart';
import '../../../core/themes.dart';
import '../../../core/widgets.dart';

/// Question de grammaire d'une leçon : un QCM à options mélangées. Une mauvaise
/// réponse est marquée et son explication s'affiche ; l'élève réessaie jusqu'à
/// trouver. La bonne réponse déclenche [onCompleted].
class GrammarQuestionWidget extends StatefulWidget {
  final GrammarQuestion question;
  final String progressLabel;
  final VoidCallback onCompleted;
  final VoidCallback onMistake;

  const GrammarQuestionWidget({
    super.key,
    required this.question,
    required this.progressLabel,
    required this.onCompleted,
    required this.onMistake,
  });

  @override
  State<GrammarQuestionWidget> createState() => _GrammarQuestionWidgetState();
}

class _GrammarQuestionWidgetState extends State<GrammarQuestionWidget> {
  late final List<int> _order;
  final Set<int> _wrong = {};
  int? _lastWrong;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _order = List.generate(widget.question.options.length, (i) => i)..shuffle();
  }

  void _choose(int i) {
    if (_done || _wrong.contains(i)) return;
    HapticFeedback.mediumImpact();
    if (i == widget.question.answer) {
      setState(() {
        _done = true;
        _lastWrong = null;
      });
      widget.onCompleted();
    } else {
      AudioService().playError();
      widget.onMistake();
      setState(() {
        _wrong.add(i);
        _lastWrong = i;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    const letters = ['A', 'B', 'C', 'D', 'E', 'F'];
    final last = _lastWrong;
    final explication = (last != null && last < q.explications.length) ? q.explications[last].trim() : '';

    return RomanCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.progressLabel,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: RomanColors.goldDark),
          ),
          const SizedBox(height: 6),
          const Text(
            'Exercice de grammaire',
            style: TextStyle(fontSize: 17, height: 1.3, fontWeight: FontWeight.bold, fontFamily: 'serif', color: RomanColors.imperialPurple),
          ),
          const SizedBox(height: 6),
          Text(
            q.question,
            style: const TextStyle(fontSize: 16, height: 1.3, fontWeight: FontWeight.bold, color: RomanColors.imperialPurple),
          ),
          const SizedBox(height: 12),
          ...List.generate(_order.length, (pos) {
            final i = _order[pos];
            final isWrong = _wrong.contains(i);
            Color bg = Colors.white;
            Color border = RomanColors.marbleBorder;
            Color text = RomanColors.charcoal;
            String seal = letters[pos.clamp(0, letters.length - 1)];
            Color sealColor = const Color(0xFF8E1724);
            if (_done && i == widget.question.answer) {
              bg = const Color(0xFFE8F5E9);
              border = RomanColors.laurelGreen;
              text = const Color(0xFF1B5E20);
              seal = '✓';
              sealColor = const Color(0xFF1B5E20);
            } else if (isWrong) {
              bg = const Color(0xFFFFEBEE);
              border = const Color(0xFFB71C1C);
              text = const Color(0xFFB71C1C);
              seal = '✗';
              sealColor = const Color(0xFF8B2500);
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: (_done || isWrong) ? null : () => _choose(i),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 56),
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
          if (last != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE28B68)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pas tout à fait… Réessaie.',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF94381E)),
                  ),
                  if (explication.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(explication, style: const TextStyle(fontSize: 13.5, color: Color(0xFF66301D), height: 1.35)),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
