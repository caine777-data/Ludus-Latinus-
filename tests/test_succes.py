"""
Tests unitaires pour le système de Succès et Trophées Romains (app/succes.py).
"""

import os
import sys
import tkinter as tk
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.succes import (
    CATALOGUE_SUCCES,
    SuccesWindow,
    incrementer_stat_succes,
    valeur_progression_succes,
    verifier_et_debloquer_succes,
    verifier_tous_succes,
)


class MockApp:
    def __init__(self):
        self.data = {
            "sesterces": 50,
            "succes_debloques": [],
            "stats_succes": {
                "audio_ecoutes": 0,
                "cesar_resolus": 0,
                "marche_transactions": 0,
                "duels_parfaits": 0,
                "duels_gagnes": 0,
                "sesterces_max": 50,
            },
            "cartes_collection": [],
            "lupulus_costume": "standard",
            "lupulus_costumes_debloques": ["standard"],
        }
        self.notif_recue = None

    def ajouter_sesterces(self, montant):
        self.data["sesterces"] += montant

    def notifier_succes(self, info):
        self.notif_recue = info

    def _refresh_header_stats(self):
        pass


class TestSucces(unittest.TestCase):

    def setUp(self):
        self.app = MockApp()

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

    def test_structure_catalogue(self):
        """Vérifie la présence et la structure des succès requis."""
        succes_requis = ["polyglotte", "banquier", "invincible", "cryptographe", "collectionneur", "mercator"]
        for s in succes_requis:
            self.assertIn(s, CATALOGUE_SUCCES)
            info = CATALOGUE_SUCCES[s]
            self.assertIn("titre", info)
            self.assertIn("icone", info)
            self.assertIn("desc", info)
            self.assertIn("recompense_sesterces", info)
            self.assertTrue(info["recompense_sesterces"] > 0)
            self.assertIn("seuil", info)
            self.assertTrue(info["seuil"] > 0)

        # Invincible doit être secret
        self.assertTrue(CATALOGUE_SUCCES["invincible"]["secret"])
        # Polyglotte et Banquier ne sont pas secrets
        self.assertFalse(CATALOGUE_SUCCES["polyglotte"]["secret"])
        self.assertFalse(CATALOGUE_SUCCES["banquier"]["secret"])

    def test_calcul_valeur_progression(self):
        """Vérifie le calcul correct de la valeur actuelle selon la nature du succès."""
        # Polyglotte -> audio_ecoutes
        self.app.data["stats_succes"]["audio_ecoutes"] = 12
        self.assertEqual(valeur_progression_succes(self.app.data, "polyglotte"), 12)

        # Banquier -> sesterces max ou actuels
        self.app.data["sesterces"] = 250
        self.assertEqual(valeur_progression_succes(self.app.data, "banquier"), 250)

        # Collectionneur -> taille de cartes_collection
        self.app.data["cartes_collection"] = ["jupiter", "mars", "venus"]
        self.assertEqual(valeur_progression_succes(self.app.data, "collectionneur"), 3)

    def test_deblocage_polyglotte(self):
        """Vérifie le déblocage du succès Polyglotte après 20 écoutes."""
        self.app.data["stats_succes"]["audio_ecoutes"] = 19
        res = verifier_et_debloquer_succes(self.app, "polyglotte")
        self.assertIsNone(res)
        self.assertNotIn("polyglotte", self.app.data["succes_debloques"])

        # Incrémenter à 20
        nouveaux = incrementer_stat_succes(self.app, "audio_ecoutes", 1)
        self.assertEqual(len(nouveaux), 1)
        self.assertEqual(nouveaux[0]["id"], "polyglotte")
        self.assertIn("polyglotte", self.app.data["succes_debloques"])
        # Récompense +30 sesterces : 50 initial + 30 = 80
        self.assertEqual(self.app.data["sesterces"], 80)
        self.assertIsNotNone(self.app.notif_recue)
        self.assertEqual(self.app.notif_recue["id"], "polyglotte")

        # Ne doit pas être débloqué une deuxième fois
        res2 = verifier_et_debloquer_succes(self.app, "polyglotte")
        self.assertIsNone(res2)

    def test_deblocage_banquier(self):
        """Vérifie le déblocage du succès Banquier du Forum à 500 sesterces."""
        self.app.data["sesterces"] = 490
        verifier_tous_succes(self.app)
        self.assertNotIn("banquier", self.app.data["succes_debloques"])

        self.app.data["sesterces"] = 520
        nouveaux = verifier_tous_succes(self.app)
        self.assertTrue(any(s["id"] == "banquier" for s in nouveaux))
        self.assertIn("banquier", self.app.data["succes_debloques"])
        # Récompense +50 sesterces : 520 + 50 = 570
        self.assertEqual(self.app.data["sesterces"], 570)

    def test_deblocage_invincible(self):
        """Vérifie le déblocage du succès secret Champion Invincible."""
        nouveaux = incrementer_stat_succes(self.app, "duels_parfaits", 1)
        self.assertTrue(any(s["id"] == "invincible" for s in nouveaux))
        self.assertIn("invincible", self.app.data["succes_debloques"])

    def test_deblocage_triomphes(self):
        """Vérifie le déblocage des trophées de 4ème et Cycle 4."""
        self.app.data["badges"] = ["triomphe_4eme"]
        nouveaux = verifier_tous_succes(self.app)
        self.assertTrue(any(s["id"] == "triomphe_4eme" for s in nouveaux))
        self.assertIn("triomphe_4eme", self.app.data["succes_debloques"])

        self.app.data["badges"] = ["triomphe_4eme", "triomphe_cycle4"]
        nouveaux2 = verifier_tous_succes(self.app)
        self.assertTrue(any(s["id"] == "triomphe_cycle4" for s in nouveaux2))
        self.assertIn("triomphe_cycle4", self.app.data["succes_debloques"])

    def test_succes_window_instantiation(self):
        """Vérifie que la fenêtre SuccesWindow se construit sans erreur."""
        if not self.root:
            self.skipTest("Affichage Tkinter non disponible")
        win = SuccesWindow(self.root, self.app)
        self.assertTrue(win.winfo_exists())
        win.destroy()


if __name__ == "__main__":
    unittest.main()
