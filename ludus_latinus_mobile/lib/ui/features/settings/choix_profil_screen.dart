import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/models/profile.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../l10n/l10n.dart';
import '../../core/avatar_assets.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import 'hero_creation_screen.dart';

/// « Qui joue ? » : un médaillon par élève de l'appareil (4 au plus), et un
/// bouton pour en ajouter un. S'ouvre par « Changer d'élève », sur l'écran titre
/// et dans les Paramètres.
class ChoixProfilScreen extends StatefulWidget {
  final GameRepository repo;

  const ChoixProfilScreen({super.key, required this.repo});

  /// Ouvre l'écran ; renvoie vrai si l'élève actif a changé (ou vient d'être créé).
  static Future<bool> montrer(BuildContext context, GameRepository repo) async {
    final change = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => ChoixProfilScreen(repo: repo)),
    );
    return change ?? false;
  }

  @override
  State<ChoixProfilScreen> createState() => _ChoixProfilScreenState();
}

class _ChoixProfilScreenState extends State<ChoixProfilScreen> {
  late Future<List<UserProfile>> _profils;
  bool _occupe = false;

  @override
  void initState() {
    super.initState();
    _profils = widget.repo.profilsDeLAppareil();
  }

  Future<void> _choisir(UserProfile profil) async {
    if (_occupe) return;
    HapticFeedback.selectionClick();
    final change = profil.id != widget.repo.storageService.idActif;
    setState(() => _occupe = true);
    if (change) await widget.repo.changerDeProfil(profil.id);
    if (mounted) Navigator.of(context).pop(change);
  }

  /// Nouvel élève : profil vierge, création du héros, puis l'accueil ouvrira
  /// sa première leçon (GameRepository.premiereLeconAOuvrir).
  Future<void> _ajouter() async {
    if (_occupe) return;
    HapticFeedback.selectionClick();
    setState(() => _occupe = true);
    if (!await widget.repo.ajouterProfil()) {
      if (mounted) setState(() => _occupe = false);
      return;
    }
    if (!mounted) return;
    final heroCree = await HeroCreationScreen.showIfNeeded(context, widget.repo);
    if (heroCree && widget.repo.profile.completedLessons.isEmpty) widget.repo.premiereLeconAOuvrir = true;
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.profilesWho),
      ),
      body: ColonneLecture(
        largeurMax: 640,
        child: FutureBuilder<List<UserProfile>>(
          future: _profils,
          builder: (context, instantane) {
            final profils = instantane.data;
            if (profils == null) return const Center(child: CircularProgressIndicator());
            return GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.78,
              children: [
                for (final p in profils)
                  _Medaillon(
                    profil: p,
                    actif: p.id == widget.repo.storageService.idActif,
                    onTap: () => _choisir(p),
                  ),
                if (widget.repo.peutAjouterProfil) _NouvelEleve(onTap: _ajouter),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Carte extends StatelessWidget {
  final bool actif;
  final VoidCallback onTap;
  final Widget child;

  const _Carte({required this.actif, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: actif ? RomanColors.goldLight : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: actif ? RomanColors.imperialGold : RomanColors.marbleBorder, width: actif ? 2 : 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(12), child: child),
      ),
    );
  }
}

/// Un élève : son héros, son prénom, son rang, sa série et ses leçons.
class _Medaillon extends StatelessWidget {
  final UserProfile profil;
  final bool actif;
  final VoidCallback onTap;

  const _Medaillon({required this.profil, required this.actif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final serie = profil.currentStreak();
    return Semantics(
      button: true,
      selected: actif,
      label: profil.heroChoisi ? profil.nomHeros : context.l10n.profilesNewHero,
      excludeSemantics: false,
      child: _Carte(
        actif: actif,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                AvatarAssets.medaillon(profil),
                width: 84,
                height: 84,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 64, color: RomanColors.imperialPurple),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              profil.heroChoisi ? profil.nomHeros : context.l10n.profilesNewHero,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: RomanColors.imperialPurple),
            ),
            const SizedBox(height: 2),
            Text(profil.cursusRank.titre, style: const TextStyle(fontSize: 12.5, color: Colors.black54)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const IconeFlamme(taille: 16),
                Text(' $serie j', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(width: 10),
                Text(
                  context.l10n.profilesLessons(profil.completedLessons.length),
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NouvelEleve extends StatelessWidget {
  final VoidCallback onTap;

  const _NouvelEleve({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _Carte(
      actif: false,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: RomanColors.palatinCream,
              border: Border.all(color: RomanColors.imperialGold, width: 1.5),
            ),
            child: const Icon(Icons.add_rounded, size: 44, color: RomanColors.imperialPurple),
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.profilesNew,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: RomanColors.imperialPurple),
          ),
        ],
      ),
    );
  }
}
