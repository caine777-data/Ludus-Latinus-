import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/repositories/game_repository.dart';
import '../../../l10n/l10n.dart';
import '../../core/themes.dart';
import '../settings/choix_profil_screen.dart';

/// Écran titre, montré à chaque lancement après les cinématiques.
///
/// Une illustration par orientation : les tablettes tournent librement et
/// Windows s'affiche en paysage, or le recadrage de l'image portrait y couperait
/// le garçon. Le titre se pose dans la zone de ciel laissée libre par chacune.
class EcranTitreScreen extends StatefulWidget {
  final GameRepository repo;

  const EcranTitreScreen({super.key, required this.repo});

  @override
  State<EcranTitreScreen> createState() => _EcranTitreScreenState();
}

class _EcranTitreScreenState extends State<EcranTitreScreen> with TickerProviderStateMixin {
  static const _imagePortrait = 'assets/images/titre/portrait.webp';
  static const _imagePaysage = 'assets/images/titre/paysage.webp';
  static const _orPale = Color(0xFFF6DFA0);
  static const _ombre = Color(0xFF1E0F2B);
  static const _zoomMax = 1.07;

  // Zoom assez lent pour que l'image semble vivre sans distraire de la lecture.
  late final AnimationController _zoom =
      AnimationController(vsync: this, duration: const Duration(seconds: 24));
  late final AnimationController _pulsation =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
  bool _sorti = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Réglage « réduire les animations » du système : l'écran reste immobile.
    if (MediaQuery.disableAnimationsOf(context)) {
      _zoom.stop();
      _pulsation.value = 1;
    } else {
      if (!_zoom.isAnimating) _zoom.repeat(reverse: true);
      if (!_pulsation.isAnimating) _pulsation.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _zoom.dispose();
    _pulsation.dispose();
    super.dispose();
  }

  /// Un double appui ne doit pas dépiler aussi l'écran du dessous.
  void _entrer() {
    if (_sorti) return;
    _sorti = true;
    HapticFeedback.selectionClick();
    Navigator.of(context).pop();
  }

  /// Autre élève choisi : on entre aussitôt, il n'a pas à toucher l'écran une
  /// seconde fois. S'il revient sans changer, il retrouve le titre.
  Future<void> _changerDEleve() async {
    final change = await ChoixProfilScreen.montrer(context, widget.repo);
    if (change && mounted) _entrer();
  }

  KeyEventResult _surTouche(FocusNode _, KeyEvent evenement) {
    if (evenement is! KeyDownEvent) return KeyEventResult.ignored;
    final touche = evenement.logicalKey;
    if (touche != LogicalKeyboardKey.enter &&
        touche != LogicalKeyboardKey.numpadEnter &&
        touche != LogicalKeyboardKey.space) {
      return KeyEventResult.ignored;
    }
    _entrer();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _ombre,
      body: Focus(
        autofocus: true,
        onKeyEvent: _surTouche,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _entrer,
          child: LayoutBuilder(
            builder: (context, contraintes) {
              final paysage = contraintes.maxWidth > contraintes.maxHeight;
              return Stack(
                fit: StackFit.expand,
                children: [
                  _image(paysage),
                  _voile(paysage),
                  SafeArea(child: paysage ? _textesPaysage(contraintes) : _textesPortrait(contraintes)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _image(bool paysage) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1, end: _zoomMax)
          .animate(CurvedAnimation(parent: _zoom, curve: Curves.easeInOut)),
      // Le zoom part du garçon : il reste à l'écran quel que soit le recadrage.
      alignment: paysage ? const Alignment(0.6, 0.2) : const Alignment(0, 0.7),
      child: Image.asset(
        paysage ? _imagePaysage : _imagePortrait,
        fit: BoxFit.cover,
        alignment: paysage ? Alignment.centerRight : const Alignment(0, 0.7),
      ),
    );
  }

  /// Le ciel est clair au couchant : sans voile, l'or du titre s'y perdrait.
  Widget _voile(bool paysage) {
    final decoration = paysage
        ? LinearGradient(
            colors: [_ombre.withValues(alpha: 0.82), _ombre.withValues(alpha: 0.35), _ombre.withValues(alpha: 0)],
            stops: const [0, 0.42, 0.62],
          )
        : LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _ombre.withValues(alpha: 0.78),
              _ombre.withValues(alpha: 0.28),
              _ombre.withValues(alpha: 0),
              _ombre.withValues(alpha: 0),
              _ombre.withValues(alpha: 0.82),
            ],
            stops: const [0, 0.3, 0.42, 0.76, 1],
          );
    return DecoratedBox(decoration: BoxDecoration(gradient: decoration));
  }

  Widget _textesPortrait(BoxConstraints contraintes) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Column(
        children: [
          ..._titre(contraintes.maxWidth, TextAlign.center),
          const Spacer(),
          ..._invite(TextAlign.center),
        ],
      ),
    );
  }

  Widget _textesPaysage(BoxConstraints contraintes) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: contraintes.maxWidth * 0.5,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 24, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              ..._titre(contraintes.maxWidth * 0.42, TextAlign.start),
              const Spacer(),
              ..._invite(TextAlign.start),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _titre(double largeur, TextAlign alignement) {
    final profil = widget.repo.profile;
    final prenom = profil.heroChoisi ? profil.nomHeros.trim() : '';
    final centre = alignement == TextAlign.center;
    return [
      // Le titre tient toujours sur une ligne : il rétrécit au lieu de se couper,
      // quelle que soit la taille de police réglée sur l'appareil.
      FittedBox(
        fit: BoxFit.scaleDown,
        alignment: centre ? Alignment.center : Alignment.centerLeft,
        child: Text(
          'LUDUS LATINUS',
          maxLines: 1,
          style: TextStyle(
            fontFamily: RomanFonts.imperial,
            fontSize: (largeur * 0.1).clamp(28, 60).toDouble(),
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: _orPale,
            shadows: const [Shadow(color: Color(0xCC000000), blurRadius: 12, offset: Offset(0, 2))],
          ),
        ),
      ),
      const SizedBox(height: 10),
      Text(
        context.l10n.titleTagline,
        textAlign: alignement,
        style: _styleClair(16),
      ),
      if (prenom.isNotEmpty) ...[
        const SizedBox(height: 18),
        Text(
          context.l10n.titleGreeting(prenom),
          textAlign: alignement,
          style: _styleClair(22).copyWith(fontFamily: RomanFonts.imperial, color: _orPale),
        ),
      ],
    ];
  }

  List<Widget> _invite(TextAlign alignement) {
    final l10n = context.l10n;
    final surOrdinateur = defaultTargetPlatform == TargetPlatform.windows;
    return [
      FadeTransition(
        opacity: Tween<double>(begin: 0.45, end: 1).animate(_pulsation),
        child: Text(
          surOrdinateur ? l10n.titleEnterClick : l10n.titleEnterTouch,
          textAlign: alignement,
          style: _styleClair(17).copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      if (widget.repo.nombreDeProfils > 1) ...[
        const SizedBox(height: 6),
        TextButton(
          onPressed: _changerDEleve,
          style: TextButton.styleFrom(foregroundColor: _orPale),
          child: Text(l10n.profilesSwitch, style: const TextStyle(decoration: TextDecoration.underline, decorationColor: _orPale)),
        ),
      ],
    ];
  }

  TextStyle _styleClair(double taille) => TextStyle(
        fontSize: taille,
        height: 1.3,
        color: Colors.white,
        shadows: const [Shadow(color: Color(0xCC000000), blurRadius: 8, offset: Offset(0, 1))],
      );
}
