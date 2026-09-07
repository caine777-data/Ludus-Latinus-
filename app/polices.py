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
_FACTEUR_ZOOM = 1.0


def definir_zoom(zoom: float) -> float:
    """Définit le facteur de zoom typographique global (ex: 1.0 = 100%, 1.2 = 120%)."""
    global _FACTEUR_ZOOM
    _FACTEUR_ZOOM = max(0.75, min(2.5, round(zoom, 2)))
    return _FACTEUR_ZOOM


def get_zoom() -> float:
    """Retourne le facteur de zoom typographique global actuel."""
    return _FACTEUR_ZOOM


def ajuster_zoom(delta: float) -> float:
    """Incrémente ou décrémente le facteur de zoom global."""
    return definir_zoom(_FACTEUR_ZOOM + delta)


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
    t_effective = max(9, int(round(taille * _FACTEUR_ZOOM)))
    return (get_famille_titre(), t_effective, poids)


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
    t_effective = max(8, int(round(taille * _FACTEUR_ZOOM)))
    return (get_famille_corps(), t_effective, style)


def police_bouton(taille=10, gras=False):
    """Retourne la police pour les boutons, onglets et commandes."""
    poids = "bold" if gras else "normal"
    t_effective = max(8, int(round(taille * _FACTEUR_ZOOM)))
    return (get_famille_corps(), t_effective, poids)


def police_monument(taille=20):
    """Pour les grandes bannières SPQR, titres du Colisée et médailles."""
    t_effective = max(11, int(round(taille * _FACTEUR_ZOOM)))
    return (get_famille_titre(), t_effective, "bold")
