import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/profile.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';

// Étude d'économie d'octobre 2026 : les victoires payées des jeux sont
// ouvertes par les leçons (2 par activité du jour, 6 au plus), tous jeux
// confondus. Sans leçon, on joue pour la gloire.
void main() {
  test('Sans leçon du jour, aucune victoire payée', () {
    final profil = UserProfile();
    expect(profil.victoiresPayeesRestantes(), 0);
    expect(profil.prendreRecompense('circus'), isFalse);
  });

  test('Une leçon ouvre 2 victoires payées, partagées entre les jeux', () {
    final profil = UserProfile()..noterLeconDuJour();
    expect(profil.victoiresPayeesRestantes(), 2);
    expect(profil.prendreRecompense('circus'), isTrue);
    expect(profil.prendreRecompense('duel'), isTrue);
    expect(profil.prendreRecompense('taverne'), isFalse);
    expect(profil.victoiresPayeesRestantes(), 0);
  });

  test('Six victoires payées au plus, même après quatre leçons', () {
    final profil = UserProfile();
    for (var i = 0; i < 4; i++) {
      profil.noterLeconDuJour();
    }
    expect(profil.victoiresPayeesRestantes(), UserProfile.victoiresPayeesMax);
    for (var i = 0; i < 6; i++) {
      expect(profil.prendreRecompense('circus'), isTrue);
    }
    expect(profil.prendreRecompense('circus'), isFalse);
  });

  test('Les victoires d\'hier ne comptent pas aujourd\'hui', () {
    final profil = UserProfile(recompensesJeuxDate: '2000-01-01', recompensesJeux: {'duel': 6})..noterLeconDuJour();
    expect(profil.victoiresPayeesRestantes(), 2);
  });

  test('Victoires utilisées et missions de César survivent à la sauvegarde', () {
    final profil = UserProfile()
      ..missionsCesar.add(2)
      ..noterLeconDuJour();
    profil.prendreRecompense('duel');
    final relu = UserProfile.fromJson(profil.toJson());
    expect(relu.missionsCesar, [2]);
    expect(relu.victoiresPayeesRestantes(), 1);
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

  test('Une course payée rapporte le barème, puis plus rien', () {
    final repo = GameRepository(dataService: DataService(), storageService: StorageService());
    repo.profile
      ..lastDailyQuestDate = DateTime.now().toIso8601String().substring(0, 10)
      ..sesterces = 0
      ..noterLeconDuJour();
    for (var i = 0; i < 2; i++) {
      expect(repo.payerPartie('circus', GameRepository.gainCircus), GameRepository.gainCircus);
    }
    expect(repo.payerPartie('circus', GameRepository.gainCircus), 0);
    expect(repo.profile.sesterces, 2 * GameRepository.gainCircus);
  });

  test('La prime de l\'objectif monte avec la série, de 5 à 10', () {
    expect(GameRepository.primeObjectif(0), 5);
    expect(GameRepository.primeObjectif(1), 5);
    expect(GameRepository.primeObjectif(2), 6);
    expect(GameRepository.primeObjectif(6), 10);
    expect(GameRepository.primeObjectif(40), 10);
  });
}
