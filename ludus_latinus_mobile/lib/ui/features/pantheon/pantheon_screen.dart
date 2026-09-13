import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import '../../core/themes.dart';
import '../../core/particles_overlay.dart';
import '../../core/widgets.dart';

class CarteCollector {
  final String id;
  final String titre;
  final String sousTitreLatin;
  final String imagePath;
  final String rarete; // Commune, Rare, Mythique, Impériale
  final String description;
  final String devise;

  const CarteCollector({
    required this.id,
    required this.titre,
    required this.sousTitreLatin,
    required this.imagePath,
    required this.rarete,
    required this.description,
    required this.devise,
  });
}

const List<CarteCollector> kCartesCollector = [
  CarteCollector(
    id: 'louve',
    titre: 'La Louve Capitoline',
    sousTitreLatin: 'Lupa Capitolina',
    imagePath: 'assets/images/musee_louve.png',
    rarete: 'Mythique',
    description: 'La bête sacrée du dieu Mars qui recueillit et nourrit les jumeaux Romulus et Rémus sur les rives du Tibre.',
    devise: '« Roma aeterna in monte Palatino oritur. »',
  ),
  CarteCollector(
    id: 'gladiateur',
    titre: 'Le Gladiateur du Colisée',
    sousTitreLatin: 'Gladiator Arenae',
    imagePath: 'assets/images/musee_gladiateur.png',
    rarete: 'Rare',
    description: 'Armé du scutum et du glaive, il combat dans le sable de l\'amphithéâtre Flavien pour la gloire et sa liberté.',
    devise: '« Morituri te salutant ! »',
  ),
  CarteCollector(
    id: 'circus',
    titre: 'Le Quadrige du Circus',
    sousTitreLatin: 'Quadriga Circensis',
    imagePath: 'assets/images/musee_circus.png',
    rarete: 'Rare',
    description: 'Char léger à quatre chevaux filant à vive allure autour de la spina sous les clameurs de deux cent mille spectateurs.',
    devise: '« Ferventissimus cursus ad victoriam ! »',
  ),
  CarteCollector(
    id: 'pegase',
    titre: 'Pégase le Cheval Ailé',
    sousTitreLatin: 'Pegasus Alatus',
    imagePath: 'assets/images/musee_pegase.png',
    rarete: 'Mythique',
    description: 'Créature céleste jaillie du cou de Méduse, capable d\'ouvrir des sources sacrées d\'un simple coup de sabot.',
    devise: '« Ad astra per alas divinas. »',
  ),
  CarteCollector(
    id: 'legion',
    titre: 'L\'Aigle Légionnaire',
    sousTitreLatin: 'Aquila Legionis',
    imagePath: 'assets/images/musee_legion.png',
    rarete: 'Impériale',
    description: 'L\'étendard sacré de bronze doré porté par l\'aquilifer, symbole suprême de la discipline et de la vaillance de Rome.',
    devise: '« Senatus Populusque Romanus. »',
  ),
  CarteCollector(
    id: 'thermes',
    titre: 'Les Thermes Impériaux',
    sousTitreLatin: 'Thermae Romanae',
    imagePath: 'assets/images/musee_thermes.png',
    rarete: 'Commune',
    description: 'Le cœur de la vie civique romaine réunissant bains chauds (caldarium), gymnases et bibliothèques.',
    devise: '« Mens sana in corpore sano. »',
  ),
  CarteCollector(
    id: 'lion',
    titre: 'Le Lion de Némée',
    sousTitreLatin: 'Leo Nemaeus',
    imagePath: 'assets/images/musee_lion.png',
    rarete: 'Mythique',
    description: 'Monstre à la peau impénétrable vaincu par Hercule lors du premier de ses douze travaux héroïques.',
    devise: '« Fortitudo Herculis superat monstra. »',
  ),
  CarteCollector(
    id: 'cave_canem',
    titre: 'La Mosaïque de Pompéi',
    sousTitreLatin: 'Cave Canem',
    imagePath: 'assets/images/musee_cave_canem.png',
    rarete: 'Commune',
    description: 'Chef-d\'œuvre en tesselles de marbre ornant le vestibule de la Maison du Poète Tragique à Pompéi.',
    devise: '« Cave canem et serva domum ! »',
  ),
  CarteCollector(
    id: 'triomphe',
    titre: 'La Couronne Triomphale',
    sousTitreLatin: 'Corona Triumphalis',
    imagePath: 'assets/images/trophee_triomphe_medaillon_130.png',
    rarete: 'Impériale',
    description: 'Couronne de feuilles de laurier doré ceinte par le général victorieux gravissant la colline du Capitole.',
    devise: '« Victoria immortalis Romae ! »',
  ),
];

class PantheonScreen extends StatefulWidget {
  final GameRepository repo;

  const PantheonScreen({super.key, required this.repo});

  @override
  State<PantheonScreen> createState() => _PantheonScreenState();
}

class _PantheonScreenState extends State<PantheonScreen> {
  final Set<String> _cartesRetournees = {};

  Color _getRareteColor(String rarete) {
    switch (rarete) {
      case 'Impériale':
        return const Color(0xFF9C27B0);
      case 'Mythique':
        return const Color(0xFFD4AF37);
      case 'Rare':
        return const Color(0xFF1976D2);
      default:
        return const Color(0xFF388E3C);
    }
  }

  void _flipCard(String id) {
    HapticFeedback.lightImpact();
    AudioService().playCardFlip();
    setState(() {
      if (_cartesRetournees.contains(id)) {
        _cartesRetournees.remove(id);
      } else {
        _cartesRetournees.add(id);
        AudioService().playTriumph();
        RomanParticlesOverlay.show(context, type: ParticleType.marbleSparks);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.repo,
      builder: (context, _) {
        final sesterces = widget.repo.profile.sesterces;
        final totalCartes = kCartesCollector.length;

        return Scaffold(
          appBar: AppBar(
            title: const Text('🏛️ Le Panthéon des Trophées'),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
                      '${widget.repo.profile.sesterces} HS',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF7A5901)),
                    ),
                  ],
                ),
              ),
            ],
          ),
      body: RomanOculusBackdrop(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const RomanMeanderDivider(height: 12, color: RomanColors.imperialGold),
                const SizedBox(height: 8),
                // 1. Bannière Panthéon avec Torches Sacrées Animées
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF421019), Color(0xFF1F060B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        offset: Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Torche animée gauche
                      Image.asset(
                        'assets/images/animated/flambeau_flamme.webp',
                        width: 22,
                        height: 48,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFF0D0),
                          border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/trophee_triomphe_medaillon_130.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Text('🏆', style: TextStyle(fontSize: 26)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ALBUM COLLECTOR ANTIQUE',
                              style: TextStyle(
                                color: RomanColors.imperialGold,
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Collectionne les $totalCartes reliques mythologiques et touche une carte pour la retourner en 3D !',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Torche animée droite
                      Image.asset(
                        'assets/images/animated/flambeau_flamme.webp',
                        width: 22,
                        height: 48,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // 2. Statistiques Rapides
                Row(
                  children: [
                    Expanded(
                      child: _buildStatChip(
                        icon: '🪙',
                        label: 'Sesterces',
                        value: '$sesterces HS',
                        color: RomanColors.goldLight,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatChip(
                        icon: '🃏',
                        label: 'Reliques',
                        value: '$totalCartes / $totalCartes',
                        color: const Color(0xFFF0F6FF),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatChip(
                        icon: '👑',
                        label: 'Rang',
                        value: 'Patricien',
                        color: const Color(0xFFFDF0ED),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                const Text(
                  'Galerie des Cartes de Mythologie',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.4,
                    color: RomanColors.imperialPurple,
                  ),
                ),
                const SizedBox(height: 10),

                // 3. Grille des Cartes Collector Flip 3D
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: kCartesCollector.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) {
                    final carte = kCartesCollector[index];
                    final isFlipped = _cartesRetournees.contains(carte.id);
                    return _buildFlipCardItem(carte, isFlipped, index);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  },
);
}

  Widget _buildStatChip({
    required String icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RomanColors.marbleBorder),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: RomanColors.charcoal),
          ),
        ],
      ),
    );
  }

  static const List<String> _kChiffresRomains = ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X'];

  Widget _buildFlipCardItem(CarteCollector carte, bool isFlipped, int index) {
    final rareteColor = _getRareteColor(carte.rarete);
    final numeroRomain = index < _kChiffresRomains.length ? _kChiffresRomains[index] : '${index + 1}';

    return GestureDetector(
      onTap: () => _flipCard(carte.id),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (widget, animation) {
          final rotate = Tween(begin: math.pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotate,
            builder: (context, child) {
              final angle = (animation.value < 0.5) ? math.pi * (1 - animation.value) : rotate.value;
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
                alignment: Alignment.center,
                child: widget,
              );
            },
          );
        },
        child: isFlipped
            // Verso : Récit, Sceau SPQR & Citation Sacrée
            ? Container(
                key: const ValueKey('verso'),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFFDF8), Color(0xFFF7EEDB), Color(0xFFEDE0C8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: rareteColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: rareteColor.withOpacity(0.35),
                      offset: const Offset(0, 5),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Filigrane antique en arrière-plan
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.08,
                          child: Image.asset(
                            'assets/images/dos_carte_collector.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                          ),
                        ),
                      ),
                      // Cadre intérieur doré
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: RomanColors.imperialGold.withOpacity(0.4),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Contenu
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RomanWaxSeal(
                                      size: 30,
                                      label: 'SPQR',
                                      sealColor: rareteColor == const Color(0xFF9C27B0)
                                          ? const Color(0xFF6B1826)
                                          : const Color(0xFF8E1724),
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        carte.sousTitreLatin,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'serif',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: rareteColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const RomanMeanderDivider(
                                  height: 8,
                                  strokeWidth: 0.8,
                                  color: RomanColors.imperialGold,
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                ),
                                Text(
                                  carte.description,
                                  textAlign: TextAlign.center,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: RomanColors.charcoal,
                                    height: 1.25,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0x1A421019),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: RomanColors.imperialGold.withOpacity(0.5)),
                              ),
                              child: Text(
                                carte.devise,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5A121E),
                                ),
                              ),
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.touch_app_outlined, size: 11, color: Colors.black45),
                                SizedBox(width: 3),
                                Text(
                                  'Toucher pour retourner',
                                  style: TextStyle(fontSize: 8.5, color: Colors.black45),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            // Recto : Illustration Antique avec Piédestal en Marbre
            : Container(
                key: const ValueKey('recto'),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: rareteColor, width: 1.8),
                  boxShadow: [
                    BoxShadow(
                      color: rareteColor.withOpacity(0.28),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Badge de Rareté Antique
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              rareteColor.withOpacity(0.18),
                              rareteColor.withOpacity(0.06),
                            ],
                          ),
                          border: Border(
                            bottom: BorderSide(color: rareteColor.withOpacity(0.3), width: 1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  carte.rarete == 'Impériale'
                                      ? Icons.workspace_premium
                                      : carte.rarete == 'Mythique'
                                          ? Icons.auto_awesome
                                          : carte.rarete == 'Rare'
                                              ? Icons.diamond_outlined
                                              : Icons.eco_outlined,
                                  size: 12,
                                  color: rareteColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  carte.rarete.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: rareteColor,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: RomanColors.goldLight,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: RomanColors.imperialGold, width: 0.8),
                              ),
                              child: Text(
                                'N° $numeroRomain',
                                style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7A5901),
                                  fontFamily: 'serif',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Illustration Antique
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              carte.imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Center(
                                child: Text('🏛️', style: TextStyle(fontSize: 38, color: rareteColor)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Socle Piédestal en Marbre de Carrare sculpté
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFFDF8), Color(0xFFF2ECE1), Color(0xFFE4D9C8)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          border: Border(
                            top: BorderSide(color: RomanColors.imperialGold.withOpacity(0.6), width: 1.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              carte.titre,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: RomanColors.charcoal,
                              ),
                            ),
                            Text(
                              carte.sousTitreLatin,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontSize: 9.5,
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF7A5901),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

}
