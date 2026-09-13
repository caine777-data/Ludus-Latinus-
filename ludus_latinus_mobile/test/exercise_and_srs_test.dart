import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/lesson.dart';
import 'package:ludus_latinus_mobile/data/models/profile.dart';

void main() {
  group('Didactique & Parsing des 5 Types d''Exercices Interactifs', () {
    test('Type "puzzle" (Reconstitution de phrase) : extrait consigne, mots et solution', () {
      final json = {
        'id': 'm1-03',
        'titre': 'La Phrase Latine',
        'type': 'puzzle',
        'description': 'Construis la phrase',
        'consigne': 'Remets les mots dans l''ordre.',
        'words': ['Romulus', 'Romam', 'condit'],
        'solution': 'Romulus Romam condit',
        'xp': 20,
        'sesterces': 15,
      };

      final lesson = Lesson.fromJson(json);
      expect(lesson.type, equals('puzzle'));
      expect(lesson.words, containsAll(['Romulus', 'Romam', 'condit']));
      expect(lesson.solution, equals('Romulus Romam condit'));
      expect(lesson.consigne, contains('Remets'));
    });

    test('Type "trou" (Texte à trou & terminaison) : extrait avant, après et solution', () {
      final json = {
        'id': 'm1-04',
        'titre': 'La 1ère Déclinaison',
        'type': 'trou',
        'avant': 'Lupa puer',
        'apres': 'nutrit.',
        'solution': 'os',
        'consigne': 'Complète la désinence du COD accusatif.',
      };

      final lesson = Lesson.fromJson(json);
      expect(lesson.type, equals('trou'));
      expect(lesson.avant, equals('Lupa puer'));
      expect(lesson.apres, equals('nutrit.'));
      expect(lesson.solution, equals('os'));
    });

    test('Type "decodeur" (Radiographie grammaticale des cas) : extrait latinComplet et roles', () {
      final json = {
        'id': 'm1-08',
        'titre': 'Analyse des Fonctions',
        'type': 'decodeur',
        'latinComplet': 'Marcus gladium tenet',
        'roles': [
          {'mot': 'Marcus', 'cas': 'Nominatif (Sujet)'},
          {'mot': 'gladium', 'cas': 'Accusatif (COD)'},
          {'mot': 'tenet', 'cas': 'Verbe'},
        ],
      };

      final lesson = Lesson.fromJson(json);
      expect(lesson.type, equals('decodeur'));
      expect(lesson.latinComplet, equals('Marcus gladium tenet'));
      expect(lesson.roles.length, equals(3));
      expect(lesson.roles['Marcus'], contains('Nominatif'));
    });

    test('Type "arene" (Combat Boss didactique) : extrait nom du boss et série de questions', () {
      final json = {
        'id': 'm1-10',
        'titre': 'Le Défi de Marcus',
        'type': 'arene',
        'boss': 'Gladiateur Rétiaire',
        'questions': [
          {
            'question': 'Quel cas pour le COD ?',
            'options': ['Nominatif', 'Accusatif', 'Génitif'],
            'reponse': 'Accusatif',
            'explication': 'L''accusatif marque le COD.',
          },
          {
            'question': 'Que signifie "lupus" ?',
            'options': ['Le loup', 'Le lion', 'L''ours'],
            'reponse': 'Le loup',
            'explication': 'Lupus = loup.',
          }
        ],
      };

      final lesson = Lesson.fromJson(json);
      expect(lesson.type, equals('arene'));
      expect(lesson.bossName, equals('Gladiateur Rétiaire'));
      expect(lesson.questions.length, equals(2));
      expect(lesson.questions.first['reponse'], equals('Accusatif'));
    });
  });

  group('Système de Répétition Espacée Leitner SM-2 (Memoria Velox)', () {
    test('Progression initiale : Boîte 1, échéance immédiate, 0 révision', () {
      final prog = SrsCardProgress.initial();
      expect(prog.box, equals(1));
      expect(prog.totalReviews, equals(0));
      expect(prog.lapses, equals(0));
      expect(prog.isDue, isTrue);
    });

    test('Succès consécutifs : progression de Boîte 1 jusqu''à Boîte 5 avec intervalles croissants', () {
      var prog = SrsCardProgress.initial();

      // Succès 1 : Boîte 1 -> Boîte 2 (+3 jours)
      prog = prog.onSuccess();
      expect(prog.box, equals(2));
      expect(prog.totalReviews, equals(1));
      expect(prog.lapses, equals(0));
      expect(prog.nextReviewDate.isAfter(DateTime.now().add(const Duration(days: 2))), isTrue);

      // Succès 2 : Boîte 2 -> Boîte 3 (+7 jours)
      prog = prog.onSuccess();
      expect(prog.box, equals(3));
      expect(prog.totalReviews, equals(2));

      // Succès 3 : Boîte 3 -> Boîte 4 (+14 jours)
      prog = prog.onSuccess();
      expect(prog.box, equals(4));

      // Succès 4 : Boîte 4 -> Boîte 5 (+30 jours)
      prog = prog.onSuccess();
      expect(prog.box, equals(5));

      // Plafond à Boîte 5
      prog = prog.onSuccess();
      expect(prog.box, equals(5));
      expect(prog.totalReviews, equals(5));
    });

    test('Échec : régression immédiate en Boîte 1 et incrément des oublis (lapses)', () {
      var prog = SrsCardProgress(
        box: 4,
        nextReviewDate: DateTime.now().add(const Duration(days: 10)),
        totalReviews: 6,
        lapses: 0,
      );

      // Si erreur / oubli : retour boîte 1
      prog = prog.onFailure();
      expect(prog.box, equals(1));
      expect(prog.lapses, equals(1));
      expect(prog.totalReviews, equals(7));
      expect(prog.isDue, isTrue);
    });

    test('Sérialisation UserProfile avec état SRS des cartes', () {
      final profile = UserProfile(
        nomHeros: 'Horatius',
        sesterces: 75,
      );

      profile.updateCardSrs('lupus', success: true);
      profile.updateCardSrs('gladius', success: false);

      final json = profile.toJson();
      expect(json['srs_cards'], isNotNull);
      expect(json['srs_cards']['lupus']['box'], equals(2));
      expect(json['srs_cards']['gladius']['box'], equals(1));
      expect(json['srs_cards']['gladius']['lapses'], equals(1));

      final restored = UserProfile.fromJson(json);
      expect(restored.srsCards['lupus']?.box, equals(2));
      expect(restored.srsCards['gladius']?.box, equals(1));
      expect(restored.srsCards['gladius']?.lapses, equals(1));
    });

    test('Profil par défaut vierge : 0 leçons, 0 monuments, 50 HS', () {
      final profile = UserProfile();
      expect(profile.completedLessons, isEmpty);
      expect(profile.restoredMonuments, isEmpty);
      expect(profile.sesterces, equals(50));
      expect(profile.streakDays, equals(1));
    });
  });
}
