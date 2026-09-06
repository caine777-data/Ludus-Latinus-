"""
Module de gestion et génération des Cadres Antiques Romains.
Fournit des cadres biseautés dorés/marbre avec rivets et des médaillons ronds
pour sublimer les illustrations, portraits de héros et monstres de l'application.
"""

import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageTk

ASSETS_DIR = Path(__file__).resolve().parent.parent / "assets" / "images"

# Palette de couleurs antiques
STYLES_CADRES = {
    "or": {
        "ext": (45, 20, 10, 255),          # Bronze profond
        "biseau_h": (255, 230, 120, 255),  # Or éclatant haut/gauche
        "biseau_m": (212, 175, 55, 255),   # Or antique
        "biseau_b": (110, 75, 15, 255),    # Or sombre bas/droite
        "rivet": (255, 220, 90, 255),      # Rivet doré
        "filet": "#ffd700",
    },
    "arene": {
        "ext": (40, 10, 15, 255),          # Pourpre sombre
        "biseau_h": (230, 80, 50, 255),    # Lueur rouge braise
        "biseau_m": (160, 40, 30, 255),    # Fer rougi
        "biseau_b": (60, 20, 20, 255),     # Ombre sombre
        "rivet": (255, 190, 80, 255),      # Rivet laiton
        "filet": "#e74c3c",
    },
    "marbre": {
        "ext": (30, 30, 35, 255),          # Pierre sombre
        "biseau_h": (248, 246, 240, 255),  # Marbre blanc éclatant
        "biseau_m": (195, 190, 180, 255),  # Marbre gris clair
        "biseau_b": (90, 85, 80, 255),     # Ombre de pierre
        "rivet": (212, 175, 55, 255),      # Rivet doré
        "filet": "#dcd6cd",
    },
    "bronze": {
        "ext": (35, 25, 15, 255),
        "biseau_h": (215, 137, 60, 255),   # Bronze poli
        "biseau_m": (150, 90, 40, 255),    # Bronze antique
        "biseau_b": (60, 35, 15, 255),     # Ombre
        "rivet": (230, 160, 80, 255),      # Clou de bronze
        "filet": "#cd7f32",
    }
}

# Cache mémoire pour éviter de regénérer des PhotoImage identiques
_PHOTO_CACHE = {}


def creer_cadre_antique(im, style="or", epaisseur=8, rivets=True, ombre=True):
    """
    Applique un cadre romain antique luxueux autour d'une image PIL.
    """
    if im.mode != "RGBA":
        im = im.convert("RGBA")

    w, h = im.size
    pad = epaisseur
    nw, nh = w + pad * 2, h + pad * 2

    cfg = STYLES_CADRES.get(style, STYLES_CADRES["or"])
    c_ext = cfg["ext"]
    c_biseau_h = cfg["biseau_h"]
    c_biseau_m = cfg["biseau_m"]
    c_biseau_b = cfg["biseau_b"]
    c_rivet = cfg["rivet"]

    framed = Image.new("RGBA", (nw, nh), c_ext)
    draw = ImageDraw.Draw(framed)

    # 1. Biseau extérieur dégradé
    for i in range(pad):
        ratio = i / max(1, pad - 1)
        r = int(c_biseau_h[0] * (1 - ratio) + c_biseau_m[0] * ratio)
        g = int(c_biseau_h[1] * (1 - ratio) + c_biseau_m[1] * ratio)
        b = int(c_biseau_h[2] * (1 - ratio) + c_biseau_m[2] * ratio)
        c_top = (r, g, b, 255)

        rb = int(c_biseau_m[0] * (1 - ratio) + c_biseau_b[0] * ratio)
        gb = int(c_biseau_m[1] * (1 - ratio) + c_biseau_b[1] * ratio)
        bb = int(c_biseau_m[2] * (1 - ratio) + c_biseau_b[2] * ratio)
        c_bot = (rb, gb, bb, 255)

        draw.line([(i, i), (nw - 1 - i, i)], fill=c_top, width=1)
        draw.line([(i, i), (i, nh - 1 - i)], fill=c_top, width=1)
        draw.line([(i, nh - 1 - i), (nw - 1 - i, nh - 1 - i)], fill=c_bot, width=1)
        draw.line([(nw - 1 - i, i), (nw - 1 - i, nh - 1 - i)], fill=c_bot, width=1)

    # 2. Filet brillant intérieur
    draw.rectangle([pad - 1, pad - 1, nw - pad, nh - pad], outline=c_biseau_h, width=1)

    # 3. Ombre portée intérieure sur l'image
    img_shadow = im.copy()
    if ombre:
        sd = ImageDraw.Draw(img_shadow)
        for s in range(min(4, pad)):
            alpha = int(70 * (1 - s / 4))
            sd.rectangle([s, s, w - 1 - s, h - 1 - s], outline=(0, 0, 0, alpha), width=1)

    framed.paste(img_shadow, (pad, pad), img_shadow)

    # 4. Rivets / Clous dorés aux 4 coins
    if rivets and pad >= 5:
        r_size = max(2, pad // 3)
        dist = pad // 2
        coins = [
            (dist, dist),
            (nw - 1 - dist, dist),
            (dist, nh - 1 - dist),
            (nw - 1 - dist, nh - 1 - dist)
        ]
        for cx, cy in coins:
            draw.ellipse([cx - r_size, cy - r_size + 1, cx + r_size, cy + r_size + 1], fill=(20, 10, 5, 200))
            draw.ellipse([cx - r_size, cy - r_size, cx + r_size, cy + r_size], fill=c_rivet, outline=(90, 60, 10, 255))
            draw.point((cx - 1, cy - 1), fill=(255, 255, 220, 255))

    return framed


def creer_cadre_medaillon(im, diametre=180, style="or"):
    """
    Rogne une image en cercle et l'enchâsse dans un médaillon romain orné de rivets.
    """
    im = im.convert("RGBA")
    pad = max(8, diametre // 15)
    inner_diam = diametre - pad * 2
    im_resized = im.resize((inner_diam, inner_diam), Image.Resampling.LANCZOS)

    mask = Image.new("L", (inner_diam, inner_diam), 0)
    draw_mask = ImageDraw.Draw(mask)
    draw_mask.ellipse([0, 0, inner_diam - 1, inner_diam - 1], fill=255)

    medallion = Image.new("RGBA", (diametre, diametre), (0, 0, 0, 0))
    draw = ImageDraw.Draw(medallion)

    # Bord extérieur doré
    draw.ellipse([1, 1, diametre - 2, diametre - 2], fill=(50, 25, 10, 255), outline=(212, 175, 55, 255), width=2)

    # Anneau d'or dégradé
    for i in range(2, pad):
        ratio = (i - 2) / max(1, pad - 2)
        r = int(255 * (1 - ratio) + 180 * ratio)
        g = int(220 * (1 - ratio) + 140 * ratio)
        b = int(90 * (1 - ratio) + 30 * ratio)
        draw.ellipse([i, i, diametre - 1 - i, diametre - 1 - i], outline=(r, g, b, 255), width=1)

    # Anneau intérieur sombre
    draw.ellipse([pad - 1, pad - 1, diametre - pad, diametre - pad], outline=(90, 60, 15, 255), width=1)

    # Coller l'image circulaire
    medallion.paste(im_resized, (pad, pad), mask)

    # Clous d'or décoratifs tout autour de l'anneau
    nb_clous = max(8, diametre // 15)
    r_centre = diametre / 2
    r_clous = diametre / 2 - pad / 2
    for k in range(nb_clous):
        ang = k * (2 * math.pi / nb_clous)
        kx = int(r_centre + math.cos(ang) * r_clous)
        ky = int(r_centre + math.sin(ang) * r_clous)
        draw.ellipse([kx - 2, ky - 2, kx + 2, ky + 2], fill=(255, 235, 130, 255), outline=(100, 70, 10, 255))
        draw.point((kx - 1, ky - 1), fill=(255, 255, 255, 255))

    return medallion


def charger_photo_romaine(nom_fichier, taille=None, style="or", medaillon=False):
    """
    Charge une image depuis assets/images, applique le cadre approprié
    et retourne un objet PhotoImage utilisable directement dans Tkinter.
    Met le résultat en cache.
    """
    cache_key = (nom_fichier, taille, style, medaillon)
    if cache_key in _PHOTO_CACHE:
        return _PHOTO_CACHE[cache_key]

    chemin = ASSETS_DIR / nom_fichier
    if not chemin.exists():
        return None

    try:
        im = Image.open(chemin)
        if taille:
            im = im.resize(taille, Image.Resampling.LANCZOS)

        if not ("_cadre" in nom_fichier or "_medaillon" in nom_fichier or nom_fichier.startswith("musee_")):
            if medaillon:
                d = min(taille) if taille else min(im.size)
                im = creer_cadre_medaillon(im, diametre=d, style=style)
            else:
                im = creer_cadre_antique(im, style=style, epaisseur=8, rivets=True)

        photo = ImageTk.PhotoImage(im)
        _PHOTO_CACHE[cache_key] = photo
        return photo
    except Exception as e:
        print(f"Erreur chargement image {nom_fichier}: {e}")
        return None
