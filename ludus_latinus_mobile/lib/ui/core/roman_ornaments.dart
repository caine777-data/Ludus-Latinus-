import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'themes.dart';

/// Frise géométrique continue de méandres gréco-romains (Greek Key / Roman Fretwork)
/// entièrement tracée en vectoriel 60 FPS (zéro asset lourd).
class RomanMeanderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool showRails;

  RomanMeanderPainter({
    this.color = RomanColors.imperialGold,
    this.strokeWidth = 1.6,
    this.showRails = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.miter;

    final railPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..strokeWidth = strokeWidth * 0.75
      ..style = PaintingStyle.stroke;

    final h = size.height;
    final w = size.width;

    // Lignes de guidage / rails supérieur et inférieur
    if (showRails) {
      canvas.drawLine(const Offset(0, 0.5), Offset(w, 0.5), railPaint);
      canvas.drawLine(Offset(0, h - 0.5), Offset(w, h - 0.5), railPaint);
    }

    // Chaque motif élémentaire de méandre
    const tileW = 22.0;
    final count = (w / tileW).ceil();
    final actualTileW = w / count;

    final path = Path();
    final padY = showRails ? 2.5 : 0.0;
    final innerH = h - (padY * 2);

    for (int i = 0; i < count; i++) {
      final x = i * actualTileW;
      final yTop = padY;
      final yBot = padY + innerH;
      final yMid = padY + innerH * 0.5;
      final yMidUp = padY + innerH * 0.28;
      final yMidDown = padY + innerH * 0.72;

      if (i == 0) {
        path.moveTo(x, yBot);
      }

      // Tracé d'une clé romaine orthogonale continue
      path.lineTo(x + actualTileW * 0.58, yBot);
      path.lineTo(x + actualTileW * 0.58, yMidUp);
      path.lineTo(x + actualTileW * 0.28, yMidUp);
      path.lineTo(x + actualTileW * 0.28, yMidDown);
      path.lineTo(x + actualTileW * 0.44, yMidDown);
      path.lineTo(x + actualTileW * 0.44, yMid);
      path.lineTo(x + actualTileW * 0.78, yMid);
      path.lineTo(x + actualTileW * 0.78, yTop);
      path.lineTo(x + actualTileW, yTop);
      path.lineTo(x + actualTileW, yBot);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant RomanMeanderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.showRails != showRails;
  }
}

/// Séparateur horizontal orné d'une frise de méandres antiques.
class RomanMeanderDivider extends StatelessWidget {
  final double height;
  final Color? color;
  final double strokeWidth;
  final EdgeInsetsGeometry margin;
  final bool showRails;

  const RomanMeanderDivider({
    super.key,
    this.height = 14.0,
    this.color,
    this.strokeWidth = 1.5,
    this.margin = const EdgeInsets.symmetric(vertical: 8.0),
    this.showRails = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? RomanColors.imperialGold;

    return Container(
      margin: margin,
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: RomanMeanderPainter(
          color: effectiveColor,
          strokeWidth: strokeWidth,
          showRails: showRails,
        ),
      ),
    );
  }
}

/// Dessinateur des cornières et ferrures en bronze/or sculpté aux 4 coins du parchemin.
class _ParchmentCornersPainter extends CustomPainter {
  final Color color;
  final double cornerSize;

  _ParchmentCornersPainter({
    required this.color,
    required this.cornerSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final s = cornerSize;
    final inset = 4.0;

    void drawCorner(double startX, double startY, double dx, double dy) {
      final p = Path();
      p.moveTo(startX, startY + dy * s);
      p.lineTo(startX, startY);
      p.lineTo(startX + dx * s, startY);
      canvas.drawPath(p, paint);

      // Clou / rivet en bronze romain dans l'angle
      canvas.drawCircle(Offset(startX + dx * 3.5, startY + dy * 3.5), 1.8, dotPaint);
    }

    // Coin Haut Gauche
    drawCorner(inset, inset, 1, 1);
    // Coin Haut Droit
    drawCorner(w - inset, inset, -1, 1);
    // Coin Bas Gauche
    drawCorner(inset, h - inset, 1, -1);
    // Coin Bas Droit
    drawCorner(w - inset, h - inset, -1, -1);
  }

  @override
  bool shouldRepaint(covariant _ParchmentCornersPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.cornerSize != cornerSize;
  }
}

/// Cartouche Parchemin d'Herculanum sculpté avec texture chaude,
/// doubles bordures antiques et cornières d'angle ouvragées en or/bronze.
class RomanParchmentCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? borderColor;
  final Color? cornerColor;
  final double cornerSize;
  final VoidCallback? onTap;

  const RomanParchmentCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.borderColor,
    this.cornerColor,
    this.cornerSize = 16.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? const Color(0xFFD6C5AA);
    final effectiveCornerColor = cornerColor ?? RomanColors.imperialGold;

    final cardContent = Container(
      margin: margin,
      decoration: BoxDecoration(
        // Dégradé chaleureux évoquant le papyrus et le vélin ancien
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFFDF8),
            Color(0xFFFBF5EA),
            Color(0xFFF4EBDA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: effectiveBorderColor, width: 1.3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x163D220D),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Liseré intérieur doré discret (Double cadre antique)
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(3.5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: RomanColors.imperialGold.withOpacity(0.35),
                      width: 0.8,
                    ),
                  ),
                ),
              ),
            ),

            // Ferrures et ornements en bronze/or aux 4 coins
            Positioned.fill(
              child: CustomPaint(
                painter: _ParchmentCornersPainter(
                  color: effectiveCornerColor,
                  cornerSize: cornerSize,
                ),
              ),
            ),

            // Contenu de la carte
            Padding(
              padding: padding,
              child: child,
            ),
          ],
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: cardContent,
      );
    }

    return cardContent;
  }
}

/// Sceau de cire impérial 3D (Sigillum Romanum) avec estampille SPQR en relief
/// et couronne de lauriers, ombrage profond et biseau brillant.
class RomanWaxSeal extends StatelessWidget {
  final double size;
  final String label;
  final Color sealColor;
  final Color stampColor;
  final VoidCallback? onTap;

  const RomanWaxSeal({
    super.key,
    this.size = 54.0,
    this.label = 'SPQR',
    this.sealColor = const Color(0xFF8E1724), // Rouge cire impériale
    this.stampColor = const Color(0xFFFFDF85), // Or estampé
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Dégradé de volume 3D imitant la cire fondue pressée
          gradient: RadialGradient(
            colors: [
              sealColor.withOpacity(0.95),
              sealColor,
              Color.lerp(sealColor, Colors.black, 0.45)!,
            ],
            center: const Alignment(-0.2, -0.3),
            radius: 0.85,
          ),
          border: Border.all(
            color: Color.lerp(sealColor, Colors.white, 0.35)!,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              offset: const Offset(0, 4),
              blurRadius: 7,
            ),
            BoxShadow(
              color: sealColor.withOpacity(0.3),
              offset: const Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Anneau intérieur gravé en creux
            Container(
              width: size * 0.76,
              height: size * 0.76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black.withOpacity(0.3),
                  width: 1.0,
                ),
              ),
            ),

            // Monogramme estampé SPQR & Couronne
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: size * 0.28,
                  color: stampColor.withOpacity(0.9),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: size * 0.22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    fontFamily: 'serif',
                    color: stampColor,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.6),
                        offset: const Offset(0.8, 1.0),
                        blurRadius: 1.5,
                      ),
                    ],
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
