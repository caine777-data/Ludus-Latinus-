import 'package:flutter/foundation.dart';
import '../models/goodie_item.dart';
import '../models/monument.dart';
import '../models/profile.dart';
import '../models/srs_card.dart';
import '../models/thesaurus_entry.dart';
import '../models/world.dart';
import '../services/data_service.dart';
import '../services/storage_service.dart';

/// Résultat de la validation d'une leçon, pour doser la célébration.
class LessonResult {
  final int stars;
  final int bestStars;
  final int sestercesGained;
  final bool firstTime;
  /// Vrai si ce passage bat le meilleur nombre d'étoiles précédent.
  final bool improved;
  final bool worldCompleted;
  final String? worldTitle;

  const LessonResult({
    required this.stars,
    required this.bestStars,
    required this.sestercesGained,
    required this.firstTime,
    this.improved = false,
    required this.worldCompleted,
    this.worldTitle,
  });
}

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

  /// Sesterces gagnés à la première réussite d'une leçon, selon les étoiles.
  static int rewardForStars(int stars) => const {3: 10, 2: 7, 1: 4}[stars.clamp(1, 3)]!;

  int starsForLesson(String lessonId) => profile.lessonStars[lessonId] ?? 0;

  /// Valide une leçon. Les sesterces ne sont versés qu'à la première réussite,
  /// les étoiles gardent le meilleur résultat.
  LessonResult completeLesson(String lessonId, int stars) {
    stars = stars.clamp(1, 3);
    final firstTime = !isLessonCompleted(lessonId);
    final previousStars = starsForLesson(lessonId);

    int gain = 0;
    if (firstTime) {
      final base = rewardForStars(stars);
      // Bonus Temple de Saturne (+20%)
      final bonus = isMonumentRestored('templum_saturni') ? 0.20 : 0.0;
      gain = base + (base * bonus).round();
      storageService.addCompletedLesson(lessonId);
      storageService.addSesterces(gain);
    }
    if (stars > previousStars) {
      profile.lessonStars[lessonId] = stars;
    }
    profile.recordActivity();
    storageService.saveProfile(profile);

    World? world;
    for (final w in worlds) {
      if (w.lessons.any((l) => l.id == lessonId)) {
        world = w;
        break;
      }
    }
    final worldCompleted = firstTime &&
        world != null &&
        world.lessons.every((l) => isLessonCompleted(l.id));

    notifyListeners();
    return LessonResult(
      stars: stars,
      bestStars: stars > previousStars ? stars : previousStars,
      sestercesGained: gain,
      firstTime: firstTime,
      improved: !firstTime && stars > previousStars,
      worldCompleted: worldCompleted,
      worldTitle: world?.title,
    );
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

  SrsCardProgress getSrsProgress(String cardId) {
    return profile.getCardProgress(cardId);
  }

  void recordSrsReview(String cardId, {required bool success}) {
    profile.updateCardSrs(cardId, success: success);
    profile.recordActivity();
    storageService.saveProfile(profile);
    notifyListeners();
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

  void markIntroSeen() {
    if (profile.introSeen) return;
    profile.introSeen = true;
    storageService.saveProfile(profile);
  }

  int get taverneRewardsLeftToday => profile.taverneRewardsLeftToday;

  /// Réserve un lancer récompensé de la Taverne (3 par jour). Renvoie false si épuisé.
  bool consumeTaverneReward() {
    final ok = profile.consumeTaverneReward();
    storageService.saveProfile(profile);
    notifyListeners();
    return ok;
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

  /// Le mode sombre est masqué tant que les écrans n'utilisent pas les
  /// couleurs du thème (textes invisibles, cartes restées claires).
  static const bool modeSombreDisponible = false;

  bool get isDarkMode => modeSombreDisponible && profile.isDarkMode;

  void toggleThemeMode() {
    profile.isDarkMode = !profile.isDarkMode;
    storageService.saveProfile(profile);
    notifyListeners();
  }

  // --- BOUTIQUE ET GOODIES ROMAINS ---

  String getEquippedGoodie(GoodieCategory cat) {
    return profile.getEquippedGoodie(cat.name);
  }

  bool isGoodieOwned(String goodieId) {
    return profile.isGoodieOwned(goodieId);
  }

  bool isGoodieEquipped(GoodieCategory cat, String goodieId) {
    return profile.isGoodieEquipped(cat.name, goodieId);
  }

  bool buyGoodie(GoodieItem item) {
    if (profile.sesterces < item.prix) return false;
    if (profile.isGoodieOwned(item.id)) return false;

    profile.sesterces -= item.prix;
    profile.ownedGoodies.add(item.id);
    // Équipe automatiquement le nouvel objet acheté
    profile.equippedGoodies[item.categorie.name] = item.id;

    storageService.saveProfile(profile);
    notifyListeners();
    return true;
  }

  void equipGoodie(GoodieCategory cat, String goodieId) {
    if (!profile.isGoodieOwned(goodieId) && goodieId != 'aucune' && goodieId != 'aucun') {
      return;
    }
    profile.equippedGoodies[cat.name] = goodieId;
    storageService.saveProfile(profile);
    notifyListeners();
  }
}
