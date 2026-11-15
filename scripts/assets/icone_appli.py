"""Icône de l'application (casque de centurion) : toutes les tailles.

Source : `icone_appli_v2.png` (15/11/2026), casque romain seul, cimier noir, sur
rouge pompéien. Image Flux.2 Klein en local, redessinée à partir du casque de
l'ancienne icône Gemini (`icone_appli.jpg`, gardée) pour rester lisible à 48 px.
Produit l'icône Android adaptative (premier plan + couleur de fond), l'icône
classique des anciens Android, l'icône 512 px du Play Store et l'icône Windows.

Usage : python scripts/assets/icone_appli.py
"""
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageEnhance, ImageFilter

RACINE = Path(__file__).resolve().parents[2]
SOURCE = RACINE.parent / "gemini ludus" / "icone_appli_v2.png"
MOBILE = RACINE / "ludus_latinus_mobile"
RES = MOBILE / "android" / "app" / "src" / "main" / "res"

# Boîte du sujet (cimier compris) dans l'image source, mesurée par seuillage du
# fond rouge : sert à centrer et à régler la place qu'il occupe dans chaque format.
SUJET_CENTRE = (512, 495)
SUJET_COTE = 917

DENSITES = {"mdpi": 1, "hdpi": 1.5, "xhdpi": 2, "xxhdpi": 3, "xxxhdpi": 4}


def profil_du_fond(im):
    """Couleur moyenne du fond rouge selon la distance au centre, par anneaux de 20 px.

    Le fond de la source est un dégradé radial (clair au centre, sombre au bord) ;
    on le mesure sur les pixels franchement rouges, hors casque et cimier.
    """
    a = np.asarray(im, dtype=float)
    h, w, _ = a.shape
    yy, xx = np.mgrid[:h, :w]
    dist = np.hypot(xx - w / 2, yy - h / 2)
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    fond = (r > g * 1.6) & (r > b * 1.6)
    rayons, couleurs = [], []
    for debut in range(0, int(dist.max()), 20):
        anneau = fond & (dist >= debut) & (dist < debut + 20)
        if anneau.sum() > 200:  # trop peu de pixels : anneau masqué par le sujet
            rayons.append(debut + 10)
            couleurs.append(a[anneau].mean(0))
    return np.array(rayons), np.array(couleurs)


def agrandir_fond(im, marge):
    """Ajoute `marge` px de fond tout autour de l'image.

    Le sujet remplit presque toute la source carrée : pour le réduire dans la
    zone sûre des icônes, il faut plus de fond. On peint un dégradé radial qui
    prolonge celui de la source (au-delà, la couleur du bord), puis on y pose
    la source avec un bord fondu : les deux se raccordent sans couture.
    """
    rayons, couleurs = profil_du_fond(im)
    larg, haut = im.size
    taille = (larg + 2 * marge, haut + 2 * marge)
    yy, xx = np.mgrid[:taille[1], :taille[0]]
    dist = np.hypot(xx - taille[0] / 2, yy - taille[1] / 2)
    # np.interp garde la dernière couleur mesurée au-delà du dernier anneau
    canaux = [np.interp(dist, rayons, couleurs[:, c]) for c in range(3)]
    neuf = Image.fromarray(np.stack(canaux, -1).round().astype(np.uint8))
    masque = Image.new("L", taille, 0)
    ImageDraw.Draw(masque).rectangle((marge + 30, marge + 30, marge + larg - 30, marge + haut - 30), fill=255)
    masque = masque.filter(ImageFilter.GaussianBlur(15))
    pose = neuf.copy()
    pose.paste(im, (marge, marge))
    return Image.composite(pose, neuf, masque)


def aviver_or(im):
    """Rend l'or du casque plus franc et plus brillant (réglage « moyen » choisi
    par Cédric le 15/11/2026) : Flux le rend mat, presque beige.

    Seuls les pixels dorés changent (vert élevé, bleu nettement plus bas) : le
    fond rouge a un vert faible et le cimier noir est sombre, ils restent tels
    quels. Le masque est adouci pour ne pas laisser de liseré.
    """
    a = np.asarray(im, dtype=float)
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    dore = (g > 60) & (g > r * 0.55) & (b < g * 0.9)
    masque = Image.fromarray((dore * 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(2))
    vif = ImageEnhance.Color(im).enhance(1.6)
    vif = ImageEnhance.Contrast(vif).enhance(1.25)
    vif = ImageEnhance.Brightness(vif).enhance(1.10)
    return Image.composite(vif, im, masque)


def carre(im, part):
    """Carré centré sur le sujet, où le sujet occupe `part` du côté."""
    cote = round(SUJET_COTE / part)
    marge = max(0, cote // 2 - min(SUJET_CENTRE)) + 2
    large = agrandir_fond(im, marge)
    cx, cy = SUJET_CENTRE[0] + marge, SUJET_CENTRE[1] + marge
    return large.crop((cx - cote // 2, cy - cote // 2, cx + cote // 2, cy + cote // 2))


def main():
    im = aviver_or(Image.open(SOURCE).convert("RGB"))

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
