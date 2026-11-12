import 'package:flutter/material.dart';

import '../../../data/models/lesson.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/achat_service.dart';
import '../../../l10n/l10n.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../lesson/lesson_screen.dart';

/// Ouvre une leçon, ou l'écran de l'Édition complète si elle lui est réservée.
/// Point d'entrée unique : la carte et l'accueil passent tous deux par ici.
Future<void> ouvrirLecon(BuildContext context, GameRepository repo, Lesson lecon) async {
  if (repo.leconReservee(lecon)) {
    await EditionCompleteScreen.montrer(context, repo);
    // Achat fait depuis l'écran : l'élève voulait cette leçon, on l'ouvre.
    if (!context.mounted || repo.leconReservee(lecon)) return;
  }
  await Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => LessonScreen(repo: repo, lesson: lecon)),
  );
}

/// Ce que l'Édition complète ajoute, son prix, et la restauration d'un achat.
class EditionCompleteScreen extends StatefulWidget {
  final GameRepository repo;

  const EditionCompleteScreen({super.key, required this.repo});

  static Future<void> montrer(BuildContext context, GameRepository repo) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => EditionCompleteScreen(repo: repo)),
      );

  @override
  State<EditionCompleteScreen> createState() => _EditionCompleteScreenState();
}

class _EditionCompleteScreenState extends State<EditionCompleteScreen> {
  bool _restaurationEnCours = false;

  AchatService get _achats => widget.repo.achats;

  Future<void> _restaurer() async {
    setState(() => _restaurationEnCours = true);
    final retrouve = await _achats.restaurer();
    if (!mounted) return;
    setState(() => _restaurationEnCours = false);
    if (!retrouve) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.editionRestoreNone)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.editionTitle)),
      body: ListenableBuilder(
        listenable: _achats,
        builder: (context, _) => ColonneLecture(
          largeurMax: 560,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            children: [
              Center(
                child: ClipOval(
                  child: Image.asset('assets/images/logo_centurion_120.png', width: 96, height: 96),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.editionHeadline,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: RomanFonts.imperial,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: RomanColors.imperialPurple,
                ),
              ),
              const SizedBox(height: 20),
              if (_achats.editionComplete) ..._merci(context) else ..._offre(context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _merci(BuildContext context) => [
        Text(context.l10n.editionThanks, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17)),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.editionContinue),
        ),
      ];

  List<Widget> _offre(BuildContext context) {
    final l10n = context.l10n;
    const corps = TextStyle(fontSize: 15.5, height: 1.4);
    final etat = _achats.etat;
    final prix = _achats.prix;
    // Le bouton n'est actif qu'avec un prix venu du Play Store : on ne vend
    // jamais à un prix que Google n'a pas confirmé.
    final peutAcheter = prix != null && (etat == EtatAchat.pret || etat == EtatAchat.erreur);
    final message = switch (etat) {
      EtatAchat.chargement => l10n.editionLoading,
      EtatAchat.indisponible => l10n.editionUnavailable,
      EtatAchat.enAttente => l10n.editionPending,
      EtatAchat.erreur => l10n.editionError,
      EtatAchat.pret || EtatAchat.enCours => null,
    };
    return [
      Text(l10n.editionFree, style: corps),
      const SizedBox(height: 10),
      Text(l10n.editionUnlocks(widget.repo.nombreLeconsDeLEdition), style: corps),
      const SizedBox(height: 10),
      Text(l10n.editionPromise, style: corps),
      const SizedBox(height: 24),
      FilledButton(
        onPressed: peutAcheter ? _achats.acheter : null,
        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
        child: etat == EtatAchat.enCours
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
            : Text(l10n.editionBuy(prix ?? '3,99 €'), style: const TextStyle(fontSize: 16)),
      ),
      if (message != null) ...[
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
      ],
      const SizedBox(height: 16),
      Text(
        l10n.editionParent,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13.5, fontStyle: FontStyle.italic, color: Colors.black54),
      ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: _restaurationEnCours ? null : _restaurer,
        child: Text(l10n.editionRestore),
      ),
    ];
  }
}
