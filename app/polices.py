"""
Gestion des polices romaines antiques et calligraphiques de Ludus Latinus.
Sélectionne les meilleures typographies romaines disponibles (Palatino Linotype,
Cinzel, Trajan Pro, Georgia, Constantia) pour conférer une allure noble et impériale
aux titres, bannières, fiches d'exercices et parchemins.
"""

import tkinter.font as tkfont

# Typographies candidates par ordre de prestige impérial
CANDIDATS_TITRES = [
    "Cinzel",
    "Trajan Pro",
    "Palatino Linotype",
    "Georgia",
    "Constantia",
    "Cambria",
    "Times New Roman",
]

CANDIDATS_CORPS = [
    "Georgia",
    "Palatino Linotype",
    "Constantia",
    "Cambria",
    "Garamond",
    "Segoe UI",
]

_FAMILLE_TITRE = None
_FAMILLE_CORPS = None


def detecter_famille(candidats, fallback="Palatino Linotype"):
    try:
        disponibles = tkfont.families()
        for nom in candidats:
            if nom in disponibles:
                return nom
    except Exception:
        pass
    return fallback


def get_famille_titre():
    global _FAMILLE_TITRE
    if _FAMILLE_TITRE is None:
        _FAMILLE_TITRE = detecter_famille(CANDIDATS_TITRES, fallback="Palatino Linotype")
    return _FAMILLE_TITRE


def get_famille_corps():
    global _FAMILLE_CORPS
    if _FAMILLE_CORPS is None:
        _FAMILLE_CORPS = detecter_famille(CANDIDATS_CORPS, fallback="Georgia")
    return _FAMILLE_CORPS


def police_titre(taille=16, gras=True):
    """Retourne la police romaine pour les grands titres et en-têtes."""
    poids = "bold" if gras else "normal"
    return (get_famille_titre(), taille, poids)


def police_corps(taille=11, gras=False, italique=False):
    """Retourne la police pour les textes de leçons, récits et consignes."""
    if gras and italique:
        style = "bold italic"
    elif gras:
        style = "bold"
    elif italique:
        style = "italic"
    else:
        style = "normal"
    return (get_famille_corps(), taille, style)


def police_monument(taille=20):
    """Pour les grandes bannières SPQR, titres du Colisée et médailles."""
    return (get_famille_titre(), taille, "bold")
