import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/profile.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/ui/features/album/album_screen.dart';

/// Stockage en mémoire : les tests n'écrivent pas de fichier de sauvegarde.
class _StockageMemoire extends StorageService {
  @override
  Future<void> saveProfile(UserProfile profile) async {}
}

void main() {
  late DataService data;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    data = DataService();
    await data.loadDataset();
  });

  GameRepository depot([UserProfile? profil]) {
    final stockage = _StockageMemoire();
    // Le profil voulu passe par l'import d'une sauvegarde, comme dans l'appli.
    if (profil != null) {
      stockage.importProfileJson(json.encode({'format': StorageService.formatSauvegarde, 'profil': profil.toJson()}));
    }
    return GameRepository(dataService: data, storageService: stockage);
  }

  test('L\'album a 32 cartes et un succès par carte', () {
    expect(data.cartesAlbum.length, 32);
    expect(data.succesAlbum.map((s) => s.carteId).toSet(), data.cartesAlbum.map((c) => c.id).toSet());
  });

  test('Chaque carte a son illustration dans les assets', () {
    for (final c in data.cartesAlbum) {
      expect(File(c.image).existsSync(), isTrue, reason: c.image);
    }
  });

  test('Terminer le monde 1 donne Romulus, une seule fois, avec ses sesterces', () {
    final repo = depot();
    final avant = repo.profile.sesterces;
    for (final l in repo.worlds.first.lessons) {
      repo.completeLesson(l.id, 3);
    }
    expect(repo.aLaCarte('her_romulus'), isTrue);
    // Le monde 1 compte au moins 5 leçons : la Borne milliaire tombe aussi.
    expect(repo.aLaCarte('mon_borne'), isTrue);
    final annoncees = repo.cartesAAnnoncer.map((c) => c.id).toList();
    expect(annoncees, containsAll(['her_romulus', 'mon_borne']));
    expect(repo.profile.sesterces, greaterThanOrEqualTo(avant + 20));

    // Une nouvelle vérification ne redonne rien.
    expect(repo.verifierSucces(), isEmpty);
    expect(repo.profile.cartesAlbum.where((id) => id == 'her_romulus').length, 1);
  });

  test('Duel : Crixus vaincu sans faute donne le Lion de Némée et Méduse', () {
    final repo = depot();
    repo.noterVictoireDuel('Crixus le Rétiaire', sansFaute: true);
    expect(repo.aLaCarte('mon_lion'), isTrue);
    expect(repo.aLaCarte('mon_meduse'), isTrue);
    expect(repo.aLaCarte('div_mars'), isFalse);
    // Le même gladiateur vaincu deux fois ne compte qu'une fois pour Mars.
    repo.noterVictoireDuel('Crixus le Rétiaire', sansFaute: false);
    expect(repo.profile.gladiateursVaincus.length, 1);
    expect(repo.valeurStat('duels_gagnes'), 2);
  });

  test('Un profil qui a déjà progressé reçoit ses cartes d\'un coup', () {
    final profil = UserProfile(streakDays: 4);
    for (final w in data.worlds.take(3)) {
      profil.completedLessons.addAll(w.lessons.map((l) => l.id));
    }
    final repo = depot(profil);
    final nouvelles = repo.verifierSucces().map((c) => c.id).toSet();
    expect(nouvelles, containsAll(['her_romulus', 'her_julia', 'her_persee', 'mon_borne', 'div_apollon']));
    expect(nouvelles.contains('her_ulysse'), isFalse);
  });

  test('Les compteurs des jeux alimentent leurs succès', () {
    final repo = depot();
    for (var i = 0; i < 10; i++) {
      repo.noterEvenement('taverne_victoires');
    }
    expect(repo.aLaCarte('mon_cerbere'), isTrue);
    repo.noterEvenement('courses_finies');
    expect(repo.aLaCarte('mon_centaure'), isTrue);
  });

  testWidgets('Album : carte verrouillée avec son succès et sa progression', (tester) async {
    tester.view.physicalSize = const Size(1600, 4000);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);
    final repo = depot();
    repo.completeLesson(repo.worlds.first.lessons.first.id, 3);
    await tester.pumpWidget(MaterialApp(home: AlbumScreen(repo: repo)));
    await tester.pumpAndSettle();
    // Famille Héros affichée d'abord : Horace attend 50 leçons, l'élève en a une.
    expect(find.text('Réussir 50 leçons'), findsOneWidget);
    expect(find.text('1 / 50'), findsOneWidget);
  });
}
