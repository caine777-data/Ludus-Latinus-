import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/services/latin_phonetics_engine.dart';

void main() {
  group('LatinPhoneticsEngine Unit Tests', () {
    test('Analyse de mots fondamentaux (Caesar, Cicero, Roma)', () {
      final caesar = LatinPhoneticsEngine.analyze('Caesar');
      expect(caesar.words.length, 1);
      final wCaesar = caesar.words.first;
      expect(wCaesar.syllables, ['Cae', 'sar']);
      expect(wCaesar.tonicSyllableIndex, 0);
      expect(wCaesar.ipaRestituee, contains('kae̯.sar'));
      expect(wCaesar.ipaEcclesiastique, contains('tʃe.zar'));

      final cicero = LatinPhoneticsEngine.analyze('Cicero');
      expect(cicero.words.length, 1);
      final wCicero = cicero.words.first;
      expect(wCicero.syllables, ['Ci', 'ce', 'ro']);
      expect(wCicero.tonicSyllableIndex, 0); // Accent sur la première car pénultième brève
      expect(wCicero.ipaRestituee, contains('k'));
      expect(wCicero.ipaEcclesiastique, contains('tʃi.tʃe.ro'));

      final roma = LatinPhoneticsEngine.analyze('Roma');
      expect(roma.words.length, 1);
      final wRoma = roma.words.first;
      expect(wRoma.syllables, ['Ro', 'ma']);
      expect(wRoma.tonicSyllableIndex, 0);
    });

    test('Loi de la Pénultième pour mots réguliers', () {
      // Magister : syllabe pénultième « gis » est longue par position (suivie de s et t) -> accent sur penult (index 1)
      final magister = LatinPhoneticsEngine.analyze('Magister');
      final wMag = magister.words.first;
      expect(wMag.syllables, ['Ma', 'gis', 'ter']);
      expect(wMag.tonicSyllableIndex, 1);

      // Discipulus : syllabe pénultième « pu » est brève -> accent recule sur antépénultième (index 1)
      final discipulus = LatinPhoneticsEngine.analyze('Discipulus');
      final wDisc = discipulus.words.first;
      expect(wDisc.syllables, ['Dis', 'ci', 'pu', 'lus']);
      expect(wDisc.tonicSyllableIndex, 1);
    });

    test('Analyse d\'une locution latine complète (Veni vidi vici)', () {
      final res = LatinPhoneticsEngine.analyze('Veni vidi vici');
      expect(res.words.length, 3);
      expect(res.generalAdvice.isNotEmpty, isTrue);
      // En classique restitué, le V devient [w]
      expect(res.fullIpaRestituee, contains('w'));
      // En ecclésiastique, le V reste [v] et le C devient [tʃ] devant i
      expect(res.fullIpaEcclesiastique, contains('tʃ'));
    });

    test('Gestion des entrées vides ou avec ponctuation', () {
      final empty = LatinPhoneticsEngine.analyze('   ');
      expect(empty.words, isEmpty);

      final withPunct = LatinPhoneticsEngine.analyze('Alea iacta est !');
      expect(withPunct.words.length, 3);
    });
  });
}
