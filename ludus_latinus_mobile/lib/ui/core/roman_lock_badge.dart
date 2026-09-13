import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'themes.dart';

/// Badge et calque de verrouillage antique romain pour les activités soumises au déblocage progressif.
class RomanLockOverlay extends StatelessWidget {
  final String title;
  final String lockReason;
  final double progress; // 0.0 to 1.0
  final VoidCallback? onTap;

  const RomanLockOverlay({
    super.key,
    required this.title,
    required this.lockReason,
    this.progress = 0.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF2C1810),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: RomanColors.imperialGold, width: 1.2),
              ),
              content: Row(
                children: [
                  const Text('🏛️', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontWeight: FontWeight.bold,
                            color: RomanColors.imperialGold,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lockReason,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              duration: const Duration(seconds: 3),
            ),
          );
          if (onTap != null) onTap!();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xE81F1511),
            border: Border.all(color: const Color(0x66A88942), width: 1.2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF382319),
                  border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                  boxShadow: const [
                    BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 2)),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.lock_rounded, color: RomanColors.imperialGold, size: 20),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7E9CE),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                lockReason,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFFC7B198),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  width: 90,
                  height: 4,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFF4A3427),
                    valueColor: const AlwaysStoppedAnimation<Color>(RomanColors.imperialGold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
