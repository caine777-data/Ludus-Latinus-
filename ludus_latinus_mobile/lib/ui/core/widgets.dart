import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'themes.dart';

/// Bouton tactile impérial romain avec liseré d''or et retour haptique.
class RomanButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final bool isLarge;

  const RomanButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = RomanColors.imperialGold,
    this.textColor = const Color(0xFF1A1409),
    this.icon,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24351608),
            offset: Offset(0, 4),
            blurRadius: 8,
          )
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: EdgeInsets.symmetric(
            horizontal: isLarge ? 24 : 16,
            vertical: isLarge ? 14 : 10,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFFE5C158), width: 1.5),
          ),
        ),
        onPressed: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: isLarge ? 20 : 16, color: textColor),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: isLarge ? 15 : 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte en marbre travertin sculpté inspirée de l''élégance géométrique de Monument Valley.
class RomanCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final Color? backgroundColor;

  const RomanCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? RomanColors.marbleBorder,
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x143D1A10),
            offset: Offset(0, 4),
            blurRadius: 12,
          )
        ],
      ),
      child: child,
    );
  }
}

/// Médaillon circulaire doré ciselé pour afficher les portraits de héros ou mascottes.
class RomanMedallion extends StatelessWidget {
  final String imagePath;
  final double size;
  final String fallbackEmoji;
  final VoidCallback? onTap;

  const RomanMedallion({
    super.key,
    required this.imagePath,
    this.size = 56,
    this.fallbackEmoji = '🏛️',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          HapticFeedback.selectionClick();
          onTap!();
        }
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [Color(0xFFFFF7E2), Color(0xFFE8D49E)],
          ),
          border: Border.all(color: RomanColors.imperialGold, width: 2.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x28000000),
              offset: Offset(0, 3),
              blurRadius: 6,
            )
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text(fallbackEmoji, style: TextStyle(fontSize: size * 0.45)),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Mascotte Lupulus vivante avec bulle de dialogue réactive.
class LupulusDialogue extends StatelessWidget {
  final String emotion; // 'normal', 'joie', 'triomphe', 'reflexion', 'centurion', 'aide'
  final String message;
  final VoidCallback? onTap;

  const LupulusDialogue({
    super.key,
    this.emotion = 'normal',
    required this.message,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageFile = 'assets/images/lupulus/lupulus__180.png';

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (onTap != null) onTap!();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8DFC8), width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              offset: Offset(0, 3),
              blurRadius: 8,
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: RomanColors.palatinCream,
                border: Border.all(color: RomanColors.imperialGold, width: 1.5),
              ),
              child: ClipOval(
                child: Image.asset(
                  imageFile,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Text('🐺', style: TextStyle(fontSize: 28)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lupulus te conseille',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                      color: RomanColors.imperialPurple,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.35,
                      color: RomanColors.charcoal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Cartouche parchemin thématique pour « Le Savais-tu ? » et « À Retenir ».
class ParchmentCallout extends StatelessWidget {
  final String title;
  final String content;
  final bool isTip;

  const ParchmentCallout({
    super.key,
    required this.title,
    required this.content,
    this.isTip = true,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isTip ? const Color(0xFFFFFBF0) : const Color(0xFFF2FBF5);
    final borderColor = isTip ? const Color(0xFFD4AF37) : const Color(0xFF2E6F40);
    final titleColor = isTip ? const Color(0xFF7A4A0A) : const Color(0xFF166534);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(isTip ? "💡" : "📌", style: const TextStyle(fontSize: 15)),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(fontSize: 12.5, height: 1.45, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

/// Ruban coloré de cas de déclinaison (Nominatif, Accusatif, etc.)
class CaseRibbon extends StatelessWidget {
  final String cas;
  final String fonction;
  final Color color;

  const CaseRibbon({
    super.key,
    required this.cas,
    required this.fonction,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            cas,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(width: 4),
          Text(
            '()',
            style: TextStyle(fontSize: 10, color: color.withOpacity(0.85)),
          ),
        ],
      ),
    );
  }
}