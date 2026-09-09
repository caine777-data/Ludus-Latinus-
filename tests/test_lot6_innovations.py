"""
Tests unitaires pour les 4 innovations majeures du Lot 6 :
1. Tabularium (Compte Citoyen, Authentification, Cloud Sync, Tessera Hospitalis)
2. Memoria Velox (Flashcards 3D, Répétition Espacée SRS, Vocabulaire Collège)
3. Forum Imperiale (Reconstruction de Rome, Déblocage de Monuments, Bonus Passifs)
4. Thesaurus Linguae Latinae (Dictionnaire Bilingue, Tables de Déclinaisons & Conjugaisons)
"""

import tkinter as tk
import unittest

from app import audio
from app import progress as prog
from app.forum_imperiale import MONUMENTS_FORUM
from app.memoria_velox import VOCABULAIRE_SRS
from app.thesaurus import (
    DICTIONNAIRE_LATIN,
    TABLES_CONJUGAISONS,
    TABLES_DECLINAISONS,
)


class TestLot6Innovations(unittest.TestCase):
    """Vérification unitaire complète des mécanismes et logiques du Lot 6."""

    def setUp(self):
        self.data = prog.normaliser({
            "sesterces": 200,
            "nom_heros": "Marcus"
        })

    # -----------------------------------------------------------------------
    # 1. TABULARIUM & COMPTE CITOYEN
    # -----------------------------------------------------------------------
    def test_compte_defaut_non_enregistre(self):
        """Un profil par défaut commence en mode Invité non enregistré."""
        self.assertFalse(prog.est_compte_enregistre(self.data))
        compte = prog.get_compte(self.data)
        self.assertEqual(compte.get("email"), "")

    def test_enregistrement_compte_validation(self):
        """Vérifie le rejet d'emails invalides et de mots de passe trop courts."""
        ok, msg = prog.enregistrer_compte(self.data, "invalide", "Marcus", "12345")
        self.assertFalse(ok)
        self.assertIn("invalide", msg)

        ok, msg = prog.enregistrer_compte(self.data, "marcus@rome.org", "Marcus", "12")
        self.assertFalse(ok)
        self.assertIn("4 caractères", msg)

    def test_enregistrement_et_connexion_reussie(self):
        """Enregistre un compte avec hachage et sel, puis valide la connexion."""
        ok, msg = prog.enregistrer_compte(self.data, "marcus@rome.org", "Marcus Aurelius", "Veritas2026")
        self.assertTrue(ok)
        self.assertTrue(prog.est_compte_enregistre(self.data))

        compte = prog.get_compte(self.data)
        self.assertEqual(compte["email"], "marcus@rome.org")
        self.assertNotEqual(compte["hash"], "Veritas2026")  # Doit être haché !
        self.assertTrue(len(compte["sel"]) > 0)
        self.assertTrue(compte["tessera"].startswith("SPQR-"))

        # Connexion avec bon mot de passe
        ok_conn, msg_conn = prog.valider_connexion_compte(self.data, "marcus@rome.org", "Veritas2026")
        self.assertTrue(ok_conn)
        self.assertIn("Marcus", msg_conn)

        # Connexion avec mauvais mot de passe
        ok_bad, msg_bad = prog.valider_connexion_compte(self.data, "marcus@rome.org", "FauxMdp")
        self.assertFalse(ok_bad)
        self.assertIn("incorrect", msg_bad)

    def test_deconnexion_compte(self):
        """La déconnexion remet le compte en mode Invité."""
        prog.enregistrer_compte(self.data, "julia@rome.org", "Julia", "RomaAeterna")
        self.assertTrue(prog.est_compte_enregistre(self.data))
        prog.deconnecter_compte(self.data)
        self.assertFalse(prog.est_compte_enregistre(self.data))

    def test_tessera_hospitalis_generation(self):
        """La Tessera Hospitalis a le format impérial SPQR-XXXX-XXXX."""
        code = prog.generer_tessera_hospitalis(self.data)
        self.assertTrue(code.startswith("SPQR-"))
        parties = code.split("-")
        self.assertEqual(len(parties), 3)

    def test_synchronisation_cloud_simulee(self):
        """La synchronisation cloud met à jour l'horodatage."""
        ok, msg = prog.synchroniser_cloud_simule(self.data)
        self.assertTrue(ok)
        compte = prog.get_compte(self.data)
        self.assertIsNotNone(compte.get("derniere_sync"))

    # -----------------------------------------------------------------------
    # 2. FORUM IMPERIALE (RECONSTRUCTION DE ROME)
    # -----------------------------------------------------------------------
    def test_monuments_forum_catalogue(self):
        """Le catalogue compte 6 monuments historiques majeurs."""
        self.assertEqual(len(MONUMENTS_FORUM), 6)
        ids = [m["id"] for m in MONUMENTS_FORUM]
        self.assertIn("lacus_iuturnae", ids)
        self.assertIn("templum_saturni", ids)
        self.assertIn("curia_iulia", ids)
        self.assertIn("arcus_titi", ids)
        self.assertIn("aedes_minervae", ids)
        self.assertIn("rostra_augusta", ids)

    def test_restauration_monument_succes_et_echec(self):
        """Vérifie l'achat d'un monument avec déduction des sesterces et gestion des fonds."""
        self.assertEqual(self.data["sesterces"], 200)

        # Achat Temple de Saturne (100 HS)
        ok, msg = prog.debloquer_monument_forum(self.data, "templum_saturni", 100)
        self.assertTrue(ok)
        self.assertEqual(self.data["sesterces"], 100)
        self.assertIn("templum_saturni", prog.get_monuments_forum(self.data))

        # Tentative de ré-achat
        ok_dup, _ = prog.debloquer_monument_forum(self.data, "templum_saturni", 100)
        self.assertFalse(ok_dup)

        # Tentative d'achat au-dessus du solde (Arcus Titi : 250 HS, il ne reste que 100 HS)
        ok_pauvre, msg_pauvre = prog.debloquer_monument_forum(self.data, "arcus_titi", 250)
        self.assertFalse(ok_pauvre)
        self.assertIn("manque", msg_pauvre)

    def test_bonus_passifs_forum(self):
        """Vérifie l'activation des bonus passifs (Saturne = +20% sesterces, Curie = +10% XP, Minerve = indices)."""
        self.assertEqual(prog.bonus_forum_sesterces(self.data), 0.0)
        self.assertEqual(prog.bonus_forum_xp(self.data), 0.0)
        self.assertFalse(prog.bonus_forum_indices(self.data))

        # Déblocage Saturne
        prog.debloquer_monument_forum(self.data, "templum_saturni", 100)
        self.assertAlmostEqual(prog.bonus_forum_sesterces(self.data), 0.20)

        # Déblocage Curie Julia
        self.data["sesterces"] = 500
        prog.debloquer_monument_forum(self.data, "curia_iulia", 150)
        self.assertAlmostEqual(prog.bonus_forum_xp(self.data), 0.10)

        # Déblocage Minerve
        prog.debloquer_monument_forum(self.data, "aedes_minervae", 350)
        self.assertTrue(prog.bonus_forum_indices(self.data))

    # -----------------------------------------------------------------------
    # 3. MEMORIA VELOX & SRS LEITNER
    # -----------------------------------------------------------------------
    def test_vocabulaire_srs_corpus(self):
        """Le corpus de flashcards contient au moins 25 mots clés avec étymologie et exemples."""
        self.assertGreaterEqual(len(VOCABULAIRE_SRS), 25)
        for carte in VOCABULAIRE_SRS:
            self.assertIn("id", carte)
            self.assertIn("latin", carte)
            self.assertIn("francais", carte)
            self.assertIn("etymologie", carte)
            self.assertIn("exemple", carte)
            self.assertIn("categorie", carte)

    def test_enregistrement_repetition_espacee(self):
        """Enregistre les niveaux de révision SRS."""
        prog.enregistrer_revision_srs(self.data, "v_domus", 3)
        srs = prog.get_srs_vocabulaire(self.data)
        self.assertIn("v_domus", srs)
        self.assertEqual(srs["v_domus"]["niveau"], 3)
        self.assertEqual(srs["v_domus"]["reps"], 1)

    # -----------------------------------------------------------------------
    # 4. THESAURUS LINGUAE LATINAE
    # -----------------------------------------------------------------------
    def test_thesaurus_dictionnaire(self):
        """Le dictionnaire latin contient au moins 50 mots avec recherche bilingue."""
        self.assertGreaterEqual(len(DICTIONNAIRE_LATIN), 50)
        for e in DICTIONNAIRE_LATIN:
            self.assertIn("latin", e)
            self.assertIn("fr", e)
            self.assertIn("cat", e)

    def test_thesaurus_declinaisons_tables(self):
        """Les tables de déclinaisons couvrent les 1re, 2e, 3e, 4e et 5e déclinaisons avec 6 cas."""
        self.assertIn("1re Déclinaison (rosa, -ae f.)", TABLES_DECLINAISONS)
        self.assertIn("2e Déclinaison Masc. (dominus, -i m.)", TABLES_DECLINAISONS)
        self.assertIn("2e Déclinaison Neutre (templum, -i n.)", TABLES_DECLINAISONS)
        self.assertIn("3e Déclinaison Consonne (rex, regis m.)", TABLES_DECLINAISONS)
        self.assertIn("4e Déclinaison (manus, -us f.)", TABLES_DECLINAISONS)
        self.assertIn("5e Déclinaison (res, rei f.)", TABLES_DECLINAISONS)

        table_rosa = TABLES_DECLINAISONS["1re Déclinaison (rosa, -ae f.)"]
        self.assertEqual(len(table_rosa["sing"]), 6)
        self.assertEqual(len(table_rosa["plur"]), 6)

    def test_thesaurus_conjugaisons_tables(self):
        """Les tables de conjugaisons couvrent Présent, Imparfait, Parfait et esse."""
        self.assertIn("Présent — amare (aimer)", TABLES_CONJUGAISONS)
        self.assertIn("Imparfait — amare (aimer)", TABLES_CONJUGAISONS)
        self.assertIn("Parfait — amare (aimer)", TABLES_CONJUGAISONS)
        self.assertIn("Présent — esse (être)", TABLES_CONJUGAISONS)

    # -----------------------------------------------------------------------
    # 5. EFFETS AUDIO
    # -----------------------------------------------------------------------
    def test_audio_nouveaux_effets(self):
        """Les nouvelles fonctions audio s'exécutent sans lever d'exception."""
        audio.play_card_flip()
        audio.play_build()


class TestDialogsLot6(unittest.TestCase):
    """Instanciation des fenêtres du Lot 6 en mode graphique."""

    @classmethod
    def setUpClass(cls):
        cls.root = tk.Tk()
        cls.root.withdraw()

        class MockApp:
            def __init__(self, root):
                self.root = root
                self.C = {
                    "panel": "#f8f5ee",
                    "editor": "#ffffff",
                    "accent": "#d4af37",
                    "fg": "#1a1409",
                    "muted": "#777777",
                    "heading": "#8b2500",
                    "is_dark": False
                }
                self.data = prog.normaliser({
                    "sesterces": 300,
                    "nom_heros": "Marcus"
                })
                self.title_font = tk.font.Font(family="Georgia", size=14, weight="bold")
                self.body = tk.font.Font(family="Segoe UI", size=10)

        cls.app = MockApp(cls.root)

    @classmethod
    def tearDownClass(cls):
        try:
            cls.root.destroy()
        except Exception:
            pass

    def test_open_compte_dialog(self):
        from app.compte import CompteDialog
        dlg = CompteDialog(self.root, self.app)
        self.assertIsNotNone(dlg)
        dlg.destroy()

    def test_open_memoria_velox_dialog(self):
        from app.memoria_velox import MemoriaVeloxDialog
        dlg = MemoriaVeloxDialog(self.root, self.app)
        self.assertIsNotNone(dlg)
        dlg.destroy()

    def test_open_forum_imperiale_dialog(self):
        from app.forum_imperiale import ForumImperialeDialog
        dlg = ForumImperialeDialog(self.root, self.app)
        self.assertIsNotNone(dlg)
        dlg.destroy()

    def test_open_thesaurus_dialog(self):
        from app.thesaurus import ThesaurusDialog
        dlg = ThesaurusDialog(self.root, self.app)
        self.assertIsNotNone(dlg)
        dlg.destroy()


if __name__ == "__main__":
    unittest.main()
