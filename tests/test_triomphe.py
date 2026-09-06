"""
Tests unitaires pour la remise de badge et la célébration du Triomphe de 5ème.
"""

import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.musee import CARTES_MUSEE
from app.triomphe import diplome_triomphe_html


class TestTriomphe(unittest.TestCase):

    def test_diplome_html_garcon(self):
        html = diplome_triomphe_html("Marcus", "garcon", 450, "06/09/2026")
        self.assertIn("Marcus", html)
        self.assertIn("IMPERATOR", html)
        self.assertIn("450 Sesterces d'Or", html)
        self.assertIn("SENATVS POPVLVSQVE ROMANVS", html)
        self.assertIn("Corona Triumphalis", html)

    def test_diplome_html_fille(self):
        html = diplome_triomphe_html("Julia", "fille", 300, "06/09/2026")
        self.assertIn("Julia", html)
        self.assertIn("IMPERATRIX", html)
        self.assertIn("300 Sesterces d'Or", html)

    def test_carte_musee_laurier_or(self):
        ids = [c["id"] for c in CARTES_MUSEE]
        self.assertIn("laurier_or_5eme", ids)
        carte = next(c for c in CARTES_MUSEE if c["id"] == "laurier_or_5eme")
        self.assertEqual(carte["icone"], "👑")
        self.assertIn("Corona Triumphalis", carte["texte"])


if __name__ == "__main__":
    unittest.main()
