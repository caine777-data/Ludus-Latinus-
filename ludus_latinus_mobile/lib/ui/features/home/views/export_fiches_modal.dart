import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../data/repositories/game_repository.dart';
import '../../../../data/services/audio_service.dart';
import '../../../core/themes.dart';
import '../../../core/widgets.dart';

class ExportFichesModal extends StatefulWidget {
  final GameRepository repo;

  const ExportFichesModal({super.key, required this.repo});

  static Future<void> show(BuildContext context, {required GameRepository repo}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExportFichesModal(repo: repo),
    );
  }

  @override
  State<ExportFichesModal> createState() => _ExportFichesModalState();
}

class _ExportFichesModalState extends State<ExportFichesModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<Map<String, dynamic>> _declinaisons = [
    {
      'titre': '1ère Déclinaison (Féminin en -a)',
      'modele': 'Rosa, rosae (f.) — La rose',
      'singulier': ['rosa', 'rosa', 'rosam', 'rosae', 'rosae', 'rosa'],
      'pluriel': ['rosae', 'rosae', 'rosas', 'rosarum', 'rosis', 'rosis'],
    },
    {
      'titre': '2ème Déclinaison (Masculin en -us)',
      'modele': 'Dominus, domini (m.) — Le maître',
      'singulier': ['dominus', 'domine', 'dominum', 'domini', 'domino', 'domino'],
      'pluriel': ['domini', 'domini', 'dominos', 'dominorum', 'dominis', 'dominis'],
    },
    {
      'titre': '2ème Déclinaison Neutre (en -um)',
      'modele': 'Templum, templi (n.) — Le temple',
      'singulier': ['templum', 'templum', 'templum', 'templi', 'templo', 'templo'],
      'pluriel': ['templa', 'templa', 'templa', 'templorum', 'templis', 'templis'],
    },
    {
      'titre': '3ème Déclinaison (Consonantique & Mixte)',
      'modele': 'Rex, regis (m.) — Le roi',
      'singulier': ['rex', 'rex', 'regem', 'regis', 'regi', 'rege'],
      'pluriel': ['reges', 'reges', 'reges', 'regum', 'regibus', 'regibus'],
    },
    {
      'titre': '4ème & 5ème Déclinaisons',
      'modele': 'Manus, us (f.) — La main / Res, rei (f.) — La chose',
      'singulier': ['manus / res', 'manus / res', 'manum / rem', 'manus / rei', 'manui / rei', 'manu / re'],
      'pluriel': ['manus / res', 'manus / res', 'manus / res', 'manuum / rerum', 'manibus / rebus', 'manibus / rebus'],
    },
  ];

  static const List<String> _cas = [
    'Nominatif (Sujet)',
    'Vocatif (Appel)',
    'Accusatif (COD)',
    'Génitif (CDN)',
    'Datif (COI)',
    'Ablatif (Circ.)',
  ];

  static const List<Map<String, String>> _flashcards = [
    {
      'latin': 'LUPUS, I, m.',
      'sens': 'Le loup',
      'citation': 'Homo homini lupus est.',
      'trad': 'L\'homme est un loup pour l\'homme.',
      'emoji': '🐺',
    },
    {
      'latin': 'ROSA, AE, f.',
      'sens': 'La rose',
      'citation': 'Rosa pulchra in horto est.',
      'trad': 'Une belle rose est dans le jardin.',
      'emoji': '🌹',
    },
    {
      'latin': 'GLADIUS, II, m.',
      'sens': 'Le glaive, l\'épée',
      'citation': 'Gladius gladiatoris acer est.',
      'trad': 'Le glaive du gladiateur est affûté.',
      'emoji': '⚔️',
    },
    {
      'latin': 'AQUA, AE, f.',
      'sens': 'L\'eau',
      'citation': 'Aqua vitae fons est.',
      'trad': 'L\'eau est la source de la vie.',
      'emoji': '💧',
    },
    {
      'latin': 'TEMPLUM, I, n.',
      'sens': 'Le temple, sanctuaire',
      'citation': 'Templum deorum pulchrum est.',
      'trad': 'Le temple des dieux est magnifique.',
      'emoji': '🏛️',
    },
    {
      'latin': 'CANIS, IS, m./f.',
      'sens': 'Le chien',
      'citation': 'Cave canem !',
      'trad': 'Attention au chien !',
      'emoji': '🐕',
    },
    {
      'latin': 'AQUILA, AE, f.',
      'sens': 'L\'aigle',
      'citation': 'Aquila non capit muscas.',
      'trad': 'L\'aigle ne chasse pas les mouches.',
      'emoji': '🦅',
    },
    {
      'latin': 'EQUUS, I, m.',
      'sens': 'Le cheval',
      'citation': 'Equus celeriter currit.',
      'trad': 'Le cheval court rapidement.',
      'emoji': '🐎',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _genererDocumentHtml() {
    final profile = widget.repo.profile;
    final buffer = StringBuffer();

    buffer.writeln('''<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Ludus Latinus — Fiches Mémo & Révisions Imprimables A4</title>
  <style>
    @page { size: A4 portrait; margin: 12mm; }
    body {
      font-family: "Georgia", "Palatino", serif;
      color: #1a1a1a;
      background: #ffffff;
      margin: 0;
      padding: 0;
      line-height: 1.4;
    }
    .header {
      text-align: center;
      border-bottom: 3px double #b8860b;
      padding-bottom: 12px;
      margin-bottom: 16px;
    }
    .header h1 {
      margin: 0;
      color: #5c1320;
      font-size: 24pt;
      letter-spacing: 2px;
      text-transform: uppercase;
    }
    .header p {
      margin: 4px 0 0;
      font-style: italic;
      color: #666;
      font-size: 11pt;
    }
    .section-title {
      font-size: 14pt;
      color: #5c1320;
      border-left: 4px solid #b8860b;
      padding-left: 8px;
      margin: 18px 0 10px;
      text-transform: uppercase;
      letter-spacing: 1px;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 16px;
      font-size: 10pt;
    }
    th, td {
      border: 1px solid #c8b99d;
      padding: 6px 10px;
      text-align: left;
    }
    th {
      background-color: #f6efe0;
      color: #5c1320;
      font-weight: bold;
    }
    tr:nth-child(even) { background-color: #fdfaf4; }
    .flashcards-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 12px;
      margin-bottom: 20px;
    }
    .card {
      border: 2px dashed #b8860b;
      border-radius: 8px;
      padding: 12px;
      background: #faf6ee;
      box-sizing: border-box;
    }
    .card-latin {
      font-size: 13pt;
      font-weight: bold;
      color: #5c1320;
      margin-bottom: 4px;
    }
    .card-sens {
      font-size: 11pt;
      color: #2e5b88;
      font-weight: 600;
      margin-bottom: 6px;
    }
    .card-quote {
      font-size: 9pt;
      font-style: italic;
      color: #444;
      border-top: 1px dotted #c8b99d;
      padding-top: 4px;
    }
    .stats-box {
      border: 2px solid #5c1320;
      border-radius: 10px;
      padding: 14px;
      background: #fbf8f0;
      margin-bottom: 16px;
    }
    .footer {
      text-align: center;
      font-size: 9pt;
      color: #888;
      border-top: 1px solid #ddd;
      padding-top: 8px;
      margin-top: 24px;
    }
    @media print {
      .page-break { page-break-before: always; }
      body { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
    }
  </style>
</head>
<body>
  <div class="header">
    <h1>🏛️ Ludus Latinus — Tabulae Memoriales</h1>
    <p>« Littera scripta manet » • Fiche d'étude officielle et d'auto-évaluation A4</p>
  </div>

  <div class="stats-box">
    <strong>Élève :</strong> ${profile.nomHeros} &nbsp;|&nbsp;
    <strong>Rang :</strong> ${profile.cursusRank.titre} &nbsp;|&nbsp;
    <strong>Sesterces :</strong> ${profile.sesterces} HS &nbsp;|&nbsp;
    <strong>Monuments restaurés :</strong> ${profile.restoredMonuments.length} / 6 &nbsp;|&nbsp;
    <strong>Stèles décodées :</strong> ${profile.decodedEpigraphs.length}
  </div>

  <div class="section-title">I. Table de Référence des Déclinaisons Latines</div>
''');

    for (final dec in _declinaisons) {
      buffer.writeln('''  <h4 style="margin: 8px 0 4px; color: #5c1320;">${dec['titre']} — <em>${dec['modele']}</em></h4>
  <table>
    <thead>
      <tr>
        <th style="width: 30%;">Cas</th>
        <th style="width: 35%;">Singulier</th>
        <th style="width: 35%;">Pluriel</th>
      </tr>
    </thead>
    <tbody>''');

      final sList = dec['singulier'] as List<String>;
      final pList = dec['pluriel'] as List<String>;
      for (int i = 0; i < _cas.length; i++) {
        buffer.writeln('''      <tr>
        <td><strong>${_cas[i]}</strong></td>
        <td>${sList[i]}</td>
        <td>${pList[i]}</td>
      </tr>''');
      }
      buffer.writeln('''    </tbody>
  </table>''');
    }

    buffer.writeln('''  <div class="page-break"></div>

  <div class="header">
    <h1>✂️ Planche de Flashcards Leitner à Découper</h1>
    <p>Découpe selon les pointillés et entraîne-toi avec le système de répétition espacée !</p>
  </div>

  <div class="flashcards-grid">''');

    for (final c in _flashcards) {
      buffer.writeln('''    <div class="card">
      <div class="card-latin">${c['emoji']} ${c['latin']}</div>
      <div class="card-sens">Français : ${c['sens']}</div>
      <div class="card-quote">« ${c['citation']} »<br><small>${c['trad']}</small></div>
    </div>''');
    }

    buffer.writeln('''  </div>

  <div class="footer">
    Ludus Latinus — Conçu pour l'apprentissage du Latin au Collège et au Lycée • Fiche générée automatiquement
  </div>
</body>
</html>''');

    return buffer.toString();
  }

  void _copierDocumentHtml() {
    final html = _genererDocumentHtml();
    Clipboard.setData(ClipboardData(text: html));
    HapticFeedback.heavyImpact();
    AudioService().playTriumph();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Text('📋', style: TextStyle(fontSize: 20)),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Fiche A4 copiée au format HTML ! Ouvre ton navigateur et imprime (Ctrl+P / Imprimer en PDF).',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: RomanColors.imperialPurple,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: RomanColors.travertine,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
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
          const SizedBox(height: 12),

          // En-tête du Modal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: RomanColors.goldLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: RomanColors.imperialGold),
                  ),
                  child: const Text('🖨️', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tabulae Memoriales',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: RomanColors.imperialPurple,
                        ),
                      ),
                      Text(
                        'Fiches de Révision & Flashcards A4 Imprimables',
                        style: TextStyle(fontSize: 12, color: RomanColors.charcoal),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Onglets de navigation
          TabBar(
            controller: _tabController,
            indicatorColor: RomanColors.imperialPurple,
            labelColor: RomanColors.imperialPurple,
            unselectedLabelColor: Colors.black54,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            tabs: const [
              Tab(text: '📖 Déclinaisons', icon: Icon(Icons.table_chart_rounded, size: 20)),
              Tab(text: '✂️ Flashcards', icon: Icon(Icons.style_rounded, size: 20)),
              Tab(text: '📜 Palmarès', icon: Icon(Icons.military_tech_rounded, size: 20)),
            ],
          ),

          const Divider(height: 1),

          // Contenu défilable
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabDeclinaisons(),
                _buildTabFlashcards(),
                _buildTabPalmares(),
              ],
            ),
          ),

          // Bouton d'exportation principal
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2D6C5))),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: RomanButton(
                      text: 'COPIER LA FICHE A4 (HTML / PDF)',
                      icon: Icons.print_rounded,
                      onPressed: _copierDocumentHtml,
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

  Widget _buildTabDeclinaisons() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _declinaisons.length,
      itemBuilder: (context, idx) {
        final dec = _declinaisons[idx];
        final singulier = dec['singulier'] as List<String>;
        final pluriel = dec['pluriel'] as List<String>;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: RomanParchmentCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dec['titre'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: RomanColors.imperialPurple,
                  ),
                ),
                Text(
                  dec['modele'] as String,
                  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                Table(
                  border: TableBorder.all(color: const Color(0xFFDCCDB7)),
                  children: [
                    const TableRow(
                      decoration: BoxDecoration(color: Color(0xFFF3E8FF)),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(6),
                          child: Text('Cas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(6),
                          child: Text('Singulier', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(6),
                          child: Text('Pluriel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                      ],
                    ),
                    ...List.generate(_cas.length, (i) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(_cas[i], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(singulier[i], style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(pluriel[i], style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabFlashcards() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Planche de révision découpable prête à l\'impression :',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: RomanColors.charcoal),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.35,
          ),
          itemCount: _flashcards.length,
          itemBuilder: (context, i) {
            final f = _flashcards[i];
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                boxShadow: const [
                  BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(f['emoji']!, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          f['latin']!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: RomanColors.imperialPurple,
                            fontFamily: 'serif',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    f['sens']!,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E5B94)),
                  ),
                  Text(
                    '« ${f['citation']} »',
                    style: const TextStyle(fontSize: 9, fontStyle: FontStyle.italic, color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTabPalmares() {
    final profile = widget.repo.profile;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        RomanParchmentCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🏅', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.nomHeros.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'serif',
                            color: RomanColors.imperialPurple,
                          ),
                        ),
                        Text(
                          'Titre républicain : ${profile.cursusRank.titre}',
                          style: const TextStyle(fontSize: 12, color: RomanColors.charcoal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildPalmaresRow('🪙 Trésor accumulé', '${profile.sesterces} HS'),
              _buildPalmaresRow('🏛️ Monuments restaurés', '${profile.restoredMonuments.length} / 6 édifices'),
              _buildPalmaresRow('🔍 Stèles lapidaires décodées', '${profile.decodedEpigraphs.length} inscriptions'),
              _buildPalmaresRow('🃏 Cartes ancrées en mémoire SRS', '${profile.srsScores.length} fiches'),
              _buildPalmaresRow('🔥 Série d\'assiduité quotidienne', '${profile.streakDays} jour(s) consécutif(s)'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPalmaresRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: RomanColors.charcoal)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: RomanColors.imperialPurple)),
        ],
      ),
    );
  }
}
