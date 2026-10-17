import 'package:flutter/material.dart';
import '../../../data/models/album.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import '../../../l10n/l10n.dart';
import '../../core/themes.dart';

/// Couleur de bordure d'une carte selon sa rareté (reprise de l'appli bureau).
Color couleurRarete(String rarete) {
  switch (rarete) {
    case 'rare':
      return const Color(0xFF2980B9);
    case 'epique':
      return const Color(0xFF8E44AD);
    case 'legendaire':
      return const Color(0xFFD4AF37);
  }
  return const Color(0xFF7F8C8D);
}

String libelleRarete(BuildContext context, String rarete) {
  switch (rarete) {
    case 'rare':
      return context.l10n.albumRarityRare;
    case 'epique':
      return context.l10n.albumRarityEpic;
    case 'legendaire':
      return context.l10n.albumRarityLegendary;
  }
  return context.l10n.albumRarityCommon;
}

String libelleFamille(BuildContext context, String famille) {
  switch (famille) {
    case 'divinites':
      return context.l10n.albumFamilyGods;
    case 'monstres':
      return context.l10n.albumFamilyCreatures;
    case 'monuments':
      return context.l10n.albumFamilyMonuments;
  }
  return context.l10n.albumFamilyHeroes;
}

IconData iconeFamille(String famille) {
  switch (famille) {
    case 'divinites':
      return Icons.auto_awesome_rounded;
    case 'monstres':
      return Icons.pets_rounded;
    case 'monuments':
      return Icons.account_balance_rounded;
  }
  return Icons.shield_rounded;
}

/// Illustration d'une carte. Tant que l'image n'est pas livrée, une icône sur
/// fond de la couleur de rareté la remplace.
class ImageCarteAlbum extends StatelessWidget {
  final CarteAlbum carte;
  final double tailleIcone;
  const ImageCarteAlbum({super.key, required this.carte, this.tailleIcone = 34});

  @override
  Widget build(BuildContext context) {
    final couleur = couleurRarete(carte.rarete);
    final repli = Container(
      color: couleur.withValues(alpha: 0.14),
      alignment: Alignment.center,
      child: Icon(iconeFamille(carte.categorie), size: tailleIcone, color: couleur),
    );
    return Image.asset(carte.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => repli);
  }
}

/// Album « Héros et Créatures » : une carte par succès.
class AlbumScreen extends StatefulWidget {
  final GameRepository repo;
  const AlbumScreen({super.key, required this.repo});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  String _famille = famillesAlbum.first;

  @override
  Widget build(BuildContext context) {
    final repo = widget.repo;
    // Ordre des succès (du monde 1 aux 26 mondes), pas celui du fichier des cartes.
    final rang = {for (var i = 0; i < repo.succesAlbum.length; i++) repo.succesAlbum[i].carteId: i};
    final cartes = repo.cartesAlbum.where((c) => c.categorie == _famille).toList()
      ..sort((a, b) => (rang[a.id] ?? 99).compareTo(rang[b.id] ?? 99));
    final obtenues = repo.profile.cartesAlbum.length;
    final sesterces = [
      for (final id in repo.profile.cartesAlbum)
        if (repo.carteAlbum(id) != null) repo.sesterceDeLaCarte(repo.carteAlbum(id)!),
    ].fold<int>(0, (a, b) => a + b);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.albumTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: RomanColors.imperialPurple,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.albumHeaderLabel,
                            style: const TextStyle(color: RomanColors.goldLight, fontSize: 12, letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Text(context.l10n.albumHeaderHint, style: const TextStyle(color: Colors.white, fontSize: 14)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 16,
                          runSpacing: 4,
                          children: [
                            Text(context.l10n.albumCount(obtenues, repo.cartesAlbum.length),
                                style: const TextStyle(
                                    color: RomanColors.goldLight, fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(context.l10n.albumEarned(sesterces),
                                style: const TextStyle(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final f in famillesAlbum)
                        ChoiceChip(
                          selected: f == _famille,
                          onSelected: (_) => setState(() => _famille = f),
                          avatar: Icon(iconeFamille(f), size: 16),
                          label: Text(
                              '${libelleFamille(context, f)} ${repo.cartesAlbum.where((c) => c.categorie == f && repo.aLaCarte(c.id)).length}/${repo.cartesAlbum.where((c) => c.categorie == f).length}'),
                        ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverGrid(
                  // Cartes en portrait : la grille ajoute des colonnes sur tablette.
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.62,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _TuileCarte(repo: repo, carte: cartes[i]),
                    childCount: cartes.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TuileCarte extends StatelessWidget {
  final GameRepository repo;
  final CarteAlbum carte;
  const _TuileCarte({required this.repo, required this.carte});

  @override
  Widget build(BuildContext context) {
    final obtenue = repo.aLaCarte(carte.id);
    final couleur = couleurRarete(carte.rarete);
    final succes = repo.succesDeLaCarte(carte.id);

    if (obtenue) {
      return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => montrerCarteAlbum(context, carte),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: couleur, width: 2),
          ),
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(borderRadius: BorderRadius.circular(8), child: ImageCarteAlbum(carte: carte)),
              ),
              const SizedBox(height: 6),
              Text(carte.nom,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'serif', color: RomanColors.imperialPurple)),
              Text(libelleRarete(context, carte.rarete), style: TextStyle(fontSize: 11, color: couleur)),
            ],
          ),
        ),
      );
    }

    // Carte verrouillée : son succès et la progression vers le seuil.
    final valeur = succes == null ? 0 : repo.valeurStat(succes.stat).clamp(0, succes.seuil);
    final seuil = succes?.seuil ?? 1;
    return Container(
      decoration: BoxDecoration(
        color: RomanColors.palatinCream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RomanColors.marbleBorder, width: 1.2),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(child: Center(child: Icon(Icons.lock_rounded, color: Colors.black26, size: 30))),
          Text(carte.nom,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 2),
          Text(succes?.texte ?? '',
              maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Colors.black54)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: valeur / seuil,
              minHeight: 5,
              backgroundColor: const Color(0xFFEFE6D2),
              color: RomanColors.imperialGold,
            ),
          ),
          const SizedBox(height: 3),
          Text('$valeur / $seuil', style: const TextStyle(fontSize: 11, color: Color(0xFF854F0B))),
        ],
      ),
    );
  }
}

/// Grande carte : illustration, devise latine, traduction et anecdote.
Future<void> montrerCarteAlbum(BuildContext context, CarteAlbum carte) {
  final couleur = couleurRarete(carte.rarete);
  return showDialog<void>(
    context: context,
    builder: (ctx) => Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: BorderSide(color: couleur, width: 3)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(aspectRatio: 3 / 4, child: ImageCarteAlbum(carte: carte, tailleIcone: 72)),
              ),
              const SizedBox(height: 12),
              Text(carte.nom,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'serif', color: RomanColors.imperialPurple)),
              Text(carte.nomLatin,
                  textAlign: TextAlign.center, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black54)),
              const SizedBox(height: 6),
              Text('${libelleRarete(ctx, carte.rarete)} · ${libelleFamille(ctx, carte.categorie)}',
                  textAlign: TextAlign.center, style: TextStyle(color: couleur, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.flash_on_rounded, size: 18, color: Color(0xFF8E1724)),
                  Text(' ${ctx.l10n.albumAttack} ${carte.attaque}   '),
                  const Icon(Icons.shield_outlined, size: 18, color: Color(0xFF185FA5)),
                  Text(' ${ctx.l10n.albumDefense} ${carte.defense}'),
                ],
              ),
              const SizedBox(height: 12),
              Text('« ${carte.citation} »',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15, color: RomanColors.imperialPurple)),
              Text(carte.traduction, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87)),
              const SizedBox(height: 10),
              Text(carte.anecdote, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, height: 1.4)),
              const SizedBox(height: 12),
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(ctx.l10n.albumClose)),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Annonce des cartes gagnées depuis la dernière fois, montrée à l'accueil.
/// Plusieurs cartes gagnées d'un coup (un vieux profil qui découvre l'album)
/// sont annoncées ensemble.
Future<void> annoncerCartes(BuildContext context, GameRepository repo, List<CarteAlbum> cartes) {
  final premiere = cartes.first;
  final couleur = couleurRarete(premiere.rarete);
  final sesterces = cartes.fold<int>(0, (a, c) => a + repo.sesterceDeLaCarte(c));
  AudioService().playCardObtained();
  return showDialog<void>(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: const Color(0xFF3A2A2E),
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(cartes.length == 1 ? ctx.l10n.albumNewCard : ctx.l10n.albumNewCards(cartes.length),
                  style: const TextStyle(color: RomanColors.goldLight, letterSpacing: 2, fontSize: 13)),
              const SizedBox(height: 14),
              Container(
                width: 190,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: RomanColors.palatinCream,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: couleur, width: 3),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(aspectRatio: 3 / 4, child: ImageCarteAlbum(carte: premiere, tailleIcone: 56)),
                    ),
                    const SizedBox(height: 6),
                    Text(premiere.nom,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: 'serif', color: RomanColors.imperialPurple)),
                    Text('${libelleRarete(ctx, premiere.rarete)} · ${libelleFamille(ctx, premiere.categorie)}',
                        style: TextStyle(fontSize: 11, color: couleur)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                cartes.length == 1
                    ? ctx.l10n.albumAchievement(repo.succesDeLaCarte(premiere.id)?.texte ?? '')
                    : cartes.skip(1).map((c) => c.nom).join(', '),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 4),
              Text(ctx.l10n.albumReward(sesterces), style: const TextStyle(color: RomanColors.goldLight)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: RomanColors.goldLight, side: const BorderSide(color: RomanColors.goldLight)),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => AlbumScreen(repo: repo)));
                    },
                    child: Text(ctx.l10n.albumOpen),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: RomanColors.imperialGold, foregroundColor: RomanColors.charcoal),
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(ctx.l10n.albumContinue),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Résumé de l'album pour l'écran Compte : nombre de cartes et dernières obtenues.
class ResumeAlbum extends StatelessWidget {
  final GameRepository repo;
  const ResumeAlbum({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final ids = repo.profile.cartesAlbum;
    final dernieres = [
      for (final id in ids.reversed.take(3))
        if (repo.carteAlbum(id) != null) repo.carteAlbum(id)!,
    ];
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AlbumScreen(repo: repo))),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: RomanColors.marbleBorder, width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.style_rounded, color: RomanColors.imperialPurple),
                const SizedBox(width: 8),
                // Titre et compteur l'un sous l'autre : côte à côte, le titre
                // serait écrasé sur un petit écran ou en grande police.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.albumTitle,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'serif')),
                      Text(context.l10n.albumCount(ids.length, repo.cartesAlbum.length),
                          style: const TextStyle(color: RomanColors.imperialPurple, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.black38),
              ],
            ),
            const SizedBox(height: 10),
            if (dernieres.isEmpty)
              Text(context.l10n.albumEmpty, style: const TextStyle(fontSize: 13, color: Colors.black54))
            else
              Row(
                children: [
                  for (final c in dernieres)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        width: 64,
                        height: 86,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: couleurRarete(c.rarete), width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: ImageCarteAlbum(carte: c, tailleIcone: 24),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
