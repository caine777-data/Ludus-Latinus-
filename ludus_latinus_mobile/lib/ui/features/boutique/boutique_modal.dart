import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/models/goodie_item.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../core/particles_overlay.dart';
import '../../core/game_juice.dart';
import '../../core/avatar_assets.dart';

/// Modal de la Boutique Impériale (Taberna Romana) & Penderie de l'Avatar.
/// Permet au joueur de dépenser ses sesterces pour acheter et équiper des goodies.
class BoutiqueModal extends StatefulWidget {
  final GameRepository repo;
  final GoodieCategory initialCategory;

  const BoutiqueModal({
    super.key,
    required this.repo,
    this.initialCategory = GoodieCategory.toge,
  });

  static Future<void> show(
    BuildContext context, {
    required GameRepository repo,
    GoodieCategory initialCategory = GoodieCategory.toge,
  }) {
    HapticFeedback.mediumImpact();
    AudioService().playCardFlip();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BoutiqueModal(
        repo: repo,
        initialCategory: initialCategory,
      ),
    );
  }

  @override
  State<BoutiqueModal> createState() => _BoutiqueModalState();
}

class _BoutiqueModalState extends State<BoutiqueModal> {
  late GoodieCategory _activeCategory;

  @override
  void initState() {
    super.initState();
    _activeCategory = widget.initialCategory;
  }

  void _onCategoryChanged(GoodieCategory cat) {
    HapticFeedback.selectionClick();
    AudioService().playCardFlip();
    setState(() => _activeCategory = cat);
  }

  void _acheterObjet(GoodieItem item) {
    final solde = widget.repo.profile.sesterces;
    if (solde < item.prix) {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade800,
          content: Text(
            '🪙 Sesterces insuffisants ! Il te manque ${item.prix - solde} HS. Réussis des leçons pour en amasser !',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
      return;
    }

    HapticFeedback.heavyImpact();
    AudioService().playSesterces();
    AudioService().playTriumph();

    final ok = widget.repo.buyGoodie(item);
    if (ok) {
      RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: RomanColors.laurelGreen,
          content: Row(
            children: [
              Text(item.icone, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Acquis & Équipé : ${item.nom} (${item.nomLatin}) !',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _equiperObjet(GoodieItem item) {
    HapticFeedback.selectionClick();
    AudioService().playCardFlip();
    widget.repo.equipGoodie(item.categorie, item.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: RomanColors.imperialPurple,
        content: Text(
          'Tenue modifiée : ${item.nom} équipé !',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: widget.repo,
      builder: (context, _) {
        final profile = widget.repo.profile;
        final avatarImg = AvatarAssets.medaillon(profile);

        final itemsFiltered = kCatalogueBoutique
            .where((it) => it.categorie == _activeCategory)
            .toList();

        return Container(
          height: size.height * 0.90,
          decoration: const BoxDecoration(
            color: RomanColors.travertine,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // 1. Barre de poignée & En-tête Impérial
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 16, 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  border: Border(
                    bottom: BorderSide(color: RomanColors.marbleBorder, width: 1.2),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('🏛️', style: TextStyle(fontSize: 22)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TABERNA ROMANA',
                                style: TextStyle(
                                  fontFamily: RomanFonts.imperial,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  color: RomanColors.imperialPurple,
                                ),
                              ),
                              const Text(
                                'Boutique & Penderie Impériale • Équipe ton Héros',
                                style: TextStyle(fontSize: 11, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        // Compteur de Sesterces doré
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: RomanColors.goldLight,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                          ),
                          child: RollingSestercesCounter(
                            value: profile.sesterces,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF684900),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: RomanColors.charcoal),
                          tooltip: 'Fermer',
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. Podium d'Essayage de l'Avatar
              _buildPodium(context, profile, avatarImg),

              // 3. Barre d'Onglets des 4 Catégories
              _buildCategoryTabs(),

              const RomanMeanderDivider(
                height: 8,
                strokeWidth: 1.0,
                margin: EdgeInsets.symmetric(vertical: 4),
              ),

              // 4. Grille des Articles de la Catégorie
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 860),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      itemCount: itemsFiltered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = itemsFiltered[index];
                        final isEquipped = widget.repo.isGoodieEquipped(item.categorie, item.id);
                        final isOwned = widget.repo.isGoodieOwned(item.id) || item.isGratuit;
                        final canAfford = profile.sesterces >= item.prix;

                        return _buildItemCard(item, isEquipped, isOwned, canAfford);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Podium visuel affichant l'avatar et la synthèse de sa tenue actuelle.
  Widget _buildPodium(BuildContext context, dynamic profile, String avatarImg) {
    final togeId = widget.repo.getEquippedGoodie(GoodieCategory.toge);
    final togeItem = kCatalogueBoutique.firstWhere(
      (it) => it.id == togeId,
      orElse: () => kCatalogueBoutique[0],
    );

    final couronneId = widget.repo.getEquippedGoodie(GoodieCategory.couronne);
    final couronneItem = kCatalogueBoutique.firstWhere(
      (it) => it.id == couronneId,
      orElse: () => kCatalogueBoutique[4],
    );

    final accessoireId = widget.repo.getEquippedGoodie(GoodieCategory.accessoire);
    final accessoireItem = kCatalogueBoutique.firstWhere(
      (it) => it.id == accessoireId,
      orElse: () => kCatalogueBoutique[9],
    );

    final compagnonId = widget.repo.getEquippedGoodie(GoodieCategory.compagnon);
    final compagnonItem = kCatalogueBoutique.firstWhere(
      (it) => it.id == compagnonId,
      orElse: () => kCatalogueBoutique[14],
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: RomanColors.marbleBorder, width: 1.2),
        boxShadow: const [
          BoxShadow(color: Color(0x0C000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Médaillon de l'Avatar
          RomanMedallion(
            imagePath: avatarImg,
            size: 58,
            fallbackEmoji: profile.genre == 'fille' ? '👸' : '🤴',
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${profile.nomHeros}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: RomanColors.imperialPurple,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: RomanColors.goldLight,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: RomanColors.imperialGold, width: 0.8),
                      ),
                      child: Text(
                        '${profile.cursusRank.badge} ${profile.cursusRank.titre}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF684900),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Puces de la tenue équipée
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _buildGearChip(
                      GoodieCategory.toge,
                      togeItem.icone,
                      togeItem.nom,
                    ),
                    _buildGearChip(
                      GoodieCategory.couronne,
                      couronneItem.icone,
                      couronneItem.nom,
                    ),
                    _buildGearChip(
                      GoodieCategory.accessoire,
                      accessoireItem.icone,
                      accessoireItem.nom,
                    ),
                    if (compagnonItem.id != 'aucun')
                      _buildGearChip(
                        GoodieCategory.compagnon,
                        compagnonItem.icone,
                        compagnonItem.nom,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGearChip(GoodieCategory cat, String icon, String label) {
    final isSelectedCat = _activeCategory == cat;
    return InkWell(
      onTap: () => _onCategoryChanged(cat),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
        decoration: BoxDecoration(
          color: isSelectedCat ? RomanColors.imperialPurple.withOpacity(0.08) : const Color(0xFFF7F4EC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelectedCat ? RomanColors.imperialPurple : RomanColors.marbleBorder,
            width: isSelectedCat ? 1.2 : 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isSelectedCat ? FontWeight.bold : FontWeight.w500,
                color: isSelectedCat ? RomanColors.imperialPurple : RomanColors.charcoal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Onglets de navigation entre les catégories
  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: GoodieCategory.values.map((cat) {
            final isSelected = _activeCategory == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text('${cat.icone} ${cat.titre}'),
                selected: isSelected,
                selectedColor: RomanColors.imperialPurple,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  fontFamily: RomanFonts.body,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? RomanColors.goldLight : RomanColors.charcoal,
                ),
                side: BorderSide(
                  color: isSelected ? RomanColors.imperialGold : RomanColors.marbleBorder,
                  width: isSelected ? 1.2 : 1.0,
                ),
                onSelected: (_) => _onCategoryChanged(cat),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Carte individuelle pour chaque article achetable/équipable
  Widget _buildItemCard(GoodieItem item, bool isEquipped, bool isOwned, bool canAfford) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isEquipped
              ? RomanColors.laurelGreen
              : isOwned
                  ? RomanColors.imperialGold.withOpacity(0.6)
                  : RomanColors.marbleBorder,
          width: isEquipped ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isEquipped ? RomanColors.laurelGreen.withOpacity(0.08) : const Color(0x06000000),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Grande icône stylisée en médaillon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isEquipped
                  ? RomanColors.laurelGreen.withOpacity(0.12)
                  : const Color(0xFFF9F7F1),
              border: Border.all(
                color: isEquipped ? RomanColors.laurelGreen : RomanColors.imperialGold.withOpacity(0.5),
                width: 1.2,
              ),
            ),
            // Illustration de l'objet si elle existe, sinon l'icône de secours.
            child: ClipOval(
              child: Image.asset(
                'assets/images/boutique/${item.id}.png',
                // « contain » : l'objet détouré reste entier dans le médaillon.
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(item.icone, style: const TextStyle(fontSize: 28)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Informations & Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom sur toute la largeur, badge en dessous : plus de coupure lettre par lettre.
                Text(
                  item.nom,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: RomanColors.charcoal,
                  ),
                ),
                // Les « bonus » affichés (+15 % Résistance…) n'ont aucun effet dans le jeu :
                // on ne promet rien de faux à l'élève tant qu'ils ne sont pas codés.
                if (item.bonus != null && !item.bonus!.contains('%'))
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: RomanColors.goldLight,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: RomanColors.imperialGold, width: 0.8),
                        ),
                        child: Text(
                          item.bonus!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF684900),
                          ),
                        ),
                      ),
                  ),
                const SizedBox(height: 4),
                Text(
                  item.nomLatin,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: RomanColors.imperialPurple,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Bouton d'action (Équipé / Équiper / Acheter)
          _buildActionButton(item, isEquipped, isOwned, canAfford),
        ],
      ),
    );
  }

  Widget _buildActionButton(GoodieItem item, bool isEquipped, bool isOwned, bool canAfford) {
    if (isEquipped) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: RomanColors.laurelGreen.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: RomanColors.laurelGreen, width: 1.2),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, color: RomanColors.laurelGreen, size: 16),
            SizedBox(width: 4),
            Text(
              'Porté',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: RomanColors.laurelGreen,
              ),
            ),
          ],
        ),
      );
    }

    if (isOwned) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: RomanColors.imperialPurple,
          foregroundColor: RomanColors.goldLight,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: RomanColors.imperialGold, width: 1),
          ),
          elevation: 1,
        ),
        onPressed: () => _equiperObjet(item),
        child: const Text(
          'Équiper',
          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
        ),
      );
    }

    // Objet non possédé -> Acheter avec les sesterces
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: canAfford ? RomanColors.goldLight : const Color(0xFFF0EBE0),
        foregroundColor: canAfford ? const Color(0xFF684900) : Colors.black38,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: canAfford ? RomanColors.imperialGold : Colors.black12,
            width: 1.2,
          ),
        ),
        elevation: canAfford ? 1 : 0,
      ),
      onPressed: () => _acheterObjet(item),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🪙', style: TextStyle(fontSize: 13)),
          const SizedBox(width: 4),
          Text(
            '${item.prix} HS',
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
