"""
Tests unitaires pour le module app.cadres (cadres romains antiques, médaillons et styles).
"""

import os
from pathlib import Path
import sys
import unittest
from PIL import Image

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.cadres import (
    creer_cadre_antique,
    creer_cadre_medaillon,
    charger_photo_romaine,
    STYLES_CADRES
)


class TestCadresRomains(unittest.TestCase):

    def setUp(self):
        self.img_test = Image.new("RGB", (100, 80), (120, 100, 80))

    def test_styles_disponibles(self):
        for style in ("or", "arene", "marbre", "bronze"):
            self.assertIn(style, STYLES_CADRES)
            self.assertIn("ext", STYLES_CADRES[style])
            self.assertIn("biseau_h", STYLES_CADRES[style])

    def test_creer_cadre_antique_dimensions(self):
        epaisseur = 8
        framed = creer_cadre_antique(self.img_test, style="or", epaisseur=epaisseur, rivets=True)
        self.assertEqual(framed.size, (100 + epaisseur * 2, 80 + epaisseur * 2))
        self.assertEqual(framed.mode, "RGBA")

    def test_creer_cadre_antique_styles(self):
        for style in ("or", "arene", "marbre", "bronze"):
            framed = creer_cadre_antique(self.img_test, style=style, epaisseur=6)
            self.assertEqual(framed.size, (112, 92))

    def test_creer_cadre_medaillon(self):
        diam = 120
        med = creer_cadre_medaillon(self.img_test, diametre=diam, style="or")
        self.assertEqual(med.size, (diam, diam))
        self.assertEqual(med.mode, "RGBA")

    def test_charger_photo_romaine_fichier_inexistant(self):
        res = charger_photo_romaine("fichier_qui_nexiste_pas_1234.png")
        self.assertIsNone(res)


if __name__ == "__main__":
    unittest.main()
