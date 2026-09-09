import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/particles_overlay.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';

/// La Taverne des Dés Romains (« Alea Iacta Est ») — Mini-jeu antique tactile.
class TaverneScreen extends StatefulWidget {
  final GameRepository repo;

  const TaverneScreen({super.key, required this.repo});

  @override
  State<TaverneScreen> createState() => _TaverneScreenState();
}

class _TaverneScreenState extends State<TaverneScreen> with SingleTickerProviderStateMixin {
  late AnimationController _rollController;

  List<int> _diceValues = [1, 2, 3, 4];
  List<int> _gaiusDiceValues = [3, 4, 5, 6];
  bool _isRolling = false;
  bool _modeDuelGaius = false;
  int _miseDuel = 10;
  String? _gaiusReplique;
  String _resultTitle = 'Lance le cornet (Fritillus)';
  String _resultDesc = 'Tente le Coup de Vénus (Iactus Venereus) pour remporter 50 HS !';
  int _lastGain = 0;

  final Map<int, String> _romanDice = {
    1: 'I',
    2: 'II',
    3: 'III',
    4: 'IV',
    5: 'V',
    6: 'VI',
  };

  @override
  void initState() {
    super.initState();
    _rollController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _rollController.dispose();
    super.dispose();
  }

  void _rollDice() async {
    if (_isRolling) return;

    if (_modeDuelGaius) {
      if (widget.repo.profile.sesterces < _miseDuel) {
        AudioService().playError();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Sesterces insuffisants pour défier Gaius ! Gagne des HS en leçon !'),
          ),
        );
        return;
      }
      widget.repo.addSesterces(-_miseDuel);
    }

    HapticFeedback.heavyImpact();
    AudioService().playDiceRoll();
    setState(() {
      _isRolling = true;
      _gaiusReplique = null;
    });

    _rollController.forward(from: 0.0);

    // Simulation de secousse
    for (int i = 0; i < 5; i++) {
      await Future.delayed(const Duration(milliseconds: 80));
      HapticFeedback.lightImpact();
      if (mounted) {
        setState(() {
          _diceValues = List.generate(4, (_) => math.Random().nextInt(6) + 1);
          if (_modeDuelGaius) {
            _gaiusDiceValues = List.generate(4, (_) => math.Random().nextInt(6) + 1);
          }
        });
      }
    }

    _evaluateResult();

    if (mounted) {
      setState(() {
        _isRolling = false;
      });
    }
  }

  int _scoreCombo(List<int> dice) {
    final counts = <int, int>{};
    for (var d in dice) {
      counts[d] = (counts[d] ?? 0) + 1;
    }
    if (counts.keys.length == 4) return 1000 + dice.reduce((a, b) => a + b); // Venereus
    if (counts.values.any((c) => c >= 4)) return 800; // Carré
    if (counts.values.any((c) => c == 3)) return 600; // Brelan
    if (counts.values.any((c) => c == 2)) return 400 + dice.reduce((a, b) => a + b); // Paire
    return dice.reduce((a, b) => a + b);
  }

  void _evaluateResult() {
    if (_modeDuelGaius) {
      final playerScore = _scoreCombo(_diceValues);
      final gaiusScore = _scoreCombo(_gaiusDiceValues);

      if (playerScore > gaiusScore) {
        final gain = _miseDuel * 2;
        widget.repo.addSesterces(gain);
        AudioService().playTriumph();
        RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
        setState(() {
          _lastGain = gain;
          _resultTitle = '🏆 Victoire contre Gaius l\'Aubergiste !';
          _resultDesc = 'Tu bats le tavernier sur le marbre ! Gain : +$gain HS !';
          _gaiusReplique = '« Par Bacchus, quelle chance insolente ! Tiens ta bourse ! »';
        });
      } else if (playerScore < gaiusScore) {
        AudioService().playError();
        HapticFeedback.vibrate();
        setState(() {
          _lastGain = 0;
          _resultTitle = '❌ Gaius remporte la manche !';
          _resultDesc = 'Les dés de l\'aubergiste ont été plus forts cette fois-ci.';
          _gaiusReplique = '« Les dés de la taverne ne mentent jamais ! Merci pour le pourboire ! »';
        });
      } else {
        widget.repo.addSesterces(_miseDuel);
        AudioService().playSesterces();
        setState(() {
          _lastGain = _miseDuel;
          _resultTitle = '⚖️ Égalité parfaite !';
          _resultDesc = 'Vos figures sont de même valeur. Ta mise de $_miseDuel HS t\'est rendue.';
          _gaiusReplique = '« Bacchus partage la coupe ! On remet ça quand tu veux ! »';
        });
      }
      return;
    }

    final counts = <int, int>{};
    for (var d in _diceValues) {
      counts[d] = (counts[d] ?? 0) + 1;
    }

    int gain = 5;
    String title = 'Iactus Communis (Lancer classique)';
    String desc = 'Tes dés retombent sur le comptoir en marbre. +5 HS remportés !';

    // Iactus Canis : 4 As (1-1-1-1)
    if (counts[1] == 4) {
      title = 'Iactus Canis (Coup du Chien) !';
      desc = 'Quatre As ! Le coup le plus redouté des tavernes romaines.';
      gain = 0;
      AudioService().playError();
      _showDogChallenge();
    }
    // Iactus Venereus : 4 faces distinctes
    else if (counts.keys.length == 4) {
      title = '👑 IACTUS VENEREUS (Coup de Vénus) !';
      desc = 'Quatre faces toutes différentes ! La déesse Vénus te sourit : +50 HS et Protection de Série !';
      gain = 50;
      HapticFeedback.heavyImpact();
      AudioService().playTriumph();
      RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
    }
    // Senatus : Carré ou Brelan (4 ou 3 identiques)
    else if (counts.values.any((c) => c >= 3)) {
      title = '🏛️ Iactus Senatus (Brelan Romain) !';
      desc = 'Trois dés identiques ! Les sénateurs applaudissent : +30 HS !';
      gain = 30;
      HapticFeedback.mediumImpact();
      AudioService().playSesterces();
      RomanParticlesOverlay.show(context, type: ParticleType.marbleSparks);
    }
    // Plebeius : Au moins une paire
    else if (counts.values.any((c) => c == 2)) {
      title = '🛡️ Iactus Plebeius (Paire Romaine)';
      desc = 'Une paire de dés identiques. +15 HS remportés !';
      gain = 15;
      AudioService().playSesterces();
    } else {
      AudioService().playSesterces();
    }

    if (gain > 0) {
      widget.repo.addSesterces(gain);
    }

    setState(() {
      _lastGain = gain;
      _resultTitle = title;
      _resultDesc = desc;
    });
  }

  void _showDogChallenge() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🐕 Défi de Mercure (Rachat)'),
        content: const Text(
          'Tu as obtenu le Coup du Chien ! Pour sauver ton honneur et doubler la mise, que signifie la formule de César : « Alea iacta est » ?',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              AudioService().playTriumph();
              RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
              widget.repo.addSesterces(20);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: RomanColors.laurelGreen,
                  content: Text('✓ Bonne réponse : "Le sort en est jeté !" +20 HS de rachat !'),
                ),
              );
            },
            child: const Text('« Le sort en est jeté »'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              AudioService().playError();
            },
            child: const Text('« Rome vaincra »'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.repo,
      builder: (context, _) {
        final profile = widget.repo.profile;

        return Scaffold(
          appBar: AppBar(
            title: const Text('TAVERNE DES DÉS'),
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
                      '${profile.sesterces} HS',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF7A5901)),
                    ),
                  ],
                ),
              ),
            ],
          ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Bannière d'Ambiance de la Taberna
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A180E), Color(0xFF260A04)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33331005),
                    offset: Offset(0, 6),
                    blurRadius: 12,
                  )
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Alea Iacta Est',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontFamily: 'serif',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '« Le sort en est jeté » • Comptoir des 4 Tesserae',
                    style: TextStyle(fontSize: 12, color: Color(0xFFE2C4A2)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Secoue le cornet en cuir (fritillus) et lance les dés en os gravés. Aligne des faces distinctes pour obtenir le fabuleux Coup de Vénus !',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.85), height: 1.4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Sélecteur de Mode : Solo Quotidien vs Duel de Comptoir contre Gaius
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _modeDuelGaius = false;
                        _gaiusReplique = null;
                      });
                      AudioService().playWheelClick();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_modeDuelGaius ? RomanColors.imperialPurple : Colors.white,
                      foregroundColor: !_modeDuelGaius ? Colors.white : RomanColors.imperialPurple,
                      side: BorderSide(color: RomanColors.imperialPurple),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      elevation: !_modeDuelGaius ? 3 : 0,
                    ),
                    child: const Text('🎲 Solo Quotidien', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _modeDuelGaius = true;
                      });
                      AudioService().playWheelClick();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _modeDuelGaius ? RomanColors.imperialPurple : Colors.white,
                      foregroundColor: _modeDuelGaius ? Colors.white : RomanColors.imperialPurple,
                      side: BorderSide(color: RomanColors.imperialPurple),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      elevation: _modeDuelGaius ? 3 : 0,
                    ),
                    child: const Text('🧔 Défier Gaius', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              ],
            ),

            if (_modeDuelGaius) ...[
              const SizedBox(height: 12),
              // Sélecteur de mise
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Mise : ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: RomanColors.imperialPurple)),
                  ...[5, 10, 25].map((mise) {
                    final isSel = (_miseDuel == mise);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text('$mise HS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: isSel ? Colors.white : RomanColors.imperialPurple)),
                        selected: isSel,
                        selectedColor: RomanColors.imperialPurple,
                        backgroundColor: RomanColors.goldLight,
                        onSelected: (val) {
                          if (val) {
                            setState(() { _miseDuel = mise; });
                            AudioService().playWheelClick();
                          }
                        },
                      ),
                    );
                  }),
                ],
              ),
              if (_gaiusReplique != null)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3E1F16),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: RomanColors.imperialGold),
                  ),
                  child: Text(
                    '🧔 Gaius : $_gaiusReplique',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.amberAccent, fontStyle: FontStyle.italic, fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                ),
            ],

            const SizedBox(height: 16),

            // 2. Plateau en Marbre des 4 Dés Romains
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: RomanColors.imperialGold, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x18000000),
                    offset: Offset(0, 8),
                    blurRadius: 18,
                  )
                ],
              ),
              child: Column(
                children: [
                  if (_modeDuelGaius) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('🧔 DÉS DE GAIUS L\'AUBERGISTE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54)),
                        Text('FACTION TABERNA', style: TextStyle(fontSize: 9, color: Colors.orange, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return _build3DRomanDie(_gaiusDiceValues[index], isGaius: true);
                      }),
                    ),
                    const Divider(height: 24, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('🛡️ TES DÉS (TIRO)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: RomanColors.imperialPurple)),
                        Text('TON CORNET', style: TextStyle(fontSize: 9, color: RomanColors.laurelGreen, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return _build3DRomanDie(_diceValues[index]);
                    }),
                  ),
                  const SizedBox(height: 20),
                  // Bouton Lancer
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RomanColors.imperialGold,
                      foregroundColor: const Color(0xFF1E1408),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Color(0xFFE2B842), width: 1.5),
                      ),
                      elevation: 4,
                    ),
                    icon: Icon(_isRolling ? Icons.refresh : Icons.casino_outlined, size: 22),
                    label: Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _isRolling
                              ? 'ROULEMENT DES DÉS...'
                              : (_modeDuelGaius ? 'LANCER CONTRE GAIUS ($_miseDuel HS)' : 'SECOUER LE FRITILLUS (GRATUIT)'),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, letterSpacing: 0.8),
                        ),
                      ),
                    ),
                    onPressed: _isRolling ? null : _rollDice,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. Carte de Résultat
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: RomanColors.palatinCream,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: RomanColors.marbleBorder, width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _resultTitle,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: RomanColors.imperialPurple,
                            fontFamily: 'serif',
                          ),
                        ),
                      ),
                      if (_lastGain > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: RomanColors.laurelGreen,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '+$_lastGain HS',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _resultDesc,
                    style: const TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.35),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4. Barème des Combinaisons Antiques
            const Text(
              'Règles des Dés Romains (Tesserae)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: RomanColors.imperialPurple,
              ),
            ),
            const SizedBox(height: 8),
            _buildRuleRow('👑 Coup de Vénus', '4 faces distinctes (ex: VI-V-III-I)', '+50 HS & Bouclier'),
            _buildRuleRow('🏛️ Sénat (Brelan)', '3 dés de valeur identique', '+30 HS'),
            _buildRuleRow('🛡️ Plébéien (Paire)', '2 dés de valeur identique', '+15 HS'),
            _buildRuleRow('🐕 Coup du Chien', 'Quatre As (I-I-I-I)', 'Défi de Mercure'),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _build3DRomanDie(int val, {bool isGaius = false}) {
    return Container(
      width: isGaius ? 52 : 60,
      height: isGaius ? 52 : 60,
      decoration: BoxDecoration(
        color: isGaius ? const Color(0xFF5C3317) : const Color(0xFFFBF8EE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isGaius ? const Color(0xFF8B5A2B) : const Color(0xFFC59B27),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(0, 4),
            blurRadius: 6,
          ),
          BoxShadow(
            color: Color(0x22FFFFFF),
            offset: Offset(0, -2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          _romanDice[val] ?? '',
          style: TextStyle(
            fontSize: isGaius ? 18 : 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
            color: isGaius ? const Color(0xFFFFE4C4) : RomanColors.imperialPurple,
          ),
        ),
      ),
    );
  }

  Widget _buildRuleRow(String combo, String detail, String gain) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(combo, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: RomanColors.charcoal)),
          Expanded(
            child: Text(
              ' • $detail',
              style: const TextStyle(fontSize: 11, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(gain, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: RomanColors.laurelGreen)),
        ],
      ),
    );
  }
}