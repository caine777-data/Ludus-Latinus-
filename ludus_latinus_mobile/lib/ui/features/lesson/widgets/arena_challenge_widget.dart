import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes.dart';
import '../../../core/widgets.dart';
import '../../../core/game_juice.dart';
import '../../../../data/services/audio_service.dart';

/// Widget interactif pour les exercices de type 'arene' (défis de fin de monde contre les boss)
class ArenaChallengeWidget extends StatefulWidget {
  final Map<String, dynamic>? boss;
  final List<Map<String, dynamic>> questions;
  final VoidCallback onCompleted;
  /// Appelé à chaque erreur, pour calculer les étoiles de la leçon.
  final VoidCallback? onMistake;

  const ArenaChallengeWidget({
    super.key,
    this.boss,
    required this.questions,
    required this.onCompleted,
    this.onMistake,
  });

  @override
  State<ArenaChallengeWidget> createState() => _ArenaChallengeWidgetState();
}

class _ArenaChallengeWidgetState extends State<ArenaChallengeWidget> {
  int _currentQuestionIndex = 0;
  late int _bossHp;
  late int _maxBossHp;
  int? _selectedOption;
  bool _isAnswered = false;
  bool _isSuccess = false;

  // L'enjeu : trois vies. Une erreur en coûte une ; à zéro, l'arène est à refaire.
  static const int viesAuDepart = 3;
  int _vies = viesAuDepart;
  bool _vaincu = false;
  // Après une bonne réponse, l'explication reste affichée jusqu'à « Continuer ».
  bool _attendSuite = false;

  final GlobalKey<RomanScreenShakeState> _shakeKey = GlobalKey<RomanScreenShakeState>();
  late List<List<int>> _ordres = _melanger();

  List<List<int>> _melanger() => [
        for (final q in widget.questions)
          List.generate((q['options'] as List).length, (i) => i)..shuffle()
      ];

  void _recommencer() {
    setState(() {
      _currentQuestionIndex = 0;
      _bossHp = _maxBossHp;
      _vies = viesAuDepart;
      _vaincu = false;
      _attendSuite = false;
      _selectedOption = null;
      _isAnswered = false;
      _ordres = _melanger();
    });
  }

  void _continuer() {
    if (_bossHp <= 0 || _currentQuestionIndex >= widget.questions.length - 1) {
      setState(() {
        _isSuccess = true;
        _attendSuite = false;
      });
      widget.onCompleted();
    } else {
      setState(() {
        _currentQuestionIndex++;
        _selectedOption = null;
        _isAnswered = false;
        _attendSuite = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _maxBossHp = (widget.boss?['pv'] as int?) ?? math.max(1, widget.questions.length);
    _bossHp = _maxBossHp;
  }

  void _submitAnswer(int optIndex) {
    if (_isAnswered || _isSuccess || _vaincu) return;

    final currentQ = widget.questions[_currentQuestionIndex];
    final answerIdx = currentQ['answer'] as int? ?? 0;
    final isCorrect = (optIndex == answerIdx);

    setState(() {
      _selectedOption = optIndex;
      _isAnswered = true;
    });

    if (isCorrect) {
      HapticFeedback.heavyImpact();
      AudioService().playSwordClash();
      _shakeKey.currentState?.shake(intensity: ShakeIntensity.medium);

      setState(() {
        _bossHp = math.max(0, _bossHp - 1);
        _attendSuite = true;
      });
    } else {
      HapticFeedback.mediumImpact();
      widget.onMistake?.call();
      AudioService().playError();
      _shakeKey.currentState?.shake(intensity: ShakeIntensity.heavy);
      setState(() => _vies--);

      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            if (_vies <= 0) {
              _vaincu = true;
            } else {
              _selectedOption = null;
              _isAnswered = false;
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return const SizedBox.shrink();
    }

    final bossName = widget.boss?['nom'] as String? ?? 'Champion de l\'Arène';
    final bossIcon = widget.boss?['icone'] as String? ?? '⚔️';
    final currentQ = widget.questions[_currentQuestionIndex];
    final options = (currentQ['options'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();
    final questionText = currentQ['question'] as String? ?? 'Réponds à la provocation du Boss :';
    final expectedAnswer = currentQ['answer'] as int? ?? 0;
    final explication = currentQ['explanation'] as String? ?? '';

    return RomanScreenShake(
      key: _shakeKey,
      child: RomanCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. En-tête Boss de Fin de Monde
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A0E17), Color(0xFF2C070F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                boxShadow: const [
                  BoxShadow(color: Color(0x3344101A), offset: Offset(0, 4), blurRadius: 10),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0D0),
                      shape: BoxShape.circle,
                      border: Border.all(color: RomanColors.imperialGold, width: 1.4),
                    ),
                    child: Text(bossIcon, style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bossName.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFFFFE082),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            fontFamily: 'serif',
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Text('Points de Vie : ', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            Text(
                              '$_bossHp / $_maxBossHp',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (_bossHp / _maxBossHp).clamp(0.0, 1.0),
                            minHeight: 6,
                            backgroundColor: Colors.black45,
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF3D00)),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Text('Tes vies : ', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            for (var i = 0; i < viesAuDepart; i++)
                              Icon(
                                i < _vies ? Icons.favorite : Icons.favorite_border,
                                size: 14,
                                color: i < _vies ? const Color(0xFFFF6E6E) : Colors.white38,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: RomanColors.imperialPurple,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: RomanColors.imperialGold),
                    ),
                    child: Text(
                      '${_currentQuestionIndex + 1}/${widget.questions.length}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            if (_vaincu) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '$bossName t\'a repoussé !',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: RomanColors.imperialPurple,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Tu n\'as plus de vie. Relis le cours du monde si besoin, puis retente ta chance : '
                      'les réponses auront changé de place.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.5, height: 1.35, color: RomanColors.charcoal),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _recommencer,
                      icon: const Icon(Icons.replay),
                      label: const Text('Retenter l\'arène'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RomanColors.imperialPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
            // 2. Question en cours
            Text(
              questionText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: RomanColors.imperialPurple,
              ),
            ),
            const SizedBox(height: 12),

            // 3. Grille des 4 options de réponse
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.9,
              ),
              itemCount: options.length,
              itemBuilder: (context, pos) {
                final optIndex = _ordres[_currentQuestionIndex][pos];
                final optionText = options[optIndex];
                final isSelected = (_selectedOption == optIndex);

                Color btnColor = Colors.white;
                Color textColor = RomanColors.charcoal;
                Color borderColor = RomanColors.marbleBorder;

                if (_isAnswered) {
                  if (optIndex == expectedAnswer && isSelected) {
                    btnColor = const Color(0xFFE8F5E9);
                    textColor = const Color(0xFF1B5E20);
                    borderColor = RomanColors.laurelGreen;
                  } else if (isSelected) {
                    btnColor = const Color(0xFFFFEBEE);
                    textColor = const Color(0xFFB71C1C);
                    borderColor = const Color(0xFFB71C1C);
                  }
                }

                return InkWell(
                  onTap: _isAnswered ? null : () => _submitAnswer(optIndex),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: btnColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: isSelected ? 2.0 : 1.2),
                      boxShadow: const [
                        BoxShadow(color: Color(0x0E000000), offset: Offset(0, 2), blurRadius: 4),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      optionText,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                );
              },
            ),
            if (_attendSuite) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: RomanColors.laurelGreen),
                ),
                child: Text(
                  explication.isEmpty ? 'Touché !' : 'Touché ! $explication',
                  style: const TextStyle(fontSize: 12.5, height: 1.35, color: Color(0xFF1B5E20)),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _continuer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: RomanColors.imperialPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  _bossHp <= 0 || _currentQuestionIndex >= widget.questions.length - 1
                      ? 'Porter le coup final'
                      : 'Continuer le combat',
                ),
              ),
            ] else if (_isAnswered && _selectedOption != expectedAnswer && _vies > 0) ...[
              const SizedBox(height: 10),
              Text(
                'Raté ! Il te reste $_vies ${_vies > 1 ? 'vies' : 'vie'}. Essaie une autre réponse.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFFB71C1C)),
              ),
            ],
            ],
          ],
        ),
      ),
    );
  }
}
