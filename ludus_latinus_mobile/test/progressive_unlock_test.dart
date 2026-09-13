import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/profile.dart';

void main() {
  group('Déblocage Progressif des Mini-Jeux (Progressive Disclosure)', () {
    test('Nouveau joueur débutant (0 leçon terminée) : jeux verrouillés avec consignes d\'avancement', () {
      final profile = UserProfile(completedLessons: []);

      expect(profile.isCircusUnlocked, isFalse);
      expect(profile.isColosseumUnlocked, isFalse);
      expect(profile.isTaverneUnlocked, isFalse);
      expect(profile.isCesarUnlocked, isFalse);
      expect(profile.isMarcheTrajanUnlocked, isFalse);
      expect(profile.isPantheonUnlocked, isFalse);

      final circusStatus = profile.getUnlockStatusForGame('circus');
      expect(circusStatus.isUnlocked, isFalse);
      expect(circusStatus.progress, equals(0.0));
      expect(circusStatus.reason, contains('Via Appia'));

      final taverneStatus = profile.getUnlockStatusForGame('taverne');
      expect(taverneStatus.isUnlocked, isFalse);
      expect(taverneStatus.progress, equals(0.0));
      expect(taverneStatus.reason, contains('Palier II'));
    });

    test('Joueur au Palier I (1 à 3 leçons) : Circus et Colosseum débloqués', () {
      final profile = UserProfile(completedLessons: ['palier1_l1', 'palier1_l2']);

      expect(profile.isCircusUnlocked, isTrue);
      expect(profile.isColosseumUnlocked, isTrue);
      expect(profile.isTaverneUnlocked, isFalse);
      expect(profile.isCesarUnlocked, isFalse);

      final circusStatus = profile.getUnlockStatusForGame('circus');
      expect(circusStatus.isUnlocked, isTrue);
      expect(circusStatus.progress, equals(1.0));

      final taverneStatus = profile.getUnlockStatusForGame('taverne');
      expect(taverneStatus.isUnlocked, isFalse);
      expect(taverneStatus.progress, closeTo(2 / 6, 0.01));
    });

    test('Joueur au Palier II (6 leçons) : Taverne des Dés débloquée', () {
      final lessons = List.generate(6, (i) => 'lesson_$i');
      final profile = UserProfile(completedLessons: lessons);

      expect(profile.isTaverneUnlocked, isTrue);
      expect(profile.isCesarUnlocked, isFalse);
      expect(profile.getUnlockStatusForGame('taverne').isUnlocked, isTrue);
    });

    test('Joueur au Palier III (12 leçons) : Atelier de César débloqué', () {
      final lessons = List.generate(12, (i) => 'lesson_$i');
      final profile = UserProfile(completedLessons: lessons);

      expect(profile.isCesarUnlocked, isTrue);
      expect(profile.isMarcheTrajanUnlocked, isFalse);
      expect(profile.getUnlockStatusForGame('cesar').isUnlocked, isTrue);
    });

    test('Joueur au Palier IV (18 leçons) : Marché de Trajan débloqué', () {
      final lessons = List.generate(18, (i) => 'lesson_$i');
      final profile = UserProfile(completedLessons: lessons);

      expect(profile.isMarcheTrajanUnlocked, isTrue);
      expect(profile.getUnlockStatusForGame('marche').isUnlocked, isTrue);
    });

    test('Panthéon débloqué dès 1 monument restauré', () {
      final profile = UserProfile(
        completedLessons: ['lesson_1'],
        restoredMonuments: ['curia_julia'],
      );

      expect(profile.isPantheonUnlocked, isTrue);
      expect(profile.getUnlockStatusForGame('pantheon').isUnlocked, isTrue);
    });
  });
}
