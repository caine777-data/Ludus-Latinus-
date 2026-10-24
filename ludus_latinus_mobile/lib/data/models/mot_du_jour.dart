import 'thesaurus_entry.dart';
import 'vocab_question.dart';

/// Mot du jour : un mot latin de 4 à 6 lettres à trouver en six essais, à la
/// façon de Wordle. Le mot est propre à chaque élève : il est tiré des mondes
/// qu'il a atteints, pour réviser. Logique pure, testée sans écran.

enum EtatLettre { absente, malPlacee, bienPlacee }

class MotDuJour {
  static const int essaisMax = 6;
  static const int longueurMin = 4;
  static const int longueurMax = 6;

  /// Essai ratés après lesquels l'indice (mots français dérivés) apparaît.
  static const int essaisAvantIndice = 3;

  /// Derniers mots proposés, retenus pour ne pas les redonner trop tôt.
  static const int memoireMots = 60;

  /// Forme à deviner, en capitales : « amicus, -i » → « AMICUS ».
  static String forme(ThesaurusEntry e) => VocabQuestion.shortLatin(e).toUpperCase();

  /// Mots jouables : noms, verbes, adjectifs des [mondes] atteints, en lettres
  /// simples (pas de « salve / salvete »), de 4 à 6 lettres, sans doublon.
  static List<ThesaurusEntry> candidats(List<ThesaurusEntry> dico, Set<String> mondes) {
    final vus = <String>{};
    return [
      for (final e in dico)
        if (e.cat != 'Devise' &&
            mondes.contains(e.monde) &&
            RegExp(r'^[A-Z]{4,6}$').hasMatch(forme(e)) &&
            vus.add(forme(e)))
          e,
    ];
  }

  /// Choisit le mot du jour parmi [candidats], en évitant les [dejaVus] tant
  /// qu'il reste d'autres mots. Le choix dépend de la date pour être stable si
  /// l'écran est rouvert avant que le mot soit enregistré.
  static ThesaurusEntry? choisir(List<ThesaurusEntry> candidats, DateTime jour, List<String> dejaVus) {
    if (candidats.isEmpty) return null;
    final neufs = candidats.where((e) => !dejaVus.contains(forme(e))).toList();
    final liste = neufs.isEmpty ? candidats : neufs;
    final numeroDuJour = DateTime.utc(jour.year, jour.month, jour.day).millisecondsSinceEpoch ~/ 86400000;
    return liste[(numeroDuJour * 7919) % liste.length];
  }

  /// Couleur de chaque lettre de [essai] face à [cible], règle de Wordle : les
  /// lettres bien placées d'abord, puis les mal placées dans la limite du
  /// nombre de fois où la lettre reste dans la cible (AMARE contre AMICUS :
  /// le second A est absent).
  static List<EtatLettre> evaluer(String essai, String cible) {
    final etats = List.filled(essai.length, EtatLettre.absente);
    final restantes = <String, int>{};
    for (var i = 0; i < cible.length; i++) {
      if (i < essai.length && essai[i] == cible[i]) {
        etats[i] = EtatLettre.bienPlacee;
      } else {
        restantes[cible[i]] = (restantes[cible[i]] ?? 0) + 1;
      }
    }
    for (var i = 0; i < essai.length; i++) {
      if (etats[i] == EtatLettre.bienPlacee) continue;
      final n = restantes[essai[i]] ?? 0;
      if (n > 0) {
        etats[i] = EtatLettre.malPlacee;
        restantes[essai[i]] = n - 1;
      }
    }
    return etats;
  }

  /// Indice : les mots français dérivés, sans ceux qui donnent la réponse
  /// telle quelle (« atrium » pour ATRIUM).
  /// Sans dérivé utilisable, la traduction sert d'indice.
  static String indice(ThesaurusEntry e) {
    final cible = forme(e).toLowerCase();
    final derives = e.etym
        .split(',')
        .map((m) => m.trim())
        .where((m) => m.isNotEmpty && m.toLowerCase() != cible)
        .toList();
    return derives.isEmpty ? VocabQuestion.shortFrench(e) : derives.join(', ');
  }

  /// Meilleur état connu de chaque lettre, pour colorer le clavier.
  static Map<String, EtatLettre> etatsDuClavier(List<String> essais, String cible) {
    final etats = <String, EtatLettre>{};
    for (final essai in essais) {
      final couleurs = evaluer(essai, cible);
      for (var i = 0; i < essai.length; i++) {
        final avant = etats[essai[i]];
        if (avant == null || couleurs[i].index > avant.index) etats[essai[i]] = couleurs[i];
      }
    }
    return etats;
  }
}
