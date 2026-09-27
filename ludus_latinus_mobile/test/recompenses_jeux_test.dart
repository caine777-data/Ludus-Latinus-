import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/profile.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';

void main() {
  test('Trois parties payées par jour et par jeu, pas une de plus', () {
    final profil = UserProfile();
    expect(profil.recompensesRestantes('circus'), 3);
    expect(profil.prendreRecompense('circus'), isTrue);
    expect(profil.prendreRecompense('circus'), isTrue);
    expect(profil.prendreRecompense('circus'), isTrue);
    expect(profil.prendreRecompense('circus'), isFalse);
    expect(profil.recompensesRestantes('circus'), 0);
    // Le quota d'un jeu n'entame pas celui d'un autre.
    expect(profil.recompensesRestantes('duel'), 3);
  });

  test('Le quota repart à zéro le lendemain', () {
    final profil = UserProfile(recompensesJeuxDate: '2000-01-01', recompensesJeux: {'duel': 3});
    expect(profil.recompensesRestantes('duel'), 3);
    expect(profil.prendreRecompense('duel'), isTrue);
    expect(profil.recompensesRestantes('duel'), 2);
  });

  test('Quotas et missions de César survivent à la sauvegarde', () {
    final profil = UserProfile()..missionsCesar.add(2);
    profil.prendreRecompense('duel');
    final relu = UserProfile.fromJson(profil.toJson());
    expect(relu.missionsCesar, [2]);
    expect(relu.recompensesRestantes('duel'), 2);
  });

  test('Le défi du jour se paie en jouant au bon jeu, une seule fois', () {
    final repo = GameRepository(dataService: DataService(), storageService: StorageService());
    repo.profile.sesterces = 0;
    final jeu = repo.defiDuJour.routeCible;
    expect(repo.accomplirDefi(jeu == 'circus' ? 'duel' : 'circus'), 0);
    expect(repo.accomplirDefi(jeu), repo.defiDuJour.recompense);
    expect(repo.accomplirDefi(jeu), 0);
    expect(repo.profile.sesterces, repo.defiDuJour.recompense);
  });

  test('Une course payée rapporte le barème, puis plus rien après 3', () {
    final repo = GameRepository(dataService: DataService(), storageService: StorageService());
    repo.profile.lastDailyQuestDate = DateTime.now().toIso8601String().substring(0, 10);
    repo.profile.sesterces = 0;
    for (var i = 0; i < 3; i++) {
      expect(repo.payerPartie('circus', GameRepository.gainCircus), GameRepository.gainCircus);
    }
    expect(repo.payerPartie('circus', GameRepository.gainCircus), 0);
    expect(repo.profile.sesterces, 3 * GameRepository.gainCircus);
  });
}
