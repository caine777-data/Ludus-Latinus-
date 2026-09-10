import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/services/audio_service.dart';
import 'themes.dart';

/// Type de cinématique antique à afficher.
enum CinematicType {
  intro,
  bossEntrance,
  triumph,
}

/// Modèle de configuration pour une courte vidéo cinématique.
class CinematicConfig {
  final String assetPath;
  final String title;
  final String subtitle;
  final Duration duration;
  final VoidCallback? onAudioTrigger;

  const CinematicConfig({
    required this.assetPath,
    required this.title,
    required this.subtitle,
    required this.duration,
    this.onAudioTrigger,
  });

  static CinematicConfig forType(CinematicType type, {String? extraInfo}) {
    switch (type) {
      case CinematicType.intro:
        return CinematicConfig(
          assetPath: 'assets/cinematics/intro_eagle_rome.webp',
          title: 'S • P • Q • R',
          subtitle: 'LUDUS LATINUS • L\'Épopée de la Langue Latine',
          duration: const Duration(milliseconds: 3800),
          onAudioTrigger: () {
            AudioService().playTriumph();
          },
        );
      case CinematicType.bossEntrance:
        return CinematicConfig(
          assetPath: 'assets/cinematics/boss_entrance.webp',
          title: '⚔️ COLOSSEUM DUELLUM',
          subtitle: extraInfo != null
              ? 'DÉFI DU CHAMPION : $extraInfo'
              : '« AVE CAESAR, MORITURI TE SALUTANT ! »',
          duration: const Duration(milliseconds: 2500),
          onAudioTrigger: () {
            AudioService().playSwordClash();
            Future.delayed(const Duration(milliseconds: 700), () {
              AudioService().playCrowdCheer();
            });
          },
        );
      case CinematicType.triumph:
        return CinematicConfig(
          assetPath: 'assets/cinematics/triumph_arc.webp',
          title: '🏛️ TRIUMPHUS IMPERIALIS',
          subtitle: extraInfo != null
              ? 'NOUVEAU RANG : $extraInfo'
              : '« SENATVS POPVLVSQVE ROMANVS » • HONOS ET GLORIA',
          duration: const Duration(milliseconds: 3500),
          onAudioTrigger: () {
            AudioService().playTriumph();
            Future.delayed(const Duration(milliseconds: 600), () {
              AudioService().playCrowdCheer();
            });
          },
        );
    }
  }
}

/// Widget plein écran immersif de lecture de courte vidéo cinématique.
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

class _RomanCinematicPlayerState extends State<RomanCinematicPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  Timer? _completeTimer;
  bool _isExiting = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: widget.config.duration,
    );

    // Effet Ken Burns : zoom lent et majestueux
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.forward();
    widget.config.onAudioTrigger?.call();

    // Minuteur automatique de fin de cinématique
    _completeTimer = Timer(widget.config.duration, () {
      _handleExit();
    });
  }

  @override
  void dispose() {
    _completeTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _handleExit() {
    if (_isExiting) return;
    _isExiting = true;
    _completeTimer?.cancel();
    widget.onCompleted?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Vidéo Cinématique Animée avec Effet Ken Burns
          Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  );
                },
                child: Image.asset(
                  widget.config.assetPath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF1E1018),
                    child: Center(
                      child: Text(
                        widget.config.title,
                        style: const TextStyle(
                          color: RomanColors.imperialGold,
                          fontSize: 22,
                          fontFamily: 'serif',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. Bandes Noires Cinématiques Anamorphiques 21:9 (Letterbox)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 38,
            child: Container(color: Colors.black),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 38,
            child: Container(color: Colors.black),
          ),

          // 3. Bouton "Passer >>" (Touch Target >= 48x48)
          if (widget.showSkipButton)
            Positioned(
              top: 48,
              right: 20,
              child: SafeArea(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _handleExit();
                    },
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: RomanColors.imperialGold.withOpacity(0.8),
                          width: 1.2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x66000000),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'PASSER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: RomanColors.imperialGold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // 4. Sous-titre Épique Déroulant en Bas
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.8),
                      const Color(0xFF330E06).withOpacity(0.85),
                      Colors.black.withOpacity(0.8),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: RomanColors.imperialGold.withOpacity(0.7),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.config.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: RomanColors.imperialGold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.config.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.3,
                      ),
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

/// Classe utilitaire pour afficher instantanément une cinématique par-dessus l'écran.
class RomanCinematicOverlay {
  /// Affiche la séquence d'introduction au lancement.
  static Future<void> showIntro(
    BuildContext context, {
    VoidCallback? onFinish,
  }) async {
    final config = CinematicConfig.forType(CinematicType.intro);
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (ctx, _, __) => RomanCinematicPlayer(
          config: config,
          onCompleted: () {
            Navigator.of(ctx).pop();
            onFinish?.call();
          },
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  /// Affiche l'entrée martiale d'un Boss au Colisée.
  static Future<void> showBossEntrance(
    BuildContext context, {
    String? bossName,
    VoidCallback? onStartCombat,
  }) async {
    final config = CinematicConfig.forType(
      CinematicType.bossEntrance,
      extraInfo: bossName,
    );
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (ctx, _, __) => RomanCinematicPlayer(
          config: config,
          onCompleted: () {
            Navigator.of(ctx).pop();
            onStartCombat?.call();
          },
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  /// Affiche la cinématique de Triomphe lors d'une promotion au Cursus Honorum.
  static Future<void> showTriumph(
    BuildContext context, {
    String? rankTitle,
    VoidCallback? onFinish,
  }) async {
    final config = CinematicConfig.forType(
      CinematicType.triumph,
      extraInfo: rankTitle,
    );
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (ctx, _, __) => RomanCinematicPlayer(
          config: config,
          onCompleted: () {
            Navigator.of(ctx).pop();
            onFinish?.call();
          },
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
