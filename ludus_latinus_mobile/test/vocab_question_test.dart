import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/thesaurus_entry.dart';
import 'package:ludus_latinus_mobile/data/models/vocab_question.dart';

void main() {
  final data = json.decode(File('assets/data/ludus_latinus_dataset.json').readAsStringSync()) as Map<String, dynamic>;
  final dico = ((data['thesaurus'] as Map<String, dynamic>)['dictionnaire'] as List)
      .map((e) => ThesaurusEntry.fromJson(e as Map<String, dynamic>))
      .toList();
  final mondes = (data['mondes'] as List).cast<Map<String, dynamic>>();

  test('Le Thesaurus exporté contient le vocabulaire complémentaire', () {
    expect(dico.length, greaterThanOrEqualTo(160));
    expect(dico.any((e) => e.latin.startsWith('filius')), isTrue);
  });

  // Texte cumulé de toutes les leçons jusqu'au monde donné (inclus).
  String knownUpTo(String worldId) {
    final b = StringBuffer();
    for (final m in mondes) {
      b.write(' ${json.encode(m['lessons'])}');
      if (m['id'] == worldId) break;
    }
    return b.toString();
  }

  test('Chaque monde fournit des questions (mots du monde ou révision)', () {
    final sansQuestion = <String>[];
    for (final m in mondes) {
      final id = m['id'] as String;
      final qs = VocabQuestion.forLesson(dictionary: dico, worldId: id, lessonText: '', knownText: knownUpTo(id), random: math.Random(1));
      if (qs.length < 2) sansQuestion.add(id);
    }
    expect(sansQuestion, isEmpty);
  });

  test('On n\'interroge jamais un mot pas encore vu', () {
    final qs = VocabQuestion.forLesson(dictionary: dico, worldId: 'monde1', lessonText: 'Salve !', knownText: 'Salve ! Roma magna est.', count: 5, random: math.Random(2));
    for (final q in qs) {
      expect(['salve', 'roma'], contains(VocabQuestion.shortLatin(q.entry).split('/').first.trim().toLowerCase()));
    }
  });

  test('Une question a 3 ou 4 choix distincts dont la bonne réponse', () {
    for (final m in mondes) {
      final id = m['id'] as String;
      for (final q in VocabQuestion.forLesson(dictionary: dico, worldId: id, lessonText: '', knownText: knownUpTo(id), random: math.Random(7))) {
        expect(q.options.length, inInclusiveRange(3, 4));
        expect(q.options.toSet().length, q.options.length, reason: q.prompt);
        expect(q.answer, inInclusiveRange(0, q.options.length - 1));
      }
    }
  });

  test('Les mots cités dans la leçon sont interrogés en priorité', () {
    final qs = VocabQuestion.forLesson(
      dictionary: dico,
      worldId: 'monde2',
      lessonText: 'Pater et filius in horto ambulant.',
      knownText: 'Pater et filius in horto ambulant.',
      count: 2,
      random: math.Random(3),
    );
    final mots = qs.map((q) => VocabQuestion.shortLatin(q.entry)).toSet();
    expect(mots.intersection({'pater', 'filius', 'hortus'}).length, 2);
  });
}
