"""
Tests automatiques du curriculum de Ludus Latinus.

Vérifie que chaque type d'exercice (quiz, puzzle, trou, decodeur, arene)
a des solutions cohérentes et des identifiants uniques.
"""

import unittest

from app import exercices_latin
from content import CURRICULUM, exercice_count, get_exercice, lesson_items


class TestCurriculum(unittest.TestCase):

    def test_exercices_latin_resolubles(self):
        for level in CURRICULUM:
            for lesson in level["lessons"]:
                t = lesson.get("type")
                with self.subTest(item=lesson["id"], type=t):
                    if t == "quiz":
                        self.assertIn("answer", lesson)
                        self.assertIsInstance(lesson["answer"], int)
                        self.assertTrue(0 <= lesson["answer"] < len(lesson["options"]))
                    elif t == "puzzle":
                        self.assertIn("solution", lesson)
                        reussi, _ = exercices_latin.verifier_puzzle(lesson["solution"], lesson["solution"])
                        self.assertTrue(reussi)
                    elif t == "trou":
                        sol = lesson.get("solution") or lesson.get("attendu")
                        self.assertIsNotNone(sol)
                        reussi, _ = exercices_latin.verifier_trou(sol, sol)
                        self.assertTrue(reussi)
                    elif t == "decodeur":
                        roles = lesson.get("roles", {})
                        self.assertGreater(len(roles), 0)
                        reussi, _ = exercices_latin.verifier_decodeur(roles, roles)
                        self.assertTrue(reussi)
                    elif t == "arene":
                        boss = lesson.get("boss", {})
                        self.assertIn("nom", boss)
                        self.assertIn("icone", boss)
                        questions = lesson.get("questions", [])
                        self.assertGreater(len(questions), 0)
                        for q in questions:
                            self.assertIn("question", q)
                            self.assertIn("options", q)
                            self.assertTrue(0 <= q["answer"] < len(q["options"]))

    def test_identifiants_uniques(self):
        vus = set()
        for level in CURRICULUM:
            for lesson in level["lessons"]:
                self.assertNotIn(lesson["id"], vus, f"id dupliqué : {lesson['id']}")
                vus.add(lesson["id"])


if __name__ == "__main__":
    unittest.main()
