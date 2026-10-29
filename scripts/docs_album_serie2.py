"""Écrit docs/propositions/illustrations_album_serie2.md à partir de
content/album_serie2.py : anecdotes à relire et prompts d'illustration.

Les textes vivent dans le fichier de données ; ce document n'en est qu'une
vue, à regénérer après chaque correction.
Usage : python scripts/docs_album_serie2.py
"""

import sys
from pathlib import Path

RACINE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(RACINE))
from content.album_serie2 import ADVERSAIRES, CARTES_SERIE2, PRIX_PAR_RARETE  # noqa: E402

RARETE = {"commune": "commune", "rare": "rare", "epique": "épique", "legendaire": "légendaire"}
FAMILLE = {"heros": "héros", "divinites": "dieux", "monstres": "créatures", "monuments": "monuments"}

# Même fin de prompt que la série 1 : les deux séries doivent se ressembler.
STYLE_CARTE = ("Illustration 3D douce et chaleureuse, façon film d'animation, couleurs dorées et pourpres, "
               "lumière de fin d'après-midi. Format portrait 3:4, sujet centré, décor simple et légèrement "
               "flou. Pas de sang, pas de violence montrée. Aucun texte, aucune lettre, aucun chiffre dans "
               "l'image.")

VIDEO_CLEOPATRE = (
    "Plan vertical 9:16, film d'animation 3D doux et chaleureux. Dans la salle du trône d'un palais "
    "d'Alexandrie, colonnes peintes de lotus, voilages blancs, vue sur le Nil et le phare au loin, "
    "Cléopâtre VII, jeune reine d'Égypte au regard vif et rusé, coiffure noire au carré, diadème d'or "
    "en forme de cobra, robe blanche et large collier d'or et de lapis-lazuli, est assise sur un trône "
    "doré. Elle sourit avec assurance, fait apparaître d'un geste cinq grandes cartes dont on ne voit "
    "que le dos doré, les étale en éventail puis les tend vers la caméra comme pour lancer un défi. La "
    "caméra avance lentement vers elle. Lumière chaude du soir, reflets dorés. Le tiers bas de l'image "
    "reste sur le dallage de marbre. Aucun texte, aucune lettre, aucun chiffre, aucune image sur les "
    "cartes.")


def obtention(carte):
    if carte.get("achat"):
        return f"Achat à la Taberna : {PRIX_PAR_RARETE[carte['rarete']]} HS"
    return f"Succès : {carte['texte']}"


def main():
    lignes = [
        "# Illustrations et anecdotes de l'album, série 2",
        "",
        "Proposition de l'architecte (29/10/2026). Catalogue validé par Cédric le même jour "
        "(`docs/propositions/album_serie2.md`). Document généré par `scripts/docs_album_serie2.py` "
        "depuis `content/album_serie2.py` : les corrections se font dans ce fichier de données.",
        "",
        "## Consignes",
        "",
        "- 32 images de cartes, format **3:4** (portrait), même style que la série 1.",
        "- 2 portraits d'adversaires pour l'écran de choix, format 3:4.",
        "- 1 vidéo d'entrée de Cléopâtre, format 9:16 (facultative), comme celle de Crassus.",
        "- Déposer dans « gemini ludus » sous le nom indiqué (JPG ou PNG) : l'architecte les convertit "
        "en WebP et les branche.",
        "- Tant qu'une carte n'a pas son image, l'appli affiche une icône sur la couleur de sa rareté.",
        "- Anecdotes et devises : à relire ; devises à faire relire aussi par le professeur de latin.",
        "",
        "## Les 32 cartes",
        "",
    ]
    for n, c in enumerate(CARTES_SERIE2, 1):
        lignes += [
            f"### {n}. {c['nom']} ({c['nom_latin']})",
            "",
            f"{FAMILLE[c['categorie']]} · {RARETE[c['rarete']]} · attaque {c['atk']}, défense {c['def']} · "
            f"{obtention(c)}  ",
            f"Fichier : `{c['id']}.jpg`",
            "",
            f"- Devise : *{c['citation']}* ({c['traduction']})",
            f"- Anecdote : {c['anecdote']}",
            "",
            "```",
            f"{c['scene']}. {STYLE_CARTE}",
            "```",
            "",
        ]
    lignes += ["## Les adversaires de la Bataille", ""]
    for a in ADVERSAIRES:
        lignes += [
            f"### Portrait : {a['nom']}",
            "",
            f"Fichier : `adversaire_{a['id']}.jpg`",
            "",
            "```",
            f"{a['scene']}. {STYLE_CARTE}",
            "```",
            "",
        ]
    lignes += [
        "### Vidéo d'entrée de Cléopâtre (facultative)",
        "",
        "Fichier : `bataille_cleopatre.mp4`, 9:16, 5 à 6 secondes. Jouée en ouvrant une Bataille "
        "contre elle, comme l'entrée de Crassus.",
        "",
        "```",
        VIDEO_CLEOPATRE,
        "```",
        "",
    ]
    dest = RACINE / "docs/propositions/illustrations_album_serie2.md"
    dest.write_text("\n".join(lignes), encoding="utf-8")
    print(dest, len(CARTES_SERIE2), "cartes")


if __name__ == "__main__":
    main()
