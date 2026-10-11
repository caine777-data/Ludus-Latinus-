import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/ui/core/cinematic_player.dart';
import 'package:ludus_latinus_mobile/ui/features/settings/about_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> monter(WidgetTester tester, ThemeData theme) async {
  PackageInfo.setMockInitialValues(
    appName: 'Ludus Latinus',
    packageName: 'com.luduslatinus.app',
    version: '1.2.3',
    buildNumber: '57',
    buildSignature: '',
  );
  await tester.pumpWidget(MaterialApp(theme: theme, home: const AboutScreen()));
  await tester.pumpAndSettle();
}

List<String> images(WidgetTester tester) => tester
    .widgetList<Image>(find.byType(Image))
    .map((i) => i.image)
    .whereType<AssetImage>()
    .map((a) => a.assetName)
    .toList();

void main() {
  testWidgets('À propos : éditeur, version du paquet, aucune donnée personnelle', (tester) async {
    await monter(tester, ThemeData.light());
    expect(find.text('Ludus Latinus'), findsOneWidget);
    expect(find.text('Version 1.2.3 (57)'), findsOneWidget);
    expect(find.text('Édité par Icare & Dédale'), findsOneWidget);
    expect(find.text('© 2026 Icare & Dédale. Tous droits réservés.'), findsOneWidget);
    expect(find.text("Revoir l'animation du studio"), findsOneWidget);
    expect(find.textContaining('@'), findsNothing);
    expect(find.textContaining('github', findRichText: true), findsNothing);
    expect(images(tester), ['assets/images/studio/logo_icare_dedale_clair.png']);
  });

  testWidgets('À propos en thème sombre : logo sur fond bleu nuit', (tester) async {
    await monter(tester, ThemeData.dark());
    expect(images(tester), ['assets/images/studio/logo_icare_dedale_sombre.png']);
  });

  test('La cinématique du studio ne superpose aucun texte', () {
    final c = CinematicConfig.forType(CinematicType.studio);
    expect(c.assetPath, 'assets/cinematics/icare_dedale.mp4');
    expect(c.title, isEmpty);
    expect(c.subtitle, isEmpty);
  });
}
