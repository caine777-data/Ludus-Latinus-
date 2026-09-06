"""
Curriculum complet de Ludus Latinus.
Composé de 7 grands mondes d'apprentissage pas-à-pas pour la 5ème.
"""

from . import (
    monde1_salve,
    monde2_domus,
    monde3_dieux,
    monde4_cas,
    monde5_verbes,
    monde6_colisee,
    monde7_etymologie,
    monde8_marche,
    monde9_legion,
    monde10_monstres,
    monde11_heros,
    monde12_spqr,
    monde13_marenostrum,
    monde14_legions,
    monde15_imparfait,
    monde16_parfait,
    monde17_cesar,
    monde18_triomphe_rep,
    monde19_auguste,
    monde20_chemins,
    monde21_pompei,
    monde22_ablatif_absolu,
    monde23_passif,
    monde24_infinitive,
    monde25_poetes,
    monde26_triomphe_cycle4,
    packs,
)
from .glossaire import GLOSSAIRE as GLOSSAIRE
from .glossaire import get_glossaire as get_glossaire

CURRICULUM_5EME = [
    monde1_salve.LEVEL,
    monde2_domus.LEVEL,
    monde3_dieux.LEVEL,
    monde4_cas.LEVEL,
    monde5_verbes.LEVEL,
    monde6_colisee.LEVEL,
    monde7_etymologie.LEVEL,
    monde8_marche.LEVEL,
    monde9_legion.LEVEL,
    monde10_monstres.LEVEL,
]

CURRICULUM_4EME = [
    monde11_heros.LEVEL,
    monde12_spqr.LEVEL,
    monde13_marenostrum.LEVEL,
    monde14_legions.LEVEL,
    monde15_imparfait.LEVEL,
    monde16_parfait.LEVEL,
    monde17_cesar.LEVEL,
    monde18_triomphe_rep.LEVEL,
]

CURRICULUM_3EME = [
    monde19_auguste.LEVEL,
    monde20_chemins.LEVEL,
    monde21_pompei.LEVEL,
    monde22_ablatif_absolu.LEVEL,
    monde23_passif.LEVEL,
    monde24_infinitive.LEVEL,
    monde25_poetes.LEVEL,
    monde26_triomphe_cycle4.LEVEL,
]

CLASSES = {
    "5eme": {
        "id": "5eme",
        "titre": "5ème",
        "sous_titre": "Les Origines & La Cité",
        "icone": "🏛️",
        "description": "Premiers pas à Rome, alphabet, 1re et 2e déclinaisons, présent et mythes fondateurs.",
        "curriculum": CURRICULUM_5EME,
    },
    "4eme": {
        "id": "4eme",
        "titre": "4ème",
        "sous_titre": "La République & L'Expansion",
        "icone": "⚔️",
        "description": "3e déclinaison, adjectifs, imparfait, parfait, conquêtes de César et fin de la République.",
        "curriculum": CURRICULUM_4EME,
    },
    "3eme": {
        "id": "3eme",
        "titre": "3ème",
        "sous_titre": "L'Empire & Les Grands Auteurs",
        "icone": "👑",
        "description": "4e et 5e déclinaisons, ablatif absolu, proposition infinitive, voix passive, Auguste et Virgile.",
        "curriculum": CURRICULUM_3EME,
    },
}

CURRICULUM = CURRICULUM_5EME + CURRICULUM_4EME + CURRICULUM_3EME


def get_curriculum_classe(classe="5eme"):
    """Retourne les mondes correspondant à la classe choisie ('5eme', '4eme', '3eme')."""
    if classe in CLASSES:
        return CLASSES[classe]["curriculum"]
    return CURRICULUM_5EME


def find_classe_for_lesson(lesson_id_or_lesson):
    """Retourne la classe ('5eme', '4eme', '3eme') à laquelle appartient une leçon."""
    if isinstance(lesson_id_or_lesson, dict):
        lid = lesson_id_or_lesson.get("id")
    else:
        lid = lesson_id_or_lesson
    for classe_key, cinfo in CLASSES.items():
        for level in cinfo["curriculum"]:
            for lesson in level["lessons"]:
                if lesson["id"] == lid:
                    return classe_key
    return "5eme"

_packs_charges = False


def ids_utilises():
    """Tous les identifiants déjà pris, parcours et leçons confondus."""
    pris = set()
    for niveau in CURRICULUM:
        pris.add(niveau["id"])
        for lecon in niveau["lessons"]:
            pris.add(lecon["id"])
    return pris


def ajouter_packs(dossier=None):
    """Ajoute au curriculum les packs de leçons personnalisés."""
    global _packs_charges
    if _packs_charges:
        return [], []
    try:
        nouveaux, problemes = packs.charger_packs(dossier, ids_utilises())
        CURRICULUM.extend(nouveaux)
        _packs_charges = True
        return nouveaux, problemes
    except Exception:
        return [], []


def all_lessons():
    for level in CURRICULUM:
        for lesson in level["lessons"]:
            yield level, lesson


def lesson_items(lesson):
    """Identifiants des sous-éléments validables d'une leçon."""
    return [lesson["id"]]


def get_exercice(lesson, index):
    return lesson


def exercice_count(lesson):
    return 1


def traduit(element, champ, langue="fr", defaut=None):
    if element is None:
        return defaut
    if langue and langue != "fr":
        valeur = element.get(f"{champ}_{langue}")
        if valeur:
            return valeur
    valeur = element.get(champ)
    return defaut if valeur is None else valeur


def hints_for(lesson, exercice=None, langue="fr"):
    return lesson.get("hints", [])


def total_count():
    """Nombre total d'éléments validables."""
    return sum(len(lesson_items(lecon)) for _, lecon in all_lessons())


def lesson_done(lesson, completed):
    return all(i in completed for i in lesson_items(lesson))


def find_lesson(lesson_id):
    for _, lesson in all_lessons():
        if lesson["id"] == lesson_id:
            return lesson
    return None
