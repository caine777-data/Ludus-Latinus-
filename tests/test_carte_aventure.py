"""Tests unitaires pour la Carte d'Aventure de la Via Appia (app/carte.py)."""

import tkinter as tk
import unittest

from app.carte import CarteAventureWindow, calculer_offset_route, to_roman


class MockApp:
    def __init__(self, root):
        self.root = root
        self.data = {
            "completed": ["m1-01", "m1-02"],
            "echecs": {"m1-01": 0, "m1-02": 1},
            "classe_active": "5eme",
            "avatar": "garcon",
            "sesterces": 100,
        }
        self.C = {
            "bg": "#f5eedc",
            "panel": "#ebe1cc",
            "editor": "#ffffff",
            "fg": "#2c1d11",
            "accent": "#8b1e28",
            "sel_fg": "#ffffff",
            "btn_bg": "#d4af37",
            "btn_fg": "#2c1d11",
        }

    def _sauvegarder(self):
        pass

    def _rafraichir_selecteur_classe(self):
        pass

    def _populate_tree(self):
        pass

    def _refresh_badges(self):
        pass

    def _charger_item(self, item_id):
        self.dernier_item_charge = item_id


class TestCarteAventure(unittest.TestCase):

    def setUp(self):
        self.root = tk.Tk()
        self.root.withdraw()
        self.app = MockApp(self.root)

    def tearDown(self):
        try:
            self.root.destroy()
        except Exception:
            pass

    def test_to_roman(self):
        self.assertEqual(to_roman(1), "I")
        self.assertEqual(to_roman(2), "II")
        self.assertEqual(to_roman(3), "III")
        self.assertEqual(to_roman(4), "IV")
        self.assertEqual(to_roman(5), "V")
        self.assertEqual(to_roman(6), "VI")
        self.assertEqual(to_roman(9), "IX")
        self.assertEqual(to_roman(10), "X")
        self.assertEqual(to_roman(14), "XIV")
        self.assertEqual(to_roman(20), "XX")

    def test_calculer_offset_route(self):
        # Pour une arène de fin de monde (boss), l'offset doit être 0 (centré devant l'arc de triomphe)
        self.assertEqual(calculer_offset_route(5, 6, 0), 0.0)
        self.assertEqual(calculer_offset_route(5, 6, 1), 0.0)

        # L'offset doit alterner de direction entre les mondes pairs et impairs
        off_w0 = calculer_offset_route(1, 6, 0)
        off_w1 = calculer_offset_route(1, 6, 1)
        self.assertAlmostEqual(off_w0, -off_w1, places=3)

    def test_instanciation_et_rendu_carte(self):
        win = CarteAventureWindow(self.root, self.app)
        self.root.update_idletasks()
        self.root.update()

        # Vérifier que le canvas contient des éléments graphiques dessinés
        items = win.canvas.find_all()
        self.assertTrue(len(items) > 50, f"Le canvas doit contenir de nombreux éléments graphiques, trouvé: {len(items)}")

        # Vérifier que la borne active a été trouvée
        self.assertIsNotNone(win._active_milestone)
        lx, ly, r = win._active_milestone
        self.assertTrue(lx > 0 and ly > 0 and r > 0)

        # Changement de classe
        win._changer_classe("4eme")
        self.assertEqual(win.classe_active, "4eme")
        self.assertEqual(self.app.data["classe_active"], "4eme")

        win.destroy()


if __name__ == "__main__":
    unittest.main()
