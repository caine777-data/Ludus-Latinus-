"""
Sauvegarde et chargement de la progression de l'apprenant.

Les données sont stockées dans le dossier personnel de l'utilisateur
(~/.python-learn/progress.json), ce qui fonctionne aussi bien depuis
les sources que depuis l'exécutable empaqueté.

L'écriture est ATOMIQUE : on écrit d'abord un fichier temporaire complet,
puis on le met en place d'un seul geste (os.replace). Une coupure de
courant ou une fermeture brutale ne peut donc jamais laisser un
progress.json tronqué. L'ancienne version est conservée en .bak et sert
de filet de secours au chargement.
"""

import json
import os
import tempfile
from pathlib import Path

DATA_DIR = Path.home() / ".latin-learn"
PROGRESS_FILE = DATA_DIR / "progress.json"
BACKUP_FILE = DATA_DIR / "progress.bak.json"
PROFILES_DIR = DATA_DIR / "profiles"
ACTIVE_PROFILE_FILE = DATA_DIR / "active_profile.txt"

_DEFAULT = {"completed": [], "code": {}, "badges": [], "theme": "rome",
            "vu_accueil": False, "historique": {}, "objectif_quotidien": 3,
            "srs": {}, "nom": "", "langue": "fr",
            "notes": {}, "favoris": [], "objectif_hebdo": 15, "echecs": {},
            "accueil_au_demarrage": True,
            "sesterces": 50, "sound_enabled": True,
            "genre": "garcon", "nom_heros": "Marcus",
            "avatar": {"toge": "lin_blanc", "couronne": "aucune", "accessoire": "stylet", "fond": "villa"},
            "musee_debloques": ["rome_fondation"],
            "cartes_collection": [],
            "succes_debloques": [],
            "stats_succes": {
                "audio_ecoutes": 0,
                "cesar_resolus": 0,
                "marche_transactions": 0,
                "duels_parfaits": 0,
                "duels_gagnes": 0
            },
            "lupulus_costume": "standard",
            "lupulus_costumes_debloques": ["standard"],
            "classe_active": "5eme"}

# Renseigné par load_progress() quand le chargement ne s'est pas passé
# normalement, pour que l'interface puisse prévenir l'apprenant au lieu
# de repartir de zéro en silence. Voir dernier_incident().
_INCIDENT = None

INCIDENT_RESTAURE = "restaure"    # progress.json illisible, .bak utilisé
INCIDENT_PERDU = "perdu"          # les deux fichiers sont illisibles


def _get_active_id():
    try:
        active_f = DATA_DIR / "active_profile.txt"
        if active_f.exists():
            pid = active_f.read_text(encoding="utf-8").strip()
            if pid:
                return pid
    except Exception:
        pass
    return "defaut"


def definir_profil_actif(profile_id):
    try:
        DATA_DIR.mkdir(parents=True, exist_ok=True)
        (DATA_DIR / "active_profile.txt").write_text(str(profile_id).strip(), encoding="utf-8")
    except Exception:
        pass


def _resoudre_fichiers(profile_id=None):
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    pid = profile_id or _get_active_id()
    if pid == "defaut":
        return PROGRESS_FILE, BACKUP_FILE, "defaut"

    pdir = DATA_DIR / "profiles"
    pdir.mkdir(parents=True, exist_ok=True)
    return pdir / f"{pid}.json", pdir / f"{pid}.bak.json", pid


def lister_profils():
    """Renvoie la liste de tous les profils enregistrés avec résumé."""
    actif_id = _get_active_id()
    profils = []

    # Profil par défaut (PROGRESS_FILE)
    data_defaut = _lire(PROGRESS_FILE) or {}
    nom_defaut = data_defaut.get("nom") or (data_defaut.get("nom_heros") or "Marcus")
    genre_defaut = data_defaut.get("genre", "garcon")
    nom_heros_defaut = data_defaut.get("nom_heros", "Marcus" if genre_defaut == "garcon" else "Julia")
    profils.append({
        "id": "defaut",
        "nom": nom_defaut,
        "genre": genre_defaut,
        "nom_heros": nom_heros_defaut,
        "sesterces": data_defaut.get("sesterces", 50),
        "faits": len(data_defaut.get("completed", [])),
        "badges": len(data_defaut.get("badges", [])),
        "actif": (actif_id == "defaut")
    })

    # Profils additionnels dans DATA_DIR / "profiles"
    pdir = DATA_DIR / "profiles"
    if pdir.exists():
        fichiers = [f for f in pdir.glob("*.json") if not f.name.endswith(".bak.json") and not f.name.endswith(".corrompu.json")]
        for f in sorted(fichiers, key=lambda p: p.stat().st_mtime if p.exists() else 0):
            pid = f.stem
            if pid == "defaut":
                continue
            data = _lire(f) or {}
            nom = data.get("nom") or (data.get("nom_heros") or "Marcus")
            genre = data.get("genre", "garcon")
            nom_heros = data.get("nom_heros", "Marcus" if genre == "garcon" else "Julia")
            profils.append({
                "id": pid,
                "nom": nom,
                "genre": genre,
                "nom_heros": nom_heros,
                "sesterces": data.get("sesterces", 50),
                "faits": len(data.get("completed", [])),
                "badges": len(data.get("badges", [])),
                "actif": (pid == actif_id)
            })
    return profils


def creer_profil(nom, genre="garcon", nom_heros=None):
    """Crée un nouveau profil avec identifiant propre et le rend actif."""
    import re
    import time
    clean_nom = nom.strip() or ("Marcus" if genre == "garcon" else "Julia")
    base_id = re.sub(r"[^a-zA-Z0-9_]", "", clean_nom.lower())
    if not base_id:
        base_id = "heros"
    pid = f"{base_id}_{int(time.time()) % 10000}"

    data = normaliser({})
    data["nom"] = clean_nom
    data["genre"] = genre
    data["nom_heros"] = nom_heros or ("Marcus" if genre == "garcon" else "Julia")

    definir_profil_actif(pid)
    save_progress(data, profile_id=pid)
    return pid


def supprimer_profil(profile_id):
    """Supprime le profil spécifié. Ne peut pas supprimer le profil par défaut."""
    if profile_id == "defaut":
        return False
    pdir = DATA_DIR / "profiles"
    cible = pdir / f"{profile_id}.json"
    bak = pdir / f"{profile_id}.bak.json"
    try:
        if cible.exists():
            cible.unlink()
        if bak.exists():
            bak.unlink()
    except Exception:
        return False

    if _get_active_id() == profile_id:
        definir_profil_actif("defaut")
    return True


def dernier_incident():
    return _INCIDENT


def normaliser(data):
    """Complète un dict de progression avec les clés par défaut manquantes."""
    for cle, valeur in _DEFAULT.items():
        data.setdefault(cle, valeur.copy() if isinstance(valeur, (dict, list)) else valeur)
    if isinstance(data.get("stats_succes"), dict):
        for k, v in _DEFAULT["stats_succes"].items():
            data["stats_succes"].setdefault(k, v)
    return data


def _lire(chemin):
    """Lit un fichier de progression. Renvoie le dict, ou None si inutilisable."""
    try:
        data = json.loads(chemin.read_text(encoding="utf-8"))
    except Exception:
        return None
    return data if isinstance(data, dict) else None


def load_progress(profile_id=None):
    """Charge la progression du profil actif ou spécifié."""
    global _INCIDENT
    _INCIDENT = None

    fichier_p, fichier_bak, _ = _resoudre_fichiers(profile_id)
    principal_existe = fichier_p.exists()
    if principal_existe:
        data = _lire(fichier_p)
        if data is not None:
            return normaliser(data)

    secours = _lire(fichier_bak) if fichier_bak.exists() else None
    if secours is not None:
        if principal_existe:
            _INCIDENT = (INCIDENT_RESTAURE, str(fichier_bak))
        return normaliser(secours)

    if principal_existe:
        try:
            os.replace(fichier_p, fichier_p.with_suffix(".corrompu.json"))
            _INCIDENT = (INCIDENT_PERDU, str(fichier_p.with_suffix(".corrompu.json")))
        except OSError:
            _INCIDENT = (INCIDENT_PERDU, str(fichier_p))

    return normaliser({})


def _ecrire_temporaire(texte, dossier):
    """Écrit `texte` dans un fichier temporaire complet et synchronisé sur disque."""
    fd, tmp = tempfile.mkstemp(dir=str(dossier), prefix=".progress-", suffix=".tmp")
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as f:
            f.write(texte)
            f.flush()
            os.fsync(f.fileno())
    except BaseException:
        try:
            os.unlink(tmp)
        except OSError:
            pass
        raise
    return tmp


def save_progress(data, profile_id=None):
    """Écrit la progression du profil spécifié ou actif sur disque de façon atomique."""
    fichier_p, fichier_bak, _ = _resoudre_fichiers(profile_id)
    dossier = fichier_p.parent
    try:
        dossier.mkdir(parents=True, exist_ok=True)
        tmp = _ecrire_temporaire(json.dumps(data, ensure_ascii=False, indent=2), dossier)
    except Exception:
        return False

    try:
        if fichier_p.exists():
            os.replace(fichier_p, fichier_bak)
        os.replace(tmp, fichier_p)
        return True
    except Exception:
        try:
            os.unlink(tmp)
        except OSError:
            pass
        return False


def mark_completed(data, lesson_id):
    if lesson_id not in data["completed"]:
        data["completed"].append(lesson_id)
        save_progress(data)


def store_code(data, lesson_id, code):
    data["code"][lesson_id] = code
    save_progress(data)


def award_badge(data, level_id):
    """Enregistre un badge de niveau s'il n'existe pas déjà. Renvoie True si nouveau."""
    if level_id not in data["badges"]:
        data["badges"].append(level_id)
        save_progress(data)
        return True
    return False


def set_theme(data, theme):
    data["theme"] = theme
    save_progress(data)


def marquer_accueil_vu(data):
    data["vu_accueil"] = True
    save_progress(data)


def enregistrer_activite(data, date_iso):
    """Incrémente le compteur d'exercices du jour."""
    data["historique"][date_iso] = data["historique"].get(date_iso, 0) + 1
    save_progress(data)


def set_nom(data, nom):
    data["nom"] = nom
    save_progress(data)


def set_objectif(data, n):
    data["objectif_quotidien"] = max(1, n)
    save_progress(data)


def set_langue(data, lang):
    data["langue"] = lang
    save_progress(data)


def set_note(data, item_id, texte):
    """Enregistre (ou efface) la note personnelle d'une leçon."""
    if texte.strip():
        data["notes"][item_id] = texte
    else:
        data["notes"].pop(item_id, None)
    save_progress(data)


def toggle_favori(data, item_id):
    """Ajoute/retire une leçon des favoris. Renvoie l'état après bascule."""
    if item_id in data["favoris"]:
        data["favoris"].remove(item_id)
        actif = False
    else:
        data["favoris"].append(item_id)
        actif = True
    save_progress(data)
    return actif


def set_accueil_au_demarrage(data, actif):
    """Mémorise si l'écran d'accueil doit s'ouvrir au lancement."""
    data["accueil_au_demarrage"] = bool(actif)
    save_progress(data)


def set_objectif_hebdo(data, n):
    data["objectif_hebdo"] = max(1, n)
    save_progress(data)


def enregistrer_echec(data, item_id):
    """Compte un échec sur un exercice (pour la recommandation adaptative)."""
    data["echecs"][item_id] = data["echecs"].get(item_id, 0) + 1
    save_progress(data)


def exporter_json(data):
    """Renvoie la progression sérialisée (pour sauvegarde externe)."""
    return json.dumps(data, ensure_ascii=False, indent=2)


def importer_json(texte):
    """Construit une progression valide à partir d'un JSON. Lève ValueError si invalide."""
    charge = json.loads(texte)
    if not isinstance(charge, dict) or "completed" not in charge:
        raise ValueError("Fichier de progression non reconnu.")
    return normaliser(charge)


def reset_progress():
    """Efface toute la progression, sauvegarde de secours comprise."""
    for chemin in (PROGRESS_FILE, BACKUP_FILE):
        try:
            if chemin.exists():
                chemin.unlink()
        except Exception:
            pass


def get_genre(data):
    return data.get("genre", "garcon")


def set_genre(data, genre):
    data["genre"] = "fille" if genre == "fille" else "garcon"
    if data["genre"] == "fille" and data.get("nom_heros") in ("", "Marcus"):
        data["nom_heros"] = "Julia"
    elif data["genre"] == "garcon" and data.get("nom_heros") in ("", "Julia"):
        data["nom_heros"] = "Marcus"
    save_progress(data)


def get_nom_heros(data):
    return data.get("nom_heros") or ("Julia" if data.get("genre") == "fille" else "Marcus")


def set_nom_heros(data, nom):
    nom = (nom or "").strip()
    if nom:
        data["nom_heros"] = nom
        save_progress(data)

