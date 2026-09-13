import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes.dart';
import '../../../core/widgets.dart';
import '../../../core/game_juice.dart';
import '../../../../data/services/audio_service.dart';

/// Widget interactif pour les exercices de type 'trou' :
/// Complétion de texte, recherche de cas, désinence ou radical manquant.
class ClozeFillWidget extends StatefulWidget {
  final String? consigne;
  final String? avant;
  final String? apres;
  final String solution;
  final List<String> options;
  final String? latinComplet;
  final VoidCallback onCompleted;

  const ClozeFillWidget({
    super.key,
    this.consigne,
    this.avant,
    this.apres,
    required this.solution,
    this.options = const [],
    this.latinComplet,
    required this.onCompleted,
  });

  @override
  State<ClozeFillWidget> createState() => _ClozeFillWidgetState();
}

class _ClozeFillWidgetState extends State<ClozeFillWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isEvaluated = false;
  bool _isSuccess = false;
  String? _feedbackMessage;
  final GlobalKey<RomanScreenShakeState> _shakeKey = GlobalKey<RomanScreenShakeState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _cleanString(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[.,!?;:\"«»'']'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  void _verifyInput(String value) {
    final input = _cleanString(value);
    final expected = _cleanString(widget.solution);

    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complète la case vide avant de vérifier !'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Tolérance : accepte la solution exacte ou solution complète
    final success = (input == expected) ||
        (widget.latinComplet != null && _cleanString(input) == _cleanString(widget.latinComplet!));

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
        _feedbackMessage = '« Ce n\'est pas tout à fait cette terminaison. Observe bien le rôle du mot ! »';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final avantText = widget.avant ?? '';
    final apresText = widget.apres ?? '';

    return RomanScreenShake(
      key: _shakeKey,
      child: RomanCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. En-tête
            Row(
              children: [
                const Text('✏️ ', style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Text(
                    widget.consigne ?? 'Complète la phrase latine avec la bonne forme :',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: RomanColors.imperialPurple,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 2. Zone d'affichage de la phrase à trou
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFBF8F2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _isSuccess
                      ? RomanColors.laurelGreen
                      : (_isEvaluated ? Colors.redAccent : RomanColors.imperialGold),
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(color: Color(0x0A000000), blurRadius: 6, offset: Offset(0, 2)),
                ],
              ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                spacing: 4,
                runSpacing: 8,
                children: [
                  if (avantText.isNotEmpty)
                    Text(
                      avantText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'serif',
                        color: RomanColors.charcoal,
                      ),
                    ),
                  // Zone de saisie / trou
                  Container(
                    width: 120,
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isSuccess
                            ? RomanColors.laurelGreen
                            : (_isEvaluated ? Colors.redAccent : RomanColors.imperialPurple),
                        width: 1.8,
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      enabled: !_isSuccess,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'serif',
                        color: _isSuccess ? RomanColors.laurelGreen : RomanColors.imperialPurple,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '...',
                        hintStyle: TextStyle(color: Colors.black26),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      onSubmitted: _verifyInput,
                    ),
                  ),
                  if (apresText.isNotEmpty)
                    Text(
                      apresText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'serif',
                        color: RomanColors.charcoal,
                      ),
                    ),
                ],
              ),
            ),

            if (_feedbackMessage != null) ...[
              const SizedBox(height: 10),
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

            // 3. Options rapides de désinences (si présentes dans la leçon)
            if (widget.options.isNotEmpty && !_isSuccess) ...[
              const SizedBox(height: 14),
              const Text(
                'OPTIONS DISPONIBLES (CLIQUE POUR SÉLECTIONNER) :',
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.5),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.options.map((opt) {
                  return InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      _controller.text = opt;
                      _verifyInput(opt);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: RomanColors.goldLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                      ),
                      child: Text(
                        opt,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: RomanColors.imperialPurple,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 16),

            // 4. Bouton de validation
            if (!_isSuccess)
              RomanButton(
                text: 'VALIDER LA TERMINAISON ▶',
                backgroundColor: RomanColors.imperialPurple,
                textColor: RomanColors.goldLight,
                isLarge: true,
                onPressed: () => _verifyInput(_controller.text),
              ),
          ],
        ),
      ),
    );
  }
}
