"""Icône de l'application (casque de centurion, Gemini) : toutes les tailles.

Source : `icone_appli.jpg` (image portrait, casque et lauriers au centre).
Produit l'icône Android adaptative (premier plan + couleur de fond), l'icône
classique des anciens Android, l'icône 512 px du Play Store et l'icône Windows.

Usage : python scripts/assets/icone_appli.py
"""
from pathlib import Path

from PIL import Image

RACINE = Path(__file__).resolve().parents[2]
SOURCE = RACINE.parent / "gemini ludus" / "icone_appli.jpg"
MOBILE = RACINE / "ludus_latinus_mobile"
RES = MOBILE / "android" / "app" / "src" / "main" / "res"

# Boîte du sujet (casque + lauriers) dans l'image source, mesurée à l'œil :
# sert à centrer et à régler la place qu'il occupe dans chaque format.
SUJET_CENTRE = (384, 680)
SUJET_COTE = 720

DENSITES = {"mdpi": 1, "hdpi": 1.5, "xhdpi": 2, "xxhdpi": 3, "xxxhdpi": 4}


def elargir(im, marge):
    """Ajoute `marge` px à gauche et à droite en prolongeant chaque ligne par
    la couleur de son bord : le fond est un dégradé sombre, la jointure ne se
    voit pas. Nécessaire car les lauriers touchent presque les bords."""
    larg, h = im.size
    neuf = Image.new("RGB", (larg + 2 * marge, h))
    neuf.paste(im, (marge, 0))
    gauche = im.crop((0, 0, 1, h)).resize((marge, h))
    droite = im.crop((larg - 1, 0, larg, h)).resize((marge, h))
    neuf.paste(gauche, (0, 0))
    neuf.paste(droite, (larg + marge, 0))
    return neuf


def carre(im, part):
    """Carré centré sur le sujet, où le sujet occupe `part` du côté."""
    cote = round(SUJET_COTE / part)
    marge = max(0, cote // 2 - SUJET_CENTRE[0]) + 2
    large = elargir(im, marge)
    cx, cy = SUJET_CENTRE[0] + marge, SUJET_CENTRE[1]
    return large.crop((cx - cote // 2, cy - cote // 2, cx + cote // 2, cy + cote // 2))


def main():
    im = Image.open(SOURCE).convert("RGB")

    # Icône adaptative (Android 8 et plus) : le lanceur découpe un cercle, un
    # carré arrondi… dans un calque de 108 dp dont seuls les 66 dp centraux
    # sont garantis visibles. Le sujet occupe donc 58 % du calque.
    avant = carre(im, 0.58)
    for dossier, f in DENSITES.items():
        d = RES / f"mipmap-{dossier}"
        avant.resize((round(108 * f),) * 2, Image.LANCZOS).save(d / "ic_launcher_foreground.png", optimize=True)
        # Icône classique (anciens Android) : carré plein, sujet plus grand
        carre(im, 0.78).resize((round(48 * f),) * 2, Image.LANCZOS).save(d / "ic_launcher.png", optimize=True)

    # Couleur de fond de l'icône adaptative : celle des bords de l'image,
    # visible seulement si le lanceur déborde du calque de premier plan.
    r, g, b = im.getpixel((5, SUJET_CENTRE[1]))
    valeurs = RES / "values" / "ic_launcher_background.xml"
    valeurs.write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n<resources>\n'
        f'    <color name="ic_launcher_background">#{r:02X}{g:02X}{b:02X}</color>\n</resources>\n',
        encoding="utf-8")

    # Play Store : 512 px, carré plein (Google arrondit lui-même les coins)
    carre(im, 0.70).resize((512, 512), Image.LANCZOS).save(MOBILE / "store" / "icone_play_store_512.png", optimize=True)

    # Windows : un .ico multi-tailles, sujet grand (pas de découpe par le système)
    carre(im, 0.82).resize((256, 256), Image.LANCZOS).save(
        MOBILE / "windows" / "runner" / "resources" / "app_icon.ico",
        sizes=[(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)])

    print("[OK] icônes Android (adaptative + classique), Play Store 512, Windows .ico")


if __name__ == "__main__":
    main()
