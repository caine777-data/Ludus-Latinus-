import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/ui/features/thesaurus/thesaurus_screen.dart';

void main() {
  testWidgets('Le Thesaurus a un onglet Glossaire, trié, lu depuis les données', (tester) async {
    final data = DataService();
    await tester.runAsync(data.loadDataset);
    expect(data.glossaire.length, greaterThanOrEqualTo(20));

    final repo = GameRepository(dataService: data, storageService: StorageService());
    await tester.pumpWidget(MaterialApp(home: ThesaurusScreen(repo: repo)));
    await tester.tap(find.text('Glossaire'));
    await tester.pumpAndSettle();

    // Le premier terme par ordre alphabétique est affiché avec sa définition.
    final tries = [...data.glossaire]..sort((a, b) => a[0].toLowerCase().compareTo(b[0].toLowerCase()));
    expect(find.text(tries.first[0]), findsOneWidget);
    expect(find.text(tries.first[1]), findsOneWidget);
  });
}
