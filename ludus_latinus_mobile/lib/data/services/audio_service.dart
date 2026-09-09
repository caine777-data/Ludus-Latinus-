import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service audio antique gérant les bruitages immersifs de Rome antique.
/// Fonctionne de manière universelle sur toutes les plateformes (Android, Windows, Web, iOS).
class AudioService extends ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  bool _isMuted = false;
  double _volume = 1.0;

  bool get isMuted => _isMuted;
  double get volume => _volume;

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }

  void setVolume(double vol) {
    _volume = vol.clamp(0.0, 1.0);
    notifyListeners();
  }

  /// Tintement de sesterces (or & argent)
  Future<void> playSesterces() async {
    if (_isMuted) return;
    HapticFeedback.lightImpact();
    SystemSound.play(SystemSoundType.click);
  }

  /// Roulement des osselets et dés dans le cornet (fritillus)
  Future<void> playDiceRoll() async {
    if (_isMuted) return;
    HapticFeedback.mediumImpact();
    // Double tap sonore simulant le rebond des dés
    SystemSound.play(SystemSoundType.click);
    await Future.delayed(const Duration(milliseconds: 70));
    SystemSound.play(SystemSoundType.click);
  }

  /// Fanfare de triomphe impérial (buccina & tuba)
  Future<void> playTriumph() async {
    if (_isMuted) return;
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.click);
    await Future.delayed(const Duration(milliseconds: 140));
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
    await Future.delayed(const Duration(milliseconds: 140));
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.click);
  }

  /// Clameur de la foule au Colisée ou au Circus Maximus
  Future<void> playCrowdCheer() async {
    if (_isMuted) return;
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.click);
  }

  /// Choc métallique de glaive sur le bouclier scutum
  Future<void> playSwordClash() async {
    if (_isMuted) return;
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.click);
  }

  /// Cliquetis mécanique cranté de la roue de César
  Future<void> playWheelClick() async {
    if (_isMuted) return;
    HapticFeedback.selectionClick();
    SystemSound.play(SystemSoundType.click);
  }

  /// Bruissement d'une carte marbre retournée
  Future<void> playCardFlip() async {
    if (_isMuted) return;
    HapticFeedback.lightImpact();
    SystemSound.play(SystemSoundType.click);
  }

  /// Échec ou erreur
  Future<void> playError() async {
    if (_isMuted) return;
    HapticFeedback.vibrate();
  }
}
