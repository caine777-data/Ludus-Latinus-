import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/models/vocab_question.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import '../../../l10n/l10n.dart';
import '../../core/lottie_effects.dart';
import '../../core/particles_overlay.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import 'paires_eclair.dart';

/// Écran de Paires éclair, habillé en « messages de Mercure » : Lupulus en
/// Mercure sur la bannière, fond de ciel doré, cartes latines en tablette de
/// cire et traductions en papyrus. La règle du jeu est dans [PartiePaires].
class PairesScreen extends StatefulWidget {
  final GameRepository repo;

  const PairesScreen({super.key, required this.repo});

  @override
  State<PairesScreen> createState() => _PairesScreenState();
}

enum _Etape { regles, enJeu, fin }

/// Paires justes d'affilée qui déclenchent « Celeriter ! ».
const int _serieCeleriter = 3;

/// Puce des mots que le temps n'a pas laissé atteindre.
const _gris = Color(0xFF8A817A);

class _PairesScreenState extends State<PairesScreen> {
  late PartiePaires _partie;
  _Etape _etape = _Etape.regles;
  Timer? _chrono;
  int _secondesRestantes = PartiePaires.dureeSecondes;

  /// Mot latin touché, en attente de sa traduction.
  int? _latinChoisi;

  /// Paire fausse affichée en rouge un court instant (latin, position française).
  (int, int)? _erreur;

  /// Bonnes paires d'affilée, remises à zéro à chaque erreur.
  int _serie = 0;

  /// Message bref au centre de l'écran (nouvelle manche, « Celeriter ! »).
  /// La clé change à chaque annonce pour relancer l'animation.
  String? _annonce;
  int _cleAnnonce = 0;

  int _gain = 0;
  bool _nouveauRecord = false;

  @override
  void initState() {
    super.initState();
    _partie = _nouvellePartie();
  }

  PartiePaires _nouvellePartie() => PartiePaires.tirer(
        dictionnaire: widget.repo.thesaurus,
        mondes: widget.repo.mondesAtteints,
      );

  @override
  void dispose() {
    _chrono?.cancel();
    super.dispose();
  }

  void _commencer() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_etape == _Etape.fin) _partie = _nouvellePartie();
      _etape = _Etape.enJeu;
      _secondesRestantes = PartiePaires.dureeSecondes;
      _latinChoisi = null;
      _erreur = null;
      _serie = 0;
      _annonce = null;
      _gain = 0;
      _nouveauRecord = false;
    });
    _chrono?.cancel();
    _chrono = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _secondesRestantes--);
      if (_secondesRestantes <= 0) _terminer();
    });
  }

  void _annoncer(String texte) => setState(() {
        _annonce = texte;
        _cleAnnonce++;
      });

  void _toucherLatin(int i) {
    if (_partie.trouvees.contains(i)) return;
    HapticFeedback.selectionClick();
    setState(() => _latinChoisi = _latinChoisi == i ? null : i);
  }

  void _toucherFrancais(int position) {
    final latin = _latinChoisi;
    if (latin == null || _partie.trouvees.contains(_partie.ordreFrancais[position])) return;
    final mancheAvant = _partie.manche;
    final juste = _partie.relier(latin, position);
    if (juste) {
      AudioService().playCorrect();
      annoncerAuLecteur(context, context.l10n.a11yCorrect);
      RomanParticlesOverlay.show(context, type: ParticleType.marbleSparks, duration: const Duration(milliseconds: 700));
      setState(() {
        _latinChoisi = null;
        _serie++;
      });
      if (_partie.estGagnee) {
        _terminer();
      } else if (_partie.manche != mancheAvant) {
        AudioService().playCardFlip();
        _annoncer(context.l10n.pairsRound(_partie.manche + 1, PartiePaires.nbManches));
      } else if (_serie % _serieCeleriter == 0) {
        _annoncer(context.l10n.pairsCeleriter);
      }
      return;
    }
    // Erreur : trois secondes de moins, et la paire fausse clignote en rouge.
    AudioService().playError();
    HapticFeedback.mediumImpact();
    annoncerAuLecteur(context, context.l10n.a11yWrong);
    setState(() {
      _secondesRestantes = (_secondesRestantes - PartiePaires.penaliteSecondes).clamp(0, PartiePaires.dureeSecondes);
      _erreur = (latin, position);
      _latinChoisi = null;
      _serie = 0;
    });
    if (_secondesRestantes <= 0) {
      _terminer();
      return;
    }
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) setState(() => _erreur = null);
    });
  }

  void _terminer() {
    _chrono?.cancel();
    if (_etape == _Etape.fin) return;
    if (_partie.estGagnee) {
      _gain = widget.repo.payerPartie('paires', GameRepository.gainPaires);
      _nouveauRecord = widget.repo.enregistrerRecord('paires', _secondesRestantes);
      // Victoire payée : pluie de pièces (elle joue aussi la fanfare).
      if (_gain > 0) {
        RomanLottieEffects.showCoinShower(context);
      } else {
        AudioService().playTriumph();
        RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
      }
    } else {
      AudioService().playError();
    }
    setState(() {
      _etape = _Etape.fin;
      _annonce = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: FittedBox(fit: BoxFit.scaleDown, child: Text(context.l10n.pairsTitle))),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fond très pâle : il habille sans gêner la lecture des cartes.
          Image.asset('assets/images/paires/fond_olympe.webp', fit: BoxFit.cover),
          // Dans la pile, la colonne recevrait toute la hauteur et centrerait
          // son contenu : on la cale en haut de l'écran.
          Align(
            alignment: Alignment.topCenter,
            child: ColonneLecture(
              largeurMax: 760,
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: switch (_etape) {
                    _Etape.regles => _regles(),
                    _Etape.enJeu => _jeu(),
                    _Etape.fin => _fin(),
                  },
                ),
              ),
            ),
          ),
          if (_annonce != null)
            IgnorePointer(child: _Annonce(key: ValueKey(_cleAnnonce), texte: _annonce!)),
        ],
      ),
    );
  }

  Widget _regles() {
    final record = widget.repo.record('paires');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              'assets/images/paires/banniere_mercure_anime.webp',
              fit: BoxFit.cover,
              // L'image fixe reste en secours si l'animation ne se charge pas.
              errorBuilder: (_, __, ___) =>
                  Image.asset('assets/images/paires/banniere_mercure.webp', fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _partie.estJouable ? context.l10n.pairsRules : context.l10n.pairsNoWords,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, height: 1.4),
        ),
        if (record > 0) ...[
          const SizedBox(height: 10),
          Text(
            context.l10n.pairsRecord(record),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: RomanColors.goldDark),
          ),
        ],
        const SizedBox(height: 24),
        if (_partie.estJouable) _boutonPrincipal(context.l10n.pairsStart),
      ],
    );
  }

  Widget _boutonPrincipal(String texte) => FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: RomanColors.imperialPurple,
          minimumSize: const Size.fromHeight(52),
        ),
        onPressed: _commencer,
        child: Text(texte, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
      );

  Widget _jeu() {
    final urgence = _secondesRestantes <= 10;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.pairsRound(_partie.manche + 1, PartiePaires.nbManches),
                style: const TextStyle(fontWeight: FontWeight.bold, color: RomanColors.imperialPurple),
              ),
            ),
            Text(
              '$_secondesRestantes s',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: urgence ? RomanColors.terracotta : RomanColors.charcoal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Les dix dernières secondes, la barre épaissit une seconde sur deux :
        // elle pulse au rythme du chrono, sans animation à entretenir.
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: urgence && _secondesRestantes.isEven ? 14 : 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: _secondesRestantes / PartiePaires.dureeSecondes,
              minHeight: 14,
              backgroundColor: RomanColors.marbleBorder,
              color: urgence ? RomanColors.terracotta : RomanColors.imperialGold,
            ),
          ),
        ),
        const SizedBox(height: 18),
        for (var ligne = 0; ligne < PartiePaires.pairesParManche; ligne++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(child: _carteLatin(ligne)),
                const SizedBox(width: 12),
                Expanded(child: _carteFrancais(ligne)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _carteLatin(int i) {
    final trouvee = _partie.trouvees.contains(i);
    return _Carte(
      texte: _partie.latin(i),
      latin: true,
      etat: trouvee
          ? _EtatCarte.trouvee
          : _erreur?.$1 == i
              ? _EtatCarte.erreur
              : _latinChoisi == i
                  ? _EtatCarte.choisie
                  : _EtatCarte.libre,
      onTap: () => _toucherLatin(i),
    );
  }

  Widget _carteFrancais(int position) {
    final trouvee = _partie.trouvees.contains(_partie.ordreFrancais[position]);
    return _Carte(
      texte: _partie.francais(_partie.ordreFrancais[position]),
      latin: false,
      etat: trouvee
          ? _EtatCarte.trouvee
          : _erreur?.$2 == position
              ? _EtatCarte.erreur
              : _EtatCarte.libre,
      onTap: () => _toucherFrancais(position),
    );
  }

  Widget _fin() {
    final gagne = _partie.estGagnee;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Animations sur fond transparent : elles se posent sur le fond doré.
        Image.asset(
          lupulusAnimation(gagne ? LupulusMood.triomphe : LupulusMood.encouragement),
          height: 140,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 12),
        Text(
          gagne
              ? context.l10n.pairsWin(_secondesRestantes)
              : context.l10n.pairsLose(_partie.pairesTrouvees, PartiePaires.totalPaires),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: RomanColors.imperialPurple),
        ),
        if (gagne) ...[
          const SizedBox(height: 10),
          Text(
            _gain > 0 ? context.l10n.bataReward(_gain) : context.l10n.jeuxPourLaGloire,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: RomanColors.goldDark, fontWeight: FontWeight.bold),
          ),
          if (_nouveauRecord) ...[
            const SizedBox(height: 6),
            Text(context.l10n.pairsNewRecord,
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: RomanColors.laurelGreen)),
          ],
        ],
        const SizedBox(height: 20),
        _boutonPrincipal(context.l10n.pairsReplay),
        const SizedBox(height: 22),
        _rappel(),
      ],
    );
  }

  /// Les mots joués, les ratés en premier : la partie finit sur une révision.
  Widget _rappel() {
    final mots = _partie.motsAReviser;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: RomanColors.travertinWhite.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: RomanColors.marbleBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.pairsReview,
              style: const TextStyle(fontWeight: FontWeight.bold, color: RomanColors.imperialPurple)),
          const SizedBox(height: 8),
          for (final e in mots)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Raté : à revoir ; trouvé : coché ; pas atteint avant la fin
                  // du temps : simple puce, pour ne pas cocher un mot non relié.
                  Icon(
                    _partie.ratees.contains(e)
                        ? Icons.replay
                        : _partie.reussies.contains(e)
                            ? Icons.check
                            : Icons.circle_outlined,
                    size: 18,
                    color: _partie.ratees.contains(e)
                        ? RomanColors.terracotta
                        : _partie.reussies.contains(e)
                            ? RomanColors.laurelGreen
                            : _gris,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                        text: VocabQuestion.shortLatin(e),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: RomanColors.imperialPurple),
                      ),
                      TextSpan(text: '  ${VocabQuestion.shortFrench(e)}'),
                    ])),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Message bref au centre de l'écran : éclair blanc qui s'efface, texte doré
/// qui grossit puis disparaît en un peu moins d'une seconde.
class _Annonce extends StatelessWidget {
  final String texte;

  const _Annonce({super.key, required this.texte});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      builder: (context, t, _) {
        final opacite = t < 0.7 ? 1.0 : (1 - t) / 0.3;
        return Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: Colors.white.withValues(alpha: (0.55 * (1 - t * 3)).clamp(0.0, 0.55))),
            Center(
              child: Opacity(
                opacity: opacite.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: 0.8 + 0.3 * Curves.easeOutBack.transform(t.clamp(0.0, 0.5) * 2),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                    decoration: BoxDecoration(
                      color: RomanColors.imperialPurple,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: RomanColors.imperialGold, width: 2),
                    ),
                    child: Text(
                      texte,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: RomanColors.goldLight,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

enum _EtatCarte { libre, choisie, trouvee, erreur }

/// Une carte à toucher. Le mot latin est une tablette de cire (cadre de bois,
/// cire miel), la traduction un papyrus clair : on voit d'un coup d'œil de
/// quel côté on est. Hauteur minimale de 60 points : on joue vite, au pouce,
/// bien au-dessus des 48 recommandés.
class _Carte extends StatelessWidget {
  final String texte;
  final bool latin;
  final _EtatCarte etat;
  final VoidCallback onTap;

  const _Carte({required this.texte, required this.latin, required this.etat, required this.onTap});

  static const _cireClaire = Color(0xFFF6E2AE);
  static const _cireFoncee = Color(0xFFE9C878);
  static const _bois = Color(0xFF7A4E2A);
  static const _papyrus = Color(0xFFFBF3DC);
  static const _papyrusBord = Color(0xFFCDB88E);

  @override
  Widget build(BuildContext context) {
    final List<Color> fond = switch (etat) {
      _EtatCarte.trouvee => [RomanColors.laurelLight, RomanColors.laurelLight],
      _EtatCarte.erreur => [const Color(0xFFFBE4E0), const Color(0xFFFBE4E0)],
      _ when latin => [_cireClaire, _cireFoncee],
      _ => [_papyrus, _papyrus],
    };
    final bord = switch (etat) {
      _EtatCarte.choisie => RomanColors.imperialGold,
      _EtatCarte.trouvee => RomanColors.laurelGreen,
      _EtatCarte.erreur => RomanColors.terracotta,
      _EtatCarte.libre => latin ? _bois : _papyrusBord,
    };
    return Semantics(
      button: true,
      selected: etat == _EtatCarte.choisie,
      enabled: etat != _EtatCarte.trouvee,
      child: AnimatedScale(
        scale: etat == _EtatCarte.choisie ? 1.04 : 1,
        duration: const Duration(milliseconds: 120),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: etat == _EtatCarte.trouvee ? null : onTap,
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: fond, begin: Alignment.topCenter, end: Alignment.bottomCenter),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: bord, width: latin || etat != _EtatCarte.libre ? 3 : 1.5),
                boxShadow: [
                  if (etat == _EtatCarte.choisie)
                    const BoxShadow(color: Color(0x88D4AF37), blurRadius: 12, spreadRadius: 1)
                  else
                    const BoxShadow(color: Color(0x22000000), offset: Offset(0, 2), blurRadius: 4),
                ],
              ),
              child: Container(
                constraints: const BoxConstraints(minHeight: 60),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  texte,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: latin ? FontWeight.bold : FontWeight.w500,
                    fontStyle: latin ? FontStyle.italic : FontStyle.normal,
                    color: etat == _EtatCarte.trouvee
                        ? RomanColors.laurelGreen
                        : latin
                            ? const Color(0xFF4A2C14)
                            : RomanColors.charcoal,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
