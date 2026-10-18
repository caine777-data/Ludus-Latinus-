"""
Correspondance entre les mondes de Ludus Latinus et le programme officiel de
latin du collège : programme de LCA au cycle 4, Bulletin officiel n°11 du
17 mars 2016. Tableau validé par Cédric le 18/10/2026 (relecture par un
professeur de latin souhaitée).

Sert à la ligne « Au programme » de chaque monde et à la page « Pour les
professeurs ». Les intitulés entre guillemets sont ceux du Bulletin officiel.
"""

# langue = notions de langue travaillées ; culture = thème culturel du programme.
PROGRAMME_MONDES = {
    # 5e
    "monde1": {
        "langue": "Le verbe sum ; la prononciation ; les chiffres romains.",
        "culture": "« De la légende à l'histoire » : les origines de Rome et ses figures héroïques, les légendes de fondation.",
    },
    "monde2": {
        "langue": "L'indicatif présent (3e personne) ; les compléments de lieu.",
        "culture": "« Vie privée et vie publique » : famille et filiation, l'habitat, l'éducation.",
    },
    "monde3": {
        "langue": "Les personnes de l'indicatif.",
        "culture": "« Vie privée et vie publique » : la religion romaine, figures grecques et figures romaines de divinités.",
    },
    "monde4": {
        "langue": "Les cas et leurs fonctions : nominatif, accusatif.",
        "culture": "« De la légende à l'histoire » : figures héroïques.",
    },
    "monde5": {
        "langue": "L'indicatif présent actif ; le verbe sum.",
        "culture": "« De la légende à l'histoire » : figures héroïques.",
    },
    "monde6": {
        "langue": "Le pluriel du verbe ; les cas.",
        "culture": "« Vie privée et vie publique » : théâtre, jeux et loisirs publics.",
    },
    "monde7": {
        "langue": "Premier perfectum (veni, vidi, vici).",
        "culture": "Lexique : familles de mots, sens des préverbes, expressions latines du français.",
    },
    "monde8": {
        "langue": "Le génitif.",
        "culture": "« Vie privée et vie publique » : la vie quotidienne.",
    },
    "monde9": {
        "langue": "Le pluriel des noms.",
        "culture": "L'armée romaine : thème de 3e dans le programme, abordé ici dès la 5e.",
    },
    "monde10": {
        "langue": "L'accord de l'adjectif ; le datif et l'ablatif.",
        "culture": "« De la légende à l'histoire » : récits mythologiques ; « De Troie au Latium » pour Ulysse.",
    },
    # 4e
    "monde11": {
        "langue": "Révision des cas ; les verbes composés.",
        "culture": "« De la légende à l'histoire » : la Rome royale, la naissance de la république.",
    },
    "monde12": {
        "langue": "La 3e déclinaison.",
        "culture": "« La république : histoire et institutions » : assemblées et votes, grandes figures politiques.",
    },
    "monde13": {
        "langue": "La 3e déclinaison (noms en -i, neutres).",
        "culture": "« Le monde méditerranéen antique » : Carthage et les guerres puniques.",
    },
    "monde14": {
        "langue": "Les adjectifs de la seconde classe ; les degrés de l'adjectif.",
        "culture": "« Alliances et conflits entre cités dans le monde antique ».",
    },
    "monde15": {
        "langue": "L'imparfait ; sum à l'imparfait.",
        "culture": "« La république : histoire et institutions ».",
    },
    "monde16": {
        "langue": "Le parfait (perfectum) ; sum au parfait.",
        "culture": "« Les grandes figures politiques de la République » : César.",
    },
    "monde17": {
        "langue": "Le futur ; is, ea, id ; hic, ille, iste, idem, ipse.",
        "culture": "La guerre des Gaules : « Rome et les provinces » est un thème de 3e, abordé ici en 4e.",
    },
    "monde18": {
        "langue": "Révision de la 5e et de la 4e.",
        "culture": "« Les crises et la fin de la République » : thème de 3e, abordé ici en fin de 4e.",
    },
    # 3e
    "monde19": {
        "langue": "Les 4e et 5e déclinaisons.",
        "culture": "« De la république au principat » : Auguste ; « L'empire romain » : la paix romaine.",
    },
    "monde20": {
        "langue": "Le pronom relatif et les propositions relatives ; les verbes eo, fero, fio.",
        "culture": "« L'empire romain » : la romanisation de l'empire.",
    },
    "monde21": {
        "langue": "Le participe parfait passif.",
        "culture": "« Vie familiale, sociale et intellectuelle » : la vie à la ville.",
    },
    "monde22": {
        "langue": "L'ablatif absolu.",
        "culture": "« L'empire romain » : l'armée romaine et les guerres de conquête.",
    },
    "monde23": {
        "langue": "Le passif ; les verbes déponents.",
        "culture": "« Le monde méditerranéen » : les pratiques de l'argumentation (Cicéron).",
    },
    "monde24": {
        "langue": "La proposition infinitive ; le gérondif.",
        "culture": "« L'empire romain » : figures d'empereurs.",
    },
    "monde25": {
        "langue": "Le subjonctif : souhait, but, conséquence, condition.",
        "culture": "« Le monde méditerranéen » : Rome et la Grèce, la transmission culturelle (Virgile, Ovide).",
    },
    "monde26": {
        "langue": "Synthèse du cycle 4.",
        "culture": "Tous les ensembles du programme.",
    },
}

# Page « Pour les professeurs ».
PROGRAMME_LCA = {
    "reference": (
        "Programme de l'enseignement de complément de langues et cultures de l'Antiquité (LCA) "
        "au cycle 4, Bulletin officiel n°11 du 17 mars 2016."
    ),
    "presentation": (
        "Ludus Latinus suit le programme de latin du collège, de la 5e à la 3e. Chaque monde "
        "travaille une notion de langue et un thème culturel du programme. Les élèves peuvent "
        "s'entraîner à la maison sur ce qui est vu en classe."
    ),
    "ecarts": [
        "L'armée romaine (monde 9) est traitée dès la 5e ; le programme la place en 3e, dans « L'empire romain ».",
        "La guerre des Gaules (monde 17) est traitée en 4e ; « Rome et les provinces » figure au programme de 3e.",
        "La fin de la République (monde 18) clôt la 4e ; « Les crises et la fin de la République » est un thème de 3e.",
        "L'ablatif absolu et la proposition infinitive, à « observer » dès la 5e-4e, sont enseignés en 3e (mondes 22 et 24).",
    ],
    "relecture": "Tableau établi d'après le Bulletin officiel ; les remarques des professeurs sont les bienvenues.",
    "contact": "icareetdedale.studio@gmail.com",
}


def _insecables(texte):
    """Espaces insécables dans les guillemets : sinon « ou » peut se retrouver
    seul en début ou en fin de ligne à l'écran."""
    return texte.replace("« ", "«\u00a0").replace(" »", "\u00a0»")


PROGRAMME_MONDES = {
    monde: {cle: _insecables(texte) for cle, texte in lignes.items()} for monde, lignes in PROGRAMME_MONDES.items()
}
PROGRAMME_LCA = {
    cle: [_insecables(e) for e in val] if isinstance(val, list) else _insecables(val)
    for cle, val in PROGRAMME_LCA.items()
}
