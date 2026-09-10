import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'themes.dart';

/// Tracé vectoriel de la coupole à caissons du Panthéon et de son Oculus céleste
class RomanOculusPainter extends CustomPainter {
  final double animationValue; // 0.0 à 1.0 pour l'oscillation de la lumière
  final Color beamColor;

  RomanOculusPainter({
    required this.animationValue,
    this.beamColor = const Color(0xFFFFEAA7),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.22);
    final maxRadius = math.max(size.width, size.height) * 0.9;

    // 1. Fond de voûte en pierre de travertin avec dégradé d'ombre
    final domePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -0.56),
        radius: 1.1,
        colors: const [
          Color(0xFFE8DCCB),
          Color(0xFFC7B69E),
          Color(0xFF9E8B72),
          Color(0xFF5A4836),
        ],
        stops: const [0.0, 0.35, 0.70, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), domePaint);

    // 2. Caissons concentriques en perspective (Lacunaria)
    final ringCount = 5;
    for (int r = 1; r <= ringCount; r++) {
      final ringRadius = 40.0 + (r * (maxRadius - 40.0) / ringCount) * 0.55;
      final strokePaint = Paint()
        ..color = const Color(0x333D220D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(center, ringRadius, strokePaint);

      // Nervures radiales des caissons
      final segments = 16 + (r * 4);
      for (int i = 0; i < segments; i++) {
        final angle = (i * 2 * math.pi) / segments;
        final innerR = ringRadius - 14.0;
        final p1 = Offset(center.dx + math.cos(angle) * innerR, center.dy + math.sin(angle) * innerR);
        final p2 = Offset(center.dx + math.cos(angle) * ringRadius, center.dy + math.sin(angle) * ringRadius);
        canvas.drawLine(p1, p2, strokePaint..strokeWidth = 1.0);
      }
    }

    // 3. Faisceaux volumétriques de lumière divine (God Rays / Lux Divina)
    final beamOpacity = 0.18 + (math.sin(animationValue * 2 * math.pi) * 0.07);
    final rayCount = 7;
    for (int i = 0; i < rayCount; i++) {
      final rayAngle = (i - (rayCount - 1) / 2) * 0.18;
      final raySpread = 0.14 + (i % 2 == 0 ? 0.05 : 0.0);

      final path = Path()
        ..moveTo(center.dx + math.sin(rayAngle) * 22, center.dy + math.cos(rayAngle) * 22)
        ..lineTo(
          center.dx + math.sin(rayAngle - raySpread) * (size.height * 1.1),
          center.dy + math.cos(rayAngle - raySpread) * (size.height * 1.1),
        )
        ..lineTo(
          center.dx + math.sin(rayAngle + raySpread) * (size.height * 1.1),
          center.dy + math.cos(rayAngle + raySpread) * (size.height * 1.1),
        )
        ..close();

      final rayPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            beamColor.withOpacity(beamOpacity * 1.2),
            beamColor.withOpacity(beamOpacity * 0.6),
            Colors.transparent,
          ],
          stops: const [0.0, 0.45, 1.0],
        ).createShader(Rect.fromLTWH(0, center.dy, size.width, size.height));

      canvas.drawPath(path, rayPaint);
    }

    // 4. Bordure en bronze de l'Oculus central
    final rimPaint = Paint()
      ..color = RomanColors.goldDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5;
    canvas.drawCircle(center, 32.0, rimPaint);

    final innerRimPaint = Paint()
      ..color = RomanColors.imperialGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, 28.0, innerRimPaint);

    // 5. Cœur de l'Oculus ouvrant sur le ciel bleu de Rome
    final skyPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFFFFFFFF), // Soleil au zénith
          Color(0xFFBCE0FD), // Azur doux
          Color(0xFF4A90E2), // Ciel romain profond
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: 28.0));
    canvas.drawCircle(center, 28.0, skyPaint);

    // Halo d'éblouissement doux autour de l'Oculus
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          beamColor.withOpacity(beamOpacity * 1.5),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 70.0));
    canvas.drawCircle(center, 70.0, glowPaint);
  }

  @override
  bool shouldRepaint(covariant RomanOculusPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Arrière-plan animé de l'Oculus du Panthéon
class RomanOculusBackdrop extends StatefulWidget {
  final Widget child;

  const RomanOculusBackdrop({super.key, required this.child});

  @override
  State<RomanOculusBackdrop> createState() => _RomanOculusBackdropState();
}

class _RomanOculusBackdropState extends State<RomanOculusBackdrop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return CustomPaint(
                painter: RomanOculusPainter(
                  animationValue: _controller.value,
                ),
              );
            },
          ),
        ),
        widget.child,
      ],
    );
  }
}

/// Flambeau romain animé avec applique murale en fer forgé et halo de lueur
class RomanTorchWidget extends StatelessWidget {
  final double height;
  final bool isFlipped;

  const RomanTorchWidget({
    super.key,
    this.height = 80,
    this.isFlipped = false,
  });

  @override
  Widget build(BuildContext context) {
    final torch = Stack(
      alignment: Alignment.topCenter,
      children: [
        // Halo lumineux doux d'arrière-plan
        Positioned(
          top: 0,
          child: Container(
            width: height * 1.1,
            height: height * 1.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFFB300).withOpacity(0.35),
                  const Color(0xFFFF6F00).withOpacity(0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Flamme animée WebP
        SizedBox(
          height: height,
          child: Image.asset(
            'assets/images/animated/flambeau_flamme.webp',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.local_fire_department_rounded,
              color: Color(0xFFFF7043),
              size: 32,
            ),
          ),
        ),
      ],
    );

    if (isFlipped) {
      return Transform.scale(scaleX: -1, child: torch);
    }
    return torch;
  }
}

/// Paire de flambeaux muraux encadrant une scène ou un en-tête (Taverne, Colisée)
class RomanTorchPairHeader extends StatelessWidget {
  final Widget child;
  final double torchHeight;

  const RomanTorchPairHeader({
    super.key,
    required this.child,
    this.torchHeight = 65,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          left: 4,
          top: -8,
          child: RomanTorchWidget(height: torchHeight),
        ),
        Positioned(
          right: 4,
          top: -8,
          child: RomanTorchWidget(height: torchHeight, isFlipped: true),
        ),
      ],
    );
  }
}

/// Vélarium impérial du Circus Maximus avec les 4 bannières flottantes des factions
class CircusVelariumHeader extends StatelessWidget {
  final int? selectedIndex;
  final ValueChanged<int>? onSelectFaction;

  const CircusVelariumHeader({
    super.key,
    this.selectedIndex,
    this.onSelectFaction,
  });

  @override
  Widget build(BuildContext context) {
    final factions = [
      {'nom': 'VENETI', 'color': const Color(0xFF1E5B94), 'icon': '💙', 'label': 'Bleus'},
      {'nom': 'RUSSATI', 'color': const Color(0xFFB3261E), 'icon': '❤️', 'label': 'Rouges'},
      {'nom': 'PRASINI', 'color': const Color(0xFF2E6F40), 'icon': '💚', 'label': 'Verts'},
      {'nom': 'ALBATI', 'color': const Color(0xFF555555), 'icon': '🤍', 'label': 'Blancs'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF231713),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: RomanColors.imperialGold, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🏛️', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              Text(
                'VÉLARIUM DU CIRCUS MAXIMUS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: RomanColors.imperialGold,
                ),
              ),
              const SizedBox(width: 8),
              const Text('🏛️', style: TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: factions.asMap().entries.map((entry) {
              final idx = entry.key;
              final f = entry.value;
              final color = f['color'] as Color;
              final isSelected = (selectedIndex == idx);

              final bannerWidget = Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.9),
                      color.withOpacity(0.65),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                    bottom: Radius.circular(10),
                  ),
                  border: Border.all(
                    color: isSelected ? Colors.amberAccent : RomanColors.imperialGold,
                    width: isSelected ? 2.0 : 0.8,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.6),
                            blurRadius: 8,
                            spreadRadius: 1,
                          )
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Text(f['icon'] as String, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(
                      f['nom'] as String,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 0.6,
                        shadows: isSelected
                            ? const [Shadow(color: Colors.black, blurRadius: 4)]
                            : null,
                      ),
                    ),
                    Text(
                      f['label'] as String,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(height: 2),
                      const Text('👑', style: TextStyle(fontSize: 8)),
                    ],
                  ],
                ),
              );

              return Expanded(
                child: onSelectFaction != null
                    ? InkWell(
                        onTap: () => onSelectFaction!(idx),
                        borderRadius: BorderRadius.circular(10),
                        child: bannerWidget,
                      )
                    : bannerWidget,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Peintre de l'Arène du Colosseum : Arcades antiques, sable de l'arène et crépuscule romain
class ColosseumArenaPainter extends CustomPainter {
  final double animationValue;

  ColosseumArenaPainter({this.animationValue = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Ciel crépusculaire de Rome derrière les arcades
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF1E0E24), // Crépuscule pourpre profond
          Color(0xFF381622), // Ocre pourpre
          Color(0xFF5A221E), // Brume de sang et de feu
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.7));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.7), skyPaint);

    // 2. Silhouette des Arcades monumentales du Colisée (Amphitheatrum Flavium)
    final stonePaint = Paint()
      ..color = const Color(0x380A0404)
      ..style = PaintingStyle.fill;

    final archWidth = size.width / 5.5;
    for (int i = -1; i < 7; i++) {
      final x = i * archWidth;
      final archPath = Path()
        ..moveTo(x + 4, size.height * 0.45)
        ..lineTo(x + 4, size.height * 0.18)
        ..quadraticBezierTo(
          x + archWidth * 0.5,
          size.height * 0.08,
          x + archWidth - 4,
          size.height * 0.18,
        )
        ..lineTo(x + archWidth - 4, size.height * 0.45)
        ..close();
      canvas.drawPath(archPath, stonePaint);
    }

    // 3. Sable doré de l'arène (Harena) avec texture dégradée
    final sandPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF422115), // Limite ombre et sang
          Color(0xFF2E170E), // Sable compacté
          Color(0xFF1B0B07), // Sol de l'amphithéâtre
        ],
        stops: [0.0, 0.4, 1.0],
      ).createShader(Rect.fromLTWH(0, size.height * 0.4, size.width, size.height * 0.6));

    final sandPath = Path()
      ..moveTo(0, size.height * 0.42)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.38, size.width, size.height * 0.42)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(sandPath, sandPaint);

    // 4. Ligne dorée subtile de séparation d'arène
    final rimPaint = Paint()
      ..color = RomanColors.imperialGold.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(0, size.height * 0.42),
      Offset(size.width, size.height * 0.42),
      rimPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ColosseumArenaPainter oldDelegate) => false;
}

/// Arrière-plan thématique pour l'arène de combat du Colisée
class ColosseumArenaBackdrop extends StatelessWidget {
  final Widget child;

  const ColosseumArenaBackdrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: ColosseumArenaPainter(),
          ),
        ),
        child,
      ],
    );
  }
}
