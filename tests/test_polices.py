"""
Tests du module des typographies et polices romaines antiques (app/polices.py).
"""

import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.polices import (
    CANDIDATS_CORPS,
    CANDIDATS_TITRES,
    detecter_famille,
    get_famille_corps,
    get_famille_titre,
    police_corps,
    police_monument,
    police_titre,
)


class TestPolicesRomaines(unittest.TestCase):

    def test_candidats_non_vides(self):
        self.assertTrue(len(CANDIDATS_TITRES) > 0)
        self.assertTrue(len(CANDIDATS_CORPS) > 0)
        self.assertIn("Palatino Linotype", CANDIDATS_TITRES)
        self.assertIn("Georgia", CANDIDATS_CORPS)

    def test_detecter_famille_fallback(self):
        # Quand aucune police n'est candidate disponible, renvoie le repli
        famille = detecter_famille(["PoliceInexistante123XYZ"], fallback="Palatino Linotype")
        self.assertEqual(famille, "Palatino Linotype")

    def test_get_famille_titre_et_corps(self):
        f_titre = get_famille_titre()
        f_corps = get_famille_corps()
        self.assertIsInstance(f_titre, str)
        self.assertIsInstance(f_corps, str)
        self.assertTrue(len(f_titre) > 0)
        self.assertTrue(len(f_corps) > 0)

    def test_police_titre_format(self):
        p = police_titre(18, gras=True)
        self.assertEqual(len(p), 3)
        self.assertEqual(p[1], 18)
        self.assertEqual(p[2], "bold")

    def test_police_corps_formats(self):
        p_normal = police_corps(12, gras=False, italique=False)
        self.assertEqual(p_normal[2], "normal")

        p_gras = police_corps(12, gras=True, italique=False)
        self.assertEqual(p_gras[2], "bold")

        p_ital = police_corps(12, gras=False, italique=True)
        self.assertEqual(p_ital[2], "italic")

        p_both = police_corps(12, gras=True, italique=True)
        self.assertEqual(p_both[2], "bold italic")

    def test_police_monument(self):
        p_monument = police_monument(24)
        self.assertEqual(p_monument[1], 24)
        self.assertEqual(p_monument[2], "bold")


if __name__ == "__main__":
    unittest.main()
