// Depuis Android 15, l'appli s'affiche sous la barre de navigation du
// téléphone : ColonneLecture(protegerBas: true) doit garder le contenu
// au-dessus (boutons de Memoria, de la Bataille, du Forum...).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/ui/core/widgets.dart';

const _barreTelephone = 48.0;

Widget _ecran({required bool protegerBas}) => MaterialApp(
      // MaterialApp recrée son MediaQuery à partir de la vue : la barre simulée
      // doit donc être posée sous lui, sinon elle serait ignorée.
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          size: const Size(400, 800),
          padding: const EdgeInsets.only(bottom: _barreTelephone),
          viewPadding: const EdgeInsets.only(bottom: _barreTelephone),
        ),
        child: child!,
      ),
      home: Scaffold(
        body: ColonneLecture(
          protegerBas: protegerBas,
          child: const Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(key: Key('bouton'), height: 40, width: 100),
          ),
        ),
      ),
    );

void main() {
  setUp(() {
    final vue = TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    vue.physicalSize = const Size(400, 800);
    vue.devicePixelRatio = 1;
  });
  tearDown(() => TestWidgetsFlutterBinding.instance.platformDispatcher.views.first.resetPhysicalSize());

  testWidgets('le bouton du bas reste au-dessus de la barre du téléphone', (tester) async {
    await tester.pumpWidget(_ecran(protegerBas: true));
    final bas = tester.getBottomLeft(find.byKey(const Key('bouton'))).dy;
    expect(bas, lessThanOrEqualTo(800 - _barreTelephone));
  });

  testWidgets('sans protection, la colonne garde son comportement d\'origine', (tester) async {
    await tester.pumpWidget(_ecran(protegerBas: false));
    final bas = tester.getBottomLeft(find.byKey(const Key('bouton'))).dy;
    expect(bas, 800);
  });
}
