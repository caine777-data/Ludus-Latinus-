import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/daily_quest.dart';
import 'package:ludus_latinus_mobile/data/models/profile.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';

void main() {
  group('Étoiles des leçons', () {
    test('Les leçons validées avant les étoiles gardent 3 étoiles', () {
      final profile = UserProfile.fromJson({
        'completed': ['m1-01', 'm1-02'],
      });
      expect(profile.lessonStars['m1-01'], 3);
      expect(profile.lessonStars['m1-02'], 3);
    });

    test('Les étoiles enregistrées priment et restent entre 1 et 3', () {
      final profile = UserProfile.fromJson({
        'completed': ['m1-01'],
        'lesson_stars': {'m1-01': 1, 'm1-03': 9},
      });
      expect(profile.lessonStars['m1-01'], 1);
      expect(profile.lessonStars['m1-03'], 3);
      expect(UserProfile.fromJson(profile.toJson()).lessonStars, profile.lessonStars);
    });

    test('La récompense baisse avec les aides', () {
      expect(GameRepository.rewardForStars(3), greaterThan(GameRepository.rewardForStars(2)));
      expect(GameRepository.rewardForStars(2), greaterThan(GameRepository.rewardForStars(1)));
    });
  });

  group('Série de jours', () {
    final lundi = DateTime(2026, 9, 14);

    test('Un nouveau profil commence à 0', () {
      expect(UserProfile().currentStreak(lundi), 0);
    });

    test('Des jours consécutifs font monter la série, une seule fois par jour', () {
      final p = UserProfile();
      p.recordActivity(lundi);
      p.recordActivity(lundi);
      expect(p.currentStreak(lundi), 1);
      p.recordActivity(lundi.add(const Duration(days: 1)));
      expect(p.currentStreak(lundi.add(const Duration(days: 1))), 2);
    });

    test('Un jour manqué remet la série à zéro', () {
      final p = UserProfile();
      p.recordActivity(lundi);
      p.recordActivity(lundi.add(const Duration(days: 1)));
      expect(p.currentStreak(lundi.add(const Duration(days: 3))), 0);
      p.recordActivity(lundi.add(const Duration(days: 3)));
      expect(p.currentStreak(lundi.add(const Duration(days: 3))), 1);
    });
  });

  group('Défi du jour', () {
    test('Ne propose jamais une activité verrouillée', () {
      for (var d = 0; d < 30; d++) {
        final q = DailyQuest.getTodayQuest(DateTime(2026, 1, 1).add(Duration(days: d)), (q) => q.routeCible != 'duel');
        expect(q.routeCible, isNot('duel'));
      }
    });
  });

  group('Taverne', () {
    test('Trois lancers récompensés par jour, puis plus rien', () {
      final profile = UserProfile();
      expect(profile.taverneRewardsLeftToday, 3);
      expect(profile.consumeTaverneReward(), isTrue);
      expect(profile.consumeTaverneReward(), isTrue);
      expect(profile.consumeTaverneReward(), isTrue);
      expect(profile.consumeTaverneReward(), isFalse);
      expect(profile.taverneRewardsLeftToday, 0);
    });

    test('Le quota repart à zéro un autre jour', () {
      final profile = UserProfile(taverneRewardDate: '2000-01-01', taverneRewardCount: 3);
      expect(profile.taverneRewardsLeftToday, 3);
      expect(profile.consumeTaverneReward(), isTrue);
    });
  });
}
