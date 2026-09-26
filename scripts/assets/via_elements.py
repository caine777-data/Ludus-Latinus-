"""Détoure les éléments de bord de route de la Via Appia (pins, bornes, monuments…).

Source : Téléchargements/LATIN_LEARN/gemini ludus/via_<nom>.jpg  (fond vert)
Sortie : ludus_latinus_mobile/assets/images/via/<nom>.png

Contrairement aux articles de la boutique, on garde les proportions réelles
(un cyprès est haut et fin, des amphores sont basses) et on recadre au ras du
sujet : sur la carte, l'élément est posé par sa base, comme sur le sol.

Usage : python scripts/assets/via_elements.py [nom ...]   (sans argument : les 8)
"""

import sys
from pathlib import Path

from chroma_boutique import SOURCE, alleger, detourer
from PIL import Image

DEST = Path(__file__).resolve().parents[2] / "ludus_latinus_mobile" / "assets" / "images" / "via"
HAUTEUR_MAX = 240  # affiché au plus à ~80 dp de haut

NOMS = ["pin", "cypres", "borne", "mausolee", "fontaine", "amphores", "colonne", "charrette"]


def main(noms):
    DEST.mkdir(parents=True, exist_ok=True)
    for nom in noms:
        src = SOURCE / f"via_{nom}.jpg"
        if not src.exists():
            print(f"[MANQUE] {src.name}")
            continue
        im = detourer(Image.open(src))
        boite = im.getchannel("A").point(lambda v: 255 if v > 24 else 0).getbbox()
        if boite:
            im = im.crop(boite)
        echelle = HAUTEUR_MAX / max(im.width, im.height)
        im = im.resize((max(1, round(im.width * echelle)), max(1, round(im.height * echelle))), Image.LANCZOS)
        f = DEST / f"{nom}.png"
        alleger(im).save(f, optimize=True)
        print(f"[OK] {nom}.png  {im.width}x{im.height}, {f.stat().st_size // 1024} Ko")


if __name__ == "__main__":
    main(sys.argv[1:] or NOMS)
