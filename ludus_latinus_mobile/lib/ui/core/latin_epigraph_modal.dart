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

  /// Ouvre la première stèle non encore décodée, ou la première du catalogue historique.
  static void showRandomOrFirst(BuildContext context, {required GameRepository repo}) {
    LatinEpigraph? target;
    for (final epi in LatinEpigraph.catalogue.values) {
      if (!repo.isEpigraphDecoded(epi.monumentId)) {
        target = epi;
        break;
      }
    }
    target ??= LatinEpigraph.catalogue.values.first;
    show(context, epigraph: target, repo: repo);
  }

  @override
  State<LatinEpigraphModal> createState() => _LatinEpigraphModalState();
}

class _LatinEpigraphModalState extends State<LatinEpigraphModal> {
  int? _selectedTokenIndex;

  // L'étude : chaque fragment doit avoir été examiné avant l'épreuve.
  final Set<int> _examines = {};

  // L'épreuve : retrouver le sens de trois fragments, sans la fiche sous les yeux.
  bool _epreuve = false;
  List<int> _questions = [];
  int _numQuestion = 0;
  int _erreurs = 0;
  List<String> _choix = [];
  String? _choixFaux;

  int get _gainApresErreur => (widget.epigraph.recompense + 1) ~/ 2;

  void _commencerEpreuve() {
    final indices = List<int>.generate(widget.epigraph.tokens.length, (i) => i)..shuffle();
    setState(() {
      _epreuve = true;
      _questions = indices.take(3).toList();
      _numQuestion = 0;
      _selectedTokenIndex = null;
      _preparerChoix();
    });
  }

  void _preparerChoix() {
    final tokens = widget.epigraph.tokens;
    final bonne = tokens[_questions[_numQuestion]].traduction;
    final autres = tokens.map((t) => t.traduction).where((t) => t != bonne).toSet().toList()..shuffle();
    _choix = [bonne, ...autres.take(3)]..shuffle();
    _choixFaux = null;
  }

  void _repondre(String choix) {
    final bonne = widget.epigraph.tokens[_questions[_numQuestion]].traduction;
    if (choix != bonne) {
      HapticFeedback.mediumImpact();
      setState(() {
        _erreurs++;
        _choixFaux = choix;
      });
      return;
    }
    HapticFeedback.lightImpact();
    if (_numQuestion < _questions.length - 1) {
      setState(() {
        _numQuestion++;
        _preparerChoix();
      });
      return;
    }
    final gain = _erreurs == 0 ? widget.epigraph.recompense : _gainApresErreur;
    widget.repo.decodeEpigraph(widget.epigraph.monumentId, gain);
    AudioService().playSesterces();
    AudioService().playTriumph();
    RomanLottieEffects.showMonumentBlessing(context);
    RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
    setState(() => _epreuve = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: RomanColors.laurelGreen,
        content: Text(
          '🏛️ Épigraphe déchiffrée ! +$gain HS versés à ton trésor.',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEpreuve() {
    final token = widget.epigraph.tokens[_questions[_numQuestion]];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RomanColors.imperialGold, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ÉPREUVE DU LAPICIDE : ${_numQuestion + 1} / ${_questions.length}',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Color(0xFF7A5901),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Que signifie ce fragment ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: RomanColors.charcoal),
          ),
          const SizedBox(height: 6),
          Text(
            token.texteGraver,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'serif',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: RomanColors.imperialPurple,
            ),
          ),
          const SizedBox(height: 10),
          for (final choix in _choix)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: choix == _choixFaux ? Colors.red.shade800 : RomanColors.imperialPurple,
                  backgroundColor: choix == _choixFaux ? const Color(0xFFFDECEA) : Colors.white,
                  side: BorderSide(
                    color: choix == _choixFaux ? Colors.red.shade400 : RomanColors.marbleBorder,
                    width: 1.2,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onPressed: () => _repondre(choix),
                child: Text(choix, textAlign: TextAlign.center),
              ),
            ),
          if (_choixFaux != null)
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                "Ce n'est pas ça. Essaie encore, ou retourne voir les fragments.",
                style: TextStyle(fontSize: 12, color: Color(0xFFB71C1C)),
              ),
            ),
          Text(
            'Sans erreur : +${widget.epigraph.recompense} HS. Après une erreur : +$_gainApresErreur HS.',
            style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF5A442E)),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => setState(() => _epreuve = false),
              child: const Text('Revoir les fragments'),
            ),
          ),
        ],
      ),
    );
  }

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
                // 1. La stèle de marbre (image Gemini), l'inscription gravée dans son panneau.
                const Text(
                  '« ÉPIGRAPHE ORIGINALE GRAVÉE »',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Color(0xFF634A31),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 330),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/epigraphie/stele_vierge.webp',
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const ColoredBox(color: Color(0xFFEADCCB)),
                          ),
                          // Le panneau lisse, à l'intérieur de la couronne de laurier.
                          Align(
                            alignment: const Alignment(0, -0.06),
                            child: FractionallySizedBox(
                              widthFactor: 0.46,
                              heightFactor: 0.52,
                              child: LayoutBuilder(
                                builder: (context, c) => FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: SizedBox(
                                    width: c.maxWidth,
                                    child: Text(
                                      // Des points entre les mots, comme sur les vraies stèles.
                                      widget.epigraph.texteAntique.replaceAll('·', ' · '),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'serif',
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.1,
                                        height: 1.45,
                                        color: Color(0xFF4A3520),
                                        shadows: [
                                          Shadow(color: Colors.white, offset: Offset(1, 1), blurRadius: 1),
                                          Shadow(color: Color(0x55000000), offset: Offset(-1, -1), blurRadius: 1),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Text(
                  isDecoded
                      ? 'Touche un fragment pour revoir sa fiche.'
                      : 'Examine chaque fragment, puis estampe la pierre : il faudra retrouver le sens de trois d\'entre eux.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF5A442E),
                  ),
                ),

                const SizedBox(height: 16),

                if (_epreuve) ...[
                  _buildEpreuve(),
                  const SizedBox(height: 14),
                ] else ...[
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
                      avatar: !isDecoded && _examines.contains(index)
                          ? Icon(
                              Icons.check_circle,
                              size: 16,
                              color: isSelected ? Colors.white : RomanColors.laurelGreen,
                            )
                          : null,
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
                          _examines.add(index);
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
                ],

                // 4. Traduction intégrale : la récompense de l'épreuve, pas son corrigé.
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
                        isDecoded
                            ? widget.epigraph.traductionComplete
                            : '🔒 Elle apparaîtra quand tu auras estampé la pierre.',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          color: isDecoded ? RomanColors.imperialPurple : const Color(0xFF7A6A58),
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
                      : _epreuve
                          ? 'Épreuve en cours'
                          : _examines.length < widget.epigraph.tokens.length
                              ? 'Examine chaque fragment (${_examines.length} / ${widget.epigraph.tokens.length})'
                              : 'Estamper la Pierre (+${widget.epigraph.recompense} Sesterces)',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                // Inactif tant que tous les fragments n'ont pas été examinés, et pendant l'épreuve.
                onPressed: isDecoded
                    ? () => Navigator.pop(context)
                    : (_epreuve || _examines.length < widget.epigraph.tokens.length)
                        ? null
                        : _commencerEpreuve,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
