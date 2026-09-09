import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import '../../core/themes.dart';
import '../../core/particles_overlay.dart';

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Bannière Panthéon
              Container(
                padding: const EdgeInsets.all(16),
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
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFF0D0),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/trophee_triomphe_medaillon_130.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Text('🏆', style: TextStyle(fontSize: 28)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ALBUM COLLECTOR ANTIQUE',
                            style: TextStyle(
                              color: RomanColors.imperialGold,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Collectionne les $totalCartes reliques mythologiques et touche une carte pour la retourner en 3D !',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
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
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, index) {
                  final carte = kCartesCollector[index];
                  final isFlipped = _cartesRetournees.contains(carte.id);
                  return _buildFlipCardItem(carte, isFlipped);
                },
              ),
              const SizedBox(height: 20),
            ],
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

  Widget _buildFlipCardItem(CarteCollector carte, bool isFlipped) {
    final rareteColor = _getRareteColor(carte.rarete);

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
            // Verso : Récit & Citation
            ? Container(
                key: const ValueKey('verso'),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFFDF8), Color(0xFFF6EEDF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: rareteColor, width: 2),
                  boxShadow: const [
                    BoxShadow(color: Color(0x1F000000), offset: Offset(0, 4), blurRadius: 8),
                  ],
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            carte.sousTitreLatin,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: rareteColor,
                            ),
                          ),
                          const Divider(height: 12),
                          Text(
                            carte.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11, color: RomanColors.charcoal, height: 1.3),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          Text(
                            carte.devise,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5A121E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text('Toucher pour retourner', style: TextStyle(fontSize: 9, color: Colors.black38)),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            // Recto : Illustration Antique
            : Container(
                key: const ValueKey('recto'),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: rareteColor, width: 1.8),
                  boxShadow: const [
                    BoxShadow(color: Color(0x14000000), offset: Offset(0, 3), blurRadius: 8),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Badge rareté
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: rareteColor.withOpacity(0.12),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            carte.rarete.toUpperCase(),
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                              color: rareteColor,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const Icon(Icons.touch_app, size: 12, color: Colors.black38),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            carte.imagePath,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Center(
                              child: Text('🏛️', style: TextStyle(fontSize: 40, color: rareteColor)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFAF7F0),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            carte.titre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
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
                              fontSize: 10.5,
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
    );
  }
}
