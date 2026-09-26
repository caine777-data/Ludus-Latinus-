"""Transforme les vidéos de Lupulus (fond vert) en WebP animés transparents.

Source : Téléchargements/LATIN_LEARN/gemini ludus/lupulus_<humeur>.mp4
Sortie : ludus_latinus_mobile/assets/images/animated/<nom>.webp

Un WebP animé garde la transparence et boucle tout seul dans un simple
Image.asset : pas de lecteur vidéo, pas de son, environ 300 Ko par animation.
La piste audio générée par Gemini est donc volontairement abandonnée.

Usage : python scripts/assets/lupulus_videos.py [humeur ...]
        (sans argument : attente, joie, reflexion, salut, triomphe)
Dépendances d'outillage (pas de l'app) : pip install imageio-ffmpeg numpy pillow
"""

import subprocess
import sys
import tempfile
from pathlib import Path

import imageio_ffmpeg
import numpy as np
from PIL import Image, ImageFilter

SOURCE = Path(r"C:\Users\caine\Downloads\LATIN_LEARN\gemini ludus")
DEST = Path(__file__).resolve().parents[2] / "ludus_latinus_mobile" / "assets" / "images" / "animated"

# Nom du fichier produit : « attente » remplace l'ancienne animation de repos.
SORTIES = {
    "attente": "lupulus_idle",
    "joie": "lupulus_joie",
    "reflexion": "lupulus_reflexion",
    "salut": "lupulus_salut",
    "triomphe": "lupulus_triomphe",
}

TAILLE = 200   # côté du carré : Lupulus s'affiche au plus à ~60 dp (x3 en haute densité)
IMAGES_PAR_SECONDE = 10
MARGE = 0.06


def extraire_images(video, dossier):
    ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
    subprocess.run(
        [ffmpeg, "-v", "error", "-i", str(video), "-an", "-vf", f"fps={IMAGES_PAR_SECONDE}",
         str(Path(dossier) / "f_%04d.png")],
        check=True,
    )
    return sorted(Path(dossier).glob("f_*.png"))


def masque_fond(rgb, fond):
    """Alpha 0..1 : distance à la couleur de fond, transition douce entre 55 et 130."""
    d = np.sqrt(((rgb - fond) ** 2).sum(axis=2))
    alpha = np.clip((d - 55) / (130 - 55), 0, 1)
    # Bandes noires ajoutées par le générateur sur certaines vidéos : fond, elles
    # aussi. Seulement les colonnes entièrement noires : les pupilles et la
    # truffe de Lupulus sont presque noires et doivent rester opaques.
    # (98 % de la colonne suffit : la compression laisse du bruit au bord des bandes.)
    colonnes_noires = (rgb.max(axis=2) < 30).mean(axis=0) > 0.98
    alpha[:, colonnes_noires] = 0
    return alpha


def detourer(chemin):
    rgb = np.asarray(Image.open(chemin).convert("RGB")).astype(np.float32)
    h, w, _ = rgb.shape
    coins = np.concatenate([rgb[:10, w // 2 - 20:w // 2 + 20].reshape(-1, 3),
                            rgb[-10:, w // 2 - 20:w // 2 + 20].reshape(-1, 3)])
    fond = np.median(coins[coins.max(axis=1) > 40], axis=0)
    alpha = masque_fond(rgb, fond)

    # Érosion + adoucissement du masque : supprime la frange verte du contour.
    a = Image.fromarray((alpha * 255).astype(np.uint8))
    a = a.filter(ImageFilter.MinFilter(5)).filter(ImageFilter.GaussianBlur(1))
    alpha = np.asarray(a).astype(np.float32) / 255

    # Anti-reflet vert, seulement au bord du sujet (pas sur un vert voulu).
    bord = (alpha > 0.02) & (np.asarray(a.filter(ImageFilter.MinFilter(9))) < 250)
    plafond = np.maximum(rgb[..., 0], rgb[..., 2])
    rgb[..., 1] = np.where(bord & (rgb[..., 1] > plafond), plafond, rgb[..., 1])

    rgba = np.dstack([rgb, alpha * 255]).clip(0, 255).astype(np.uint8)
    return Image.fromarray(rgba, "RGBA")


def cadre_commun(images):
    """Un seul cadrage pour toute l'animation, sinon le personnage sautillerait."""
    boites = [im.getchannel("A").point(lambda v: 255 if v > 30 else 0).getbbox() for im in images]
    boites = [b for b in boites if b]
    x0 = min(b[0] for b in boites)
    y0 = min(b[1] for b in boites)
    x1 = max(b[2] for b in boites)
    y1 = max(b[3] for b in boites)
    cote = int(max(x1 - x0, y1 - y0) * (1 + 2 * MARGE))
    cx, cy = (x0 + x1) // 2, (y0 + y1) // 2
    return (cx - cote // 2, cy - cote // 2, cx - cote // 2 + cote, cy - cote // 2 + cote)


def convertir(humeur):
    video = SOURCE / f"lupulus_{humeur}.mp4"
    if not video.exists():
        print(f"[MANQUE] {video.name}")
        return
    with tempfile.TemporaryDirectory() as dossier:
        images = [detourer(f) for f in extraire_images(video, dossier)]
    boite = cadre_commun(images)
    finales = []
    for im in images:
        carre = Image.new("RGBA", (boite[2] - boite[0], boite[3] - boite[1]), (0, 0, 0, 0))
        carre.paste(im, (-boite[0], -boite[1]), im)
        finales.append(carre.resize((TAILLE, TAILLE), Image.LANCZOS))

    DEST.mkdir(parents=True, exist_ok=True)
    sortie = DEST / f"{SORTIES[humeur]}.webp"
    finales[0].save(
        sortie, "WEBP", save_all=True, append_images=finales[1:],
        duration=round(1000 / IMAGES_PAR_SECONDE), loop=0, quality=72, method=6,
    )
    print(f"[OK] {sortie.name}  {len(finales)} images, {sortie.stat().st_size // 1024} Ko")


if __name__ == "__main__":
    for h in sys.argv[1:] or list(SORTIES):
        convertir(h)
