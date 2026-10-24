import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/models/mot_du_jour.dart';
import '../../../data/models/thesaurus_entry.dart';
import '../../../data/models/vocab_question.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import '../../../l10n/l10n.dart';
import '../../core/lottie_effects.dart';
import '../../core/particles_overlay.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';

/// Écran du Mot du jour : grille de six essais, clavier AZERTY à l'écran
/// (celui des élèves français), indice après trois essais ratés. L'état du
/// jour vit dans le profil (voir GameRepository.motDuJour), l'écran ne garde
/// que la saisie en cours. La règle des couleurs est dans [MotDuJour].
class MotDuJourScreen extends StatefulWidget {
  final GameRepository repo;

  const MotDuJourScreen({super.key, required this.repo});

  @override
  State<MotDuJourScreen> createState() => _MotDuJourScreenState();
}

const _vert = Color(0xFF3B7D3A);
const _dore = Color(0xFFC99A1E);
const _gris = Color(0xFF8A817A);

const _rangees = ['AZERTYUIOP', 'QSDFGHJKLM', 'WXCVBN'];

class _MotDuJourScreenState extends State<MotDuJourScreen> {
  ThesaurusEntry? _mot;
  String _saisie = '';
  String? _alerte;
  int _gain = 0;

  @override
  void initState() {
    super.initState();
    _mot = widget.repo.motDuJour();
  }

  String get _cible => MotDuJour.forme(_mot!);
  List<String> get _essais => widget.repo.profile.motDuJourEssais;
  bool get _trouve => _essais.contains(_cible);
  bool get _fini => _trouve || _essais.length >= MotDuJour.essaisMax;

  void _taper(String lettre) {
    if (_fini || _saisie.length >= _cible.length) return;
    HapticFeedback.selectionClick();
    setState(() {
      _saisie += lettre;
      _alerte = null;
    });
  }

  void _effacer() {
    if (_saisie.isEmpty) return;
    HapticFeedback.selectionClick();
    setState(() => _saisie = _saisie.substring(0, _saisie.length - 1));
  }

  void _valider() {
    if (_fini) return;
    if (_saisie.length < _cible.length) {
      HapticFeedback.mediumImpact();
      setState(() => _alerte = context.l10n.wordTooShort(_cible.length));
      return;
    }
    final gain = widget.repo.proposerMotDuJour(_saisie);
    setState(() {
      _saisie = '';
      _gain = gain;
    });
    if (_trouve) {
      if (gain > 0) {
        RomanLottieEffects.showCoinShower(context);
      } else {
        AudioService().playTriumph();
        RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
      }
      annoncerAuLecteur(context, context.l10n.wordWin(_essais.length));
    } else if (_fini) {
      AudioService().playError();
      annoncerAuLecteur(context, context.l10n.wordLose(_cible));
    } else {
      AudioService().playCardFlip();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Bibliothèque romaine très pâle derrière la grille.
    return FondDeJeu(
      image: 'assets/images/mot_du_jour/fond_bibliotheque.webp',
      child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: FittedBox(fit: BoxFit.scaleDown, child: Text(context.l10n.wordTitle))),
      body: _mot == null
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Center(child: Text(context.l10n.wordNone, textAlign: TextAlign.center)),
            )
          : ColonneLecture(
              largeurMax: 560,
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _entete(),
                            const SizedBox(height: 14),
                            _grille(),
                            if (_alerte != null) ...[
                              const SizedBox(height: 8),
                              Text(_alerte!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: RomanColors.terracotta, fontWeight: FontWeight.bold)),
                            ],
                            if (!_fini && _essais.length >= MotDuJour.essaisAvantIndice) ...[
                              const SizedBox(height: 12),
                              _indice(),
                            ],
                            if (_fini) ...[
                              const SizedBox(height: 16),
                              _resultat(),
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (!_fini) _clavier(),
                  ],
                ),
              ),
            ),
    ));
  }

  Widget _entete() => Row(
        children: [
          Image.asset('assets/images/lupulus/lupulus_philosophe_180.png', width: 64, height: 64),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.wordLetters(_cible.length),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: RomanColors.imperialPurple, fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(context.l10n.wordRules, style: const TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.3)),
              ],
            ),
          ),
        ],
      );

  /// Six rangées de cases. Les essais passés sont colorés, la rangée en cours
  /// montre la saisie, les suivantes sont vides.
  Widget _grille() {
    return LayoutBuilder(builder: (context, contraintes) {
      final cote = ((contraintes.maxWidth - 8.0 * (_cible.length - 1)) / _cible.length).clamp(36.0, 58.0);
      return Column(
        children: [
          for (var r = 0; r < MotDuJour.essaisMax; r++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var c = 0; c < _cible.length; c++) ...[
                    if (c > 0) const SizedBox(width: 8),
                    _case(r, c, cote),
                  ],
                ],
              ),
            ),
        ],
      );
    });
  }

  Widget _case(int rangee, int colonne, double cote) {
    String lettre = '';
    Color? fond;
    if (rangee < _essais.length) {
      lettre = _essais[rangee][colonne];
      fond = switch (MotDuJour.evaluer(_essais[rangee], _cible)[colonne]) {
        EtatLettre.bienPlacee => _vert,
        EtatLettre.malPlacee => _dore,
        EtatLettre.absente => _gris,
      };
    } else if (rangee == _essais.length && colonne < _saisie.length) {
      lettre = _saisie[colonne];
    }
    final enCours = rangee == _essais.length && !_fini;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: cote,
      height: cote,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fond ?? RomanColors.cardSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: fond ?? (enCours && lettre.isNotEmpty ? RomanColors.imperialPurple : RomanColors.marbleBorder),
          width: 2,
        ),
      ),
      child: Text(
        lettre,
        style: TextStyle(
          fontSize: cote * 0.48,
          fontWeight: FontWeight.bold,
          color: fond == null ? RomanColors.charcoal : Colors.white,
        ),
      ),
    );
  }

  Widget _indice() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: RomanColors.goldLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: RomanColors.imperialGold),
        ),
        child: Row(
          children: [
            const Icon(Icons.lightbulb_outline, color: RomanColors.goldDark),
            const SizedBox(width: 10),
            Expanded(child: Text(context.l10n.wordHint(MotDuJour.indice(_mot!)), style: const TextStyle(fontSize: 14))),
          ],
        ),
      );

  Widget _resultat() {
    final mot = _mot!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _trouve ? RomanColors.laurelLight : RomanColors.palatinCream,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _trouve ? RomanColors.laurelGreen : RomanColors.marbleBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            lupulusAnimation(_trouve ? LupulusMood.triomphe : LupulusMood.encouragement),
            height: 110,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 6),
          Text(
            _trouve ? context.l10n.wordWin(_essais.length) : context.l10n.wordLose(_cible),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: RomanColors.imperialPurple),
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.wordMeaning(mot.latin, VocabQuestion.shortFrench(mot)),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          if (mot.ex.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('${mot.ex} (${mot.exFr})',
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 13.5, fontStyle: FontStyle.italic)),
          ],
          if (_gain > 0) ...[
            const SizedBox(height: 10),
            Text(context.l10n.bataReward(_gain),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, color: RomanColors.goldDark)),
          ],
          const SizedBox(height: 10),
          Text(context.l10n.wordComeBack, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  /// Clavier AZERTY : les touches prennent la couleur la plus informative
  /// déjà obtenue, comme dans Wordle. Touches d'au moins 48 points de haut.
  Widget _clavier() {
    final etats = MotDuJour.etatsDuClavier(_essais, _cible);
    Widget touche(String lettre) {
      final etat = etats[lettre];
      final fond = switch (etat) {
        EtatLettre.bienPlacee => _vert,
        EtatLettre.malPlacee => _dore,
        EtatLettre.absente => _gris,
        null => RomanColors.palatinCream,
      };
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(2.5),
          child: Material(
            color: fond,
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () => _taper(lettre),
              child: SizedBox(
                height: 50,
                child: Center(
                  child: Text(lettre,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: etat == null ? RomanColors.charcoal : Colors.white)),
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget action({required Widget enfant, required VoidCallback onTap, required int flex, String? libelle}) => Expanded(
          flex: flex,
          child: Padding(
            padding: const EdgeInsets.all(2.5),
            child: Semantics(
              button: true,
              label: libelle,
              child: Material(
                color: RomanColors.imperialPurple,
                borderRadius: BorderRadius.circular(6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: onTap,
                  child: SizedBox(height: 50, child: Center(child: enfant)),
                ),
              ),
            ),
          ),
        );

    return Container(
      color: RomanColors.travertinWhite,
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [for (final l in _rangees[0].split('')) touche(l)]),
          Row(children: [for (final l in _rangees[1].split('')) touche(l)]),
          Row(
            children: [
              action(
                flex: 2,
                onTap: _effacer,
                libelle: context.l10n.a11yDelete,
                enfant: const Icon(Icons.backspace_outlined, color: Colors.white, size: 20),
              ),
              for (final l in _rangees[2].split('')) touche(l),
              action(
                flex: 3,
                onTap: _valider,
                enfant: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(context.l10n.wordValidate,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
