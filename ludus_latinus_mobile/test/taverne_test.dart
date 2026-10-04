import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/ui/features/taverne/taverne_screen.dart';

void main() {
  test('Les totaux de quatre dés s\'écrivent en chiffres romains', () {
    const attendus = {4: 'IV', 9: 'IX', 14: 'XIV', 19: 'XIX', 24: 'XXIV', 6: 'VI', 20: 'XX'};
    attendus.forEach((n, r) => expect(chiffreRomain(n), r));
  });
}
