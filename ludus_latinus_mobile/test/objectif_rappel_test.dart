import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/profile.dart';
import 'package:ludus_latinus_mobile/data/services/rappel_service.dart';

void main() {
  final lundi = DateTime(2026, 10, 19, 9, 0);

  group('Objectif du jour', () {
    test('Une leçon ou 10 cartes Memoria font une activité', () {
      final p = UserProfile(objectifJour: 2);
      p.noterLeconDuJour(lundi);
      expect(p.activitesDuJour(lundi), 1);
      for (var i = 0; i < 9; i++) {
        p.noterRevisionDuJour(lundi);
      }
      expect(p.activitesDuJour(lundi), 1);
      p.noterRevisionDuJour(lundi);
      expect(p.activitesDuJour(lundi), 2);
    });

    test('Objectif validé une seule fois par jour, compteurs remis à zéro le lendemain', () {
      final p = UserProfile(objectifJour: 1);
      expect(p.validerObjectif(lundi), isFalse);
      p.noterLeconDuJour(lundi);
      expect(p.validerObjectif(lundi), isTrue);
      expect(p.validerObjectif(lundi), isFalse);
      final mardi = lundi.add(const Duration(days: 1));
      expect(p.activitesDuJour(mardi), 0);
      expect(p.objectifAtteintAujourdhui(mardi), isFalse);
      p.noterLeconDuJour(mardi);
      expect(p.validerObjectif(mardi), isTrue);
    });

    test('Ancienne sauvegarde : objectif 1, rappel désactivé, 17 h 30', () {
      final p = UserProfile.fromJson({'nom_heros': 'Livia'});
      expect(p.objectifJour, 1);
      expect(p.rappelActif, isFalse);
      expect(p.rappelPropose, isFalse);
      expect(p.rappelMinutes, 17 * 60 + 30);
    });
  });

  group('Rappels des 7 prochains jours', () {
    test('Objectif pas encore atteint : rappel ce soir, la série en jeu ce soir', () {
      final r = rappelsAProgrammer(minutes: 17 * 60 + 30, serie: 5, joueAujourdhui: false, faitAujourdhui: false, maintenant: lundi);
      expect(r.length, 7);
      expect(r.first.quand, DateTime(2026, 10, 19, 17, 30));
      expect(r.first.serieEnJeu, isTrue);
      expect(r.skip(1).any((x) => x.serieEnJeu), isFalse);
    });

    test('Objectif atteint : pas de rappel ce soir, la série en jeu demain', () {
      final r = rappelsAProgrammer(minutes: 17 * 60 + 30, serie: 5, joueAujourdhui: true, faitAujourdhui: true, maintenant: lundi);
      expect(r.length, 6);
      expect(r.first.quand, DateTime(2026, 10, 20, 17, 30));
      expect(r.first.serieEnJeu, isTrue);
    });

    test('Heure déjà passée : le premier rappel est demain ; une série de 1 jour reste un rappel simple', () {
      final soir = DateTime(2026, 10, 19, 20, 0);
      final r = rappelsAProgrammer(minutes: 17 * 60 + 30, serie: 1, joueAujourdhui: false, faitAujourdhui: false, maintenant: soir);
      expect(r.first.jour, 1);
      expect(r.any((x) => x.serieEnJeu), isFalse);
    });

    test("A joué hier sans atteindre l'objectif aujourd'hui : la série en jeu ce soir", () {
      final r = rappelsAProgrammer(minutes: 17 * 60 + 30, serie: 12, joueAujourdhui: false, faitAujourdhui: false, maintenant: lundi);
      expect(r.first.jour, 0);
      expect(r.first.serieEnJeu, isTrue);
    });

    test("A joué aujourd'hui sans atteindre l'objectif : rappel ce soir, mais la série en jeu demain", () {
      final r = rappelsAProgrammer(minutes: 17 * 60 + 30, serie: 12, joueAujourdhui: true, faitAujourdhui: false, maintenant: lundi);
      expect(r.first.jour, 0);
      expect(r.first.serieEnJeu, isFalse);
      expect(r[1].serieEnJeu, isTrue);
    });
  });
}
