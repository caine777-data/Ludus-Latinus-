import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../data/models/world.dart';
import '../../data/services/audio_service.dart';
import 'themes.dart';

/// Type de cinématique antique à afficher.
enum CinematicType {
  intro,
  bossEntrance,
  triumph,
}

/// Configuration d'une courte vidéo cinématique (vidéos verticales 9:16 avec bande-son).
class CinematicConfig {
  final String assetPath;
  final String title;
  final String subtitle;

  const CinematicConfig({
    required this.assetPath,
    required this.title,
    required this.subtitle,
  });

  static CinematicConfig forType(CinematicType type, {String? extraInfo, String? video}) {
    switch (type) {
      case CinematicType.intro:
        return const CinematicConfig(
          assetPath: 'assets/cinematics/intro.mp4',
          title: 'LUDUS LATINUS',
          subtitle: '« Per aspera ad astra » : par des chemins ardus, jusqu\'aux étoiles',
        );
      case CinematicType.bossEntrance:
        return CinematicConfig(
          // Chaque champion a son entrée ; la vidéo générique reste en secours.
          assetPath: video ?? 'assets/cinematics/boss_entrance.mp4',
          title: 'COLOSSEUM DUELLUM',
          subtitle: extraInfo != null ? 'Ton adversaire : $extraInfo' : '« Ave Caesar, morituri te salutant ! »',
        );
      case CinematicType.triumph:
        return CinematicConfig(
          assetPath: 'assets/cinematics/triumph.mp4',
          title: 'TRIUMPHUS',
          subtitle: extraInfo ?? 'Rome célèbre ta victoire !',
        );
    }
  }
}

/// Lecteur plein écran d'une courte vidéo cinématique, avec bouton « Passer ».
class RomanCinematicPlayer extends StatefulWidget {
  final CinematicConfig config;
  final VoidCallback? onCompleted;
  final bool showSkipButton;

  const RomanCinematicPlayer({
    super.key,
    required this.config,
    this.onCompleted,
    this.showSkipButton = true,
  });

  @override
  State<RomanCinematicPlayer> createState() => _RomanCinematicPlayerState();
}

class _RomanCinematicPlayerState extends State<RomanCinematicPlayer> {
  late final VideoPlayerController _controller;
  Timer? _safetyTimer;
  bool _ready = false;
  bool _isExiting = false;

  @override
  void initState() {
    super.initState();
    // La vidéo a sa propre bande-son : la musique d'ambiance se tait.
    AudioService().enterMusic(null);
    _controller = VideoPlayerController.asset(
      widget.config.assetPath,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controller.addListener(_onTick);
    _controller.initialize().then((_) {
      if (!mounted) return;
      // Respecte le réglage « muet » de l'appli.
      _controller.setVolume(AudioService().isMuted ? 0 : AudioService().volume);
      _controller.play();
      setState(() => _ready = true);
    }).catchError((_) {
      // Vidéo illisible sur cet appareil : on ne bloque jamais l'élève.
      _handleExit();
    });
    // Filet de sécurité si la vidéo ne signale jamais sa fin.
    _safetyTimer = Timer(const Duration(seconds: 15), _handleExit);
  }

  void _onTick() {
    final v = _controller.value;
    if (v.isInitialized && !v.isPlaying && v.duration > Duration.zero && v.position >= v.duration) {
      _handleExit();
    }
  }

  @override
  void dispose() {
    _safetyTimer?.cancel();
    _controller.removeListener(_onTick);
    _controller.dispose();
    AudioService().leaveMusic(null);
    super.dispose();
  }

  void _handleExit() {
    if (_isExiting) return;
    _isExiting = true;
    _safetyTimer?.cancel();
    _controller.pause();
    widget.onCompleted?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Vidéo verticale en plein écran (recadrée sur les écrans plus allongés).
          AnimatedOpacity(
            opacity: _ready ? 1 : 0,
            duration: const Duration(milliseconds: 350),
            child: _ready
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Bouton « Passer » (zone tactile ≥ 48 dp).
          if (widget.showSkipButton)
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Material(
                    color: Colors.black.withOpacity(0.55),
                    shape: StadiumBorder(side: BorderSide(color: RomanColors.imperialGold.withOpacity(0.8))),
                    child: InkWell(
                      customBorder: const StadiumBorder(),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _handleExit();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'PASSER',
                              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward_ios, size: 13, color: RomanColors.imperialGold),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Titre sur un dégradé sombre en bas, lisible sur toutes les images.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 36),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00000000), Color(0xCC000000)],
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.config.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: RomanFonts.imperial,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: RomanColors.imperialGold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.config.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.white, height: 1.35),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Affiche une cinématique par-dessus l'écran courant.
class RomanCinematicOverlay {
  static Future<void> _show(BuildContext context, CinematicConfig config) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (ctx, _, __) => RomanCinematicPlayer(
          config: config,
          onCompleted: () => Navigator.of(ctx).pop(),
        ),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  /// Séquence d'introduction (premier lancement).
  static Future<void> showIntro(BuildContext context) =>
      _show(context, CinematicConfig.forType(CinematicType.intro));

  /// Entrée d'un champion au Colisée.
  static Future<void> showBossEntrance(BuildContext context, {String? bossName, String? video}) =>
      _show(context, CinematicConfig.forType(CinematicType.bossEntrance, extraInfo: bossName, video: video));

  /// Triomphe : fin d'un monde de la Via Appia.
  static Future<void> showTriumph(BuildContext context, {String? subtitle}) =>
      _show(context, CinematicConfig.forType(CinematicType.triumph, extraInfo: subtitle));

  /// Vidéo propre à chaque niveau, par identifiant de classe.
  static const _videosNiveau = {
    '5eme': 'assets/cinematics/niveau_5e.mp4',
    '4eme': 'assets/cinematics/niveau_4e.mp4',
    '3eme': 'assets/cinematics/niveau_3e.mp4',
  };

  /// Entrée dans un niveau (5e, 4e, 3e) : survol de la Rome de cette époque.
  /// Voir `GameRepository.enterLevelOf` pour la règle « une seule fois ».
  static Future<void> showLevel(BuildContext context, SchoolClass niveau) {
    final video = _videosNiveau[niveau.id];
    if (video == null) return Future.value();
    return _show(
      context,
      CinematicConfig(
        assetPath: video,
        title: 'CLASSE DE ${niveau.titre.toUpperCase()}',
        subtitle: niveau.sousTitre,
      ),
    );
  }
}
