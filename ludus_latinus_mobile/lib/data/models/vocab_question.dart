import 'dart:math' as math;
import 'thesaurus_entry.dart';

/// Question de vocabulaire tirée du Thesaurus, posée après l'exercice principal d'une leçon.
class VocabQuestion {
  final String prompt;
  final List<String> options;
  final int answer;
  final ThesaurusEntry entry;

  const VocabQuestion({
    required this.prompt,
    required this.options,
    required this.answer,
    required this.entry,
  });

  /// Forme courte du mot latin, sans génitif ni temps primitifs : « aqua, -ae » → « aqua ».
  static String shortLatin(ThesaurusEntry e) {
    if (e.cat == 'Devise') return e.latin;
    return e.latin.split('(').first.split(',').first.trim();
  }

  /// Traduction courte, sans précision entre parenthèses.
  static String shortFrench(ThesaurusEntry e) => e.fr.split('(').first.trim();

  /// Vrai si le mot apparaît en entier dans le texte (« ire » ne compte pas dans « écrire »).
  static bool _appearsIn(ThesaurusEntry e, String lowerText) {
    final forms = shortLatin(e).toLowerCase().split('/').map((f) => f.trim()).where((f) => f.length >= 2);
    return forms.any((f) => RegExp('(?<![a-zà-ÿ])${RegExp.escape(f)}(?![a-zà-ÿ])').hasMatch(lowerText));
  }

  /// Fabrique jusqu'à [count] questions pour une leçon, uniquement sur des mots
  /// déjà rencontrés ([knownText] : cette leçon et les précédentes).
  /// Priorité : mots de la leçon, puis du monde, puis révision des mondes passés.
  /// Les mauvaises réponses viennent de la même catégorie (noms avec noms…).
  static List<VocabQuestion> forLesson({
    required List<ThesaurusEntry> dictionary,
    required String worldId,
    required String lessonText,
    String? knownText,
    int count = 3,
    math.Random? random,
  }) {
    final rnd = random ?? math.Random();
    final text = lessonText.toLowerCase();
    final known = (knownText ?? lessonText).toLowerCase();
    final usable = dictionary.where((e) => e.cat != 'Devise' && e.monde.isNotEmpty).toList();

    final inLesson = usable.where((e) => e.monde == worldId && _appearsIn(e, text)).toList()..shuffle(rnd);
    final inWorld = usable.where((e) => e.monde == worldId && !inLesson.contains(e) && _appearsIn(e, known)).toList()..shuffle(rnd);
    final review = usable.where((e) => e.monde != worldId && _appearsIn(e, known)).toList()..shuffle(rnd);
    final chosen = [...inLesson, ...inWorld, ...review].take(count).toList();
    if (chosen.isEmpty) return [];

    final questions = <VocabQuestion>[];
    for (var i = 0; i < chosen.length; i++) {
      final e = chosen[i];
      final pool = dictionary.where((d) => d != e && d.cat == e.cat && d.cat != 'Devise').toList()..shuffle(rnd);
      // On alterne le sens : latin → français, puis français → latin.
      final latinToFrench = i.isEven;
      final right = latinToFrench ? shortFrench(e) : shortLatin(e);
      final wrong = <String>[];
      for (final d in pool) {
        final v = latinToFrench ? shortFrench(d) : shortLatin(d);
        if (v.toLowerCase() != right.toLowerCase() && !wrong.contains(v)) wrong.add(v);
        if (wrong.length == 3) break;
      }
      if (wrong.length < 2) continue;
      final options = [right, ...wrong]..shuffle(rnd);
      questions.add(VocabQuestion(
        prompt: latinToFrench
            ? 'Que signifie « ${shortLatin(e)} » ?'
            : 'Comment dit-on « ${shortFrench(e)} » en latin ?',
        options: options,
        answer: options.indexOf(right),
        entry: e,
      ));
    }
    return questions;
  }

  /// Questions de vocabulaire pour les mini-jeux (Duel, Circus), au format de
  /// leurs questions fixes : `q`, `rep`, `fausses`, `explication`.
  /// Seuls les mots des [mondes] déjà atteints sont interrogés ; les mauvaises
  /// réponses viennent de la même catégorie, de préférence parmi ces mondes.
  static List<Map<String, dynamic>> pourJeu({
    required List<ThesaurusEntry> dictionary,
    required Set<String> mondes,
    int count = 16,
    math.Random? random,
  }) {
    final rnd = random ?? math.Random();
    final vus = <String>{};
    final connus = dictionary
        .where((e) => e.cat != 'Devise' && mondes.contains(e.monde) && vus.add(e.latin))
        .toList()
      ..shuffle(rnd);

    final questions = <Map<String, dynamic>>[];
    for (final e in connus) {
      if (questions.length >= count) break;
      final latinVersFrancais = questions.length.isEven;
      final bonne = latinVersFrancais ? shortFrench(e) : shortLatin(e);
      final memeCategorie = dictionary.where((d) => d != e && d.cat == e.cat && d.cat != 'Devise').toList()
        ..shuffle(rnd);
      // Les mots déjà rencontrés d'abord : un piège inconnu se repère trop bien.
      final pieges = [
        ...memeCategorie.where((d) => mondes.contains(d.monde)),
        ...memeCategorie.where((d) => !mondes.contains(d.monde)),
      ];
      final fausses = <String>[];
      for (final d in pieges) {
        final v = latinVersFrancais ? shortFrench(d) : shortLatin(d);
        if (v.toLowerCase() != bonne.toLowerCase() && !fausses.contains(v)) fausses.add(v);
        if (fausses.length == 3) break;
      }
      if (fausses.length < 3) continue;
      questions.add({
        'q': latinVersFrancais
            ? 'Que signifie « ${shortLatin(e)} » ?'
            : 'Comment dit-on « ${shortFrench(e)} » en latin ?',
        'rep': bonne,
        'fausses': fausses,
        'explication': e.ex.isEmpty
            ? '${e.latin} : ${e.fr}.'
            : '${e.latin} : ${e.fr}. ${e.ex} (${e.exFr})',
      });
    }
    return questions;
  }
}
