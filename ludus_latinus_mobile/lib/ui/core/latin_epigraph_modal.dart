import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'themes.dart';
import 'particles_overlay.dart';
import 'lottie_effects.dart';
import '../../data/models/latin_epigraph.dart';
import '../../data/repositories/game_repository.dart';
import '../../data/services/audio_service.dart';

/// Modal d'Épigraphie Romaine : Déchiffrage des inscriptions lapidaires gravées dans le marbre.
class LatinEpigraphModal extends StatefulWidget {
  final LatinEpigraph epigraph;
  final GameRepository repo;

  const LatinEpigraphModal({
    super.key,
    required this.epigraph,
    required this.repo,
  });

  static void show(BuildContext context, {required LatinEpigraph epigraph, required GameRepository repo}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LatinEpigraphModal(epigraph: epigraph, repo: repo),
    );
  }

  @override
  State<LatinEpigraphModal> createState() => _LatinEpigraphModalState();
}

class _LatinEpigraphModalState extends State<LatinEpigraphModal> {
  int? _selectedTokenIndex;

  @override
  Widget build(BuildContext context) {
    final isDecoded = widget.repo.isEpigraphDecoded(widget.epigraph.monumentId);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: RomanColors.palatinCream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 20,
            offset: Offset(0, -4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barre de tirage
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            width: 44,
            height: 4.5,
            decoration: BoxDecoration(
              color: RomanColors.marbleBorder,
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // En-tête Impérial
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: RomanColors.goldLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: RomanColors.imperialGold),
                  ),
                  child: const Text('🏛️', style: TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'INSCRIPTIO LAPIDARIA',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: RomanColors.imperialGold,
                        ),
                      ),
                      Text(
                        widget.epigraph.titre,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                          color: RomanColors.imperialPurple,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isDecoded)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: RomanColors.laurelGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '✓ DÉCHIFFRÉ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
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
                        const Text('🪙 ', style: TextStyle(fontSize: 11)),
                        Text(
                          '+${widget.epigraph.recompense} HS',
                          style: const TextStyle(
                            color: Color(0xFF7A5901),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const Divider(height: 1, color: RomanColors.marbleBorder),

          // Corps défilable
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                // 1. La Pierre de Marbre Gravée
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEADCCB), Color(0xFFD8C7B0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFB59D82), width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 10,
                        offset: Offset(2, 4),
                      ),
                      BoxShadow(
                        color: Colors.white70,
                        blurRadius: 4,
                        offset: Offset(-1, -1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '« ÉPIGRAPHE ORIGINALE GRAVÉE »',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Color(0xFF634A31),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SelectableText(
                        widget.epigraph.texteAntique,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.8,
                          height: 1.6,
                          color: Color(0xFF2B1C10),
                          shadows: [
                            Shadow(
                              color: Colors.white,
                              offset: Offset(1, 1),
                              blurRadius: 1,
                            ),
                            Shadow(
                              color: Color(0x66000000),
                              offset: Offset(-1, -1),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Touchez un mot gravé ci-dessous pour révéler son secret lapidaire',
                        style: TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF5A442E),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 2. Jetons de décryptage lapidaire
                const Text(
                  'Fragments & Abréviations à déchiffrer :',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: RomanColors.charcoal,
                  ),
                ),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(widget.epigraph.tokens.length, (index) {
                    final token = widget.epigraph.tokens[index];
                    final isSelected = _selectedTokenIndex == index;

                    return ActionChip(
                      label: Text(token.texteGraver),
                      backgroundColor: isSelected ? RomanColors.imperialPurple : Colors.white,
                      labelStyle: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : RomanColors.imperialPurple,
                        letterSpacing: 0.8,
                      ),
                      side: BorderSide(
                        color: isSelected ? RomanColors.imperialPurple : RomanColors.marbleBorder,
                        width: 1.2,
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        AudioService().playCardFlip();
                        setState(() {
                          _selectedTokenIndex = index;
                        });
                      },
                    );
                  }),
                ),

                const SizedBox(height: 12),

                // 3. Panneau de détail du token sélectionné
                if (_selectedTokenIndex != null) ...[
                  Builder(
                    builder: (context) {
                      final token = widget.epigraph.tokens[_selectedTokenIndex!];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('🔍 ', style: TextStyle(fontSize: 16)),
                                Text(
                                  token.formeDeveloppee,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: RomanColors.imperialPurple,
                                    fontFamily: 'serif',
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: RomanColors.goldLight,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    token.texteGraver,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF7A5901),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Traduction : ${token.traduction}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: RomanColors.charcoal,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Grammaire : ${token.roleGrammatical}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                ],

                // 4. Traduction intégrale
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: RomanColors.marbleBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text('📜 ', style: TextStyle(fontSize: 14)),
                          Text(
                            'Traduction Française Complète',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: RomanColors.charcoal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.epigraph.traductionComplete,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          color: RomanColors.imperialPurple,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // 5. Contexte Historique & Archéologique
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F3EE),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: RomanColors.marbleBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text('🏺 ', style: TextStyle(fontSize: 14)),
                          Text(
                            'Notice Archéologique & Historique',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF533F2B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.epigraph.contexteHistorique,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Barre d'Action Inférieure
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDecoded ? RomanColors.laurelGreen : RomanColors.imperialGold,
                  foregroundColor: isDecoded ? Colors.white : const Color(0xFF1F150A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                icon: Icon(isDecoded ? Icons.check_circle_outline : Icons.brush_outlined, size: 20),
                label: Text(
                  isDecoded
                      ? 'Inscription Déjà Archivée au Tabularium'
                      : 'Estamper la Pierre (+${widget.epigraph.recompense} Sesterces)',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (!isDecoded) {
                    widget.repo.decodeEpigraph(widget.epigraph.monumentId, widget.epigraph.recompense);
                    AudioService().playSesterces();
                    AudioService().playTriumph();
                    RomanLottieEffects.showMonumentBlessing(context);
                    RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: RomanColors.laurelGreen,
                        content: Text(
                          '🏛️ Épigraphe déchiffrée avec succès ! +${widget.epigraph.recompense} HS versés à ton trésor.',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
