"""Détoure les illustrations de la boutique générées sur fond vert.

Source : Téléchargements/LATIN_LEARN/gemini ludus/<id>.jpg
Sortie : ludus_latinus_mobile/assets/images/boutique/<id>.png (256x256, fond transparent)

Usage : python scripts/assets/chroma_boutique.py [id ...]   (sans argument : les 20 articles)
"""

import sys
from pathlib import Path

from PIL import Image, ImageFilter

SOURCE = Path(r"C:\Users\caine\Downloads\LATIN_LEARN\gemini ludus")
DEST = Path(__file__).resolve().parents[2] / "ludus_latinus_mobile" / "assets" / "images" / "boutique"
TAILLE = 256
MARGE = 0.06  # marge autour du sujet, en fraction du côté

IDS = [
    "praetexta", "lorica", "imperiale", "lorica_squamata",
    "laurier_bronze", "galea_centurio", "laurier_or", "diademe_vestale", "corona_obsidionalis",
    "volumen", "gladius", "scutum", "vexillum_spqr", "fasces",
    "lupulus_jr", "noctua", "aquila", "cerberus_pullus", "equus", "pegasus_aureus",
]


def couleur_fond(im):
    """Couleur moyenne des quatre coins : le vert exact varie d'une image à l'autre."""
    w, h = im.size
    c = 12
    zones = [(0, 0, c, c), (w - c, 0, w, c), (0, h - c, c, h), (w - c, h - c, w, h)]
    pix = [p for z in zones for p in im.crop(z).convert("RGB").getdata()]
    return tuple(sum(v[i] for v in pix) // len(pix) for i in range(3))


def detourer(im, seuil_bas=55, seuil_haut=130, erosion=19, bande=41):
    """Alpha = distance à la couleur de fond échantillonnée, avec une transition douce.

    Le masque est ensuite légèrement érodé puis adouci : c'est ce qui supprime
    la frange verte que le seuil seul laisse autour du sujet.
    """
    im = im.convert("RGB")
    fond = couleur_fond(im)
    px = im.load()
    w, h = im.size
    alpha = Image.new("L", (w, h))
    apx = alpha.load()
    for y in range(h):
        for x in range(w):
            r, g, b = px[x, y]
            d = ((r - fond[0]) ** 2 + (g - fond[1]) ** 2 + (b - fond[2]) ** 2) ** 0.5
            if d <= seuil_bas:
                apx[x, y] = 0
            elif d >= seuil_haut:
                apx[x, y] = 255
            else:
                apx[x, y] = int(255 * (d - seuil_bas) / (seuil_haut - seuil_bas))
    alpha = alpha.filter(ImageFilter.MinFilter(erosion)).filter(ImageFilter.GaussianBlur(2))

    # Anti-frange : on ne retire le vert résiduel que dans la bande du contour,
    # pour ne pas décolorer un sujet légitimement vert (couronne d'herbe…).
    interieur = alpha.filter(ImageFilter.MinFilter(bande))
    bpx = interieur.load()
    apx = alpha.load()
    for y in range(h):
        for x in range(w):
            if apx[x, y] > 8 and bpx[x, y] < 250:
                r, g, b = px[x, y]
                plafond = max(r, b)
                if g > plafond:
                    px[x, y] = (r, plafond, b)

    sortie = im.convert("RGBA")
    sortie.putalpha(alpha)
    return sortie


def recadrer(im):
    """Recadre sur le sujet, centre dans un carré et ajoute une marge régulière."""
    boite = im.split()[3].point(lambda v: 255 if v > 24 else 0).getbbox()
    if boite:
        im = im.crop(boite)
    cote = int(max(im.size) * (1 + 2 * MARGE))
    carre = Image.new("RGBA", (cote, cote), (0, 0, 0, 0))
    carre.paste(im, ((cote - im.width) // 2, (cote - im.height) // 2))
    return carre.resize((TAILLE, TAILLE), Image.LANCZOS)


def alleger(im):
    """Palette de 255 couleurs, alpha conservé : un médaillon de 64 px n'en demande pas plus."""
    alpha = im.getchannel("A")
    q = im.convert("RGB").quantize(colors=255, method=Image.Quantize.FASTOCTREE, dither=Image.Dither.NONE)
    q = q.convert("RGBA")
    q.putalpha(alpha)
    return q


def main(ids):
    DEST.mkdir(parents=True, exist_ok=True)
    for item in ids:
        src = next((SOURCE / f"{item}{ext}" for ext in (".jpg", ".jpeg", ".png") if (SOURCE / f"{item}{ext}").exists()), None)
        if src is None:
            print(f"[MANQUE] {item}")
            continue
        img = alleger(recadrer(detourer(Image.open(src))))
        img.save(DEST / f"{item}.png", optimize=True)
        print(f"[OK] {item}.png  ({(DEST / f'{item}.png').stat().st_size // 1024} Ko)")


if __name__ == "__main__":
    main(sys.argv[1:] or IDS)
