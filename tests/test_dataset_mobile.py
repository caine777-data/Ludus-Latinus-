"""
Tests unitaires pour le dataset universel mobile (ludus_latinus_dataset.json).
Vérifie la validité du fichier exporté, l'intégrité des 26 mondes, des 113 leçons
et des modules (Thesaurus, Forum, Cartes, SRS).
"""

import json
import unittest
from pathlib import Path

project_root = Path(__file__).resolve().parent.parent
DATASET_PATH = project_root / "assets" / "data" / "ludus_latinus_dataset.json"


class TestDatasetMobile(unittest.TestCase):
    """Vérifie l'intégrité structurelle du fichier JSON universel pour l'application mobile."""

    @classmethod
    def setUpClass(cls):
        if not DATASET_PATH.exists():
            from scripts.exporter_dataset_mobile import exporter_dataset
            exporter_dataset(DATASET_PATH)

        with open(DATASET_PATH, encoding="utf-8") as f:
            cls.data = json.load(f)

    def test_metadata(self):
        meta = self.data.get("metadata", {})
        self.assertEqual(meta.get("app"), "Ludus Latinus")
        self.assertEqual(meta.get("total_classes"), 3)
        self.assertEqual(meta.get("total_mondes"), 26)
        self.assertEqual(meta.get("total_lecons"), 113)

    def test_classes_structure(self):
        classes = self.data.get("classes", [])
        self.assertEqual(len(classes), 3)
        class_ids = [c["id"] for c in classes]
        self.assertIn("5eme", class_ids)
        self.assertIn("4eme", class_ids)
        self.assertIn("3eme", class_ids)

    def test_mondes_and_lessons_count(self):
        mondes = self.data.get("mondes", [])
        self.assertEqual(len(mondes), 26)

        total_lecons = 0
        for m in mondes:
            self.assertIn("id", m)
            self.assertIn("title", m)
            self.assertIn("lessons", m)
            lessons = m["lessons"]
            self.assertGreaterEqual(len(lessons), 1)
            total_lecons += len(lessons)
            for les in lessons:
                self.assertIn("id", les)
                self.assertIn("type", les)
                self.assertIn("title", les)
                self.assertIn("content", les)

        self.assertEqual(total_lecons, 113)

    def test_thesaurus_export(self):
        thesaurus = self.data.get("thesaurus", {})
        dico = thesaurus.get("dictionnaire", [])
        self.assertGreaterEqual(len(dico), 50)
        self.assertIn("declinaisons", thesaurus)
        self.assertIn("conjugaisons", thesaurus)

    def test_forum_and_srs_export(self):
        forum = self.data.get("forum_monuments", [])
        self.assertEqual(len(forum), 6)
        srs = self.data.get("memoria_srs", [])
        self.assertGreaterEqual(len(srs), 25)

    def test_cartes_collection_export(self):
        cartes_col = self.data.get("cartes_collection", {})
        cartes = cartes_col.get("cartes", [])
        self.assertGreaterEqual(len(cartes), 24)
        self.assertIn("raretes", cartes_col)
        self.assertIn("categories", cartes_col)


if __name__ == "__main__":
    unittest.main()
