import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/data/models/thesaurus_entry.dart';
import 'package:ludus_latinus_mobile/data/models/vocab_question.dart';
import 'package:ludus_latinus_mobile/ui/features/circus/circus_deck.dart';

List<Map<String, dynamic>> _qs(String p, int n) =>
    [for (var i = 0; i < n; i++) {'q': '$p$i', 'rep': 'a', 'fausses': <String>['b', 'c', 'd'], 'explication': ''}];

void main() {
  test('deux tiers des mondes, un tiers du cirque, bloc par bloc', () {
    final deck = CircusDeck(mondes: _qs('m', 40), cirque: _qs('c', 46), random: math.Random(1));
    final tirage = [for (var i = 0; i < 3000; i++) (deck.suivante()['q'] as String)[0]];
    expect(tirage.where((c) => c == 'm').length, 2000);
    for (var i = 0; i < tirage.length; i += 3) {
      expect(tirage.sublist(i, i + 3).where((c) => c == 'm').length, 2);
    }
  });

  test('pas de doublon dans la fenêtre récente', () {
    final deck = CircusDeck(mondes: _qs('m', 20), cirque: _qs('c', 46), random: math.Random(2));
    final vus = <String>[];
    for (var i = 0; i < 1000; i++) {
      final q = deck.suivante()['q'] as String;
      expect(vus.reversed.take(8).contains(q), isFalse);
      vus.add(q);
    }
  });

  test('repli : peu de questions des mondes, complété par le cirque sans boucle', () {
    final deck = CircusDeck(mondes: _qs('m', 3), cirque: _qs('c', 46), random: math.Random(3));
    final tirage = [for (var i = 0; i < 600; i++) deck.suivante()['q'] as String];
    for (var i = 8; i < tirage.length; i++) {
      expect(tirage.sublist(i - 8, i).contains(tirage[i]), isFalse);
    }
    expect(tirage.where((q) => q.startsWith('c')).length, greaterThan(200));
    expect(tirage.toSet().length, greaterThan(40));
  });

  test('aucune question des mondes : tout vient du cirque', () {
    final deck = CircusDeck(mondes: [], cirque: _qs('c', 10), random: math.Random(4));
    for (var i = 0; i < 50; i++) {
      expect((deck.suivante()['q'] as String).startsWith('c'), isTrue);
    }
  });

  test('une seule question au total : ne plante pas', () {
    final deck = CircusDeck(mondes: [], cirque: _qs('c', 1), random: math.Random(5));
    expect(deck.suivante()['q'], 'c0');
    expect(deck.suivante()['q'], 'c0');
  });

  test('données réelles, monde 1 seul : la course reste variée et sans répétition proche', () {
    final data = json.decode(File('assets/data/ludus_latinus_dataset.json').readAsStringSync()) as Map<String, dynamic>;
    final dico = ((data['thesaurus'] as Map<String, dynamic>)['dictionnaire'] as List)
        .map((e) => ThesaurusEntry.fromJson(e as Map<String, dynamic>))
        .toList();
    final monde1 = ((data['mondes'] as List).first as Map<String, dynamic>)['id'] as String;
    final mondes = VocabQuestion.pourJeu(dictionary: dico, mondes: {monde1}, count: 60, random: math.Random(7));
    final deck = CircusDeck(mondes: mondes, cirque: _qs('c', 46), random: math.Random(7));
    final tirage = [for (var i = 0; i < 300; i++) deck.suivante()['q'] as String];
    for (var i = 8; i < tirage.length; i++) {
      expect(tirage.sublist(i - 8, i).contains(tirage[i]), isFalse);
    }
    // ignore: avoid_print
    print('monde 1 : ${mondes.length} questions distinctes sur 60 demandées');
  });
}
