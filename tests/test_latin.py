"""Tests unitaires pour les fonctionnalités de Ludus Latinus."""

import unittest
from app import audio, exercices_latin, stats
import content


class TestExercicesLatin(unittest.TestCase):
    def test_verifier_puzzle(self):
        # Cas exact
        reussi, _ = exercices_latin.verifier_puzzle(
            ["Bonjour,", "ami !"], "Bonjour, ami !"
        )
        self.assertTrue(reussi)

        # Cas tolérant aux majuscules et ponctuation
        reussi, _ = exercices_latin.verifier_puzzle(
            ["bonjour", "ami"], "Bonjour, ami !"
        )
        self.assertTrue(reussi)

        # Mauvais ordre
        reussi, _ = exercices_latin.verifier_puzzle(
            ["ami", "bonjour"], "Bonjour, ami !"
        )
        self.assertFalse(reussi)

    def test_verifier_trou(self):
        # Bonne réponse
        reussi, _ = exercices_latin.verifier_trou("sum", "sum")
        self.assertTrue(reussi)

        # Majuscule tolérée
        reussi, _ = exercices_latin.verifier_trou("SUM", "sum")
        self.assertTrue(reussi)

        # Mauvaise réponse
        reussi, _ = exercices_latin.verifier_trou("es", "sum")
        self.assertFalse(reussi)

    def test_verifier_decodeur(self):
        roles_attendus = {0: "sujet", 1: "cod", 2: "verbe"}
        roles_proposes_ok = {0: "sujet", 1: "cod", 2: "verbe"}
        reussi, _ = exercices_latin.verifier_decodeur(roles_proposes_ok, roles_attendus)
        self.assertTrue(reussi)

        roles_proposes_err = {0: "cod", 1: "sujet", 2: "verbe"}
        reussi, _ = exercices_latin.verifier_decodeur(roles_proposes_err, roles_attendus)
        self.assertFalse(reussi)

    def test_combat_arene(self):
        questions = [
            {"question": "Q1", "options": ["A", "B"], "answer": 0},
            {"question": "Q2", "options": ["A", "B"], "answer": 1},
        ]
        combat = exercices_latin.EtatCombatArene("Boss", "🦁", pv_max=2, questions=questions)
        self.assertEqual(combat.pv_actuels, 2)
        self.assertFalse(combat.victoire)

        # Bonne réponse Q1
        ok, _ = combat.repondre(0)
        self.assertTrue(ok)
        self.assertEqual(combat.pv_actuels, 1)

        # Mauvaise réponse Q2
        ok, _ = combat.repondre(0)
        self.assertFalse(ok)
        self.assertEqual(combat.pv_actuels, 1)

        # Bonne réponse Q2
        ok, _ = combat.repondre(1)
        self.assertTrue(ok)
        self.assertEqual(combat.pv_actuels, 0)
        self.assertTrue(combat.victoire)


class TestRangsEtStats(unittest.TestCase):
    def test_rang_romain(self):
        r1 = stats.rang_romain(1)
        self.assertEqual(r1["titre"], "Tiro")
        r10 = stats.rang_romain(10)
        self.assertEqual(r10["titre"], "Legionarius")
        r25 = stats.rang_romain(25)
        self.assertEqual(r25["titre"], "Triumphator")

    def test_niveau_et_xp(self):
        info = stats.niveau(150)
        self.assertEqual(info["niveau"], 2)
        self.assertEqual(info["dans_niveau"], 50)
        self.assertEqual(info["rang_titre"], "Tiro")


class TestCurriculumLatin(unittest.TestCase):
    def test_tous_les_mondes(self):
        self.assertEqual(len(content.CURRICULUM), 10)
        ids = content.ids_utilises()
        self.assertGreater(len(ids), 30)

        for niveau in content.CURRICULUM:
            self.assertTrue(niveau["id"].startswith("monde"))
            self.assertGreater(len(niveau["lessons"]), 0)
            for lecon in niveau["lessons"]:
                self.assertIn("title", lecon)
                self.assertIn("content", lecon)
                self.assertIn("type", lecon)


if __name__ == "__main__":
    unittest.main()
