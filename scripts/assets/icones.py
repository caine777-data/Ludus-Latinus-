"""Icônes isolées générées dans Gemini (fond vert) : détourage et mise au format.

Réutilise le détourage de la boutique. Usage : python scripts/assets/icones.py
"""
from pathlib import Path

from chroma_boutique import SOURCE, alleger, detourer, recadrer
from PIL import Image

DEST = Path(__file__).resolve().parents[2] / "ludus_latinus_mobile" / "assets" / "images"

# nom du fichier Gemini -> côté en pixels (le médaillon de 48 points, en 3x ou plus)
ICONES = {
    "icone_epigraphie": 192,
}

# Icônes posées dans le texte (sesterces, série, boutique : audit E4 et E8),
# 12 à 24 points à l'écran : cadrage serré, sans la marge du médaillon.
ICONES_SERREES = {
    "icone_sesterce": 96,
    "icone_flamme": 96,
    "icone_bourse": 96,
}

# Les icônes s'affichent dans un médaillon rond : le sujet doit tenir dans le
# cercle, sinon les coins (ici le manche de la loupe) sont coupés.
MARGE_CERCLE = 1.30


def dans_le_cercle(im):
    cote = int(im.width * MARGE_CERCLE)
    carre = Image.new("RGBA", (cote, cote), (0, 0, 0, 0))
    carre.paste(im, ((cote - im.width) // 2, (cote - im.height) // 2))
    return carre


def main():
    for nom, taille in {**ICONES, **ICONES_SERREES}.items():
        src = SOURCE / f"{nom}.jpg"
        if not src.exists():
            print(f"[MANQUE] {nom}")
            continue
        img = recadrer(detourer(Image.open(src)))
        if nom in ICONES:
            img = dans_le_cercle(img)
        else:
            # Carré transparent autour du sujet, pour qu'il ne soit pas déformé.
            cote = max(img.size)
            carre = Image.new("RGBA", (cote, cote), (0, 0, 0, 0))
            carre.paste(img, ((cote - img.width) // 2, (cote - img.height) // 2))
            img = carre
        img = alleger(img.resize((taille, taille), Image.LANCZOS))
        img.save(DEST / f"{nom}.png", optimize=True)
        print(f"[OK] {nom}.png  ({(DEST / f'{nom}.png').stat().st_size // 1024} Ko)")


if __name__ == "__main__":
    main()
