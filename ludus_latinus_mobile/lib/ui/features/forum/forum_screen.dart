import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../core/particles_overlay.dart';
import '../../../data/models/monument.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';

/// Écran de reconstruction impériale du Forum Romanum (Style Monument Valley).
class ForumScreen extends StatelessWidget {
  final GameRepository repo;

  const ForumScreen({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: repo,
      builder: (context, _) {
        final profile = repo.profile;
        final monuments = repo.monuments;
        final restoredCount = monuments.where((m) => repo.isMonumentRestored(m.id)).length;

        return Scaffold(
          appBar: AppBar(
            title: const Text('FORUM IMPERIALE'),
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
                      ' HS',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.5,
                        color: Color(0xFF7A5901),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. Fresque Panoramique du Forum Romain
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5A121E), Color(0xFF2C070F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3344101A),
                      offset: Offset(0, 6),
                      blurRadius: 14,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Forum Romanum',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            fontFamily: 'serif',
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: RomanColors.imperialGold,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            ' /  Édifices',
                            style: const TextStyle(
                              color: Color(0xFF241505),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Restaure les chefs-d’œuvre de la Ville Éternelle grâce à tes sesterces de quête. Chaque monument restauré débloque un bonus permanent pour ton épopée !',
                      style: TextStyle(
                        color: Color(0xFFEDE0D4),
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 2. Liste des 6 Édifices Historiques
              ...monuments.map((monument) {
                final isRestored = repo.isMonumentRestored(monument.id);
                final canAfford = profile.sesterces >= monument.cout;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _buildMonumentCard(
                    context: context,
                    monument: monument,
                    isRestored: isRestored,
                    canAfford: canAfford,
                    onRestore: () {
                      final success = repo.restoreMonument(monument.id, monument.cout);
                      if (success) {
                        AudioService().playTriumph();
                        AudioService().playSesterces();
                        RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: RomanColors.laurelGreen,
                            content: Row(
                              children: [
                                const Text('🏛️ ', style: TextStyle(fontSize: 18)),
                                Expanded(
                                  child: Text(
                                    '${monument.nom} restauré avec gloire ! Bonus actif : ${monument.bonusDescription}',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        AudioService().playError();
                      }
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonumentCard({
    required BuildContext context,
    required ForumMonument monument,
    required bool isRestored,
    required bool canAfford,
    required VoidCallback onRestore,
  }) {
    Color borderColor = isRestored ? RomanColors.laurelGreen : RomanColors.marbleBorder;
    Color bgColor = isRestored ? const Color(0xFFF6FBF7) : Colors.white;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isRestored ? 2.0 : 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 3),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isRestored ? const Color(0xFFE8F5EE) : RomanColors.goldLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isRestored ? RomanColors.laurelGreen : RomanColors.imperialGold,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    isRestored ? '✨' : '🏛️',
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      monument.titreFr,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: RomanColors.charcoal,
                        fontFamily: 'serif',
                      ),
                    ),
                    Text(
                      monument.nom,
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: RomanColors.imperialPurple,
                      ),
                    ),
                  ],
                ),
              ),
              if (isRestored)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: RomanColors.laurelGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'RESTAURÉ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: RomanColors.goldLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: RomanColors.imperialGold),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🪙 ', style: TextStyle(fontSize: 12)),
                      Text(
                        ' HS',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7A5901),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            monument.description,
            style: const TextStyle(
              fontSize: 12.5,
              color: Colors.black87,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isRestored ? const Color(0xFFE8F5EE) : const Color(0xFFFFFBEA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isRestored ? RomanColors.laurelGreen.withOpacity(0.5) : const Color(0xFFE6C667),
              ),
            ),
            child: Row(
              children: [
                Text(isRestored ? '👑' : '⭐', style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Bonus permanent : ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isRestored ? const Color(0xFF1B5E20) : const Color(0xFF825E00),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isRestored) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAfford ? RomanColors.imperialGold : Colors.grey.shade400,
                  foregroundColor: canAfford ? const Color(0xFF1A1409) : Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                icon: const Icon(Icons.handyman_outlined, size: 18),
                label: Text(
                  canAfford ? 'Reconstruire ce monument' : 'Fonds insuffisants',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                onPressed: canAfford ? onRestore : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}