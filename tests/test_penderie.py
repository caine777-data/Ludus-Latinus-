"""
Tests unitaires pour la Penderie de Lupulus et le système de Costumes (app/mascotte.py).
"""

import os
import sys
import tkinter as tk
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.mascotte import (
    COSTUMES_LUPULUS,
    MascotteWidget,
    PenderieLupulusDialog,
)


class MockApp:
    def __init__(self, sesterces=200):
        self.data = {
            "sesterces": sesterces,
            "lupulus_costume": "standard",
            "lupulus_costumes_debloques": ["standard"],
        }

    def ajouter_sesterces(self, montant):
        self.data["sesterces"] += montant

    def _refresh_header_stats(self):
        pass


class TestPenderieLupulus(unittest.TestCase):

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

    def test_catalogue_costumes(self):
        """Vérifie la définition des costumes antiques."""
        costumes_attendus = ["standard", "mercure", "imperator", "savant"]
        for cid in costumes_attendus:
            self.assertIn(cid, COSTUMES_LUPULUS)
            info = COSTUMES_LUPULUS[cid]
            self.assertIn("nom", info)
            self.assertIn("prix", info)
            self.assertIn("icone", info)
            self.assertIn("replique", info)

        self.assertEqual(COSTUMES_LUPULUS["standard"]["prix"], 0)
        self.assertEqual(COSTUMES_LUPULUS["mercure"]["prix"], 150)
        self.assertEqual(COSTUMES_LUPULUS["imperator"]["prix"], 250)
        self.assertEqual(COSTUMES_LUPULUS["savant"]["prix"], 100)

    def test_widget_badge_costume_et_changement(self):
        """Vérifie l'affichage du badge de costume sur le widget mascotte."""
        if not self.root:
            self.skipTest("Tkinter display non disponible")

        app = MockApp(sesterces=300)
        widget = MascotteWidget(self.root, app=app, taille=80)
        self.assertEqual(widget.costume_actuel, "standard")
        self.assertIn("Toge", widget.lbl_costume.cget("text"))

        # Changer de costume dans app
        app.data["lupulus_costume"] = "imperator"
        widget.rafraichir_costume()
        self.assertEqual(widget.costume_actuel, "imperator")
        self.assertIn("Lauriers", widget.lbl_costume.cget("text"))
        widget.destroy()

    def test_dialogue_penderie_achat_et_equipement(self):
        """Vérifie le fonctionnement de l'achat et de l'équipement dans le dialogue."""
        if not self.root:
            self.skipTest("Tkinter display non disponible")

        app = MockApp(sesterces=200)
        dialog = PenderieLupulusDialog(self.root, app)
        self.assertTrue(dialog.winfo_exists())

        # Achat de "mercure" (150 sesterces)
        dialog._acheter("mercure")
        self.assertEqual(app.data["lupulus_costume"], "mercure")
        self.assertIn("mercure", app.data["lupulus_costumes_debloques"])
        # Solde restant : 200 - 150 = 50
        self.assertEqual(app.data["sesterces"], 50)

        # Tentative d'achat de "imperator" (250 sesterces) -> solde insuffisant (50 < 250)
        dialog._acheter("imperator")
        self.assertNotIn("imperator", app.data["lupulus_costumes_debloques"])
        self.assertEqual(app.data["sesterces"], 50)

        # Équiper à nouveau "standard" (déjà possédé)
        dialog._equiper("standard")
        self.assertEqual(app.data["lupulus_costume"], "standard")

        dialog.destroy()


if __name__ == "__main__":
    unittest.main()
