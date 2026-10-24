import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import '../../../l10n/l10n.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import 'paires_eclair.dart';

/// Écran de Paires éclair : deux colonnes (latin à gauche, traductions
/// mélangées à droite), un chrono d'une minute pour trois manches.
/// La règle du jeu est dans [PartiePaires].
class PairesScreen extends StatefulWidget {
  final GameRepository repo;

  const PairesScreen({super.key, required this.repo});

  @override
  State<PairesScreen> createState() => _PairesScreenState();
}

enum _Etape { regles, enJeu, fin }

class _PairesScreenState extends State<PairesScreen> {
  late PartiePaires _partie;
  _Etape _etape = _Etape.regles;
  Timer? _chrono;
  int _secondesRestantes = PartiePaires.dureeSecondes;

  /// Mot latin touché, en attente de sa traduction.
  int? _latinChoisi;

  /// Paire fausse affichée en rouge un court instant (latin, position française).
  (int, int)? _erreur;

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
      setState(() => _latinChoisi = null);
      if (_partie.estGagnee) {
        _terminer();
      } else if (_partie.manche != mancheAvant) {
        AudioService().playCardFlip();
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
      AudioService().playTriumph();
    } else {
      AudioService().playError();
    }
    setState(() => _etape = _Etape.fin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: FittedBox(fit: BoxFit.scaleDown, child: Text(context.l10n.pairsTitle))),
      body: ColonneLecture(
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
    );
  }

  Widget _regles() {
    final record = widget.repo.record('paires');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        const Icon(Icons.bolt, size: 56, color: RomanColors.goldDark),
        const SizedBox(height: 12),
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
    final fraction = _secondesRestantes / PartiePaires.dureeSecondes;
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
                color: _secondesRestantes <= 10 ? RomanColors.terracotta : RomanColors.charcoal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 10,
            backgroundColor: RomanColors.marbleBorder,
            color: _secondesRestantes <= 10 ? RomanColors.terracotta : RomanColors.imperialGold,
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
        const SizedBox(height: 12),
        Icon(gagne ? Icons.emoji_events : Icons.hourglass_bottom,
            size: 56, color: gagne ? RomanColors.goldDark : RomanColors.terracotta),
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
        const SizedBox(height: 24),
        _boutonPrincipal(context.l10n.pairsReplay),
      ],
    );
  }
}

enum _EtatCarte { libre, choisie, trouvee, erreur }

/// Une carte à toucher : mot latin ou traduction. Hauteur minimale de 60
/// points : on joue vite, au pouce, bien au-dessus des 48 recommandés.
class _Carte extends StatelessWidget {
  final String texte;
  final bool latin;
  final _EtatCarte etat;
  final VoidCallback onTap;

  const _Carte({required this.texte, required this.latin, required this.etat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final (fond, bord) = switch (etat) {
      _EtatCarte.libre => (RomanColors.cardSurface, RomanColors.marbleBorder),
      _EtatCarte.choisie => (RomanColors.goldLight, RomanColors.imperialGold),
      _EtatCarte.trouvee => (RomanColors.laurelLight, RomanColors.laurelGreen),
      _EtatCarte.erreur => (const Color(0xFFFBE4E0), RomanColors.terracotta),
    };
    return Semantics(
      button: true,
      selected: etat == _EtatCarte.choisie,
      enabled: etat != _EtatCarte.trouvee,
      child: Material(
        color: fond,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: etat == _EtatCarte.trouvee ? null : onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 60),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: bord, width: etat == _EtatCarte.libre ? 1.2 : 2),
            ),
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
                        ? RomanColors.imperialPurple
                        : RomanColors.charcoal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
