import 'dart:math' as math;
import 'package:flutter/material.dart';

enum ParticleType {
  laurelRain,
  marbleSparks,
  shockwave,
}

/// Moteur de particules visuelles impériales inspiré de l'esthétique épurée de Monument Valley.
class RomanParticlesOverlay extends StatefulWidget {
  final ParticleType type;
  final Duration duration;
  final VoidCallback? onFinished;

  const RomanParticlesOverlay({
    super.key,
    this.type = ParticleType.laurelRain,
    this.duration = const Duration(milliseconds: 2400),
    this.onFinished,
  });

  /// Affiche l'overlay de particules par-dessus n'importe quel écran
  static void show(
    BuildContext context, {
    ParticleType type = ParticleType.laurelRain,
    Duration duration = const Duration(milliseconds: 2200),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => IgnorePointer(
        child: RomanParticlesOverlay(
          type: type,
          duration: duration,
          onFinished: () {
            entry.remove();
          },
        ),
      ),
    );
    overlay.insert(entry);
  }

  @override
  State<RomanParticlesOverlay> createState() => _RomanParticlesOverlayState();
}

class _RomanParticlesOverlayState extends State<RomanParticlesOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ParticleItem> _particles = [];
  final math.Random _rng = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // Initialisation selon le type
    final count = widget.type == ParticleType.laurelRain ? 42 : 36;
    for (int i = 0; i < count; i++) {
      _particles.add(_ParticleItem(
        x: _rng.nextDouble(),
        y: widget.type == ParticleType.laurelRain
            ? -0.2 - (_rng.nextDouble() * 0.5)
            : 0.5,
        speedX: widget.type == ParticleType.laurelRain
            ? (_rng.nextDouble() - 0.5) * 0.2
            : (_rng.nextDouble() - 0.5) * 1.8,
        speedY: widget.type == ParticleType.laurelRain
            ? 0.4 + (_rng.nextDouble() * 0.6)
            : (_rng.nextDouble() - 0.5) * 1.8,
        size: widget.type == ParticleType.laurelRain
            ? 14.0 + (_rng.nextDouble() * 12.0)
            : 6.0 + (_rng.nextDouble() * 8.0),
        rotation: _rng.nextDouble() * math.pi * 2,
        rotationSpeed: (_rng.nextDouble() - 0.5) * 6.0,
        color: _getRandomRomanColor(),
      ));
    }

    _controller.forward().then((_) {
      if (widget.onFinished != null) widget.onFinished!();
    });
  }

  Color _getRandomRomanColor() {
    const palette = [
      Color(0xFFD4AF37), // Or Impérial
      Color(0xFFF3E5AB), // Or Clair
      Color(0xFFE5A93C), // Ambre Antique
      Color(0xFF1E5E3A), // Vert Laurier
      Color(0xFF8B2500), // Rouge Pompéien
      Color(0xFFFFF9E6), // Ivoire
    ];
    return palette[_rng.nextInt(palette.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlesPainter(
            particles: _particles,
            progress: _controller.value,
            type: widget.type,
          ),
        );
      },
    );
  }
}

class _ParticleItem {
  double x;
  double y;
  double speedX;
  double speedY;
  double size;
  double rotation;
  double rotationSpeed;
  Color color;

  _ParticleItem({
    required this.x,
    required this.y,
    required this.speedX,
    required this.speedY,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
  });
}

class _ParticlesPainter extends CustomPainter {
  final List<_ParticleItem> particles;
  final double progress;
  final ParticleType type;

  _ParticlesPainter({
    required this.particles,
    required this.progress,
    required this.type,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // 1. Onde de choc centrale en cas de victoire
    if (type == ParticleType.shockwave || type == ParticleType.laurelRain) {
      final waveRadius = progress * size.shortestSide * 0.6;
      final waveOpacity = (1.0 - progress).clamp(0.0, 1.0) * 0.35;
      final wavePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0 * (1.0 - progress)
        ..color = const Color(0xFFD4AF37).withOpacity(waveOpacity);
      canvas.drawCircle(
        Offset(size.width / 2, size.height * 0.45),
        waveRadius,
        wavePaint,
      );
    }

    // 2. Particules individuelles
    for (final p in particles) {
      double curX;
      double curY;
      double opacity;

      if (type == ParticleType.laurelRain) {
        curX = (p.x + math.sin(progress * 4.0 + p.rotation) * 0.08) * size.width;
        curY = (p.y + (p.speedY * progress * 1.5)) * size.height;
        opacity = (1.0 - (progress * 0.85)).clamp(0.0, 1.0);
      } else {
        curX = (p.x + (p.speedX * progress * 0.5)) * size.width;
        curY = (p.y + (p.speedY * progress * 0.5)) * size.height;
        opacity = (1.0 - progress).clamp(0.0, 1.0);
      }

      if (opacity <= 0.01) continue;

      paint.color = p.color.withOpacity(opacity);

      canvas.save();
      canvas.translate(curX, curY);
      canvas.rotate(p.rotation + (p.rotationSpeed * progress));

      if (type == ParticleType.laurelRain) {
        // Dessine une feuille de laurier dorée stylisée
        _drawLaurelLeaf(canvas, paint, p.size);
      } else {
        // Étincelle ou facette de marbre
        _drawSpark(canvas, paint, p.size);
      }

      canvas.restore();
    }
  }

  void _drawLaurelLeaf(Canvas canvas, Paint paint, double leafSize) {
    final path = Path();
    final half = leafSize / 2;
    path.moveTo(0, -half);
    path.quadraticBezierTo(half * 0.65, 0, 0, half);
    path.quadraticBezierTo(-half * 0.65, 0, 0, -half);
    path.close();
    canvas.drawPath(path, paint);

    // Nervure centrale délicate
    final veinPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withOpacity(0.4);
    canvas.drawLine(Offset(0, -half * 0.8), Offset(0, half * 0.8), veinPaint);
  }

  void _drawSpark(Canvas canvas, Paint paint, double sparkSize) {
    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: sparkSize,
      height: sparkSize,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(2)), paint);
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) => true;
}
