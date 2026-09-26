import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import '../../core/cinematic_player.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import 'hero_form.dart';

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
      appBar: AppBar(title: const Text('PARAMÈTRES')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _Titre('Ton héros'),
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
          const _Titre('Son et musique'),
          _Reglage(
            icone: Icons.volume_up_rounded,
            titre: 'Musique, bruitages et volume',
            sousTitre: AudioService().isMuted ? 'Le son est coupé' : 'Le son est activé',
            onTap: () => RomanAudioModal.show(context),
          ),
          if (GameRepository.modeSombreDisponible) ...[
            const SizedBox(height: 22),
            const _Titre('Affichage'),
            AnimatedBuilder(
              animation: repo,
              builder: (context, _) => SwitchListTile.adaptive(
                value: repo.isDarkMode,
                onChanged: (_) => repo.toggleThemeMode(),
                title: const Text('Mode nuit'),
                secondary: const Icon(Icons.nightlight_round, color: RomanColors.imperialPurple),
              ),
            ),
          ],
          const SizedBox(height: 22),
          const _Titre('Vidéo'),
          _Reglage(
            icone: Icons.play_circle_outline_rounded,
            titre: 'Revoir l\'introduction',
            sousTitre: 'Elle se joue aussi à chaque démarrage',
            onTap: () => RomanCinematicOverlay.showIntro(context),
          ),
        ],
      ),
    );
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
    return Material(
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
    );
  }
}
