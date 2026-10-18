"""Convertit en WebP les illustrations de leçon et les cartes de l'album.

Exception à la règle « pas de recompression », décidée par Cédric le 18/10/2026 :
ces images pesaient 66 Mo (leçons) et environ 26 Mo (cartes), assez pour faire
renoncer des familles au téléchargement. Qualité 90 : 4 à 7 fois plus léger,
écart à l'original d'environ 40 dB (PSNR), invisible à l'œil, vérifié sur détail
agrandi. Les originaux restent dans « gemini ludus ».

Usage, depuis ludus_latinus_mobile/ :
    python ../scripts/assets/webp_illustrations.py <dossier> [<dossier> ...]
Chaque .jpg du dossier devient un .webp du même nom ; le .jpg est supprimé.
"""

import sys
from pathlib import Path

from PIL import Image

QUALITE = 90


def convertir(dossier: Path) -> tuple[int, int, int]:
    nombre = avant = apres = 0
    for jpg in sorted(dossier.glob("*.jpg")):
        webp = jpg.with_suffix(".webp")
        with Image.open(jpg) as image:
            image.convert("RGB").save(webp, "WEBP", quality=QUALITE, method=6)
        avant += jpg.stat().st_size
        apres += webp.stat().st_size
        jpg.unlink()
        nombre += 1
    return nombre, avant, apres


if __name__ == "__main__":
    for nom in sys.argv[1:]:
        n, avant, apres = convertir(Path(nom))
        if n:
            print(f"{nom} : {n} images, {avant / 1e6:.1f} Mo -> {apres / 1e6:.1f} Mo")
        else:
            print(f"{nom} : aucune image .jpg")
