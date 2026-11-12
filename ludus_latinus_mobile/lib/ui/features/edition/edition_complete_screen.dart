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
///
/// Même illustration que l'écran titre (la terrasse face au Vésuve) : l'achat
/// prolonge le voyage annoncé au lancement, il ne ressemble pas à une boutique.
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
  static const _illustration = 'assets/images/titre/paysage.webp';
  static const _hauteurBandeau = 250.0;
  static const _orPale = Color(0xFFF6DFA0);
  static const _ombre = Color(0xFF1E0F2B);

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
    final sombre = Theme.of(context).brightness == Brightness.dark;
    final fond = sombre ? RomanColors.darkBackground : RomanColors.travertinWhite;
    return Scaffold(
      backgroundColor: fond,
      body: ListenableBuilder(
        listenable: _achats,
        builder: (context, _) => Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                _bandeau(context, fond),
                ColonneLecture(
                  largeurMax: 560,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _achats.editionComplete ? _merci(context, sombre) : _offre(context, sombre),
                    ),
                  ),
                ),
              ],
            ),
            // Retour posé sur l'illustration : une barre d'application la couperait.
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton.filled(
                  onPressed: () => Navigator.of(context).maybePop(),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  style: IconButton.styleFrom(backgroundColor: _ombre.withValues(alpha: 0.55)),
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Illustration fondue dans le fond de l'écran, titre en or sur le ciel.
  Widget _bandeau(BuildContext context, Color fond) {
    final l10n = context.l10n;
    final haut = MediaQuery.paddingOf(context).top;
    return SizedBox(
      height: _hauteurBandeau + haut,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(_illustration, fit: BoxFit.cover, alignment: const Alignment(0.3, -0.2)),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_ombre.withValues(alpha: 0.35), _ombre.withValues(alpha: 0.15), fond],
                stops: const [0, 0.55, 1],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 18,
            child: Column(
              children: [
                Text(
                  l10n.editionTitle.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3,
                    color: RomanColors.imperialGold,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    l10n.editionHeadline,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: RomanFonts.imperial,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).brightness == Brightness.dark ? _orPale : RomanColors.imperialPurple,
                      shadows: const [Shadow(color: Color(0x66FFFFFF), blurRadius: 10)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _merci(BuildContext context, bool sombre) => [
        Center(child: Image.asset(lupulusAnimation(LupulusMood.triomphe), height: 150)),
        const SizedBox(height: 12),
        Text(
          context.l10n.editionThanks,
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: RomanFonts.imperial, fontSize: 19, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 24),
        _BoutonOr(texte: context.l10n.editionContinue, onPressed: () => Navigator.of(context).pop()),
      ];

  List<Widget> _offre(BuildContext context, bool sombre) {
    final l10n = context.l10n;
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
    final discret = sombre ? Colors.white60 : Colors.black54;
    return [
      _Atout(icone: Icons.lock_open_rounded, texte: l10n.editionFree, sombre: sombre),
      _Atout(icone: Icons.route_rounded, texte: l10n.editionUnlocks(widget.repo.nombreLeconsDeLEdition), sombre: sombre),
      _Atout(icone: Icons.verified_rounded, texte: l10n.editionPromise, sombre: sombre),
      const SizedBox(height: 34),
      // Lupulus, animé et détouré, attend à demi posé sur le cadre.
      Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
            decoration: BoxDecoration(
              color: sombre ? RomanColors.darkCard : RomanColors.goldLight,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: RomanColors.imperialGold, width: 1.5),
              boxShadow: const [BoxShadow(color: Color(0x22D4AF37), blurRadius: 16, offset: Offset(0, 6))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _BoutonOr(
                  texte: l10n.editionBuy(prix ?? '3,99 €'),
                  chargement: etat == EtatAchat.enCours,
                  onPressed: peutAcheter ? _achats.acheter : null,
                ),
                if (message != null) ...[
                  const SizedBox(height: 10),
                  Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 13.5, color: discret)),
                ],
                const SizedBox(height: 12),
                Text(
                  l10n.editionParent,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.5, fontStyle: FontStyle.italic, color: discret),
                ),
              ],
            ),
          ),
          Positioned(
            right: 4,
            top: -58,
            child: IgnorePointer(
              child: Image.asset(lupulusAnimation(LupulusMood.attente), height: 80),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Center(
        child: TextButton.icon(
          onPressed: _restaurationEnCours ? null : _restaurer,
          icon: const Icon(Icons.restore_rounded, size: 18),
          label: Text(l10n.editionRestore),
        ),
      ),
    ];
  }
}

/// Une promesse de l'Édition complète, avec son médaillon.
class _Atout extends StatelessWidget {
  final IconData icone;
  final String texte;
  final bool sombre;

  const _Atout({required this.icone, required this.texte, required this.sombre});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: sombre ? RomanColors.darkCard : RomanColors.palatinCream,
              border: Border.all(color: RomanColors.imperialGold, width: 1.2),
            ),
            child: Icon(icone, size: 20, color: sombre ? RomanColors.lunarGold : RomanColors.imperialPurple),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(texte, style: const TextStyle(fontSize: 15, height: 1.4)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bouton principal doré, dans le ton des boutons « Avancer sur la route ».
class _BoutonOr extends StatelessWidget {
  final String texte;
  final VoidCallback? onPressed;
  final bool chargement;

  const _BoutonOr({required this.texte, required this.onPressed, this.chargement = false});

  @override
  Widget build(BuildContext context) {
    final actif = onPressed != null;
    return Opacity(
      opacity: actif || chargement ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFF7D878), Color(0xFFC79820)]),
            borderRadius: BorderRadius.circular(14),
            boxShadow: actif ? const [BoxShadow(color: Color(0x44C79820), blurRadius: 10, offset: Offset(0, 4))] : null,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onPressed,
            child: Center(
              child: chargement
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF2C1E0A)),
                    )
                  : Text(
                      texte,
                      style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800, color: Color(0xFF2C1E0A)),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
