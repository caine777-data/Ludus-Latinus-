import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../core/particles_overlay.dart';

enum ModeCesar {
  missions,
  generateur,
  decodeur,
}

class MissionCesar {
  final String titre;
  final String dateContexte;
  final String explication;
  final int cle;
  final String messageChiffre;
  final String messageClair;
  final String traduction;
  final int gain;

  const MissionCesar({
    required this.titre,
    required this.dateContexte,
    required this.explication,
    required this.cle,
    required this.messageChiffre,
    required this.messageClair,
    required this.traduction,
    required this.gain,
  });
}

const List<MissionCesar> kMissionsCesar = [
  MissionCesar(
    titre: "Mission 1 : Le Camp de Quintus Cicéron",
    dateContexte: "Gaule, 54 av. J.-C.",
    explication: "Les Nerviens encerclent la légion romaine. César envoie un messager gaulois avec une lettre cryptée par la clé classique (+3).",
    cle: 3,
    messageChiffre: "FDHVDU TXLQWR VDOXWHP GLFLW. OHJLRQHV DGIXWXUDH VXQW !",
    messageClair: "CAESAR QUINTO SALUTEM DICIT. LEGIONES ADFUTURAE SUNT !",
    traduction: "« César salue Quintus. Les légions arrivent à la rescousse ! »",
    gain: 20,
  ),
  MissionCesar(
    titre: "Mission 2 : Le Franchissement du Rubicon",
    dateContexte: "Italie, 49 av. J.-C.",
    explication: "César défie le Sénat et décide de franchir la frontière sacrée avec la clé secrète (+5).",
    cle: 5,
    messageChiffre: "FQJF NFHYF JXY. WTRF SNYNIJY !",
    messageClair: "ALEA IACTA EST. ROMA NITIDET !",
    traduction: "« Le sort en est jeté. Rome resplendit ! »",
    gain: 25,
  ),
  MissionCesar(
    titre: "Mission 3 : La Victoire d'Alésia",
    dateContexte: "Alésia, 52 av. J.-C.",
    explication: "Les lignes de circonvallation subissent l'assaut final. César transmet la consigne suprême avec la clé (+4).",
    cle: 4,
    messageChiffre: "ZMVI UYMWUYI ERMQEW ! ZMGXSVME RMXMHIX !",
    messageClair: "VIRE QUISQUE ANIMAS ! VICTORIA NITIDET !",
    traduction: "« Que chacun ranime son courage ! La victoire rayonne ! »",
    gain: 30,
  ),
];

class CesarScreen extends StatefulWidget {
  final GameRepository repo;

  const CesarScreen({super.key, required this.repo});

  @override
  State<CesarScreen> createState() => _CesarScreenState();
}

class _CesarScreenState extends State<CesarScreen> with SingleTickerProviderStateMixin {
  int _cleActuelle = 1;
  int _missionIndex = 0;
  ModeCesar _modeActuel = ModeCesar.missions;
  final TextEditingController _saisieControleur = TextEditingController(text: "VENI VIDI VICI");
  final TextEditingController _decodeurControleur = TextEditingController(text: "PHGLFRV VXQW FDHVDU");
  final Set<int> _missionsReussies = {};
  final Set<String> _messagesAmiDechiffres = {};
  MissionCesar get _missionActuelle => kMissionsCesar[_missionIndex % kMissionsCesar.length];

  @override
  void dispose() {
    _saisieControleur.dispose();
    _decodeurControleur.dispose();
    super.dispose();
  }

  int? _calculerCleFrequence(String texte) {
    final counts = <int, int>{};
    final upper = texte.toUpperCase();
    for (int i = 0; i < upper.length; i++) {
      final code = upper.codeUnitAt(i);
      if (code >= 65 && code <= 90) {
        counts[code] = (counts[code] ?? 0) + 1;
      }
    }
    if (counts.isEmpty) return null;
    var maxChar = 65;
    var maxCount = -1;
    counts.forEach((c, cnt) {
      if (cnt > maxCount) {
        maxCount = cnt;
        maxChar = c;
      }
    });
    // Lettre la plus fréquente en Latin / Français = E (code ASCII 69)
    return (maxChar - 69 + 26) % 26;
  }

  String _genererEpitreFormatee(String texteChiffre, int cle) {
    return '''
🏛️ *EPISTVLA SECRETA SPQR* 🏛️
Ad amicos scriptum sub sigillo Caesaris.
══════════════════════════════
$texteChiffre
══════════════════════════════
🗝️ Clavis Caesaris : +$cle
🛑 Sigillum Imperatoris C. Ivlivs Caesar''';
  }

  String _appliquerDecalage(String texte, int decalage) {
    final buffer = StringBuffer();
    final k = (decalage % 26 + 26) % 26;

    for (int i = 0; i < texte.length; i++) {
      final code = texte.codeUnitAt(i);
      if (code >= 65 && code <= 90) {
        // Majuscule A-Z
        buffer.writeCharCode((code - 65 + k) % 26 + 65);
      } else if (code >= 97 && code <= 122) {
        // Minuscule a-z
        buffer.writeCharCode((code - 97 + k) % 26 + 97);
      } else {
        buffer.write(texte[i]);
      }
    }
    return buffer.toString();
  }

  void _modifierCle(int delta) {
    HapticFeedback.selectionClick();
    AudioService().playWheelClick();
    setState(() {
      _cleActuelle = (_cleActuelle + delta) % 26;
      if (_cleActuelle < 0) _cleActuelle += 26;
    });
    _verifierMission();
  }

  void _setCle(int valeur) {
    HapticFeedback.selectionClick();
    AudioService().playWheelClick();
    setState(() {
      _cleActuelle = valeur % 26;
    });
    _verifierMission();
  }

  void _verifierMission() {
    if (_modeActuel != ModeCesar.missions) return;
    final mission = _missionActuelle;
    if (_cleActuelle == mission.cle && !_missionsReussies.contains(_missionIndex)) {
      HapticFeedback.mediumImpact();
      AudioService().playTriumph();
      AudioService().playSesterces();
      RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
      widget.repo.addSesterces(mission.gain);
      setState(() {
        _missionsReussies.add(_missionIndex);
      });
      _afficherVictoireMission(mission);
    }
  }

  void _afficherVictoireMission(MissionCesar mission) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: RomanColors.travertine,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: RomanColors.imperialGold, width: 2),
        ),
        title: const Row(
          children: [
            Text('🦅', style: TextStyle(fontSize: 26)),
            SizedBox(width: 8),
            Text(
              'Message Déchiffré !',
              style: TextStyle(
                color: RomanColors.imperialPurple,
                fontWeight: FontWeight.bold,
                fontFamily: 'serif',
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mission.titre,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF7A5901)),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: RomanColors.imperialGold),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.messageClair,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: RomanColors.imperialPurple,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mission.traduction,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('🪙', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  '+${mission.gain} Sesterces remportés !',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: RomanColors.laurelGreen),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CONTINUER', style: TextStyle(color: RomanColors.imperialPurple, fontWeight: FontWeight.bold)),
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
        final mission = _missionActuelle;
        final String texteDechiffre;
        switch (_modeActuel) {
          case ModeCesar.missions:
            texteDechiffre = _appliquerDecalage(mission.messageChiffre, -_cleActuelle);
            break;
          case ModeCesar.generateur:
            texteDechiffre = _appliquerDecalage(_saisieControleur.text, _cleActuelle);
            break;
          case ModeCesar.decodeur:
            texteDechiffre = _appliquerDecalage(_decodeurControleur.text, -_cleActuelle);
            break;
        }

        final estCleValide = _modeActuel == ModeCesar.missions && _cleActuelle == mission.cle;

        return Scaffold(
          appBar: AppBar(
            title: const Text('📜 L\'Atelier Secret de César'),
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
                      '${widget.repo.profile.sesterces} HS',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF7A5901)),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.swap_horiz),
                tooltip: 'Changer de mode',
                onPressed: () {
                  HapticFeedback.selectionClick();
                  AudioService().playCardFlip();
                  setState(() {
                    _modeActuel = ModeCesar.values[(_modeActuel.index + 1) % ModeCesar.values.length];
                  });
                },
              ),
            ],
          ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. En-tête Impérial avec César
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4A101A), Color(0xFF24060C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33350911),
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFF0D0),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/lupulus/lupulus_imperator.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Text('👑', style: TextStyle(fontSize: 28)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'IVLIVS CAESAR IMPERATOR',
                            style: TextStyle(
                              color: RomanColors.imperialGold,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _modeActuel == ModeCesar.missions
                                ? '« Tourne la roue pour trouver la clé secrète et décoder mes ordres de bataille ! »'
                                : _modeActuel == ModeCesar.generateur
                                    ? '« Compose tes messages secrets, scelle le parchemin et transmets-le à tes alliés ! »'
                                    : '« Colle une missive reçue d\'un camarade, étudie sa fréquence et révèle ses secrets ! »',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 2. Sélecteur de Mode (3 modes interactifs)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('⚔️ Missions'),
                      selected: _modeActuel == ModeCesar.missions,
                      selectedColor: RomanColors.imperialPurple,
                      labelStyle: TextStyle(
                        color: _modeActuel == ModeCesar.missions ? Colors.white : RomanColors.charcoal,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _modeActuel = ModeCesar.missions);
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('📜 Parchemin Secret'),
                      selected: _modeActuel == ModeCesar.generateur,
                      selectedColor: RomanColors.imperialPurple,
                      labelStyle: TextStyle(
                        color: _modeActuel == ModeCesar.generateur ? Colors.white : RomanColors.charcoal,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _modeActuel = ModeCesar.generateur);
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('🔍 Décodeur Camarade'),
                      selected: _modeActuel == ModeCesar.decodeur,
                      selectedColor: RomanColors.imperialPurple,
                      labelStyle: TextStyle(
                        color: _modeActuel == ModeCesar.decodeur ? Colors.white : RomanColors.charcoal,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _modeActuel = ModeCesar.decodeur);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 3. Roue Cryptographique Double Animée
              Center(
                child: SizedBox(
                  width: 250,
                  height: 250,
                  child: CustomPaint(
                    painter: RoueCesarPainter(cle: _cleActuelle),
                    child: Center(
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: RomanColors.imperialPurple,
                          border: Border.all(color: RomanColors.imperialGold, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'CLÉ',
                              style: TextStyle(
                                fontSize: 9,
                                color: RomanColors.imperialGold,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              '+$_cleActuelle',
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'serif',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 4. Contrôles de la Clé (+/-)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 32,
                    color: RomanColors.imperialPurple,
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => _modifierCle(-1),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Slider(
                      value: _cleActuelle.toDouble(),
                      min: 0,
                      max: 25,
                      divisions: 25,
                      activeColor: RomanColors.imperialPurple,
                      inactiveColor: const Color(0xFFE2D6C5),
                      label: 'Clé +$_cleActuelle',
                      onChanged: (val) => _setCle(val.round()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    iconSize: 32,
                    color: RomanColors.imperialPurple,
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => _modifierCle(1),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // 5. Zone de Contenu : Missions vs Parchemin Secret vs Décodeur Camarade
              if (_modeActuel == ModeCesar.missions) ...[
                // Onglets de missions
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(kMissionsCesar.length, (idx) {
                      final isSelected = _missionIndex == idx;
                      final isDone = _missionsReussies.contains(idx);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          avatar: isDone ? const Text('✓', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)) : null,
                          label: Text('Mission ${idx + 1}'),
                          selected: isSelected,
                          selectedColor: RomanColors.goldLight,
                          labelStyle: TextStyle(
                            color: isSelected ? RomanColors.imperialPurple : RomanColors.charcoal,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 12,
                          ),
                          onSelected: (val) {
                            if (val) {
                              HapticFeedback.selectionClick();
                              setState(() => _missionIndex = idx);
                            }
                          },
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 10),

                // Carte Mission
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: estCleValide ? RomanColors.laurelGreen : RomanColors.marbleBorder,
                      width: estCleValide ? 2 : 1.2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              mission.titre,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: RomanColors.imperialPurple,
                              ),
                            ),
                          ),
                          Text(
                            mission.dateContexte,
                            style: const TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        mission.explication,
                        style: const TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                      const Divider(height: 20),
                      const Text(
                        'MESSAGE CRYPTÉ PAR LES LÉGIONS :',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: RomanColors.charcoal),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F2E9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE0D4C3)),
                        ),
                        child: Text(
                          mission.messageChiffre,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7A2020),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'DÉCHIFFREMENT EN TEMPS RÉEL (SELON LA CLÉ) :',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: RomanColors.charcoal),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: estCleValide ? const Color(0xFFEBF7EB) : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: estCleValide ? RomanColors.laurelGreen : const Color(0xFFD4C7B5),
                          ),
                        ),
                        child: Text(
                          texteDechiffre,
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: estCleValide ? RomanColors.laurelGreen : RomanColors.charcoal,
                          ),
                        ),
                      ),
                      if (estCleValide) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Traduction : ${mission.traduction}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF1B5E20),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ] else if (_modeActuel == ModeCesar.generateur) ...[
                // Mode Générateur de Parchemin Secret
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MESSAGE CLAIR À ENCODER :',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: RomanColors.charcoal),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _saisieControleur,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          hintText: 'Écris ton message secret...',
                          filled: true,
                          fillColor: const Color(0xFFFAF7F0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onChanged: (val) => setState(() {}),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'PARCHEMIN IMPÉRIAL SCELLÉ :',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: RomanColors.charcoal),
                      ),
                      const SizedBox(height: 6),
                      // Parchemin antique stylisé
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFFBF0), Color(0xFFF3E7CF)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: RomanColors.imperialGold, width: 1.8),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1F523415),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('🏛️', style: TextStyle(fontSize: 14)),
                                SizedBox(width: 6),
                                Text(
                                  'EPISTVLA SECRETA SPQR',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: RomanColors.imperialPurple,
                                    letterSpacing: 1.5,
                                    fontFamily: 'serif',
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text('🏛️', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            const Divider(color: RomanColors.imperialGold, height: 16),
                            SelectableText(
                              texteDechiffre,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A101A),
                                letterSpacing: 1.4,
                              ),
                            ),
                            const Divider(color: RomanColors.imperialGold, height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '🗝️ Clavis : +$_cleActuelle',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF7A5901)),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFB71C1C),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('🛑', style: TextStyle(fontSize: 10)),
                                      SizedBox(width: 4),
                                      Text(
                                        'SIGILLVM CAESARIS',
                                        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.copy, size: 16),
                              label: const Text('TEXTE SEUL'),
                              onPressed: () {
                                AudioService().playWheelClick();
                                Clipboard.setData(ClipboardData(text: texteDechiffre));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Texte crypté copié dans le presse-papiers !'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: RomanButton(
                              text: '📜 EXPORTER LE PARCHEMIN',
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                AudioService().playTriumph();
                                final epitre = _genererEpitreFormatee(texteDechiffre, _cleActuelle);
                                Clipboard.setData(ClipboardData(text: epitre));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Parchemin antique avec sceau copié ! Partage-le à tes alliés !'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Mode Décodeur de Camarade
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MISSIVE SECRÈTE REÇUE :',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: RomanColors.charcoal),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _decodeurControleur,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          hintText: 'Colle ici le message codé reçu...',
                          prefixIcon: const Icon(Icons.paste),
                          filled: true,
                          fillColor: const Color(0xFFFAF7F0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onChanged: (val) => setState(() {}),
                      ),
                      const SizedBox(height: 10),
                      // Analyse fréquentielle
                      Builder(
                        builder: (context) {
                          final cleSugg = _calculerCleFrequence(_decodeurControleur.text);
                          if (cleSugg == null) return const SizedBox.shrink();
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF8E7),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: RomanColors.imperialGold),
                            ),
                            child: Row(
                              children: [
                                const Text('💡', style: TextStyle(fontSize: 16)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Analyse de l\'Érudit : La lettre dominante suggère la clé +$cleSugg (basée sur le E).',
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF7A5901)),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _setCle(cleSugg),
                                  child: const Text('Tester', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Text(
                        'DÉCHIFFREMENT DU MESSAGE :',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: RomanColors.charcoal),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F7F3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: RomanColors.imperialPurple.withOpacity(0.4)),
                        ),
                        child: SelectableText(
                          texteDechiffre.isEmpty ? '(Message vide)' : texteDechiffre,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: RomanColors.imperialPurple,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      RomanButton(
                        text: '✓ VALIDER LE DÉCHIFFREMENT (+10 HS)',
                        onPressed: _decodeurControleur.text.trim().isEmpty
                            ? null
                            : () {
                                final textKey = '${_decodeurControleur.text}_$_cleActuelle';
                                if (!_messagesAmiDechiffres.contains(textKey)) {
                                  HapticFeedback.mediumImpact();
                                  AudioService().playTriumph();
                                  AudioService().playSesterces();
                                  RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
                                  widget.repo.addSesterces(10);
                                  setState(() {
                                    _messagesAmiDechiffres.add(textKey);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Missive déchiffrée ! +10 Sesterces remportés ! 🪙'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Missive déjà validée pour cette clé !'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
      },
    );
  }
}

class RoueCesarPainter extends CustomPainter {
  final int cle;

  const RoueCesarPainter({required this.cle});

  static const String _alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radiusOuter = size.width / 2;
    final radiusInner = radiusOuter * 0.74;

    final paintBronzeOuter = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF8B5A2B), Color(0xFF4A2F13)],
      ).createShader(Rect.fromCircle(center: center, radius: radiusOuter))
      ..style = PaintingStyle.fill;

    final paintGoldInner = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFFF2D1), Color(0xFFD4AF37)],
      ).createShader(Rect.fromCircle(center: center, radius: radiusInner))
      ..style = PaintingStyle.fill;

    final paintBorder = Paint()
      ..color = const Color(0xFFD4AF37)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // 1. Cercle extérieur (Alphabet fixe clair)
    canvas.drawCircle(center, radiusOuter, paintBronzeOuter);
    canvas.drawCircle(center, radiusOuter, paintBorder);

    // 2. Cercle intérieur (Alphabet mobile décalé)
    canvas.drawCircle(center, radiusInner, paintGoldInner);
    canvas.drawCircle(center, radiusInner, paintBorder);

    // Dessin de l'alphabet extérieur fixe
    const totalLetters = 26;
    final angleStep = (2 * math.pi) / totalLetters;

    for (int i = 0; i < totalLetters; i++) {
      final angle = i * angleStep - math.pi / 2;
      final x = center.dx + (radiusOuter - 16) * math.cos(angle);
      final y = center.dy + (radiusOuter - 16) * math.sin(angle);

      final textSpan = TextSpan(
        text: _alphabet[i],
        style: const TextStyle(
          color: Color(0xFFFFF2D1),
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
          fontFamily: 'serif',
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }

    // Dessin de l'alphabet intérieur tournant selon la clé
    for (int i = 0; i < totalLetters; i++) {
      final letterIndex = (i + cle) % 26;
      final angle = i * angleStep - math.pi / 2;
      final x = center.dx + (radiusInner - 18) * math.cos(angle);
      final y = center.dy + (radiusInner - 18) * math.sin(angle);

      final textSpan = TextSpan(
        text: _alphabet[letterIndex],
        style: const TextStyle(
          color: Color(0xFF5A121E),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'serif',
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant RoueCesarPainter oldDelegate) => oldDelegate.cle != cle;
}
