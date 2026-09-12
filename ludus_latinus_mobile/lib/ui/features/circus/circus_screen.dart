import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/particles_overlay.dart';
import '../../core/widgets.dart';
import '../../core/game_juice.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';

enum CircusFaction {
  veneti('Veneti', 'Bleus Impériaux', Color(0xFF1E5B94), 'Vitesse +15%', 1.15, 1.0, 1.0, '💙'),
  russati('Russati', 'Rouges Guerriers', Color(0xFFB3261E), 'Turbo +25%', 1.0, 1.25, 1.0, '❤️'),
  prasini('Prasini', 'Verts Populaires', Color(0xFF2E6F40), 'Sesterces +30%', 1.0, 1.0, 1.30, '💚'),
  albati('Albati', 'Blancs Vétérans', Color(0xFF616161), 'Seconde Chance', 1.0, 1.0, 1.0, '🤍');

  final String nom;
  final String description;
  final Color couleur;
  final String bonusLabel;
  final double speedMult;
  final double turboMult;
  final double sestercesMult;
  final String icon;

  const CircusFaction(
    this.nom,
    this.description,
    this.couleur,
    this.bonusLabel,
    this.speedMult,
    this.turboMult,
    this.sestercesMult,
    this.icon,
  );
}

class CircusMaximusScreen extends StatefulWidget {
  final GameRepository repo;

  const CircusMaximusScreen({super.key, required this.repo});

  @override
  State<CircusMaximusScreen> createState() => _CircusMaximusScreenState();
}

class _CircusMaximusScreenState extends State<CircusMaximusScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  // Faction impériale et bonus
  CircusFaction _selectedFaction = CircusFaction.veneti;
  bool _shieldAvailable = false;
  final GlobalKey<RomanScreenShakeState> _shakeKey = GlobalKey<RomanScreenShakeState>();

  CircusFaction get _rivalFaction =>
      _selectedFaction == CircusFaction.russati ? CircusFaction.veneti : CircusFaction.russati;

  String _getChariotAsset(CircusFaction faction) {
    switch (faction) {
      case CircusFaction.veneti:
        return 'assets/images/circus/chariot_bleu.png';
      case CircusFaction.russati:
        return 'assets/images/circus/chariot_rouge.png';
      case CircusFaction.prasini:
        return 'assets/images/circus/chariot_vert.png';
      case CircusFaction.albati:
        return 'assets/images/circus/chariot_blanc.png';
    }
  }

  // Événement d'incident de virage (Meta)
  bool _incidentActive = false;
  int _incidentLap = 0;
  Map<String, dynamic>? _currentIncident;
  int _incidentCountdown = 4;
  Timer? _incidentCountdownTimer;

  // Progression de la course (0.0 à 100.0%)
  double _playerProgress = 0.0;
  double _rivalProgress = 0.0;
  double _playerSpeed = 0.035;
  double _rivalSpeed = 0.032;

  int _currentLap = 1;
  static const int _totalLaps = 3;
  bool _raceFinished = false;
  bool _playerWon = false;
  int _scoreSesterces = 0;
  int _comboCount = 0;
  int _turboRemainingFrames = 0;

  // Questions de vocabulaire et culture du Circus Maximus
  final List<Map<String, dynamic>> _questions = [
    {
      'q': 'Que signifie « equus » qui tire ton quadrige ?',
      'rep': 'Le cheval',
      'fausses': ['Le loup', 'L\'aigle', 'Le taureau'],
      'explication': 'Equus (m.) désigne le cheval ; eques désigne le cavalier.',
    },
    {
      'q': 'Que signifie « celeriter » pour accélérer ?',
      'rep': 'Rapidement',
      'fausses': ['Lentement', 'Toujours', 'Jamais'],
      'explication': 'Celeriter est l\'adverbe de celer (rapide) -> célérité.',
    },
    {
      'q': 'Que signifie « victoria » à l\'arrivée ?',
      'rep': 'La victoire',
      'fausses': ['La défaite', 'Le départ', 'La route'],
      'explication': 'Victoria donne victoire en français.',
    },
    {
      'q': 'Que signifie « auriga » ?',
      'rep': 'Le cocher de char',
      'fausses': ['Le légionnaire', 'Le sénateur', 'Le forgeron'],
      'explication': 'L\'aurige était le champion adulé conduisant le char.',
    },
    {
      'q': 'Comment dit-on « quatre » en latin (quadrige) ?',
      'rep': 'Quattuor',
      'fausses': ['Tres', 'Quinque', 'Duo'],
      'explication': 'Quattuor = 4 -> quadrige (char à 4 chevaux).',
    },
    {
      'q': 'Que signifie « arena » à l\'origine ?',
      'rep': 'Le sable',
      'fausses': ['L\'eau', 'La pierre', 'L\'or'],
      'explication': 'Harena désignait le sable fin qui couvrait la piste.',
    },
    {
      'q': 'Que crie la foule pour encourager : « Curre » ?',
      'rep': 'Cours !',
      'fausses': ['Arrête !', 'Regarde !', 'Écoute !'],
      'explication': 'Curre est l\'impératif présent du verbe currere (courir).',
    },
    {
      'q': 'Quelle faction porte la couleur bleue au cirque ?',
      'rep': 'Veneti',
      'fausses': ['Russati', 'Prasini', 'Albati'],
      'explication': 'Les Veneti (Bleus) et Prasini (Verts) étaient les favoris.',
    },
    {
      'q': 'Quel animal en bronze servait à compter les tours ?',
      'rep': 'Le dauphin',
      'fausses': ['Le lion', 'L\'aigle', 'Le cygne'],
      'explication': 'Sept dauphins en bronze s\'abaissaient à chaque tour.',
    },
    {
      'q': 'Comment appelle-t-on le terre-plein central du cirque ?',
      'rep': 'La Spina',
      'fausses': ['Le Cardo', 'L\'Atrium', 'La Cavea'],
      'explication': 'La spina est l\'épine dorsale ornée d\'obélisques.',
    },
  ];

  late Map<String, dynamic> _currentQuestion;
  late List<String> _shuffledAnswers;
  String? _selectedAnswer;
  Timer? _gameLoopTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _shieldAvailable = (_selectedFaction == CircusFaction.albati);
    _loadNewQuestion();
    _startGameLoop();
  }

  @override
  void dispose() {
    _incidentCountdownTimer?.cancel();
    _gameLoopTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _loadNewQuestion() {
    final random = math.Random();
    _currentQuestion = _questions[random.nextInt(_questions.length)];
    final options = <String>[
      _currentQuestion['rep'] as String,
      ...(_currentQuestion['fausses'] as List<String>),
    ];
    options.shuffle();
    _shuffledAnswers = options;
    _selectedAnswer = null;
  }

  void _startGameLoop() {
    _gameLoopTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_raceFinished) return;

      setState(() {
        // Avancement du joueur avec boost ou vitesse de croisière selon faction
        double speed = _playerSpeed * _selectedFaction.speedMult;
        if (_turboRemainingFrames > 0) {
          speed *= (2.2 * _selectedFaction.turboMult);
          _turboRemainingFrames--;
        }
        _playerProgress += speed;

        // Vitesse du rival avec légères variations réalistes
        final rivalFluctuation = (math.sin(timer.tick * 0.1) * 0.005);
        _rivalProgress += (_rivalSpeed + rivalFluctuation);

        // Déclenchement de l'incident de virage serré à la Meta (vers 50% du tour)
        if (_playerProgress >= 48.0 && _incidentLap < _currentLap && !_incidentActive) {
          _triggerTurnIncident();
        }

        // Détection de tour terminé
        if (_playerProgress >= 100.0) {
          if (_currentLap < _totalLaps) {
            _currentLap++;
            _playerProgress = 0.0;
            _incidentActive = false;
            _incidentCountdownTimer?.cancel();
            _rivalProgress = math.max(0.0, _rivalProgress - 95.0);
            HapticFeedback.mediumImpact();
            AudioService().playCrowdCheer();
          } else {
            _finishRace(won: true);
          }
        } else if (_rivalProgress >= 100.0 && _currentLap >= _totalLaps) {
          _finishRace(won: false);
        }
      });
    });
  }

  void _triggerTurnIncident() {
    _incidentLap = _currentLap;
    _incidentActive = true;
    _incidentCountdown = 4;
    final incidents = [
      {
        'titre': '⚠️ Incident à la Meta !',
        'desc': 'Le quadrige dérape sur le sable fin au ras de l\'obélisque !',
        'bonne': 'Frena stringere (Serrer les rênes fermement)',
        'mauvaise': 'Equos flagellare (Fouetter sans regarder)',
      },
      {
        'titre': '⚠️ Bourrasque de sable sur la Spina !',
        'desc': 'La poussière aveugle les chevaux à l\'entrée du virage !',
        'bonne': 'Cursum moderari (Contrôler la trajectoire)',
        'mauvaise': 'Oculos claudere (Fermer les yeux)',
      },
      {
        'titre': '⚠️ Tentative de dépassement agressif !',
        'desc': 'Un char rival tente de te serrer contre la bordure en marbre !',
        'bonne': 'Spatium defendere (Défendre sa ligne)',
        'mauvaise': 'Laxare habenas (Lâcher prise)',
      },
    ];
    final inc = incidents[math.Random().nextInt(incidents.length)];
    final options = [inc['bonne']!, inc['mauvaise']!]..shuffle();
    _currentIncident = {
      'titre': inc['titre'],
      'desc': inc['desc'],
      'bonne': inc['bonne'],
      'options': options,
    };
    AudioService().playCrowdCheer();
    HapticFeedback.mediumImpact();

    _incidentCountdownTimer?.cancel();
    _incidentCountdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _incidentCountdown--;
      });
      if (_incidentCountdown <= 0) {
        t.cancel();
        if (_incidentActive) {
          _resolveIncident(false, timeout: true);
        }
      }
    });
  }

  void _resolveIncident(bool success, {bool timeout = false}) {
    _incidentCountdownTimer?.cancel();
    setState(() {
      _incidentActive = false;
    });

    if (success) {
      HapticFeedback.heavyImpact();
      AudioService().playTriumph();
      AudioService().playCrowdCheer();
      RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
      setState(() {
        _turboRemainingFrames = 30; // Gros boost
        _scoreSesterces += 15;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: RomanColors.laurelGreen,
          duration: Duration(seconds: 2),
          content: Text('✓ Virage magistral ! Turbo impérial activé ! (+15 HS)'),
        ),
      );
    } else {
      if (_shieldAvailable) {
        _shieldAvailable = false;
        AudioService().playSwordClash();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blueGrey,
            duration: Duration(seconds: 2),
            content: Text('🛡️ Bouclier des Albati : Crash évité de justesse !'),
          ),
        );
      } else {
        AudioService().playError();
        HapticFeedback.vibrate();
        _shakeKey.currentState?.shake(intensity: ShakeIntensity.heavy);
        setState(() {
          _playerProgress = math.max(0.0, _playerProgress - 6.0);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade800,
            duration: const Duration(seconds: 2),
            content: Text(timeout ? '⏱️ Temps écoulé ! Dérapage à la borne !' : '❌ Mauvaise manœuvre ! Tête-à-queue léger !'),
          ),
        );
      }
    }
  }

  void _onAnswerSelected(String answer) {
    if (_selectedAnswer != null || _raceFinished) return;

    final isCorrect = (answer == _currentQuestion['rep']);
    setState(() {
      _selectedAnswer = answer;
    });

    if (isCorrect) {
      HapticFeedback.heavyImpact();
      AudioService().playCrowdCheer();
      AudioService().playSesterces();
      RomanParticlesOverlay.show(context, type: ParticleType.marbleSparks);
      _comboCount++;
      _turboRemainingFrames = (28 * _selectedFaction.turboMult).round();
      _scoreSesterces += (10 * _comboCount);
    } else {
      if (_shieldAvailable) {
        _shieldAvailable = false;
        AudioService().playSwordClash();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blueGrey,
            duration: Duration(seconds: 2),
            content: Text('🛡️ Seconde Chance des Albati : Erreur amortie sans ralentissement !'),
          ),
        );
      } else {
        HapticFeedback.vibrate();
        AudioService().playError();
        _shakeKey.currentState?.shake(intensity: ShakeIntensity.medium);
        _comboCount = 0;
        _playerProgress = math.max(0.0, _playerProgress - 3.5); // tête-à-queue léger
      }
    }

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted && !_raceFinished) {
        setState(() {
          _loadNewQuestion();
        });
      }
    });
  }

  void _finishRace({required bool won}) {
    _incidentCountdownTimer?.cancel();
    _gameLoopTimer?.cancel();
    _raceFinished = true;
    _playerWon = won;

    if (won) {
      final baseReward = _scoreSesterces + 50;
      final finalReward = (baseReward * _selectedFaction.sestercesMult).round();
      widget.repo.addSesterces(finalReward);
      HapticFeedback.heavyImpact();
      AudioService().playCrowdCheer();
      AudioService().playTriumph();
      RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
    } else {
      widget.repo.addSesterces(10);
      AudioService().playError();
    }
  }

  void _restartRace() {
    AudioService().playWheelClick();
    _incidentCountdownTimer?.cancel();
    setState(() {
      _playerProgress = 0.0;
      _rivalProgress = 0.0;
      _currentLap = 1;
      _raceFinished = false;
      _playerWon = false;
      _scoreSesterces = 0;
      _comboCount = 0;
      _turboRemainingFrames = 0;
      _incidentActive = false;
      _incidentLap = 0;
      _shieldAvailable = (_selectedFaction == CircusFaction.albati);
      _loadNewQuestion();
    });
    _startGameLoop();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.repo,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF9F6F0),
          appBar: AppBar(
            title: const Text(
              'CIRCUS MAXIMUS',
              style: TextStyle(
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            centerTitle: true,
            backgroundColor: RomanColors.imperialPurple,
            foregroundColor: Colors.white,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: RomanColors.goldLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: RomanColors.imperialGold),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🪙', style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 4),
                    Text(
                      '+$_scoreSesterces (${widget.repo.profile.sesterces} HS)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7A5901),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      body: RomanScreenShake(
        key: _shakeKey,
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: Column(
                children: [
                  const RomanMeanderDivider(height: 10, color: RomanColors.imperialGold),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: CircusVelariumHeader(
                      selectedIndex: CircusFaction.values.indexOf(_selectedFaction),
                      onSelectFaction: (idx) {
                        setState(() {
                          _selectedFaction = CircusFaction.values[idx];
                          _shieldAvailable = (_selectedFaction == CircusFaction.albati);
                        });
                        AudioService().playWheelClick();
                      },
                    ),
                  ),
                  // 1. Tableau des 3 Dauphins de Bronze (Compteur de Tours)
                  _buildDolphinLapCounter(),

                  // 2. Vue de la Piste Monument Valley (CustomPainter & Sprites)
                  SizedBox(
                    height: 195,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: _buildRacetrackView(),
                    ),
                  ),

                  // 3. Panneau Turbo & Combo
                  _buildTurboComboHeader(),

                  // 4. Console Quiz Question & Choix de Vocabulaire
                  Expanded(
                    child: _raceFinished ? _buildVictoryScreen() : _buildQuizPanel(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
      },
    );
  }

  void _showFactionSelectionDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🐎 Choisis ton Écurie Impériale'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: CircusFaction.values.map((f) {
            final isSelected = (f == _selectedFaction);
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? f.couleur.withOpacity(0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? f.couleur : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: ListTile(
                leading: Text(f.icon, style: const TextStyle(fontSize: 22)),
                title: Text(f.nom, style: TextStyle(fontWeight: FontWeight.bold, color: f.couleur)),
                subtitle: Text('${f.description} • Bonus : ${f.bonusLabel}', style: const TextStyle(fontSize: 11)),
                trailing: isSelected ? Icon(Icons.check_circle, color: f.couleur) : null,
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedFaction = f;
                    _shieldAvailable = (f == CircusFaction.albati);
                  });
                  AudioService().playWheelClick();
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDolphinLapCounter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: RomanColors.marbleBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'TOURS : ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: RomanColors.imperialPurple,
                ),
              ),
              ...List.generate(_totalLaps, (index) {
                final isCompleted = index < _currentLap;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 300),
                    scale: isCompleted ? 1.15 : 0.85,
                    child: Text(
                      isCompleted ? '🐬' : '⚪',
                      style: TextStyle(
                        fontSize: 18,
                        color: isCompleted ? Colors.blueAccent : Colors.grey,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          InkWell(
            onTap: _showFactionSelectionDialog,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _turboRemainingFrames > 0
                    ? Colors.orange.withOpacity(0.2)
                    : _selectedFaction.couleur.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _turboRemainingFrames > 0 ? Colors.orange : _selectedFaction.couleur,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _turboRemainingFrames > 0
                        ? '🔥 TURBO'
                        : '${_selectedFaction.icon} ${_selectedFaction.nom.toUpperCase()} ▼',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _turboRemainingFrames > 0 ? Colors.deepOrange : _selectedFaction.couleur,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRacetrackView() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFDFCAAC), // Sable de l'arène
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC0A080), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Fond animé du sable et des gradins
                CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: _CircusTrackPainter(
                    playerProgress: _playerProgress / 100.0,
                    rivalProgress: _rivalProgress / 100.0,
                    isTurbo: _turboRemainingFrames > 0,
                  ),
                ),

                // Ligne de départ / arrivée dorée
                Positioned(
                  left: 40,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: 3,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),

                // Spina centrale ornée d'obélisques et statues
                Center(
                  child: Container(
                    width: 140,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0E6D2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: RomanColors.imperialGold, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33000000),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Text('🏛️', style: TextStyle(fontSize: 14)),
                        Text('SPINA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Color(0xFF7A5901))),
                        Text('🏺', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ),

                // Char Bleu (Joueur - Veneti)
                _buildChariotWidget(
                  constraints: constraints,
                  progress: _playerProgress / 100.0,
                  laneY: 0.28,
                  isPlayer: true,
                  isTurbo: _turboRemainingFrames > 0,
                ),

                // Char Rouge (Rival - Russati)
                _buildChariotWidget(
                  constraints: constraints,
                  progress: _rivalProgress / 100.0,
                  laneY: 0.72,
                  isPlayer: false,
                  isTurbo: false,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildChariotWidget({
    required BoxConstraints constraints,
    required double progress,
    required double laneY,
    required bool isPlayer,
    required bool isTurbo,
  }) {
    // Largeur du quadrige et de la piste
    const chariotWidth = 92.0;
    const chariotHeight = 46.0;
    final trackWidth = math.max(100.0, constraints.maxWidth - (chariotWidth + 24.0));
    final x = 10.0 + (progress.clamp(0.0, 1.0) * trackWidth);
    final y = (constraints.maxHeight * laneY) - (chariotHeight * 0.65);

    final faction = isPlayer ? _selectedFaction : _rivalFaction;
    final assetPath = _getChariotAsset(faction);

    // Galop physique avec rebond vertical et léger tangage
    final gallopSpeed = isTurbo ? 9.5 : 4.5;
    final gallopCycle = (_animController.value * gallopSpeed * 2 * math.pi);
    final gallopOffsetY = math.sin(gallopCycle) * (isTurbo ? 2.8 : 1.6);
    final gallopAngle = math.cos(gallopCycle) * (isTurbo ? 0.035 : 0.015);

    return Positioned(
      left: x,
      top: y + gallopOffsetY,
      child: Transform.rotate(
            angle: gallopAngle,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge d'écurie romaine au-dessus du quadrige
                Container(
                  margin: const EdgeInsets.only(left: 4, bottom: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: faction.couleur.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isPlayer ? RomanColors.imperialGold : Colors.white70,
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        offset: Offset(0, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(faction.icon, style: const TextStyle(fontSize: 8.5)),
                      const SizedBox(width: 3),
                      Text(
                        isPlayer ? 'SPQR • ${faction.nom.toUpperCase()}' : 'RIVAL • ${faction.nom.toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (isPlayer && isTurbo) ...[
                        const SizedBox(width: 3),
                        const Text('🔥', style: TextStyle(fontSize: 8)),
                      ],
                    ],
                  ),
                ),

                // Quadrige avec roues, aurige, chevaux, traînée de poussière & turbo
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Traînée de poussière et flammes à l'arrière des roues
                    if (isTurbo)
                      Container(
                        margin: const EdgeInsets.only(right: 2, bottom: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('💨', style: TextStyle(fontSize: 12)),
                            Text('🔥', style: TextStyle(fontSize: 15)),
                          ],
                        ),
                      )
                    else
                      Container(
                        margin: const EdgeInsets.only(right: 2, bottom: 2),
                        child: Text(
                          '💨',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.65),
                          ),
                        ),
                      ),

                    // Corps du char (Quadrige antique avec ombre portée et bouclier éventuel)
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Halo de turbo ou bouclier céleste Albati
                        if (isTurbo)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orangeAccent.withOpacity(0.6),
                                    blurRadius: 14,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (isPlayer && _shieldAvailable && _selectedFaction == CircusFaction.albati)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.cyanAccent.withOpacity(0.85), width: 2),
                                color: Colors.cyanAccent.withOpacity(0.18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.cyanAccent.withOpacity(0.4),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Image réelle du Quadrige Antique
                        Image.asset(
                          assetPath,
                          width: chariotWidth,
                          height: chariotHeight,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(
                            width: chariotWidth,
                            height: chariotHeight,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: faction.couleur,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text('🐎 Quadrige', style: TextStyle(color: Colors.white, fontSize: 10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
  }

  Widget _buildTurboComboHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('COMBO : ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
              Text(
                'x$_comboCount',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _comboCount > 1 ? Colors.deepOrange : RomanColors.imperialPurple,
                ),
              ),
            ],
          ),
          Text(
            _turboRemainingFrames > 0 ? '⚡ ACCÉLÉRATION MAXIMALE !' : 'Réponds vite pour doubler ton rival !',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _turboRemainingFrames > 0 ? Colors.deepOrange : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentPanel() {
    final inc = _currentIncident!;
    final options = inc['options'] as List<String>;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7EB),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: Colors.deepOrange, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22FF5722),
            offset: Offset(0, -3),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                inc['titre'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '⏱️ ${_incidentCountdown}s',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            inc['desc'] as String,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Column(
              children: options.map((opt) {
                final isGood = (opt == inc['bonne']);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => _resolveIncident(isGood),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RomanColors.goldLight,
                        foregroundColor: RomanColors.imperialPurple,
                        side: const BorderSide(color: RomanColors.imperialGold, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        opt,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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

  Widget _buildQuizPanel() {
    if (_incidentActive && _currentIncident != null) {
      return _buildIncidentPanel();
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: RomanColors.marbleBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            offset: Offset(0, -3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Énoncé de la question
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: RomanColors.goldLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: RomanColors.imperialGold.withOpacity(0.5)),
            ),
            child: Text(
              _currentQuestion['q'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: RomanColors.imperialPurple,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Grille 2x2 des réponses
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 500;
                final childAspectRatio = isWide ? 4.2 : 2.3;

                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: childAspectRatio,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(_shuffledAnswers.length, (index) {
                    final answer = _shuffledAnswers[index];
                    final letterBadge = ['A', 'B', 'C', 'D'][index % 4];
                    final isSelected = (_selectedAnswer == answer);
                    final isCorrect = (answer == _currentQuestion['rep']);

                    Color btnBg = Colors.white;
                    Color btnBorder = RomanColors.marbleBorder;
                    Color btnText = RomanColors.imperialPurple;
                    Color badgeBg = RomanColors.goldLight;
                    Color badgeBorder = RomanColors.imperialGold;
                    Color badgeText = const Color(0xFF7A5901);

                    if (_selectedAnswer != null) {
                      if (isCorrect) {
                        btnBg = Colors.green.shade50;
                        btnBorder = Colors.green.shade600;
                        btnText = Colors.green.shade800;
                        badgeBg = Colors.green.shade700;
                        badgeBorder = Colors.green;
                        badgeText = Colors.white;
                      } else if (isSelected) {
                        btnBg = Colors.red.shade50;
                        btnBorder = Colors.red.shade600;
                        btnText = Colors.red.shade800;
                        badgeBg = Colors.red.shade700;
                        badgeBorder = Colors.red;
                        badgeText = Colors.white;
                      }
                    }

                    return InkWell(
                      onTap: () => _onAnswerSelected(answer),
                      borderRadius: BorderRadius.circular(14),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: badgeBg,
                                border: Border.all(color: badgeBorder, width: 1),
                              ),
                              child: Center(
                                child: Text(
                                  letterBadge,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: badgeText,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  answer,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: btnText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVictoryScreen() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: RomanColors.marbleBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _playerWon ? '🏆 VICTORIA !' : '💨 COURSE DISPUTÉE !',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _playerWon ? Colors.green.shade800 : Colors.red.shade800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _playerWon
                ? 'Ton quadrige franchit la ligne en triomphateur ! Rome t\'acclame !'
                : 'Le rival Maximus a été le plus rapide cette fois-ci. Réessaie pour la gloire !',
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
                  '+${_playerWon ? _scoreSesterces + 50 : 10} Sesterces remportés',
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
              ElevatedButton.icon(
                onPressed: _restartRace,
                icon: const Icon(Icons.replay),
                label: const Text('Nouvelle Course'),
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

class _CircusTrackPainter extends CustomPainter {
  final double playerProgress;
  final double rivalProgress;
  final bool isTurbo;

  _CircusTrackPainter({
    required this.playerProgress,
    required this.rivalProgress,
    required this.isTurbo,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final sandPaint = Paint()..color = const Color(0xFFE8D3B4);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), sandPaint);

    // Lignes de séparation de couloirs en pointillés
    final dashPaint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    const double dashWidth = 8;
    const double dashSpace = 8;
    double startX = 0;
    final double yMiddle = size.height * 0.5;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, yMiddle),
        Offset(startX + dashWidth, yMiddle),
        dashPaint,
      );
      startX += dashWidth + dashSpace;
    }

    // Effet de trainée de poussière si turbo
    if (isTurbo) {
      final turboTrail = Paint()
        ..color = Colors.orange.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.28), 16, turboTrail);
    }
  }

  @override
  bool shouldRepaint(covariant _CircusTrackPainter oldDelegate) {
    return oldDelegate.playerProgress != playerProgress ||
        oldDelegate.rivalProgress != rivalProgress ||
        oldDelegate.isTurbo != isTurbo;
  }
}
