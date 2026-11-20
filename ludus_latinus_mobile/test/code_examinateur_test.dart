// Code examinateur : saisie cachée dans l'écran À propos (7 appuis sur la
// ligne Version). Le vrai code n'est jamais dans le dépôt : les tests
// vérifient les refus, et le parcours d'écran passe par un double qui
// accepte un code de test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/services/achat_service.dart';
import 'package:ludus_latinus_mobile/data/services/code_examinateur.dart';
import 'package:ludus_latinus_mobile/l10n/app_localizations.dart';
import 'package:ludus_latinus_mobile/ui/features/settings/about_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Achat payant non ouvert, qui accepte « BON » comme code examinateur.
class _AchatAvecCodeDeTest extends AchatSimule {
  final List<String> codesRecus = [];

  @override
  Future<bool> ouvrirAvecCode(String code) async {
    codesRecus.add(code);
    if (code != 'BON') return false;
    await acheter();
    return true;
  }
}

Future<void> monter(WidgetTester tester, AchatService? achats) async {
  PackageInfo.setMockInitialValues(
    appName: 'Ludus Latinus',
    packageName: 'fr.icareetdedale.luduslatinus',
    version: '1.0.1',
    buildNumber: '108',
    buildSignature: '',
  );
  await tester.pumpWidget(MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: AboutScreen(achats: achats),
  ));
  await tester.pumpAndSettle();
}

Future<void> appuyerSurVersion(WidgetTester tester, int fois) async {
  for (var i = 0; i < fois; i++) {
    await tester.tap(find.text('Version 1.0.1 (108)'));
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.pumpAndSettle();
}

void main() {
  test('les codes faux ou vides sont refusés', () {
    expect(codeExaminateurValide(''), isFalse);
    expect(codeExaminateurValide('   '), isFalse);
    expect(codeExaminateurValide('ABCDEFGHJK'), isFalse);
    expect(codeExaminateurValide('edition_complete'), isFalse);
  });

  test('l\'édition offerte et l\'achat simulé ignorent un mauvais code', () async {
    expect(await AchatOffert().ouvrirAvecCode('ABCDEFGHJK'), isFalse);
    final simule = AchatSimule();
    expect(await simule.ouvrirAvecCode('ABCDEFGHJK'), isFalse);
    expect(simule.editionComplete, isFalse);
  });

  testWidgets('6 appuis ne suffisent pas, le 7e ouvre la saisie', (tester) async {
    await monter(tester, _AchatAvecCodeDeTest());
    await appuyerSurVersion(tester, 6);
    expect(find.byType(AlertDialog), findsNothing);
    await appuyerSurVersion(tester, 1);
    expect(find.text('Code d\'accès'), findsOneWidget);
  });

  testWidgets('appuis trop espacés : la saisie ne s\'ouvre pas', (tester) async {
    await monter(tester, _AchatAvecCodeDeTest());
    for (var i = 0; i < 7; i++) {
      await tester.tap(find.text('Version 1.0.1 (108)'));
      await tester.pump(const Duration(seconds: 1));
    }
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('bon code : édition ouverte et message ; mauvais code : rien', (tester) async {
    final achats = _AchatAvecCodeDeTest();
    await monter(tester, achats);

    await appuyerSurVersion(tester, 7);
    await tester.enterText(find.byType(TextField), 'FAUX');
    await tester.tap(find.text('Valider'));
    await tester.pumpAndSettle();
    expect(achats.editionComplete, isFalse);
    expect(find.byType(SnackBar), findsNothing);

    await appuyerSurVersion(tester, 7);
    await tester.enterText(find.byType(TextField), 'BON');
    await tester.tap(find.text('Valider'));
    await tester.pumpAndSettle();
    expect(achats.codesRecus, ['FAUX', 'BON']);
    expect(achats.editionComplete, isTrue);
    expect(find.text('Édition complète ouverte.'), findsOneWidget);
  });

  testWidgets('édition offerte ou écran sans achats : la ligne Version reste inerte', (tester) async {
    await monter(tester, AchatOffert());
    await appuyerSurVersion(tester, 7);
    expect(find.byType(AlertDialog), findsNothing);

    await monter(tester, null);
    await appuyerSurVersion(tester, 7);
    expect(find.byType(AlertDialog), findsNothing);
  });
}
