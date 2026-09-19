import 'dart:convert';
import 'dart:io';
import 'dart:ffi';
import 'package:audioplayers/audioplayers.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

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

  static void cleanup() {
    stopAll();
    for (final ptr in _cachedPointers.values) {
      try {
        calloc.free(ptr);
      } catch (_) {}
    }
    _cachedPointers.clear();
  }
}

/// Musiques d'ambiance disponibles.
enum MusicTrack {
  accueil('assets/audio/musique_accueil.ogg'),
  lecon('assets/audio/musique_lecon.ogg'),
  arene('assets/audio/musique_arene.ogg');

  final String asset;
  const MusicTrack(this.asset);
}

/// Service audio antique gérant les bruitages immersifs de Rome antique.
/// Fonctionne avec une fidélité acoustique réelle sur Android (SoundPool)
/// et Windows (winmm.dll), avec repli haptique et sonore universel.
class AudioService extends ChangeNotifier with WidgetsBindingObserver {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal() {
    _initEngine();
  }

  static const MethodChannel _androidChannel = MethodChannel('com.luduslatinus/audio');
  static const String _settingsFile = 'reglages_audio.json';

  bool _isMuted = false;
  double _volume = 0.85;
  bool _hapticsEnabled = true;
  bool _musicEnabled = true;
  double _musicVolume = 0.5;

  bool get isMuted => _isMuted;
  double get volume => _volume;
  bool get hapticsEnabled => _hapticsEnabled;
  bool get musicEnabled => _musicEnabled;
  double get musicVolume => _musicVolume;

  final Map<String, String> _resolvedWindowsPaths = {};

  void _initEngine() {
    if (!kIsWeb && Platform.isWindows) {
      _WindowsAudioEngine.init();
      _WindowsAudioEngine.setVolume(_isMuted ? 0.0 : _volume);
    }
  }

  // --- Réglages mémorisés d'une session à l'autre ---

  /// À appeler une fois au démarrage : relit les réglages et suit l'arrière-plan de l'appli.
  Future<void> init() async {
    WidgetsBinding.instance.addObserver(this);
    try {
      final file = File('${(await getApplicationDocumentsDirectory()).path}/$_settingsFile');
      if (await file.exists()) {
        final m = json.decode(await file.readAsString()) as Map<String, dynamic>;
        _isMuted = m['muet'] as bool? ?? false;
        _volume = (m['volume'] as num?)?.toDouble() ?? _volume;
        _hapticsEnabled = m['vibrations'] as bool? ?? true;
        _musicEnabled = m['musique'] as bool? ?? true;
        _musicVolume = (m['volume_musique'] as num?)?.toDouble() ?? _musicVolume;
      }
    } catch (e) {
      debugPrint('[AudioService] Réglages audio par défaut ($e)');
    }
    if (!kIsWeb && Platform.isWindows) {
      _WindowsAudioEngine.setVolume(_isMuted ? 0.0 : _volume);
    }
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    try {
      final file = File('${(await getApplicationDocumentsDirectory()).path}/$_settingsFile');
      await file.writeAsString(json.encode({
        'muet': _isMuted,
        'volume': _volume,
        'vibrations': _hapticsEnabled,
        'musique': _musicEnabled,
        'volume_musique': _musicVolume,
      }));
    } catch (e) {
      debugPrint('[AudioService] Sauvegarde des réglages impossible ($e)');
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (!kIsWeb && Platform.isWindows) {
      _WindowsAudioEngine.setVolume(_isMuted ? 0.0 : _volume);
    }
    _applyMusic();
    _saveSettings();
    notifyListeners();
  }

  void setVolume(double vol) {
    _volume = vol.clamp(0.0, 1.0);
    if (!kIsWeb && Platform.isWindows) {
      _WindowsAudioEngine.setVolume(_isMuted ? 0.0 : _volume);
    }
    _saveSettings();
    notifyListeners();
  }

  void setHapticsEnabled(bool enabled) {
    _hapticsEnabled = enabled;
    _saveSettings();
    notifyListeners();
  }

  // --- Musique d'ambiance ---
  //
  // Chaque écran « entre » dans sa musique et en « sort » à sa fermeture :
  // une pile permet de retrouver la musique de l'écran précédent. Une entrée
  // nulle impose le silence (cinématiques, qui ont leur propre bande-son).

  final AudioPlayer _musicPlayer = AudioPlayer(playerId: 'musique');
  final List<MusicTrack?> _musicStack = [];
  MusicTrack? _currentTrack;
  bool _appInBackground = false;
  bool _musicContextSet = false;

  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    _applyMusic();
    _saveSettings();
    notifyListeners();
  }

  void setMusicVolume(double vol) {
    _musicVolume = vol.clamp(0.0, 1.0);
    _musicPlayer.setVolume(_musicVolume * _volume);
    _saveSettings();
    notifyListeners();
  }

  /// Un écran demande sa musique (null = silence). À appeler dans initState.
  void enterMusic(MusicTrack? track) {
    _musicStack.add(track);
    _applyMusic();
  }

  /// L'écran se ferme : la musique précédente reprend. À appeler dans dispose.
  void leaveMusic(MusicTrack? track) {
    final i = _musicStack.lastIndexOf(track);
    if (i >= 0) _musicStack.removeAt(i);
    _applyMusic();
  }

  // Les demandes sont traitées l'une après l'autre : sinon une pause peut
  // arriver avant la fin d'un démarrage et la musique reste bloquée.
  Future<void> _musicQueue = Future.value();

  Future<void> _applyMusic() {
    _musicQueue = _musicQueue.then((_) => _applyMusicNow());
    return _musicQueue;
  }

  Future<void> _applyMusicNow() async {
    final wanted = _musicStack.isEmpty ? null : _musicStack.last;
    final audible = wanted != null && _musicEnabled && !_isMuted && !_appInBackground;
    try {
      if (!audible) {
        await _musicPlayer.pause();
        return;
      }
      if (!_musicContextSet) {
        // L'appli gère elle-même quand la musique se tait (vidéos, arrière-plan) :
        // sans cela, la vidéo lui « vole » le focus audio et elle ne reprend plus.
        await _musicPlayer.setAudioContext(AudioContext(
          android: const AudioContextAndroid(
            isSpeakerphoneOn: false,
            audioMode: AndroidAudioMode.normal,
            stayAwake: false,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.none,
          ),
          iOS: AudioContextIOS(category: AVAudioSessionCategory.ambient),
        ));
        await _musicPlayer.setReleaseMode(ReleaseMode.loop);
        _musicContextSet = true;
      }
      await _musicPlayer.setVolume(_musicVolume * _volume);
      if (wanted != _currentTrack || _musicPlayer.state == PlayerState.stopped || _musicPlayer.state == PlayerState.completed) {
        _currentTrack = wanted;
        await _musicPlayer.play(AssetSource(wanted.asset.replaceFirst('assets/', '')));
      } else if (_musicPlayer.state != PlayerState.playing) {
        await _musicPlayer.resume();
      }
    } catch (e) {
      debugPrint('[AudioService] Musique indisponible ($e)');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pas de musique quand l'appli est en arrière-plan ou l'écran éteint.
    _appInBackground = state != AppLifecycleState.resumed;
    _applyMusic();
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

  /// Erreur : son boisé discret (plus le bip d'alerte du téléphone).
  Future<void> playError() async {
    if (_isMuted) return;
    if (_hapticsEnabled) HapticFeedback.lightImpact();
    await playAsset('assets/audio/erreur.wav');
  }

  /// Bonne réponse dans une leçon.
  Future<void> playCorrect() async {
    if (_isMuted) return;
    if (_hapticsEnabled) HapticFeedback.mediumImpact();
    await playAsset('assets/audio/bonne_reponse.wav');
  }

  /// Indice demandé.
  Future<void> playHint() async {
    if (_isMuted) return;
    await playAsset('assets/audio/indice.wav', volumeMultiplier: 0.8);
  }

  /// Leçon validée pour la première fois.
  Future<void> playLessonDone() async {
    if (_isMuted) return;
    await playAsset('assets/audio/lecon_validee.wav');
  }

  /// Étoile obtenue.
  Future<void> playStar() async {
    if (_isMuted) return;
    await playAsset('assets/audio/etoile.wav', volumeMultiplier: 0.8);
  }

  /// Toucher d'un onglet ou d'un bouton de navigation.
  Future<void> playButton() async {
    if (_isMuted) return;
    await playAsset('assets/audio/bouton.wav', volumeMultiplier: 0.5);
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

  @override
  void dispose() {
    if (!kIsWeb && Platform.isWindows) {
      _WindowsAudioEngine.cleanup();
    }
    super.dispose();
  }
}

