"""
Gestionnaire et cache des icônes romaines 3D de Ludus Latinus.
Fournit les icônes thématiques dorées pour la barre d'outils, les boutons,
les rubans de statistiques et les dialogues.
"""

import tkinter as tk
from pathlib import Path

try:
    from PIL import Image, ImageTk
    HAS_PIL = True
except ImportError:
    HAS_PIL = False

ICONS_DIR = Path(__file__).resolve().parent.parent / "assets" / "icons"
# Cache de secours quand aucune fenêtre n'existe encore.
_CACHE = {}


def vider_cache():
    """Vide le cache des icônes (utile lors du cycle de vie de fenêtres ou tests unitaires)."""
    _CACHE.clear()
    racine = getattr(tk, "_default_root", None)
    if racine is not None:
        try:
            racine._cache_icones = {}
        except Exception:
            pass


def _image_valide(photo):
    """Vrai si l'image existe encore côté Tcl (sa fenêtre n'est pas fermée)."""
    try:
        photo.width()
        return True
    except Exception:
        return False


def _cache_courant(master=None):
    """Cache porté par la fenêtre, afin qu'il meure avec son interpréteur Tk.

    Une PhotoImage n'est valable que pour l'interpréteur qui l'a créée. Un cache
    de module la ferait survivre à sa fenêtre, et une autre fenêtre échouerait
    sur « image "pyimageNN" doesn't exist ».
    """
    racine = master if master is not None else getattr(tk, "_default_root", None)
    if racine is None:
        return _CACHE
    cache = getattr(racine, "_cache_icones", None)
    if cache is None:
        cache = {}
        try:
            racine._cache_icones = cache
        except Exception:
            return _CACHE
    return cache


def charger_icone(nom, taille=24, master=None):
    """
    Charge une icône romaine depuis assets/icons et la retourne sous forme de PhotoImage.
    Met en cache le résultat pour des performances optimales.
    Exemple : charger_icone("icone_temple", 24)

    [master] est la fenêtre qui utilisera l'icône. Le préciser est indispensable
    dès que plusieurs fenêtres Tk coexistent : une image appartient à un seul
    interpréteur et reste invisible pour les autres.
    """
    cache = _cache_courant(master)
    cle = (nom, taille)
    if cle in cache:
        deja = cache[cle]
        if _image_valide(deja):
            return deja
        # L'image appartenait à une fenêtre désormais fermée : on la régénère.
        cache.pop(cle, None)

    # 1. Essayer taille exacte si disponible
    f_taille = ICONS_DIR / f"{nom}_{taille}.png"
    if f_taille.exists():
        try:
            photo = tk.PhotoImage(file=str(f_taille), master=master)
            cache[cle] = photo
            return photo
        except Exception:
            pass

    # 2. Si PIL est disponible, redimensionner depuis la meilleure résolution disponible
    if HAS_PIL:
        candidats = [
            ICONS_DIR / f"{nom}_64.png",
            ICONS_DIR / f"{nom}.png",
            ICONS_DIR / f"{nom}_32.png",
            ICONS_DIR / f"{nom}_24.png",
        ]
        for c in candidats:
            if c.exists():
                try:
                    im = Image.open(c).convert("RGBA")
                    if im.size != (taille, taille):
                        im = im.resize((taille, taille), Image.Resampling.LANCZOS)
                    photo = ImageTk.PhotoImage(im, master=master)
                    cache[cle] = photo
                    return photo
                except Exception:
                    continue

    # 3. Repli Tkinter direct
    for f in [ICONS_DIR / f"{nom}_{taille}.png", ICONS_DIR / f"{nom}_24.png", ICONS_DIR / f"{nom}.png"]:
        if f.exists():
            try:
                photo = tk.PhotoImage(file=str(f), master=master)
                cache[cle] = photo
                return photo
            except Exception:
                continue

    return None


def get_icones_toolbar(master=None):
    """Retourne le dictionnaire des icônes associées aux clés de barre d'outils."""
    mapping = {
        "tb_accueil": "icone_temple",
        "tb_carte": "icone_carte",
        "tb_circus": "icone_circus",
        "tb_cartes": "icone_trophee",
        "tb_penderie": "icone_sesterce",
        "tb_marche": "icone_sesterce",
        "tb_cesar": "icone_laurier",
        "tb_duel": "icone_arene",
        "tb_fiches": "icone_revision",
        "tb_profils": "icone_profils",
        "tb_maj": "icone_maj",
        "tb_glossaire": "icone_glossaire",
        "tb_revision": "icone_revision",
        "tb_succes": "icone_trophee",
        "tb_decrypteur": "icone_laurier",
        "tb_taverne": "icone_arene",
        "tb_compte": "icone_profils",
        "tb_memoria": "icone_revision",
        "tb_forum": "icone_temple",
        "tb_thesaurus": "icone_glossaire",
        "tb_stats": "icone_stats",
    }
    resultat = {}
    for k, v in mapping.items():
        img = charger_icone(v, taille=24, master=master)
        if img:
            resultat[k] = img
    return resultat
