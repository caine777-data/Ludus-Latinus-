"""Tests de la logique de motivation (streak, SRS, certificat)."""

import datetime
import unittest

from app import stats


class TestStats(unittest.TestCase):

    def test_streak(self):
        t = datetime.date(2026, 6, 27)
        h = {"2026-06-27": 2, "2026-06-26": 1, "2026-06-25": 3}
        self.assertEqual(stats.streak(h, t), 3)
        # inactif aujourd'hui mais actif hier : la série tient
        h2 = {"2026-06-26": 1, "2026-06-25": 1}
        self.assertEqual(stats.streak(h2, t), 2)
        # trou : la série s'arrête
        h3 = {"2026-06-27": 1, "2026-06-25": 1}
        self.assertEqual(stats.streak(h3, t), 1)

    def test_meilleur_streak(self):
        h = {"2026-06-01": 1, "2026-06-02": 1, "2026-06-03": 1,
             "2026-06-10": 1, "2026-06-11": 1}
        self.assertEqual(stats.meilleur_streak(h), 3)

    def test_intervalle_progressif(self):
        self.assertEqual(stats.prochain_intervalle(0), 1)
        self.assertEqual(stats.prochain_intervalle(1), 3)
        self.assertEqual(stats.prochain_intervalle(7), 16)
        self.assertEqual(stats.prochain_intervalle(90), 90)

    def test_planifier_et_dus(self):
        t = datetime.date(2026, 6, 27)
        srs = {}
        stats.planifier(srs, "deb-00", t, reussi=True)
        self.assertEqual(srs["deb-00"]["interval"], 1)
        self.assertEqual(srs["deb-00"]["due"], "2026-06-28")
        # pas encore dû aujourd'hui
        self.assertEqual(stats.dus(srs, t, {"deb-00"}), [])
        # dû demain
        self.assertEqual(stats.dus(srs, t + datetime.timedelta(days=1), {"deb-00"}),
                         ["deb-00"])

    def test_certificat_html(self):
        html = stats.certificat_html("Ada Lovelace", "Débutant", "27/06/2026")
        self.assertIn("Ada Lovelace", html)
        self.assertIn("Débutant", html)
        self.assertIn("<!DOCTYPE html>", html)

    def test_xp_et_niveau(self):
        self.assertEqual(stats.xp_total([], []), 0)
        self.assertEqual(stats.xp_total(["a", "b"], ["x"]), 10 * 2 + 50)
        n = stats.niveau(0)
        self.assertEqual(n["niveau"], 1)
        n = stats.niveau(250)
        self.assertEqual(n["niveau"], 3)
        self.assertEqual(n["dans_niveau"], 50)

    def test_cette_semaine(self):
        # mercredi 2026-06-24 ; lundi de la semaine = 2026-06-22
        today = datetime.date(2026, 6, 24)
        hist = {"2026-06-22": 2, "2026-06-24": 3, "2026-06-21": 9}  # 21 = dimanche d'avant
        self.assertEqual(stats.cette_semaine(hist, today), 5)

    def test_prochaine_action(self):
        ordre = ["a", "b", "c", "d"]
        # révision prioritaire
        self.assertEqual(stats.prochaine_action(ordre, ["a"], ["b"]),
                         ("revision", "b"))
        # sinon première non faite
        self.assertEqual(stats.prochaine_action(ordre, ["a"], []),
                         ("nouvelle", "b"))
        # tout fait
        self.assertEqual(stats.prochaine_action(ordre, ordre, []),
                         ("termine", None))

    def test_cheatsheet_html(self):
        sections = [("Bases", [("x = 1", "entier"), ('s = "hi"', "chaîne")])]
        html = stats.cheatsheet_html("Antisèche", sections)
        self.assertIn("<!DOCTYPE html>", html)
        self.assertIn("Bases", html)
        self.assertIn("&quot;", html)          # guillemets échappés
        self.assertEqual(html.count("<section>"), 1)


class TestNotionsDifficiles(unittest.TestCase):
    """Les échecs enregistrés servent enfin à proposer un rattrapage."""

    ORDRE = ["deb-01", "deb-02", "deb-03", "deb-04"]

    def test_classement_du_plus_difficile_au_moins(self):
        echecs = {"deb-01": 2, "deb-02": 7, "deb-03": 4}
        self.assertEqual(
            stats.notions_difficiles(echecs, self.ORDRE),
            [("deb-02", 7), ("deb-03", 4), ("deb-01", 2)])

    def test_un_seul_echec_ne_fait_pas_une_difficulte(self):
        self.assertEqual(stats.notions_difficiles({"deb-01": 1}, self.ORDRE), [])

    def test_limite_respectee(self):
        echecs = {"deb-01": 9, "deb-02": 8, "deb-03": 7, "deb-04": 6}
        self.assertEqual(len(stats.notions_difficiles(echecs, self.ORDRE, limite=2)), 2)

    def test_exercices_disparus_sont_ecartes(self):
        """Le curriculum change : un ancien identifiant ne doit rien proposer."""
        echecs = {"exercice-supprime": 12, "deb-01": 3}
        self.assertEqual(stats.notions_difficiles(echecs, self.ORDRE),
                         [("deb-01", 3)])

    def test_classement_stable(self):
        """À égalité, l'ordre ne doit pas changer d'un affichage à l'autre."""
        echecs = {"deb-03": 3, "deb-01": 3, "deb-02": 3}
        premier = stats.notions_difficiles(echecs, self.ORDRE)
        self.assertEqual(premier, stats.notions_difficiles(echecs, self.ORDRE))
        self.assertEqual([item for item, _ in premier], ["deb-01", "deb-02", "deb-03"])

    def test_aucun_echec(self):
        self.assertEqual(stats.notions_difficiles({}, self.ORDRE), [])


class TestResumeAccueil(unittest.TestCase):

    ORDRE = ["a", "b", "c", "d"]

    def resume(self, **data):
        base = {"completed": [], "echecs": {}, "historique": {}, "badges": [],
                "srs": {}, "objectif_quotidien": 3}
        base.update(data)
        return stats.resume_accueil(base, self.ORDRE, datetime.date(2026, 5, 4))

    def test_progression_comptee_sur_les_exercices_existants(self):
        r = self.resume(completed=["a", "b", "disparu"])
        self.assertEqual((r["faits"], r["total"]), (2, 4))

    def test_prochaine_action_est_la_premiere_non_faite(self):
        self.assertEqual(self.resume(completed=["a"])["prochaine"], ("nouvelle", "b"))

    def test_revision_prioritaire_sur_la_suite(self):
        r = self.resume(completed=["a"],
                        srs={"a": {"interval": 1, "due": "2026-05-01"}})
        self.assertEqual(r["prochaine"], ("revision", "a"))
        self.assertEqual(r["revisions"], 1)

    def test_tout_termine(self):
        self.assertEqual(self.resume(completed=self.ORDRE)["prochaine"],
                         ("termine", None))

    def test_activite_du_jour_et_objectif(self):
        r = self.resume(historique={"2026-05-04": 5}, objectif_quotidien=3)
        self.assertEqual((r["aujourdhui"], r["objectif"]), (5, 3))
        self.assertEqual(r["serie"], 1)

    def test_difficultes_remontees(self):
        self.assertEqual(self.resume(echecs={"b": 4})["difficiles"], [("b", 4)])

    def test_donnees_vides_ne_plantent_pas(self):
        r = stats.resume_accueil({}, [], datetime.date(2026, 5, 4))
        self.assertEqual(r["faits"], 0)
        self.assertEqual(r["prochaine"], ("termine", None))

    def test_defi_du_jour_selection_deterministe(self):
        curr = [
            {"id": "t1", "lessons": [{"id": "l1", "title": "L1"}, {"id": "l2", "title": "L2"}]},
            {"id": "t2", "lessons": [{"id": "l3", "title": "L3"}]}
        ]
        d1 = stats.defi_du_jour(curr, datetime.date(2026, 8, 30))
        d2 = stats.defi_du_jour(curr, datetime.date(2026, 8, 30))
        self.assertIsNotNone(d1)
        self.assertEqual(d1["id"], d2["id"])

    def test_export_anki_tsv(self):
        gloss = [("mot", "définition")]
        curr = [{"id": "t1", "lessons": [{"id": "qz", "type": "quiz", "question": "Q ?", "options": ["R1", "R2"], "answer": 0, "explanation": "Exp"}]}]
        tsv = stats.export_anki_tsv(gloss, curr, lang="fr")
        self.assertIn("#separator:tab", tsv)
        self.assertIn("mot\tdéfinition\tluduslatinus::vocabulaire", tsv)
        self.assertIn("Q ?\tR1<br><small style='color:gray'>Exp</small>\tluduslatinus::t1", tsv)


if __name__ == "__main__":
    unittest.main()
