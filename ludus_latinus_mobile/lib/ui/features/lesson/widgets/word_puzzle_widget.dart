import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes.dart';
import '../../../core/widgets.dart';
import '../../../core/game_juice.dart';
import '../../../../data/services/audio_service.dart';

/// Widget interactif pour les exercices de type 'puzzle' :
/// Reconstitution de phrase latine ou traduction française par jetons de mots cliquables.
class WordPuzzleWidget extends StatefulWidget {
  final List<String> availableWords;
  final String targetSolution;
  final String? latinPhrase;
  final VoidCallback onCompleted;

  const WordPuzzleWidget({
    super.key,
    required this.availableWords,
    required this.targetSolution,
    this.latinPhrase,
    required this.onCompleted,
  });

  @override
  State<WordPuzzleWidget> createState() => _WordPuzzleWidgetState();
}

class _WordPuzzleWidgetState extends State<WordPuzzleWidget> {
  late List<String> _bankWords;
  final List<String> _selectedWords = [];
  bool _isEvaluated = false;
  bool _isSuccess = false;
  String? _feedbackMessage;
  final GlobalKey<RomanScreenShakeState> _shakeKey = GlobalKey<RomanScreenShakeState>();

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    setState(() {
      _bankWords = List<String>.from(widget.availableWords)..shuffle();
      _selectedWords.clear();
      _isEvaluated = false;
      _isSuccess = false;
      _feedbackMessage = null;
    });
  }

  void _onWordTappedFromBank(int index) {
    if (_isSuccess) return;
    HapticFeedback.selectionClick();
    AudioService().playCardFlip();
    setState(() {
      final word = _bankWords.removeAt(index);
      _selectedWords.add(word);
      _isEvaluated = false;
      _feedbackMessage = null;
    });
  }

  void _onWordTappedFromSelected(int index) {
    if (_isSuccess) return;
    HapticFeedback.lightImpact();
    setState(() {
      final word = _selectedWords.removeAt(index);
      _bankWords.add(word);
      _isEvaluated = false;
      _feedbackMessage = null;
    });
  }

  String _cleanString(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[.,!?;:\"«»'']'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  void _verifySentence() {
    if (_selectedWords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Touche des mots pour composer ta phrase avant de valider !'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final proposition = _cleanString(_selectedWords.join(' '));
    final expected = _cleanString(widget.targetSolution);

    final success = proposition == expected;

    setState(() {
      _isEvaluated = true;
      _isSuccess = success;
    });

    if (success) {
      HapticFeedback.heavyImpact();
      widget.onCompleted();
    } else {
      HapticFeedback.mediumImpact();
      AudioService().playError();
      _shakeKey.currentState?.shake(intensity: ShakeIntensity.medium);
      setState(() {
        _feedbackMessage = '« Ce n\'est pas tout à fait le bon ordre des mots. Réessaie ! »';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RomanScreenShake(
      key: _shakeKey,
      child: RomanCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. En-tête de consigne
            Row(
              children: [
                const Text('🧩 ', style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PUZZLE DE SYNTAXE ROMAINE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: Color(0xFFB37400),
                          fontFamily: 'serif',
                        ),
                      ),
                      if (widget.latinPhrase != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Traduis ou réordonne : « ${widget.latinPhrase} »',
                          style: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: RomanColors.imperialPurple,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, size: 20, color: Colors.black54),
                  tooltip: 'Réinitialiser les mots',
                  onPressed: _resetGame,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 2. Zone de composition (La phrase construite par l'élève)
            Container(
              constraints: const BoxConstraints(minHeight: 74),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _isSuccess
                    ? const Color(0xFFE8F5E9)
                    : (_isEvaluated && !_isSuccess
                        ? const Color(0xFFFFEBEE)
                        : const Color(0xFFF9F6F0)),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _isSuccess
                      ? RomanColors.laurelGreen
                      : (_isEvaluated && !_isSuccess
                          ? Colors.redAccent
                          : RomanColors.imperialGold),
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(color: Color(0x0C000000), blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: _selectedWords.isEmpty
                  ? const Center(
                      child: Text(
                        'Touche les mots ci-dessous pour assembler la phrase dans le bon ordre ✍️',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.black45, fontStyle: FontStyle.italic),
                      ),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: List.generate(_selectedWords.length, (idx) {
                        return GestureDetector(
                          onTap: () => _onWordTappedFromSelected(idx),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: RomanColors.imperialPurple,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(color: Color(0x22000000), offset: Offset(0, 2), blurRadius: 4),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _selectedWords[idx],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.close_rounded, size: 14, color: Colors.white70),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
            ),

            if (_feedbackMessage != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Row(
                  children: [
                    const Text('🐺', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _feedbackMessage!,
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF7A4E0B)),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 14),

            // 3. Banque de mots disponibles
            const Text(
              'MOTS DISPONIBLES :',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.6,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_bankWords.length, (idx) {
                return InkWell(
                  onTap: () => _onWordTappedFromBank(idx),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                      boxShadow: const [
                        BoxShadow(color: Color(0x10000000), offset: Offset(0, 2), blurRadius: 4),
                      ],
                    ),
                    child: Text(
                      _bankWords[idx],
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: RomanColors.charcoal,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            // 4. Bouton de vérification
            if (!_isSuccess)
              RomanButton(
                text: 'VÉRIFIER LA PHRASE ▶',
                backgroundColor: RomanColors.imperialPurple,
                textColor: RomanColors.goldLight,
                isLarge: true,
                onPressed: _verifySentence,
              ),
          ],
        ),
      ),
    );
  }
}
