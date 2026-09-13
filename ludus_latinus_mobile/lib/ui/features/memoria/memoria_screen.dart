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

            const SizedBox(height: 10),

            // 3b. Présence bienveillante de Lupulus (Mentor pédagogique)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: RomanColors.palatinCream,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: RomanColors.marbleBorder, width: 0.9),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    offset: Offset(0, 1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipOval(
                    child: Image.asset(
                      _streak >= 5
                          ? 'assets/images/lupulus/lupulus_triomphe_180.png'
                          : _streak >= 3
                              ? 'assets/images/lupulus/lupulus_joie_180.png'
                              : 'assets/images/lupulus/lupulus_reflexion_180.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Text('🐺', style: TextStyle(fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _streak >= 5
                        ? '« Incredibile ! Le feu de Rome brûle en toi ! »'
                        : _streak >= 3
                            ? '« Macte animo ! Continue sur cette belle lancée ! »'
                            : '« Repetitio est mater studiorum : touche la carte ! »',
                    style: const TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: RomanColors.imperialPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // 4. Flashcard 3D Matrix4 avec dynamique de relief et perspective
            Expanded(
              child: GestureDetector(
                onTap: _flipCard,
                child: AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, _) {
                    final angle = _flipAnimation.value * math.pi;
                    final isFrontVisible = _flipAnimation.value < 0.5;
                    // Effet de soulèvement vers l'avant lors du retournement
                    final flipProgress = (0.5 - (_flipAnimation.value - 0.5).abs()) * 2.0;
                    final scale = 1.0 + (flipProgress * 0.04);

                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0012)
                        ..scale(scale)
                        ..rotateY(angle),
                      alignment: Alignment.center,
                      child: isFrontVisible
                          ? _buildCardSide(
                              isFront: true,
                              flipProgress: flipProgress,
                              child: _buildRecto(card),
                            )
                          : Transform(
                              transform: Matrix4.identity()..rotateY(math.pi),
                              alignment: Alignment.center,
                              child: _buildCardSide(
                                isFront: false,
                                flipProgress: flipProgress,
                                child: _buildVerso(card),
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 14),

            // 5. Boutons Leitner SRS avec relief tactile et multiplicateurs
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

  Widget _buildCornerOrnament() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: RomanColors.imperialGold,
        boxShadow: const [
          BoxShadow(
            color: Color(0x44000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSide({
    required bool isFront,
    required Widget child,
    required double flipProgress,
  }) {
    final elevation = 4.0 + (flipProgress * 10.0);
    final spread = 1.0 + (flipProgress * 3.0);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          // Halo ardent si Furor Latinus
          if (_streak >= 5) ...[
            const BoxShadow(
              color: Color(0x77D50000),
              blurRadius: 26,
              spreadRadius: 4,
            ),
            const BoxShadow(
              color: Color(0x55FF9100),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ] else if (_streak >= 3) ...[
            const BoxShadow(
              color: Color(0x66FFB300),
              blurRadius: 20,
              spreadRadius: 3,
            ),
          ],
          BoxShadow(
            color: const Color(0x332B1810),
            blurRadius: elevation * 2,
            spreadRadius: spread,
            offset: Offset(0, 4 + flipProgress * 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Fond dégradé marbre de Carrare ou parchemin d'or
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isFront
                        ? const [Color(0xFFFCF9F3), Color(0xFFF6F0E6), Color(0xFFEFE6D6)]
                        : const [Color(0xFFF7FCF9), Color(0xFFEFF8F2), Color(0xFFE4F3E9)],
                  ),
                ),
              ),
            ),

            // Filigrane subtil de la carte collector antique
            Positioned.fill(
              child: Opacity(
                opacity: 0.07,
                child: Image.asset(
                  'assets/images/dos_carte_collector.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
            ),

            // Double cadre ciselé or et marbre
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isFront ? RomanColors.imperialGold : RomanColors.laurelGreen,
                    width: 3.5,
                  ),
                ),
              ),
            ),

            // Liseré intérieur avec coins ouvragés
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isFront
                          ? RomanColors.imperialGold.withOpacity(0.5)
                          : RomanColors.laurelGreen.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),

            // Rivets d'angle antiques
            Positioned(top: 10, left: 10, child: _buildCornerOrnament()),
            Positioned(top: 10, right: 10, child: _buildCornerOrnament()),
            Positioned(bottom: 10, left: 10, child: _buildCornerOrnament()),
            Positioned(bottom: 10, right: 10, child: _buildCornerOrnament()),

            // Contenu de la face de carte
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: Center(child: child),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryIcon(String cat) {
    if (cat.contains('Dieux') || cat.contains('Mythes')) return '⚡';
    if (cat.contains('Armée') || cat.contains('Légions')) return '⚔️';
    if (cat.contains('Maison') || cat.contains('Famille')) return '🏡';
    if (cat.contains('Nature') || cat.contains('Animaux')) return '🐾';
    if (cat.contains('Citoyenneté') || cat.contains('Valeurs')) return '🏛️';
    return '📜';
  }

  Widget _buildRecto(SrsCard card) {
    final catIcon = _getCategoryIcon(card.categorie);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [RomanColors.goldLight, const Color(0xFFFFF9E8)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: RomanColors.imperialGold, width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F000000),
                offset: Offset(0, 1),
                blurRadius: 3,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(catIcon, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 6),
              Text(
                card.categorie.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: Color(0xFF7A5901),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        Text(
          card.latin,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: RomanColors.imperialPurple,
            fontFamily: 'serif',
            shadows: [
              Shadow(
                color: Color(0x224A1525),
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        if (card.genre.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0x1F000000),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              card.genre,
              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black87),
            ),
          ),
        ],
        const SizedBox(height: 14),
        InkWell(
          onTap: () {
            AudioService().playWheelClick();
            LatinPronunciationModal.show(context, card.latin);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: RomanColors.goldLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: RomanColors.imperialGold, width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000),
                  offset: Offset(0, 1),
                  blurRadius: 3,
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.volume_up_rounded, size: 16, color: RomanColors.imperialPurple),
                SizedBox(width: 5),
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
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: RomanColors.palatinCream,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: RomanColors.marbleBorder, width: 0.8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('👆 ', style: TextStyle(fontSize: 12)),
              Text(
                'Touche pour retourner la carte',
                style: TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w600),
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5EE),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: RomanColors.laurelGreen.withOpacity(0.5)),
          ),
          child: const Text(
            'TRADUCTION FRANÇAISE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: Color(0xFF1E5E3A),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          card.francais,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: RomanColors.laurelGreen,
            shadows: [
              Shadow(
                color: Color(0x221E5E3A),
                offset: Offset(0, 1.5),
                blurRadius: 3,
              ),
            ],
          ),
        ),
        if (card.etymologie.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5EE),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFC3E6D0)),
            ),
            child: Text(
              card.etymologie,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF1E5E3A)),
            ),
          ),
        ],
        if (card.exemple.isNotEmpty) ...[
          const SizedBox(height: 16),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color,
                  Color.lerp(color, Colors.black, 0.22)!,
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    sub,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFECB3),
                    ),
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