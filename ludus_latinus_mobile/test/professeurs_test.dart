import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/ui/features/settings/professeurs_screen.dart';

// Programme de LCA : chaque monde porte sa ligne « Au programme », et la page
// des professeurs les liste toutes avec les écarts assumés.
void main() {
  final data = DataService();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await data.loadDataset();
  });

  test('Les 26 mondes ont leur ligne « Au programme »', () {
    expect(data.worlds.length, 26);
    for (final w in data.worlds) {
      expect(w.programme?.langue, isNotEmpty, reason: w.id);
      expect(w.programme?.culture, isNotEmpty, reason: w.id);
    }
    expect(data.programmeLca?.ecarts.length, 4);
  });

  testWidgets('La page des professeurs liste les mondes, les écarts et le contact', (tester) async {
    tester.view.physicalSize = const Size(800, 40000);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);
    final repo = GameRepository(dataService: data, storageService: StorageService());
    await tester.pumpWidget(MaterialApp(home: ProfesseursScreen(repo: repo)));
    await tester.pump();
    expect(find.textContaining('Langue : '), findsNWidgets(26));
    expect(find.text(data.programmeLca!.contact), findsOneWidget);
    expect(find.textContaining('monde 9'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
