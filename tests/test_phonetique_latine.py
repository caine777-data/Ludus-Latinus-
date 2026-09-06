"""
Tests unitaires pour le moteur de phonétique latine classique (app/phonetique_latine.py).
"""

import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.phonetique_latine import (
    determiner_accent_tonique,
    transcrire_latin_phonetique,
)


class TestPhonetiqueLatine(unittest.TestCase):

    def test_c_toujours_dur(self):
        # Cicero -> Kikero
        trans = transcrire_latin_phonetique("Cicero")
        self.assertTrue(trans.lower().startswith("k") or "qu" in trans.lower() or "kikero" in trans.lower())

    def test_caesar_diphtongue(self):
        trans = transcrire_latin_phonetique("Caesar")
        self.assertTrue("k" in trans.lower())

    def test_v_consonne(self):
        # Veni, vidi, vici
        trans = transcrire_latin_phonetique("Veni vidi vici")
        self.assertTrue("ou" in trans.lower() or "w" in trans.lower())

    def test_chaine_vide(self):
        self.assertEqual(transcrire_latin_phonetique(""), "")

    def test_determiner_accent_tonique(self):
        # Mot de 2 syllabes (Ro-ma) -> première syllabe (indice 0)
        self.assertEqual(determiner_accent_tonique("Roma"), 0)
        self.assertEqual(determiner_accent_tonique("lupus"), 0)

        # Mot de 3 syllabes
        accent = determiner_accent_tonique("amicus")
        self.assertIn(accent, (0, 1))


if __name__ == "__main__":
    unittest.main()
