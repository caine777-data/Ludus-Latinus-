"""Convertit les décors des mondes générés dans Gemini en WebP pour l'application.

Source : Téléchargements/LATIN_LEARN/gemini ludus/decor_monde<N>.jpg  (vertical 9:16)
Sortie : ludus_latinus_mobile/assets/images/mondes/monde<N>.webp       (720 px de large)

Usage : python scripts/assets/decors_mondes.py [N ...]   (sans argument : les 26 mondes)
"""

import sys
from pathlib import Path

from PIL import Image

SOURCE = Path(r"C:\Users\caine\Downloads\LATIN_LEARN\gemini ludus")
DEST = Path(__file__).resolve().parents[2] / "ludus_latinus_mobile" / "assets" / "images" / "mondes"
LARGEUR = 720
QUALITE = 78


def main(numeros):
    DEST.mkdir(parents=True, exist_ok=True)
    for n in numeros:
        src = SOURCE / f"decor_monde{n}.jpg"
        if not src.exists():
            print(f"[MANQUE] {src.name}")
            continue
        im = Image.open(src).convert("RGB")
        im = im.resize((LARGEUR, round(im.height * LARGEUR / im.width)), Image.LANCZOS)
        f = DEST / f"monde{n}.webp"
        im.save(f, "WEBP", quality=QUALITE, method=6)
        print(f"[OK] {f.name}  ({f.stat().st_size // 1024} Ko)")


if __name__ == "__main__":
    main([int(a) for a in sys.argv[1:]] or range(1, 27))
