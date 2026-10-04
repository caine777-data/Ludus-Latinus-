import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/particles_overlay.dart';
import '../../core/game_juice.dart';
import '../../core/widgets.dart';
import '../../core/cinematic_player.dart';
import '../../../data/models/vocab_question.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import '../../core/avatar_assets.dart';

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
    '+10 pts et Coup Critique si réponse < 4s',
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

  String get nom => francais;
  String get titre => latin;
}


class DuelScreen extends StatefulWidget {
  final GameRepository repo;

  const DuelScreen({super.key, required this.repo});

  @override
  State<DuelScreen> createState() => _DuelScreenState();
}

class _DuelScreenState extends State<DuelScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;

  int _currentBossIndex = 0;
  CombatStance _currentStance = CombatStance.gravis;
  String? _currentBossSpeech;
  DateTime _questionStartTime = DateTime.now();

  final List<Map<String, dynamic>> _bosses = [
    {
      'nom': 'Crixus le Rétiaire',
      'court': 'Crixus', // pour la jauge, où le nom complet ne tient pas
      'titre': 'Gladiateur Vétéran',
      'image': 'assets/images/boss_retiaire_anime.webp',
      'video': 'assets/cinematics/boss_retiaire.mp4',
      'maxHp': 100,
      'attaque': 20,
      'citation': '« Mors aut gloria in harena ! »',
      'tauntBlesse': '« Bene pugnas, tiro ! Sed reticulum meum manet ! » (Bien battu ! Mais mon filet t\'attend !)',
      'tauntAttaque': '« Reticulum meum te capit ! Vae victis ! » (Mon filet te capture ! Malheur aux vaincus !)',
    },
    {
      'nom': 'Le Lion de Némée',
      'court': 'Le Lion', // pour la jauge, où le nom complet ne tient pas
      'titre': 'Fauve Légendaire',
      'image': 'assets/images/boss_lion_anime.webp',
      'video': 'assets/cinematics/boss_lion.mp4',
      'maxHp': 120,
      'attaque': 25,
      'citation': '« Rugitus leonis terram commovet ! »',
      'tauntBlesse': '« Grrr ! Pellis mea invulnerabilis est ! » (Ma peau est invulnérable !)',
      'tauntAttaque': '« Ungues mei ferrum penetrant ! » (Mes griffes percent le fer !)',
    },
    {
      'nom': 'Le Minotaure',
      'court': 'Le Minotaure', // pour la jauge, où le nom complet ne tient pas
      'titre': 'Gardien du Labyrinthe',
      'image': 'assets/images/boss_minotaure_anime.webp',
      'video': 'assets/cinematics/boss_minotaure.mp4',
      'maxHp': 140,
      'attaque': 30,
      'citation': '« Nullus exitus e labyrintho patet ! »',
      'tauntBlesse': '« Dolor me fortem reddit ! » (La douleur me rend plus fort !)',
      'tauntAttaque': '« Cornua mea te prosternent ! » (Mes cornes vont te terrasser !)',
    },
    {
      'nom': 'Le Sphinx de Thèbes',
      'court': 'Le Sphinx', // pour la jauge, où le nom complet ne tient pas
      'titre': 'Maître des Énigmes',
      'image': 'assets/images/boss_sphinx_anime.webp',
      'video': 'assets/cinematics/boss_sphinx.mp4',
      'maxHp': 160,
      'attaque': 35,
      'citation': '« Solve aenigma aut peri ! »',
      'tauntBlesse': '« Ingenium tuum me miratur... » (Ton esprit m\'étonne...)',
      'tauntAttaque': '« Ignorantia tua te damnat ! » (Ton ignorance te condamne !)',
    },
    {
      'nom': 'Mercure Céleste',
      'court': 'Mercure', // pour la jauge, où le nom complet ne tient pas
      'titre': 'Messager des Dieux',
      'image': 'assets/images/boss_mercure_anime.webp',
      'video': 'assets/cinematics/boss_mercure.mp4',
      'maxHp': 180,
      'attaque': 40,
      'citation': '« Celeritas deorum vincit omnia ! »',
      'tauntBlesse': '« Fulgur Iovis te adiuvat ! » (L\'éclair de Jupiter t\'assiste !)',
      'tauntAttaque': '« Tardus es sicut testudo ! » (Tu es lent comme une tortue !)',
    },
  ];

  List<Map<String, dynamic>> _duelDeck = [];

  // `monde` : rang du monde où la notion est enseignée. Une question n'est
  // posée qu'à l'élève qui a atteint ce monde (voir _questionsDuJoueur).
  final List<Map<String, dynamic>> _duelQuestions = [
    {
      'monde': 4,
      'q': 'Que signifie « Lupus » ?',
      'rep': 'Le loup',
      'fausses': ['Le lièvre', 'La lune', 'Le lynx'],
      'explication': 'Lupus (m.) désigne le loup. La louve (lupa) allaita Romulus et Rémus.',
    },
    {
      'monde': 4,
      'q': 'Quel est le cas du sujet et de son attribut en latin ?',
      'rep': 'Le Nominatif',
      'fausses': ['L\'Accusatif', 'L\'Ablatif', 'Le Datif'],
      'explication': 'Le nominatif est le premier cas de la déclinaison, fonction sujet.',
    },
    {
      'monde': 4,
      'q': 'Quel cas latin exprime le Complément d\'Objet Direct (COD) ?',
      'rep': 'L\'Accusatif',
      'fausses': ['Le Génitif', 'Le Datif', 'L\'Ablatif'],
      'explication': 'L\'accusatif marque le patient ou but de l\'action (terminaison en -m au singulier).',
    },
    {
      'monde': 11,
      'q': 'Quel cas latin exprime la possession (complément du nom) ?',
      'rep': 'Le Génitif',
      'fausses': ['Le Datif', 'L\'Ablatif', 'Le Vocatif'],
      'explication': 'Le génitif indique l\'appartenance (ex: Gladius Caesaris = le glaive de César).',
    },
    {
      'monde': 12,
      'q': 'Quel cas latin correspond au COI et à l\'attribution ?',
      'rep': 'Le Datif',
      'fausses': ['L\'Accusatif', 'Le Nominatif', 'L\'Ablatif'],
      'explication': 'Le datif sert à indiquer à qui ou pour qui l\'action est faite.',
    },
    {
      'monde': 12,
      'q': 'Quel cas exprime les compléments de moyen, de temps et de lieu ?',
      'rep': 'L\'Ablatif',
      'fausses': ['Le Vocatif', 'Le Génitif', 'L\'Accusatif'],
      'explication': 'L\'ablatif synthétise l\'instrumental, le séparatif et le locatif.',
    },
    {
      'monde': 1,
      'q': 'Quel cas sert à interpeller directement quelqu\'un ?',
      'rep': 'Le Vocatif',
      'fausses': ['Le Datif', 'Le Nominatif', 'L\'Accusatif'],
      'explication': 'Exemple célèbre : « Ave, Caesar ! » ou « Tu quoque, mi fili ! ».',
    },
    {
      'monde': 14,
      'q': 'Que signifie « Bellum » ?',
      'rep': 'La guerre',
      'fausses': ['La beauté', 'Le bœuf', 'La boisson'],
      'explication': 'Bellum (n.) donne « belligérant », « belliqueux » et « rébellion ».',
    },
    {
      'monde': 19,
      'q': 'Que signifie « Pax » ?',
      'rep': 'La paix',
      'fausses': ['Le pain', 'Le mur', 'Le pas'],
      'explication': 'Pax Romana désignait la longue période de paix impériale.',
    },
    {
      'monde': 3,
      'q': 'Qui est le dieu romain de la guerre ?',
      'rep': 'Mars',
      'fausses': ['Jupiter', 'Neptune', 'Vulcain'],
      'explication': 'Mars, équivalent d\'Arès chez les Grecs, est l\'ancêtre des Romains.',
    },
    {
      'monde': 9,
      'q': 'Que signifie « Gladius » ?',
      'rep': 'Le glaive',
      'fausses': ['Le bouclier', 'Le casque', 'La lance'],
      'explication': 'L\'épée courte à double tranchant des légionnaires, d\'où « gladiateur ».',
    },
    {
      'monde': 6,
      'q': 'Comment s\'appelle le grand bouclier rectangulaire romain ?',
      'rep': 'Le Scutum',
      'fausses': ['La Lorica', 'Le Pilum', 'La Galea'],
      'explication': 'Le scutum courbé protégeait le corps et formait la fameuse tortue.',
    },
    {
      'monde': 9,
      'q': 'Que désigne le « Pilum » lancé par les légionnaires ?',
      'rep': 'Le javelot lourd',
      'fausses': ['La flèche', 'Le bouclier', 'La dague'],
      'explication': 'Le pilum avait une pointe en fer doux conçue pour se tordre après impact.',
    },
    {
      'monde': 9,
      'q': 'Comment appelle-t-on le casque de bronze du guerrier romain ?',
      'rep': 'La Galea',
      'fausses': ['La Caliga', 'Le Sagum', 'La Balteus'],
      'explication': 'La galea protégeait la tête, les joues et la nuque.',
    },
    {
      'monde': 12,
      'q': 'Que signifie « Rex » (3e déclinaison) ?',
      'rep': 'Le roi',
      'fausses': ['La loi', 'La reine', 'Le chef'],
      'explication': 'Rex (génitif regis) donne « royal », « régime » et « souverain ».',
    },
    {
      'monde': 11,
      'q': 'Que signifie « Civis » ?',
      'rep': 'Le citoyen',
      'fausses': ['Le paysan', 'Le marchand', 'Le marin'],
      'explication': 'Civis donne citoyen, civil et civilité. « Civis Romanus sum ! ».',
    },
    {
      'monde': 17,
      'q': 'Que signifie « Urbs » ?',
      'rep': 'La ville',
      'fausses': ['Le champ', 'La forêt', 'La colline'],
      'explication': 'Urbs désigne la ville fortifiée, et par excellence la cité de Rome.',
    },
    {
      'monde': 5,
      'q': 'Que signifie « Miles » ?',
      'rep': 'Le soldat / guerrier',
      'fausses': ['Le maître', 'Le juge', 'Le médecin'],
      'explication': 'Miles (génitif militis) a donné le mot « militaire ».',
    },
    {
      'monde': 12,
      'q': 'Que signifie « Dux » ?',
      'rep': 'Le chef / général',
      'fausses': ['Le prisonnier', 'L\'artisan', 'L\'esclave'],
      'explication': 'Dux (génitif ducis) vient de ducere (mener) et a donné « duc ».',
    },
    {
      'monde': 13,
      'q': 'Que signifie « Hostis » ?',
      'rep': 'L\'ennemi',
      'fausses': ['L\'ami', 'L\'invité', 'Le voisin'],
      'explication': 'Hostis désignait l\'ennemi public en temps de guerre (d\'où « hostile »).',
    },
    {
      'monde': 15,
      'q': 'Quel suffixe caractérise l\'imparfait latin ?',
      'rep': '-ba-',
      'fausses': ['-vi-', '-re-', '-isse-'],
      'explication': 'Exemples : amabam (j\'aimais), legebam (je lisais).',
    },
    {
      'monde': 7,
      'q': 'Que signifie « Veni, vidi, vici » prononcé par César ?',
      'rep': 'Je suis venu, j\'ai vu, j\'ai vaincu',
      'fausses': ['Vivre, aimer, mourir', 'Parler, écouter, comprendre', 'Courir, sauter, gagner'],
      'explication': 'Trois parfaits historiques concis annonçant la victoire éclair de Zéla.',
    },
    {
      'monde': 17,
      'q': 'Que signifie « Alea iacta est » ?',
      'rep': 'Le sort en est jeté',
      'fausses': ['La guerre commence', 'La paix est signée', 'Les dés sont perdus'],
      'explication': 'Phrase attribuée à César franchissant le fleuve Rubicon en 49 av. J.-C.',
    },
    {
      'monde': 6,
      'q': 'Que disaient les gladiateurs : « Morituri te salutant » ?',
      'rep': 'Ceux qui vont mourir te saluent',
      'fausses': ['Nous combattons pour la gloire', 'Donne-nous la vie', 'Rome est invincible'],
      'explication': 'Salut traditionnel adressé à l\'empereur avant le combat à mort.',
    },
    {
      'monde': 3,
      'q': 'Qui est le roi de l\'Olympe brandissant la foudre ?',
      'rep': 'Jupiter',
      'fausses': ['Pluton', 'Neptune', 'Saturne'],
      'explication': 'Jupiter (Zeus en grec), dieu suprême de la justice et du ciel.',
    },
    {
      'monde': 3,
      'q': 'Quelle déesse romaine incarne la sagesse et la stratégie ?',
      'rep': 'Minerve',
      'fausses': ['Vénus', 'Diane', 'Cérès'],
      'explication': 'Minerve (Athéna), née tout armée de la tête de Jupiter.',
    },
    {
      'monde': 9,
      'q': 'Comment s\'appelle le corps d\'armée d\'élite de 5000 soldats ?',
      'rep': 'La Légion (Legio)',
      'fausses': ['La Cohorte', 'La Centurie', 'Le Manipule'],
      'explication': 'La légion romaine était l\'unité tactique redoutable de la République et de l\'Empire.',
    },
    {
      'monde': 9,
      'q': 'Quel officier commande une centurie d\'environ 80 hommes ?',
      'rep': 'Le Centurion',
      'fausses': ['Le Tribun', 'Le Légat', 'Le Préfet'],
      'explication': 'Le centurion portait un casque à crête transversale pour être repéré au combat.',
    },
    {
      'monde': 9,
      'q': 'Comment appelle-t-on la célèbre formation sous les boucliers ?',
      'rep': 'La Tortue (Testudo)',
      'fausses': ['Le Hérisson', 'L\'Aigle', 'Le Bélier'],
      'explication': 'Les boucliers imbriqués au-dessus et sur les flancs repoussaient flèches et javelines.',
    },
    {
      'monde': 12,
      'q': 'Que signifie l\'abréviation « SPQR » ?',
      'rep': 'Le Sénat et le Peuple Romain',
      'fausses': ['Rome Pour Toujours', 'Paix et Victoire Romaine', 'Gloire à l\'Empire'],
      'explication': 'Senatus Populusque Romanus, la formule souveraine de l\'État romain.',
    },
    {
      'monde': 11,
      'q': 'Que signifie « Virtus » chez les Romains ?',
      'rep': 'Le courage viril et la vaillance',
      'fausses': ['La faiblesse', 'La fuite', 'L\'argent'],
      'explication': 'Virtus (de vir, l\'homme) désigne le courage indomptable au combat.',
    },
    {
      'monde': 9,
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
  // Score du combat, en points : ce n'est plus de l'argent.
  int _gainsSesterces = 0;
  // Sesterces vraiment versés à la fin (0 si perdu ou quota du jour atteint).
  int _recompense = 0;

  late Map<String, dynamic> _currentQ;
  late List<String> _shuffledChoices;
  String? _chosenAnswer;
  String? _floatingCombatText;
  final GlobalKey<RomanScreenShakeState> _shakeKey = GlobalKey<RomanScreenShakeState>();

  // Assaut : l'attaquant s'élance, frappe, revient. [_assautHeros] dit qui attaque.
  late final AnimationController _assaut = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    value: 1,
  );
  bool _assautHeros = true;
  int _coups = 0;
  static const _imageImpact = AssetImage('assets/images/animated/duel_impact.webp');

  void _lancerAssaut({required bool heros}) {
    // L'impact animé rejoue depuis sa première image à chaque coup.
    _imageImpact.evict();
    setState(() {
      _assautHeros = heros;
      _coups++;
    });
    _assaut.forward(from: 0);
  }

  @override
  void initState() {
    super.initState();
    AudioService().enterMusic(MusicTrack.arene);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _initBoss();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showBossEntrance();
    });
  }

  void _showBossEntrance() {
    final boss = _bosses[_currentBossIndex];
    RomanCinematicOverlay.showBossEntrance(
      context,
      bossName: boss['nom'] as String,
      video: boss['video'] as String?,
    );
  }

  @override
  void dispose() {
    AudioService().leaveMusic(MusicTrack.arene);
    _pulseController.dispose();
    _assaut.dispose();
    _quizScroll.dispose();
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
      _recompense = 0;
      _currentBossSpeech = null;
      _nextQuestion();
    });
  }

  /// Le paquet de questions suit la progression : les questions fixes dont
  /// le monde est atteint, plus du vocabulaire tiré du Thesaurus des mondes
  /// atteints. Si le paquet est maigre (tout début), on le complète avec les
  /// questions fixes des mondes suivants, les plus proches d'abord.
  List<Map<String, dynamic>> _questionsDuJoueur() {
    final rang = widget.repo.rangMondeAtteint;
    final fixes = List<Map<String, dynamic>>.from(_duelQuestions)
      ..sort((a, b) => (a['monde'] as int).compareTo(b['monde'] as int));
    final deck = <Map<String, dynamic>>[
      ...fixes.where((q) => (q['monde'] as int) <= rang),
    ];
    final enonces = deck.map((q) => (q['q'] as String).toLowerCase()).toSet();
    for (final q in VocabQuestion.pourJeu(
      dictionary: widget.repo.thesaurus,
      mondes: widget.repo.mondesAtteints,
    )) {
      if (enonces.add((q['q'] as String).toLowerCase())) deck.add(q);
    }
    for (final q in fixes) {
      if (deck.length >= 12) break;
      if (!deck.contains(q)) deck.add(q);
    }
    return deck;
  }

  void _nextQuestion() {
    if (_duelDeck.isEmpty) {
      _duelDeck = _questionsDuJoueur()..shuffle();
    }
    _currentQ = _duelDeck.removeAt(0);
    final options = <String>[
      _currentQ['rep'] as String,
      ...(_currentQ['fausses'] as List<String>),
    ];
    options.shuffle();
    _shuffledChoices = options;
    _chosenAnswer = null;
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
      _serie++;
      if (widget.repo.enregistrerRecord('duel', _serie)) _nouveauRecord = true;
      HapticFeedback.heavyImpact();
      AudioService().playSwordClash();
      AudioService().playSesterces();
      _lancerAssaut(heros: true);

      int degats = (35 * _currentStance.damageMult).round();
      int sestercesEarned = 15;
      final isCrit = (_currentStance == CombatStance.celox && elapsedSec <= 4);

      if (isCrit) {
        degats = (degats * 1.25).round();
        sestercesEarned += 10;
        AudioService().playCrowdCheer();
        _shakeKey.currentState?.shake(intensity: ShakeIntensity.heavy);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: RomanColors.laurelGreen,
            duration: Duration(seconds: 1),
            content: Text('⚡ Coup Critique & Célérité ! (+10 pts)'),
          ),
        );
      } else {
        _shakeKey.currentState?.shake(intensity: ShakeIntensity.medium);
      }

      setState(() {
        _bossHp = math.max(0, _bossHp - degats);
        _gainsSesterces += sestercesEarned;
        _currentBossSpeech = boss['tauntBlesse'] as String?;
        _floatingCombatText = isCrit ? '⚡ CRITIQUE -$degats' : '-$degats';
      });

      if (_bossHp <= 0) {
        _terminerCombat(victoire: true);
        return;
      }
    } else {
      _serie = 0;
      HapticFeedback.vibrate();
      AudioService().playError();
      _shakeKey.currentState?.shake(intensity: ShakeIntensity.heavy);
      _lancerAssaut(heros: false);
      final baseRiposte = boss['attaque'] as int;
      final riposte = (baseRiposte * _currentStance.riposteMult).round();

      setState(() {
        _playerHp = math.max(0, _playerHp - riposte);
        _currentBossSpeech = boss['tauntAttaque'] as String?;
        _floatingCombatText = '-$riposte';
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
      // Un boss vaincu vaut un peu plus qu'une leçon, et seulement 3 fois par jour.
      // Avant : score + 50, sans limite.
      _recompense = widget.repo.payerPartie('duel', GameRepository.gainDuel);
      HapticFeedback.heavyImpact();
      AudioService().playSwordClash();
      AudioService().playCrowdCheer();
      AudioService().playTriumph();
      RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
    } else {
      _recompense = 0;
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
            title: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
              'COLOSSEUM',
              style: TextStyle(letterSpacing: 1.4, fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
            ),
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
                      '$_gainsSesterces pts (${widget.repo.profile.sesterces} HS)',
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
      body: RomanScreenShake(
        key: _shakeKey,
        child: SafeArea(
          child: Column(
            children: [
              const RomanMeanderDivider(height: 10, color: RomanColors.imperialGold),
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
      ),
    );
      },
    );
  }

  Widget _buildArenaView(Map<String, dynamic> boss) {
    final isGirl = widget.repo.profile.genre == 'fille';
    final heroAvatar = AvatarAssets.medaillon(widget.repo.profile);
    final heroName = widget.repo.profile.nomHeros.isNotEmpty
        ? widget.repo.profile.nomHeros
        : (isGirl ? 'Julia' : 'Marcus');

    return Stack(
      children: [
        // Le Colisée au crépuscule, assombri en haut et en bas pour que les
        // jauges et les répliques restent lisibles.
        Positioned.fill(
          child: Image.asset(
            'assets/images/duel/decor_colisee.webp',
            fit: BoxFit.cover,
            alignment: const Alignment(0, 0.35),
            errorBuilder: (_, __, ___) => const ColoredBox(color: Color(0xFF1B1622)),
          ),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xCC120E16), Color(0x22120E16), Color(0x33120E16), Color(0xCC120E16)],
                stops: [0, 0.3, 0.7, 1],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _jauge(
                      nom: heroName,
                      pv: _playerHp,
                      pvMax: 100,
                      couleur: _playerHp > 30 ? RomanColors.laurelGreen : const Color(0xFF8E1724),
                      bordure: RomanColors.imperialGold,
                      texte: const Color(0xFFFFE082),
                      aDroite: false,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF2E0811),
                      border: Border.all(color: RomanColors.imperialGold, width: 1.5),
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
                  Expanded(
                    child: _jauge(
                      nom: (boss['court'] ?? boss['nom']) as String,
                      pv: _bossHp,
                      pvMax: boss['maxHp'] as int,
                      couleur: const Color(0xFF8E1724),
                      bordure: const Color(0xFF8E1724),
                      texte: const Color(0xFFFF8A80),
                      aDroite: true,
                    ),
                  ),
                ],
              ),
              Expanded(child: _buildScene(boss, heroAvatar, heroName)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xDD3E151D),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                ),
                child: Text(
                  // Les répliques portent déjà leurs guillemets.
                  _combatFini && _victoire
                      ? '« Io triumphe ! » (Victoire, triomphe !)'
                      : _currentBossSpeech ?? boss['citation'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Jauge de vie : le nom s'abrège au lieu de déborder de l'écran.
  Widget _jauge({
    required String nom,
    required int pv,
    required int pvMax,
    required Color couleur,
    required Color bordure,
    required Color texte,
    required bool aDroite,
  }) {
    final libelle = Expanded(
      child: Text(
        nom.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: aDroite ? TextAlign.right : TextAlign.left,
        style: TextStyle(
          color: texte,
          fontWeight: FontWeight.bold,
          fontSize: 10.5,
          fontFamily: 'serif',
          letterSpacing: 0.5,
        ),
      ),
    );
    final chiffres = Text(
      '$pv/$pvMax',
      style: TextStyle(color: texte, fontWeight: FontWeight.bold, fontSize: 10),
    );
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xDD0D1B2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bordure, width: 1.2),
      ),
      child: Column(
        children: [
          Row(
            children: aDroite
                ? [chiffres, const SizedBox(width: 6), libelle]
                : [libelle, const SizedBox(width: 6), chiffres],
          ),
          const SizedBox(height: 5),
          RomanElasticProgressBar(
            value: (pv / pvMax).clamp(0.0, 1.0),
            color: couleur,
            ghostColor: const Color(0xFFFFD700).withValues(alpha: 0.5),
            backgroundColor: const Color(0xFF142132),
            height: 10,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      ),
    );
  }

  /// Le face-à-face sur le sable : respiration au repos, élan de l'attaquant,
  /// recul et flash rouge de celui qui encaisse, impact au point de contact.
  Widget _buildScene(Map<String, dynamic> boss, String heroAvatar, String heroName) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final taille = math.min(100.0, c.maxHeight * 0.58);
        final xHeros = w * 0.24;
        final xBoss = w * 0.76;
        final portee = math.max(0.0, (xBoss - xHeros) - taille * 1.05);
        final sol = c.maxHeight * 0.16;

        return AnimatedBuilder(
          animation: Listenable.merge([_pulseController, _assaut]),
          builder: (context, _) {
            final t = _assaut.value;
            // Aller (0 à 0,35), choc (0,35 à 0,5), retour (0,5 à 1).
            final elan = t < 0.35
                ? Curves.easeIn.transform(t / 0.35)
                : t < 0.5
                    ? 1.0
                    : 1 - Curves.easeOutCubic.transform((t - 0.5) / 0.5);
            final encaisse = t >= 0.35 && t < 0.95 ? math.sin((t - 0.35) / 0.6 * math.pi) : 0.0;
            final respire = math.sin(_pulseController.value * math.pi);

            final dxHeros = _assautHeros ? elan * portee : -encaisse * 16;
            final dxBoss = _assautHeros ? encaisse * 16 : -elan * portee;
            final xCible = _assautHeros ? xBoss - taille * 0.45 : xHeros + taille * 0.45;
            final yCentre = sol + taille / 2;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: xHeros - taille / 2 - 20 + dxHeros,
                  bottom: sol + respire * 3,
                  child: _combattant(
                    image: heroAvatar,
                    nom: heroName,
                    badge: _currentStance.nom,
                    taille: taille,
                    couleur: RomanColors.imperialGold,
                    touche: _assautHeros ? 0 : encaisse,
                    sens: -1,
                    vaincu: _combatFini && !_victoire,
                  ),
                ),
                Positioned(
                  left: xBoss - taille / 2 - 20 + dxBoss,
                  bottom: sol + (1 - respire) * 3,
                  child: _combattant(
                    image: boss['image'] as String,
                    nom: boss['nom'] as String,
                    badge: boss['titre'] as String,
                    taille: taille,
                    couleur: const Color(0xFFFF8A80),
                    touche: _assautHeros ? encaisse : 0,
                    sens: 1,
                    vaincu: _combatFini && _victoire,
                  ),
                ),
                if (t > 0.3 && t < 1)
                  Positioned(
                    left: xCible - taille * 0.9,
                    bottom: yCentre - taille * 0.9,
                    width: taille * 1.8,
                    height: taille * 1.8,
                    child: IgnorePointer(
                      child: Image(
                        key: ValueKey(_coups),
                        image: _imageImpact,
                        gaplessPlayback: true,
                      ),
                    ),
                  ),
                if (_floatingCombatText != null && t > 0.35 && t < 1)
                  Positioned(
                    left: xCible - 70,
                    width: 140,
                    bottom: yCentre + taille * 0.55 + (t - 0.35) * 40,
                    child: Opacity(
                      opacity: (1 - (t - 0.6) / 0.4).clamp(0.0, 1.0),
                      child: Text(
                        _floatingCombatText!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFFFE082),
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          shadows: [Shadow(color: Colors.black, blurRadius: 6)],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  /// Un combattant : médaillon, nom et badge. [touche] (0 à 1) le fait
  /// basculer vers l'arrière et rougir ; [sens] vaut -1 à gauche, 1 à droite.
  Widget _combattant({
    required String image,
    required String nom,
    required String badge,
    required double taille,
    required Color couleur,
    required double touche,
    required int sens,
    bool vaincu = false,
  }) {
    // Le vaincu bascule en arrière, s'enfonce et pâlit.
    return AnimatedSlide(
      offset: vaincu ? const Offset(0, 0.12) : Offset.zero,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        opacity: vaincu ? 0.45 : 1,
        duration: const Duration(milliseconds: 700),
        child: AnimatedRotation(
          turns: vaincu ? sens * 0.06 : 0,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutBack,
          child: _combattantPose(image, nom, badge, taille, couleur, touche, sens),
        ),
      ),
    );
  }

  Widget _combattantPose(
    String image,
    String nom,
    String badge,
    double taille,
    Color couleur,
    double touche,
    int sens,
  ) {
    return SizedBox(
      width: taille + 40,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.rotate(
            angle: sens * touche * 0.18,
            child: Container(
              width: taille,
              height: taille,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color.lerp(couleur, const Color(0xFFFF5252), touche)!,
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.lerp(
                      couleur.withValues(alpha: 0.35),
                      const Color(0xFFD32F2F),
                      touche,
                    )!,
                    blurRadius: 14 + touche * 10,
                    spreadRadius: 1 + touche * 3,
                  ),
                ],
              ),
              child: ClipOval(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Les boss ont un portrait animé ; le héros, une image fixe
                    // (elle change avec sa tenue) : on l'anime en respiration.
                    Transform.rotate(
                      angle: sens < 0 ? math.sin(_pulseController.value * math.pi * 2) * 0.035 : 0,
                      child: Transform.scale(
                        scale: sens < 0 ? 1.0 + 0.05 * math.sin(_pulseController.value * math.pi) : 1.0,
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Text('⚔️', style: TextStyle(fontSize: 32)),
                          ),
                        ),
                      ),
                    ),
                    // Flash rouge du coup encaissé.
                    ColoredBox(color: const Color(0xFFD32F2F).withValues(alpha: touche * 0.45)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: couleur, width: 0.8),
            ),
            child: Text(
              badge.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: couleur, fontSize: 8, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            nom,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 10.5,
              fontFamily: 'serif',
              shadows: [Shadow(color: Colors.black, blurRadius: 4)],
            ),
          ),
        ],
      ),
    );
  }

  final ScrollController _quizScroll = ScrollController();

  // Bonnes réponses d'affilée, d'un boss à l'autre : le record du Duel.
  int _serie = 0;
  bool _nouveauRecord = false;

  Widget _buildQuizPanel() {
    // Après une réponse, on amène le bandeau d'explication à l'écran s'il est sous le pli.
    if (_chosenAnswer != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_quizScroll.hasClients) return;
        final bas = _quizScroll.position.maxScrollExtent;
        if (bas > _quizScroll.offset) {
          _quizScroll.animateTo(bas, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
        }
      });
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFF9F6F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      // Le panneau défile : sur un petit téléphone, rien ne sort de l'écran
      // (ni les réponses du bas, ni le bandeau qui apparaît après la réponse).
      child: LayoutBuilder(
        builder: (context, contraintes) => SingleChildScrollView(
          controller: _quizScroll,
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
                                color: RomanColors.imperialPurple.withValues(alpha: 0.3),
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
              border: Border.all(color: RomanColors.imperialGold.withValues(alpha: 0.5)),
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

          SizedBox(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              // Cases plus basses quand la place manque, pour garder les
              // quatre réponses visibles sans faire défiler.
              childAspectRatio: contraintes.maxHeight < 300 ? 3.3 : 2.1,
              shrinkWrap: true,
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
        ),
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
      // Défilant : sur un petit écran, le panneau ne déborde plus.
      child: SingleChildScrollView(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_victoire) ...[
            Image.asset(
              lupulusAnimation(LupulusMood.triomphe),
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
                // Passe à la ligne au lieu de déborder sur un petit écran.
                Flexible(
                  child: Text(
                    _recompense > 0
                        ? '+$_recompense Sesterces remportés'
                        : _victoire
                            ? 'Pour la gloire : 3 duels payés par jour'
                            : 'Pas de sesterces cette fois',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7A5901),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _nouveauRecord
                ? '🏅 Nouveau record : ${widget.repo.record('duel')} bonnes réponses d\'affilée !'
                : 'Ton record : ${widget.repo.record('duel')} bonnes réponses d\'affilée',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: _nouveauRecord ? FontWeight.bold : FontWeight.w600,
              color: _nouveauRecord ? Colors.green.shade800 : Colors.black54,
            ),
          ),
          const SizedBox(height: 20),
          // Wrap : sur un écran étroit, le second bouton passe à la ligne.
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: RomanColors.imperialPurple,
                  side: const BorderSide(color: RomanColors.imperialPurple),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text('Quitter'),
              ),
              if (_victoire && _currentBossIndex < _bosses.length - 1)
                ElevatedButton.icon(
                  onPressed: () {
                    AudioService().playWheelClick();
                    setState(() {
                      _currentBossIndex++;
                      _initBoss();
                    });
                    _showBossEntrance();
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
      ),
    );
  }
}
