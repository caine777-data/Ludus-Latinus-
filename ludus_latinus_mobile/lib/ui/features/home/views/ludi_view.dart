import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes.dart';
import '../../../core/widgets.dart';
import '../../../../data/repositories/game_repository.dart';
import '../../../../data/services/audio_service.dart';
import '../../circus/circus_screen.dart';
import '../../duel/duel_screen.dart';
import '../../taverne/taverne_screen.dart';
import '../../cesar/cesar_screen.dart';
import '../../marche/marche_trajan_screen.dart';
import '../../pantheon/pantheon_screen.dart';

/// Onglet 3 : Ludi & Arènes — Mini-jeux d'arcade romaine soumis au déblocage progressif (Progressive Disclosure).
class LudiView extends StatelessWidget {
  final GameRepository repo;

  const LudiView({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final profile = repo.profile;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. En-tête épique des Ludi Romains
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B1E1E), Color(0xFF4A0E17)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x334A0E17),
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
                        child: Text('⚔️', style: TextStyle(fontSize: 26)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'LUDI & ARÈNES DE L\'EMPIRE',
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
                            '« Panem et circenses » • Du pain et des jeux !\nDéfis chronométrés, courses épiques et tavernes antiques.',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFFFFEAEA),
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

              // 2. Grille des 6 Jeux & Arènes avec Déblocage Progressif
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
                      // 1. Circus Maximus
                      _buildGameTile(
                        context: context,
                        gameKey: 'circus',
                        imagePath: 'assets/images/circus/chariot_bleu.png',
                        fallbackIcon: '🐎',
                        title: 'Circus Maximus',
                        subtitle: 'Course de chars & turbo',
                        tagLabel: 'COURSE',
                        tagColor: const Color(0xFFB3261E),
                        onTap: () {
                          AudioService().playCrowdCheer();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CircusMaximusScreen(repo: repo)),
                          );
                        },
                      ),

                      // 2. Colosseum Duellum
                      _buildGameTile(
                        context: context,
                        gameKey: 'duel',
                        imagePath: 'assets/images/boss_gladiateur_140.png',
                        fallbackIcon: '⚔️',
                        title: 'Colosseum Duellum',
                        subtitle: 'Arène tactique des champions',
                        tagLabel: 'ARÈNE',
                        tagColor: const Color(0xFFB3261E),
                        onTap: () {
                          AudioService().playSwordClash();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => DuelScreen(repo: repo)),
                          );
                        },
                      ),

                      // 3. Taverne des Dés (Alea Iacta Est)
                      _buildGameTile(
                        context: context,
                        gameKey: 'taverne',
                        imagePath: 'assets/images/boss_mercure_140.png',
                        fallbackIcon: '🎲',
                        title: 'Alea Iacta Est',
                        subtitle: 'Taverne & dés romains',
                        tagLabel: 'DÉS',
                        tagColor: const Color(0xFF8E24AA),
                        onTap: () {
                          AudioService().playDiceRoll();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => TaverneScreen(repo: repo)),
                          );
                        },
                      ),

                      // 4. Atelier de César
                      _buildGameTile(
                        context: context,
                        gameKey: 'cesar',
                        imagePath: 'assets/images/lupulus/lupulus_imperator.png',
                        fallbackIcon: '📜',
                        title: 'Atelier de César',
                        subtitle: 'Cryptographie militaire',
                        tagLabel: 'ÉNIGME',
                        tagColor: const Color(0xFF7A5901),
                        onTap: () {
                          AudioService().playWheelClick();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CesarScreen(repo: repo)),
                          );
                        },
                      ),

                      // 5. Marché de Trajan
                      _buildGameTile(
                        context: context,
                        gameKey: 'marche',
                        imagePath: 'assets/images/lupulus/lupulus_savant.png',
                        fallbackIcon: '🏺',
                        title: 'Marché de Trajan',
                        subtitle: 'Chiffres romains & étal',
                        tagLabel: 'COMMERCE',
                        tagColor: const Color(0xFF1E5B94),
                        onTap: () {
                          AudioService().playSesterces();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => MarcheTrajanScreen(repo: repo)),
                          );
                        },
                      ),

                      // 6. Le Panthéon
                      _buildGameTile(
                        context: context,
                        gameKey: 'pantheon',
                        imagePath: 'assets/images/trophee_triomphe_medaillon_130.png',
                        fallbackIcon: '🏆',
                        title: 'Le Panthéon',
                        subtitle: 'Album des reliques & dieux',
                        tagLabel: 'RELIQUES',
                        tagColor: const Color(0xFF7A5901),
                        onTap: () {
                          AudioService().playTriumph();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PantheonScreen(repo: repo)),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              // 3. Bannière d'encouragement au déblocage
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: RomanColors.palatinCream,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                ),
                child: Row(
                  children: [
                    const Text('🏺', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Le Saviez-vous ?',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: RomanColors.imperialPurple,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Chaque nouvelle ville conquise sur la Via Appia déverrouille de nouveaux quartiers de loisirs. Avance dans tes leçons pour tout débloquer ! (${profile.completedLessons.length} leçons terminées).',
                            style: const TextStyle(fontSize: 11, color: Colors.black87),
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

  Widget _buildGameTile({
    required BuildContext context,
    required String gameKey,
    required String imagePath,
    required String fallbackIcon,
    required String title,
    required String subtitle,
    required String tagLabel,
    required Color tagColor,
    required VoidCallback onTap,
  }) {
    final status = repo.profile.getUnlockStatusForGame(gameKey);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 210;

        Widget tileContent = Container(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 14 : 10,
            vertical: isWide ? 10 : 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: status.isUnlocked ? RomanColors.marbleBorder : const Color(0xFFD6C8B8),
              width: 1.2,
            ),
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
        );

        if (!status.isUnlocked) {
          return Stack(
            fit: StackFit.expand,
            children: [
              tileContent,
              RomanLockOverlay(
                title: title,
                lockReason: status.reason,
                progress: status.progress,
              ),
            ],
          );
        }

        return InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(16),
          child: tileContent,
        );
      },
    );
  }
}
