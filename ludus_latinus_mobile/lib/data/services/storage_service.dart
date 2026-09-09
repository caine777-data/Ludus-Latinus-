import 'dart:convert';
import '../models/profile.dart';

/// Service de persistance locale pour la progression et le profil citoyen.
class StorageService {
  UserProfile _currentProfile = UserProfile();

  UserProfile get profile => _currentProfile;

  Future<void> init() async {
    // Initialise avec le profil par défaut de Marcus
    _currentProfile = UserProfile(
      id: 'defaut',
      nomHeros: 'Marcus',
      genre: 'garcon',
      sesterces: 120,
      streakDays: 3,
      completedLessons: ['m1-01', 'm1-02'],
      restoredMonuments: ['lacus_iuturnae'],
    );
  }

  Future<void> saveProfile(UserProfile profile) async {
    _currentProfile = profile;
    // La sérialisation JSON permet la sauvegarde dans SharedPreferences ou SQLite
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
