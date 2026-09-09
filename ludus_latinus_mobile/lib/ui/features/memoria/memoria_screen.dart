import 'package:flutter/material.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../../data/models/srs_card.dart';
import '../../../data/repositories/game_repository.dart';

/// Dojo de Révision Éclair — Flashcards avec tap tactile pour retourner la carte.
class MemoriaScreen extends StatefulWidget {
  final GameRepository repo;

  const MemoriaScreen({super.key, required this.repo});

  @override
  State<MemoriaScreen> createState() => _MemoriaScreenState();
}

class _MemoriaScreenState extends State<MemoriaScreen> {
  int currentIndex = 0;
  bool isFlipped = false;
  int sessionEarnings = 0;

  void _flipCard() {
    setState(() {
      isFlipped = !isFlipped;
    });
  }

  void _rateCard(int rating) {
    int gain = (rating == 3) ? 10 : (rating == 2) ? 5 : 0;
    sessionEarnings += gain;
    widget.repo.storageService.addSesterces(gain);

    setState(() {
      if (currentIndex < widget.repo.srsCards.length - 1) {
        currentIndex++;
        isFlipped = false;
      } else {
        _showVictoryDialog();
      }
    });
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('👑 Triomphe de la Mémoire !'),
        content: Text(
          'Tu as terminé cette session de révision avec succès !\n'
          '+$sessionEarnings Sesterces remportés ! 🪙',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Retour au Forum'),
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
        appBar: AppBar(title: const Text('🃏 MEMORIA VELOX')),
        body: const Center(child: Text('Aucune carte disponible.')),
      );
    }

    final card = cards[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🃏 MEMORIA VELOX'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '🪙 +$sessionEarnings HS',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB8860B)),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Barre de progression
            LinearProgressIndicator(
              value: (currentIndex + 1) / cards.length,
              backgroundColor: Colors.black12,
              valueColor: const AlwaysStoppedAnimation<Color>(RomanColors.imperialGold),
            ),
            const SizedBox(height: 8),
            Text(
              'Carte ${currentIndex + 1} / ${cards.length}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
            ),

            const SizedBox(height: 20),

            // Flashcard tactile avec effet de retournement
            Expanded(
              child: GestureDetector(
                onTap: _flipCard,
                child: RomanCard(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: isFlipped
                        ? _buildVerso(card)
                        : _buildRecto(card),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 3 Boutons d'Évaluation Leitner SRS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A1818),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _rateCard(1),
                    child: const Text('🔴 À Revoir', textAlign: TextAlign.center),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A4E10),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _rateCard(2),
                    child: const Text('🟡 Hésitant\n(+5 HS)', textAlign: TextAlign.center),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RomanColors.laurelGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _rateCard(3),
                    child: const Text('🟢 Maîtrisé !\n(+10 HS)', textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: RomanColors.imperialGold),
          ),
          child: Text(
            card.categorie,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5A3810)),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          card.latin,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: RomanColors.imperialPurple,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          card.genre,
          style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black54),
        ),
        const SizedBox(height: 24),
        const Text(
          '👆 Touche pour retourner la carte',
          style: TextStyle(fontSize: 12, color: Colors.black38),
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: RomanColors.laurelGreen,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          card.etymologie,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: RomanColors.imperialGold),
          ),
          child: Column(
            children: [
              Text(
                '« ${card.exemple} »',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: RomanColors.imperialPurple),
              ),
              const SizedBox(height: 4),
              Text(
                '= ${card.exempleFr}',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
