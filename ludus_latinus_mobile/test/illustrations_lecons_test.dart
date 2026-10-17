import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/lesson.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/ui/features/lesson/lesson_screen.dart';
import 'package:ludus_latinus_mobile/ui/features/lesson/illustrations_lecons.dart';

void main() {
  test('La liste des leçons illustrées correspond exactement aux fichiers', () {
    final fichiers = Directory('assets/images/lecons')
        .listSync()
        .map((f) => f.uri.pathSegments.last)
        .where((n) => n.startsWith('lecon_') && n.endsWith('.jpg'))
        .map((n) => n.substring(6, n.length - 4))
        .toSet();
    expect(fichiers, leconsIllustrees);
  });

  test('Une leçon sans image garde le repli', () {
    expect(illustrationDeLecon('m11-01'), 'assets/images/lecons/lecon_m11-01.jpg');
    expect(illustrationDeLecon('m01-01'), isNull);
  });

  test('Le dossier des images de leçon est déclaré dans pubspec', () {
    expect(File('pubspec.yaml').readAsStringSync(), contains('- assets/images/lecons/'));
  });

  Future<Image> bandeau(WidgetTester tester, String id, String titre) async {
    // La police de test déborde dans l'en-tête : bruit sans rapport ici.
    final ancien = FlutterError.onError;
    FlutterError.onError = (d) { if (!d.toString().contains('overflowed')) ancien?.call(d); };
    addTearDown(() => FlutterError.onError = ancien);
    final repo = GameRepository(dataService: DataService(), storageService: StorageService());
    final l = Lesson.fromJson({
      'id': id, 'type': 'quiz', 'title': titre, 'content': 'Contenu',
      'question': 'Q ?', 'options': ['a', 'b', 'c', 'd'], 'answer': 0,
    });
    await tester.pumpWidget(MaterialApp(home: LessonScreen(repo: repo, lesson: l)));
    await tester.pump(const Duration(milliseconds: 300));
    return tester.widgetList<Image>(find.byType(Image)).firstWhere((i) =>
        i.image is AssetImage &&
        ((i.image as AssetImage).assetName.contains('/lecons/') ||
            (i.image as AssetImage).assetName.contains('musee_')));
  }

  testWidgets('Leçon de 4e : son image remplit le bandeau', (tester) async {
    final img = await bandeau(tester, 'm11-01', 'Horatius Coclès');
    expect((img.image as AssetImage).assetName, 'assets/images/lecons/lecon_m11-01.jpg');
    expect(img.fit, BoxFit.cover);
  });

  testWidgets('Leçon sans image propre : repli sur le musée, image entière', (tester) async {
    final img = await bandeau(tester, 'm03-01', 'La louve et Romulus');
    expect((img.image as AssetImage).assetName, 'assets/images/musee_louve.jpg');
    expect(img.fit, BoxFit.contain);
  });
}
