import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/profile.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/ui/features/account/account_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Profil reconnaissable, pour vérifier qu'il traverse bien export puis import.
  // Étoiles renseignées : sinon fromJson en invente (migration d'anciennes sauvegardes).
  UserProfile profilTest() => UserProfile(
        id: 'test',
        nomHeros: 'Livia',
        genre: 'fille',
        sesterces: 123,
        streakDays: 4,
        completedLessons: ['a', 'b'],
        lessonStars: {'a': 3, 'b': 2},
        restoredMonuments: ['forum'],
      );

  test('export puis import redonne le même profil', () {
    final source = StorageService();
    source.saveProfile(profilTest());
    final contenu = source.exportProfileJson();

    final cible = StorageService();
    expect(cible.importProfileJson(contenu), isTrue);
    // L'import remplit le profil de l'élève actif : seul l'identifiant change.
    expect(cible.profile.id, cible.idActif);
    expect(json.encode(cible.profile.toJson()), json.encode((source.profile..id = cible.idActif).toJson()));
  });

  test("l'export est enveloppé : format, version, date, profil", () {
    final s = StorageService()..saveProfile(profilTest());
    final map = json.decode(s.exportProfileJson()) as Map<String, dynamic>;
    expect(map['format'], 'ludus_latinus_sauvegarde');
    expect(map['version'], 1);
    expect(DateTime.tryParse(map['date'] as String), isNotNull);
    expect(map['profil'], isA<Map<String, dynamic>>());
  });

  test('un contenu invalide est refusé sans toucher au profil courant', () {
    final s = StorageService()..saveProfile(profilTest());
    final avant = json.encode(s.profile.toJson());
    final refuses = [
      '{}',
      '"texte"',
      'pas du json',
      '[]',
      json.encode({'format': 'autre', 'version': 1, 'profil': profilTest().toJson()}),
      json.encode({'version': 1, 'profil': profilTest().toJson()}),
      json.encode({'format': 'ludus_latinus_sauvegarde', 'version': 1, 'profil': 'texte'}),
      json.encode({'format': 'ludus_latinus_sauvegarde', 'version': 1}),
    ];
    for (final contenu in refuses) {
      expect(s.importProfileJson(contenu), isFalse, reason: contenu);
      expect(json.encode(s.profile.toJson()), avant, reason: contenu);
    }
  });

  test("une ancienne sauvegarde contenant 'compte' se lit sans erreur", () {
    final ancien = profilTest().toJson()
      ..['compte'] = {
        'email': 'eleve@exemple.fr',
        'tessera': 'SPQR-0000-0000',
        'derniere_sync': '2026-01-01 10:00',
      };
    final p = UserProfile.fromJson(ancien);
    expect(p.nomHeros, 'Livia');
    // Le bloc 'compte' n'est plus écrit à la sauvegarde suivante.
    expect(p.toJson().containsKey('compte'), isFalse);

    final s = StorageService();
    final enveloppe = json.encode({
      'format': 'ludus_latinus_sauvegarde',
      'version': 1,
      'date': DateTime.now().toIso8601String(),
      'profil': ancien,
    });
    expect(s.importProfileJson(enveloppe), isTrue);
    expect(s.profile.nomHeros, 'Livia');
  });

  testWidgets("l'écran Compte propose la sauvegarde, sans e-mail ni Tessera ni Cloud",
      (tester) async {
    tester.view.physicalSize = const Size(1200, 6000);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    final repo = GameRepository(dataService: DataService(), storageService: StorageService());
    await tester.pumpWidget(MaterialApp(home: AccountScreen(repo: repo)));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Sauvegarde de ta progression'), findsOneWidget);
    expect(find.text('Exporter dans un fichier'), findsOneWidget);
    expect(find.text('Importer un fichier'), findsOneWidget);

    // Le champ du nom du héros existe peut-être ; aucun champ ne doit demander
    // d'adresse courriel (programme Familles de Google Play).
    final champs = tester.widgetList<TextField>(find.byType(TextField));
    for (final c in champs) {
      expect(c.keyboardType, isNot(TextInputType.emailAddress));
    }
    expect(find.textContaining('Tessera'), findsNothing);
    expect(find.textContaining('Cloud'), findsNothing);
  });
}
