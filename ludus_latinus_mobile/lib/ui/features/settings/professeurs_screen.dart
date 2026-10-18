import 'package:flutter/material.dart';
import '../../../data/models/world.dart';
import '../../../data/repositories/game_repository.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../../l10n/l10n.dart';

/// Page « Pour les professeurs » : ce que chaque monde travaille du programme
/// de latin du collège (LCA, BO du 17 mars 2016), et les écarts assumés.
/// Les textes viennent du jeu de données (content/programme_lca.py).
class ProfesseursScreen extends StatelessWidget {
  final GameRepository repo;

  const ProfesseursScreen({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final page = repo.dataService.programmeLca;
    final mondes = {for (final w in repo.worlds) w.id: w};
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.teachersTitle)),
      body: SafeArea(
        child: page == null
            ? const SizedBox.shrink()
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  ColonneLecture(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(page.presentation, style: const TextStyle(fontSize: 15, height: 1.4)),
                        const SizedBox(height: 8),
                        Text(page.reference, style: _discret(context)),
                        for (final classe in repo.classes) ...[
                          const SizedBox(height: 24),
                          _Titre('${classe.icone} ${classe.titre} · ${classe.sousTitre}'),
                          for (final id in classe.mondesIds)
                            if (mondes[id]?.programme != null) _CarteMonde(world: mondes[id]!),
                        ],
                        const SizedBox(height: 24),
                        _Titre(context.l10n.teachersGaps),
                        for (final ecart in page.ecarts)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text('• $ecart', style: const TextStyle(fontSize: 14, height: 1.35)),
                          ),
                        const SizedBox(height: 24),
                        _Titre(context.l10n.teachersContact),
                        Text(page.relecture, style: const TextStyle(fontSize: 14, height: 1.35)),
                        const SizedBox(height: 6),
                        SelectableText(
                          page.contact,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

TextStyle _discret(BuildContext context) => TextStyle(
      fontSize: 12.5,
      fontStyle: FontStyle.italic,
      color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54,
    );

class _Titre extends StatelessWidget {
  final String texte;

  const _Titre(this.texte);

  @override
  Widget build(BuildContext context) {
    final sombre = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        texte,
        style: TextStyle(
          fontFamily: RomanFonts.imperial,
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: sombre ? RomanColors.goldLight : RomanColors.imperialPurple,
        ),
      ),
    );
  }
}

/// Une ligne du tableau : le monde, sa notion de langue, son thème culturel.
class _CarteMonde extends StatelessWidget {
  final World world;

  const _CarteMonde({required this.world});

  @override
  Widget build(BuildContext context) {
    final sombre = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: sombre ? RomanColors.darkCard : RomanColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: sombre ? RomanColors.darkBorder : RomanColors.marbleBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(world.title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          LignesProgramme(programme: world.programme!),
        ],
      ),
    );
  }
}

/// « Langue : … » et « Culture : … », partagé par la page et la fiche d'un monde.
class LignesProgramme extends StatelessWidget {
  final ProgrammeMonde programme;

  const LignesProgramme({super.key, required this.programme});

  @override
  Widget build(BuildContext context) {
    final sombre = Theme.of(context).brightness == Brightness.dark;
    final etiquette = TextStyle(
      fontWeight: FontWeight.bold,
      color: sombre ? RomanColors.imperialGold : RomanColors.imperialPurple,
    );
    Widget ligne(String titre, String texte) => Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text.rich(
            TextSpan(children: [TextSpan(text: '$titre : ', style: etiquette), TextSpan(text: texte)]),
            style: const TextStyle(fontSize: 13.5, height: 1.35),
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ligne(context.l10n.programmeLangue, programme.langue),
        ligne(context.l10n.programmeCulture, programme.culture),
      ],
    );
  }
}

/// Fiche « Au programme » d'un monde, ouverte depuis sa bannière sur la carte.
Future<void> montrerProgrammeMonde(BuildContext context, World world, String numero) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: ColonneLecture(
        largeurMax: 640,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Titre(context.l10n.mapProgrammeTitre(numero)),
              LignesProgramme(programme: world.programme!),
              const SizedBox(height: 12),
              Text(context.l10n.programmeSource, style: _discret(context)),
            ],
          ),
        ),
      ),
    ),
  );
}
