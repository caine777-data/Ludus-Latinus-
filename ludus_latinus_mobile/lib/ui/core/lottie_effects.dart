import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'themes.dart';
import '../../data/services/audio_service.dart';

/// Gestionnaire d'effets visuels et animations vectorielles Lottie 60 FPS.
class RomanLottieEffects {
  /// 🪙 Affiche une cascade / pluie de sesterces dorés par-dessus l'écran
  static void showCoinShower(
    BuildContext context, {
    Duration duration = const Duration(milliseconds: 2200),
    VoidCallback? onFinished,
  }) {
    HapticFeedback.mediumImpact();
    AudioService().playVictory();

    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => IgnorePointer(
        child: SizedBox.expand(
          child: Center(
            child: Lottie.asset(
              'assets/animations/coin_rain.json',
              repeat: false,
              fit: BoxFit.cover,
              width: MediaQuery.of(ctx).size.width,
              height: MediaQuery.of(ctx).size.height,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(duration, () {
      if (entry.mounted) {
        entry.remove();
        onFinished?.call();
      }
    });
  }

  /// 🌿 Affiche la couronne de lauriers triomphale lors d'un nouveau rang
  static void showLaurelTriumph(
    BuildContext context, {
    String? title,
    String? subtitle,
    Duration duration = const Duration(milliseconds: 2600),
  }) {
    HapticFeedback.heavyImpact();
    AudioService().playTrophy();

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 240,
                height: 240,
                child: Lottie.asset(
                  'assets/animations/laurel_wreath.json',
                  repeat: false,
                  fit: BoxFit.contain,
                ),
              ),
              if (title != null) ...[
                const SizedBox(height: 8),
                Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Trajan',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: RomanColors.goldLight,
                    shadows: [
                      Shadow(
                        color: Colors.black87,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ],
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// 📦 Affiche le coffre impérial interactif qui s'ouvre pour distribuer une récompense
  static void showChestReward(
    BuildContext context, {
    required int sestercesReward,
    required String questTitle,
    required VoidCallback onClaim,
  }) {
    HapticFeedback.heavyImpact();
    AudioService().playCardFlip();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: RomanColors.palatinCream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: RomanColors.imperialGold, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'DÉFI DU JOUR ACCOMPLI !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Trajan',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: RomanColors.imperialPurple,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  questTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: RomanColors.charcoal),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 180,
                  height: 160,
                  child: Lottie.asset(
                    'assets/animations/chest_open.json',
                    repeat: false,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: RomanColors.goldLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: RomanColors.imperialGold),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🪙', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 8),
                      Text(
                        '+$sestercesReward SESTERCES',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: RomanColors.imperialPurple,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RomanColors.imperialPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      onClaim();
                      showCoinShower(context);
                    },
                    child: const Text(
                      'RÉCOLTER LE TRÉSOR',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 💥 Affiche un éclat d'armes (gladius clash) lors d'une attaque / parade
  static void showSwordClash(
    BuildContext context, {
    Offset? position,
    Duration duration = const Duration(milliseconds: 1400),
  }) {
    HapticFeedback.heavyImpact();
    AudioService().playWrong();

    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => IgnorePointer(
        child: SizedBox.expand(
          child: Center(
            child: SizedBox(
              width: 220,
              height: 220,
              child: Lottie.asset(
                'assets/animations/sword_clash.json',
                repeat: false,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(duration, () {
      if (entry.mounted) {
        entry.remove();
      }
    });
  }

  /// 🏛️ Affiche l'aura d'étoiles scintillantes lors de la bénédiction / restauration d'un monument
  static void showMonumentBlessing(
    BuildContext context, {
    String? monumentName,
    Duration duration = const Duration(milliseconds: 2400),
  }) {
    HapticFeedback.lightImpact();
    AudioService().playTrophy();

    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => IgnorePointer(
        child: SizedBox.expand(
          child: Center(
            child: SizedBox(
              width: 320,
              height: 320,
              child: Lottie.asset(
                'assets/animations/stars_glitter.json',
                repeat: false,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(duration, () {
      if (entry.mounted) {
        entry.remove();
      }
    });
  }
}

/// Widget autonome prêt à intégrer une animation Lottie vectorielle dans un composant
class RomanLottieWidget extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final bool repeat;
  final BoxFit fit;

  const RomanLottieWidget({
    super.key,
    required this.assetName,
    this.width,
    this.height,
    this.repeat = true,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/$assetName',
      width: width,
      height: height,
      repeat: repeat,
      fit: fit,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  }
}
