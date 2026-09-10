import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../core/particles_overlay.dart';

class ArticleMarche {
  final String nom;
  final String latin;
  final int prix;
  final String emoji;
  final String description;

  const ArticleMarche({
    required this.nom,
    required this.latin,
    required this.prix,
    required this.emoji,
    required this.description,
  });
}

const List<ArticleMarche> kArticlesMarche = [
  ArticleMarche(
    nom: "Amphore d'huile d'olive de Campanie",
    latin: "Amphora olei",
    prix: 25,
    emoji: "🏺",
    description: "Huile de première pression, indispensable pour la cuisine et les lampes.",
  ),
  ArticleMarche(
    nom: "Toge en laine fine d'Étrurie",
    latin: "Toga lanea",
    prix: 40,
    emoji: "👘",
    description: "Vêtement d'apparat du citoyen romain, tissé à la main.",
  ),
  ArticleMarche(
    nom: "Panier de figues fraîches & dattes",
    latin: "Ficus et dactyli",
    prix: 14,
    emoji: "🧺",
    description: "Douceurs sucrées récoltées dans les vergers du Latium.",
  ),
  ArticleMarche(
    nom: "Rouleau de papyrus d'Alexandrie",
    latin: "Volumen papyri",
    prix: 32,
    emoji: "📜",
    description: "Support d'écriture noble pour rédiger discours et correspondances.",
  ),
  ArticleMarche(
    nom: "Glaive d'entraînement en bois",
    latin: "Rudis lignea",
    prix: 18,
    emoji: "🗡️",
    description: "Offert aux gladiateurs méritants pour symboliser leur affranchissement.",
  ),
  ArticleMarche(
    nom: "Flacon de parfum de Tyr",
    latin: "Unguentum Tyrium",
    prix: 65,
    emoji: "🧪",
    description: "Essence rare à base de myrrhe et d'aromates de Phénicie.",
  ),
  ArticleMarche(
    nom: "Statuette en bronze de Minerve",
    latin: "Statua Minervae",
    prix: 85,
    emoji: "🦉",
    description: "Déesse de la sagesse et de la stratégie, protectrice de la cité.",
  ),
  ArticleMarche(
    nom: "Coffret d'épices d'Orient",
    latin: "Aromata orientalia",
    prix: 50,
    emoji: "🧰",
    description: "Poivre noir des Indes et cannelle arrivés par la route de la soie.",
  ),
];

class ClientMarche {
  final String nom;
  final String titre;
  final String emoji;
  final String articleNom;
  final int prixArticle;
  final int sommeDonnee;
  final String repliqueSucces;

  int get renduAttendu => sommeDonnee - prixArticle;

  const ClientMarche({
    required this.nom,
    required this.titre,
    required this.emoji,
    required this.articleNom,
    required this.prixArticle,
    required this.sommeDonnee,
    required this.repliqueSucces,
  });
}

const List<ClientMarche> kClientsMarche = [
  ClientMarche(
    nom: 'Centurio Lucius',
    titre: 'Officier de la Legio I',
    emoji: '⚔️',
    articleNom: 'Rudis lignea (Glaive)',
    prixArticle: 18,
    sommeDonnee: 25,
    repliqueSucces: '« Optime ! Monnaie exacte, jeune marchand. Que Mars te garde ! »',
  ),
  ClientMarche(
    nom: 'Senator Valerius',
    titre: 'Membre du Sénat Impérial',
    emoji: '🏛️',
    articleNom: 'Toga lanea (Toge en laine)',
    prixArticle: 40,
    sommeDonnee: 50,
    repliqueSucces: '« Recte factum ! Tu mérites ta place au Forum de Trajan ! »',
  ),
  ClientMarche(
    nom: 'Sacerdos Claudia',
    titre: 'Prêtresse de Vesta',
    emoji: '🕯️',
    articleNom: 'Statua Minervae (Statuette)',
    prixArticle: 85,
    sommeDonnee: 100,
    repliqueSucces: '« Gratias tibi ago ! Minerve bénisse ton étal ! »',
  ),
  ClientMarche(
    nom: 'Agricola Titus',
    titre: 'Fermier des Collines d\'Albe',
    emoji: '🌾',
    articleNom: 'Ficus et dactyli (Panier de fruits)',
    prixArticle: 14,
    sommeDonnee: 20,
    repliqueSucces: '« Parfaitement compté ! Mes bêtes en seront bien nourries ! »',
  ),
  ClientMarche(
    nom: 'Mercatrix Flavia',
    titre: 'Négociante d\'Antioche',
    emoji: '🧳',
    articleNom: 'Aromata orientalia (Épices)',
    prixArticle: 50,
    sommeDonnee: 75,
    repliqueSucces: '« Bene computatum ! Rendez-vous à la prochaine caravane ! »',
  ),
];

class MarcheTrajanScreen extends StatefulWidget {
  final GameRepository repo;

  const MarcheTrajanScreen({super.key, required this.repo});

  @override
  State<MarcheTrajanScreen> createState() => _MarcheTrajanScreenState();
}

class _MarcheTrajanScreenState extends State<MarcheTrajanScreen> {
  int _articleIndex = 0;
  int _clientIndex = 0;
  bool _modeRenduMonnaie = false;
  String _saisieRomaine = '';
  String? _messageFeedback;
  bool _feedbackSucces = false;

  static const Map<String, int> _valeurs = {
    'I': 1,
    'V': 5,
    'X': 10,
    'L': 50,
    'C': 100,
    'D': 500,
    'M': 1000,
  };

  ArticleMarche get _articleActuel => kArticlesMarche[_articleIndex % kArticlesMarche.length];
  ClientMarche get _clientActuel => kClientsMarche[_clientIndex % kClientsMarche.length];

  int _convertirRomainEnArabe(String romain) {
    if (romain.isEmpty) return 0;
    int total = 0;
    int prev = 0;
    for (int i = romain.length - 1; i >= 0; i--) {
      final char = romain[i];
      final val = _valeurs[char] ?? 0;
      if (val < prev) {
        total -= val;
      } else {
        total += val;
        prev = val;
      }
    }
    return total;
  }

  String _convertirArabeEnRomain(int n) {
    if (n <= 0 || n > 3999) return '';
    const map = [
      [1000, 'M'],
      [900, 'CM'],
      [500, 'D'],
      [400, 'CD'],
      [100, 'C'],
      [90, 'XC'],
      [50, 'L'],
      [40, 'XL'],
      [10, 'X'],
      [9, 'IX'],
      [5, 'V'],
      [4, 'IV'],
      [1, 'I'],
    ];
    var res = '';
    var restant = n;
    for (final pair in map) {
      final val = pair[0] as int;
      final lettre = pair[1] as String;
      while (restant >= val) {
        res += lettre;
        restant -= val;
      }
    }
    return res;
  }

  void _ajouterChiffre(String chiffre) {
    HapticFeedback.lightImpact();
    AudioService().playWheelClick();
    if (_saisieRomaine.length >= 15) return;
    setState(() {
      _saisieRomaine += chiffre;
      _messageFeedback = null;
    });
  }

  void _effacerDernier() {
    HapticFeedback.selectionClick();
    AudioService().playCardFlip();
    if (_saisieRomaine.isNotEmpty) {
      setState(() {
        _saisieRomaine = _saisieRomaine.substring(0, _saisieRomaine.length - 1);
        _messageFeedback = null;
      });
    }
  }

  void _reinitialiser() {
    HapticFeedback.selectionClick();
    AudioService().playCardFlip();
    setState(() {
      _saisieRomaine = '';
      _messageFeedback = null;
    });
  }

  void _validerPaiement() {
    final valeurSaisie = _convertirRomainEnArabe(_saisieRomaine);

    if (_modeRenduMonnaie) {
      final client = _clientActuel;
      final attendu = client.renduAttendu;
      final attenduRomain = _convertirArabeEnRomain(attendu);

      if (valeurSaisie == attendu && _saisieRomaine == attenduRomain) {
        HapticFeedback.heavyImpact();
        AudioService().playSesterces();
        AudioService().playTriumph();
        RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
        widget.repo.addSesterces(15);
        setState(() {
          _feedbackSucces = true;
          _messageFeedback = '${client.nom} : ${client.repliqueSucces} (+15 HS de pourboire !)';
        });

        Future.delayed(const Duration(milliseconds: 1800), () {
          if (!mounted) return;
          setState(() {
            _clientIndex = (_clientIndex + 1) % kClientsMarche.length;
            _saisieRomaine = '';
            _messageFeedback = null;
            _feedbackSucces = false;
          });
        });
      } else if (valeurSaisie == attendu) {
        HapticFeedback.vibrate();
        AudioService().playError();
        setState(() {
          _feedbackSucces = false;
          _messageFeedback = 'La somme est exacte ($attendu HS), mais en chiffres romains canoniques on écrit $attenduRomain !';
        });
      } else {
        HapticFeedback.vibrate();
        AudioService().playError();
        setState(() {
          _feedbackSucces = false;
          _messageFeedback = 'Calcul incorrect : ${client.sommeDonnee} HS donnés - ${client.prixArticle} HS = $attendu HS ($attenduRomain) à rendre !';
        });
      }
      return;
    }

    final prixAttendu = _articleActuel.prix;
    final attenduRomain = _convertirArabeEnRomain(prixAttendu);

    if (valeurSaisie == prixAttendu && _saisieRomaine == attenduRomain) {
      HapticFeedback.mediumImpact();
      AudioService().playSesterces();
      AudioService().playTriumph();
      RomanParticlesOverlay.show(context, type: ParticleType.marbleSparks);
      widget.repo.addSesterces(15);
      setState(() {
        _feedbackSucces = true;
        _messageFeedback = 'Optime ! Tu as composé $attenduRomain ($prixAttendu HS). Gaius t\'offre +15 HS !';
      });

      Future.delayed(const Duration(milliseconds: 1600), () {
        if (!mounted) return;
        setState(() {
          _articleIndex = (_articleIndex + 1) % kArticlesMarche.length;
          _saisieRomaine = '';
          _messageFeedback = null;
          _feedbackSucces = false;
        });
      });
    } else if (valeurSaisie == prixAttendu) {
      // Valeur mathématique bonne mais écriture non canonique (ex: IIII au lieu de IV)
      HapticFeedback.vibrate();
      AudioService().playError();
      setState(() {
        _feedbackSucces = false;
        _messageFeedback = 'La valeur est bonne ($prixAttendu), mais en latin canonique on écrit $attenduRomain !';
      });
    } else {
      HapticFeedback.vibrate();
      AudioService().playError();
      setState(() {
        _feedbackSucces = false;
        _messageFeedback = 'Tu as composé $_saisieRomaine ($valeurSaisie HS). Il faut $attenduRomain ($prixAttendu HS) !';
      });
    }
  }

  void _ouvrirLexique() {
    AudioService().playCardFlip();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.72,
        decoration: const BoxDecoration(
          color: RomanColors.travertine,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: RomanColors.imperialGold,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Text('🏛️', style: TextStyle(fontSize: 24)),
                SizedBox(width: 8),
                Text(
                  'Lexique des Chiffres Romains',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: RomanColors.imperialPurple,
                    fontFamily: 'serif',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'À Rome, on combine les 7 chiffres fondamentaux par addition et par soustraction (pour 4 et 9) :',
              style: TextStyle(fontSize: 13, color: RomanColors.charcoal),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView(
                children: [
                  _buildLexiqueRow('I', '1', 'Unus • Doigt tendu'),
                  _buildLexiqueRow('V', '5', 'Quinque • Main ouverte en V'),
                  _buildLexiqueRow('X', '10', 'Decem • Deux mains croisées'),
                  _buildLexiqueRow('L', '50', 'Quinquaginta • Demi-centaine'),
                  _buildLexiqueRow('C', '100', 'Centum • Centaine'),
                  _buildLexiqueRow('D', '500', 'Quingenti • Demi-millier'),
                  _buildLexiqueRow('M', '1000', 'Mille • Millier'),
                  const Divider(height: 24),
                  const Text(
                    '⚠️ Règles de soustraction canoniques :',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  const Text('• IV = 4 (5 - 1)  |  IX = 9 (10 - 1)'),
                  const Text('• XL = 40 (50 - 10)  |  XC = 90 (100 - 10)'),
                  const Text('• CD = 400 (500 - 100)  |  CM = 900 (1000 - 100)'),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RomanButton(
                text: 'J\'AI COMPRIS',
                onPressed: () => Navigator.pop(ctx),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLexiqueRow(String romain, String arabe, String origine) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: RomanColors.marbleBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: RomanColors.goldLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: RomanColors.imperialGold),
            ),
            child: Text(
              romain,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: RomanColors.imperialPurple,
                fontFamily: 'serif',
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$arabe en chiffres arabes',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  origine,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
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
        final valeurSaisie = _convertirRomainEnArabe(_saisieRomaine);
        final article = _articleActuel;

        return Scaffold(
          appBar: AppBar(
            title: const Text('🏺 Marché de Trajan'),
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
                icon: const Icon(Icons.volume_up_rounded, color: RomanColors.imperialGold),
                tooltip: 'Harmonia Antiqua (Audio)',
                onPressed: () => RomanAudioModal.show(context),
              ),
              IconButton(
                icon: const Icon(Icons.help_outline),
                tooltip: 'Aide & Lexique',
                onPressed: _ouvrirLexique,
              ),
            ],
          ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const RomanMeanderDivider(height: 10, color: RomanColors.imperialGold),
              const SizedBox(height: 8),
              // Sélecteur de Mode : Achats à l'étal vs Rendu de Monnaie (Calculus)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _modeRenduMonnaie = false;
                          _saisieRomaine = '';
                          _messageFeedback = null;
                        });
                        AudioService().playWheelClick();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !_modeRenduMonnaie ? RomanColors.imperialPurple : Colors.white,
                        foregroundColor: !_modeRenduMonnaie ? Colors.white : RomanColors.imperialPurple,
                        side: BorderSide(color: RomanColors.imperialPurple),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text('🛍️ Étal de Gaius', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _modeRenduMonnaie = true;
                          _saisieRomaine = '';
                          _messageFeedback = null;
                        });
                        AudioService().playWheelClick();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _modeRenduMonnaie ? RomanColors.imperialPurple : Colors.white,
                        foregroundColor: _modeRenduMonnaie ? Colors.white : RomanColors.imperialPurple,
                        side: BorderSide(color: RomanColors.imperialPurple),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text('⚖️ Rendu de Monnaie', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 1. Bannière Marchande ou Client Romains
              if (!_modeRenduMonnaie)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5A121E), Color(0xFF330811)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3344101A),
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
                            'assets/images/lupulus/lupulus_savant.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Text('👨‍💼', style: TextStyle(fontSize: 28)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'GAIUS MERCATOR',
                              style: TextStyle(
                                color: RomanColors.imperialGold,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '« Salve citoyen ! Paye le juste prix en chiffres romains pour emporter ta marchandise ! »',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.5,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E3A5F), Color(0xFF0F1E33)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x331E3A5F),
                        offset: Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD6E4F0),
                        ),
                        child: Text(_clientActuel.emoji, style: const TextStyle(fontSize: 28)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _clientActuel.nom.toUpperCase(),
                              style: const TextStyle(
                                color: RomanColors.imperialGold,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              _clientActuel.titre,
                              style: const TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '« J\'achète ${_clientActuel.articleNom} (${_clientActuel.prixArticle} HS). Voici ${_clientActuel.sommeDonnee} HS, rends-moi la monnaie ! »',
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

              // 2. Fiche de Transaction (Article ou Rendu) sur Parchemin Antique
              RomanParchmentCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (!_modeRenduMonnaie) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: RomanColors.goldLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: RomanColors.imperialGold),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              article.emoji,
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article.latin,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: RomanColors.imperialPurple,
                                    fontFamily: 'serif',
                                  ),
                                ),
                                Text(
                                  article.nom,
                                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  article.description,
                                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'PRIX DEMANDÉ :',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: RomanColors.charcoal,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: RomanColors.goldLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: RomanColors.imperialGold),
                            ),
                            child: Text(
                              '${article.prix} SESTERCES',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7A5901),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Article : ${_clientActuel.articleNom}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: RomanColors.imperialPurple)),
                              const SizedBox(height: 2),
                              Text('Prix : ${_clientActuel.prixArticle} HS • Donné : ${_clientActuel.sommeDonnee} HS', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: RomanColors.laurelGreen.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: RomanColors.laurelGreen),
                            ),
                            child: Text(
                              'À RENDRE : ${_clientActuel.renduAttendu} HS',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: RomanColors.laurelGreen),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 3. Cadre de composition en marbre
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF8F2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                ),
                child: Column(
                  children: [
                    const Text(
                      'TES TUILES DE PAIEMENT (CHIFFRES ROMAINS) :',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: RomanColors.charcoal,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      constraints: const BoxConstraints(minHeight: 48),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2D6C5)),
                      ),
                      child: Text(
                        _saisieRomaine.isEmpty ? 'Touchez les tuiles ci-dessous...' : _saisieRomaine,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                          fontFamily: 'serif',
                          color: _saisieRomaine.isEmpty ? Colors.black26 : RomanColors.imperialPurple,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _saisieRomaine.isEmpty
                          ? 'Valeur actuelle : 0 HS'
                          : 'Valeur décimale : $valeurSaisie HS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: valeurSaisie == article.prix
                            ? RomanColors.laurelGreen
                            : RomanColors.charcoal,
                      ),
                    ),
                  ],
                ),
              ),

              if (_messageFeedback != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: _feedbackSucces ? const Color(0xFFEAF5EA) : const Color(0xFFFFECEC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _feedbackSucces ? RomanColors.laurelGreen : Colors.redAccent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _feedbackSucces ? Icons.check_circle : Icons.info_outline,
                        color: _feedbackSucces ? RomanColors.laurelGreen : Colors.redAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _messageFeedback!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _feedbackSucces ? const Color(0xFF144D25) : const Color(0xFF7A1010),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // 4. Clavier des 7 Tuiles Romaines
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: ['I', 'V', 'X', 'L', 'C', 'D', 'M'].map((tuile) {
                  return _buildMarbleTile(
                    label: tuile,
                    valeur: _valeurs[tuile] ?? 0,
                    onTap: () => _ajouterChiffre(tuile),
                  );
                }).toList(),
              ),

              const SizedBox(height: 14),

              // 5. Actions d'effacement & Validation
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFFB5A490)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _saisieRomaine.isEmpty ? null : _effacerDernier,
                      child: const Text('⌫ EFFACER'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFFB5A490)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _saisieRomaine.isEmpty ? null : _reinitialiser,
                      child: const Text('RAZ'),
                    ),
                  ),
                  const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: RomanButton(
                        text: _modeRenduMonnaie
                            ? '✓ RENDRE (${_clientActuel.renduAttendu} HS)'
                            : '✓ PAYER (${article.prix} HS)',
                        onPressed: _saisieRomaine.isEmpty ? null : _validerPaiement,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
      },
    );
  }

  Widget _buildMarbleTile({
    required String label,
    required int valeur,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 68,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFFBF2), Color(0xFFF1E6D3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: RomanColors.imperialGold, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F000000),
                offset: Offset(0, 3),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: RomanColors.imperialPurple,
                  fontFamily: 'serif',
                ),
              ),
              Text(
                '$valeur',
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF7A5901),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
