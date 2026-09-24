import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../core/themes.dart';

/// Décalage horizontal d'une borne par rapport au centre : le serpentin
/// de la Via Appia (-50, 0, 50, 0…). Partagé par les bornes et la route,
/// pour que la chaussée passe exactement sous chaque borne.
double serpentinOffset(int lessonIndex) {
  switch (lessonIndex % 4) {
    case 0:
      return -50;
    case 2:
      return 50;
    default:
      return 0;
  }
}

/// Un tronçon de la Via Appia, peint derrière une rangée de la carte.
///
/// Chaque rangée ne dessine que sa part de la route : de [topX] (bord haut)
/// jusqu'à la borne en ([nodeX], [nodeY]), puis jusqu'à [bottomX] (bord bas).
/// Les tronçons voisins partagent la même abscisse à leur frontière et y
/// arrivent à la verticale : la route paraît d'un seul tenant, quelle que soit
/// la hauteur de chaque rangée.
///
/// Sans [nodeY], le tronçon est une ligne droite (sous la bannière d'un monde).
class ViaAppiaRoadPainter extends CustomPainter {
  /// Abscisses exprimées en décalage depuis le centre de la rangée.
  final double topX;
  final double nodeX;
  final double bottomX;
  final double? nodeY;

  /// Route déjà parcourue (pleine) ou encore à parcourir (estompée),
  /// pour la moitié haute et la moitié basse du tronçon.
  final bool topTravelled;
  final bool bottomTravelled;

  /// Graine du tirage des pavés : même dessin à chaque affichage.
  final int seed;

  const ViaAppiaRoadPainter({
    required this.topX,
    required this.bottomX,
    required this.seed,
    this.nodeX = 0,
    this.nodeY,
    this.topTravelled = true,
    this.bottomTravelled = true,
  });

  const ViaAppiaRoadPainter.straight({
    required double x,
    required bool travelled,
    required this.seed,
  })  : topX = x,
        bottomX = x,
        nodeX = x,
        nodeY = null,
        topTravelled = travelled,
        bottomTravelled = travelled;

  static const double _shoulderWidth = 62;
  static const double _curbWidth = 48;
  static const double _roadWidth = 40;
  static const double _rowStep = 9;

  /// Chaque tronçon déborde d'un pixel sur ses voisins : sans ce recouvrement,
  /// l'anticrénelage laisse passer le fond en un fin trait clair à chaque raccord.
  static const double _overlap = 1.5;

  static const _basalt = [
    Color(0xFF7E766E),
    Color(0xFF8C837A),
    Color(0xFF736B64),
    Color(0xFF978E84),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final h = size.height;
    final y = nodeY;

    if (y == null) {
      final path = Path()
        ..moveTo(cx + topX, -_overlap)
        ..lineTo(cx + bottomX, h + _overlap);
      _paintRoad(canvas, path, topTravelled, 0);
      return;
    }

    // Tangentes verticales aux deux bords et sous la borne : les raccords
    // entre rangées ne font ni angle ni marche.
    final top = Path()
      ..moveTo(cx + topX, -_overlap)
      ..lineTo(cx + topX, 0)
      ..cubicTo(cx + topX, y * 0.55, cx + nodeX, y * 0.45, cx + nodeX, y);
    final rest = h - y;
    final bottom = Path()
      ..moveTo(cx + nodeX, y)
      ..cubicTo(cx + nodeX, y + rest * 0.55, cx + bottomX, y + rest * 0.45,
          cx + bottomX, h)
      ..lineTo(cx + bottomX, h + _overlap);

    _paintRoad(canvas, top, topTravelled, 0);
    _paintRoad(canvas, bottom, bottomTravelled, 1);
  }

  void _paintRoad(Canvas canvas, Path path, bool travelled, int part) {
    // La route à venir reste visible mais s'efface : on voit où l'on va.
    // On mélange avec le fond plutôt que de jouer sur la transparence, pour
    // que le recouvrement entre tronçons ne dessine pas de trait plus foncé.
    Color tint(Color c) =>
        travelled ? c : Color.lerp(c, RomanColors.palatinCream, 0.6)!;

    Paint stroke(Color c, double width) => Paint()
      ..color = tint(c)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.butt;

    // Bas-côtés en terre battue, bordure de travertin, puis joints sombres.
    // Bas-côtés : terre battue déjà mêlée au crème du fond (opaque, voir tint).
    canvas.drawPath(path, stroke(const Color(0xFFE6D8BD), _shoulderWidth));
    canvas.drawPath(path, stroke(const Color(0xFFD2C5A6), _curbWidth));
    canvas.drawPath(path, stroke(const Color(0xFF5B534C), _roadWidth));

    final stonePaint = Paint()..style = PaintingStyle.fill;
    var row = 0;
    for (final metric in path.computeMetrics()) {
      for (double d = _rowStep / 2; d < metric.length; d += _rowStep, row++) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent == null) continue;
        // Rangées en quinconce, comme un vrai dallage.
        final lanes = row.isEven
            ? const [(-13.0, 6.2), (0.0, 6.4), (13.0, 6.2)]
            : const [(-16.0, 3.4), (-6.5, 6.3), (6.5, 6.3), (16.0, 3.4)];
        for (var lane = 0; lane < lanes.length; lane++) {
          final (lateral, radius) = lanes[lane];
          final r1 = _rand(part, row, lane, 0);
          stonePaint.color = tint(_basalt[(r1 * _basalt.length).floor()]);
          canvas.drawPath(
            _stone(tangent, lateral, radius, part, row, lane),
            stonePaint,
          );
        }
      }
    }
  }

  /// Pavé polygonal irrégulier, orienté selon la route.
  Path _stone(ui.Tangent t, double lateral, double radius, int part, int row,
      int lane) {
    final dir = t.vector;
    final normal = Offset(-dir.dy, dir.dx);
    final centre = t.position + normal * lateral;
    final angle0 = math.atan2(dir.dy, dir.dx);
    final sides = 5 + (_rand(part, row, lane, 1) * 2).floor();
    final path = Path();
    for (var k = 0; k < sides; k++) {
      final jitterA = (_rand(part, row, lane, 10 + k) - 0.5) * 0.7;
      final jitterR = 0.78 + _rand(part, row, lane, 30 + k) * 0.24;
      final a = angle0 + (k / sides) * 2 * math.pi + jitterA;
      final p = centre + Offset(math.cos(a), math.sin(a)) * radius * jitterR;
      if (k == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    return path..close();
  }

  /// Hasard déterministe dans [0, 1[ : le dallage ne change pas d'un affichage à l'autre.
  double _rand(int a, int b, int c, int d) {
    var x = seed * 73856093 ^
        a * 19349663 ^
        b * 83492791 ^
        c * 2654435761 ^
        d * 40503;
    x = (x ^ (x >> 13)) * 1274126177;
    x = x ^ (x >> 16);
    return (x & 0xFFFFF) / 0x100000;
  }

  @override
  bool shouldRepaint(covariant ViaAppiaRoadPainter old) =>
      old.topX != topX ||
      old.nodeX != nodeX ||
      old.bottomX != bottomX ||
      old.nodeY != nodeY ||
      old.topTravelled != topTravelled ||
      old.bottomTravelled != bottomTravelled ||
      old.seed != seed;
}
