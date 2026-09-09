import 'package:flutter/foundation.dart';
import '../models/monument.dart';
import '../models/profile.dart';
import '../models/srs_card.dart';
import '../models/thesaurus_entry.dart';
import '../models/world.dart';
import '../services/data_service.dart';
import '../services/storage_service.dart';

/// Repository principal qui expose l'état du jeu et de la progression à toute l'UI.
class GameRepository extends ChangeNotifier {
  final DataService dataService;
  final StorageService storageService;

  GameRepository({
    required this.dataService,
    required this.storageService,
  });

  bool get isReady => dataService.isLoaded;

  UserProfile get profile => storageService.profile;
  List<SchoolClass> get classes => dataService.classes;
  List<World> get worlds => dataService.worlds;
  List<ThesaurusEntry> get thesaurus => dataService.thesaurus;
  List<ForumMonument> get monuments => dataService.monuments;
  List<SrsCard> get srsCards => dataService.srsCards;

  Future<void> initialize() async {
    await dataService.loadDataset();
    await storageService.init();
    notifyListeners();
  }

  void completeLesson(String lessonId, int rewardSesterces) {
    storageService.addCompletedLesson(lessonId);
    // Bonus Temple de Saturne (+20%)
    double bonus = isMonumentRestored('templum_saturni') ? 0.20 : 0.0;
    int totalGain = rewardSesterces + (rewardSesterces * bonus).round();
    storageService.addSesterces(totalGain);
    notifyListeners();
  }

  void addSesterces(int amount) {
    storageService.addSesterces(amount);
    notifyListeners();
  }

  bool isLessonCompleted(String lessonId) {
    return profile.completedLessons.contains(lessonId);
  }

  bool isMonumentRestored(String monumentId) {
    return profile.restoredMonuments.contains(monumentId);
  }

  bool restoreMonument(String monumentId, int cost) {
    bool ok = storageService.unlockMonument(monumentId, cost);
    if (ok) notifyListeners();
    return ok;
  }

  void updateProfileName(String newName, String genre) {
    profile.nomHeros = newName;
    profile.genre = genre;
    storageService.saveProfile(profile);
    notifyListeners();
  }

  void registerAccount(String email) {
    profile.email = email;
    profile.lastSyncDate = DateTime.now().toString().substring(0, 16);
    storageService.saveProfile(profile);
    notifyListeners();
  }

  bool isDailyQuestCompletedToday() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return profile.lastDailyQuestDate == today;
  }

  void completeDailyQuest(int reward) {
    if (isDailyQuestCompletedToday()) return;
    profile.lastDailyQuestDate = DateTime.now().toIso8601String().substring(0, 10);
    storageService.addSesterces(reward);
    storageService.saveProfile(profile);
    notifyListeners();
  }

  bool isEpigraphDecoded(String monumentId) {
    return profile.decodedEpigraphs.contains(monumentId);
  }

  void decodeEpigraph(String monumentId, int reward) {
    if (isEpigraphDecoded(monumentId)) return;
    profile.decodedEpigraphs.add(monumentId);
    storageService.addSesterces(reward);
    storageService.saveProfile(profile);
    notifyListeners();
  }
}
