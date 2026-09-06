"""
Tests unitaires pour le gestionnaire d'icônes romaines 3D (app/icones.py).
"""

import os
import sys
import tkinter as tk
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.icones import ICONS_DIR, charger_icone, get_icones_toolbar


class TestIconesRomaines(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
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

    def test_dossier_icones_existe(self):
        self.assertTrue(ICONS_DIR.exists(), f"Le dossier {ICONS_DIR} doit exister")
        self.assertTrue(ICONS_DIR.is_dir())

    def test_fichiers_icones_essentielles_presents(self):
        icones_cles = [
            "icone_temple",
            "icone_carte",
            "icone_circus",
            "icone_profils",
            "icone_maj",
            "icone_glossaire",
            "icone_revision",
            "icone_stats",
            "icone_sesterce",
            "icone_arene",
            "icone_musee",
            "icone_tuba",
            "icone_laurier",
            "icone_trophee",
        ]
        for icone in icones_cles:
            with self.subTest(icone=icone):
                f24 = ICONS_DIR / f"{icone}_24.png"
                f20 = ICONS_DIR / f"{icone}_20.png"
                self.assertTrue(f24.exists(), f"L'icône {f24.name} est manquante")
                self.assertTrue(f20.exists(), f"L'icône {f20.name} est manquante")

    def test_charger_icone_inexistante(self):
        res = charger_icone("icone_qui_nexiste_absolument_pas_xyz", 24)
        self.assertIsNone(res)

    def test_charger_icone_et_mise_en_cache(self):
        if not self.root:
            self.skipTest("Tkinter display non disponible")
        img1 = charger_icone("icone_temple", 24)
        self.assertIsNotNone(img1)
        img2 = charger_icone("icone_temple", 24)
        self.assertIs(img1, img2, "L'icône chargée doit provenir du cache mémoire")

    def test_get_icones_toolbar(self):
        if not self.root:
            self.skipTest("Tkinter display non disponible")
        icons_map = get_icones_toolbar()
        self.assertIsInstance(icons_map, dict)
        for k in ("tb_accueil", "tb_carte", "tb_circus", "tb_profils", "tb_glossaire"):
            self.assertIn(k, icons_map, f"La clé {k} doit être présente dans get_icones_toolbar()")


if __name__ == "__main__":
    unittest.main()
