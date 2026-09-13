import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes.dart';
import '../../../core/widgets.dart';
import '../../../../data/repositories/game_repository.dart';
import '../../../../data/services/audio_service.dart';
import '../../memoria/memoria_screen.dart';
import '../../thesaurus/thesaurus_screen.dart';
import '../../forum/forum_screen.dart';
import '../../../core/latin_epigraph_modal.dart';

/// Onglet 2 : Bibliotheca & Memoria — L'espace d'étude, de révision SRS et de documentation latine.
class BibliothecaView extends StatelessWidget {
  final GameRepository repo;

  const BibliothecaView({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final profile = repo.profile;
    final srsCount = profile.srsScores.length;
    final restoredCount = profile.restoredMonuments.length;
    final epigraphCount = profile.decodedEpigraphs.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. En-tête solennel de la Bibliotheca
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E3A5F), Color(0xFF10233B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3310233B),
                      offset: Offset(0, 6),
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFF0D0),
                        border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                      ),
                      child: const Center(
                        child: Text('🏛️', style: TextStyle(fontSize: 26)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'BIBLIOTHECA ROMANA',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            '« Littera scripta manet » • Les écrits restent.\nOutils de référence, mémoire espacée et trésors épigraphiques.',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFFD6E4F0),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. Grille des 4 Ateliers d'Étude & Outils Fondamentaux
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 520;
                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: isDesktop ? 3.2 : 1.28,
                    children: [
                      // A. Memoria Velox (SRS)
                      _buildStudyTile(
                        context: context,
                        imagePath: 'assets/images/musee_circus.png',
                        fallbackIcon: '🃏',
                        title: 'Memoria Velox',
                        subtitle: '$srsCount mot(s) ancré(s) en mémoire',
                        tagLabel: 'RÉVISION SRS',
                        tagColor: const Color(0xFF1E5B94),
                        onTap: () {
                          AudioService().playCardFlip();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => MemoriaScreen(repo: repo)),
                          );
                        },
                      ),

                      // B. Thesaurus (Dictionnaire & Tables)
                      _buildStudyTile(
                        context: context,
                        imagePath: 'assets/images/musee_louve.png',
                        fallbackIcon: '📖',
                        title: 'Thesaurus',
                        subtitle: 'Lexique thématique & déclinaisons',
                        tagLabel: 'DICTIONNAIRE',
                        tagColor: const Color(0xFF1E5B94),
                        onTap: () {
                          AudioService().playCardFlip();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ThesaurusScreen(repo: repo)),
                          );
                        },
                      ),

                      // C. Forum Imperiale (Monuments & Civilisation)
                      _buildStudyTile(
                        context: context,
                        imagePath: 'assets/images/musee_thermes.png',
                        fallbackIcon: '🏛️',
                        title: 'Forum Imperiale',
                        subtitle: '$restoredCount / 6 édifice(s) restauré(s)',
                        tagLabel: 'PATRIMOINE',
                        tagColor: const Color(0xFF7A5901),
                        onTap: () {
                          AudioService().playTriumph();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ForumScreen(repo: repo)),
                          );
                        },
                      ),

                      // D. Épigraphie Lapidaire (Stèles antiques)
                      _buildStudyTile(
                        context: context,
                        imagePath: 'assets/images/logo_centurion_64.png',
                        fallbackIcon: '🔍',
                        title: 'Épigraphie',
                        subtitle: '$epigraphCount inscription(s) décodée(s)',
                        tagLabel: 'STÈLES',
                        tagColor: const Color(0xFF0D6E6E),
                        onTap: () {
                          AudioService().playWheelClick();
                          LatinEpigraphModal.showRandomOrFirst(context, repo: repo);
                        },
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              // 3. Carte de Conseil d'Étude Didactique
              RomanCard(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: RomanColors.goldLight,
                        border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                      ),
                      child: const Text('💡', style: TextStyle(fontSize: 22)),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Conseil Didactique de Lupulus',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: RomanColors.imperialPurple,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Réviser 5 minutes par jour avec Memoria Velox est 3 fois plus efficace qu\'une heure le week-end. Active la répétition espacée !',
                            style: TextStyle(fontSize: 11.5, color: Colors.black87, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudyTile({
    required BuildContext context,
    required String imagePath,
    required String fallbackIcon,
    required String title,
    required String subtitle,
    required String tagLabel,
    required Color tagColor,
    required VoidCallback onTap,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 210;

        return InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 14 : 10,
              vertical: isWide ? 10 : 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: RomanColors.marbleBorder, width: 1.2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F000000),
                  offset: Offset(0, 3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: isWide
                ? Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: RomanColors.goldLight,
                          border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Center(
                              child: Text(fallbackIcon, style: const TextStyle(fontSize: 22)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: RomanColors.imperialPurple,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: tagColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: tagColor.withOpacity(0.4), width: 0.8),
                                  ),
                                  child: Text(
                                    tagLabel,
                                    style: TextStyle(
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.bold,
                                      color: tagColor,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: RomanColors.imperialGold,
                        size: 20,
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: RomanColors.goldLight,
                          border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Center(
                              child: Text(fallbackIcon, style: const TextStyle(fontSize: 20)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: RomanColors.imperialPurple,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10, color: Colors.black54),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
