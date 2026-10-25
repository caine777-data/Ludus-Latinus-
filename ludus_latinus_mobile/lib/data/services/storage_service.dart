import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/profile.dart';

/// Service de persistance locale de la progression, un fichier JSON par élève.
///
/// Plusieurs élèves peuvent partager l'appareil (fratrie, tablette de classe) :
/// chacun a son fichier, et un petit index retient la liste des profils et
/// l'élève actif. Le premier élève garde le fichier historique
/// `ludus_latinus_save.json` : une sauvegarde d'avant le multiprofil devient
/// ce premier profil sans aucune migration.
class StorageService {
  UserProfile _currentProfile = UserProfile();
  static const String _saveFileName = 'ludus_latinus_save.json';
  static const String _indexFileName = 'ludus_latinus_profils.json';

  /// Identifiant du premier élève, celui du fichier historique.
  static const String idPremierProfil = 'defaut';

  /// Élèves au plus sur un appareil : l'écran « Qui joue ? » tient sur une
  /// page de téléphone (décision de Cédric, 25/10/2026).
  static const int profilsMax = 4;

  /// Dossier imposé (tests) ; sinon celui des documents de l'appli.
  final String? _dossierImpose;
  String? _dossierCache;

  List<String> _ids = [idPremierProfil];
  String _idActif = idPremierProfil;

  StorageService({String? dossier}) : _dossierImpose = dossier;

  UserProfile get profile => _currentProfile;
  List<String> get idsProfils => List.unmodifiable(_ids);
  String get idActif => _idActif;

  Future<void> init() async {
    await _lireIndex();
    if (!_ids.contains(_idActif)) _idActif = _ids.first;
    _currentProfile = await chargerProfil(_idActif) ?? _profilNeuf(_idActif);
  }

  /// Profil vierge d'un nouvel élève.
  UserProfile _profilNeuf(String id) => UserProfile(
        id: id,
        nomHeros: 'Marcus',
        genre: 'garcon',
        sesterces: 50,
        streakDays: 0,
        completedLessons: [],
        restoredMonuments: [],
      );

  // --- Emplacements des fichiers ---

  Future<String> _dossier() async {
    final impose = _dossierImpose;
    if (impose != null) return impose;
    if (_dossierCache != null) return _dossierCache!;
    try {
      // Emplacement officiel (documents de l'appli sur Android, iOS, bureau).
      _dossierCache = (await getApplicationDocumentsDirectory()).path;
    } catch (_) {
      // Repli sans plugins (tests unitaires, ligne de commande).
      _dossierCache = Platform.environment['APPDATA'] ?? Platform.environment['HOME'] ?? Directory.current.path;
    }
    return _dossierCache!;
  }

  static String _nomFichier(String id) =>
      id == idPremierProfil ? _saveFileName : 'ludus_latinus_save_$id.json';

  Future<File> _fichierProfil(String id) async => File('${await _dossier()}/${_nomFichier(id)}');

  // --- Index des profils ---

  Future<void> _lireIndex() async {
    try {
      final fichier = File('${await _dossier()}/$_indexFileName');
      if (!await fichier.exists()) return;
      final map = json.decode(await fichier.readAsString()) as Map<String, dynamic>;
      final ids = (map['profils'] as List?)?.map((e) => e.toString()).toList() ?? [];
      if (ids.isNotEmpty) _ids = ids;
      _idActif = map['actif'] as String? ?? _ids.first;
    } catch (e) {
      debugPrint('[StorageService] Index des profils illisible : premier profil seul ($e)');
    }
  }

  Future<void> _ecrireIndex() async {
    try {
      final fichier = File('${await _dossier()}/$_indexFileName');
      await fichier.writeAsString(json.encode({'actif': _idActif, 'profils': _ids}), flush: true);
    } catch (e) {
      debugPrint('[StorageService] Erreur écriture de l\'index des profils : $e');
    }
  }

  // --- Profils ---

  /// Lit le profil d'un élève sans le rendre actif ; null s'il n'a pas encore
  /// de fichier ou si celui-ci est illisible.
  Future<UserProfile?> chargerProfil(String id) async {
    try {
      final fichier = await _fichierProfil(id);
      if (!await fichier.exists()) return null;
      final map = json.decode(await fichier.readAsString()) as Map<String, dynamic>;
      return UserProfile.fromJson(map)..id = id;
    } catch (e) {
      debugPrint('[StorageService] Profil $id illisible ($e)');
      return null;
    }
  }

  /// Tous les élèves de l'appareil, dans l'ordre de création.
  Future<List<UserProfile>> chargerTousLesProfils() async => [
        for (final id in _ids)
          if (id == _idActif) _currentProfile else await chargerProfil(id) ?? _profilNeuf(id),
      ];

  /// Rend actif l'élève [id] : son profil remplace le profil courant.
  Future<void> changerDeProfil(String id) async {
    if (!_ids.contains(id) || id == _idActif) return;
    _currentProfile = await chargerProfil(id) ?? _profilNeuf(id);
    _idActif = id;
    await _ecrireIndex();
  }

  /// Ajoute un élève et le rend actif. Renvoie false si l'appareil en a déjà
  /// [profilsMax].
  Future<bool> creerProfil() async {
    if (_ids.length >= profilsMax) return false;
    final id = 'eleve${DateTime.now().millisecondsSinceEpoch}';
    _ids = [..._ids, id];
    _idActif = id;
    _currentProfile = _profilNeuf(id);
    await saveProfile(_currentProfile);
    await _ecrireIndex();
    return true;
  }

  /// Supprime un élève et son fichier. Le dernier élève ne se supprime pas :
  /// l'appli a toujours un profil. Si c'était l'élève actif, le premier
  /// restant prend sa place.
  Future<bool> supprimerProfil(String id) async {
    if (_ids.length <= 1 || !_ids.contains(id)) return false;
    try {
      final fichier = await _fichierProfil(id);
      if (await fichier.exists()) await fichier.delete();
    } catch (e) {
      debugPrint('[StorageService] Fichier du profil $id non supprimé : $e');
    }
    _ids = _ids.where((i) => i != id).toList();
    if (_idActif == id) {
      _idActif = _ids.first;
      _currentProfile = await chargerProfil(_idActif) ?? _profilNeuf(_idActif);
    }
    await _ecrireIndex();
    return true;
  }

  Future<void> saveProfile(UserProfile profile) async {
    _currentProfile = profile;
    try {
      // Fichier local : le profil brut, sans l'enveloppe des sauvegardes exportées.
      await (await _fichierProfil(_idActif)).writeAsString(json.encode(profile.toJson()), flush: true);
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

  /// Importe une sauvegarde dans le profil de l'élève actif. Tout est vérifié
  /// avant de toucher au profil courant : en cas d'échec, il reste intact et
  /// on retourne false.
  bool importProfileJson(String jsonStr) {
    final nouveau = lireSauvegarde(jsonStr);
    if (nouveau == null) return false;
    // Le profil importé prend la place de l'élève actif, pas d'un autre.
    nouveau.id = _idActif;
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
