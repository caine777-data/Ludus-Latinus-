import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes.dart';
import '../../../core/widgets.dart';
import '../../../../data/models/profile.dart';
import '../../../../data/repositories/game_repository.dart';
import '../../circus/circus_screen.dart';
import '../../duel/duel_screen.dart';
import '../../taverne/taverne_screen.dart';
import '../../cesar/cesar_screen.dart';
import '../../marche/marche_trajan_screen.dart';
import '../../pantheon/pantheon_screen.dart';
import '../../album/album_screen.dart';
import '../../bataille/bataille_screen.dart';
import '../../paires/paires_screen.dart';
import '../../mot_du_jour/mot_du_jour_screen.dart';
import '../../../../l10n/l10n.dart';

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
                        children: [
                          Text(
                            context.l10n.ludiTitle,
                            style: const TextStyle(
                              fontFamily: 'serif',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            context.l10n.ludiSubtitle,
                            style: const TextStyle(
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

              const SizedBox(height: 12),
              _BandeauVictoires(repo: repo),
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
                    // Tuiles un peu plus hautes sur un téléphone étroit, sinon leur texte déborde.
                    childAspectRatio: isDesktop ? 3.2 : (constraints.maxWidth < 350 ? 1.12 : 1.28),
                    children: [
                      // 1. Circus Maximus
                      _buildGameTile(
                        context: context,
                        gameKey: 'circus',
                        imagePath: 'assets/images/circus/chariot_bleu.png',
                        fallbackIcon: '🐎',
                        title: 'Circus Maximus',
                        subtitle: repo.record('circus') > 0
                            ? context.l10n.ludiRecordPoints(repo.record('circus'))
                            : context.l10n.ludiCircusSubtitle,
                        tagLabel: context.l10n.ludiCircusTag,
                        tagColor: const Color(0xFFB3261E),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CircusMaximusScreen(repo: repo)),
                          );
                        },
                      ),

                      // Paires éclair : ouvert dès le départ, comme le Circus,
                      // car il ne demande que les mots du premier monde.
                      // Lupulus en Mercure, hôte du jeu (messager rapide des dieux).
                      _buildGameTile(
                        context: context,
                        gameKey: 'paires',
                        imagePath: 'assets/images/lupulus/lupulus_mercure_180.png',
                        fallbackIcon: '⚡',
                        title: context.l10n.pairsTitle,
                        subtitle: repo.record('paires') > 0
                            ? context.l10n.pairsRecord(repo.record('paires'))
                            : context.l10n.ludiPairsSubtitle,
                        tagLabel: context.l10n.ludiPairsTag,
                        tagColor: RomanColors.laurelGreen,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PairesScreen(repo: repo)),
                          );
                        },
                      ),

                      // Mot du jour : ouvert dès le départ ; une fois le mot du
                      // jour joué, la tuile dit de revenir demain.
                      _buildGameTile(
                        context: context,
                        gameKey: 'motdujour',
                        imagePath: 'assets/images/lupulus/lupulus_philosophe_180.png',
                        fallbackIcon: '🔤',
                        title: context.l10n.wordTitle,
                        subtitle: repo.motDuJourTermine
                            ? context.l10n.ludiWordDone
                            : context.l10n.ludiWordSubtitle,
                        tagLabel: context.l10n.ludiWordTag,
                        tagColor: RomanColors.laurelGreen,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => MotDuJourScreen(repo: repo)),
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
                        subtitle: repo.record('duel') > 0
                            ? context.l10n.ludiRecordStreak(repo.record('duel'))
                            : context.l10n.ludiDuelSubtitle,
                        tagLabel: context.l10n.ludiDuelTag,
                        tagColor: const Color(0xFFB3261E),
                        onTap: () {
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
                        imagePath: 'assets/images/taverne/gaius.webp',
                        fallbackIcon: '🎲',
                        title: 'Alea Iacta Est',
                        subtitle: context.l10n.ludiTavernSubtitle,
                        tagLabel: context.l10n.ludiTavernTag,
                        tagColor: const Color(0xFF8E24AA),
                        onTap: () {
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
                        subtitle: context.l10n.ludiCaesarSubtitle,
                        tagLabel: context.l10n.ludiCaesarTag,
                        tagColor: const Color(0xFF7A5901),
                        onTap: () {
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
                        subtitle: context.l10n.ludiMarketSubtitle,
                        tagLabel: context.l10n.ludiMarketTag,
                        tagColor: const Color(0xFF1E5B94),
                        onTap: () {
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
                        subtitle: context.l10n.ludiPantheonSubtitle,
                        tagLabel: context.l10n.ludiPantheonTag,
                        tagColor: const Color(0xFF7A5901),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PantheonScreen(repo: repo)),
                          );
                        },
                      ),

                      // 7. Album « Héros et Créatures » : une carte par succès
                      _buildGameTile(
                        context: context,
                        gameKey: 'album',
                        imagePath: 'assets/images/dos_carte_collector.png',
                        fallbackIcon: '🃏',
                        title: context.l10n.albumTitle,
                        subtitle: context.l10n.ludiAlbumSubtitle,
                        tagLabel: context.l10n.ludiAlbumTag,
                        tagColor: const Color(0xFF8E44AD),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AlbumScreen(repo: repo)),
                          );
                        },
                      ),

                      // 8. Bataille des Légendes : les cartes de l'album contre Crassus
                      _buildGameTile(
                        context: context,
                        gameKey: 'bataille',
                        imagePath: 'assets/images/album/her_hannibal.webp',
                        fallbackIcon: '⚔️',
                        title: context.l10n.bataTitle,
                        subtitle: repo.record('bataille') > 0
                            ? context.l10n.ludiRecordStreak(repo.record('bataille'))
                            : context.l10n.bataSubtitle,
                        tagLabel: context.l10n.bataTag,
                        tagColor: const Color(0xFF8E1724),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => BatailleScreen(repo: repo)),
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
                          Text(
                            context.l10n.ludiDidYouKnow,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: RomanColors.imperialPurple,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            context.l10n.ludiDidYouKnowBody(profile.completedLessons.length),
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
                                  color: tagColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: tagColor.withValues(alpha: 0.4), width: 0.8),
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
              // Masqué mais gardé pour la taille : sinon son texte transparaît
              // sous le voile semi-opaque du cadenas.
              Opacity(opacity: 0, child: tileContent),
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

/// Rappelle, en haut du Ludi, combien de victoires seront encore payées
/// aujourd'hui et que ce sont les leçons qui les ouvrent : sans ce rappel,
/// l'élève découvrirait la règle à la fin d'une partie gagnée pour rien.
class _BandeauVictoires extends StatelessWidget {
  final GameRepository repo;

  const _BandeauVictoires({required this.repo});

  @override
  Widget build(BuildContext context) {
    final restantes = repo.victoiresPayeesRestantes;
    final plafondAtteint =
        repo.profile.activitesDuJour() * UserProfile.victoiresParActivite >= UserProfile.victoiresPayeesMax;
    final message = restantes > 0
        ? context.l10n.ludiVictoiresPayees(restantes)
        : plafondAtteint
            ? context.l10n.ludiVictoiresEpuisees
            : context.l10n.ludiVictoiresAucune;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: RomanColors.palatinCream,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: RomanColors.imperialGold, width: 1.2),
      ),
      child: Row(
        children: [
          Icon(
            restantes > 0 ? Icons.paid : Icons.menu_book,
            color: RomanColors.goldDark,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
