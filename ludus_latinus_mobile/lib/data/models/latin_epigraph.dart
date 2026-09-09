/// Modèle et base de données des inscriptions lapidaires authentiques (Épigraphie romaine).
class EpigraphToken {
  final String texteGraver;
  final String formeDeveloppee;
  final String traduction;
  final String roleGrammatical;

  const EpigraphToken({
    required this.texteGraver,
    required this.formeDeveloppee,
    required this.traduction,
    required this.roleGrammatical,
  });
}

class LatinEpigraph {
  final String monumentId;
  final String titre;
  final String texteAntique;
  final List<EpigraphToken> tokens;
  final String traductionComplete;
  final String contexteHistorique;
  final int recompense;

  const LatinEpigraph({
    required this.monumentId,
    required this.titre,
    required this.texteAntique,
    required this.tokens,
    required this.traductionComplete,
    required this.contexteHistorique,
    this.recompense = 15,
  });

  /// Catalogue historique des 6 inscriptions du Forum Romanum
  static const Map<String, LatinEpigraph> catalogue = {
    'templum_saturni': LatinEpigraph(
      monumentId: 'templum_saturni',
      titre: 'Dédicace du Temple de Saturne',
      texteAntique: 'SENATVS·POPVLVSQVE·ROMANVS·INCENDIO·CONSVMPTVM·RESTITVIT',
      tokens: [
        EpigraphToken(
          texteGraver: 'SENATVS',
          formeDeveloppee: 'Senatus',
          traduction: 'Le Sénat',
          roleGrammatical: 'Nom au nominatif masculin singulier (4e déclinaison)',
        ),
        EpigraphToken(
          texteGraver: 'POPVLVSQVE',
          formeDeveloppee: 'Populus-que',
          traduction: 'et le Peuple',
          roleGrammatical: 'Nom nominatif masculin + enclitique coordonnant -que',
        ),
        EpigraphToken(
          texteGraver: 'ROMANVS',
          formeDeveloppee: 'Romanus',
          traduction: 'Romain',
          roleGrammatical: 'Adjectif épithète au nominatif masculin singulier',
        ),
        EpigraphToken(
          texteGraver: 'INCENDIO',
          formeDeveloppee: 'Incendio',
          traduction: 'par l\'incendie',
          roleGrammatical: 'Ablatif de cause/moyen neutre singulier (2e décl.)',
        ),
        EpigraphToken(
          texteGraver: 'CONSVMPTVM',
          formeDeveloppee: 'Consumptum',
          traduction: 'détruit / consumé',
          roleGrammatical: 'Participe parfait passif à l\'accusatif masculin singulier',
        ),
        EpigraphToken(
          texteGraver: 'RESTITVIT',
          formeDeveloppee: 'Restituit',
          traduction: 'a reconstruit',
          roleGrammatical: 'Verbe restituere au parfait de l\'indicatif, 3e pers. sg.',
        ),
      ],
      traductionComplete: '« Le Sénat et le Peuple Romain ont reconstruit ce temple détruit par l\'incendie. »',
      contexteHistorique: 'Gravée sur l\'architrave des huit colonnes ioniques en granite rose encore debout aujourd\'hui. L\'inscription commémore la reconstruction ordonnée après le grand incendie de l\'an 283 apr. J.-C.',
    ),
    'arcus_titi': LatinEpigraph(
      monumentId: 'arcus_titi',
      titre: 'Attique de l\'Arc de Titus',
      texteAntique: 'SENATVS·POPVLVSQVE·ROMANVS·DIVO·TITO·DIVI·VESPASIANI·F·VESPASIANO·AVGVSTO',
      tokens: [
        EpigraphToken(
          texteGraver: 'SENATVS·POPVLVSQVE·ROMANVS',
          formeDeveloppee: 'Senatus Populusque Romanus',
          traduction: 'Le Sénat et le Peuple Romain (S.P.Q.R.)',
          roleGrammatical: 'Formule officielle souveraine au nominatif',
        ),
        EpigraphToken(
          texteGraver: 'DIVO·TITO',
          formeDeveloppee: 'Divo Tito',
          traduction: 'au divin Titus',
          roleGrammatical: 'Datif d\'attribution masculin singulier (empereur divinisé)',
        ),
        EpigraphToken(
          texteGraver: 'DIVI·VESPASIANI·F·',
          formeDeveloppee: 'Divi Vespasiani Filio',
          traduction: 'fils du divin Vespasien',
          roleGrammatical: 'Génitif de filiation + F. pour filio au datif',
        ),
        EpigraphToken(
          texteGraver: 'VESPASIANO·AVGVSTO',
          formeDeveloppee: 'Vespasiano Augusto',
          traduction: 'Vespasien Auguste',
          roleGrammatical: 'Noms et titres au datif singulier',
        ),
      ],
      traductionComplete: '« Le Sénat et le Peuple Romain au divin Titus Vespasien Auguste, fils du divin Vespasien. »',
      contexteHistorique: 'Érigé en 81 apr. J.-C. par Domitien au sommet de la Voie Sacrée. Le mot "DIVO" prouve que Titus est déjà mort et élevé au rang des dieux (apothéose).',
    ),
    'lacus_iuturnae': LatinEpigraph(
      monumentId: 'lacus_iuturnae',
      titre: 'Autel de la Fontaine Sacrée',
      texteAntique: 'IVTVRNAE·SACRVM·CASTORI·ET·POLLVCI·DICATVM',
      tokens: [
        EpigraphToken(
          texteGraver: 'IVTVRNAE',
          formeDeveloppee: 'Iuturnae',
          traduction: 'À Juturne',
          roleGrammatical: 'Datif singulier féminin (dédicace à la nymphe des eaux)',
        ),
        EpigraphToken(
          texteGraver: 'SACRVM',
          formeDeveloppee: 'Sacrum',
          traduction: 'Consacré',
          roleGrammatical: 'Adjectif neutre nominatif singulier',
        ),
        EpigraphToken(
          texteGraver: 'CASTORI·ET·POLLVCI',
          formeDeveloppee: 'Castori et Polluci',
          traduction: 'À Castor et Pollux',
          roleGrammatical: 'Datif des Dieux Dioscures (3e déclinaison)',
        ),
        EpigraphToken(
          texteGraver: 'DICATVM',
          formeDeveloppee: 'Dicatum',
          traduction: 'Dédié',
          roleGrammatical: 'Participe parfait passif de dicare',
        ),
      ],
      traductionComplete: '« Lieu sacré voué à Juturne, dédié à Castor et à Pollux. »',
      contexteHistorique: 'Ce bassin recueille la source sacrée jaillissant au pied du Palatin. Selon la légende, les deux dieux cavaliers y firent boire leurs montures après la bataille du lac Régille en 499 av. J.-C.',
    ),
    'curia_iulia': LatinEpigraph(
      monumentId: 'curia_iulia',
      titre: 'Épigraphe du Sénat (Curia Julia)',
      texteAntique: 'SENATVS·CONSVLTO·DE·RE·PVBLICA·DEFENDENDA',
      tokens: [
        EpigraphToken(
          texteGraver: 'SENATVS',
          formeDeveloppee: 'Senatus',
          traduction: 'Du Sénat',
          roleGrammatical: 'Génitif masculin singulier (4e déclinaison)',
        ),
        EpigraphToken(
          texteGraver: 'CONSVLTO',
          formeDeveloppee: 'Consulto',
          traduction: 'Par décret (Senatus-consulte)',
          roleGrammatical: 'Ablatif neutre singulier',
        ),
        EpigraphToken(
          texteGraver: 'DE·RE·PVBLICA',
          formeDeveloppee: 'De Re Publica',
          traduction: 'Pour la sauvegarde de l\'État',
          roleGrammatical: 'Préposition de (+ ablatif de re publica)',
        ),
        EpigraphToken(
          texteGraver: 'DEFENDENDA',
          formeDeveloppee: 'Defendenda',
          traduction: 'à défendre',
          roleGrammatical: 'Adjectif verbal (gérondif d\'obligation en accord)',
        ),
      ],
      traductionComplete: '« Par décret du Sénat pour la défense de la République. »',
      contexteHistorique: 'La formule canonique des décrets sénatoriaux gravés sur tables de bronze affichées à la Curie pour guider l\'action des consuls et des préteurs.',
    ),
    'aedes_minervae': LatinEpigraph(
      monumentId: 'aedes_minervae',
      titre: 'Dédicace du Temple de Minerve',
      texteAntique: 'MINERVAE·AVGVSTAE·SACRVM·PRO·SALVTE·CIVIVM',
      tokens: [
        EpigraphToken(
          texteGraver: 'MINERVAE',
          formeDeveloppee: 'Minervae',
          traduction: 'À Minerve',
          roleGrammatical: 'Datif féminin singulier (1ère déclinaison)',
        ),
        EpigraphToken(
          texteGraver: 'AVGVSTAE',
          formeDeveloppee: 'Augustae',
          traduction: 'Souveraine / Vénérable',
          roleGrammatical: 'Adjectif épithète au datif féminin singulier',
        ),
        EpigraphToken(
          texteGraver: 'SACRVM',
          formeDeveloppee: 'Sacrum',
          traduction: 'Consacré',
          roleGrammatical: 'Neutre nominatif de consécration',
        ),
        EpigraphToken(
          texteGraver: 'PRO·SALVTE',
          formeDeveloppee: 'Pro Salute',
          traduction: 'Pour le salut',
          roleGrammatical: 'Préposition pro (+ ablatif féminin salus, salutis)',
        ),
        EpigraphToken(
          texteGraver: 'CIVIVM',
          formeDeveloppee: 'Civium',
          traduction: 'des citoyens',
          roleGrammatical: 'Génitif pluriel (civis, civis - 3e déclinaison)',
        ),
      ],
      traductionComplete: '« Consacré à Minerve Auguste pour le salut de tous les citoyens. »',
      contexteHistorique: 'Minerve, patronne des artisans, poètes et professeurs (*magistri*), était vénérée comme protectrice de l\'intelligence et de la concorde civique.',
    ),
    'rostra_augusta': LatinEpigraph(
      monumentId: 'rostra_augusta',
      titre: 'Tribune des Rostres Impériaux',
      texteAntique: 'IMP·CAESAR·DIVI·F·AVGVSTVS·ROSTRA·EXORNATA·DEDICAVIT',
      tokens: [
        EpigraphToken(
          texteGraver: 'IMP·',
          formeDeveloppee: 'Imperator',
          traduction: 'Général victorieux / Empereur',
          roleGrammatical: 'Titre honorifique au nominatif',
        ),
        EpigraphToken(
          texteGraver: 'CAESAR·DIVI·F·',
          formeDeveloppee: 'Caesar Divi Filius',
          traduction: 'César fils du divin (Jules)',
          roleGrammatical: 'Nominatif masculin + Filiation légale',
        ),
        EpigraphToken(
          texteGraver: 'AVGVSTVS',
          formeDeveloppee: 'Augustus',
          traduction: 'Auguste',
          roleGrammatical: 'Cognomen religieux d\'autorité suprême',
        ),
        EpigraphToken(
          texteGraver: 'ROSTRA',
          formeDeveloppee: 'Rostra',
          traduction: 'les Rostres (éperons de navires)',
          roleGrammatical: 'Accusatif neutre pluriel (complément d\'objet)',
        ),
        EpigraphToken(
          texteGraver: 'EXORNATA',
          formeDeveloppee: 'Exornata',
          traduction: 'magnifiquement ornés',
          roleGrammatical: 'Participe parfait passif neutre pluriel',
        ),
        EpigraphToken(
          texteGraver: 'DEDICAVIT',
          formeDeveloppee: 'Dedicavit',
          traduction: 'a inauguré / dédié',
          roleGrammatical: 'Verbe au parfait de l\'indicatif actif (3e pers. sg.)',
        ),
      ],
      traductionComplete: '« L\'Empereur César Auguste, fils du Divin Jules, a inauguré les Rostres magnifiquement ornés. »',
      contexteHistorique: 'Inaugurés après la victoire navale d\'Actium (31 av. J.-C.). La tribune était garnie des éperons de bronze capturés sur la flotte de Cléopâtre et Marc Antoine.',
    ),
  };
}
