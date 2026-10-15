import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../core/cinematic_player.dart';
import '../../core/themes.dart';
import '../../../l10n/l10n.dart';

/// Écran « À propos » : logo et nom de l'éditeur, version de l'appli.
/// Volontairement sans nom de personne, sans e-mail et sans lien vers le code.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  /// Logo adapté au thème : version claire sur fond crème, sombre sur bleu nuit.
  static String logoPour(Brightness luminosite) => luminosite == Brightness.dark
      ? 'assets/images/studio/logo_icare_dedale_sombre.png'
      : 'assets/images/studio/logo_icare_dedale_clair.png';

  @override
  Widget build(BuildContext context) {
    final sombre = Theme.of(context).brightness == Brightness.dark;
    final couleurTexte = sombre ? Colors.white : RomanColors.charcoal;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.aboutTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Center(
            child: Column(
              children: [
                // Coins arrondis et ombre légère : le carré du logo devient une
                // carte voulue au lieu d'un fond un peu différent de la page.
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(color: Color(0x1A000000), blurRadius: 16, offset: Offset(0, 6)),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset(logoPour(Theme.of(context).brightness), width: 220),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Ludus Latinus',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: RomanFonts.imperial,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: sombre ? RomanColors.goldLight : RomanColors.imperialPurple,
                  ),
                ),
                const SizedBox(height: 8),
                // Version lue dans le paquet installé : elle suit le numéro du build CI.
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, info) {
                    final texte = info.hasData
                        ? context.l10n.aboutVersion(info.data!.version, info.data!.buildNumber)
                        : context.l10n.aboutVersionLoading;
                    return Text(texte, style: TextStyle(fontSize: 15, color: couleurTexte));
                  },
                ),
                const SizedBox(height: 20),
                Text(context.l10n.aboutPublisher,
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: couleurTexte)),
                const SizedBox(height: 6),
                Text(
                  context.l10n.aboutRights,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: couleurTexte.withValues(alpha: 0.7)),
                ),
                const SizedBox(height: 32),
                OutlinedButton.icon(
                  onPressed: () => RomanCinematicOverlay.showStudio(context),
                  icon: const Icon(Icons.play_circle_outline_rounded),
                  label: Text(context.l10n.aboutReplayStudio),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
