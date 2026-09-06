#!/usr/bin/env bash
# ============================================================================
#  Construit le disque d'installation macOS (.dmg) à partir du bundle
#  produit par PyInstaller (dist/PythonLearn.app).
#
#  Usage, depuis la racine du projet (python-learn/) :
#      bash packaging/macos/construire-dmg.sh 1.2.3 arm64
#
#  Le fichier fini est déposé dans dist/PythonLearn-<version>-<arch>.dmg
# ============================================================================
set -euo pipefail

VERSION="${1:?usage: construire-dmg.sh <version> [architecture]}"
ARCH="${2:-$(uname -m)}"
APP="dist/LudusLatinus.app"
[ -d "$APP" ] || APP="dist/PythonLearn.app"
DMG="dist/LudusLatinus-${VERSION}-${ARCH}.dmg"

if [ ! -d "$APP" ]; then
    echo "Bundle introuvable : $APP (lancer PyInstaller en mode --windowed)" >&2
    exit 1
fi

# Signature « ad hoc » : elle ne coûte rien, ne remplace pas un certificat
# Apple payant, mais évite à macOS de refuser catégoriquement une application
# dont le contenu n'est signé par personne.
codesign --force --deep --sign - "$APP" 2>/dev/null || \
    echo "Signature ad hoc impossible — sans gravité, l'application reste utilisable."

# Contenu du disque : l'application, plus un raccourci vers /Applications
# pour que l'utilisateur n'ait qu'à glisser l'icône de gauche à droite.
montage="$(mktemp -d)"
trap 'rm -rf "$montage"' EXIT
cp -R "$APP" "$montage/"
ln -s /Applications "$montage/Applications"

cat > "$montage/LISEZ-MOI.txt" <<'TXT'
Ludus Latinus — installation
============================

1. Glisse l'icône Ludus Latinus sur le dossier Applications, à droite.
2. Au PREMIER lancement, fais un clic droit sur Ludus Latinus dans le dossier
   Applications, puis choisis « Ouvrir », et confirme.

Pourquoi cette manipulation ? L'application n'est pas signée avec un
certificat de développeur Apple (payant), donc macOS demande une
confirmation explicite la première fois. Les lancements suivants se font
normalement, par un simple double-clic.

Si macOS annonce que l'application « est endommagée », lance dans le
Terminal :

    xattr -dr com.apple.quarantine "/Applications/LudusLatinus.app"

Ta progression est enregistrée dans ~/.latin-learn et survit aux mises
à jour comme à la désinstallation.
TXT

rm -f "$DMG"
hdiutil create \
    -volname "Ludus Latinus ${VERSION}" \
    -srcfolder "$montage" \
    -ov -format UDZO \
    "$DMG"

echo "Disque construit :"
ls -lh "$DMG"
