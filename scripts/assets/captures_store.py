"""Met les captures d'émulateur (1080 × 2400) au format du Play Store.

Google refuse un côté long de plus de 2 fois le côté court : on élargit à
1200 × 2400 en prolongeant les bords gauche et droit (la dernière colonne de
pixels est étirée sur 60 px), sans toucher au contenu de l'écran.

Usage : python scripts/assets/captures_store.py <capture.png> <destination.png> [...]
(par paires source, destination).
"""

import sys

from PIL import Image

LARGEUR, HAUTEUR = 1200, 2400


def au_format_store(source, destination):
    with Image.open(source) as capture:
        capture = capture.convert("RGB")
        if capture.size != (1080, HAUTEUR):
            raise ValueError(f"{source} : {capture.size}, 1080 × 2400 attendu")
        marge = (LARGEUR - capture.width) // 2
        sortie = Image.new("RGB", (LARGEUR, HAUTEUR))
        sortie.paste(capture, (marge, 0))
        gauche = capture.crop((0, 0, 1, HAUTEUR)).resize((marge, HAUTEUR))
        droite = capture.crop((capture.width - 1, 0, capture.width, HAUTEUR)).resize((marge, HAUTEUR))
        sortie.paste(gauche, (0, 0))
        sortie.paste(droite, (marge + capture.width, 0))
        sortie.save(destination, optimize=True)


if __name__ == "__main__":
    args = sys.argv[1:]
    if not args or len(args) % 2:
        sys.exit(__doc__)
    for src, dst in zip(args[::2], args[1::2], strict=True):
        au_format_store(src, dst)
        print(dst)
