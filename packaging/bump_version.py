"""
Script CLI pour incrémenter et synchroniser le numéro de version de Ludus Latinus.
Utilisé par GitHub Actions et disponible en local.

Usage :
    python packaging/bump_version.py patch
    python packaging/bump_version.py minor
    python packaging/bump_version.py major
    python packaging/bump_version.py personnalisée 1.2.0
    python packaging/bump_version.py conserver
"""

import os
import sys
from pathlib import Path

# Ajouter le répertoire racine au PYTHONPATH
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from app.version import __version__, appliquer_version, calculer_nouvelle_version


def main():
    action = sys.argv[1] if len(sys.argv) > 1 else "keep"
    manuelle = sys.argv[2] if len(sys.argv) > 2 else ""

    actuelle = __version__
    nouvelle = calculer_nouvelle_version(actuelle, action, manuelle)

    change = (nouvelle != actuelle)
    if change:
        appliquer_version(nouvelle)
        print(f"Version mise à jour : {actuelle} -> {nouvelle}")
    else:
        print(f"Version conservée : {actuelle}")

    # Export pour GitHub Actions si présent
    gh_env = os.environ.get("GITHUB_ENV")
    if gh_env and os.path.exists(gh_env):
        with open(gh_env, "a", encoding="utf-8") as f:
            f.write(f"NEW_VERSION={nouvelle}\n")
            f.write(f"VERSION_CHANGED={'true' if change else 'false'}\n")

    gh_output = os.environ.get("GITHUB_OUTPUT")
    if gh_output and os.path.exists(gh_output):
        with open(gh_output, "a", encoding="utf-8") as f:
            f.write(f"new_version={nouvelle}\n")
            f.write(f"version_changed={'true' if change else 'false'}\n")

    return 0


if __name__ == "__main__":
    sys.exit(main())
