import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/album.dart';
import 'package:ludus_latinus_mobile/data/models/profile.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/ui/features/bataille/bataille_logique.dart';

/// Stockage en mémoire : les tests n'écrivent pas de fichier de sauvegarde.
class _StockageMemoire extends StorageService {
  @override
  Future<void> saveProfile(UserProfile profile) async {}
}

// Série 2 de l'album (retour de Clovis, 29/10/2026) : des cartes gagnées en jouant
// à la Bataille et aux nouveaux jeux, d'autres achetées, et Cléopâtre.
void main() {
  late DataService data;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    data = DataService();
    await data.loadDataset();
  });

  GameRepository depot() {
    final repo = GameRepository(dataService: data, storageService: _StockageMemoire());
    repo.profile.cartesAlbum.clear();
    repo.profile.compteurs.clear();
    repo.profile.records.clear();
    repo.profile.sesterces = 0;
    return repo;
  }

  CarteAlbum carte(String id) => data.cartesAlbum.firstWhere((c) => c.id == id);

  test('Les victoires contre Crassus donnent leurs cartes et ouvrent Cléopâtre au bon moment', () {
    final repo = depot();
    repo.noterBataille(victoire: true);
    expect(repo.aLaCarte('her_clelie'), isTrue);
    expect(repo.aLaCarte('her_remus'), isFalse);
    repo.noterBataille(victoire: true);
    expect(repo.aLaCarte('her_remus'), isTrue);
    expect(repo.cleopatreOuverte, isFalse);
    for (var i = 0; i < 3; i++) {
      repo.noterBataille(victoire: true);
    }
    expect(repo.aLaCarte('her_mucius'), isTrue);
    expect(repo.cleopatreOuverte, isTrue);
  });

  test('Les victoires contre Cléopâtre ont leur propre compteur, jusqu\'à Jules César', () {
    final repo = depot();
    repo.noterBataille(victoire: true, contreCleopatre: true);
    expect(repo.aLaCarte('mon_phenix'), isTrue);
    expect(repo.victoiresContreCrassus, 0);
    for (var i = 0; i < 6; i++) {
      repo.noterBataille(victoire: true, contreCleopatre: true);
    }
    expect(repo.aLaCarte('her_cesar'), isTrue);
    expect(repo.aLaCarte('div_venus'), isFalse);
  });

  test('Les nouveaux jeux donnent leurs cartes', () {
    final repo = depot();
    repo.noterEvenement('paires_victoires');
    expect(repo.aLaCarte('her_atalante'), isTrue);
    repo.enregistrerRecord('paires', 30);
    expect(repo.aLaCarte('mon_griffon'), isTrue);

    final mot = repo.motDuJour();
    expect(mot, isNotNull);
    repo.proposerMotDuJour(repo.profile.motDuJour!);
    expect(repo.aLaCarte('div_janus'), isTrue);
    expect(repo.profile.compteurs['mots_du_jour_trouves'], 1);
    // Rejouer le même jour ne compte pas deux fois.
    repo.proposerMotDuJour(repo.profile.motDuJour!);
    expect(repo.profile.compteurs['mots_du_jour_trouves'], 1);
  });

  test('Acheter : le prix est retiré, sans prime, une seule fois, jamais à crédit', () {
    final repo = depot();
    final forum = carte('mon_forum');
    expect(repo.acheterCarte(forum), isFalse, reason: 'pas assez de sesterces');
    repo.profile.sesterces = 100;
    expect(repo.acheterCarte(forum), isTrue);
    expect(repo.profile.sesterces, 100 - forum.prix!);
    expect(repo.aLaCarte(forum.id), isTrue);
    expect(repo.cartesAAnnoncer, isEmpty);
    expect(repo.acheterCarte(forum), isFalse, reason: 'déjà obtenue');
    repo.profile.sesterces = 1000;
    expect(repo.acheterCarte(carte('her_cesar')), isFalse, reason: 'se gagne, ne s\'achète pas');
  });

  test('Une carte à vendre n\'a pas de succès, et les prix suivent la rareté', () {
    const prix = {'commune': 80, 'rare': 150, 'epique': 300, 'legendaire': 600};
    final repo = depot();
    expect(repo.cartesAVendre.length, 16);
    for (final c in repo.cartesAVendre) {
      expect(c.prix, prix[c.rarete]);
      expect(repo.succesDeLaCarte(c.id), isNull);
    }
  });

  test('Cléopâtre oppose une rareté au-dessus, sans doublon', () {
    const rangs = ['commune', 'rare', 'epique', 'legendaire'];
    final main = data.cartesAlbum.where((c) => c.rarete == 'commune').take(5).toList();
    for (var graine = 0; graine < 20; graine++) {
      final adverse = mainDeCleopatre(main, data.cartesAlbum, Random(graine));
      expect(adverse.length, main.length);
      expect(adverse.map((c) => c.id).toSet().length, main.length);
      for (final c in adverse) {
        expect(rangs.indexOf(c.rarete), 1);
      }
    }
    // Aucune rareté au-dessus de légendaire : elle reste légendaire.
    final fortes = data.cartesAlbum.where((c) => c.rarete == 'legendaire').take(2).toList();
    final adverse = mainDeCleopatre(fortes, data.cartesAlbum, Random(1));
    expect(adverse.every((c) => c.rarete == 'legendaire'), isTrue);
  });
}
