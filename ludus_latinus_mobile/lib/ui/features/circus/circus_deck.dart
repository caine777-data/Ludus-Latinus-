import 'dart:math' as math;

/// Pioche de questions du Circus : deux tiers viennent des mondes atteints par
/// l'élève (vocabulaire et notions des leçons), un tiers du cirque.
///
/// Règle de tirage : les questions sont servies par blocs de trois, avec deux
/// places "mondes" et une place "cirque" dans un ordre mélangé. La proportion
/// est donc tenue à chaque bloc, pas seulement sur l'ensemble de la course.
/// Une question n'est jamais redonnée tant qu'elle figure parmi les
/// [memoire] dernières posées. Si la source voulue n'a plus rien d'éligible
/// (peu de mondes atteints, donc peu de questions distinctes), on complète
/// avec l'autre source plutôt que de répéter.
class CircusDeck {
  CircusDeck({
    required List<Map<String, dynamic>> mondes,
    required List<Map<String, dynamic>> cirque,
    math.Random? random,
    this.memoire = 8,
  })  : assert(cirque.isNotEmpty || mondes.isNotEmpty),
        _rnd = random ?? math.Random(),
        _poolMondes = _distinctes(mondes),
        _poolCirque = _distinctes(cirque);

  final int memoire;
  final math.Random _rnd;
  final List<Map<String, dynamic>> _poolMondes;
  final List<Map<String, dynamic>> _poolCirque;
  final List<Map<String, dynamic>> _pileMondes = [];
  final List<Map<String, dynamic>> _pileCirque = [];
  final List<String> _recentes = [];
  final List<bool> _bloc = []; // true = place "mondes"

  static List<Map<String, dynamic>> _distinctes(List<Map<String, dynamic>> l) {
    final vus = <String>{};
    return [for (final q in l) if (vus.add(q['q'] as String)) q];
  }

  /// Nombre de questions distinctes disponibles au total.
  int get taille => _poolMondes.length + _poolCirque.length;

  Map<String, dynamic> suivante() {
    if (_bloc.isEmpty) {
      _bloc
        ..addAll([true, true, false])
        ..shuffle(_rnd);
    }
    final voulueMondes = _bloc.removeAt(0);
    final q = (voulueMondes ? _tirer(true) ?? _tirer(false) : _tirer(false) ?? _tirer(true)) ?? _secours();
    _recentes.add(q['q'] as String);
    final fenetre = math.max(0, math.min(memoire, taille - 1));
    while (_recentes.length > fenetre) {
      _recentes.removeAt(0);
    }
    return q;
  }

  /// Prend la première question éligible de la pile (qu'on remplit au besoin).
  Map<String, dynamic>? _tirer(bool mondes) {
    final pool = mondes ? _poolMondes : _poolCirque;
    final pile = mondes ? _pileMondes : _pileCirque;
    if (pool.isEmpty) return null;
    for (var essai = 0; essai < 2; essai++) {
      final i = pile.indexWhere((q) => !_recentes.contains(q['q']));
      if (i >= 0) return pile.removeAt(i);
      // Pile vide ou entièrement récente : on la reconstitue, mélangée.
      pile
        ..clear()
        ..addAll(pool)
        ..shuffle(_rnd);
    }
    return null;
  }

  /// Dernier recours (une seule question distincte au total) : on rejoue.
  Map<String, dynamic> _secours() {
    final pool = _poolCirque.isNotEmpty ? _poolCirque : _poolMondes;
    return pool[_rnd.nextInt(pool.length)];
  }
}
