"""Chaque question de grammaire des leçons est complète et bien formée."""

import unittest

from content import CURRICULUM


def _lecons_avec_grammaire():
    return [
        (lecon["id"], lecon["grammaire"])
        for monde in CURRICULUM
        for lecon in monde.get("lessons", [])
        if "grammaire" in lecon
    ]


class TestGrammaireLecons(unittest.TestCase):
    def test_mondes_1_a_10_ont_leur_question(self):
        ids = {i for i, _ in _lecons_avec_grammaire()}
        attendus = {
            lecon["id"]
            for monde in CURRICULUM
            if monde["id"] in {f"monde{n}" for n in range(1, 11)}
            for lecon in monde["lessons"]
            if lecon.get("type") != "arene"
        }
        self.assertEqual(attendus - ids, set())

    def test_forme_de_chaque_grammaire(self):
        blocs = _lecons_avec_grammaire()
        self.assertGreaterEqual(len(blocs), 21)
        for lecon_id, g in blocs:
            with self.subTest(lecon=lecon_id):
                self.assertTrue(g["question"].strip())
                self.assertEqual(len(g["options"]), 4)
                self.assertEqual(len(set(g["options"])), 4)
                self.assertIn(g["answer"], range(4))
                self.assertEqual(len(g["explications"]), 4)
                vides = [i for i, e in enumerate(g["explications"]) if not e.strip()]
                self.assertEqual(vides, [g["answer"]])


if __name__ == "__main__":
    unittest.main()
