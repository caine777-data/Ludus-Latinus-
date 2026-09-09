import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'themes.dart';
import 'widgets.dart';
import '../../data/services/audio_service.dart';
import '../../data/services/latin_phonetics_engine.dart';

/// Modal interactif d'analyse et de récitation phonétique latine.
/// Permet de comparer la prononciation restituée (Cicéron) et ecclésiastique (Moyen Âge),
/// d'observer l'accentuation tonique (loi de la pénultième) et d'écouter la cadence métrique.
class LatinPronunciationModal extends StatefulWidget {
  final String text;

  const LatinPronunciationModal({super.key, required this.text});

  /// Méthode d'ouverture pratique accessible depuis n'importe quel écran
  static void show(BuildContext context, String text) {
    AudioService().playCardFlip();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LatinPronunciationModal(text: text),
    );
  }

  @override
  State<LatinPronunciationModal> createState() => _LatinPronunciationModalState();
}

class _LatinPronunciationModalState extends State<LatinPronunciationModal> {
  late LatinPhoneticResult _analysis;
  bool _isRestituee = true; // true = Restituée classique, false = Ecclésiastique
  int _activeWordIndex = 0;
  int _highlightedSyllableIndex = -1;
  bool _isPlayingRhythm = false;
  Timer? _rhythmTimer;

  @override
  void initState() {
    super.initState();
    _analysis = LatinPhoneticsEngine.analyze(widget.text);
  }

  @override
  void dispose() {
    _rhythmTimer?.cancel();
    super.dispose();
  }

  void _playSyllabicRhythm() {
    if (_isPlayingRhythm || _analysis.words.isEmpty) return;

    final currentWord = _analysis.words[_activeWordIndex.clamp(0, _analysis.words.length - 1)];
    final syllCount = currentWord.syllables.length;
    if (syllCount == 0) return;

    setState(() {
      _isPlayingRhythm = true;
      _highlightedSyllableIndex = 0;
    });

    _playSyllableSound(_highlightedSyllableIndex == currentWord.tonicSyllableIndex);

    var currentStep = 0;
    _rhythmTimer?.cancel();
    _rhythmTimer = Timer.periodic(const Duration(milliseconds: 450), (timer) {
      currentStep++;
      if (currentStep >= syllCount) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _isPlayingRhythm = false;
            _highlightedSyllableIndex = -1;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _highlightedSyllableIndex = currentStep;
          });
          _playSyllableSound(currentStep == currentWord.tonicSyllableIndex);
        }
      }
    });
  }

  void _playSyllableSound(bool isTonic) {
    if (isTonic) {
      HapticFeedback.heavyImpact();
      SystemSound.play(SystemSoundType.click);
    } else {
      HapticFeedback.lightImpact();
      SystemSound.play(SystemSoundType.click);
    }
  }

  String _getPhoneticHelpText(LatinWordPhonetics word, bool isRest) {
    final lower = word.cleanWord.toLowerCase();
    if (isRest) {
      if (lower == 'caesar') return 'Prononcez « KA-ÈSS-AR » avec le C claquant [K] et la diphtongue liée.';
      if (lower == 'cicero') return 'Prononcez « KI-KÉ-RO » comme dans « kiwi », l\'accent sur le premier KI !';
      if (lower == 'roma') return 'Prononcez « RŌ-MA » avec le R roulé et le O long.';
      if (lower == 'senatus') return 'Prononcez « SÉ-NĀ-TOUSS » avec l\'accent frappant le NĀ.';
      if (lower.contains('v')) return 'Rappelez-vous : le V classique sonne toujours [W] ou [OU] !';
      if (lower.contains('c')) return 'En latin classique, le C sonne TOUJOURS [K], même devant E et I.';
      return 'Chaque lettre latine se prononce distinctement ; l\'accent marque la syllabe tonique.';
    } else {
      if (lower == 'caesar') return 'Prononcez « TCHÉ-ZAR » à la manière italienne et médiévale.';
      if (lower == 'cicero') return 'Prononcez « TCHI-TCHÉ-RO » comme dans les chants grégoriens.';
      if (lower.contains('c')) return 'Devant E et I, le C devient doux [TCH] en prononciation d\'Église.';
      if (lower.contains('ti')) return 'Devant voyelle, TI se prononce [TSI] (ex: gratia = « gratsia »).';
      return 'Prononciation traditionnelle liturgique héritée du bas Moyen Âge.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasWords = _analysis.words.isNotEmpty;
    final currentWord = hasWords
        ? _analysis.words[_activeWordIndex.clamp(0, _analysis.words.length - 1)]
        : null;

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: RomanColors.travertinWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Barre de tirage / poignée
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: RomanColors.marbleBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // En-tête avec titre antique
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: RomanColors.goldLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                  ),
                  child: const Icon(Icons.record_voice_over_outlined, color: RomanColors.imperialPurple, size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PRONUNTIATIO LATINA',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: RomanColors.imperialPurple,
                        ),
                      ),
                      Text(
                        'Guide phonétique & accent tonique antique',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: RomanColors.charcoal),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Si plusieurs mots, afficher un sélecteur horizontal
            if (_analysis.words.length > 1) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_analysis.words.length, (idx) {
                    final w = _analysis.words[idx];
                    final isSel = idx == _activeWordIndex;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(w.cleanWord),
                        selected: isSel,
                        selectedColor: RomanColors.imperialPurple,
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : RomanColors.charcoal,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        backgroundColor: Colors.white,
                        onSelected: (selected) {
                          if (selected) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _activeWordIndex = idx;
                              _highlightedSyllableIndex = -1;
                            });
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Carte principale du mot sélectionné
            if (currentWord != null) ...[
              RomanCard(
                child: Column(
                  children: [
                    // Texte du mot
                    Text(
                      currentWord.latin,
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: RomanColors.imperialPurple,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Découpage syllabique et indicateur de la tonique
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 6,
                      runSpacing: 6,
                      children: List.generate(currentWord.syllables.length, (sIdx) {
                        final isTonic = (sIdx == currentWord.tonicSyllableIndex);
                        final isHighlighted = (sIdx == _highlightedSyllableIndex);

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isHighlighted
                                ? RomanColors.imperialGold
                                : (isTonic ? RomanColors.goldLight : Colors.white),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isTonic ? RomanColors.imperialGold : RomanColors.marbleBorder,
                              width: isTonic ? 1.5 : 1.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                currentWord.syllables[sIdx],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isTonic ? FontWeight.bold : FontWeight.normal,
                                  color: isHighlighted ? Colors.white : (isTonic ? const Color(0xFF7A5901) : RomanColors.charcoal),
                                ),
                              ),
                              Text(
                                isTonic ? '▲ tonique' : '—',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: isTonic ? const Color(0xFF7A5901) : Colors.black38,
                                  fontWeight: isTonic ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 12),

                    // Bouton de récitation métrée
                    SizedBox(
                      height: 38,
                      child: ElevatedButton.icon(
                        onPressed: _isPlayingRhythm ? null : _playSyllabicRhythm,
                        icon: Icon(
                          _isPlayingRhythm ? Icons.hourglass_top : Icons.play_arrow_rounded,
                          size: 18,
                        ),
                        label: Text(
                          _isPlayingRhythm ? 'Récitation en cours...' : 'Réciter au rythme antique ▶',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: RomanColors.imperialPurple,
                          foregroundColor: Colors.white,
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Commutateur Restituée vs Ecclésiastique
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: RomanColors.marbleBorder),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _isRestituee = true);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _isRestituee ? RomanColors.imperialPurple : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '🏛️ Restituée (Cicéron)',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: _isRestituee ? FontWeight.bold : FontWeight.normal,
                                color: _isRestituee ? Colors.white : RomanColors.charcoal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _isRestituee = false);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: !_isRestituee ? RomanColors.imperialPurple : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '⛪ Ecclésiastique (Moyen Âge)',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: !_isRestituee ? FontWeight.bold : FontWeight.normal,
                                color: !_isRestituee ? Colors.white : RomanColors.charcoal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Panneau de transcription et astuce de prononciation
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: RomanColors.marbleBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Transcription API : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1EDE6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _isRestituee ? currentWord.ipaRestituee : currentWord.ipaEcclesiastique,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: RomanColors.imperialPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🗣️ ', style: TextStyle(fontSize: 14)),
                        Expanded(
                          child: Text(
                            _getPhoneticHelpText(currentWord, _isRestituee),
                            style: const TextStyle(fontSize: 12.5, color: RomanColors.charcoal, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                    if (currentWord.phoneticNotes.isNotEmpty) ...[
                      const Divider(height: 16, color: RomanColors.marbleBorder),
                      ...currentWord.phoneticNotes.map((note) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: RomanColors.imperialGold, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(note, style: const TextStyle(fontSize: 11.5, color: Colors.black87)),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ],
                ),
              ),
            ],

            const SizedBox(height: 14),

            // Conseil général / Loi de la pénultième
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F5EF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: RomanColors.goldLight),
              ),
              child: const Row(
                children: [
                  Text('💡 ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      'Loi de la Pénultième : En latin, l\'accent tonique ne frappe JAMAIS la dernière syllabe. Sur un mot de 2 syllabes, il est toujours sur la première !',
                      style: TextStyle(fontSize: 11, color: Color(0xFF634D15), fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
