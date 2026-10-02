"""
Tests empêchant les exercices du collège (mondes 1 à 26) de redonner leur réponse.

Vérifie que :
- les exercices à trou ne divulguent pas le mot attendu dans le cours ou la consigne ;
- les puzzles ne divulguent pas la phrase solution complète dans le cours.
"""

import re
import unicodedata
import unittest

from content import CURRICULUM

# Exceptions autorisées à conserver la solution dans le cours :
# - m1-02, m1-05 : découverte, avant l'apprentissage des cas
# - m7-03 : devise à connaître (Veni, vidi, vici)
EXCEPTIONS = {
    "m1-02": "découverte, avant les cas",
    "m1-05": "découverte, avant les cas",
    "m7-03": "devise à connaître",
}

# 5e (mondes 1 à 10), 4e (mondes 11 à 18) et 3e (mondes 19 à 26) sont réécrites.
MONDES_REECRITS = {f"monde{i}" for i in range(1, 27)}


def normaliser(texte: str) -> str:
    """Minuscules, sans accents, ponctuation remplacée par des espaces."""
    texte = unicodedata.normalize("NFD", texte.lower())
    texte = "".join(c for c in texte if unicodedata.category(c) != "Mn")
    texte = re.sub(r"[^a-z0-9]+", " ", texte)
    return " ".join(texte.split())


def contient_texte(cherche: str, cible: str) -> bool:
    """Vérifie si 'cherche' apparaît en mot(s) entier(s) dans 'cible' (piège 7 d'AGENTS.md)."""
    c_norm = normaliser(cherche)
    if not c_norm:
        return False
    cible_norm = normaliser(cible)
    pattern = r"(?<![a-z0-9])" + re.escape(c_norm) + r"(?![a-z0-9])"
    return bool(re.search(pattern, cible_norm))


class TestReponsesCachees(unittest.TestCase):
    """Vérifie que les exercices réécrits ne donnent pas leur réponse avant l'épreuve."""

    def test_trous_ne_donnent_pas_reponse(self):
        """Le mot complet reconstitué ne doit apparaître ni dans content ni dans consigne."""
        for level in CURRICULUM:
            if level.get("id") not in MONDES_REECRITS:
                continue
            for lesson in level.get("lessons", []):
                lid = lesson.get("id")
                if lid in EXCEPTIONS:
                    continue
                if lesson.get("type") == "trou":
                    avant = lesson.get("avant")
                    sol = lesson.get("solution")
                    if not avant or not sol:
                        continue
                    mots_avant = avant.split()
                    if not mots_avant:
                        continue
                    # Dernier mot de avant + solution (ex: leg + it = legit)
                    mot_reconstitue = mots_avant[-1] + sol
                    mots_a_tester = [mot_reconstitue]
                    if avant.endswith(" "):
                        mots_a_tester.append(f"{mots_avant[-1]} {sol}")
                    content = lesson.get("content", "")
                    consigne = lesson.get("consigne", "")

                    for mot in mots_a_tester:
                        with self.subTest(lesson=lid, mot=mot, champ="content"):
                            self.assertFalse(
                                contient_texte(mot, content),
                                f"La leçon {lid} révèle le mot '{mot}' dans son cours.",
                            )
                        with self.subTest(lesson=lid, mot=mot, champ="consigne"):
                            self.assertFalse(
                                contient_texte(mot, consigne),
                                f"La leçon {lid} révèle le mot '{mot}' dans sa consigne.",
                            )

    def test_puzzles_ne_donnent_pas_reponse(self):
        """La phrase française complète de solution ne doit pas apparaître dans content."""
        for level in CURRICULUM:
            if level.get("id") not in MONDES_REECRITS:
                continue
            for lesson in level.get("lessons", []):
                lid = lesson.get("id")
                if lid in EXCEPTIONS:
                    continue
                if lesson.get("type") == "puzzle":
                    sol = lesson.get("solution")
                    if not sol:
                        continue
                    content = lesson.get("content", "")

                    with self.subTest(lesson=lid):
                        self.assertFalse(
                            contient_texte(sol, content),
                            f"La leçon {lid} révèle la solution du puzzle '{sol}' dans son cours.",
                        )


if __name__ == "__main__":
    unittest.main()
