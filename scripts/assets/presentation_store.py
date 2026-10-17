"""Image de présentation Play Store (1024 x 500) et mise au format des captures.

Usage, depuis ludus_latinus_mobile/ :
    python ../scripts/assets/presentation_store.py
    python ../scripts/assets/presentation_store.py captures <dossier des captures brutes>

L'image part d'une illustration de leçon (Pline face au Vésuve) : son côté gauche,
la baie et le ciel, est assez calme pour porter le titre sous un voile pourpre.
"""

import sys

from PIL import Image, ImageDraw, ImageFont

ILLUSTRATION = "assets/images/lecons/lecon_m21-03.jpg"
SORTIE = "store/presentation_1024x500.png"


def presentation():
    fond = Image.open(ILLUSTRATION).convert("RGB")
    ratio = 1024 / fond.width
    fond = fond.resize((1024, round(fond.height * ratio)), Image.LANCZOS)
    haut = (fond.height - 500) // 2
    fond = fond.crop((0, haut, 1024, haut + 500))

    # Voile pourpre dégradé vers la droite : le titre reste lisible sans masquer l'élève.
    voile = Image.new("RGBA", (1024, 500))
    dessin = ImageDraw.Draw(voile)
    for x in range(1024):
        alpha = int(225 * max(0, 1 - x / 600) ** 1.3)
        dessin.line([(x, 0), (x, 500)], fill=(55, 8, 22, alpha))
    image = Image.alpha_composite(fond.convert("RGBA"), voile)

    dessin = ImageDraw.Draw(image)
    titre = ImageFont.truetype("assets/fonts/Cinzel-VariableFont_wght.ttf", 66)
    titre.set_variation_by_name("Bold")
    sous_titre = ImageFont.truetype("assets/fonts/PlusJakartaSans-VariableFont_wght.ttf", 29)
    sous_titre.set_variation_by_name("SemiBold")
    dessin.text((56, 182), "Ludus Latinus", font=titre, fill=(246, 214, 140))
    dessin.text((60, 268), "Le latin du collège,", font=sous_titre, fill=(255, 248, 235))
    dessin.text((60, 306), "de la 5e à la 3e", font=sous_titre, fill=(255, 248, 235))
    image.convert("RGB").save(SORTIE)


def captures(source):
    """Captures d'émulateur 1080 x 2400 vers 1200 x 2400.

    Google Play refuse un côté plus de deux fois plus long que l'autre. On élargit en
    prolongeant la première et la dernière colonne : rien n'est coupé ni déformé.
    """
    ordre = ["03_lecon", "02_via", "06_duel", "04_exercice",
             "08_pantheon", "01_accueil", "10_thesaurus", "09_taverne"]
    for rang, nom in enumerate(ordre, 1):
        image = Image.open(f"{source}/{nom}.png").convert("RGB")
        largeur, hauteur = image.size
        marge = (1200 - largeur) // 2
        toile = Image.new("RGB", (1200, hauteur))
        toile.paste(image.crop((0, 0, 1, hauteur)).resize((marge, hauteur)), (0, 0))
        toile.paste(image, (marge, 0))
        toile.paste(image.crop((largeur - 1, 0, largeur, hauteur)).resize((marge, hauteur)), (marge + largeur, 0))
        toile.save(f"store/captures/{rang:02d}_{nom[3:]}.png")


if __name__ == "__main__":
    if len(sys.argv) > 2 and sys.argv[1] == "captures":
        captures(sys.argv[2])
    else:
        presentation()
