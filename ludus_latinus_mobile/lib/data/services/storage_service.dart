import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/profile.dart';

/// Service de persistance locale robuste pour la progression et le profil citoyen.
/// Sauvegarde automatique en JSON local avec rechargement au démarrage.
class StorageService {
  UserProfile _currentProfile = UserProfile();
  static const String _saveFileName = 'ludus_latinus_save.json';
  String? _cachedSaveFilePath;

  UserProfile get profile => _currentProfile;

  Future<void> init() async {
    // 1. Initialise avec un profil citoyen vierge et équitable
    _currentProfile = UserProfile(
      id: 'defaut',
      nomHeros: 'Marcus',
      genre: 'garcon',
      sesterces: 50,
      streakDays: 0,
      completedLessons: [],
      restoredMonuments: [],
    );

    // 2. Tente de restaurer la sauvegarde locale sur disque si elle existe
    try {
      final path = await _getSaveFilePath();
      final file = File(path);
      if (await file.exists()) {
        final content = await file.readAsString();
        final map = json.decode(content) as Map<String, dynamic>;
        _currentProfile = UserProfile.fromJson(map);
      }
    } catch (e) {
      debugPrint('[StorageService] Restauration locale: profil par défaut ($e)');
    }
  }

  Future<String> _getSaveFilePath() async {
    if (_cachedSaveFilePath != null) return _cachedSaveFilePath!;

    try {
      // 1. Emplacement officiel sécurisé (Android App Documents / iOS Sandbox / Desktop Documents)
      final docDir = await getApplicationDocumentsDirectory();
      _cachedSaveFilePath = '${docDir.path}/$_saveFileName';
      return _cachedSaveFilePath!;
    } catch (_) {
      // 2. Repli défensif en cas d'environnement sans plugins (tests unitaires, CLI)
      try {
        final userHome = Platform.environment['APPDATA'] ??
            Platform.environment['HOME'] ??
            Directory.current.path;
        _cachedSaveFilePath = '$userHome/$_saveFileName';
        return _cachedSaveFilePath!;
      } catch (_) {
        _cachedSaveFilePath = _saveFileName;
        return _cachedSaveFilePath!;
      }
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    _currentProfile = profile;
    try {
      final path = await _getSaveFilePath();
      final file = File(path);
      // Fichier local : le profil brut, sans l'enveloppe des sauvegardes exportées.
      await file.writeAsString(json.encode(profile.toJson()), flush: true);
    } catch (e) {
      debugPrint('[StorageService] Erreur sauvegarde disque: $e');
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

  /// Identifiant du format de sauvegarde exportable : il permet de refuser un
  /// fichier JSON quelconque que l'élève choisirait par erreur.
  static const String formatSauvegarde = 'ludus_latinus_sauvegarde';

  /// Sauvegarde exportable : le profil enveloppé avec son format, sa version
  /// et sa date, pour qu'une version future de l'appli puisse la reconnaître.
  String exportProfileJson() {
    return json.encode({
      'format': formatSauvegarde,
      'version': 1,
      'date': DateTime.now().toIso8601String(),
      'profil': _currentProfile.toJson(),
    });
  }

  /// Importe une sauvegarde. Tout est vérifié avant de toucher au profil
  /// courant : en cas d'échec, il reste intact et on retourne false.
  bool importProfileJson(String jsonStr) {
    final nouveau = lireSauvegarde(jsonStr);
    if (nouveau == null) return false;
    _currentProfile = nouveau;
    saveProfile(nouveau);
    return true;
  }

  /// Lit une sauvegarde exportée sans rien modifier ; null si le contenu n'en
  /// est pas une. Sert aussi à vérifier le fichier avant de demander confirmation.
  static UserProfile? lireSauvegarde(String jsonStr) {
    try {
      final enveloppe = json.decode(jsonStr);
      if (enveloppe is! Map<String, dynamic>) return null;
      if (enveloppe['format'] != formatSauvegarde) return null;
      final profil = enveloppe['profil'];
      if (profil is! Map<String, dynamic>) return null;
      return UserProfile.fromJson(profil);
    } catch (_) {
      return null;
    }
  }
}
