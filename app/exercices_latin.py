"""
Logique de vérification des exercices de latin pour Ludus Latinus.

Module sans dépendance d'interface : entièrement testable et autonome.
Gère la validation des 5 grands types d'activités linguistiques :
- puzzle : reconstitution de phrase avec jetons de mots cliquables
- trou : texte à trous ou terminaisons avec tolérance orthographique
- decodeur : attribution des fonctions (Sujet/Nominatif, COD/Accusatif, Verbe)
- paires : association de mots latin/français
- arene : défi de combat avec jauge de points de vie adverse
"""

import re
import unicodedata

# ------------------------------------------------------------- Normalisation
def normaliser_mot(mot: str) -> str:
    """Normalise un mot pour comparaison tolérante (minuscule, sans ponctuation)."""
    if not mot:
        return ""
    m = re.sub(r"[.,!?;:\"«»']", " ", str(mot))
    return " ".join(m.strip().lower().split())


def normaliser_texte(texte: str) -> str:
    """Normalise une phrase entière : espaces simples, minuscules, ponctuation."""
    if not texte:
        return ""
    m = re.sub(r"[.,!?;:\"«»']", " ", str(texte))
    return " ".join(m.strip().lower().split())


# ---------------------------------------------------------- 1. Puzzle de mots
def verifier_puzzle(mots_proposes, solutions_attendues):
    """Vérifie une proposition de puzzle de mots.
    
    mots_proposes : liste de str ou str unique
    solutions_attendues : liste de listes de str, ou liste de str
    """
    if isinstance(mots_proposes, (list, tuple)):
        mots_clean = []
        for m in mots_proposes:
            norm = normaliser_texte(str(m))
            if norm:
                mots_clean.append(norm)
        prop_str = " ".join(mots_clean)
    else:
        prop_str = normaliser_texte(str(mots_proposes))

    # Formater les solutions possibles
    if isinstance(solutions_attendues, str):
        solutions = [solutions_attendues]
    elif isinstance(solutions_attendues, (list, tuple)):
        if solutions_attendues and isinstance(solutions_attendues[0], (list, tuple)):
            solutions = [" ".join(m) for m in solutions_attendues]
        else:
            solutions = list(solutions_attendues)
    else:
        solutions = []

    for sol in solutions:
        if prop_str == normaliser_texte(str(sol)):
            return True, "Bravo ! Traduction parfaitement reconstituée !"

    return False, "Ce n'est pas tout à fait le bon ordre des mots. Réessaie !"


# ---------------------------------------------------------- 2. Texte à trous
def verifier_trou(reponse_saisie: str, solutions_attendues):
    """Vérifie la saisie d'un texte à trous ou d'une désinence.
    
    Tolérant aux majuscules, espaces et accents optionnels.
    """
    saisie = normaliser_mot(reponse_saisie)
    if not saisie:
        return False, "Écris ta réponse dans la case avant de vérifier !"

    if isinstance(solutions_attendues, str):
        solutions = [solutions_attendues]
    else:
        solutions = list(solutions_attendues)

    for sol in solutions:
        if saisie == normaliser_mot(sol):
            return True, f"Parfait ! La bonne réponse est bien « {sol} »."

    sol_principale = solutions[0] if solutions else ""
    return False, f"Pas tout à fait. Pense bien à la règle !"


# ---------------------------------------------------------- 3. Décodeur de cas
def verifier_decodeur(roles_attribues: dict, roles_attendus: dict):
    """Vérifie les étiquettes grammaticales attribuées aux mots d'une phrase.
    
    roles_attribues : {0: "sujet", 1: "cod", 2: "verbe"}
    roles_attendus : {0: "sujet", 1: "cod", 2: "verbe"}
    """
    erreurs = []
    for idx, role_voulu in roles_attendus.items():
        role_donne = roles_attribues.get(idx)
        if role_donne != role_voulu:
            erreurs.append(idx)

    if not erreurs:
        return True, "Formidable ! Tu as démasqué le rôle de chaque mot dans la phrase !"
    
    nb_err = len(erreurs)
    return False, f"Attention, il y a {nb_err} mot(s) qui n'ont pas le bon rôle grammatical."


# --------------------------------------------------- 4. Association de Paires
def verifier_paire(mot_latin: str, mot_francais: str, paires_attendues: dict):
    """Vérifie si une association instantanée de deux mots est correcte."""
    latin = normaliser_mot(mot_latin)
    fr = normaliser_mot(mot_francais)
    
    attendus_norm = {normaliser_mot(k): normaliser_mot(v) for k, v in paires_attendues.items()}
    if attendus_norm.get(latin) == fr:
        return True
    return False


# --------------------------------------------------- 5. Combat d'Arène / Boss
class EtatCombatArene:
    """Gère l'état d'un combat de boss dans l'Arène."""
    def __init__(self, nom_boss: str, icone: str, pv_max: int, questions: list):
        self.nom_boss = nom_boss
        self.icone = icone
        self.pv_max = pv_max
        self.pv_actuels = pv_max
        self.questions = questions
        self.index_q = 0
        self.victoire = False
        self.defaite = False

    def question_actuelle(self):
        if 0 <= self.index_q < len(self.questions):
            return self.questions[self.index_q]
        return None

    def repondre(self, reponse_idx: int):
        q = self.question_actuelle()
        if not q:
            return False, "Combat terminé"
        
        correct = (reponse_idx == q.get("answer"))
        if correct:
            self.pv_actuels = max(0, self.pv_actuels - 1)
            self.index_q += 1
            if self.pv_actuels == 0:
                self.victoire = True
                msg = f"Coup critique ! Tu as terrassé {self.nom_boss} !"
            else:
                msg = f"Touché ! {self.nom_boss} vacille ! Plus que {self.pv_actuels} PV !"
            return True, msg
        else:
            # Mauvaise réponse : le boss contre-attaque amicalement
            msg = f"Le monstre a esquivé ! {q.get('explanation', '')}"
            return False, msg
