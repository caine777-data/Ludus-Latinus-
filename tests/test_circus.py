"""
Tests unitaires pour le mini-jeu Circus Maximus (app/circus.py).
"""

import os
import sys
import tkinter as tk
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.circus import QUESTIONS_CIRCUS, CircusMaximusWindow


class MockCircusApp:
    def __init__(self, sesterces=50):
        self.data = {
            "sesterces": sesterces,
            "heros": "Marcus",
            "classe_active": "5eme",
        }
        self.C = {
            "panel": "#1f2335",
            "accent": "#ffd700",
            "editor": "#1a1b26",
            "fg": "#ffffff",
            "muted": "#9aa5ce",
            "ok": "#2ecc71",
            "err": "#ef4444",
        }

    def ajouter_sesterces(self, montant):
        self.data["sesterces"] += montant


class TestCircusMaximus(unittest.TestCase):

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

    def test_questions_circus_valides(self):
        """Vérifie la cohérence du pool de questions du Circus Maximus."""
        self.assertGreaterEqual(len(QUESTIONS_CIRCUS), 10)
        for q in QUESTIONS_CIRCUS:
            self.assertIn("q", q)
            self.assertIn("rep", q)
            self.assertIn("fausses", q)
            self.assertEqual(len(q["fausses"]), 3)
            self.assertNotIn(q["rep"], q["fausses"])

    def test_circus_window_mecanique_complete(self):
        """Vérifie l'initialisation, la réponse correcte avec combo et le reset lors d'une erreur."""
        if not self.root:
            self.skipTest("Tkinter display non disponible")

        app = MockCircusApp()
        win = CircusMaximusWindow(self.root, app)
        self.assertTrue(win.winfo_exists())
        self.assertEqual(win.tour_joueur, 1)
        self.assertEqual(win.pos_joueur, 0.0)
        self.assertEqual(len(win.reponse_btns), 4)

        # 1. Test réponse correcte et combo boost
        rep_juste = win.current_q["rep"]
        pos_avant = win.pos_joueur
        combo_avant = win.combo_reponses

        win._verifier_reponse(rep_juste)

        self.assertGreater(win.pos_joueur, pos_avant)
        self.assertEqual(win.combo_reponses, combo_avant + 1)
        self.assertGreater(win.turbo_frames, 0)

        # 2. Test mauvaise réponse et reset du combo
        win.combo_reponses = 3
        win._verifier_reponse("Mauvaise Reponse Totalement Inexistante")
        self.assertEqual(win.combo_reponses, 0)

        win.destroy()
