"""
Moteur de phonétique latine classique (prononciation restituée) et synthèse vocale.
Applique les règles de prononciation de l'époque cicéronienne :
- C toujours dur [k] (Cicero -> Kikero)
- G toujours dur [g] (gens -> guens)
- V prononcé [w] (venit -> wénit)
- AE / OE diphtongues
- Règle de l'accent tonique romain (pénultième / antépénultième).
"""

import os
import re
import subprocess
import threading


# Table de substitution phonétique classique pour la synthèse
REGLES_PHONETIQUES = [
    # Diphtongues
    (r"\bae\b", "é"),
    (r"ae", "é"),
    (r"oe", "é"),
    (r"au", "aou"),
    (r"eu", "éou"),
    # C toujours dur
    (r"c([eiyéèê])", r"qu\1"),
    (r"c", "k"),
    # G toujours dur
    (r"g([eiyéèê])", r"gu\1"),
    # V consonne -> W
    (r"\bv([aeiouyéèê])", r"ou\1"),
    (r"([aeiouyéèê])v([aeiouyéèê])", r"\1ou\2"),
    # TH, CH, PH
    (r"th", "t"),
    (r"ch", "k"),
    (r"ph", "f"),
    # Qu -> Kou
    (r"qu", "kou"),
    # TI devant voyelle reste TI (pas SI)
    (r"ti([aeoué])", r"ti\1"),
]


def transcrire_latin_phonetique(texte):
    """
    Convertit un texte latin en transcription phonétique restituée
    pour une prononciation romaine authentique.
    Exemple : 'Veni, vidi, vici' -> 'Ouni, ouidi, ouiki'
    """
    if not texte:
        return ""

    mots = texte.split()
    mots_phonetiques = []

    for mot in mots:
        # Conserver la ponctuation
        ponct_debut = re.match(r"^[^\w]+", mot)
        ponct_fin = re.search(r"[^\w]+$", mot)
        p_deb = ponct_debut.group(0) if ponct_debut else ""
        p_fin = ponct_fin.group(0) if ponct_fin else ""
        coeur = mot[len(p_deb):len(mot) - len(p_fin)] if p_fin else mot[len(p_deb):]

        modifie = coeur.lower()
        for patron, rempl in REGLES_PHONETIQUES:
            modifie = re.sub(patron, rempl, modifie)

        # Préserver majuscule initiale si le mot en avait une
        if coeur and coeur[0].isupper():
            modifie = modifie.capitalize()

        mots_phonetiques.append(p_deb + modifie + p_fin)

    return " ".join(mots_phonetiques)


def determiner_accent_tonique(mot):
    """
    Analyse les syllabes d'un mot latin et retourne l'indice de la syllabe accentuée.
    Règles classiques :
    - Mot de 2 syllabes : toujours l'avant-dernière (pénultième).
    - Mot de 3+ syllabes : avant-dernière si longue, sinon antépénultième.
    """
    mot_net = re.sub(r"[^\w]", "", mot).lower()
    # Découpage simple des voyelles
    voyelles = list(re.finditer(r"[aeiouyéèê]+", mot_net))
    nb_syllabes = len(voyelles)

    if nb_syllabes <= 1:
        return 0
    elif nb_syllabes == 2:
        return 0  # Première syllabe = avant-dernière
    else:
        # Heuristique classique : par défaut avant-dernière si diphtongue ou suivie de 2 consonnes
        penult_match = voyelles[-2]
        apres_penult = mot_net[penult_match.end():voyelles[-1].start()]
        if len(apres_penult) >= 2 or len(penult_match.group(0)) >= 2:
            return nb_syllabes - 2  # Pénultième
        return nb_syllabes - 3      # Antépénultième


def prononcer_latin_async(texte, vitesse=0):
    """
    Prononce une phrase latine en tâche de fond avec la phonétique restituée.
    Utilise PowerShell SpeechSynthesizer sous Windows de façon ultra-légère et sans dépendance.
    """
    if not texte:
        return

    phonetique = transcrire_latin_phonetique(texte)

    def _parler():
        try:
            # Script PowerShell pour la voix TTS native Windows
            texte_echappe = phonetique.replace("'", "''").replace('"', '`"')
            ps_script = (
                f"Add-Type -AssemblyName System.Speech; "
                f"$synth = New-Object System.Speech.Synthesis.SpeechSynthesizer; "
                f"$synth.Rate = {vitesse}; "
                f"$synth.Speak('{texte_echappe}');"
            )
            subprocess.run(
                ["powershell", "-NoProfile", "-Command", ps_script],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0),
                timeout=8,
            )
        except Exception:
            pass

    t = threading.Thread(target=_parler, daemon=True)
    t.start()
