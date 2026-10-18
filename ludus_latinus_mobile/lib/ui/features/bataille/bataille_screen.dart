import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/models/album.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import '../../../l10n/l10n.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../album/album_screen.dart';
import 'bataille_logique.dart';

/// Bataille des Légendes : les cartes de l'album contre celles de Crassus.
class BatailleScreen extends StatefulWidget {
  final GameRepository repo;
  const BatailleScreen({super.key, required this.repo});

  @override
  State<BatailleScreen> createState() => _BatailleScreenState();
}

enum _Etape { choixMain, poseCarte, question, choixCaracteristique, resultat, fin }

class _BatailleScreenState extends State<BatailleScreen> {
  final Random _alea = Random();
  _Etape _etape = _Etape.choixMain;

  /// Cartes choisies pour la main (identifiants), et cartes prêtées par Crassus.
  final Set<String> _choisies = {};
  List<CarteAlbum> _pretees = const [];

  PartieBataille? _partie;
  CarteAlbum? _carteJoueur;
  CarteAlbum? _carteCrassus;
  QuestionBataille? _question;
  String? _reponseDonnee;
  Caracteristique? _caracteristique;
  int _resultatManche = 0;
  int _gain = 0;

  List<CarteAlbum> get _possedees => [
        for (final id in widget.repo.profile.cartesAlbum)
          if (widget.repo.carteAlbum(id) != null) widget.repo.carteAlbum(id)!,
      ];

  @override
  void initState() {
    super.initState();
    _preparerMain();
  }

  /// Avec 5 cartes ou moins, la main est toute faite (complétée par des prêts) ;
  /// au-delà, l'élève choisit, les 5 plus fortes étant proposées d'office.
  void _preparerMain() {
    final possedees = _possedees;
    _pretees = cartesDePret(possedees, widget.repo.cartesAlbum, _alea);
    final fortes = List.of(possedees)
      ..sort((a, b) => (b.attaque + b.defense).compareTo(a.attaque + a.defense));
    _choisies
      ..clear()
      ..addAll(fortes.take(tailleMain).map((c) => c.id));
  }

  void _commencer() {
    final main = [
      for (final c in _possedees)
        if (_choisies.contains(c.id)) c,
      ..._pretees,
    ];
    setState(() {
      _partie = PartieBataille(
        mainJoueur: main,
        mainCrassus: mainDeCrassus(main, widget.repo.cartesAlbum, _alea),
        pretees: _pretees.map((c) => c.id).toSet(),
      );
      _carteJoueur = null;
      _carteCrassus = null;
      _gain = 0;
      _etape = _Etape.poseCarte;
    });
    AudioService().playCardFlip();
  }

  void _poser(CarteAlbum carte) {
    if (_etape != _Etape.poseCarte) return;
    final partie = _partie!;
    HapticFeedback.selectionClick();
    AudioService().playCardFlip();
    setState(() {
      _carteJoueur = carte;
      _carteCrassus = partie.carteDeCrassus(_alea);
      _question = questionPour(carte, widget.repo.cartesAlbum, widget.repo.vocabulaireAtteint, _alea);
      _reponseDonnee = null;
      _caracteristique = null;
      _etape = _Etape.question;
    });
  }

  void _repondre(String reponse) {
    if (_etape != _Etape.question) return;
    final juste = reponse == _question!.bonne;
    setState(() => _reponseDonnee = reponse);
    if (juste) {
      AudioService().playCorrect();
      setState(() => _etape = _Etape.choixCaracteristique);
    } else {
      AudioService().playError();
      HapticFeedback.vibrate();
      _jouerManche(choixDeCrassus(_carteJoueur!, _carteCrassus!));
    }
  }

  void _jouerManche(Caracteristique c) {
    final resultat = _partie!.jouer(_carteJoueur!, _carteCrassus!, c);
    setState(() {
      _caracteristique = c;
      _resultatManche = resultat;
      _etape = _Etape.resultat;
    });
    if (resultat > 0) AudioService().playSwordClash();
  }

  void _suite() {
    final partie = _partie!;
    if (!partie.finie) {
      setState(() {
        _carteJoueur = null;
        _carteCrassus = null;
        _etape = _Etape.poseCarte;
      });
      return;
    }
    final victoire = partie.issue == IssuePartie.victoire;
    final gain = widget.repo.noterBataille(victoire: victoire);
    if (victoire) {
      AudioService().playTriumph();
      HapticFeedback.heavyImpact();
    }
    setState(() {
      _gain = gain;
      _etape = _Etape.fin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.bataTitle)),
      body: ColonneLecture(
        largeurMax: 560,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _etape == _Etape.choixMain ? _choixDeLaMain(context) : _table(context),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- choix de la main

  Widget _choixDeLaMain(BuildContext context) {
    final possedees = _possedees;
    final pret = _choisies.length + _pretees.length >= tailleMain;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Bandeau(titre: context.l10n.bataCrassus, texte: context.l10n.bataIntro),
        const SizedBox(height: 10),
        Text(context.l10n.bataRules, style: const TextStyle(fontSize: 14, height: 1.4)),
        const SizedBox(height: 16),
        Text(
          possedees.length > tailleMain ? context.l10n.bataChooseHand : context.l10n.bataHand,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: RomanColors.imperialPurple),
        ),
        if (possedees.length > tailleMain)
          Text(context.l10n.bataChosen(_choisies.length), style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final c in possedees)
              _CarteJeu(
                carte: c,
                largeur: 92,
                selectionnee: _choisies.contains(c.id),
                onTap: possedees.length <= tailleMain
                    ? null
                    : () => setState(() {
                          if (_choisies.contains(c.id)) {
                            _choisies.remove(c.id);
                          } else if (_choisies.length < tailleMain) {
                            _choisies.add(c.id);
                          }
                        }),
              ),
            for (final c in _pretees) _CarteJeu(carte: c, largeur: 92, pretee: true),
          ],
        ),
        if (_pretees.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(context.l10n.bataLoanInfo, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        ],
        const SizedBox(height: 18),
        RomanButton(text: context.l10n.bataStart, isLarge: true, onPressed: pret ? _commencer : null),
      ],
    );
  }

  // ---------------------------------------------------------------- table de jeu

  Widget _table(BuildContext context) {
    final partie = _partie!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: RomanColors.imperialPurple, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Text('${context.l10n.bataYou} ${partie.pointsJoueur}',
                  style: const TextStyle(color: RomanColors.goldLight, fontWeight: FontWeight.bold)),
              Expanded(
                // Pendant le résultat, la manche jouée est déjà comptée : on garde
                // son numéro jusqu'à « Manche suivante ».
                child: Text(
                    context.l10n.bataRound(min(
                        _etape == _Etape.resultat || _etape == _Etape.fin ? partie.manche : partie.manche + 1, 5)),
                    textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ),
              Text('${context.l10n.bataCrassus} ${partie.pointsCrassus}',
                  style: const TextStyle(color: RomanColors.goldLight, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _emplacement(context, _carteJoueur, context.l10n.bataYou, cachee: false),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('VS', style: TextStyle(fontFamily: 'serif', color: RomanColors.imperialGold, fontSize: 18)),
            ),
            _emplacement(context, _carteCrassus, context.l10n.bataCrassus,
                cachee: _etape == _Etape.question || _etape == _Etape.choixCaracteristique),
          ],
        ),
        const SizedBox(height: 12),
        _milieu(context),
        if (_etape != _Etape.fin) ...[
          const SizedBox(height: 14),
          Text(context.l10n.bataHand, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              // La carte posée quitte la main dès qu'elle est sur la table.
              for (final c in partie.mainJoueur.where((c) => c != _carteJoueur))
                _CarteJeu(
                  carte: c,
                  largeur: 64,
                  pretee: partie.pretees.contains(c.id),
                  onTap: _etape == _Etape.poseCarte ? () => _poser(c) : null,
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _emplacement(BuildContext context, CarteAlbum? carte, String libelle, {required bool cachee}) {
    return Column(
      children: [
        if (carte == null)
          Container(
            width: 120,
            height: 190,
            decoration: BoxDecoration(
              color: RomanColors.palatinCream,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: RomanColors.marbleBorder, width: 1.5),
            ),
          )
        else
          _CarteJeu(carte: carte, largeur: 120, cachee: cachee, pretee: _partie!.pretees.contains(carte.id)),
        const SizedBox(height: 4),
        Text(libelle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }

  Widget _milieu(BuildContext context) {
    switch (_etape) {
      case _Etape.choixMain:
      case _Etape.poseCarte:
        return _Message(texte: context.l10n.bataPlayCard);
      case _Etape.question:
        final q = _question!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Message(
              texte: q.estDevise ? context.l10n.bataQuestionMotto(q.latin) : context.l10n.bataQuestionWord(q.latin),
            ),
            const SizedBox(height: 8),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // Hauteur des cases : trois lignes de texte (les devises sont longues)
              // à la taille de police de l'élève, plus les marges. À 64 fixes,
              // la 3e ligne d'une devise était coupée.
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 24 + MediaQuery.textScalerOf(context).scale(13) * 3 * 1.3,
              ),
              children: [for (final r in q.reponses) _Choix(texte: r, onTap: () => _repondre(r))],
            ),
          ],
        );
      case _Etape.choixCaracteristique:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Message(texte: context.l10n.bataChooseStat, couleur: const Color(0xFFEAF3DE)),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final c in Caracteristique.values)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _Choix(
                        texte: '${_libelle(context, c)} ${valeur(_carteJoueur!, c)}',
                        icone: c == Caracteristique.attaque ? Icons.flash_on_rounded : Icons.shield_outlined,
                        onTap: () => _jouerManche(c),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      case _Etape.resultat:
        final c = _caracteristique!;
        final erreur = _reponseDonnee != _question!.bonne;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (erreur) _Message(texte: context.l10n.bataWrong(_question!.bonne), couleur: const Color(0xFFFCEBEB)),
            if (erreur) const SizedBox(height: 6),
            _Message(
              texte: '${_resultatManche > 0 ? context.l10n.bataRoundWon : _resultatManche < 0 ? context.l10n.bataRoundLost : context.l10n.bataRoundTie}\n'
                  '${context.l10n.bataDuel(_libelle(context, c), valeur(_carteJoueur!, c), valeur(_carteCrassus!, c))}',
              couleur: _resultatManche > 0 ? const Color(0xFFEAF3DE) : null,
            ),
            const SizedBox(height: 10),
            RomanButton(
              text: _partie!.finie ? context.l10n.bataSeeResult : context.l10n.bataNext,
              onPressed: _suite,
            ),
          ],
        );
      case _Etape.fin:
        final partie = _partie!;
        final issue = partie.issue;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Bandeau(
              titre: issue == IssuePartie.victoire
                  ? context.l10n.bataVictory
                  : issue == IssuePartie.defaite
                      ? context.l10n.bataDefeat
                      : context.l10n.bataDraw,
              texte: context.l10n.bataFinalScore(partie.pointsJoueur, partie.pointsCrassus),
            ),
            if (issue == IssuePartie.victoire) ...[
              const SizedBox(height: 8),
              Text(
                _gain > 0 ? context.l10n.bataReward(_gain) : context.l10n.bataNoReward,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7A5901)),
              ),
            ],
            const SizedBox(height: 14),
            RomanButton(
              text: context.l10n.bataAgain,
              onPressed: () => setState(() {
                _preparerMain();
                _etape = _Etape.choixMain;
              }),
            ),
            const SizedBox(height: 8),
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.l10n.bataBack)),
          ],
        );
    }
  }

  String _libelle(BuildContext context, Caracteristique c) =>
      c == Caracteristique.attaque ? context.l10n.albumAttack : context.l10n.albumDefense;
}

/// Une carte de jeu : illustration, nom, attaque et défense ; face cachée,
/// grisée « prêt », ou entourée quand elle est choisie.
class _CarteJeu extends StatelessWidget {
  final CarteAlbum carte;
  final double largeur;
  final bool cachee;
  final bool pretee;
  final bool selectionnee;
  final VoidCallback? onTap;

  const _CarteJeu({
    required this.carte,
    required this.largeur,
    this.cachee = false,
    this.pretee = false,
    this.selectionnee = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final petite = largeur < 80;
    final couleur = cachee ? RomanColors.imperialGold : couleurRarete(carte.rarete);
    final carteWidget = Container(
      width: largeur,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cachee ? RomanColors.imperialPurple : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: selectionnee ? RomanColors.imperialPurple : couleur, width: selectionnee ? 3 : 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: cachee
                  ? Image.asset('assets/images/dos_carte_collector.png', fit: BoxFit.cover)
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        ImageCarteAlbum(carte: carte, tailleIcone: petite ? 18 : 30),
                        // Carte choisie pour la main : coche bien visible, la bordure
                        // seule se confondait avec la couleur de rareté.
                        if (selectionnee)
                          const Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: RomanColors.imperialPurple,
                                child: Icon(Icons.check_rounded, size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        if (pretee)
                          Container(
                            color: Colors.white54,
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.only(top: 4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              color: Colors.black54,
                              child: Text(context.l10n.bataLoan,
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    ),
            ),
          ),
          if (!petite) ...[
            const SizedBox(height: 3),
            Text(
              cachee ? context.l10n.bataHidden : carte.nom,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: cachee ? RomanColors.goldLight : RomanColors.imperialPurple,
              ),
            ),
            if (!cachee)
              Text('${carte.attaque} · ${carte.defense}', style: const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ],
      ),
    );
    if (onTap == null) return carteWidget;
    return InkWell(borderRadius: BorderRadius.circular(10), onTap: onTap, child: carteWidget);
  }
}

class _Message extends StatelessWidget {
  final String texte;
  final Color? couleur;
  const _Message({required this.texte, this.couleur});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: couleur ?? const Color(0xFFFFF6DD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE3CF95)),
        ),
        child: Text(texte,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: RomanColors.imperialPurple, fontWeight: FontWeight.w600)),
      );
}

class _Choix extends StatelessWidget {
  final String texte;
  final IconData? icone;
  final VoidCallback onTap;
  const _Choix({required this.texte, required this.onTap, this.icone});

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: RomanColors.marbleBorder, width: 1.2),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icone != null) ...[Icon(icone, size: 18, color: RomanColors.imperialPurple), const SizedBox(width: 6)],
                Flexible(
                  child: Text(texte,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: RomanColors.imperialPurple)),
                ),
              ],
            ),
          ),
        ),
      );
}

class _Bandeau extends StatelessWidget {
  final String titre;
  final String texte;
  const _Bandeau({required this.titre, required this.texte});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: RomanColors.imperialPurple,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: RomanColors.imperialGold, width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titre,
                style: const TextStyle(color: RomanColors.goldLight, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'serif')),
            const SizedBox(height: 4),
            Text(texte, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.35)),
          ],
        ),
      );
}
