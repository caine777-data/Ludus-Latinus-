"""
Tests unitaires pour la génération de fiches de révision et flashcards A4 / PDF (app/export_pdf.py).
"""

import os
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.export_pdf import (
    CAS_NOMS,
    FLASHCARDS_DATA,
    TABLE_DECLINAISONS,
    generer_css_print,
    generer_fichier_html,
    generer_html_fiche_synthese,
    generer_html_flashcards,
)


class TestExportPDF(unittest.TestCase):

    def test_donnees_declinaisons_completes(self):
        self.assertEqual(len(CAS_NOMS), 6)
        self.assertTrue(len(TABLE_DECLINAISONS) >= 4)
        for dec in TABLE_DECLINAISONS:
            with self.subTest(dec=dec["titre"]):
                self.assertIn("titre", dec)
                self.assertIn("modele", dec)
                self.assertEqual(len(dec["singulier"]), 6)
                self.assertEqual(len(dec["pluriel"]), 6)

    def test_flashcards_data_structure(self):
        self.assertEqual(len(FLASHCARDS_DATA), 8)
        for c in FLASHCARDS_DATA:
            with self.subTest(latin=c["latin"]):
                self.assertIn("latin", c)
                self.assertIn("sens", c)
                self.assertIn("citation", c)
                self.assertIn("traduction", c)
                self.assertIn("icon", c)

    def test_css_print_a4(self):
        css = generer_css_print()
        self.assertIn("@page", css)
        self.assertIn("size: A4", css)
        self.assertIn("@media print", css)

    def test_generer_html_fiche_synthese(self):
        html = generer_html_fiche_synthese()
        self.assertIn("<!DOCTYPE html>", html)
        self.assertIn("SENATVS POPVLVSQVE ROMANVS", html)
        self.assertIn("FICHE DE SYNTHÈSE", html)
        self.assertIn("declinaison-table", html)
        self.assertIn("Mini-Quiz", html)

    def test_generer_html_flashcards(self):
        html = generer_html_flashcards()
        self.assertIn("<!DOCTYPE html>", html)
        self.assertIn("PLANCHE DE FLASHCARDS", html)
        self.assertIn("grille-flashcards", html)
        self.assertIn("LUPUS", html)

    def test_creation_fichiers_sur_disque(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            p1 = generer_fichier_html("synthese", Path(tmpdir) / "fiche.html")
            self.assertTrue(p1.exists())
            self.assertGreater(p1.stat().st_size, 1000)

            p2 = generer_fichier_html("flashcards", Path(tmpdir) / "flash.html")
            self.assertTrue(p2.exists())
            self.assertGreater(p2.stat().st_size, 1000)


if __name__ == "__main__":
    unittest.main()
