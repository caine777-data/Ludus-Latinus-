"""
Tests unitaires pour la gestion des versions et le module de mise à jour.
"""

import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.mise_a_jour import _parse_version, extraire_depot_info
from app.version import calculer_nouvelle_version


class TestMiseAJour(unittest.TestCase):

    def test_parse_version(self):
        self.assertEqual(_parse_version("1.0.0"), (1, 0, 0))
        self.assertEqual(_parse_version("v1.2.3"), (1, 2, 3))
        self.assertEqual(_parse_version("version 2.10.4-rc1"), (2, 10, 4))
        self.assertEqual(_parse_version("invalide"), (0, 0, 0))

    def test_extraire_depot_info(self):
        self.assertEqual(
            extraire_depot_info("https://github.com/caine777-data/ludus-latinus"),
            ("caine777-data", "ludus-latinus")
        )
        self.assertEqual(
            extraire_depot_info("mon-user/mon-latin/"),
            ("mon-user", "mon-latin")
        )

    def test_calculer_nouvelle_version_patch(self):
        self.assertEqual(calculer_nouvelle_version("1.0.0", "patch"), "1.0.1")
        self.assertEqual(calculer_nouvelle_version("1.0.9", "patch"), "1.0.10")

    def test_calculer_nouvelle_version_minor(self):
        self.assertEqual(calculer_nouvelle_version("1.0.3", "minor"), "1.1.0")

    def test_calculer_nouvelle_version_major(self):
        self.assertEqual(calculer_nouvelle_version("1.4.3", "major"), "2.0.0")

    def test_calculer_nouvelle_version_conserver(self):
        self.assertEqual(calculer_nouvelle_version("1.0.0", "conserver"), "1.0.0")
        self.assertEqual(calculer_nouvelle_version("1.0.0", "keep"), "1.0.0")

    def test_calculer_nouvelle_version_manuelle(self):
        self.assertEqual(calculer_nouvelle_version("1.0.0", "personnalisée", "1.5.2"), "1.5.2")
        self.assertEqual(calculer_nouvelle_version("1.0.0", "custom", "v2.0.1"), "2.0.1")

    def test_calculer_nouvelle_version_manuelle_invalide(self):
        with self.assertRaises(ValueError):
            calculer_nouvelle_version("1.0.0", "personnalisée", "abc")


if __name__ == "__main__":
    unittest.main()
