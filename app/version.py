"""
Version de l'application — source unique de vérité.

Elle est lue par :
  - `main.py --version` (et le contrôle de santé de la CI) ;
  - les scripts d'empaquetage (installateur Windows, .deb, .dmg) ;
  - le workflow GitHub Actions, qui la compare au tag `vX.Y.Z` publié.

Pour publier une nouvelle version : modifier __version__ ici, committer,
puis poser le tag correspondant (ex. `git tag v1.1.0`).
"""

import re
from pathlib import Path

__version__ = "1.0.1"

APP_NAME = "Ludus Latinus"
APP_ID = "ludus-latinus"
AUTEUR = "Cédric Monna"
ANNEE = "2026"
DEPOT = "https://github.com/caine777-data/ludus-latinus"
DESCRIPTION = "Apprendre le latin pas à pas — L'Aventure Romaine pour collégiens."

RACINE = Path(__file__).resolve().parent.parent
FICHIER_VERSION = RACINE / "app" / "version.py"
FICHIER_PYPROJECT = RACINE / "pyproject.toml"
FICHIER_ISS = RACINE / "packaging" / "installer.iss"


def calculer_nouvelle_version(actuelle, action, version_manuelle=""):
    actuelle = actuelle.strip()
    action = (action or "patch").lower()

    if "conserver" in action or "keep" in action:
        return actuelle

    if "personnalisée" in action or "custom" in action or "manuelle" in action:
        v = (version_manuelle or "").strip().lstrip("v")
        if not re.match(r"^\d+\.\d+\.\d+$", v):
            raise ValueError(f"Version manuelle invalide : '{v}'. Format attendu : X.Y.Z (ex: 1.0.1)")
        return v

    parts = list(map(int, actuelle.split(".")))
    if len(parts) != 3:
        raise ValueError(f"Version actuelle non conforme au format semver : '{actuelle}'")

    major, minor, patch = parts

    if "major" in action:
        return f"{major + 1}.0.0"
    elif "minor" in action:
        return f"{major}.{minor + 1}.0"
    elif "patch" in action:
        return f"{major}.{minor}.{patch + 1}"
    elif re.match(r"^\d+\.\d+\.\d+$", action.lstrip("v")):
        return action.lstrip("v")
    else:
        raise ValueError(f"Action de version inconnue : '{action}'")


def appliquer_version(nouvelle_version):
    # 1. app/version.py
    t_ver = FICHIER_VERSION.read_text(encoding="utf-8")
    t_ver = re.sub(r'__version__\s*=\s*"[^"]+"', f'__version__ = "{nouvelle_version}"', t_ver)
    FICHIER_VERSION.write_text(t_ver, encoding="utf-8")

    # 2. pyproject.toml
    if FICHIER_PYPROJECT.exists():
        t_pyp = FICHIER_PYPROJECT.read_text(encoding="utf-8")
        t_pyp = re.sub(r'version\s*=\s*"[^"]+"', f'version = "{nouvelle_version}"', t_pyp, count=1)
        FICHIER_PYPROJECT.write_text(t_pyp, encoding="utf-8")

    # 3. packaging/installer.iss
    if FICHIER_ISS.exists():
        t_iss = FICHIER_ISS.read_text(encoding="utf-8")
        t_iss = re.sub(r'#define\s+MaVersion\s+"[^"]+"', f'#define MaVersion "{nouvelle_version}"', t_iss)
        FICHIER_ISS.write_text(t_iss, encoding="utf-8")
