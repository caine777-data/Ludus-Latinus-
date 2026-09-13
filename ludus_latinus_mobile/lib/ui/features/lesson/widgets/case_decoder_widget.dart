import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes.dart';
import '../../../core/widgets.dart';
import '../../../core/game_juice.dart';
import '../../../../data/services/audio_service.dart';

/// Widget interactif pour les exercices de type 'decodeur' :
/// Radiographie syntaxique et attribution tactile des fonctions grammaticales (Sujet, COD, Verbe).
class CaseDecoderWidget extends StatefulWidget {
  final List<String> words;
  final Map<String, String> expectedRoles;
  final String? latinPhrase;
  final VoidCallback onCompleted;

  const CaseDecoderWidget({
    super.key,
    required this.words,
    required this.expectedRoles,
    this.latinPhrase,
    required this.onCompleted,
  });

  @override
  State<CaseDecoderWidget> createState() => _CaseDecoderWidgetState();
}

class _CaseDecoderWidgetState extends State<CaseDecoderWidget> {
  late Map<int, String?> _assignedRoles;
  int _selectedWordIndex = 0;
  bool _isEvaluated = false;
  bool _isSuccess = false;
  String? _feedbackMessage;
  final GlobalKey<RomanScreenShakeState> _shakeKey = GlobalKey<RomanScreenShakeState>();

  final List<Map<String, dynamic>> _availableGrammarRoles = [
    {
      'id': 'sujet',
      'label': 'Sujet (Nominatif)',
      'color': CaseColors.nominative,
      'icon': '🔵',
    },
    {
      'id': 'cod',
      'label': 'COD (Accusatif)',
      'color': CaseColors.accusative,
      'icon': '🔴',
    },
    {
      'id': 'verbe',
      'label': 'Verbe d\'action',
      'color': const Color(0xFFD4AF37),
      'icon': '🟢',
    },
  ];

  @override
  void initState() {
    super.initState();
    _assignedRoles = {for (var i = 0; i < widget.words.length; i++) i: null};
  }

  void _assignRoleToSelectedWord(String roleId) {
    if (_isSuccess) return;
    HapticFeedback.selectionClick();
    AudioService().playCardFlip();
    setState(() {
      _assignedRoles[_selectedWordIndex] = roleId;
      _isEvaluated = false;
      _feedbackMessage = null;

      // Avance automatiquement au mot suivant s'il n'a pas encore de rôle
      if (_selectedWordIndex < widget.words.length - 1) {
        _selectedWordIndex++;
      }
    });
  }

  Color _getColorForRole(String? roleId) {
    if (roleId == null) return Colors.white;
    final r = _availableGrammarRoles.firstWhere(
      (it) => it['id'] == roleId,
      orElse: () => {'color': RomanColors.marbleBorder},
    );
    return r['color'] as Color;
  }

  String _getLabelForRole(String? roleId) {
    if (roleId == null) return 'Rôle ?';
    final r = _availableGrammarRoles.firstWhere(
      (it) => it['id'] == roleId,
      orElse: () => {'label': 'Inconnu'},
    );
    return r['label'] as String;
  }

  void _verifyDecoding() {
    // Vérifier que tous les mots ont reçu un rôle
    if (_assignedRoles.values.any((r) => r == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attribue une fonction grammaticale à chaque mot avant de vérifier !'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    bool allCorrect = true;
    for (var i = 0; i < widget.words.length; i++) {
      final expected = widget.expectedRoles[i.toString()]?.toLowerCase().trim();
      final assigned = _assignedRoles[i]?.toLowerCase().trim();
      if (expected != null && assigned != expected) {
        allCorrect = false;
        break;
      }
    }

    setState(() {
      _isEvaluated = true;
      _isSuccess = allCorrect;
    });

    if (allCorrect) {
      HapticFeedback.heavyImpact();
      widget.onCompleted();
    } else {
      HapticFeedback.mediumImpact();
      AudioService().playError();
      _shakeKey.currentState?.shake(intensity: ShakeIntensity.medium);
      setState(() {
        _feedbackMessage = '« Une des fonctions grammaticales n\'est pas attribuée au bon mot. Observe bien les désinences ! »';
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
            // 1. En-tête
            Row(
              children: [
                const Text('🔬 ', style: TextStyle(fontSize: 18)),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LE DÉCODEUR DE CAS GRAMMATICAUX',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: Color(0xFF0D6E6E),
                          fontFamily: 'serif',
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Sélectionne chaque mot et attribue-lui sa fonction dans la phrase.',
                        style: TextStyle(fontSize: 11.5, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 2. Mots de la phrase latine
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: List.generate(widget.words.length, (idx) {
                final word = widget.words[idx];
                final isSelected = _selectedWordIndex == idx;
                final role = _assignedRoles[idx];
                final roleColor = _getColorForRole(role);
                final hasRole = role != null;

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedWordIndex = idx);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: hasRole ? roleColor.withOpacity(0.18) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? RomanColors.imperialPurple
                            : (hasRole ? roleColor : RomanColors.marbleBorder),
                        width: isSelected ? 2.2 : 1.4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? RomanColors.imperialPurple.withOpacity(0.2)
                              : const Color(0x0C000000),
                          offset: const Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          word,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'serif',
                            color: hasRole ? roleColor : RomanColors.charcoal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: hasRole ? roleColor : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            hasRole ? _getLabelForRole(role) : 'Fonction ?',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: hasRole ? Colors.white : Colors.black45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),

            if (_feedbackMessage != null) ...[
              const SizedBox(height: 12),
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

            const SizedBox(height: 16),

            // 3. Palette des 3 rôles grammaticaux
            if (!_isSuccess) ...[
              Text(
                'ATTRIBUER AU MOT SÉLECTIONNÉ (« ${widget.words[_selectedWordIndex]} ») :',
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: _availableGrammarRoles.map((role) {
                  final color = role['color'] as Color;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => _assignRoleToSelectedWord(role['id'] as String),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            role['label'] as String,
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // 4. Bouton de vérification
              RomanButton(
                text: 'VÉRIFIER LE DÉCODAGE ▶',
                backgroundColor: RomanColors.imperialPurple,
                textColor: RomanColors.goldLight,
                isLarge: true,
                onPressed: _verifyDecoding,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
