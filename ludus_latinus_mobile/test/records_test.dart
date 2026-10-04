import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/profile.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';

void main() {
  test('Un record ne retient que le meilleur résultat', () {
    final repo = GameRepository(dataService: DataService(), storageService: StorageService());
    expect(repo.record('circus'), 0);
    expect(repo.enregistrerRecord('circus', 120), isTrue);
    expect(repo.enregistrerRecord('circus', 80), isFalse);
    expect(repo.enregistrerRecord('circus', 120), isFalse);
    expect(repo.record('circus'), 120);
    expect(repo.enregistrerRecord('circus', 150), isTrue);
    expect(repo.record('circus'), 150);
    expect(repo.record('duel'), 0, reason: 'chaque jeu a son propre record');
  });

  test('Les records survivent à la sauvegarde du profil', () {
    final repo = GameRepository(dataService: DataService(), storageService: StorageService());
    repo.enregistrerRecord('memoria', 7);
    final relu = UserProfile.fromJson(repo.profile.toJson());
    expect(relu.records['memoria'], 7);
  });
}
