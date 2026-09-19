"""
Script d'exportation universel du curriculum de Ludus Latinus.

Génère le dataset complet (26 mondes, 113 leçons, Thesaurus, Forum,
Cartes Mythologiques, Memoria SRS) au format JSON universel dans
assets/data/ludus_latinus_dataset.json pour l'application mobile et le web.
"""

import json
import re
import sys
from datetime import datetime
from pathlib import Path

# Ajouter la racine du projet au PYTHONPATH
project_root = Path(__file__).resolve().parent.parent
if str(project_root) not in sys.path:
    sys.path.insert(0, str(project_root))

from app.forum_imperiale import MONUMENTS_FORUM  # noqa: E402
from app.memoria_velox import VOCABULAIRE_SRS  # noqa: E402
from app.succes import CATALOGUE_SUCCES  # noqa: E402
from app.thesaurus import (  # noqa: E402
    DICTIONNAIRE_LATIN,
    TABLES_CONJUGAISONS,
    TABLES_DECLINAISONS,
)
from content import CLASSES, CURRICULUM, GLOSSAIRE  # noqa: E402
from content.cartes_data import CARTES_COLLECTION, CATEGORIES, RARETES  # noqa: E402


def _monde_du_mot(entree, curriculum):
    """Premier monde dont une leçon emploie le mot : sert aux exercices de vocabulaire."""
    if entree.get("monde"):
        return entree["monde"]
    latin = entree["latin"]
    if entree.get("cat") == "Devise":
        formes = [latin.lower()]
    else:
        formes = [latin.split(",")[0].split("(")[0].split("/")[0].strip().lower()]
    if entree.get("cat") == "Verbe" and "(" in latin:
        # Les leçons emploient surtout la 1re et la 3e personne : video, videt, vincit.
        premiere = latin.split("(")[1].split(",")[0].strip().lower()
        formes.append(premiere)
        if premiere.endswith("eo"):
            formes.append(premiere[:-1] + "t")
        elif premiere.endswith("io"):
            formes.append(premiere[:-1] + "t")
        elif premiere.endswith("o"):
            formes.append(premiere[:-1] + ("at" if formes[0].endswith("are") else "it"))
    formes = [f for f in formes if len(f) >= 3]
    for monde in curriculum:
        for lecon in monde.get("lessons", []):
            texte = json.dumps(lecon, ensure_ascii=False).lower()
            if any(re.search(r"(?<![a-zà-ÿ])" + re.escape(f) + r"(?![a-zà-ÿ])", texte) for f in formes):
                return monde["id"]
    return ""


def dictionnaire_avec_mondes(curriculum=None):
    curriculum = CURRICULUM if curriculum is None else curriculum
    return [{**e, "monde": _monde_du_mot(e, curriculum)} for e in DICTIONNAIRE_LATIN]


def exporter_dataset(dest_path=None) -> Path:
    """Extrait l'intégralité du contenu pédagogique et ludique dans un fichier JSON."""
    if dest_path is None:
        dest_path = project_root / "assets" / "data" / "ludus_latinus_dataset.json"

    dest_path = Path(dest_path)
    dest_path.parent.mkdir(parents=True, exist_ok=True)

    total_lecons = sum(len(w.get("lessons", [])) for w in CURRICULUM)

    dataset = {
        "metadata": {
            "app": "Ludus Latinus",
            "version": "1.0.0",
            "titre": "Dataset Pédagogique Universel — Cycle 4",
            "date_export": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            "total_classes": len(CLASSES),
            "total_mondes": len(CURRICULUM),
            "total_lecons": total_lecons,
            "total_cartes_collection": len(CARTES_COLLECTION),
            "total_mots_thesaurus": len(DICTIONNAIRE_LATIN),
            "total_monuments_forum": len(MONUMENTS_FORUM),
            "total_flashcards_srs": len(VOCABULAIRE_SRS),
        },
        "classes": [
            {
                "id": c_id,
                "titre": c_data["titre"],
                "sous_titre": c_data["sous_titre"],
                "icone": c_data["icone"],
                "description": c_data["description"],
                "mondes_ids": [w["id"] for w in c_data["curriculum"]],
            }
            for c_id, c_data in CLASSES.items()
        ],
        "mondes": CURRICULUM,
        "thesaurus": {
            "dictionnaire": dictionnaire_avec_mondes(),
            "declinaisons": TABLES_DECLINAISONS,
            "conjugaisons": TABLES_CONJUGAISONS,
        },
        "forum_monuments": MONUMENTS_FORUM,
        "memoria_srs": VOCABULAIRE_SRS,
        "cartes_collection": {
            "cartes": CARTES_COLLECTION,
            "raretes": RARETES,
            "categories": CATEGORIES,
        },
        "glossaire": GLOSSAIRE,
        "succes": CATALOGUE_SUCCES,
    }

    contenu_json = json.dumps(dataset, ensure_ascii=False, indent=2)
    dest_path.write_text(contenu_json, encoding="utf-8")

    try:
        sys.stdout.reconfigure(encoding="utf-8")
    except Exception:
        pass

    print(f"[OK] Dataset universel exporte avec succes vers : {dest_path}")
    print(f"  - Mondes : {len(CURRICULUM)} ({len(CLASSES)} classes)")
    print(f"  - Lecons & Exercices : {total_lecons}")
    print(f"  - Thesaurus latin : {len(DICTIONNAIRE_LATIN)} entrees")
    print(f"  - Cartes Mythologiques : {len(CARTES_COLLECTION)}")
    print(f"  - Monuments du Forum : {len(MONUMENTS_FORUM)}")
    print(f"  - Taille du fichier : {len(contenu_json) / 1024:.1f} Ko")

    return dest_path


if __name__ == "__main__":
    exporter_dataset()
