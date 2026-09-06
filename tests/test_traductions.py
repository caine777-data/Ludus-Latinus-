"""
Tests du mécanisme de traduction du contenu des leçons.
"""

import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from content import CURRICULUM, find_lesson, traduit


class TestChampTraduit(unittest.TestCase):

    LECON = {"title": "Bonjour", "title_en": "Hello", "content": "Texte"}

    def test_langue_traduite(self):
        self.assertEqual(traduit(self.LECON, "title", "en"), "Hello")

    def test_francais_par_defaut(self):
        self.assertEqual(traduit(self.LECON, "title"), "Bonjour")
        self.assertEqual(traduit(self.LECON, "title", "fr"), "Bonjour")

    def test_repli_quand_la_traduction_manque(self):
        """Une leçon non traduite doit rester lisible, pas disparaître."""
        self.assertEqual(traduit(self.LECON, "content", "en"), "Texte")

    def test_langue_inconnue_retombe_sur_le_francais(self):
        self.assertEqual(traduit(self.LECON, "title", "klingon"), "Bonjour")

    def test_champ_absent(self):
        self.assertIsNone(traduit(self.LECON, "inexistant", "en"))
        self.assertEqual(traduit(self.LECON, "inexistant", "en", []), [])

    def test_element_absent(self):
        self.assertIsNone(traduit(None, "title", "en"))

    def test_traduction_vide_ne_masque_pas_le_francais(self):
        lecon = {"title": "Bonjour", "title_en": ""}
        self.assertEqual(traduit(lecon, "title", "en"), "Bonjour")


if __name__ == "__main__":
    unittest.main()
