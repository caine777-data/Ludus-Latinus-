"""Détoure les avatars générés sur fond vert et produit les deux tailles de médaillon.

Source : Téléchargements/LATIN_LEARN/gemini ludus/avatar_<genre>_<toge>.jpg
Sortie : ludus_latinus_mobile/assets/images/avatars/<genre>_<toge>_140.png et _48.png

Usage : python scripts/assets/chroma_avatars.py [garcon_lorica ...]   (sans argument : les 10)
"""

import sys
from pathlib import Path

from chroma_boutique import DEST as DEST_BOUTIQUE
from chroma_boutique import alleger, detourer
from PIL import Image

SOURCE = Path(r"C:\Users\caine\Downloads\LATIN_LEARN\gemini ludus")
DEST = DEST_BOUTIQUE.parent / "avatars"
TAILLES = (140, 48)

GENRES = ("garcon", "fille")
TOGES = ("lin_blanc", "praetexta", "lorica", "imperiale", "lorica_squamata")


def cadrer(im):
    """Cadre carré sur le buste : le visage doit rester au centre du médaillon rond."""
    boite = im.split()[3].point(lambda v: 255 if v > 24 else 0).getbbox()
    if boite:
        im = im.crop(boite)
    # Le buste est plus haut que large : on prend un carré centré sur le haut du sujet.
    cote = max(im.width, int(im.height * 0.78))
    carre = Image.new("RGBA", (cote, cote), (0, 0, 0, 0))
    carre.paste(im, ((cote - im.width) // 2, 0))
    return carre


def main(noms):
    DEST.mkdir(parents=True, exist_ok=True)
    for nom in noms:
        src = SOURCE / f"avatar_{nom}.jpg"
        if not src.exists():
            print(f"[MANQUE] avatar_{nom}.jpg")
            continue
        base = cadrer(detourer(Image.open(src)))
        for taille in TAILLES:
            f = DEST / f"{nom}_{taille}.png"
            alleger(base.resize((taille, taille), Image.LANCZOS)).save(f, optimize=True)
        print(f"[OK] {nom} ({(DEST / f'{nom}_140.png').stat().st_size // 1024} Ko)")


if __name__ == "__main__":
    main(sys.argv[1:] or [f"{g}_{t}" for g in GENRES for t in TOGES])
