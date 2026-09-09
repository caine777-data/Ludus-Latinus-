/// Entrée de dictionnaire pour le Thesaurus Linguae Latinae.
class ThesaurusEntry {
  final String latin;
  final String cat;
  final String genre;
  final String fr;
  final String etym;
  final String ex;
  final String exFr;

  const ThesaurusEntry({
    required this.latin,
    required this.cat,
    required this.genre,
    required this.fr,
    required this.etym,
    required this.ex,
    required this.exFr,
  });

  factory ThesaurusEntry.fromJson(Map<String, dynamic> json) {
    return ThesaurusEntry(
      latin: json['latin'] as String? ?? '',
      cat: json['cat'] as String? ?? 'Nom',
      genre: json['genre'] as String? ?? '',
      fr: json['fr'] as String? ?? '',
      etym: json['etym'] as String? ?? '',
      ex: json['ex'] as String? ?? '',
      exFr: json['ex_fr'] as String? ?? '',
    );
  }
}
