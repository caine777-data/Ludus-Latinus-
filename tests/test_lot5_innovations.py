"""
Tests unitaires pour les innovations du Lot 5 :
1. Le Décrypteur Visuel de Phrases (Anatomia Sententiae)
2. La Taverne des Dés Romains (Alea Iacta Est)
3. L'Espace de Cours Sublime (Cartouches Parchemins & SFX)
"""

import tkinter as tk
import unittest
from datetime import date

from app import audio
from app.decrypteur_visuel import (
    CAS_INFO,
    PHRASES_PREDEFINIES,
    DecrypteurVisuelWindow,
    analyser_phrase_auto,
)
from app.taverne_alea import TaverneAleaWindow


class MockApp:
    """Simulateur léger de l'application principale pour les tests."""

    def __init__(self):
        self.data = {
            "sesterces": 100,
            "streak_protege": False,
            "dernier_alea_date": None,
            "historique_alea": 0,
            "completed": [],
            "badges": [],
        }
        self.C = {
            "bg": "#fcfbf7",
            "panel": "#f4efe2",
            "editor": "#ffffff",
            "fg": "#1e293b",
            "muted": "#64748b",
            "accent": "#991b1b",
            "heading": "#7f1d1d",
            "ok": "#15803d",
            "code": "#854d0e",
        }
        self.theme_name = "light"
        self.lang = "fr"
        self.current = {
            "id": "m1-01",
            "latin": "Romulus Romam condidit",
            "content": "## Le savais-tu ?\nL'alphabet latin est l'ancêtre du nôtre.\n\n📌 **À retenir** : Pas d'espaces à l'origine.",
        }
        self.reactions = []

    def ajouter_sesterces(self, montant):
        self.data["sesterces"] = max(0, self.data.get("sesterces", 0) + montant)

    def reagir_succes(self, msg=None):
        self.reactions.append(("succes", msg))

    def reagir_erreur(self, msg=None):
        self.reactions.append(("erreur", msg))


class TestDecrypteurVisuel(unittest.TestCase):
    """Tests de l'analyseur syntaxique et du Décrypteur Visuel."""

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

    def test_phrases_predefinies_conformite(self):
        """Vérifie que chaque phrase du corpus est intègre et complète."""
        self.assertGreaterEqual(len(PHRASES_PREDEFINIES), 5)
        for p in PHRASES_PREDEFINIES:
            self.assertIn("titre", p)
            self.assertIn("latin", p)
            self.assertIn("francais", p)
            self.assertIn("mots", p)
            self.assertGreaterEqual(len(p["mots"]), 2)

            for m in p["mots"]:
                self.assertIn("texte", m)
                self.assertIn("cas", m)
                self.assertIn(m["cas"], CAS_INFO)
                self.assertIn("fonction", m)
                self.assertIn("traduction", m)

    def test_analyser_phrase_auto(self):
        """Teste l'analyse heuristique automatique de phrases libres."""
        res = analyser_phrase_auto("Caesar Galliam vicit et Romam venit")
        self.assertEqual(res["latin"], "Caesar Galliam vicit et Romam venit")
        self.assertGreaterEqual(len(res["mots"]), 5)

        # Vérifier que Galliam / Romam sont identifiés à l'accusatif
        mots_par_texte = {m["texte"]: m for m in res["mots"]}
        self.assertEqual(mots_par_texte["Galliam"]["cas"], "accusatif")
        self.assertEqual(mots_par_texte["Romam"]["cas"], "accusatif")
        # Vérifier que 'et' est invariable
        self.assertEqual(mots_par_texte["et"]["cas"], "invariable")

    def test_decrypteur_window_gui_and_puzzle(self):
        """Teste l'initialisation de l'IHM et les étapes du puzzle de traduction."""
        if not self.root:
            self.skipTest("Tkinter display non disponible")
        app = MockApp()
        win = DecrypteurVisuelWindow(self.root, app, phrase_initiale="Romulus Romam condidit")
        self.root.update_idletasks()

        # Vérifier que les capsules sont créées
        self.assertGreaterEqual(len(win.capsules_widgets), 3)

        # Étape 1 : le puzzle attend le verbe
        self.assertEqual(win.etape_puzzle, 1)

        # Clic sur un nom (Romulus) -> reste à l'étape 1
        win._interagir_puzzle(0)
        self.assertEqual(win.etape_puzzle, 1)

        # Trouver l'index du verbe (condidit)
        idx_verbe = None
        idx_sujet = None
        for i, cap in enumerate(win.capsules_widgets):
            if cap["info"].get("cas") == "verbe":
                idx_verbe = i
            elif cap["info"].get("cas") == "nominatif":
                idx_sujet = i

        self.assertIsNotNone(idx_verbe)
        self.assertIsNotNone(idx_sujet)

        # Clic sur le verbe -> passe à l'étape 2 (trouver le sujet)
        win._interagir_puzzle(idx_verbe)
        self.assertEqual(win.etape_puzzle, 2)

        # Clic sur le sujet -> passe à l'étape 3
        win._interagir_puzzle(idx_sujet)
        self.assertEqual(win.etape_puzzle, 3)

        # Validation de l'étape 3 -> récompense en sesterces
        sesterces_avant = app.data["sesterces"]
        win._recompenser_puzzle()
        self.assertEqual(app.data["sesterces"], sesterces_avant + 5)
        self.assertGreaterEqual(len(app.reactions), 1)

        win.destroy()


class TestTaverneAlea(unittest.TestCase):
    """Tests du module de dés romains 'Alea Iacta Est'."""

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

    def test_combinaisons_romaines(self):
        """Teste la détection des tirages antiques (Vénus, Chien, Sénateur, Plébéien)."""
        if not self.root:
            self.skipTest("Tkinter display non disponible")
        app = MockApp()
        win = TaverneAleaWindow(self.root, app)
        self.root.update_idletasks()

        # 1. Coup de Vénus : 4 faces différentes [1, 3, 4, 6]
        win.valeurs_des = [1, 3, 4, 6]
        sesterces_init = app.data["sesterces"]
        win._evaluer_resultat()
        self.assertEqual(app.data["sesterces"], sesterces_init + 50)
        self.assertTrue(app.data.get("streak_protege"))

        # 2. Coup du Sénateur : 3 dés identiques [4, 4, 4, 2]
        win.valeurs_des = [4, 4, 4, 2]
        sesterces_avant_senat = app.data["sesterces"]
        win._evaluer_resultat()
        self.assertEqual(app.data["sesterces"], sesterces_avant_senat + 25)

        # 3. Coup du Plébéien : tirage standard [2, 2, 5, 6] -> somme = 15
        win.valeurs_des = [2, 2, 5, 6]
        sesterces_avant_pleb = app.data["sesterces"]
        win._evaluer_resultat()
        self.assertEqual(app.data["sesterces"], sesterces_avant_pleb + 15)

        win.destroy()

    def test_lancer_gratuit_et_payant(self):
        """Teste le contrôle du rituel quotidien (Bonus Diurnum)."""
        if not self.root:
            self.skipTest("Tkinter display non disponible")
        app = MockApp()
        win = TaverneAleaWindow(self.root, app)
        self.root.update_idletasks()

        auj = date.today().isoformat()
        app.data["dernier_alea_date"] = None

        # 1er lancer : Gratuit
        sesterces_avant = app.data["sesterces"]
        win._declencher_lancer()
        self.assertEqual(app.data["dernier_alea_date"], auj)
        # Ne doit pas avoir déduit 15 sesterces
        self.assertGreaterEqual(app.data["sesterces"], sesterces_avant)

        # 2ème lancer le même jour : Payant (15 Sesterces)
        sesterces_avant_relance = app.data["sesterces"]
        win.en_animation = False
        win._declencher_lancer()
        # Doit déduire 15 sesterces
        self.assertEqual(app.data["sesterces"], sesterces_avant_relance - 15)
        self.assertEqual(app.data["historique_alea"], 2)

        win.destroy()


class TestAudioAndCoursSublime(unittest.TestCase):
    """Tests des effets sonores et des cartouches de cours."""

    def test_audio_play_dice(self):
        """Vérifie que la fonction play_dice ne lève aucune exception."""
        try:
            audio.play_dice()
        except Exception as e:
            self.fail(f"play_dice a levé une exception inattendue : {e}")

    def test_callouts_rendu_markdown(self):
        """Vérifie que le moteur de cours formate correctement les sections callouts."""
        try:
            root = tk.Tk()
            root.withdraw()
        except Exception:
            self.skipTest("Tkinter display non disponible")
        try:
            from app.ui import PythonLearnApp
            # Instanciation de test
            app = PythonLearnApp(root)
            texte_test = (
                "## Le savais-tu ? 💡\n"
                "Le latin n'avait pas de lettre J.\n\n"
                "📌 **À retenir** : Les Romains écrivaient en capitales.\n\n"
                "## Chapitre 2\n"
                "Texte ordinaire."
            )
            app._render_content(texte_test)
            contenu = app.content.get("1.0", tk.END)
            self.assertIn("LE SAVAIS-TU ?", contenu)
            self.assertIn("À RETENIR", contenu)
            self.assertIn("Chapitre 2", contenu)
            app.quitter()
        finally:
            try:
                root.destroy()
            except Exception:
                pass


if __name__ == "__main__":
    unittest.main()
