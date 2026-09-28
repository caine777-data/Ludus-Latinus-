"""Illustrations Gemini du 28/09 : stèle, cartes des cas, rétiaire, décor du Duel.

Le détourage mesure « à quel point un pixel est vert » (G moins le plus fort de
R et B) plutôt que sa distance à une seule couleur de fond : il tient donc sur
les fonds verts dégradés (le rétiaire) où l'échantillonnage des coins échoue.

Usage : python scripts/assets/illustrations.py [nom ...]
Dépendances d'outillage (pas de l'app) : pip install numpy pillow
"""

import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter

SOURCE = Path(r"C:\Users\caine\Downloads\LATIN_LEARN\gemini ludus")
IMAGES = Path(__file__).resolve().parents[2] / "ludus_latinus_mobile" / "assets" / "images"

# Sujets détourés : nom du fichier Gemini -> (sortie, côté en pixels).
DETOURES = {
    "stele_vierge": ("epigraphie/stele_vierge.webp", 640),
    **{f"cas_{c}": (f"cas/cas_{c}.webp", 320)
       for c in ("nominatif", "vocatif", "accusatif", "genitif", "datif", "ablatif")},
}

MARGE = 0.04


def detourer(im):
    """RGBA : fond vert transparent, contour adouci, reflet vert retiré au bord."""
    im = im.convert("RGB")
    if im.width > 1400:
        im = im.resize((1400, round(im.height * 1400 / im.width)), Image.LANCZOS)
    rgb = np.asarray(im).astype(np.float32)
    vert = rgb[..., 1] - np.maximum(rgb[..., 0], rgb[..., 2])
    # 25 et plus : fond ; 8 et moins : sujet ; entre les deux, transition douce.
    alpha = np.clip((25 - vert) / (25 - 8), 0, 1)
    a = Image.fromarray((alpha * 255).astype(np.uint8))
    a = a.filter(ImageFilter.MinFilter(3)).filter(ImageFilter.GaussianBlur(1))
    alpha = np.asarray(a).astype(np.float32)
    bord = (alpha > 5) & (np.asarray(a.filter(ImageFilter.MinFilter(9))) < 250)
    plafond = np.maximum(rgb[..., 0], rgb[..., 2])
    rgb[..., 1] = np.where(bord & (rgb[..., 1] > plafond), plafond, rgb[..., 1])
    return Image.fromarray(np.dstack([rgb, alpha]).clip(0, 255).astype(np.uint8), "RGBA")


def cadrer(im, cote):
    """Carré centré sur le sujet, avec une petite marge."""
    boite = im.getchannel("A").point(lambda v: 255 if v > 24 else 0).getbbox()
    im = im.crop(boite)
    c = int(max(im.size) * (1 + 2 * MARGE))
    carre = Image.new("RGBA", (c, c), (0, 0, 0, 0))
    carre.paste(im, ((c - im.width) // 2, (c - im.height) // 2))
    return carre.resize((cote, cote), Image.LANCZOS)


def enregistrer(im, chemin, qualite=82):
    sortie = IMAGES / chemin
    sortie.parent.mkdir(parents=True, exist_ok=True)
    im.save(sortie, "WEBP", quality=qualite, method=6)
    print(f"[OK] {chemin}  {im.size[0]}x{im.size[1]}, {sortie.stat().st_size // 1024} Ko")


def decor_duel():
    """Fond de l'arène du Duel, en portrait."""
    im = Image.open(SOURCE / "decor_colisee_duel.jpg").convert("RGB")
    im = im.resize((720, round(im.height * 720 / im.width)), Image.LANCZOS)
    enregistrer(im, "duel/decor_colisee.webp", 72)


def boss_retiaire():
    """Médaillon du rétiaire, dans la même veine que les autres boss : le sujet
    détouré devant les gradins du décor de l'arène."""
    sujet = cadrer(detourer(Image.open(SOURCE / "boss_retiaire.jpg")), 280)
    fond = Image.open(SOURCE / "decor_colisee_duel.jpg").convert("RGB")
    # Les gradins éclairés, un peu flous pour que le gladiateur ressorte.
    fond = fond.crop((0, 200, fond.width, 200 + fond.width)).resize((280, 280), Image.LANCZOS)
    fond = fond.filter(ImageFilter.GaussianBlur(2)).convert("RGBA")
    fond.alpha_composite(sujet)
    enregistrer(fond.convert("RGB"), "boss_retiaire.webp", 85)


def main(noms):
    for nom in noms:
        if nom in DETOURES:
            chemin, cote = DETOURES[nom]
            enregistrer(cadrer(detourer(Image.open(SOURCE / f"{nom}.jpg")), cote), chemin)
        elif nom == "decor_colisee_duel":
            decor_duel()
        elif nom == "boss_retiaire":
            boss_retiaire()
        else:
            print(f"[INCONNU] {nom}")


if __name__ == "__main__":
    main(sys.argv[1:] or [*DETOURES, "decor_colisee_duel", "boss_retiaire"])
