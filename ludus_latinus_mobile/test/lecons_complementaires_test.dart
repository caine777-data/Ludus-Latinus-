import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/lesson.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/ui/features/lesson/lesson_screen.dart';

// Les leçons complémentaires du programme (hic/ille, eo/fero/fio, déponent,
// gérondif, subjonctif) sont insérées par l'export Python juste avant l'arène.
// On vérifie sur le vrai jeu de données qu'elles y sont, à la bonne place, et
// que l'écran de leçon les ouvre sans erreur.
void main() {
  const attendues = {
    'monde17': ['m17-05'],
    'monde20': ['m20-05'],
    'monde23': ['m23-05'],
    'monde24': ['m24-05'],
    'monde25': ['m25-05', 'm25-06'],
  };

  final donnees = jsonDecode(File('assets/data/ludus_latinus_dataset.json').readAsStringSync()) as Map<String, dynamic>;
  // Les mondes sont rangés par classe dans le jeu de données : on les aplatit.
  final mondes = <Map<String, dynamic>>[];
  void collecter(dynamic noeud) {
    if (noeud is Map<String, dynamic>) {
      if (noeud['lessons'] is List && noeud['id'] is String) mondes.add(noeud);
      noeud.values.forEach(collecter);
    } else if (noeud is List) {
      noeud.forEach(collecter);
    }
  }

  collecter(donnees);

  List<Map<String, dynamic>> leconsDe(String monde) => (mondes.firstWhere((m) => m['id'] == monde)['lessons'] as List)
      .cast<Map<String, dynamic>>();

  test('Les leçons complémentaires précèdent l\'arène de leur monde', () {
    attendues.forEach((monde, ids) {
      final lecons = leconsDe(monde);
      final finDuMonde = lecons.sublist(lecons.length - ids.length - 1).map((l) => l['id']).toList();
      expect(finDuMonde, [...ids, lecons.last['id']], reason: monde);
      expect(lecons.last['type'], 'arene', reason: monde);
    });
  });

  for (final entree in attendues.entries) {
    for (final id in entree.value) {
      testWidgets('La leçon $id s\'ouvre', (tester) async {
        final json = leconsDe(entree.key).firstWhere((l) => l['id'] == id);
        final lecon = Lesson.fromJson(json);
        expect(lecon.grammaire, isNotNull);
        tester.view.physicalSize = const Size(800, 5000);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.reset);
        // La police de test est plus large que la vraie : on ignore les
        // débordements de mise en page, on ne cherche que les vraies erreurs.
        final ancien = FlutterError.onError;
        FlutterError.onError = (d) {
          if (!d.toString().contains('overflowed')) ancien?.call(d);
        };
        addTearDown(() => FlutterError.onError = ancien);
        final repo = GameRepository(dataService: DataService(), storageService: StorageService());
        await tester.pumpWidget(MaterialApp(home: LessonScreen(repo: repo, lesson: lecon)));
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.textContaining(lecon.title.split(' : ').first), findsWidgets);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
