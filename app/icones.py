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
_CACHE = {}


def vider_cache():
    """Vide le cache des icônes (utile lors du cycle de vie de fenêtres ou tests unitaires)."""
    _CACHE.clear()


def charger_icone(nom, taille=24):
    """
    Charge une icône romaine depuis assets/icons et la retourne sous forme de PhotoImage.
    Met en cache le résultat pour des performances optimales.
    Exemple : charger_icone("icone_temple", 24)
    """
    root_id = id(tk._default_root) if getattr(tk, "_default_root", None) is not None else None
    cle = (root_id, nom, taille)
    if cle in _CACHE:
        return _CACHE[cle]

    # 1. Essayer taille exacte si disponible
    f_taille = ICONS_DIR / f"{nom}_{taille}.png"
    if f_taille.exists():
        try:
            photo = tk.PhotoImage(file=str(f_taille))
            _CACHE[cle] = photo
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
                    photo = ImageTk.PhotoImage(im)
                    _CACHE[cle] = photo
                    return photo
                except Exception:
                    continue

    # 3. Repli Tkinter direct
    for f in [ICONS_DIR / f"{nom}_{taille}.png", ICONS_DIR / f"{nom}_24.png", ICONS_DIR / f"{nom}.png"]:
        if f.exists():
            try:
                photo = tk.PhotoImage(file=str(f))
                _CACHE[cle] = photo
                return photo
            except Exception:
                continue

    return None


def get_icones_toolbar():
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
        img = charger_icone(v, taille=24)
        if img:
            resultat[k] = img
    return resultat
