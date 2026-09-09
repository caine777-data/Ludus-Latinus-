/// Moteur phonétique latin certifié pour Ludus Latinus.
/// Gère la transcription en Alphabet Phonétique International (API),
/// le découpage syllabique et l'accentuation tonique selon la Loi de la Pénultième,
/// pour la prononciation classique restituée (Cicéron) et ecclésiastique.
class LatinPhoneticsEngine {
  static const Set<String> _vowels = {
    'a', 'e', 'i', 'o', 'u', 'y',
    'ā', 'ē', 'ī', 'ō', 'ū',
    'á', 'é', 'í', 'ó', 'ú',
  };

  static const List<String> _diphthongs = ['ae', 'oe', 'au', 'eu', 'ui'];

  /// Lexique de référence pré-annoté pour les locutions célèbres et le vocabulaire fondamental.
  static const Map<String, Map<String, dynamic>> _curatedLexicon = {
    'caesar': {
      'syllables': ['Cae', 'sar'],
      'tonic': 0,
      'ipaRestituee': '[ˈkae̯.sar]',
      'ipaEcclesiastique': '[ˈtʃe.zar]',
      'macrons': 'Caesar',
      'notes': [
        'Le C claque toujours comme un [K] dur en latin classique.',
        'La diphtongue AE se prononce [aɪ] (comme dans l\'anglais « eye »).',
        'Le S final est toujours sourd et sifflant [s], jamais voisé [z].',
      ],
    },
    'cicero': {
      'syllables': ['Ci', 'ce', 'ro'],
      'tonic': 0,
      'ipaRestituee': '[ˈkɪ.kɛ.roː]',
      'ipaEcclesiastique': '[ˈtʃi.tʃe.ro]',
      'macrons': 'Cicerō',
      'notes': [
        'En latin classique restitué, on prononçait « Kikéro », jamais « Sisséro » ni « Tchitchéro » !',
        'L\'avant-dernière syllabe « ce » est brève, donc l\'accent tonique remonte sur la première syllabe (Cí-ce-ro).',
        'Le O final est long.',
      ],
    },
    'roma': {
      'syllables': ['Ro', 'ma'],
      'tonic': 0,
      'ipaRestituee': '[ˈroː.ma]',
      'ipaEcclesiastique': '[ˈro.ma]',
      'macrons': 'Rōma',
      'notes': [
        'Le R latin était roulé avec la pointe de la langue sur le palais.',
        'Le O de Rōma est long, marqué par un macron.',
      ],
    },
    'senatus': {
      'syllables': ['Se', 'na', 'tus'],
      'tonic': 1,
      'ipaRestituee': '[sɛˈnaː.tʊs]',
      'ipaEcclesiastique': '[seˈna.tus]',
      'macrons': 'Senātus',
      'notes': [
        'Nom de la 4e déclinaison : l\'avant-dernière voyelle « a » est longue (Senātus).',
        'L\'accent tonique frappe donc la syllabe pénultième (Se-ná-tus).',
      ],
    },
    'forum': {
      'syllables': ['Fo', 'rum'],
      'tonic': 0,
      'ipaRestituee': '[ˈfɔ.rũː]',
      'ipaEcclesiastique': '[ˈfo.rum]',
      'macrons': 'Forum',
      'notes': [
        'En fin de mot, le M latin classique nasalisait la voyelle qui le précédait.',
      ],
    },
    'magister': {
      'syllables': ['Ma', 'gis', 'ter'],
      'tonic': 1,
      'ipaRestituee': '[maˈɡɪs.tɛr]',
      'ipaEcclesiastique': '[maˈdʒis.ter]',
      'macrons': 'Magister',
      'notes': [
        'La syllabe « gis » est longue par position (suivie de deux consonnes s et t).',
        'L\'accent tonique tombe obligatoirement sur « gis » (Ma-gís-ter).',
        'En latin restitué, le G est toujours dur [ɡ] comme dans « gare ».',
      ],
    },
    'discipulus': {
      'syllables': ['Dis', 'ci', 'pu', 'lus'],
      'tonic': 1,
      'ipaRestituee': '[dɪsˈkɪ.pʊ.lʊs]',
      'ipaEcclesiastique': '[diʃˈʃi.pu.lus]',
      'macrons': 'Discipulus',
      'notes': [
        'L\'avant-dernière syllabe « pu » est brève, donc l\'accent recule sur « ci » (Dis-cí-pu-lus).',
      ],
    },
    'aqua': {
      'syllables': ['A', 'qua'],
      'tonic': 0,
      'ipaRestituee': '[ˈa.kwa]',
      'ipaEcclesiastique': '[ˈa.kwa]',
      'macrons': 'Aqua',
      'notes': [
        'Le groupe « qu » forme une consonne labiovélaire indissociable suivie de la voyelle a.',
      ],
    },
    'lupus': {
      'syllables': ['Lu', 'pus'],
      'tonic': 0,
      'ipaRestituee': '[ˈlʊ.pʊs]',
      'ipaEcclesiastique': '[ˈlu.pus]',
      'macrons': 'Lupus',
      'notes': [
        'Le U bref latin sonne proche du [ou] court.',
      ],
    },
    'gladiator': {
      'syllables': ['Gla', 'di', 'a', 'tor'],
      'tonic': 2,
      'ipaRestituee': '[ɡla.dɪˈaː.tɔr]',
      'ipaEcclesiastique': '[ɡla.diˈa.tor]',
      'macrons': 'Gladiātor',
      'notes': [
        'Le suffixe -ātor a un a long, recevant l\'accent tonique.',
      ],
    },
    'imperium': {
      'syllables': ['Im', 'pe', 'ri', 'um'],
      'tonic': 1,
      'ipaRestituee': '[ɪmˈpɛ.rɪ.ũː]',
      'ipaEcclesiastique': '[imˈpe.ri.um]',
      'macrons': 'Imperium',
      'notes': [
        'La pénultième « ri » est brève, l\'accent tonique recule sur « pe » (Im-pé-ri-um).',
      ],
    },
  };

  /// Analyse phonétique complète d'un mot ou d'une phrase latine.
  static LatinPhoneticResult analyze(String text) {
    final cleanInput = text.trim();
    if (cleanInput.isEmpty) {
      return LatinPhoneticResult.empty();
    }

    final rawWords = cleanInput.split(RegExp(r'\s+'));
    final analyzedWords = <LatinWordPhonetics>[];

    for (final rw in rawWords) {
      final stripped = rw.replaceAll(RegExp(r'[^\w\u0100-\u017F]'), '');
      if (stripped.isEmpty) continue;
      analyzedWords.add(_analyzeSingleWord(stripped, rw));
    }

    final fullIpaRest = analyzedWords.map((w) => w.ipaRestituee.replaceAll('[', '').replaceAll(']', '')).join(' ');
    final fullIpaEccl = analyzedWords.map((w) => w.ipaEcclesiastique.replaceAll('[', '').replaceAll(']', '')).join(' ');

    // Conseils généraux déduits du texte
    final advice = _generateGeneralAdvice(cleanInput);

    return LatinPhoneticResult(
      originalText: cleanInput,
      words: analyzedWords,
      fullIpaRestituee: '[$fullIpaRest]',
      fullIpaEcclesiastique: '[$fullIpaEccl]',
      generalAdvice: advice,
    );
  }

  /// Analyse un mot latin isolé
  static LatinWordPhonetics _analyzeSingleWord(String cleanWord, String originalRaw) {
    final lower = cleanWord.toLowerCase();

    // 1. Vérification dans le lexique pré-annoté
    if (_curatedLexicon.containsKey(lower)) {
      final data = _curatedLexicon[lower]!;
      final sylls = List<String>.from(data['syllables'] as List);
      final tonic = data['tonic'] as int;
      final ipaRest = data['ipaRestituee'] as String;
      final ipaEccl = data['ipaEcclesiastique'] as String;
      final notes = List<String>.from(data['notes'] as List);

      return LatinWordPhonetics(
        latin: originalRaw,
        cleanWord: cleanWord,
        syllables: sylls,
        tonicSyllableIndex: tonic,
        syllablesDisplay: _buildSyllablesDisplay(sylls, tonic),
        ipaRestituee: ipaRest,
        ipaEcclesiastique: ipaEccl,
        phoneticNotes: notes,
      );
    }

    // 2. Découpage syllabique algorithmique
    final sylls = _syllabify(cleanWord);

    // 3. Détermination de l'accent tonique (Loi de la pénultième)
    final tonic = _determineTonicIndex(cleanWord, sylls);

    // 4. Transcription API Restituée
    final ipaRest = _transcribeRestituee(cleanWord, sylls, tonic);

    // 5. Transcription API Ecclésiastique
    final ipaEccl = _transcribeEcclesiastique(cleanWord, sylls, tonic);

    // 6. Notes phonétiques adaptées aux sons du mot
    final notes = _generateWordNotes(lower, sylls, tonic);

    return LatinWordPhonetics(
      latin: originalRaw,
      cleanWord: cleanWord,
      syllables: sylls,
      tonicSyllableIndex: tonic,
      syllablesDisplay: _buildSyllablesDisplay(sylls, tonic),
      ipaRestituee: ipaRest,
      ipaEcclesiastique: ipaEccl,
      phoneticNotes: notes,
    );
  }

  /// Découpage syllabique latin
  static List<String> _syllabify(String word) {
    final w = word.toLowerCase();
    final kernels = <List<int>>[];
    var i = 0;

    while (i < w.length) {
      if (i + 1 < w.length && w.substring(i, i + 2) == 'qu') {
        i += 2;
        continue;
      }
      if (i + 1 < w.length && _diphthongs.contains(w.substring(i, i + 2))) {
        kernels.add([i, i + 2]);
        i += 2;
      } else if (_vowels.contains(w[i])) {
        kernels.add([i, i + 1]);
        i += 1;
      } else {
        i += 1;
      }
    }

    if (kernels.length <= 1) {
      return [word];
    }

    final cuts = <int>[0];
    for (var k = 0; k < kernels.length - 1; k++) {
      final k1End = kernels[k][1];
      final k2Start = kernels[k + 1][0];
      final between = w.substring(k1End, k2Start);

      if (between.startsWith('qu')) {
        cuts.add(k1End);
      } else if (between.length <= 1) {
        cuts.add(k1End);
      } else if (between.length == 2) {
        final c1 = between[0];
        final c2 = between[1];
        // Règle de la muta cum liquida (p, b, t, d, c, g + r, l)
        if ('pbtdcg'.contains(c1) && 'rl'.contains(c2)) {
          cuts.add(k1End);
        } else {
          cuts.add(k1End + 1);
        }
      } else {
        cuts.add(k1End + 1);
      }
    }
    cuts.add(word.length);

    final res = <String>[];
    for (var s = 0; s < cuts.length - 1; s++) {
      res.add(word.substring(cuts[s], cuts[s + 1]));
    }
    return res;
  }

  /// Détermination de la syllabe tonique selon la Loi de la Pénultième
  static int _determineTonicIndex(String word, List<String> sylls) {
    if (sylls.length <= 1) return 0;
    if (sylls.length == 2) return 0;

    final penultIndex = sylls.length - 2;
    final penult = sylls[penultIndex].toLowerCase();

    // La pénultième est-elle longue ?
    // 1. Diphtongue
    for (final d in _diphthongs) {
      if (penult.contains(d)) return penultIndex;
    }

    // 2. Présence de voyelle longue (macron)
    if (penult.contains(RegExp(r'[āēīōū]'))) return penultIndex;

    // 3. Longue par position (se termine par une consonne ou suivie de 2 consonnes)
    if (penult.length >= 2 && !_vowels.contains(penult[penult.length - 1])) {
      return penultIndex;
    }

    // Sinon, l'avant-dernière est brève -> l'accent recule sur l'antépénultième
    return sylls.length - 3;
  }

  /// Construit la représentation visuelle avec accent aigu sur la tonique
  static String _buildSyllablesDisplay(List<String> sylls, int tonicIndex) {
    final parts = <String>[];
    for (var i = 0; i < sylls.length; i++) {
      if (i == tonicIndex) {
        parts.add(_addTonicAccentMark(sylls[i]));
      } else {
        parts.add(sylls[i]);
      }
    }
    return parts.join(' · ');
  }

  static String _addTonicAccentMark(String syllable) {
    // Si contient une diphtongue, accentuer la première lettre
    for (final d in _diphthongs) {
      if (syllable.toLowerCase().contains(d)) {
        return syllable.replaceFirstMapped(
          RegExp(d, caseSensitive: false),
          (m) => '${_accentChar(m[0]![0])}${m[0]![1]}',
        );
      }
    }
    // Sinon accentuer la voyelle principale
    return syllable.replaceFirstMapped(
      RegExp(r'[aeiouyāēīōū]', caseSensitive: false),
      (m) => _accentChar(m[0]!),
    );
  }

  static String _accentChar(String c) {
    switch (c) {
      case 'a': return 'á';
      case 'e': return 'é';
      case 'i': return 'í';
      case 'o': return 'ó';
      case 'u': return 'ú';
      case 'A': return 'Á';
      case 'E': return 'É';
      case 'I': return 'Í';
      case 'O': return 'Ó';
      case 'U': return 'Ú';
      case 'ā': return 'ā́';
      case 'ē': return 'ḗ';
      case 'ī': return 'ī́';
      case 'ō': return 'ṓ';
      case 'ū': return 'ū́';
      default: return c;
    }
  }

  /// Transcription en prononciation classique restituée (Ier s. av. J.-C.)
  static String _transcribeRestituee(String word, List<String> sylls, int tonicIndex) {
    final buf = StringBuffer();
    final w = word.toLowerCase();

    // Remplacement des diphtongues et consonnes
    var ipa = w
        .replaceAll('qu', 'kw')
        .replaceAll('ae', 'ae̯')
        .replaceAll('oe', 'oe̯')
        .replaceAll('au', 'au̯')
        .replaceAll('eu', 'eu̯')
        .replaceAll('c', 'k')
        .replaceAll('v', 'w')
        .replaceAll('g', 'ɡ')
        .replaceAll('y', 'y')
        .replaceAll('z', 'dz')
        .replaceAll('th', 'tʰ')
        .replaceAll('ph', 'pʰ')
        .replaceAll('ch', 'kʰ');

    // Reconstruction avec accent tonique API
    buf.write('[');
    final ipaSylls = _syllabify(ipa);
    for (var i = 0; i < ipaSylls.length; i++) {
      if (i == tonicIndex) {
        buf.write('ˈ');
      } else if (i > 0) {
        buf.write('.');
      }
      buf.write(ipaSylls[i]);
    }
    buf.write(']');
    return buf.toString();
  }

  /// Transcription en prononciation ecclésiastique (traditionnelle / médiévale)
  static String _transcribeEcclesiastique(String word, List<String> sylls, int tonicIndex) {
    final buf = StringBuffer();
    var ipa = word.toLowerCase();

    // Règles ecclésiastiques :
    // C devant e, i, ae, oe -> tʃ
    ipa = ipa.replaceAll(RegExp(r'c(?=[eiy]|ae|oe)'), 'tʃ');
    // SC devant e, i -> ʃ
    ipa = ipa.replaceAll(RegExp(r'stʃ'), 'ʃ');
    // G devant e, i -> dʒ
    ipa = ipa.replaceAll(RegExp(r'g(?=[eiy]|ae|oe)'), 'dʒ');
    // GN -> ɲ
    ipa = ipa.replaceAll('gn', 'ɲ');
    // TI devant voyelle -> tsi
    ipa = ipa.replaceAll(RegExp(r'(?<![stx])ti(?=[aeou])'), 'tsi');
    // Diphtongues ae, oe -> e
    ipa = ipa.replaceAll('ae', 'e').replaceAll('oe', 'e');
    // V reste v
    ipa = ipa.replaceAll('qu', 'kw');
    // H muet
    ipa = ipa.replaceAll('h', '');

    buf.write('[');
    final ipaSylls = _syllabify(ipa);
    for (var i = 0; i < ipaSylls.length; i++) {
      if (i == tonicIndex) {
        buf.write('ˈ');
      } else if (i > 0) {
        buf.write('.');
      }
      buf.write(ipaSylls[i]);
    }
    buf.write(']');
    return buf.toString();
  }

  /// Génère des remarques pédagogiques ciblées sur un mot
  static List<String> _generateWordNotes(String lower, List<String> sylls, int tonicIndex) {
    final notes = <String>[];

    if (lower.contains('c')) {
      notes.add('C claque toujours comme un [K] dur en latin classique.');
    }
    if (lower.contains('v')) {
      notes.add('V se prononçait comme une semi-voyelle [W] ou [OU] (ex: vinum = « ouinoum »).');
    }
    if (lower.contains('ae') || lower.contains('oe')) {
      notes.add('La diphtongue se prononce en un seul souffle lié : [aɪ] ou [ɔɪ].');
    }
    if (lower.contains('g')) {
      notes.add('G est toujours dur [ɡ] comme dans « gladiateur », jamais doux.');
    }
    if (lower.endsWith('m')) {
      notes.add('Le -M final nasalisait la voyelle en poésie et déclamation classique.');
    }

    if (sylls.length >= 2) {
      if (tonicIndex == sylls.length - 2) {
        notes.add('L\'accent tonique frappe la pénultième syllabe (${sylls[tonicIndex]}).');
      } else {
        notes.add('L\'avant-dernière syllabe étant brève, l\'accent recule sur l\'antépénultième (${sylls[tonicIndex]}).');
      }
    }

    return notes;
  }

  /// Conseils d'ensemble pour un groupe de mots
  static List<String> _generateGeneralAdvice(String text) {
    final advice = <String>[];
    final lower = text.toLowerCase();

    if (lower.contains('c')) {
      advice.add('🏛️ Règle Cicéronienne : La lettre C est TOUJOURS prononcée [K].');
    }
    if (lower.contains('v')) {
      advice.add('📜 Semi-voyelle V : À l\'époque impériale, le V s\'écrivait V mais sonnait [W].');
    }
    advice.add('⚡ Loi de la Pénultième : En latin, l\'accent ne tombe JAMAIS sur la dernière syllabe.');

    return advice;
  }
}

/// Résultat complet de l'analyse phonétique
class LatinPhoneticResult {
  final String originalText;
  final List<LatinWordPhonetics> words;
  final String fullIpaRestituee;
  final String fullIpaEcclesiastique;
  final List<String> generalAdvice;

  const LatinPhoneticResult({
    required this.originalText,
    required this.words,
    required this.fullIpaRestituee,
    required this.fullIpaEcclesiastique,
    required this.generalAdvice,
  });

  factory LatinPhoneticResult.empty() {
    return const LatinPhoneticResult(
      originalText: '',
      words: [],
      fullIpaRestituee: '[]',
      fullIpaEcclesiastique: '[]',
      generalAdvice: [],
    );
  }
}

/// Données phonétiques pour un mot individuel
class LatinWordPhonetics {
  final String latin;
  final String cleanWord;
  final List<String> syllables;
  final int tonicSyllableIndex;
  final String syllablesDisplay;
  final String ipaRestituee;
  final String ipaEcclesiastique;
  final List<String> phoneticNotes;

  const LatinWordPhonetics({
    required this.latin,
    required this.cleanWord,
    required this.syllables,
    required this.tonicSyllableIndex,
    required this.syllablesDisplay,
    required this.ipaRestituee,
    required this.ipaEcclesiastique,
    required this.phoneticNotes,
  });
}
