import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import '../../core/cinematic_player.dart';
import 'about_screen.dart';
import 'choix_profil_screen.dart';
import 'professeurs_screen.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import 'hero_form.dart';
import '../home/views/objectif_du_jour.dart';
import '../../../l10n/l10n.dart';

/// Paramètres : tous les réglages au même endroit (héros, son, intro).
///
/// Avant, changer de personnage se cachait dans le compte, derrière
/// « Touche l'avatar pour changer », et le son se réglait ailleurs.
class SettingsScreen extends StatelessWidget {
  final GameRepository repo;

  const SettingsScreen({super.key, required this.repo});

  static Future<void> show(BuildContext context, GameRepository repo) {
    HapticFeedback.selectionClick();
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SettingsScreen(repo: repo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = repo.profile;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: ColonneLecture(largeurMax: 900, child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Titre(context.l10n.settingsSectionHero),
          RomanParchmentCard(
            padding: const EdgeInsets.all(16),
            child: HeroForm(
              profile: profile,
              genreInitial: profile.genre,
              prenomInitial: profile.nomHeros,
              // Enregistré au fil de la saisie ; un prénom vide n'est jamais retenu.
              onChanged: (prenom, genre) =>
                  repo.updateProfileName(prenom.isEmpty ? profile.nomHeros : prenom, genre),
            ),
          ),
          const SizedBox(height: 22),
          _Titre(context.l10n.profilesSection),
          _Reglage(
            icone: Icons.people_alt_outlined,
            titre: context.l10n.profilesSwitch,
            sousTitre: repo.nombreDeProfils > 1
                ? context.l10n.profilesCount(repo.nombreDeProfils)
                : context.l10n.profilesAddHint,
            onTap: () async {
              final change = await ChoixProfilScreen.montrer(context, repo);
              // Autre élève : retour à l'accueil, où il retrouve sa progression
              // (et sa première leçon s'il vient d'être créé).
              if (change && context.mounted) Navigator.of(context).popUntil((r) => r.isFirst);
            },
          ),
          if (repo.nombreDeProfils > 1)
            _Reglage(
              icone: Icons.person_remove_outlined,
              titre: context.l10n.profilesDelete,
              sousTitre: profile.nomHeros,
              onTap: () => _supprimerProfil(context),
            ),
          const SizedBox(height: 22),
          _Titre(context.l10n.settingsReminderSection),
          _Bloc(child: ReglagesRappelEtObjectif(repo: repo)),
          const SizedBox(height: 22),
          _Titre(context.l10n.settingsSectionSound),
          _Reglage(
            icone: Icons.volume_up_rounded,
            titre: context.l10n.settingsSoundTitle,
            sousTitre: AudioService().isMuted ? context.l10n.settingsSoundMuted : context.l10n.settingsSoundOn,
            onTap: () => RomanAudioModal.show(context),
          ),
          const SizedBox(height: 22),
          _Titre(context.l10n.settingsSectionDisplay),
          _Bloc(
            child: AnimatedBuilder(
            animation: repo,
            builder: (context, _) => SwitchListTile.adaptive(
              value: repo.lectureConfort,
              onChanged: (_) => repo.basculerLectureConfort(),
              title: Text(context.l10n.settingsReadingComfort),
              subtitle: Text(context.l10n.settingsReadingComfortHint),
              secondary: const Icon(Icons.chrome_reader_mode_outlined, color: RomanColors.imperialPurple),
            ),
          )),
          if (GameRepository.modeSombreDisponible) ...[
            AnimatedBuilder(
              animation: repo,
              builder: (context, _) => SwitchListTile.adaptive(
                value: repo.isDarkMode,
                onChanged: (_) => repo.toggleThemeMode(),
                title: Text(context.l10n.settingsNightMode),
                secondary: const Icon(Icons.nightlight_round, color: RomanColors.imperialPurple),
              ),
            ),
          ],
          const SizedBox(height: 22),
          _Titre(context.l10n.settingsSectionVideo),
          _Reglage(
            icone: Icons.play_circle_outline_rounded,
            titre: context.l10n.settingsReplayIntro,
            sousTitre: context.l10n.settingsReplayIntroHint,
            onTap: () => RomanCinematicOverlay.showIntro(context),
          ),
          const SizedBox(height: 22),
          _Titre(context.l10n.settingsSectionApp),
          if (repo.dataService.programmeLca != null)
            _Reglage(
              icone: Icons.school_outlined,
              titre: context.l10n.settingsTeachers,
              sousTitre: context.l10n.settingsTeachersHint,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfesseursScreen(repo: repo)),
              ),
            ),
          _Reglage(
            icone: Icons.info_outline_rounded,
            titre: context.l10n.settingsAbout,
            sousTitre: context.l10n.settingsAboutHint,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
          ),
        ],
      )),
    );
  }
}

extension on SettingsScreen {
  /// Suppression de l'élève actif, après confirmation par son prénom : on ne
  /// perd pas une année de latin d'un toucher malheureux.
  Future<void> _supprimerProfil(BuildContext context) async {
    final prenom = repo.profile.nomHeros;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.profilesDeleteTitle(prenom)),
        content: Text(ctx.l10n.profilesDeleteBody(prenom)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(ctx.l10n.commonCancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: RomanColors.terracotta),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(ctx.l10n.profilesDeleteConfirm),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await repo.supprimerProfil(repo.storageService.idActif);
    if (context.mounted) Navigator.of(context).popUntil((r) => r.isFirst);
  }
}

class _Titre extends StatelessWidget {
  final String texte;

  const _Titre(this.texte);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        texte.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.4,
          color: RomanColors.imperialPurple,
        ),
      ),
    );
  }
}

/// Carte blanche qui regroupe des lignes de réglage, comme [_Reglage] :
/// toutes les sections ont ainsi le même aspect.
class _Bloc extends StatelessWidget {
  final Widget child;

  const _Bloc({required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: RomanColors.marbleBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _Reglage extends StatelessWidget {
  final IconData icone;
  final String titre;
  final String sousTitre;
  final VoidCallback onTap;

  const _Reglage({
    required this.icone,
    required this.titre,
    required this.sousTitre,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Marge sous chaque carte : deux réglages d'une même section se touchaient.
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: RomanColors.marbleBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: Icon(icone, color: RomanColors.imperialPurple),
        title: Text(titre, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(sousTitre),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    ));
  }
}
