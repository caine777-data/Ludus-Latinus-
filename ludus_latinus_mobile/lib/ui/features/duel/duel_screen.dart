import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/particles_overlay.dart';
import '../../core/lottie_effects.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';

enum CombatStance {
  gravis(
    'Ictus Gravis',
    'Attaque Lourde',
    '⚔️',
    'Dégâts infligés +45%, riposte subie +50%',
    1.45,
    1.50,
  ),
  scutum(
    'Scuti Paratio',
    'Parade au Scutum',
    '🛡️',
    'Riposte subie réduite de 50%, dégâts normaux',
    0.90,
    0.50,
  ),
  celox(
    'Fuga Celox',
    'Esquive Agile',
    '💨',
    '+10 HS et Coup Critique si réponse < 4s',
    1.15,
    1.00,
  );

  final String latin;
  final String francais;
  final String emoji;
  final String description;
  final double damageMult;
  final double riposteMult;

  const CombatStance(
    this.latin,
    this.francais,
    this.emoji,
    this.description,
    this.damageMult,
    this.riposteMult,
  );
}

class DuelScreen extends StatefulWidget {
  final GameRepository repo;

  const DuelScreen({super.key, required this.repo});

  @override
  State<DuelScreen> createState() => _DuelScreenState();
}

class _DuelScreenState extends State<DuelScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  int _currentBossIndex = 0;
  CombatStance _currentStance = CombatStance.gravis;
  String? _currentBossSpeech;
  DateTime _questionStartTime = DateTime.now();

  final List<Map<String, dynamic>> _bosses = [
    {
      'nom': 'Marcus le Rétiaire',
      'titre': 'Gladiateur Vétéran',
      'image': 'assets/images/boss_gladiateur_140.png',
      'maxHp': 100,
      'attaque': 20,
      'citation': '« Mors aut gloria in harena ! »',
      'tauntBlesse': '« Bene pugnas, tiro ! Sed reticulum meum manet ! » (Bien battu ! Mais mon filet t\'attend !)',
      'tauntAttaque': '« Reticulum meum te capit ! Vae victis ! » (Mon filet te capture ! Malheur aux vaincus !)',
    },
    {
      'nom': 'Le Lion de Némée',
      'titre': 'Fauve Légendaire',
      'image': 'assets/images/boss_lion_140.png',
      'maxHp': 120,
      'attaque': 25,
      'citation': '« Rugitus leonis terram commovet ! »',
      'tauntBlesse': '« Grrr ! Pellis mea invulnerabilis est ! » (Ma peau est invulnérable !)',
      'tauntAttaque': '« Ungues mei ferrum penetrant ! » (Mes griffes percent le fer !)',
    },
    {
      'nom': 'Le Minotaure',
      'titre': 'Gardien du Labyrinthe',
      'image': 'assets/images/boss_minotaure_140.png',
      'maxHp': 140,
      'attaque': 30,
      'citation': '« Nullus exitus e labyrintho patet ! »',
      'tauntBlesse': '« Dolor me fortem reddit ! » (La douleur me rend plus fort !)',
      'tauntAttaque': '« Cornua mea te prosternent ! » (Mes cornes vont te terrasser !)',
    },
    {
      'nom': 'Le Sphinx de Thèbes',
      'titre': 'Maître des Énigmes',
      'image': 'assets/images/boss_sphinx_140.png',
      'maxHp': 160,
      'attaque': 35,
      'citation': '« Solve aenigma aut peri ! »',
      'tauntBlesse': '« Ingenium tuum me miratur... » (Ton esprit m\'étonne...)',
      'tauntAttaque': '« Ignorantia tua te damnat ! » (Ton ignorance te condamne !)',
    },
    {
      'nom': 'Mercure Céleste',
      'titre': 'Messager des Dieux',
      'image': 'assets/images/boss_mercure_140.png',
      'maxHp': 180,
      'attaque': 40,
      'citation': '« Celeritas deorum vincit omnia ! »',
      'tauntBlesse': '« Fulgur Iovis te adiuvat ! » (L\'éclair de Jupiter t\'assiste !)',
      'tauntAttaque': '« Tardus es sicut testudo ! » (Tu es lent comme une tortue !)',
    },
  ];

  final List<Map<String, dynamic>> _duelQuestions = [
    {
      'q': 'Que signifie « Lupus » ?',
      'rep': 'Le loup',
      'fausses': ['Le lièvre', 'La lune', 'Le lynx'],
    },
    {
      'q': 'Quel est le cas du sujet en latin ?',
      'rep': 'Le Nominatif',
      'fausses': ['L\'Accusatif', 'L\'Ablatif', 'Le Datif'],
    },
    {
      'q': 'Que signifie « Bellum » ?',
      'rep': 'La guerre',
      'fausses': ['La beauté', 'Le bœuf', 'La boisson'],
    },
    {
      'q': 'Qui est le dieu romain de la guerre ?',
      'rep': 'Mars',
      'fausses': ['Jupiter', 'Neptune', 'Vulcain'],
    },
    {
      'q': 'Quel cas latin exprime le COD ?',
      'rep': 'L\'Accusatif',
      'fausses': ['Le Génitif', 'Le Datif', 'L\'Ablatif'],
    },
    {
      'q': 'Que signifie « Gladius » ?',
      'rep': 'Le glaive',
      'fausses': ['Le bouclier', 'Le casque', 'La lance'],
    },
    {
      'q': 'Que signifie « Rex » (3e déclinaison) ?',
      'rep': 'Le roi',
      'fausses': ['La loi', 'La reine', 'Le chef'],
    },
    {
      'q': 'Quel suffixe caractérise l\'imparfait latin ?',
      'rep': '-ba-',
      'fausses': ['-vi-', '-re-', '-isse-'],
    },
    {
      'q': 'Que signifie « Veni, vidi, vici » de César ?',
      'rep': 'Je suis venu, j\'ai vu, j\'ai vaincu',
      'fausses': ['Vivre, aimer, mourir', 'Parler, écouter, comprendre', 'Courir, sauter, gagner'],
    },
    {
      'q': 'Que signifie l\'abréviation « SPQR » ?',
      'rep': 'Le Sénat et le Peuple Romain',
      'fausses': ['Rome Pour Toujours', 'Paix et Victoire Romaine', 'Gloire à l\'Empire'],
    },
  ];

  int _playerHp = 100;
  int _bossHp = 100;
  bool _combatFini = false;
  bool _victoire = false;
  int _gainsSesterces = 0;

  late Map<String, dynamic> _currentQ;
  late List<String> _shuffledChoices;
  String? _chosenAnswer;
  bool _animatingHit = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _initBoss();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _initBoss() {
    final boss = _bosses[_currentBossIndex];
    setState(() {
      _playerHp = 100;
      _bossHp = boss['maxHp'] as int;
      _combatFini = false;
      _victoire = false;
      _gainsSesterces = 0;
      _currentBossSpeech = null;
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    final random = math.Random();
    _currentQ = _duelQuestions[random.nextInt(_duelQuestions.length)];
    final options = <String>[
      _currentQ['rep'] as String,
      ...(_currentQ['fausses'] as List<String>),
    ];
    options.shuffle();
    _shuffledChoices = options;
    _chosenAnswer = null;
    _animatingHit = false;
    _questionStartTime = DateTime.now();
  }

  void _onOptionTapped(String answer) {
    if (_chosenAnswer != null || _combatFini) return;

    final isCorrect = (answer == _currentQ['rep']);
    final boss = _bosses[_currentBossIndex];
    final elapsedSec = DateTime.now().difference(_questionStartTime).inSeconds;

    setState(() {
      _chosenAnswer = answer;
      _animatingHit = true;
    });

    if (isCorrect) {
      HapticFeedback.heavyImpact();
      AudioService().playSwordClash();
      AudioService().playSesterces();
      RomanLottieEffects.showSwordClash(context);
      RomanParticlesOverlay.show(context, type: ParticleType.marbleSparks);

      int degats = (35 * _currentStance.damageMult).round();
      int sestercesEarned = 15;

      // Bonus de célérité si Fuga Celox et réponse ultra-rapide
      if (_currentStance == CombatStance.celox && elapsedSec <= 4) {
        degats = (degats * 1.25).round();
        sestercesEarned += 10;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: RomanColors.laurelGreen,
            duration: Duration(seconds: 1),
            content: Text('⚡ Coup Critique & Célérité ! (+10 HS)'),
          ),
        );
      }

      setState(() {
        _bossHp = math.max(0, _bossHp - degats);
        _gainsSesterces += sestercesEarned;
        _currentBossSpeech = boss['tauntBlesse'] as String?;
      });

      if (_bossHp <= 0) {
        _terminerCombat(victoire: true);
        return;
      }
    } else {
      HapticFeedback.vibrate();
      AudioService().playError();
      final baseRiposte = boss['attaque'] as int;
      final riposte = (baseRiposte * _currentStance.riposteMult).round();

      setState(() {
        _playerHp = math.max(0, _playerHp - riposte);
        _currentBossSpeech = boss['tauntAttaque'] as String?;
      });

      if (_currentStance == CombatStance.scutum) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blueGrey,
            duration: Duration(seconds: 1),
            content: Text('🛡️ Parade au Scutum : Dégâts réduits de moitié !'),
          ),
        );
      }

      if (_playerHp <= 0) {
        _terminerCombat(victoire: false);
        return;
      }
    }

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted && !_combatFini) {
        setState(() {
          _nextQuestion();
        });
      }
    });
  }

  void _terminerCombat({required bool victoire}) {
    setState(() {
      _combatFini = true;
      _victoire = victoire;
    });

    if (victoire) {
      final total = _gainsSesterces + 50;
      widget.repo.addSesterces(total);
      HapticFeedback.heavyImpact();
      AudioService().playSwordClash();
      AudioService().playCrowdCheer();
      AudioService().playTriumph();
      RomanLottieEffects.showCoinShower(context);
      RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
    } else {
      widget.repo.addSesterces(5);
      AudioService().playError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.repo,
      builder: (context, _) {
        final boss = _bosses[_currentBossIndex];

        return Scaffold(
          backgroundColor: const Color(0xFF1B1622), // Ambiance nocturne au Colisée
          appBar: AppBar(
            title: const Text(
              'COLOSSEUM DUELLUM',
              style: TextStyle(letterSpacing: 1.4, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            centerTitle: true,
            backgroundColor: const Color(0xFF2D1E3A),
            foregroundColor: Colors.white,
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
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
                      '+$_gainsSesterces (${widget.repo.profile.sesterces} HS)',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF7A5901)),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Règles de l\'Arène'),
                      content: const Text(
                        'Affronte les champions antiques du Colisée !\n\n'
                        'Chaque bonne réponse porte un coup critique à l\'adversaire.\n'
                        'Une erreur te fait subir la riposte du gladiateur.\n\n'
                        'Vaincs les 5 colosses pour graver ton nom au Panthéon !',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Compris'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Arène & Jauges de Vie
            Expanded(
              flex: 5,
              child: _buildArenaView(boss),
            ),

            // 2. Panneau Question / Énigme ou Victoire
            Expanded(
              flex: 5,
              child: _combatFini ? _buildVictoryPanel(boss) : _buildQuizPanel(),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildArenaView(Map<String, dynamic> boss) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2D1E3A), Color(0xFF18101E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Barres de Vie (Joueur vs Boss)
          Row(
            children: [
              // Jauge Joueur
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🛡️ TOI (Tiro)',
                      style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: _playerHp / 100.0,
                        backgroundColor: Colors.white24,
                        color: _playerHp > 30 ? Colors.greenAccent : Colors.redAccent,
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text('$_playerHp / 100 HP', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Jauge Boss
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '⚔️ ${boss['nom']}',
                      style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: _bossHp / (boss['maxHp'] as int),
                        backgroundColor: Colors.white24,
                        color: Colors.deepOrangeAccent,
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text('$_bossHp / ${boss['maxHp']} HP', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),

          // Portrait du Boss dans son Médaillon Antique encadré de Flambeaux
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/animated/flambeau_flamme.webp',
                width: 32,
                height: 52,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 14),
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = _animatingHit ? 0.92 : 1.0 + (_pulseController.value * 0.04);
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _animatingHit ? Colors.redAccent : RomanColors.imperialGold,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (_animatingHit ? Colors.redAccent : RomanColors.imperialGold).withOpacity(0.35),
                            blurRadius: 16,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          boss['image'] as String,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Text('⚔️', style: TextStyle(fontSize: 48)),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 14),
              Transform.scale(
                scaleX: -1,
                child: Image.asset(
                  'assets/images/animated/flambeau_flamme.webp',
                  width: 32,
                  height: 52,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),

          // Titre et citation antique du boss
          Column(
            children: [
              Text(
                boss['titre'] as String,
                style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.8),
              ),
              const SizedBox(height: 3),
              if (_currentBossSpeech != null)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A1F3D),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                  ),
                  child: Text(
                    _currentBossSpeech!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              else
                Text(
                  boss['citation'] as String,
                  style: const TextStyle(color: Colors.white60, fontStyle: FontStyle.italic, fontSize: 11),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuizPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFF9F6F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sélecteur de Posture de Combat (Stance)
          Row(
            children: CombatStance.values.map((stance) {
              final isSelected = (stance == _currentStance);
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentStance = stance;
                    });
                    AudioService().playWheelClick();
                    HapticFeedback.selectionClick();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? RomanColors.imperialPurple : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? RomanColors.imperialGold : RomanColors.marbleBorder,
                        width: isSelected ? 1.6 : 1.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: RomanColors.imperialPurple.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${stance.emoji} ${stance.latin}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : RomanColors.imperialPurple,
                            ),
                          ),
                        ),
                        const SizedBox(height: 1),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            stance.francais,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 8.5,
                              color: isSelected ? RomanColors.goldLight : Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: RomanColors.goldLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: RomanColors.imperialGold.withOpacity(0.5)),
            ),
            child: Text(
              _currentQ['q'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: RomanColors.imperialPurple,
              ),
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.1,
              physics: const NeverScrollableScrollPhysics(),
              children: _shuffledChoices.map((choice) {
                final isSelected = (_chosenAnswer == choice);
                final isCorrect = (choice == _currentQ['rep']);

                Color btnBg = Colors.white;
                Color btnBorder = RomanColors.marbleBorder;
                Color btnText = RomanColors.imperialPurple;

                if (_chosenAnswer != null) {
                  if (isCorrect) {
                    btnBg = Colors.green.shade50;
                    btnBorder = Colors.green.shade600;
                    btnText = Colors.green.shade800;
                  } else if (isSelected) {
                    btnBg = Colors.red.shade50;
                    btnBorder = Colors.red.shade600;
                    btnText = Colors.red.shade800;
                  }
                }

                return InkWell(
                  onTap: () => _onOptionTapped(choice),
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: btnBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: btnBorder, width: isSelected ? 2.0 : 1.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      choice,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: btnText,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVictoryPanel(Map<String, dynamic> boss) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFF9F6F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _victoire ? '⚔️ TRIOMPHE DANS L\'ARÈNE !' : '☠️ DÉFAITE AU COMBAT !',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _victoire ? Colors.green.shade800 : Colors.red.shade800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _victoire
                ? 'Tu as terrassé ${boss['nom']} ! Le peuple romain scande ton nom.'
                : '${boss['nom']} a triomphé dans le sable. Retrempe ton glaive et retente ta chance !',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: RomanColors.goldLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: RomanColors.imperialGold),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🪙', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  '+${_victoire ? _gainsSesterces + 50 : 5} Sesterces remportés',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7A5901),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: RomanColors.imperialPurple,
                  side: BorderSide(color: RomanColors.imperialPurple),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text('Quitter'),
              ),
              const SizedBox(width: 16),
              if (_victoire && _currentBossIndex < _bosses.length - 1)
                ElevatedButton.icon(
                  onPressed: () {
                    AudioService().playWheelClick();
                    setState(() {
                      _currentBossIndex++;
                      _initBoss();
                    });
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Boss Suivant'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RomanColors.imperialPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: () {
                    AudioService().playWheelClick();
                    _initBoss();
                  },
                  icon: const Icon(Icons.replay),
                  label: const Text('Rejouer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RomanColors.imperialPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
