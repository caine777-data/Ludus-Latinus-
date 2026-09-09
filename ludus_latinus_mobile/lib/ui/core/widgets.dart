import 'package:flutter/material.dart';
import 'themes.dart';

/// Bouton tactile impérial romain avec liseré d'or et relief.
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 3),
            blurRadius: 4,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFC5A059), width: 1.5),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: isLarge ? 20 : 16, color: textColor),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: isLarge ? 16 : 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte en marbre travertin sculpté pour regrouper le contenu.
class RomanCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;

  const RomanCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor ?? const Color(0xFFD4AF37),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 6,
          )
        ],
      ),
      child: child,
    );
  }
}

/// Cartouche parchemin thématique pour « Le Savais-tu ? » et « À Retenir ».
class ParchmentCallout extends StatelessWidget {
  final String title;
  final String content;
  final bool isTip; // true = "Le Savais-tu ?", false = "À Retenir"

  const ParchmentCallout({
    super.key,
    required this.title,
    required this.content,
    this.isTip = true,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isTip ? const Color(0xFFFFF8E7) : const Color(0xFFF0FDF4);
    final borderColor = isTip ? const Color(0xFFC59B27) : const Color(0xFF2E6F40);
    final titleColor = isTip ? const Color(0xFF8B2500) : const Color(0xFF166534);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(isTip ? "💡" : "📌", style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
