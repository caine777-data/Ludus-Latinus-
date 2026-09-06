"""
Tests unitaires pour la mascotte Lupulus (app/mascotte.py).
"""

import os
import sys
import tkinter as tk
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.mascotte import (
    ASSETS_LUPULUS,
    CITATIONS_ERREUR,
    CITATIONS_SUCCES,
    COSTUMES_LUPULUS,
    REPLIQUES_CLIC,
    MascotteWidget,
)


class TestMascotteLupulus(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        if sys.platform == "darwin" and os.environ.get("GITHUB_ACTIONS"):
            cls.root = None
            return
        try:
            cls.root = tk.Tk()
            cls.root.withdraw()
        except Exception:
            cls.root = None

    @classmethod
    def tearDownClass(cls):
        if cls.root:
            try:
                cls.root.destroy()
            except Exception:
                pass

    def test_dossier_et_fichiers_assets_lupulus(self):
        self.assertTrue(ASSETS_LUPULUS.exists(), f"Le dossier {ASSETS_LUPULUS} doit exister")
        for emotion in ("normal", "joie", "reflexion", "aide", "triomphe"):
            f = ASSETS_LUPULUS / f"lupulus_{emotion}.png"
            self.assertTrue(f.exists(), f"L'asset {f.name} doit exister")

    def test_citations_non_vides(self):
        self.assertTrue(len(REPLIQUES_CLIC) >= 3)
        self.assertTrue(len(CITATIONS_SUCCES) >= 3)
        self.assertTrue(len(CITATIONS_ERREUR) >= 3)
        self.assertIn("standard", COSTUMES_LUPULUS)

    def test_widget_creation_et_emotions(self):
        if not self.root:
            self.skipTest("Tkinter display non disponible")
        widget = MascotteWidget(self.root, taille=80)
        self.assertEqual(widget.emotion_actuelle, "normal")

        widget.reagir_succes()
        self.assertEqual(widget.emotion_actuelle, "joie")

        widget.reagir_erreur()
        self.assertEqual(widget.emotion_actuelle, "aide")

        widget.reagir_reflexion()
        self.assertEqual(widget.emotion_actuelle, "reflexion")

        widget.reagir_triomphe()
        self.assertEqual(widget.emotion_actuelle, "triomphe")


if __name__ == "__main__":
    unittest.main()
