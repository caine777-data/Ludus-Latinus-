import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../core/particles_overlay.dart';
import '../../core/latin_pronunciation_modal.dart';
import '../../../data/models/srs_card.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';

enum NiveauMemoria {
  tous('Tous', 'Toutes les cartes'),
  cinquieme('5ème', 'Maison, Famille & Nature'),
  quatrieme('4ème', 'Mythes, Dieux & Légions'),
  troisieme('3ème', 'Citoyenneté & Verbes');

  final String label;
  final String description;
  const NiveauMemoria(this.label, this.description);

  bool matches(String categorie) {
    switch (this) {
      case NiveauMemoria.tous:
        return true;
      case NiveauMemoria.cinquieme:
        return categorie.contains('Famille') || categorie.contains('Nature') || categorie.contains('Animaux');
      case NiveauMemoria.quatrieme:
        return categorie.contains('Dieux') || categorie.contains('Mythes') || categorie.contains('Armée') || categorie.contains('Légions');
      case NiveauMemoria.troisieme:
        return categorie.contains('Citoyenneté') || categorie.contains('Valeurs') || categorie.contains('Verbes');
    }
  }
}

/// Dojo de Révision Éclair — Flashcards 3D Matrix4 avec esthétique de marbre sculpté.
class MemoriaScreen extends StatefulWidget {
  final GameRepository repo;

  const MemoriaScreen({super.key, required this.repo});

  @override
  State<MemoriaScreen> createState() => _MemoriaScreenState();
}

class _MemoriaScreenState extends State<MemoriaScreen> with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  int currentIndex = 0;
  int sessionEarnings = 0;
  bool isFront = true;
  NiveauMemoria selectedNiveau = NiveauMemoria.tous;
  int _streak = 0;
  int _maxStreak = 0;

  List<SrsCard> get _filteredCards {
    final all = widget.repo.srsCards;
    if (selectedNiveau == NiveauMemoria.tous) return all;
    final filtered = all.where((c) => selectedNiveau.matches(c.categorie)).toList();
    return filtered.isNotEmpty ? filtered : all;
  }

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutBack),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    AudioService().playCardFlip();
    if (isFront) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
    setState(() {
      isFront = !isFront;
    });
  }

  void _rateCard(int rating) {
    int baseGain = 0;
    if (rating == 3) {
      _streak++;
      if (_streak > _maxStreak) _maxStreak = _streak;

      // Multiplicateurs Furor Latinus
      if (_streak >= 5) {
        baseGain = 20; // x2.0
        HapticFeedback.heavyImpact();
        RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
      } else if (_streak >= 3) {
        baseGain = 15; // x1.5
        HapticFeedback.mediumImpact();
      } else {
        baseGain = 10;
        HapticFeedback.selectionClick();
      }
      AudioService().playSesterces();
    } else if (rating == 2) {
      _streak = 0;
      baseGain = 5;
      AudioService().playSesterces();
    } else {
      _streak = 0;
      baseGain = 0;
      AudioService().playError();
    }

    sessionEarnings += baseGain;
    widget.repo.addSesterces(baseGain);

    final cards = _filteredCards;
    if (currentIndex < cards.length - 1) {
      if (!isFront) {
        _flipController.reverse();
        isFront = true;
      }
      setState(() {
        currentIndex++;
      });
    } else {
      _showVictoryDialog();
    }
  }

  void _showVictoryDialog() {
    AudioService().playTriumph();
    RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Text('👑 ', style: TextStyle(fontSize: 24)),
            Expanded(
              child: Text(
                'TRIOMPHE DE LA MÉMOIRE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'serif',
                  letterSpacing: 0.5,
                  color: RomanColors.imperialPurple,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/lupulus/lupulus_triomphe_180.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Text('🏆', style: TextStyle(fontSize: 40)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Session de révision achevée avec brio !\nTu as remporté +$sessionEarnings Sesterces (HS) !${_maxStreak >= 3 ? '\n🔥 Furor Latinus Max : $_maxStreak d\'affilée !' : ''}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
          ],
        ),
        actions: [
          RomanButton(
            text: 'Retour au Forum',
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cards = _filteredCards;
    if (cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('MEMORIA VELOX')),
        body: const Center(child: Text('Aucune carte de vocabulaire disponible.')),
      );
    }

    final safeIndex = currentIndex.clamp(0, cards.length - 1);
    final card = cards[safeIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('MEMORIA VELOX'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: RomanColors.goldLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: RomanColors.imperialGold),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🪙', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 4),
                Text(
                  '+$sessionEarnings HS',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF7A5901)),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: RomanColors.imperialGold),
            tooltip: 'Harmonia Antiqua (Audio)',
            onPressed: () => RomanAudioModal.show(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // 1. Filtre par niveau scolaire
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: NiveauMemoria.values.map((lvl) {
                  final isSelected = selectedNiveau == lvl;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(lvl.label),
                      selected: isSelected,
                      selectedColor: RomanColors.imperialPurple,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : RomanColors.charcoal,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.5,
                      ),
                      onSelected: (val) {
                        if (val && selectedNiveau != lvl) {
                          HapticFeedback.selectionClick();
                          AudioService().playCardFlip();
                          setState(() {
                            selectedNiveau = lvl;
                            currentIndex = 0;
                            if (!isFront) {
                              _flipController.reverse();
                              isFront = true;
                            }
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),
            const RomanMeanderDivider(height: 10, color: RomanColors.imperialGold),
            const SizedBox(height: 8),

            // 2. Bannière Furor Latinus Streak (si streak >= 3)
            if (_streak >= 3) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _streak >= 5
                        ? [const Color(0xFFB71C1C), const Color(0xFFE65100)]
                        : [const Color(0xFF7A1B28), const Color(0xFFD4AF37)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33B71C1C),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      _streak >= 5
                          ? 'FUROR LATINUS MAXIMUS (x2.0 HS) !'
                          : 'FUROR LATINUS (x1.5 HS) !',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '($_streak d\'affilée)',
                      style: const TextStyle(
                        color: Color(0xFFFFE082),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // 3. Barre de progression
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Carte ${safeIndex + 1} / ${cards.length}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: RomanColors.imperialPurple),
                ),
                Text(
                  card.categorie.toUpperCase(),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (safeIndex + 1) / cards.length,
                minHeight: 6,
                backgroundColor: const Color(0xFFE5DDD0),
                valueColor: const AlwaysStoppedAnimation<Color>(RomanColors.imperialGold),
              ),
            ),

            const SizedBox(height: 14),

            // 4. Flashcard 3D Matrix4
            Expanded(
              child: GestureDetector(
                onTap: _flipCard,
                child: AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, _) {
                    final angle = _flipAnimation.value * math.pi;
                    final isFrontVisible = _flipAnimation.value < 0.5;

                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0012)
                        ..rotateY(angle),
                      alignment: Alignment.center,
                      child: isFrontVisible
                          ? _buildCardSide(
                              isFront: true,
                              child: _buildRecto(card),
                            )
                          : Transform(
                              transform: Matrix4.identity()..rotateY(math.pi),
                              alignment: Alignment.center,
                              child: _buildCardSide(
                                isFront: false,
                                child: _buildVerso(card),
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 14),

            // 5. Boutons Leitner SRS avec multiplicateurs
            Row(
              children: [
                Expanded(
                  child: _buildLeitnerButton(
                    label: '🔴 À Revoir',
                    sub: '+0 HS',
                    color: const Color(0xFF8B2500),
                    onTap: () => _rateCard(1),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildLeitnerButton(
                    label: '🟡 Hésitant',
                    sub: '+5 HS',
                    color: const Color(0xFFB8860B),
                    onTap: () => _rateCard(2),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildLeitnerButton(
                    label: '🟢 Maîtrisé !',
                    sub: _streak >= 5 ? '+20 HS (x2)' : _streak >= 3 ? '+15 HS (x1.5)' : '+10 HS',
                    color: RomanColors.laurelGreen,
                    onTap: () => _rateCard(3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSide({required bool isFront, required Widget child}) {
    return RomanParchmentCard(
      padding: const EdgeInsets.all(24),
      borderColor: isFront ? RomanColors.imperialGold : RomanColors.laurelGreen,
      child: Center(child: child),
    );
  }

  Widget _buildRecto(SrsCard card) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: RomanColors.goldLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: RomanColors.imperialGold),
          ),
          child: Text(
            card.categorie,
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF7A5901)),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          card.latin,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: RomanColors.imperialPurple,
            fontFamily: 'serif',
          ),
        ),
        if (card.genre.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            card.genre,
            style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.black54),
          ),
        ],
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            AudioService().playWheelClick();
            LatinPronunciationModal.show(context, card.latin);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: RomanColors.goldLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: RomanColors.imperialGold, width: 0.8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.volume_up_rounded, size: 15, color: RomanColors.imperialPurple),
                SizedBox(width: 4),
                Text(
                  'Prononciation & API',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: RomanColors.imperialPurple,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: RomanColors.palatinCream,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('👆 ', style: TextStyle(fontSize: 12)),
              Text(
                'Touche pour retourner la carte',
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerso(SrsCard card) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          card.francais,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: RomanColors.laurelGreen,
          ),
        ),
        if (card.etymologie.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5EE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              card.etymologie,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF1E5E3A)),
            ),
          ),
        ],
        if (card.exemple.isNotEmpty) ...[
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5CF8E)),
            ),
            child: Column(
              children: [
                Text(
                  '« ${card.exemple} »',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: RomanColors.imperialPurple,
                  ),
                ),
                InkWell(
                  onTap: () {
                    AudioService().playWheelClick();
                    LatinPronunciationModal.show(context, card.exemple);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.volume_up_rounded, size: 14, color: RomanColors.imperialPurple),
                        SizedBox(width: 4),
                        Text(
                          'Écouter la phrase',
                          style: TextStyle(fontSize: 10.5, color: RomanColors.imperialPurple, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                if (card.exempleFr.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '= ${card.exempleFr}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11.5, color: Colors.black54),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLeitnerButton({
    required String label,
    required String sub,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      onPressed: onTap,
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(fontSize: 10, color: Colors.white70)),
        ],
      ),
    );
  }
}