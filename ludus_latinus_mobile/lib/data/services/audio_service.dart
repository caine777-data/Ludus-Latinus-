import 'dart:io';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// Signatures C pour winmm.dll sous Windows
typedef _PlaySoundC = Int32 Function(Pointer<Utf16> pszSound, IntPtr hmod, Uint32 fdwSound);
typedef _PlaySoundDart = int Function(Pointer<Utf16> pszSound, int hmod, int fdwSound);

typedef _WaveOutSetVolumeC = Uint32 Function(IntPtr uDeviceID, Uint32 dwVolume);
typedef _WaveOutSetVolumeDart = int Function(int uDeviceID, int dwVolume);

/// Moteur audio Windows natif via WinMM (PlaySoundW & waveOutSetVolume)
class _WindowsAudioEngine {
  static DynamicLibrary? _winmm;
  static _PlaySoundDart? _playSound;
  static _WaveOutSetVolumeDart? _waveOutSetVolume;
  static final Map<String, Pointer<Utf16>> _cachedPointers = {};
  static bool _initialized = false;

  static const int SND_ASYNC = 0x0001;
  static const int SND_NODEFAULT = 0x0002;
  static const int SND_PURGE = 0x0040;
  static const int SND_FILENAME = 0x00020000;

  static void init() {
    if (_initialized) return;
    _initialized = true;
    try {
      _winmm = DynamicLibrary.open('winmm.dll');
      _playSound = _winmm!.lookupFunction<_PlaySoundC, _PlaySoundDart>('PlaySoundW');
      _waveOutSetVolume = _winmm!.lookupFunction<_WaveOutSetVolumeC, _WaveOutSetVolumeDart>('waveOutSetVolume');
    } catch (e) {
      debugPrint('[AudioService] Erreur initialisation winmm.dll: $e');
    }
  }

  static void playFile(String filePath) {
    init();
    if (_playSound == null) return;
    try {
      var ptr = _cachedPointers[filePath];
      if (ptr == null) {
        ptr = filePath.toNativeUtf16();
        _cachedPointers[filePath] = ptr;
      }
      _playSound!(ptr, 0, SND_ASYNC | SND_FILENAME | SND_NODEFAULT);
    } catch (e) {
      debugPrint('[AudioService] Erreur PlaySoundW: $e');
    }
  }

  static void setVolume(double volume) {
    init();
    if (_waveOutSetVolume == null) return;
    try {
      final vol16 = (volume.clamp(0.0, 1.0) * 0xFFFF).round() & 0xFFFF;
      final dwVolume = vol16 | (vol16 << 16);
      _waveOutSetVolume!(0, dwVolume);
    } catch (e) {
      debugPrint('[AudioService] Erreur waveOutSetVolume: $e');
    }
  }

  static void stopAll() {
    init();
    if (_playSound == null) return;
    try {
      _playSound!(nullptr, 0, SND_PURGE);
    } catch (e) {
      debugPrint('[AudioService] Erreur stopAll Windows: $e');
    }
  }
}

/// Service audio antique gérant les bruitages immersifs de Rome antique.
/// Fonctionne avec une fidélité acoustique réelle sur Android (SoundPool)
/// et Windows (winmm.dll), avec repli haptique et sonore universel.
class AudioService extends ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal() {
    _initEngine();
  }

  static const MethodChannel _androidChannel = MethodChannel('com.luduslatinus/audio');

  bool _isMuted = false;
  double _volume = 0.85;
  bool _hapticsEnabled = true;

  bool get isMuted => _isMuted;
  double get volume => _volume;
  bool get hapticsEnabled => _hapticsEnabled;

  final Map<String, String> _resolvedWindowsPaths = {};

  void _initEngine() {
    if (!kIsWeb && Platform.isWindows) {
      _WindowsAudioEngine.init();
      _WindowsAudioEngine.setVolume(_isMuted ? 0.0 : _volume);
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (!kIsWeb && Platform.isWindows) {
      _WindowsAudioEngine.setVolume(_isMuted ? 0.0 : _volume);
    }
    notifyListeners();
  }

  void setVolume(double vol) {
    _volume = vol.clamp(0.0, 1.0);
    if (!kIsWeb && Platform.isWindows) {
      _WindowsAudioEngine.setVolume(_isMuted ? 0.0 : _volume);
    }
    notifyListeners();
  }

  void setHapticsEnabled(bool enabled) {
    _hapticsEnabled = enabled;
    notifyListeners();
  }

  /// Résout le chemin physique d'un asset audio sur Windows
  Future<String?> _getWindowsAudioPath(String assetPath) async {
    if (_resolvedWindowsPaths.containsKey(assetPath)) {
      return _resolvedWindowsPaths[assetPath];
    }

    try {
      // 1. Emplacement standard de l'application Windows compilée
      final exeDir = File(Platform.resolvedExecutable).parent.path;
      final segments = ['data', 'flutter_assets', ...assetPath.split('/')];
      final standardPath = [exeDir, ...segments].join(Platform.pathSeparator);
      if (File(standardPath).existsSync()) {
        _resolvedWindowsPaths[assetPath] = standardPath;
        return standardPath;
      }

      // 2. Répertoire de travail actuel (mode debug ou test)
      final localSegments = assetPath.split('/');
      final localPath = [Directory.current.path, ...localSegments].join(Platform.pathSeparator);
      if (File(localPath).existsSync()) {
        _resolvedWindowsPaths[assetPath] = localPath;
        return localPath;
      }

      // 3. Fallback : extraction vers le dossier temporaire système
      final tempDir = Directory.systemTemp;
      final audioDir = Directory('${tempDir.path}${Platform.pathSeparator}ludus_audio');
      if (!audioDir.existsSync()) {
        audioDir.createSync(recursive: true);
      }
      final fileName = assetPath.split('/').last;
      final tempFile = File('${audioDir.path}${Platform.pathSeparator}$fileName');
      if (!tempFile.existsSync()) {
        final byteData = await rootBundle.load(assetPath);
        await tempFile.writeAsBytes(
          byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
        );
      }
      _resolvedWindowsPaths[assetPath] = tempFile.path;
      return tempFile.path;
    } catch (e) {
      debugPrint('[AudioService] Impossible de résoudre $assetPath sur Windows: $e');
      return null;
    }
  }

  /// Joue un asset sonore avec prise en charge cross-plateforme
  Future<void> playAsset(String assetPath, {double volumeMultiplier = 1.0}) async {
    if (_isMuted) return;

    final targetVolume = (_volume * volumeMultiplier).clamp(0.0, 1.0);

    // 1. Windows Desktop (WinMM PlaySoundW)
    if (!kIsWeb && Platform.isWindows) {
      final path = await _getWindowsAudioPath(assetPath);
      if (path != null) {
        _WindowsAudioEngine.playFile(path);
        return;
      }
    }

    // 2. Android Mobile (SoundPool via MethodChannel)
    if (!kIsWeb && Platform.isAndroid) {
      try {
        await _androidChannel.invokeMethod('play', {
          'asset': assetPath,
          'volume': targetVolume,
        });
        return;
      } catch (e) {
        debugPrint('[AudioService] Erreur MethodChannel Android: $e');
      }
    }

    // 3. Repli système standard
    SystemSound.play(SystemSoundType.click);
  }

  /// Tintement de sesterces (or & argent)
  Future<void> playSesterces() async {
    if (_isMuted) return;
    if (_hapticsEnabled) HapticFeedback.lightImpact();
    await playAsset('assets/audio/sesterces_clink.wav');
  }

  /// Micro-tintement rapide pour le défilement fluide des pièces
  Future<void> playCoinTick() async {
    if (_isMuted) return;
    if (_hapticsEnabled) HapticFeedback.selectionClick();
    await playAsset('assets/audio/sesterces_clink.wav', volumeMultiplier: 0.6);
  }

  /// Roulement des osselets et dés dans le cornet (fritillus)
  Future<void> playDiceRoll() async {
    if (_isMuted) return;
    if (_hapticsEnabled) HapticFeedback.mediumImpact();
    await playAsset('assets/audio/dice_roll.wav');
  }

  /// Fanfare de triomphe impérial (buccina & tuba)
  Future<void> playTriumph() async {
    if (_isMuted) return;
    if (_hapticsEnabled) HapticFeedback.heavyImpact();
    await playAsset('assets/audio/triumph_fanfare.wav');
  }

  /// Clameur de la foule au Colisée ou au Circus Maximus
  Future<void> playCrowdCheer() async {
    if (_isMuted) return;
    if (_hapticsEnabled) HapticFeedback.heavyImpact();
    await playAsset('assets/audio/crowd_cheer.wav');
  }

  /// Choc métallique de glaive sur le bouclier scutum
  Future<void> playSwordClash() async {
    if (_isMuted) return;
    if (_hapticsEnabled) HapticFeedback.heavyImpact();
    await playAsset('assets/audio/sword_clash.wav');
  }

  /// Cliquetis mécanique cranté de la roue de César
  Future<void> playWheelClick() async {
    if (_isMuted) return;
    if (_hapticsEnabled) HapticFeedback.selectionClick();
    await playAsset('assets/audio/wheel_click.wav');
  }

  /// Bruissement d'une carte marbre ou parchemin retourné
  Future<void> playCardFlip() async {
    if (_isMuted) return;
    if (_hapticsEnabled) HapticFeedback.lightImpact();
    await playAsset('assets/audio/card_flip.wav');
  }

  /// Échec ou erreur
  Future<void> playError() async {
    if (_isMuted) return;
    if (_hapticsEnabled) HapticFeedback.vibrate();
    SystemSound.play(SystemSoundType.alert);
  }

  /// Arrêt de tous les flux audio
  Future<void> stopAll() async {
    if (!kIsWeb && Platform.isWindows) {
      _WindowsAudioEngine.stopAll();
    } else if (!kIsWeb && Platform.isAndroid) {
      try {
        await _androidChannel.invokeMethod('stopAll');
      } catch (_) {}
    }
  }
}

