"""
Tests unitaires pour le module de réactivité responsive app/responsive.py.
"""

import os
import sys
import tkinter as tk
import unittest
from unittest.mock import MagicMock

from app.responsive import adapter_geometrie_fenetre, lier_wraplength_dynamique


class TestResponsive(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if sys.platform == "darwin" and os.environ.get("GITHUB_ACTIONS"):
            cls.has_tk = False
            cls.root = None
            return
        try:
            cls.root = tk.Tk()
            cls.root.withdraw()
            cls.has_tk = True
        except Exception:
            cls.has_tk = False

    @classmethod
    def tearDownClass(cls):
        if getattr(cls, "has_tk", False) and getattr(cls, "root", None):
            try:
                cls.root.destroy()
            except Exception:
                pass

    def test_adapter_geometrie_fenetre_avec_mock(self):
        """Vérifie le calcul responsive de géométrie et minsize sur une fenêtre simulée."""
        mock_win = MagicMock()
        mock_win.winfo_screenwidth.return_value = 1024
        mock_win.winfo_screenheight.return_value = 768

        w, h = adapter_geometrie_fenetre(mock_win, largeur_preferee=1200, hauteur_preferee=900,
                                         min_w=600, min_h=450, marge_w=50, marge_h=80, centrer=True)

        self.assertLessEqual(w, 1024 - 50)
        self.assertLessEqual(h, 768 - 80)
        self.assertGreaterEqual(w, 600)
        self.assertGreaterEqual(h, 450)
        mock_win.geometry.assert_called_once()
        mock_win.minsize.assert_called_once()

    def test_lier_wraplength_dynamique_avec_mock(self):
        """Vérifie que l'événement Configure recalcule bien le wraplength sur les labels."""
        mock_parent = MagicMock()
        mock_label1 = MagicMock()
        mock_label2 = MagicMock()

        handler = None
        def fake_bind(sequence, func, add=""):
            nonlocal handler
            handler = func
        mock_parent.bind.side_effect = fake_bind

        lier_wraplength_dynamique(mock_parent, mock_label1, mock_label2, marge=30, min_wraplength=200)
        self.assertIsNotNone(handler)

        event = MagicMock()
        event.widget = mock_parent
        event.width = 600

        handler(event)
        mock_label1.configure.assert_called_with(wraplength=570)
        mock_label2.configure.assert_called_with(wraplength=570)

    def test_lier_wraplength_min_borne(self):
        """Vérifie que wraplength ne descend jamais sous le seuil minimum."""
        mock_parent = MagicMock()
        mock_label = MagicMock()

        handler = None
        def fake_bind(sequence, func, add=""):
            nonlocal handler
            handler = func
        mock_parent.bind.side_effect = fake_bind

        lier_wraplength_dynamique(mock_parent, mock_label, marge=40, min_wraplength=220)

        event = MagicMock()
        event.widget = mock_parent
        event.width = 150  # 150 - 40 = 110 < 220

        handler(event)
        mock_label.configure.assert_called_with(wraplength=220)


if __name__ == "__main__":
    unittest.main()
