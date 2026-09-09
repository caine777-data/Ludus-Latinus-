import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../../data/models/thesaurus_entry.dart';
import '../../../data/repositories/game_repository.dart';

/// Dictionnaire bilingue latin-français et tables grammaticales colorées.
class ThesaurusScreen extends StatefulWidget {
  final GameRepository repo;

  const ThesaurusScreen({super.key, required this.repo});

  @override
  State<ThesaurusScreen> createState() => _ThesaurusScreenState();
}

class _ThesaurusScreenState extends State<ThesaurusScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Tous';
  String _searchQuery = '';

  final List<String> _categories = ['Tous', 'Nom', 'Verbe', 'Adjectif', 'Invariable'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<ThesaurusEntry> _getFilteredEntries() {
    return widget.repo.thesaurus.where((entry) {
      final matchesCat = _selectedCategory == 'Tous' ||
          entry.cat.toLowerCase().contains(_selectedCategory.toLowerCase());
      final q = _searchQuery.toLowerCase().trim();
      final matchesSearch = q.isEmpty ||
          entry.latin.toLowerCase().contains(q) ||
          entry.fr.toLowerCase().contains(q) ||
          entry.etym.toLowerCase().contains(q);
      return matchesCat && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('THESAURUS'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: RomanColors.imperialGold,
          labelColor: RomanColors.imperialPurple,
          unselectedLabelColor: Colors.black54,
          tabs: const [
            Tab(icon: Icon(Icons.menu_book_outlined, size: 20), text: 'Dictionnaire'),
            Tab(icon: Icon(Icons.table_rows_outlined, size: 20), text: 'Déclinaisons'),
            Tab(icon: Icon(Icons.auto_stories_outlined, size: 20), text: 'Conjugaisons'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDictionaryTab(),
          _buildDeclensionsTab(),
          _buildConjugationsTab(),
        ],
      ),
    );
  }

  Widget _buildDictionaryTab() {
    final entries = _getFilteredEntries();

    return Column(
      children: [
        // Barre de recherche
        Container(
          padding: const EdgeInsets.all(12),
          color: RomanColors.travertinWhite,
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher en latin ou français...',
                  prefixIcon: const Icon(Icons.search, color: RomanColors.imperialPurple),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: RomanColors.imperialGold),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: RomanColors.marbleBorder),
                  ),
                ),
                onChanged: (val) {
                  setState(() => _searchQuery = val);
                },
              ),
              const SizedBox(height: 8),
              // Filtres de catégories
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((cat) {
                    final isSel = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSel,
                        selectedColor: RomanColors.imperialPurple,
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : RomanColors.charcoal,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          fontSize: 11.5,
                        ),
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: isSel ? RomanColors.imperialPurple : const Color(0xFFE2D6C5),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedCategory = cat);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Résumé
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ' terme(s) trouvé(s)',
                style: const TextStyle(fontSize: 12, color: Colors.black54, fontStyle: FontStyle.italic),
              ),
              const Text(
                'Vocabulaire Cycle 4',
                style: TextStyle(fontSize: 11, color: RomanColors.imperialPurple, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        // Liste des termes
        Expanded(
          child: entries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('📜', style: TextStyle(fontSize: 44)),
                      const SizedBox(height: 10),
                      Text(
                        'Aucun mot trouvé pour «  »',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final item = entries[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: RomanColors.marbleBorder, width: 1.2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                item.latin,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'serif',
                                  color: RomanColors.imperialPurple,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: RomanColors.goldLight,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: RomanColors.imperialGold, width: 0.8),
                                ),
                                child: Text(
                                  ' '.trim(),
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7A5901),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.volume_up_outlined, size: 20, color: RomanColors.imperialPurple),
                                tooltip: 'Prononciation',
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('🔊 Prononciation : ""'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.fr,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: RomanColors.charcoal,
                            ),
                          ),
                          if (item.etym.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Text('🌱 ', style: TextStyle(fontSize: 12)),
                                Expanded(
                                  child: Text(
                                    item.etym,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFF1E5E3A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (item.ex.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAF7EE),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '«  »',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: RomanColors.charcoal,
                                    ),
                                  ),
                                  if (item.exFr.isNotEmpty)
                                    Text(
                                      item.exFr,
                                      style: const TextStyle(fontSize: 11, color: Colors.black54),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDeclensionsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDeclensionCard(
          title: '1ère Déclinaison (Rosa, ae, f.)',
          type: 'Noms féminins en -a',
          cases: const [
            ['Cas', 'Singulier', 'Pluriel', 'Fonction'],
            ['Nominatif', 'ros-a', 'ros-ae', 'Sujet'],
            ['Vocatif', 'ros-a', 'ros-ae', 'Appel'],
            ['Accusatif', 'ros-am', 'ros-as', 'COD'],
            ['Génitif', 'ros-ae', 'ros-arum', 'Complément du Nom'],
            ['Datif', 'ros-ae', 'ros-is', 'Attribution / COI'],
            ['Ablatif', 'ros-a', 'ros-is', 'Circonstanciel'],
          ],
        ),
        const SizedBox(height: 16),
        _buildDeclensionCard(
          title: '2ème Déclinaison (Dominus, i, m. / Templum, i, n.)',
          type: 'Noms masculins en -us et neutres en -um',
          cases: const [
            ['Cas', 'Masc. Sg.', 'Masc. Pl.', 'Neutre Sg.', 'Neutre Pl.'],
            ['Nominatif', 'domin-us', 'domin-i', 'templ-um', 'templ-a'],
            ['Vocatif', 'domin-e', 'domin-i', 'templ-um', 'templ-a'],
            ['Accusatif', 'domin-um', 'domin-os', 'templ-um', 'templ-a'],
            ['Génitif', 'domin-i', 'domin-orum', 'templ-i', 'templ-orum'],
            ['Datif', 'domin-o', 'domin-is', 'templ-o', 'templ-is'],
            ['Ablatif', 'domin-o', 'domin-is', 'templ-o', 'templ-is'],
          ],
        ),
        const SizedBox(height: 16),
        _buildDeclensionCard(
          title: '3ème Déclinaison (Consonantique & Mixte)',
          type: 'Rex, regis, m. / Civis, civis, m.',
          cases: const [
            ['Cas', 'Cons. Sg.', 'Cons. Pl.', 'Mixte Sg.', 'Mixte Pl.'],
            ['Nominatif', 'rex', 'reg-es', 'civ-is', 'civ-es'],
            ['Vocatif', 'rex', 'reg-es', 'civ-is', 'civ-es'],
            ['Accusatif', 'reg-em', 'reg-es', 'civ-em', 'civ-es'],
            ['Génitif', 'reg-is', 'reg-um', 'civ-is', 'civ-ium'],
            ['Datif', 'reg-i', 'reg-ibus', 'civ-i', 'civ-ibus'],
            ['Ablatif', 'reg-e', 'reg-ibus', 'civ-e', 'civ-ibus'],
          ],
        ),
      ],
    );
  }

  Widget _buildConjugationsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDeclensionCard(
          title: 'Verbe ÊTRE (Esse) — Présent & Imparfait',
          type: 'Verbe irrégulier fondamental',
          cases: const [
            ['Personne', 'Présent', 'Imparfait', 'Sens'],
            ['1re Sg. (ego)', 'sum', 'eram', 'je suis / j''étais'],
            ['2e Sg. (tu)', 'es', 'eras', 'tu es / tu étais'],
            ['3e Sg. (is/ea)', 'est', 'erat', 'il est / il était'],
            ['1re Pl. (nos)', 'sumus', 'eramus', 'nous sommes / étions'],
            ['2e Pl. (vos)', 'estis', 'eratis', 'vous êtes / étiez'],
            ['3e Pl. (ii/eae)', 'sunt', 'erant', 'ils sont / étaient'],
          ],
        ),
        const SizedBox(height: 16),
        _buildDeclensionCard(
          title: '1ère Conjugaison (Amare — aimer)',
          type: 'Verbes en -are (Présent de l''indicatif)',
          cases: const [
            ['Personne', 'Forme Latine', 'Traduction'],
            ['1re Sg.', 'am-o', 'j''aime'],
            ['2e Sg.', 'am-as', 'tu aimes'],
            ['3e Sg.', 'am-at', 'il / elle aime'],
            ['1re Pl.', 'am-amus', 'nous aimons'],
            ['2e Pl.', 'am-atis', 'vous aimez'],
            ['3e Pl.', 'am-ant', 'ils / elles aiment'],
          ],
        ),
      ],
    );
  }

  Widget _buildDeclensionCard({
    required String title,
    required String type,
    required List<List<String>> cases,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: RomanColors.imperialGold, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 3),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: RomanColors.imperialPurple,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                    fontFamily: 'serif',
                  ),
                ),
                Text(
                  type,
                  style: const TextStyle(
                    color: RomanColors.goldLight,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 36,
              dataRowMinHeight: 32,
              dataRowMaxHeight: 38,
              columnSpacing: 22,
              headingTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11.5,
                color: RomanColors.charcoal,
              ),
              columns: cases.first.map((col) => DataColumn(label: Text(col))).toList(),
              rows: cases.skip(1).map((row) {
                final caseName = row.first;
                Color caseColor = Colors.transparent;
                if (caseName.contains('Nominatif')) caseColor = CaseColors.nominative.withOpacity(0.08);
                if (caseName.contains('Vocatif')) caseColor = CaseColors.vocative.withOpacity(0.08);
                if (caseName.contains('Accusatif')) caseColor = CaseColors.accusative.withOpacity(0.08);
                if (caseName.contains('Génitif')) caseColor = CaseColors.genitive.withOpacity(0.08);
                if (caseName.contains('Datif')) caseColor = CaseColors.dative.withOpacity(0.08);
                if (caseName.contains('Ablatif')) caseColor = CaseColors.ablative.withOpacity(0.08);

                return DataRow(
                  color: MaterialStateProperty.all(caseColor),
                  cells: row.map((cell) {
                    final isHeader = cell == row.first;
                    return DataCell(
                      Text(
                        cell,
                        style: TextStyle(
                          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                          color: isHeader ? RomanColors.imperialPurple : RomanColors.charcoal,
                        ),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}