import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/services/audio_service.dart';
import 'themes.dart';

/// Intensité de la secousse d'écran.
enum ShakeIntensity {
  light(amplitude: 4.0, durationMs: 220),
  medium(amplitude: 8.5, durationMs: 340),
  heavy(amplitude: 15.0, durationMs: 480);

  final double amplitude;
  final int durationMs;

  const ShakeIntensity({required this.amplitude, required this.durationMs});
}

/// Enveloppe widget injectant un effet de secousse d'écran physique (Screen Shake)
/// avec amortissement sur les axes X et Y, et retour haptique synchronisé.
class RomanScreenShake extends StatefulWidget {
  final Widget child;

  const RomanScreenShake({
    super.key,
    required this.child,
  });

  /// Déclenche la secousse sur le RomanScreenShake le plus proche dans l'arbre de widgets.
  static void shakeOf(BuildContext context, {ShakeIntensity intensity = ShakeIntensity.medium}) {
    context.findAncestorStateOfType<RomanScreenShakeState>()?.shake(intensity: intensity);
  }

  @override
  State<RomanScreenShake> createState() => RomanScreenShakeState();
}

class RomanScreenShakeState extends State<RomanScreenShake>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _currentAmplitude = 6.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Déclenche la secousse d'écran avec l'intensité spécifiée.
  void shake({ShakeIntensity intensity = ShakeIntensity.medium}) {
    _currentAmplitude = intensity.amplitude;
    _controller.duration = Duration(milliseconds: intensity.durationMs);

    switch (intensity) {
      case ShakeIntensity.light:
        HapticFeedback.lightImpact();
        break;
      case ShakeIntensity.medium:
        HapticFeedback.mediumImpact();
        break;
      case ShakeIntensity.heavy:
        HapticFeedback.heavyImpact();
        break;
    }

    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (!_controller.isAnimating) {
          return widget.child;
        }

        final t = _controller.value;
        // Amortissement exponentiel décroissant
        final decay = 1.0 - t;
        // Oscillations haute fréquence sinusoïdales déphasées
        final offsetX = math.sin(t * math.pi * 8.0) * _currentAmplitude * decay;
        final offsetY = math.cos(t * math.pi * 6.0) * (_currentAmplitude * 0.65) * decay;

        return Transform.translate(
          offset: Offset(offsetX, offsetY),
          child: widget.child,
        );
      },
    );
  }
}

/// Compteur numérique animé à défilement fluide avec tintement audio et rebond d'échelle.
class RomanAnimatedCounter extends StatefulWidget {
  final int value;
  final int? initialValue;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final Duration duration;
  final bool playSound;
  final Curve curve;

  const RomanAnimatedCounter({
    super.key,
    required this.value,
    this.initialValue,
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.duration = const Duration(milliseconds: 800),
    this.playSound = true,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<RomanAnimatedCounter> createState() => _RomanAnimatedCounterState();
}

class _RomanAnimatedCounterState extends State<RomanAnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _startValue = 0;
  int _targetValue = 0;
  int _lastTickValue = 0;

  @override
  void initState() {
    super.initState();
    _startValue = widget.initialValue ?? widget.value;
    _targetValue = widget.value;
    _lastTickValue = _startValue;

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);

    if (_startValue != _targetValue) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant RomanAnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      final currentProgressVal = (_startValue + (_targetValue - _startValue) * _animation.value).round();
      _startValue = currentProgressVal;
      _targetValue = widget.value;
      _lastTickValue = _startValue;
      _controller.duration = widget.duration;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final current = (_startValue + (_targetValue - _startValue) * _animation.value).round();

        // Joue un micro-tintement si la valeur a changé
        if (widget.playSound && _controller.isAnimating && current != _lastTickValue) {
          _lastTickValue = current;
          AudioService().playCoinTick();
        }

        // Effet de rebond d'échelle subtil pendant le défilement
        final scaleBounce = _controller.isAnimating
            ? 1.0 + (math.sin(_animation.value * math.pi) * 0.12)
            : 1.0;

        return Transform.scale(
          scale: scaleBounce,
          alignment: Alignment.center,
          child: Text(
            '${widget.prefix}$current${widget.suffix}',
            style: widget.style,
          ),
        );
      },
    );
  }
}

/// Spécialisation du compteur de score pour les Sesterces (HS) impériaux avec icône or.
class RollingSestercesCounter extends StatelessWidget {
  final int value;
  final int? initialValue;
  final TextStyle? style;
  final Duration duration;
  final bool playSound;
  final bool showIcon;

  const RollingSestercesCounter({
    super.key,
    required this.value,
    this.initialValue,
    this.style,
    this.duration = const Duration(milliseconds: 750),
    this.playSound = true,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    const defaultStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.bold,
      color: Color(0xFF7A5901),
      letterSpacing: 0.3,
    );

    return RomanAnimatedCounter(
      value: value,
      initialValue: initialValue,
      prefix: showIcon ? '🪙 ' : '',
      suffix: ' HS',
      style: style ?? defaultStyle,
      duration: duration,
      playSound: playSound,
    );
  }
}

/// Barre de vie & de progression élastique avec dynamique de ressort (Spring Physics)
/// et jauge "fantôme" (Ghost Bar) réactive style jeu d'arcade / RPG.
class RomanElasticProgressBar extends StatefulWidget {
  final double value; // 0.0 à 1.0
  final Color color;
  final Color? ghostColor;
  final Color backgroundColor;
  final double height;
  final BorderRadius? borderRadius;
  final bool showGhost;
  final Duration duration;

  const RomanElasticProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.ghostColor,
    this.backgroundColor = const Color(0x33000000),
    this.height = 10.0,
    this.borderRadius,
    this.showGhost = true,
    this.duration = const Duration(milliseconds: 650),
  });

  @override
  State<RomanElasticProgressBar> createState() => _RomanElasticProgressBarState();
}

class _RomanElasticProgressBarState extends State<RomanElasticProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _ghostController;
  late Animation<double> _mainAnimation;
  late Animation<double> _ghostAnimation;

  double _oldMainValue = 0.0;
  double _targetValue = 0.0;
  double _oldGhostValue = 0.0;

  @override
  void initState() {
    super.initState();
    _targetValue = widget.value.clamp(0.0, 1.0);
    _oldMainValue = _targetValue;
    _oldGhostValue = _targetValue;

    // Contrôleur de la jauge principale avec léger rebond élastique (easeOutBack)
    _mainController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _mainAnimation = CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOutBack,
    );

    // Contrôleur de la jauge fantôme plus lente pour marquer l'impact
    _ghostController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.duration.inMilliseconds * 1.3).round()),
    );
    _ghostAnimation = CurvedAnimation(
      parent: _ghostController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didUpdateWidget(covariant RomanElasticProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      final currentMain = _oldMainValue + (_targetValue - _oldMainValue) * _mainAnimation.value;
      _oldMainValue = currentMain.clamp(0.0, 1.0);
      _oldGhostValue = math.max(_oldGhostValue, _oldMainValue);
      _targetValue = widget.value.clamp(0.0, 1.0);

      _mainController.forward(from: 0.0);

      // Si la vie baisse, la jauge fantôme attend 120ms avant de fondre
      if (_targetValue < _oldMainValue) {
        Future.delayed(const Duration(milliseconds: 120), () {
          if (mounted) {
            _ghostController.forward(from: 0.0);
          }
        });
      } else {
        // Si la vie ou XP monte, la jauge fantôme précède la montée
        _ghostController.forward(from: 0.0);
      }
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _ghostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(widget.height / 2);
    final effectiveGhostColor = widget.ghostColor ??
        (_targetValue < _oldMainValue
            ? Colors.redAccent.withOpacity(0.5)
            : RomanColors.imperialGold.withOpacity(0.4));

    return ClipRRect(
      borderRadius: radius,
      child: Container(
        height: widget.height,
        color: widget.backgroundColor,
        child: Stack(
          children: [
            // Jauge Fantôme (Impact / Gain retardé)
            if (widget.showGhost)
              AnimatedBuilder(
                animation: _ghostAnimation,
                builder: (context, child) {
                  final ghostVal = (_oldGhostValue + (_targetValue - _oldGhostValue) * _ghostAnimation.value)
                      .clamp(0.0, 1.0);
                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: ghostVal,
                    child: Container(color: effectiveGhostColor),
                  );
                },
              ),

            // Jauge Principale Élastique
            AnimatedBuilder(
              animation: _mainAnimation,
              builder: (context, child) {
                final mainVal = (_oldMainValue + (_targetValue - _oldMainValue) * _mainAnimation.value)
                    .clamp(0.0, 1.0);

                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: mainVal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.color,
                      gradient: LinearGradient(
                        colors: [
                          widget.color.withOpacity(0.85),
                          widget.color,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Ligne de reflet brillant en haut de la jauge (effet 3D arcade)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: widget.height * 0.35,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.28),
                      Colors.white.withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
