import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/particles_overlay.dart';
import '../../core/widgets.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';

/// Un nombre en chiffres romains (jusqu'à 39, assez pour les totaux du jeu).
String chiffreRomain(int n) {
  const valeurs = [10, 9, 5, 4, 1];
  const lettres = ['X', 'IX', 'V', 'IV', 'I'];
  var reste = n;
  final b = StringBuffer();
  for (var i = 0; i < valeurs.length; i++) {
    while (reste >= valeurs[i]) {
      b.write(lettres[i]);
      reste -= valeurs[i];
    }
  }
  return b.toString();
}

enum IssueManche { enCours, gagnee, perdue, egalite }

/// « Ad XXI » : le joueur lance des dés un par un et s'arrête quand il veut ;
/// le plus près de XXI gagne, au-dessus on perd. Les totaux ne s'affichent qu'en
/// chiffres romains : les lire, c'est jouer. Gaius relance tant qu'il a moins
/// de XVII. Logique séparée de l'écran pour être testée.
class PartieAdXXI {
  static const int cible = 21;
  static const int seuilGaius = 17;

  final math.Random _hasard;
  final List<int> desJoueur = [];
  final List<int> desGaius = [];
  bool joueurArrete = false;

  PartieAdXXI({math.Random? hasard}) : _hasard = hasard ?? math.Random() {
    desJoueur
      ..add(_de())
      ..add(_de());
  }

  int _de() => _hasard.nextInt(6) + 1;

  int get totalJoueur => desJoueur.fold(0, (a, b) => a + b);
  int get totalGaius => desGaius.fold(0, (a, b) => a + b);
  bool get joueurDepasse => totalJoueur > cible;

  /// Le joueur prend un dé de plus. S'il dépasse XXI, sa manche s'arrête.
  void encoreUnDe() {
    if (joueurArrete) return;
    desJoueur.add(_de());
    if (joueurDepasse) joueurArrete = true;
  }

  void arreter() => joueurArrete = true;

  /// Gaius joue un dé (s'il doit encore jouer). Vrai s'il a lancé.
  bool tourDeGaius() {
    if (!joueurArrete || joueurDepasse) return false;
    if (desGaius.length >= 2 && totalGaius >= seuilGaius) return false;
    desGaius.add(_de());
    return true;
  }

  IssueManche get issue {
    if (!joueurArrete) return IssueManche.enCours;
    if (joueurDepasse) return IssueManche.perdue;
    if (desGaius.length < 2 || totalGaius < seuilGaius) return IssueManche.enCours;
    if (totalGaius > cible || totalJoueur > totalGaius) return IssueManche.gagnee;
    if (totalJoueur < totalGaius) return IssueManche.perdue;
    return IssueManche.egalite;
  }
}

/// La Taverne des Dés : « Ad XXI » contre Gaius l'aubergiste.
class TaverneScreen extends StatefulWidget {
  final GameRepository repo;

  const TaverneScreen({super.key, required this.repo});

  @override
  State<TaverneScreen> createState() => _TaverneScreenState();
}

class _TaverneScreenState extends State<TaverneScreen> {
  static const int gainVictoire = 8;

  PartieAdXXI _partie = PartieAdXXI();
  bool _gaiusJoue = false;
  int _gainManche = 0;
  int _gainDefi = 0;
  final ScrollController _defilement = ScrollController();
  bool _mancheComptee = false;

  static const Map<int, String> _faces = {1: 'I', 2: 'II', 3: 'III', 4: 'IV', 5: 'V', 6: 'VI'};

  void _encoreUnDe() {
    HapticFeedback.lightImpact();
    AudioService().playDiceRoll();
    setState(() => _partie.encoreUnDe());
    if (_partie.joueurArrete) _finDeManche();
  }

  Future<void> _jeMArrete() async {
    HapticFeedback.selectionClick();
    setState(() {
      _partie.arreter();
      _gaiusJoue = true;
    });
    // Gaius lance ses dés un par un, pour qu'on suive son total.
    while (true) {
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      final aLance = _partie.tourDeGaius();
      if (!aLance) break;
      AudioService().playDiceRoll();
      setState(() {});
    }
    if (!mounted) return;
    setState(() => _gaiusJoue = false);
    _finDeManche();
  }

  void _finDeManche() {
    if (_mancheComptee) return;
    final issue = _partie.issue;
    if (issue == IssueManche.enCours) return;
    _mancheComptee = true;
    var gain = 0;
    var defi = 0;
    if (issue == IssueManche.gagnee) {
      if (widget.repo.taverneRewardsLeftToday > 0 && widget.repo.consumeTaverneReward()) {
        widget.repo.addSesterces(gainVictoire);
        gain = gainVictoire;
      }
      defi = widget.repo.accomplirDefi('taverne');
      HapticFeedback.heavyImpact();
      AudioService().playTriumph();
      RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
    } else if (issue == IssueManche.perdue) {
      HapticFeedback.mediumImpact();
      AudioService().playError();
    }
    setState(() {
      _gainManche = gain;
      _gainDefi = defi;
    });
    // Le résultat s'affiche sous la zone du joueur : on le fait venir à l'écran.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_defilement.hasClients) {
        _defilement.animateTo(
          _defilement.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _defilement.dispose();
    super.dispose();
  }

  void _nouvelleManche() {
    HapticFeedback.selectionClick();
    setState(() {
      _partie = PartieAdXXI();
      _gainManche = 0;
      _gainDefi = 0;
      _mancheComptee = false;
      _gaiusJoue = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.repo,
      builder: (context, _) {
        final issue = _partie.issue;
        final enCours = !_partie.joueurArrete;
        return Scaffold(
          appBar: AppBar(
            title: const FittedBox(fit: BoxFit.scaleDown, child: Text('TAVERNE DES DÉS')),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 14),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: RomanColors.goldLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: RomanColors.imperialGold),
                ),
                child: Text(
                  '🪙 ${widget.repo.profile.sesterces} HS',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF7A5901)),
                ),
              ),
            ],
          ),
          // Les deux boutons restent en bas de l'écran : ils ne bougent plus
          // quand les dés passent sur une deuxième rangée.
          bottomNavigationBar: enCours
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: _boutonsDeJeu(),
                  ),
                )
              : null,
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
            controller: _defilement,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _regles(),
                const SizedBox(height: 14),
                _zone(
                  titre: 'Gaius l\'aubergiste',
                  des: _partie.desGaius,
                  total: _partie.totalGaius,
                  gaius: true,
                  vide: enCours
                      ? 'Gaius attend que tu t\'arrêtes…'
                      : (_partie.joueurDepasse ? 'Tu as dépassé XXI : Gaius n\'a pas besoin de jouer.' : null),
                ),
                const SizedBox(height: 12),
                _zone(
                  titre: 'Toi',
                  des: _partie.desJoueur,
                  total: _partie.totalJoueur,
                  gaius: false,
                ),
                const SizedBox(height: 14),
                if (_gaiusJoue) _gaiusReflechit() else if (!enCours) _resultat(issue),
                const SizedBox(height: 14),
                Text(
                  widget.repo.taverneRewardsLeftToday > 0
                      ? 'Victoires payées aujourd\'hui : encore ${widget.repo.taverneRewardsLeftToday} sur 3 (+$gainVictoire HS chacune)'
                      : 'Tes 3 victoires payées du jour sont faites : tu peux jouer pour la gloire.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
            ),
          ),
        );
      },
    );
  }

  Widget _regles() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A180E), Color(0xFF260A04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: RomanColors.imperialGold, width: 1.5),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎲 AD XXI : approche-toi de 21 sans le dépasser',
            style: TextStyle(color: Color(0xFFFFE082), fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _Regle('1', 'Ajoute des dés un par un. Ton total s\'écrit en chiffres romains.'),
          _Regle('2', 'Arrête-toi quand tu veux. Au-dessus de XXI, tu as perdu.'),
          _Regle('3', 'Gaius joue ensuite : il relance tant qu\'il a moins de XVII. Le plus près de XXI gagne ; à égalité, personne ne gagne.'),
          SizedBox(height: 8),
          Text(
            'Aide : I = 1 · V = 5 · X = 10 · IV = 4 · IX = 9 · XXI = 21',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _zone({
    required String titre,
    required List<int> des,
    required int total,
    required bool gaius,
    String? vide,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: gaius ? const Color(0xFFF3E6D8) : RomanColors.palatinCream,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: gaius ? const Color(0xFF9E6534) : RomanColors.imperialGold, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titre,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: RomanColors.imperialPurple),
          ),
          const SizedBox(height: 8),
          if (des.isEmpty)
            Text(vide ?? '', style: const TextStyle(fontSize: 12.5, fontStyle: FontStyle.italic, color: Colors.black54))
          else ...[
            Wrap(spacing: 8, runSpacing: 8, children: [for (final d in des) _de(d, gaius: gaius)]),
            const SizedBox(height: 10),
            // Le total n'existe ici qu'en chiffres romains : le lire, c'est jouer.
            Text(
              'Total : ${chiffreRomain(total)}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'serif',
                letterSpacing: 1.2,
                color: total > PartieAdXXI.cible ? const Color(0xFFB71C1C) : RomanColors.imperialPurple,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _de(int valeur, {required bool gaius}) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gaius
              ? const [Color(0xFF7A4320), Color(0xFF4E260E)]
              : const [Color(0xFFFFFDF8), Color(0xFFE5D5B5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: gaius ? const Color(0xFF9E6534) : RomanColors.imperialGold, width: 2),
        boxShadow: const [BoxShadow(color: Color(0x33000000), offset: Offset(0, 3), blurRadius: 5)],
      ),
      child: Text(
        _faces[valeur] ?? '',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          fontFamily: 'serif',
          color: gaius ? const Color(0xFFFFE4C4) : RomanColors.imperialPurple,
        ),
      ),
    );
  }

  Widget _boutonsDeJeu() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _encoreUnDe,
            style: ElevatedButton.styleFrom(
              backgroundColor: RomanColors.imperialGold,
              foregroundColor: const Color(0xFF1E1408),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('🎲 Encore un dé', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: _jeMArrete,
            style: ElevatedButton.styleFrom(
              backgroundColor: RomanColors.imperialPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('✋ Je m\'arrête', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ),
      ],
    );
  }

  Widget _gaiusReflechit() {
    return const Text(
      'Gaius lance ses dés…',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: RomanColors.imperialPurple),
    );
  }

  Widget _resultat(IssueManche issue) {
    final p = _partie;
    final String titre;
    final String detail;
    final Color couleur;
    switch (issue) {
      case IssueManche.gagnee:
        titre = '🏆 Tu bats Gaius !';
        couleur = Colors.green.shade800;
        detail = p.totalGaius > PartieAdXXI.cible
            ? 'Gaius a dépassé XXI avec ${chiffreRomain(p.totalGaius)} (${p.totalGaius}).'
            : 'Ton ${chiffreRomain(p.totalJoueur)} (${p.totalJoueur}) bat son ${chiffreRomain(p.totalGaius)} (${p.totalGaius}).';
        break;
      case IssueManche.perdue:
        titre = p.joueurDepasse ? '💥 Trop loin !' : 'Gaius l\'emporte';
        couleur = const Color(0xFFB71C1C);
        detail = p.joueurDepasse
            ? '${chiffreRomain(p.totalJoueur)} (${p.totalJoueur}) dépasse XXI (21).'
            : 'Son ${chiffreRomain(p.totalGaius)} (${p.totalGaius}) bat ton ${chiffreRomain(p.totalJoueur)} (${p.totalJoueur}).';
        break;
      case IssueManche.egalite:
        titre = '⚖️ Égalité';
        couleur = RomanColors.imperialPurple;
        detail = 'Vous avez tous les deux ${chiffreRomain(p.totalJoueur)} (${p.totalJoueur}).';
        break;
      case IssueManche.enCours:
        return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: couleur, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(titre, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: couleur)),
          const SizedBox(height: 6),
          Text(detail, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13.5, height: 1.35)),
          if (_gainManche + _gainDefi > 0) ...[
            const SizedBox(height: 6),
            Text(
              [
                if (_gainManche > 0) '+$_gainManche HS pour la victoire',
                if (_gainDefi > 0) '+$_gainDefi HS pour le défi du jour',
              ].join('\n'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: RomanColors.laurelGreen),
            ),
          ],
          const SizedBox(height: 10),
          RomanButton(text: '🎲 NOUVELLE MANCHE', onPressed: _nouvelleManche),
        ],
      ),
    );
  }
}

class _Regle extends StatelessWidget {
  final String numero;
  final String texte;

  const _Regle(this.numero, this.texte);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$numero. ', style: const TextStyle(color: Color(0xFFFFE082), fontWeight: FontWeight.bold, fontSize: 13)),
          Expanded(child: Text(texte, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.3))),
        ],
      ),
    );
  }
}
