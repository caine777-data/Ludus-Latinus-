import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/profile.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';

/// Stockage en mémoire : les tests n'écrivent pas de fichier de sauvegarde.
class _StockageMemoire extends StorageService {
  @override
  Future<void> saveProfile(UserProfile profile) async {}
}

// Audit T58 : le nouveau rang et l'ouverture du Colisée passaient en silence.
// Chaque déblocage doit être annoncé une fois, et une ancienne sauvegarde ne
// doit pas recevoir d'un coup l'annonce de tout ce qu'elle a déjà ouvert.
void main() {
  late DataService data;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    data = DataService();
    await data.loadDataset();
  });

  test('Premier relevé silencieux, puis rang et Colisée annoncés une fois', () {
    final repo = GameRepository(dataService: data, storageService: _StockageMemoire());
    repo.profile.completedLessons.clear();

    // Premier passage : on note l'état, rien à annoncer.
    var annonce = repo.deblocagesAAnnoncer();
    expect(annonce.rang, isNull);
    expect(annonce.jeux, isEmpty);

    // Trois leçons : le Colisée s'ouvre (2 leçons) et le rang monte (3 leçons).
    repo.profile.completedLessons.addAll(['m1-01', 'm1-02', 'm1-03']);
    annonce = repo.deblocagesAAnnoncer();
    expect(annonce.jeux, ['duel']);
    expect(annonce.rang, isNotNull);
    expect(annonce.rang!.titre, isNot('Tiro'));

    // Déjà annoncé : plus rien.
    annonce = repo.deblocagesAAnnoncer();
    expect(annonce.rang, isNull);
    expect(annonce.jeux, isEmpty);
  });

  test('Une ancienne sauvegarde avancée n\'est pas inondée d\'annonces', () {
    final repo = GameRepository(dataService: data, storageService: _StockageMemoire());
    repo.profile
      ..rangAnnonce = null
      ..jeuxAnnonces = null
      ..completedLessons.addAll([for (final w in data.worlds.take(5)) ...w.lessons.map((l) => l.id)]);
    final annonce = repo.deblocagesAAnnoncer();
    expect(annonce.rang, isNull);
    expect(annonce.jeux, isEmpty);
    expect(repo.profile.jeuxAnnonces, containsAll(['duel', 'taverne']));
  });
}
