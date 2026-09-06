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
    packs,
)
from .glossaire import GLOSSAIRE as GLOSSAIRE
from .glossaire import get_glossaire as get_glossaire

CURRICULUM = [
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
