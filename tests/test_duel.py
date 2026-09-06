"""
Tests unitaires pour le Mode Duel à 2 Joueurs (app/duel.py).
"""

import os
import sys
import tkinter as tk
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.duel import QUESTIONS_DUEL, DuelWindow


class DummyApp:
    def __init__(self):
        self.C = {
            "bg": "#1a1b26",
            "card_bg": "#24283b",
            "fg": "#ffffff",
            "accent": "#ffd700",
            "gold": "#d4af37",
        }
        self.sesterces_ajoutes = 0

    def ajouter_sesterces(self, montant):
        self.sesterces_ajoutes += montant


class TestDuel(unittest.TestCase):

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

    def test_questions_structure_et_integrite(self):
        self.assertTrue(len(QUESTIONS_DUEL) >= 15, "Au moins 15 questions doivent être définies")
        for idx, q in enumerate(QUESTIONS_DUEL):
            with self.subTest(idx=idx):
                self.assertIn("q", q)
                self.assertIn("choix", q)
                self.assertIn("rep", q)
                self.assertIsInstance(q["choix"], list)
                self.assertEqual(len(q["choix"]), 3, f"La question {idx} doit avoir exactement 3 propositions")
                self.assertTrue(0 <= q["rep"] < len(q["choix"]), f"L'index de réponse pour question {idx} est invalide")
                self.assertTrue(bool(q["choix"][q["rep"]].strip()))

    def test_duel_window_initialisation_et_mecanique(self):
        if not self.root:
            self.skipTest("Tkinter display non disponible")

        app = DummyApp()
        fen = DuelWindow(self.root, app)

        self.assertEqual(fen.score_j1, 0)
        self.assertEqual(fen.score_j2, 0)
        self.assertEqual(fen.position_corde, 0)
        self.assertFalse(fen.bloque_j1)
        self.assertFalse(fen.bloque_j2)
        self.assertIsNotNone(fen.question_en_cours)
        self.assertEqual(len(fen.ordre_options), 3)

        # Simulation bonne réponse Joueur 1
        bonne_opt = fen.bonne_option_idx
        fen._traiter_reponse_joueur(1, bonne_opt)
        self.assertEqual(fen.score_j1, 1)
        self.assertEqual(fen.position_corde, 1)

        # Simulation mauvaise réponse Joueur 2
        mauvaise_opt = (bonne_opt + 1) % 3
        fen._traiter_reponse_joueur(2, mauvaise_opt)
        self.assertTrue(fen.bloque_j2)

        fen.destroy()


if __name__ == "__main__":
    unittest.main()
