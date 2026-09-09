import 'dart:convert';
import 'dart:io';
import '../models/profile.dart';

/// Service de persistance locale robuste pour la progression et le profil citoyen.
/// Sauvegarde automatique en JSON local avec rechargement au démarrage.
class StorageService {
  UserProfile _currentProfile = UserProfile();
  static const String _saveFileName = 'ludus_latinus_save.json';

  UserProfile get profile => _currentProfile;

  Future<void> init() async {
    // 1. Initialise avec les valeurs par défaut de Marcus
    _currentProfile = UserProfile(
      id: 'defaut',
      nomHeros: 'Marcus',
      genre: 'garcon',
      sesterces: 120,
      streakDays: 3,
      completedLessons: ['m1-01', 'm1-02'],
      restoredMonuments: ['lacus_iuturnae'],
    );

    // 2. Tente de restaurer la sauvegarde locale sur disque si elle existe
    try {
      final file = File(_getSaveFilePath());
      if (await file.exists()) {
        final content = await file.readAsString();
        final map = json.decode(content) as Map<String, dynamic>;
        _currentProfile = UserProfile.fromJson(map);
      }
    } catch (_) {
      // Si la lecture disque échoue (ex: environnement sans permissions), garde le profil par défaut
    }
  }

  String _getSaveFilePath() {
    try {
      // Emplacement utilisateur ou répertoire courant
      final userHome = Platform.environment['APPDATA'] ??
          Platform.environment['HOME'] ??
          Directory.current.path;
      return '$userHome/$_saveFileName';
    } catch (_) {
      return _saveFileName;
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    _currentProfile = profile;
    try {
      final file = File(_getSaveFilePath());
      await file.writeAsString(exportProfileJson(), flush: true);
    } catch (_) {
      // Tolérance gracieuse en mémoire
    }
  }

  void addCompletedLesson(String lessonId) {
    if (!_currentProfile.completedLessons.contains(lessonId)) {
      _currentProfile.completedLessons.add(lessonId);
      saveProfile(_currentProfile);
    }
  }

  void addSesterces(int amount) {
    _currentProfile.sesterces += amount;
    saveProfile(_currentProfile);
  }

  bool unlockMonument(String monumentId, int cost) {
    if (_currentProfile.restoredMonuments.contains(monumentId)) return false;
    if (_currentProfile.sesterces < cost) return false;

    _currentProfile.sesterces -= cost;
    _currentProfile.restoredMonuments.add(monumentId);
    saveProfile(_currentProfile);
    return true;
  }

  String exportProfileJson() {
    return json.encode(_currentProfile.toJson());
  }

  bool importProfileJson(String jsonStr) {
    try {
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      _currentProfile = UserProfile.fromJson(map);
      saveProfile(_currentProfile);
      return true;
    } catch (_) {
      return false;
    }
  }
}
