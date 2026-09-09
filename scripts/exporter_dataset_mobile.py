"""
Script d'exportation universel du curriculum de Ludus Latinus.

Génère le dataset complet (26 mondes, 113 leçons, Thesaurus, Forum,
Cartes Mythologiques, Memoria SRS) au format JSON universel dans
assets/data/ludus_latinus_dataset.json pour l'application mobile et le web.
"""

import json
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
            "dictionnaire": DICTIONNAIRE_LATIN,
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
