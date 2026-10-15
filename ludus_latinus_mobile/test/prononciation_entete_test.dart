import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/services/latin_phonetics_engine.dart';

void main() {
  test('Entrée de dictionnaire : un seul mot, sans virgule ni terminaison', () {
    final r = LatinPhoneticsEngine.analyze('amica, -ae');
    expect(r.words.map((w) => w.latin).toList(), ['amica']);
  });

  test('Phrase : la ponctuation de bord disparaît, les mots restent', () {
    final r = LatinPhoneticsEngine.analyze('Salve, amice !');
    expect(r.words.map((w) => w.latin).toList(), ['Salve', 'amice']);
  });
}
