import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../data/services/achat_service.dart';
import '../../../data/services/code_examinateur.dart';
import '../../core/cinematic_player.dart';
import '../../core/themes.dart';
import '../../../l10n/l10n.dart';

/// Écran « À propos » : logo et nom de l'éditeur, version de l'appli.
/// Volontairement sans nom de personne, sans e-mail et sans lien vers le code.
///
/// Sept appuis rapides sur la ligne « Version » ouvrent la saisie du code
/// examinateur (version payante seulement, tant que l'édition n'est pas ouverte).
class AboutScreen extends StatefulWidget {
  /// Absent dans les tests de l'écran : la ligne Version reste alors inerte.
  final AchatService? achats;

  const AboutScreen({super.key, this.achats});

  /// Logo adapté au thème : version claire sur fond crème, sombre sur bleu nuit.
  static String logoPour(Brightness luminosite) => luminosite == Brightness.dark
      ? 'assets/images/studio/logo_icare_dedale_sombre.png'
      : 'assets/images/studio/logo_icare_dedale_clair.png';

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  /// Délai maximal entre deux appuis : au-delà, le compte repart de zéro,
  /// pour qu'un appui distrait de temps en temps n'ouvre jamais la saisie.
  static const Duration _delaiEntreAppuis = Duration(milliseconds: 600);

  int _appuis = 0;

  /// Remet le compte à zéro si l'appui suivant tarde. Un minuteur plutôt
  /// qu'une comparaison d'heures : il suit le temps simulé des tests.
  Timer? _remiseAZero;

  @override
  void dispose() {
    _remiseAZero?.cancel();
    super.dispose();
  }

  void _appuiSurVersion() {
    final achats = widget.achats;
    if (achats == null || !achats.estPayant || achats.editionComplete) return;
    _remiseAZero?.cancel();
    _appuis++;
    if (_appuis < kAppuisCodeExaminateur) {
      _remiseAZero = Timer(_delaiEntreAppuis, () => _appuis = 0);
      return;
    }
    _appuis = 0;
    _demanderCode(achats);
  }

  Future<void> _demanderCode(AchatService achats) async {
    final code = await showDialog<String>(context: context, builder: (_) => const _DialogueCode());
    if (code == null || !mounted) return;
    // Mauvais code : aucun message, pour ne rien apprendre à qui essaie au hasard.
    if (!await achats.ouvrirAvecCode(code) || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.reviewerCodeOk)));
  }

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
                    child: Image.asset(AboutScreen.logoPour(Theme.of(context).brightness), width: 220),
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
                    return GestureDetector(
                      onTap: _appuiSurVersion,
                      child: Text(texte, style: TextStyle(fontSize: 15, color: couleurTexte)),
                    );
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

/// Saisie du code examinateur. Widget à état pour que le champ vive aussi
/// longtemps que la fenêtre, animation de fermeture comprise.
class _DialogueCode extends StatefulWidget {
  const _DialogueCode();

  @override
  State<_DialogueCode> createState() => _DialogueCodeState();
}

class _DialogueCodeState extends State<_DialogueCode> {
  final TextEditingController _saisie = TextEditingController();

  @override
  void dispose() {
    _saisie.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.reviewerCodeTitle),
      content: TextField(
        controller: _saisie,
        autofocus: true,
        textCapitalization: TextCapitalization.characters,
        autocorrect: false,
        enableSuggestions: false,
        decoration: InputDecoration(hintText: context.l10n.reviewerCodeHint),
        onSubmitted: (texte) => Navigator.pop(context, texte),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.commonCancel)),
        FilledButton(
          onPressed: () => Navigator.pop(context, _saisie.text),
          child: Text(context.l10n.reviewerCodeValidate),
        ),
      ],
    );
  }
}
