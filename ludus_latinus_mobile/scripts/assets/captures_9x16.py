"""
Met les captures téléphone du Play Store au format 9:16 exact.

Google n'accepte plus que du 16:9 ou du 9:16 ; nos captures font 1200 x 2400 (1:2).
On retire la barre d'état Android et la barre de gestes (inutiles sur la fiche),
puis on élargit l'image de quelques pixels en prolongeant ses bords, plutôt que
de couper du contenu de jeu en bas (boutons, clavier du Mot du jour).

Entrée : store/captures/*.png. Sortie : store/captures_9x16/ (originaux conservés).
"""
from pathlib import Path

from PIL import Image

RACINE = Path(__file__).resolve().parents[2] / "store"
SOURCE = RACINE / "captures"
CIBLE = RACINE / "captures_9x16"

# Mesuré sur les captures du 30/10 : l'heure de la barre d'état finit vers
# y = 85, la barre d'application commence vers y = 140 ; la barre de gestes
# occupe les 63 derniers pixels.
ROGNE_HAUT = 135
ROGNE_BAS = 73
HAUTEUR = 2400 - ROGNE_HAUT - ROGNE_BAS  # 2192 = 16 x 137
LARGEUR = HAUTEUR * 9 // 16  # 1233


def mettre_en_9x16(image: Image.Image) -> Image.Image:
    """Rogne les barres système puis élargit en recopiant les colonnes de bord."""
    largeur, hauteur = image.size
    coeur = image.crop((0, ROGNE_HAUT, largeur, hauteur - ROGNE_BAS))
    marge_gauche = (LARGEUR - largeur) // 2
    marge_droite = LARGEUR - largeur - marge_gauche
    sortie = Image.new("RGB", (LARGEUR, HAUTEUR))
    sortie.paste(coeur, (marge_gauche, 0))
    # Bords prolongés : sur fond crème ou sur une illustration, une bande de
    # 16 px recopiée ne se voit pas, contrairement à un aplat de couleur.
    gauche = coeur.crop((0, 0, 1, HAUTEUR)).resize((marge_gauche, HAUTEUR))
    droite = coeur.crop((largeur - 1, 0, largeur, HAUTEUR)).resize((marge_droite, HAUTEUR))
    sortie.paste(gauche, (0, 0))
    sortie.paste(droite, (marge_gauche + largeur, 0))
    return sortie


def main() -> None:
    CIBLE.mkdir(exist_ok=True)
    for chemin in sorted(SOURCE.glob("*.png")):
        image = Image.open(chemin).convert("RGB")
        if image.size != (1200, 2400):
            raise ValueError(f"{chemin.name} : taille inattendue {image.size}, mesures à refaire")
        mettre_en_9x16(image).save(CIBLE / chemin.name, optimize=True)
        print(chemin.name, "->", LARGEUR, "x", HAUTEUR)


if __name__ == "__main__":
    main()
