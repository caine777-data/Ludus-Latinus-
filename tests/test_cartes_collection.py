"""
Tests unitaires pour l'Album de Cartes Mythologiques (content/cartes_data.py et app/cartes_collection.py).
"""

import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from content.cartes_data import (
    CARTES_COLLECTION,
    CATEGORIES,
    INDEX_CARTES,
    RARETES,
    tirage_booster,
)


class TestCartesCollection(unittest.TestCase):

    def test_nombre_de_cartes(self):
        self.assertEqual(len(CARTES_COLLECTION), 24, "L'album doit contenir exactement 24 cartes")

    def test_categories_valides(self):
        for c in CARTES_COLLECTION:
            with self.subTest(carte=c["id"]):
                self.assertIn(c["categorie"], CATEGORIES)
                self.assertIn(c["rarete"], RARETES)
                self.assertTrue(len(c["nom"]) > 0)
                self.assertTrue(len(c["nom_latin"]) > 0)
                self.assertTrue(len(c["citation"]) > 0)
                self.assertTrue(c["atk"] > 0)
                self.assertTrue(c["def"] > 0)

    def test_index_cartes(self):
        self.assertEqual(len(INDEX_CARTES), 24)
        self.assertIn("div_jupiter", INDEX_CARTES)
        self.assertIn("mon_cerbere", INDEX_CARTES)
        self.assertIn("her_hercule", INDEX_CARTES)
        self.assertIn("mon_cesar", INDEX_CARTES)

    def test_tirage_booster(self):
        booster = tirage_booster(3)
        self.assertEqual(len(booster), 3)
        for c in booster:
            self.assertIn(c["id"], INDEX_CARTES)
        # Chaque booster doit contenir au moins une carte Rare ou supérieure
        raretes_obtenues = {c["rarete"] for c in booster}
        self.assertTrue(bool(raretes_obtenues.intersection({"rare", "epique", "legendaire"})))


if __name__ == "__main__":
    unittest.main()
