"""Habillage des jeux du Ludi (24-25/10/2026) : Gaius et sa taverne, fond du
Mot du jour, sceau de César, bannière animée de Paires éclair, portraits des
clients du Marché.

Les images fixes passent en WebP (Gemini les livre en JPEG nommé .webp).
Les deux vidéos deviennent des WebP animés en boucle simple : elles reviennent
d'elles-mêmes à leur pose de départ, et un rire joué à l'envers (l'aller-retour
des boss du Colisée) sonnerait faux.

Usage : python scripts/assets/ludi_habillage.py
Dépendances d'outillage (pas de l'app) : python -m pip install pillow imageio-ffmpeg
"""

import subprocess
import tempfile
from pathlib import Path

import imageio_ffmpeg
from PIL import Image

SOURCE = Path(r"C:\Users\caine\Downloads\LATIN_LEARN\gemini ludus")
IMAGES = Path(__file__).resolve().parents[2] / "ludus_latinus_mobile" / "assets" / "images"

# Fichier Gemini -> (sortie, largeur maximale en pixels).
FIXES = {
    "gaius": ("taverne/gaius.webp", 512),
    "fond_taverne": ("taverne/fond_taverne.webp", 768),
    "fond_bibliotheque": ("mot_du_jour/fond_bibliotheque.webp", 768),
    "sceau_victoire": ("cesar/sceau_victoire.webp", 512),
}

# Portraits des clients du Marché (1024 x 1024, buste) : carré serré sur le
# visage, pour le médaillon rond de 54 points (192 px = 3,5x).
CLIENTS = ["centurion", "senateur", "vestale", "fermier", "negociante", "general", "patricienne", "philosophe"]
ZONE_VISAGE = (172, 40, 852, 720)
COTE_CLIENT = 192

# Vidéo Gemini -> (sortie, zone gardée (x0, y0, x1, y1), largeur de sortie, images/s).
ANIMATIONS = {
    # 720 x 1280 : de la tête au gobelet, en 3:4, pour la zone de Gaius.
    "gaius_anime": ("taverne/gaius_anime.webp", (0, 40, 720, 1000), 240, 10),
    # 1280 x 720 : toute la scène, à la largeur de la bannière sur téléphone.
    "banniere_mercure": ("paires/banniere_mercure_anime.webp", (0, 0, 1280, 720), 560, 10),
}


def image_fixe(nom, sortie, largeur):
    im = Image.open(SOURCE / f"{nom}.webp").convert("RGB")
    if im.width > largeur:
        im = im.resize((largeur, round(im.height * largeur / im.width)), Image.LANCZOS)
    chemin = IMAGES / sortie
    chemin.parent.mkdir(parents=True, exist_ok=True)
    im.save(chemin, "WEBP", quality=85, method=6)
    print(f"[OK] {sortie}  {im.size}  {chemin.stat().st_size // 1024} Ko")


def animation(nom, sortie, zone, largeur, ips):
    x0, y0, x1, y1 = zone
    hauteur = round((y1 - y0) * largeur / (x1 - x0))
    with tempfile.TemporaryDirectory() as dossier:
        subprocess.run(
            [imageio_ffmpeg.get_ffmpeg_exe(), "-v", "error", "-i", str(SOURCE / f"{nom}.mp4"),
             "-an", "-vf", f"fps={ips}", str(Path(dossier) / "f_%03d.png")],
            check=True,
        )
        images = [
            Image.open(f).convert("RGB").crop(zone).resize((largeur, hauteur), Image.LANCZOS)
            for f in sorted(Path(dossier).glob("f_*.png"))
        ]
    chemin = IMAGES / sortie
    chemin.parent.mkdir(parents=True, exist_ok=True)
    images[0].save(
        chemin, "WEBP", save_all=True, append_images=images[1:],
        duration=round(1000 / ips), loop=0, quality=62, method=6,
    )
    print(f"[OK] {sortie}  {len(images)} images {largeur}x{hauteur}, {chemin.stat().st_size // 1024} Ko")


def portrait_client(nom):
    im = Image.open(SOURCE / f"client_{nom}.jpg").convert("RGB").crop(ZONE_VISAGE)
    im = im.resize((COTE_CLIENT, COTE_CLIENT), Image.LANCZOS)
    chemin = IMAGES / "marche" / f"client_{nom}.webp"
    chemin.parent.mkdir(parents=True, exist_ok=True)
    im.save(chemin, "WEBP", quality=85, method=6)
    print(f"[OK] marche/client_{nom}.webp  {chemin.stat().st_size // 1024} Ko")


def main():
    for nom, (sortie, largeur) in FIXES.items():
        image_fixe(nom, sortie, largeur)
    for nom, (sortie, zone, largeur, ips) in ANIMATIONS.items():
        animation(nom, sortie, zone, largeur, ips)
    for nom in CLIENTS:
        portrait_client(nom)


if __name__ == "__main__":
    main()
