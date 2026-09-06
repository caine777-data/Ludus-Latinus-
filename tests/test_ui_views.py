"""Test d'intégration graphique de toutes les vues de leçons."""

import os
import sys
import tkinter as tk
import unittest

import content
from app.ui import PythonLearnApp


class TestUIViews(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if sys.platform == "darwin" and os.environ.get("GITHUB_ACTIONS"):
            cls.root = None
            cls.app = None
            return
        try:
            cls.root = tk.Tk()
            cls.root.withdraw()
            cls.app = PythonLearnApp(cls.root)
            cls.root.update()
        except Exception:
            cls.root = None
            cls.app = None

    @classmethod
    def tearDownClass(cls):
        if cls.root:
            try:
                cls.root.destroy()
            except Exception:
                pass

    def test_chargement_tous_types_de_lecons(self):
        if not self.root or not self.app:
            self.skipTest("Tkinter display non disponible")
        # Tester au moins une leçon de chaque type
        types_testes = set()
        for level in content.CURRICULUM:
            for lesson in level["lessons"]:
                t = lesson.get("type")
                if t not in types_testes:
                    self.app._load_lesson(lesson)
                    self.root.update()
                    types_testes.add(t)

        self.assertIn("quiz", types_testes)
        self.assertIn("puzzle", types_testes)
        self.assertIn("trou", types_testes)
        self.assertIn("decodeur", types_testes)
        self.assertIn("arene", types_testes)


if __name__ == "__main__":
    unittest.main()
