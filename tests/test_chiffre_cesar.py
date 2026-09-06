"""
Tests unitaires pour le Chiffre de César (app/chiffre_cesar.py).
"""

import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.chiffre_cesar import (
    MISSIONS_CESAR,
    chiffrer_cesar,
    dechiffrer_cesar,
)


class TestChiffreCesar(unittest.TestCase):

    def test_chiffrement_classique_cle_3(self):
        # A -> D, B -> E, Z -> C
        self.assertEqual(chiffrer_cesar("ABC", 3), "DEF")
        self.assertEqual(chiffrer_cesar("XYZ", 3), "ABC")
        self.assertEqual(chiffrer_cesar("Caesar", 3), "Fdhvdu")

    def test_dechiffrement_cle_3(self):
        self.assertEqual(dechiffrer_cesar("DEF", 3), "ABC")
        self.assertEqual(dechiffrer_cesar("Fdhvdu", 3), "Caesar")

    def test_preservation_ponctuation_et_espaces(self):
        texte = "Veni, vidi, vici !"
        chiffre = chiffrer_cesar(texte, 5)
        self.assertEqual(dechiffrer_cesar(chiffre, 5), texte)

    def test_chaine_vide(self):
        self.assertEqual(chiffrer_cesar("", 3), "")
        self.assertEqual(dechiffrer_cesar("", 3), "")

    def test_missions_cesar_solubles(self):
        self.assertTrue(len(MISSIONS_CESAR) >= 3)
        for m in MISSIONS_CESAR:
            with self.subTest(mission=m["titre"]):
                sol = dechiffrer_cesar(m["chiffre"], m["cle"])
                self.assertEqual(sol, m["clair_attendu"])


if __name__ == "__main__":
    unittest.main()
