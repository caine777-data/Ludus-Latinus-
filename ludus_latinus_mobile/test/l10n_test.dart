import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/repositories/game_repository.dart';
import 'package:ludus_latinus_mobile/data/services/data_service.dart';
import 'package:ludus_latinus_mobile/data/services/storage_service.dart';
import 'package:ludus_latinus_mobile/l10n/l10n.dart';
import 'package:ludus_latinus_mobile/main.dart';

void main() {
  test('app_fr.arb : aucune valeur vide', () {
    final arb = jsonDecode(File('lib/l10n/app_fr.arb').readAsStringSync()) as Map<String, dynamic>;
    final textes = arb.entries.where((e) => !e.key.startsWith('@'));
    expect(textes, isNotEmpty);
    for (final e in textes) {
      expect(e.value, isA<String>(), reason: 'la clé ${e.key} doit être un texte');
      expect((e.value as String).trim(), isNotEmpty, reason: 'la clé ${e.key} est vide');
    }
  });

  testWidgets('L\'appli démarre avec la locale fr', (tester) async {
    tester.view.physicalSize = const Size(1080, 3000);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);
    final repo = GameRepository(dataService: DataService(), storageService: StorageService());
    await tester.pumpWidget(LudusLatinusApp(repository: repo));
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.locale, const Locale('fr'));
    expect(app.supportedLocales, [const Locale('fr')]);
    final context = tester.element(find.byType(Scaffold).first);
    expect(Localizations.localeOf(context), const Locale('fr'));
    expect(context.l10n.settingsTitle, 'PARAMÈTRES');
    await tester.pump(const Duration(seconds: 1));
  });
}
