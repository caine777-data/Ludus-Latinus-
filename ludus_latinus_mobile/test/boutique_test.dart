import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/goodie_item.dart';
import 'package:ludus_latinus_mobile/data/models/profile.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';

void main() {
  group('Boutique & Goodies Tests', () {
    test('Catalogue Boutique complet et cohérent', () {
      expect(kCatalogueBoutique.length, greaterThanOrEqualTo(16));

      // Vérifie que toutes les catégories sont présentes
      for (final cat in GoodieCategory.values) {
        final items = kCatalogueBoutique.where((i) => i.categorie == cat).toList();
        expect(items, isNotEmpty, reason: 'La catégorie ${cat.name} doit contenir des articles');
      }

      // Vérifie les identifiants uniques
      final ids = kCatalogueBoutique.map((e) => e.id).toSet();
      expect(ids.length, equals(kCatalogueBoutique.length));
    });

    test('UserProfile sérialise et désérialise les goodies avec succès', () {
      final profile = UserProfile(
        id: 'test_user',
        nomHeros: 'Titus',
        sesterces: 150,
        equippedGoodies: {
          'toge': 'praetexta',
          'couronne': 'laurier_or',
          'accessoire': 'gladius',
          'compagnon': 'lupulus_jr',
        },
        ownedGoodies: ['lin_blanc', 'praetexta', 'laurier_or', 'gladius', 'lupulus_jr'],
      );

      final jsonMap = profile.toJson();
      expect(jsonMap['equipped_goodies']['toge'], equals('praetexta'));
      expect(jsonMap['equipped_goodies']['compagnon'], equals('lupulus_jr'));
      expect((jsonMap['owned_goodies'] as List).contains('gladius'), isTrue);

      final reloaded = UserProfile.fromJson(jsonMap);
      expect(reloaded.getEquippedGoodie('toge'), equals('praetexta'));
      expect(reloaded.getEquippedGoodie('couronne'), equals('laurier_or'));
      expect(reloaded.isGoodieOwned('gladius'), isTrue);
      expect(reloaded.isGoodieOwned('scutum'), isFalse);
    });

    test('Achat d\'un goodie avec sesterces suffisants', () {
      final storage = StorageService();
      final data = DataService();
      final repo = GameRepository(dataService: data, storageService: storage);

      repo.profile.sesterces = 100;
      repo.profile.ownedGoodies = ['lin_blanc', 'aucune', 'stylet', 'aucun'];

      final item = kCatalogueBoutique.firstWhere((i) => i.id == 'praetexta'); // prix: 35
      final success = repo.buyGoodie(item);

      expect(success, isTrue);
      expect(repo.profile.sesterces, equals(65));
      expect(repo.isGoodieOwned('praetexta'), isTrue);
      expect(repo.isGoodieEquipped(GoodieCategory.toge, 'praetexta'), isTrue);
    });

    test('Refus d\'achat si sesterces insuffisants', () {
      final storage = StorageService();
      final data = DataService();
      final repo = GameRepository(dataService: data, storageService: storage);

      repo.profile.sesterces = 10;
      repo.profile.ownedGoodies = ['lin_blanc', 'aucune', 'stylet', 'aucun'];

      final item = kCatalogueBoutique.firstWhere((i) => i.id == 'fasces'); // prix: 130
      final success = repo.buyGoodie(item);

      expect(success, isFalse);
      expect(repo.profile.sesterces, equals(10));
      expect(repo.isGoodieOwned('fasces'), isFalse);
    });

    test('Équipement d\'un objet déjà possédé', () {
      final storage = StorageService();
      final data = DataService();
      final repo = GameRepository(dataService: data, storageService: storage);

      repo.profile.ownedGoodies = ['lin_blanc', 'praetexta'];
      repo.equipGoodie(GoodieCategory.toge, 'praetexta');

      expect(repo.getEquippedGoodie(GoodieCategory.toge), equals('praetexta'));
    });
  });
}
