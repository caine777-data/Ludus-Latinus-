import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../data/models/cursus_honorum.dart';
import '../../../../data/services/audio_service.dart';
import '../../../../l10n/l10n.dart';
import '../../../core/themes.dart';

/// Annonce, sur l'accueil, d'un nouveau rang du Cursus Honorum et des jeux du
/// Ludi qui viennent de s'ouvrir.
///
/// Avant, ces déblocages passaient en silence : l'élève ne découvrait le
/// Colisée qu'en ouvrant l'onglet Ludi par hasard (audit T58).
/// [ouvrirLudi] est appelé si l'élève choisit d'aller jouer tout de suite.
Future<void> annoncerDeblocages(
  BuildContext context, {
  CursusHonorum? rang,
  required List<String> jeux,
  required VoidCallback ouvrirLudi,
}) {
  HapticFeedback.mediumImpact();
  AudioService().playCardObtained();
  final l10n = context.l10n;
  return showDialog<void>(
    context: context,
    // Pas de fermeture par un appui à côté : l'annonce passerait inaperçue.
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        rang != null ? l10n.unlockRankTitle : l10n.unlockGameTitle,
        textAlign: TextAlign.center,
        style: const TextStyle(fontFamily: RomanFonts.imperial, fontWeight: FontWeight.bold, color: RomanColors.imperialPurple),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (rang != null) ...[
            Text(rang.badge, style: const TextStyle(fontSize: 44)),
            const SizedBox(height: 6),
            Text(
              l10n.unlockRankName(rang.titre, rang.sousTitre),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: RomanColors.imperialPurple),
            ),
            const SizedBox(height: 6),
            Text(rang.description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, height: 1.35)),
          ],
          if (rang != null && jeux.isNotEmpty) const Divider(height: 28),
          for (final jeu in jeux)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                l10n.unlockGameOpen(nomDuJeu(context, jeu)),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: RomanColors.laurelGreen),
              ),
            ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.unlockLater)),
        if (jeux.isNotEmpty)
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: RomanColors.imperialPurple),
            onPressed: () {
              Navigator.pop(ctx);
              ouvrirLudi();
            },
            child: Text(l10n.unlockGoPlay),
          ),
      ],
    ),
  );
}

/// Nom affiché d'un jeu du Ludi, à partir de sa clé de déblocage.
String nomDuJeu(BuildContext context, String cle) {
  final l10n = context.l10n;
  return switch (cle) {
    'duel' => l10n.unlockNameDuel,
    'taverne' => l10n.unlockNameTaverne,
    'cesar' => l10n.unlockNameCesar,
    'marche' => l10n.unlockNameMarche,
    'bataille' => l10n.bataTitle,
    _ => cle,
  };
}
