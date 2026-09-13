import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/particles_overlay.dart';
import '../../core/lottie_effects.dart';
import '../../core/cinematic_player.dart';
import '../../core/game_juice.dart';
import '../../core/widgets.dart';
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

  List<Map<String, dynamic>> _duelDeck = [];

  final List<Map<String, dynamic>> _duelQuestions = [
    {
      'q': 'Que signifie « Lupus » ?',
      'rep': 'Le loup',
      'fausses': ['Le lièvre', 'La lune', 'Le lynx'],
      'explication': 'Lupus (m.) désigne le loup. La louve (lupa) allaita Romulus et Rémus.',
    },
    {
      'q': 'Quel est le cas du sujet et de son attribut en latin ?',
      'rep': 'Le Nominatif',
      'fausses': ['L\'Accusatif', 'L\'Ablatif', 'Le Datif'],
      'explication': 'Le nominatif est le premier cas de la déclinaison, fonction sujet.',
    },
    {
      'q': 'Quel cas latin exprime le Complément d\'Objet Direct (COD) ?',
      'rep': 'L\'Accusatif',
      'fausses': ['Le Génitif', 'Le Datif', 'L\'Ablatif'],
      'explication': 'L\'accusatif marque le patient ou but de l\'action (terminaison en -m au singulier).',
    },
    {
      'q': 'Quel cas latin exprime la possession (complément du nom) ?',
      'rep': 'Le Génitif',
      'fausses': ['Le Datif', 'L\'Ablatif', 'Le Vocatif'],
      'explication': 'Le génitif indique l\'appartenance (ex: Gladius Caesaris = le glaive de César).',
    },
    {
      'q': 'Quel cas latin correspond au COI et à l\'attribution ?',
      'rep': 'Le Datif',
      'fausses': ['L\'Accusatif', 'Le Nominatif', 'L\'Ablatif'],
      'explication': 'Le datif sert à indiquer à qui ou pour qui l\'action est faite.',
    },
    {
      'q': 'Quel cas exprime les compléments de moyen, de temps et de lieu ?',
      'rep': 'L\'Ablatif',
      'fausses': ['Le Vocatif', 'Le Génitif', 'L\'Accusatif'],
      'explication': 'L\'ablatif synthétise l\'instrumental, le séparatif et le locatif.',
    },
    {
      'q': 'Quel cas sert à interpeller directement quelqu\'un ?',
      'rep': 'Le Vocatif',
      'fausses': ['Le Datif', 'Le Nominatif', 'L\'Accusatif'],
      'explication': 'Exemple célèbre : « Ave, Caesar ! » ou « Tu quoque, mi fili ! ».',
    },
    {
      'q': 'Que signifie « Bellum » ?',
      'rep': 'La guerre',
      'fausses': ['La beauté', 'Le bœuf', 'La boisson'],
      'explication': 'Bellum (n.) donne « belligérant », « belliqueux » et « rébellion ».',
    },
    {
      'q': 'Que signifie « Pax » ?',
      'rep': 'La paix',
      'fausses': ['Le pain', 'Le mur', 'Le pas'],
      'explication': 'Pax Romana désignait la longue période de paix impériale.',
    },
    {
      'q': 'Qui est le dieu romain de la guerre ?',
      'rep': 'Mars',
      'fausses': ['Jupiter', 'Neptune', 'Vulcain'],
      'explication': 'Mars, équivalent d\'Arès chez les Grecs, est l\'ancêtre des Romains.',
    },
    {
      'q': 'Que signifie « Gladius » ?',
      'rep': 'Le glaive',
      'fausses': ['Le bouclier', 'Le casque', 'La lance'],
      'explication': 'L\'épée courte à double tranchant des légionnaires, d\'où « gladiateur ».',
    },
    {
      'q': 'Comment s\'appelle le grand bouclier rectangulaire romain ?',
      'rep': 'Le Scutum',
      'fausses': ['La Lorica', 'Le Pilum', 'La Galea'],
      'explication': 'Le scutum courbé protégeait le corps et formait la fameuse tortue.',
    },
    {
      'q': 'Que désigne le « Pilum » lancé par les légionnaires ?',
      'rep': 'Le javelot lourd',
      'fausses': ['La flèche', 'Le bouclier', 'La dague'],
      'explication': 'Le pilum avait une pointe en fer doux conçue pour se tordre après impact.',
    },
    {
      'q': 'Comment appelle-t-on le casque de bronze du guerrier romain ?',
      'rep': 'La Galea',
      'fausses': ['La Caliga', 'Le Sagum', 'La Balteus'],
      'explication': 'La galea protégeait la tête, les joues et la nuque.',
    },
    {
      'q': 'Que signifie « Rex » (3e déclinaison) ?',
      'rep': 'Le roi',
      'fausses': ['La loi', 'La reine', 'Le chef'],
      'explication': 'Rex (génitif regis) donne « royal », « régime » et « souverain ».',
    },
    {
      'q': 'Que signifie « Civis » ?',
      'rep': 'Le citoyen',
      'fausses': ['Le paysan', 'Le marchand', 'Le marin'],
      'explication': 'Civis donne citoyen, civil et civilité. « Civis Romanus sum ! ».',
    },
    {
      'q': 'Que signifie « Urbs » ?',
      'rep': 'La ville',
      'fausses': ['Le champ', 'La forêt', 'La colline'],
      'explication': 'Urbs désigne la ville fortifiée, et par excellence la cité de Rome.',
    },
    {
      'q': 'Que signifie « Miles » ?',
      'rep': 'Le soldat / guerrier',
      'fausses': ['Le maître', 'Le juge', 'Le médecin'],
      'explication': 'Miles (génitif militis) a donné le mot « militaire ».',
    },
    {
      'q': 'Que signifie « Dux » ?',
      'rep': 'Le chef / général',
      'fausses': ['Le prisonnier', 'L\'artisan', 'L\'esclave'],
      'explication': 'Dux (génitif ducis) vient de ducere (mener) et a donné « duc ».',
    },
    {
      'q': 'Que signifie « Hostis » ?',
      'rep': 'L\'ennemi',
      'fausses': ['L\'ami', 'L\'invité', 'Le voisin'],
      'explication': 'Hostis désignait l\'ennemi public en temps de guerre (d\'où « hostile »).',
    },
    {
      'q': 'Quel suffixe caractérise l\'imparfait latin ?',
      'rep': '-ba-',
      'fausses': ['-vi-', '-re-', '-isse-'],
      'explication': 'Exemples : amabam (j\'aimais), legebam (je lisais).',
    },
    {
      'q': 'Que signifie « Veni, vidi, vici » prononcé par César ?',
      'rep': 'Je suis venu, j\'ai vu, j\'ai vaincu',
      'fausses': ['Vivre, aimer, mourir', 'Parler, écouter, comprendre', 'Courir, sauter, gagner'],
      'explication': 'Trois parfaits historiques concis annonçant la victoire éclair de Zéla.',
    },
    {
      'q': 'Que signifie « Alea iacta est » ?',
      'rep': 'Le sort en est jeté',
      'fausses': ['La guerre commence', 'La paix est signée', 'Les dés sont perdus'],
      'explication': 'Phrase attribuée à César franchissant le fleuve Rubicon en 49 av. J.-C.',
    },
    {
      'q': 'Que disaient les gladiateurs : « Morituri te salutant » ?',
      'rep': 'Ceux qui vont mourir te saluent',
      'fausses': ['Nous combattons pour la gloire', 'Donne-nous la vie', 'Rome est invincible'],
      'explication': 'Salut traditionnel adressé à l\'empereur avant le combat à mort.',
    },
    {
      'q': 'Qui est le roi de l\'Olympe brandissant la foudre ?',
      'rep': 'Jupiter',
      'fausses': ['Pluton', 'Neptune', 'Saturne'],
      'explication': 'Jupiter (Zeus en grec), dieu suprême de la justice et du ciel.',
    },
    {
      'q': 'Quelle déesse romaine incarne la sagesse et la stratégie ?',
      'rep': 'Minerve',
      'fausses': ['Vénus', 'Diane', 'Cérès'],
      'explication': 'Minerve (Athéna), née tout armée de la tête de Jupiter.',
    },
    {
      'q': 'Comment s\'appelle le corps d\'armée d\'élite de 5000 soldats ?',
      'rep': 'La Légion (Legio)',
      'fausses': ['La Cohorte', 'La Centurie', 'Le Manipule'],
      'explication': 'La légion romaine était l\'unité tactique redoutable de la République et de l\'Empire.',
    },
    {
      'q': 'Quel officier commande une centurie d\'environ 80 hommes ?',
      'rep': 'Le Centurion',
      'fausses': ['Le Tribun', 'Le Légat', 'Le Préfet'],
      'explication': 'Le centurion portait un casque à crête transversale pour être repéré au combat.',
    },
    {
      'q': 'Comment appelle-t-on la célèbre formation sous les boucliers ?',
      'rep': 'La Tortue (Testudo)',
      'fausses': ['Le Hérisson', 'L\'Aigle', 'Le Bélier'],
      'explication': 'Les boucliers imbriqués au-dessus et sur les flancs repoussaient flèches et javelines.',
    },
    {
      'q': 'Que signifie l\'abréviation « SPQR » ?',
      'rep': 'Le Sénat et le Peuple Romain',
      'fausses': ['Rome Pour Toujours', 'Paix et Victoire Romaine', 'Gloire à l\'Empire'],
      'explication': 'Senatus Populusque Romanus, la formule souveraine de l\'État romain.',
    },
    {
      'q': 'Que signifie « Virtus » chez les Romains ?',
      'rep': 'Le courage viril et la vaillance',
      'fausses': ['La faiblesse', 'La fuite', 'L\'argent'],
      'explication': 'Virtus (de vir, l\'homme) désigne le courage indomptable au combat.',
    },
    {
      'q': 'Que désigne « Castra » en latin ?',
      'rep': 'Le camp militaire fortifié',
      'fausses': ['Le château', 'La maison de campagne', 'La prison'],
      'explication': 'Castra (pluriel neutre) donne « castrum » et les terminaisons de villes (-chester).',
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
  bool _playerRiposteAnim = false;
  String? _floatingCombatText;
  bool _floatingCombatIsHero = false;
  final GlobalKey<RomanScreenShakeState> _shakeKey = GlobalKey<RomanScreenShakeState>();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _initBoss();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showBossEntranceCinematic();
      }
    });
  }

  void _showBossEntranceCinematic() {
    final boss = _bosses[_currentBossIndex];
    RomanCinematicOverlay.showBossEntrance(
      context,
      bossName: boss['nom'] as String,
    );
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
    if (_duelDeck.isEmpty) {
      _duelDeck = List<Map<String, dynamic>>.from(_duelQuestions)..shuffle();
    }
    _currentQ = _duelDeck.removeAt(0);
    final options = <String>[
      _currentQ['rep'] as String,
      ...(_currentQ['fausses'] as List<String>),
    ];
    options.shuffle();
    _shuffledChoices = options;
    _chosenAnswer = null;
    _animatingHit = false;
    _playerRiposteAnim = false;
    _floatingCombatText = null;
    _questionStartTime = DateTime.now();
  }

  void _onOptionTapped(String answer) {
    if (_chosenAnswer != null || _combatFini) return;

    final isCorrect = (answer == _currentQ['rep']);
    final boss = _bosses[_currentBossIndex];
    final elapsedSec = DateTime.now().difference(_questionStartTime).inSeconds;

    setState(() {
      _chosenAnswer = answer;
    });

    if (isCorrect) {
      HapticFeedback.heavyImpact();
      AudioService().playSwordClash();
      AudioService().playSesterces();
      RomanLottieEffects.showSwordClash(context);
      RomanParticlesOverlay.show(context, type: ParticleType.marbleSparks);

      int degats = (35 * _currentStance.damageMult).round();
      int sestercesEarned = 15;
      final isCrit = (_currentStance == CombatStance.celox && elapsedSec <= 4);

      if (isCrit) {
        degats = (degats * 1.25).round();
        sestercesEarned += 10;
        _shakeKey.currentState?.shake(intensity: ShakeIntensity.heavy);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: RomanColors.laurelGreen,
            duration: Duration(seconds: 1),
            content: Text('⚡ Coup Critique & Célérité ! (+10 HS)'),
          ),
        );
      } else {
        _shakeKey.currentState?.shake(intensity: ShakeIntensity.medium);
      }

      setState(() {
        _bossHp = math.max(0, _bossHp - degats);
        _gainsSesterces += sestercesEarned;
        _currentBossSpeech = boss['tauntBlesse'] as String?;
        _floatingCombatText = isCrit ? '⚡ CRITIQUE -$degats HP !' : '⚔️ -$degats HP !';
        _floatingCombatIsHero = true;
        _animatingHit = true;
        _playerRiposteAnim = false;
      });

      if (_bossHp <= 0) {
        _terminerCombat(victoire: true);
        return;
      }
    } else {
      HapticFeedback.vibrate();
      AudioService().playError();
      _shakeKey.currentState?.shake(intensity: ShakeIntensity.heavy);
      final baseRiposte = boss['attaque'] as int;
      final riposte = (baseRiposte * _currentStance.riposteMult).round();

      setState(() {
        _playerHp = math.max(0, _playerHp - riposte);
        _currentBossSpeech = boss['tauntAttaque'] as String?;
        _floatingCombatText = '🛡️ RIPOSTE -$riposte HP !';
        _floatingCombatIsHero = false;
        _animatingHit = false;
        _playerRiposteAnim = true;
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

      // Cinématique de triomphe impérial lors de la victoire contre le boss ultime
      if (_currentBossIndex == _bosses.length - 1) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            RomanCinematicOverlay.showTriumph(
              context,
              rankTitle: 'Grand Vainqueur du Colisée',
            );
          }
        });
      }
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
                margin: const EdgeInsets.only(right: 6),
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
                      '+$_gainsSesterces (${widget.repo.profile.sesterces} HS)',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF7A5901)),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.movie_creation_outlined, color: RomanColors.imperialGold),
                tooltip: 'Revoir la Cinématique du Boss',
                onPressed: _showBossEntranceCinematic,
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
      body: RomanScreenShake(
        key: _shakeKey,
        child: SafeArea(
          child: Column(
            children: [
              const RomanMeanderDivider(height: 10, color: RomanColors.imperialGold),
              // 1. Arène & Jauges de Vie
              Expanded(
                flex: 5,
                child: ColosseumArenaBackdrop(
                  child: _buildArenaView(boss),
                ),
              ),

              // 2. Panneau Question / Énigme ou Victoire
              Expanded(
                flex: 5,
                child: _combatFini ? _buildVictoryPanel(boss) : _buildQuizPanel(),
              ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }

  Widget _buildArenaView(Map<String, dynamic> boss) {
    final isGirl = widget.repo.profile.genre == 'fille';
    final heroAvatar = isGirl
        ? 'assets/images/avatar_fille_medaillon_140.png'
        : 'assets/images/avatar_garcon_medaillon_140.png';
    final heroName = widget.repo.profile.nomHeros.isNotEmpty
        ? widget.repo.profile.nomHeros
        : (isGirl ? 'Julia' : 'Marcus');

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 1. Barres de Vie Épiques en Marbre & Or Antique
          Row(
            children: [
              // Jauge Héros (Joueur)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xDD0D1B2A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                    boxShadow: const [
                      BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text('🛡️ ', style: TextStyle(fontSize: 11)),
                              Text(
                                heroName.toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFFFFE082),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.5,
                                  fontFamily: 'serif',
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$_playerHp/100',
                            style: TextStyle(
                              color: _playerHp > 30 ? Colors.greenAccent : Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Stack(
                          children: [
                            Container(height: 8, color: const Color(0xFF1B263B)),
                            AnimatedFractionallySizedBox(
                              duration: const Duration(milliseconds: 300),
                              widthFactor: (_playerHp / 100.0).clamp(0.0, 1.0),
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: _playerHp > 30
                                        ? [const Color(0xFF00E676), const Color(0xFF00B0FF)]
                                        : [const Color(0xFFFF1744), const Color(0xFFFF9100)],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Médaillon VS central
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2E0811),
                  border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                  boxShadow: const [
                    BoxShadow(color: Color(0x66FFD700), blurRadius: 8),
                  ],
                ),
                child: const Text(
                  'VS',
                  style: TextStyle(
                    color: RomanColors.imperialGold,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    fontFamily: 'serif',
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Jauge Champion Boss
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xDD2B0E14),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFD43737), width: 1.2),
                    boxShadow: const [
                      BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$_bossHp/${boss['maxHp']}',
                            style: const TextStyle(
                              color: Color(0xFFFF8A80),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                (boss['nom'] as String).toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFFFF8A80),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.5,
                                  fontFamily: 'serif',
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const Text(' ⚔️', style: TextStyle(fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Stack(
                          children: [
                            Container(height: 8, color: const Color(0xFF3E151D)),
                            AnimatedFractionallySizedBox(
                              duration: const Duration(milliseconds: 300),
                              widthFactor: (_bossHp / (boss['maxHp'] as int)).clamp(0.0, 1.0),
                              child: Container(
                                height: 8,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFFFF5252), Color(0xFFFF9100)],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 2. Face-à-Face des Combattants dans l'Arène
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Héros Joueur (Gauche)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, _) {
                        final heroScale = _playerRiposteAnim
                            ? 0.88
                            : 1.0 + (_pulseController.value * 0.03);
                        return Transform.scale(
                          scale: heroScale,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _playerRiposteAnim
                                          ? Colors.redAccent.withOpacity(0.7)
                                          : const Color(0xFF00B0FF).withOpacity(0.35),
                                      blurRadius: 16,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 82,
                                height: 82,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _playerRiposteAnim ? Colors.redAccent : RomanColors.imperialGold,
                                    width: 2.5,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    heroAvatar,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Center(
                                      child: Text('🛡️', style: TextStyle(fontSize: 32)),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: RomanColors.imperialGold, width: 0.8),
                                  ),
                                  child: Text(
                                    _currentStance.nom.toUpperCase(),
                                    style: const TextStyle(
                                      color: RomanColors.imperialGold,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '🛡️ $heroName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.5,
                        fontFamily: 'serif',
                      ),
                    ),
                  ],
                ),

                // Centre d'Affrontement avec Dégâts Flottants & Glaives Croisés
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_floatingCombatText != null)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _floatingCombatIsHero ? const Color(0xFFB71C1C) : const Color(0xFF7F0000),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                          boxShadow: const [
                            BoxShadow(color: Color(0x66FFD700), blurRadius: 8),
                          ],
                        ),
                        child: Text(
                          _floatingCombatText!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 22),

                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, _) {
                        return Transform.rotate(
                          angle: (_animatingHit ? 0.3 : 0.0) + (math.sin(_pulseController.value * math.pi) * 0.08),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0x66000000),
                              border: Border.all(color: RomanColors.imperialGold.withOpacity(0.5)),
                            ),
                            child: const Text('⚔️', style: TextStyle(fontSize: 22)),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'COLOSSEUM',
                      style: TextStyle(
                        color: RomanColors.imperialGold,
                        fontSize: 8.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),

                // Champion Boss (Droite) avec Torches Animées
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, _) {
                        final bossScale = _animatingHit
                            ? 0.88
                            : 1.0 + (_pulseController.value * 0.03);
                        return Transform.scale(
                          scale: bossScale,
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                right: -14,
                                top: -6,
                                child: Image.asset(
                                  'assets/images/animated/flambeau_flamme.webp',
                                  width: 22,
                                  height: 38,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _animatingHit
                                          ? Colors.redAccent.withOpacity(0.8)
                                          : Colors.deepOrangeAccent.withOpacity(0.4),
                                      blurRadius: 16,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 82,
                                height: 82,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _animatingHit ? Colors.redAccent : const Color(0xFFFF7043),
                                    width: 2.5,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    boss['image'] as String,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Center(
                                      child: Text('⚔️', style: TextStyle(fontSize: 32)),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3E151D),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: const Color(0xFFFF8A80), width: 0.8),
                                  ),
                                  child: Text(
                                    '${boss['titre']}'.toUpperCase(),
                                    style: const TextStyle(
                                      color: Color(0xFFFF8A80),
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '⚔️ ${boss['nom']}',
                      style: const TextStyle(
                        color: Colors.amberAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.5,
                        fontFamily: 'serif',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 3. Dialogue / Taunt du Boss
          if (_currentBossSpeech != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xDD3E151D),
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
              '« ${boss['citation']} »',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic, fontSize: 10.5),
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
          if (_chosenAnswer != null) ...[
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: (_chosenAnswer == _currentQ['rep'])
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (_chosenAnswer == _currentQ['rep'])
                      ? Colors.green.shade600
                      : Colors.orange.shade700,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    (_chosenAnswer == _currentQ['rep']) ? '⚔️ Frappe réussie !' : '🛡️ Riposte subie !',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: (_chosenAnswer == _currentQ['rep'])
                          ? Colors.green.shade800
                          : Colors.orange.shade900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _currentQ['explication'] as String? ?? 'Réponse attendue : ${_currentQ['rep']}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: (_chosenAnswer == _currentQ['rep'])
                            ? Colors.green.shade900
                            : Colors.brown.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
          if (_victoire) ...[
            Image.asset(
              'assets/images/victoire_320.png',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox(),
            ),
            const SizedBox(height: 8),
          ],
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
                const Text(
                  '+',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7A5901),
                  ),
                ),
                RollingSestercesCounter(
                  value: _victoire ? _gainsSesterces + 50 : 5,
                  initialValue: 0,
                  showIcon: false,
                  duration: const Duration(milliseconds: 900),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7A5901),
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'remportés',
                  style: TextStyle(
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
                    _showBossEntranceCinematic();
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
