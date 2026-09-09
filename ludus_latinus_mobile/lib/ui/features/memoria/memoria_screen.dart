import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../../data/models/srs_card.dart';
import '../../../data/repositories/game_repository.dart';

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
    HapticFeedback.lightImpact();
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
    HapticFeedback.mediumImpact();
    int gain = (rating == 3) ? 10 : (rating == 2) ? 5 : 0;
    sessionEarnings += gain;
    widget.repo.storageService.addSesterces(gain);

    if (currentIndex < widget.repo.srsCards.length - 1) {
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
              'Session de révision achevée avec brio !\nTu as remporté + Sesterces (HS) !',
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
    final cards = widget.repo.srsCards;
    if (cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('MEMORIA VELOX')),
        body: const Center(child: Text('Aucune carte de vocabulaire disponible.')),
      );
    }

    final card = cards[currentIndex];

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
                  '+ HS',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF7A5901)),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Barre de progression
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Carte  / ',
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
                value: (currentIndex + 1) / cards.length,
                minHeight: 6,
                backgroundColor: const Color(0xFFE5DDD0),
                valueColor: const AlwaysStoppedAnimation<Color>(RomanColors.imperialGold),
              ),
            ),

            const SizedBox(height: 18),

            // 🃏 Flashcard avec vraie rotation 3D Matrix4
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
                        ..setEntry(3, 2, 0.0012) // Perspective 3D
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

            const SizedBox(height: 18),

            // 3 Boutons d'Évaluation Leitner SRS
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
                    sub: '+10 HS',
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isFront ? Colors.white : const Color(0xFFFBF9F4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isFront ? RomanColors.imperialGold : RomanColors.laurelGreen,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x223E1A0F),
            offset: Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
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
        const SizedBox(height: 32),
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
                  '«  »',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: RomanColors.imperialPurple,
                  ),
                ),
                if (card.exempleFr.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '= ',
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