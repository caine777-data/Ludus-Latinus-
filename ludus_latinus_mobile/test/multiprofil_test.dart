import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';

// Multiprofil (25/10/2026) : un fichier par élève, 4 au plus, et une ancienne
// sauvegarde devient le premier élève sans migration.
void main() {
  late Directory dossier;

  setUp(() => dossier = Directory.systemTemp.createTempSync('ludus_profils_'));
  tearDown(() => dossier.deleteSync(recursive: true));

  test('Une sauvegarde d\'avant le multiprofil devient le premier élève', () async {
    File('${dossier.path}/ludus_latinus_save.json')
        .writeAsStringSync(json.encode({'nom_heros': 'Livia', 'completed': ['m1-01'], 'sesterces': 77}));
    final s = StorageService(dossier: dossier.path);
    await s.init();
    expect(s.idsProfils, [StorageService.idPremierProfil]);
    expect(s.profile.nomHeros, 'Livia');
    expect(s.profile.sesterces, 77);
  });

  test('Chaque élève a sa progression, retrouvée après redémarrage', () async {
    final s = StorageService(dossier: dossier.path);
    await s.init();
    await s.saveProfile(s.profile..nomHeros = 'Marcus'..sesterces = 10);
    expect(await s.creerProfil(), isTrue);
    await s.saveProfile(s.profile..nomHeros = 'Julia'..sesterces = 99);

    // Redémarrage : le dernier élève actif revient, l'autre est intact.
    final relu = StorageService(dossier: dossier.path);
    await relu.init();
    expect(relu.idsProfils.length, 2);
    expect(relu.profile.nomHeros, 'Julia');
    await relu.changerDeProfil(StorageService.idPremierProfil);
    expect(relu.profile.nomHeros, 'Marcus');
    expect(relu.profile.sesterces, 10);
  });

  test('Quatre élèves au plus', () async {
    final s = StorageService(dossier: dossier.path);
    await s.init();
    for (var i = 1; i < StorageService.profilsMax; i++) {
      expect(await s.creerProfil(), isTrue);
    }
    expect(await s.creerProfil(), isFalse);
    expect(s.idsProfils.length, StorageService.profilsMax);
  });

  test('Supprimer l\'élève actif : un autre prend sa place, le dernier reste', () async {
    final s = StorageService(dossier: dossier.path);
    await s.init();
    await s.saveProfile(s.profile..nomHeros = 'Marcus');
    await s.creerProfil();
    final idJulia = s.idActif;
    await s.saveProfile(s.profile..nomHeros = 'Julia');
    expect(await s.supprimerProfil(idJulia), isTrue);
    expect(s.profile.nomHeros, 'Marcus');
    expect(File('${dossier.path}/ludus_latinus_save_$idJulia.json').existsSync(), isFalse);
    expect(await s.supprimerProfil(s.idActif), isFalse, reason: 'le dernier élève ne se supprime pas');
  });
}
