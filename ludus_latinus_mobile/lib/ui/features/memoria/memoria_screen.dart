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
  tous('Tous', null),
  cinquieme('5ème', '5eme'),
  quatrieme('4ème', '4eme'),
  troisieme('3ème', '3eme');

  final String label;

  /// Identifiant de classe des mondes retenus (null : tous les niveaux).
  final String? classeId;
  const NiveauMemoria(this.label, this.classeId);

  bool matches(String? classe) => classeId == null || classe == classeId;
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

  String _cardKey(SrsCard card) => card.id.isNotEmpty ? card.id : card.latin;

  // Question de la carte en cours : l'élève choisit la traduction parmi quatre.
  // Avant, il se notait lui-même (« Maîtrisé ! ») et était payé pour ça.
  String? _questionPour;
  List<String> _options = const [];
  String _bonne = '';
  String? _choix;

  static String _court(String fr) => fr.split('(').first.split(';').first.trim();

  void _preparerQuestion(SrsCard card) {
    if (_questionPour == _cardKey(card)) return;
    final rnd = math.Random();
    _questionPour = _cardKey(card);
    _choix = null;
    _bonne = _court(card.francais);
    final autres = widget.repo.thesaurus
        .where((e) => e.latin != card.latin && e.cat != 'Devise' && _court(e.fr).isNotEmpty)
        .toList()
      ..shuffle(rnd);
    // Des distracteurs de même nature (noms avec noms…) d'abord : sinon on devine.
    autres.sort((a, b) => (a.cat == card.categorie ? 0 : 1) - (b.cat == card.categorie ? 0 : 1));
    final faux = <String>[];
    for (final e in autres) {
      final f = _court(e.fr);
      if (f.toLowerCase() != _bonne.toLowerCase() && !faux.contains(f)) faux.add(f);
      if (faux.length == 3) break;
    }
    _options = [_bonne, ...faux]..shuffle(rnd);
  }

  // Paquet de la séance, figé à l'ouverture et à chaque changement de niveau.
  // Retrié à chaque affichage, il faisait passer une autre carte sous la
  // carte retournée : l'élève voyait la solution de la suivante.
  List<SrsCard>? _seance;

  List<SrsCard> get _paquet => _seance ??= _filteredCards;

  List<SrsCard> get _filteredCards {
    final cards = widget.repo.memoriaCards
        .where((c) => selectedNiveau.matches(widget.repo.classeDuMonde(c.monde)))
        .toList();

    // Trie par priorité didactique : les cartes à réviser (isDue) en tête de file
    cards.sort((a, b) {
      final progA = widget.repo.getSrsProgress(_cardKey(a));
      final progB = widget.repo.getSrsProgress(_cardKey(b));
      if (progA.isDue && !progB.isDue) return -1;
      if (!progA.isDue && progB.isDue) return 1;
      return progA.nextReviewDate.compareTo(progB.nextReviewDate);
    });

    return cards;
  }

  int get _dueCount {
    return _paquet.where((c) => widget.repo.getSrsProgress(_cardKey(c)).isDue).length;
  }

  static String _toRoman(int number) {
    switch (number) {
      case 1:
        return 'I';
      case 2:
        return 'II';
      case 3:
        return 'III';
      case 4:
        return 'IV';
      case 5:
        return 'V';
      default:
        return '$number';
    }
  }

  static int _boxIntervalDays(int box) {
    switch (box) {
      case 1:
        return 1;
      case 2:
        return 3;
      case 3:
        return 7;
      case 4:
        return 14;
      case 5:
      default:
        return 30;
    }
  }

  static Color _getBoxColor(int box) {
    switch (box) {
      case 1:
        return const Color(0xFF8B2500); // Terre cuite
      case 2:
        return const Color(0xFFB8860B); // Bronze antique
      case 3:
        return const Color(0xFF5A738E); // Acier / Argent
      case 4:
        return const Color(0xFFC5A059); // Or impérial
      case 5:
      default:
        return RomanColors.laurelGreen; // Laurier de triomphe
    }
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
    // Retourner la carte avant de répondre, ce serait lire la solution.
    if (_choix == null) return;
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

  void _repondre(SrsCard card, String option) {
    if (_choix != null) return;
    final key = _cardKey(card);
    final etaitAReviser = widget.repo.getSrsProgress(key).isDue;
    final juste = option == _bonne;
    widget.repo.recordSrsReview(key, success: juste);

    var gain = 0;
    if (juste) {
      _streak++;
      if (_streak > _maxStreak) _maxStreak = _streak;
      // Seule une carte à réviser rapporte : revoir en boucle une carte déjà
      // sue ne doit pas remplir la bourse.
      if (etaitAReviser) gain = GameRepository.gainMemoria;
      HapticFeedback.mediumImpact();
      if (_streak >= 5) RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
      AudioService().playCorrect();
    } else {
      _streak = 0;
      HapticFeedback.lightImpact();
      AudioService().playError();
    }
    if (gain > 0) {
      sessionEarnings += gain;
      widget.repo.addSesterces(gain);
    }

    final prog = widget.repo.getSrsProgress(key);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: juste ? RomanColors.laurelGreen : const Color(0xFF8B2500),
        duration: const Duration(milliseconds: 1400),
        content: Text(juste
            ? 'Exact ! Arca ${_toRoman(prog.box)} : prochaine révision dans ${_boxIntervalDays(prog.box)} j${gain > 0 ? ' (+$gain HS)' : ''}'
            : "C'était « $_bonne ». Retour en Arca I : tu la reverras bientôt."),
      ),
    );

    setState(() => _choix = option);
    // La carte se retourne toute seule : traduction, étymologie, exemple.
    _flipController.forward();
    isFront = false;
  }

  void _carteSuivante(int total) {
    HapticFeedback.selectionClick();
    if (currentIndex < total - 1) {
      _flipController.reverse();
      setState(() {
        isFront = true;
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
                  lupulusAnimation(LupulusMood.triomphe),
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
    final cards = _paquet;
    if (cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('MEMORIA VELOX')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              selectedNiveau == NiveauMemoria.tous
                  ? "Ta Memoria est encore vide.\n\nTermine une leçon de la Via Appia : ses mots viendront s'y réviser."
                  : "Aucun mot de ${selectedNiveau.label} pour l'instant : termine une leçon de ce niveau.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, height: 1.5, color: RomanColors.charcoal),
            ),
          ),
        ),
      );
    }

    final safeIndex = currentIndex.clamp(0, cards.length - 1);
    final card = cards[safeIndex];
    _preparerQuestion(card);

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
                            _seance = null;
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
                      _streak >= 5 ? 'FUROR LATINUS MAXIMUS !' : 'FUROR LATINUS !',
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

            // 3. Barre de progression & Compteur de révision du jour
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Carte ${safeIndex + 1} / ${cards.length}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: RomanColors.imperialPurple),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: _dueCount > 0 ? const Color(0xFFFDE8E8) : const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _dueCount > 0 ? const Color(0xFFE57373) : const Color(0xFF81C784),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_dueCount > 0 ? '⏳ ' : '✓ ', style: const TextStyle(fontSize: 9)),
                          Text(
                            '$_dueCount à réviser',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _dueCount > 0 ? const Color(0xFFC62828) : const Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                      lupulusAnimation(_streak >= 5
                          ? LupulusMood.triomphe
                          : _streak >= 3
                              ? LupulusMood.joie
                              : LupulusMood.reflexion),
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Text('🐺', style: TextStyle(fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Souple : les messages de série sont longs, ils passent à la ligne.
                  Flexible(
                    child: Text(
                      _streak >= 5
                          ? '« Incredibile ! Le feu de Rome brûle en toi ! »'
                          : _streak >= 3
                              ? '« Macte animo ! Continue sur cette belle lancée ! »'
                              : '« Repetitio est mater studiorum ! »',
                      style: const TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: RomanColors.imperialPurple,
                        fontWeight: FontWeight.w600,
                      ),
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

            // 5. Quatre traductions possibles, puis « Carte suivante » une fois répondu.
            if (_choix == null)
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 3.2,
                children: [
                  for (final option in _options)
                    _buildOption(option, onTap: () => _repondre(card, option)),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: RomanButton(
                  text: safeIndex < cards.length - 1 ? 'CARTE SUIVANTE' : 'TERMINER',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => _carteSuivante(cards.length),
                ),
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
    final prog = widget.repo.getSrsProgress(_cardKey(card));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                  const SizedBox(width: 5),
                  Text(
                    card.categorie.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                      color: Color(0xFF7A5901),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _getBoxColor(prog.box),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: RomanColors.imperialGold, width: 0.9),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1F000000),
                    offset: Offset(0, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Text(
                'ARCA ${_toRoman(prog.box)}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
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
              Text('👇 ', style: TextStyle(fontSize: 12)),
              Text(
                'Choisis sa traduction ci-dessous',
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

  Widget _buildOption(String texte, {required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: RomanColors.imperialGold, width: 1.4),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              texte,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: RomanColors.charcoal),
            ),
          ),
        ),
      ),
    );
  }
}
