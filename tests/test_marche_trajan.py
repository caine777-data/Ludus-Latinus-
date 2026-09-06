"""
Tests unitaires pour le Marché de Trajan et la conversion en chiffres romains (app/marche_trajan.py).
"""

import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.marche_trajan import (
    ARTICLES_MARCHE,
    arabe_en_romain,
    romain_en_arabe,
)


class TestMarcheTrajan(unittest.TestCase):

    def test_arabe_en_romain_valeurs_cles(self):
        tests = [
            (1, "I"),
            (4, "IV"),
            (5, "V"),
            (9, "IX"),
            (10, "X"),
            (14, "XIV"),
            (25, "XXV"),
            (40, "XL"),
            (49, "XLIX"),
            (50, "L"),
            (90, "XC"),
            (99, "XCIX"),
            (100, "C"),
            (400, "CD"),
            (500, "D"),
            (900, "CM"),
            (1000, "M"),
            (2026, "MMXXVI"),
        ]
        for nb, attendu in tests:
            with self.subTest(nb=nb):
                self.assertEqual(arabe_en_romain(nb), attendu)

    def test_romain_en_arabe_valeurs_cles(self):
        tests = [
            ("I", 1),
            ("IV", 4),
            ("IX", 9),
            ("XXV", 25),
            ("XLIX", 49),
            ("L", 50),
            ("C", 100),
            ("MCMXCIV", 1994),
            ("MMXXVI", 2026),
        ]
        for rom, attendu in tests:
            with self.subTest(rom=rom):
                self.assertEqual(romain_en_arabe(rom), attendu)

    def test_articles_marche_bien_formes(self):
        self.assertTrue(len(ARTICLES_MARCHE) >= 5)
        for a in ARTICLES_MARCHE:
            self.assertIn("nom", a)
            self.assertIn("prix", a)
            self.assertIn("latin", a)
            self.assertTrue(a["prix"] > 0)


if __name__ == "__main__":
    unittest.main()
