# Diffuser Ludus Latinus

Ce guide explique comment le code devient des fichiers d'installation
téléchargeables, et comment les publier proprement. L'application reste
**sans dépendance** pour l'utilisateur final : Python, tkinter et le
curriculum sont embarqués dans le fichier livré.

---

## 1. La voie normale : ne rien construire soi-même (GitHub Actions)

Tout est automatisé dans GitHub Actions !

### Option A : Construire à la demande (bouton Action)
1. Va sur l'onglet **Actions** de ton dépôt GitHub.
2. Clique sur **Construire les installateurs** à gauche.
3. Clique sur le bouton **Run workflow** à droite.
4. Laisse tourner les machines virtuelles (Windows, macOS, Linux).
5. Une fois terminé, télécharge les artefacts produits directement depuis la page de l'exécution.

### Option B : Publier une Release officielle
1. Vérifie le numéro de version dans `app/version.py` (ex: `1.0.0`).
2. Committe et pousse un tag Git :
```bash
git tag v1.0.0
git push origin v1.0.0
```
Le workflow `.github/workflows/build.yml` se charge du reste :

| Étape | Ce qui est vérifié ou produit |
|---|---|
| Tests | Tous les tests unitaires et leçons passent |
| Version | Le tag correspond bien à `app/version.py` |
| Windows | `LudusLatinus-Setup-<version>.exe` + version portable |
| macOS | `LudusLatinus-<version>-arm64.dmg` pour Apple Silicon |
| Linux | `ludus-latinus_<version>_amd64.deb` + archive `.tar.gz` |
| Contrôle | Chaque exécutable produit est lancé avec `--check` |
| Release | Les fichiers sont publiés automatiquement sur GitHub avec SHA-256 |

---

## 2. Construire en local (mise au point optionnelle)

Chaque système ne peut construire que pour lui-même :

```bash
pip install -r requirements-dev.txt        # pyinstaller + ruff
```

**Windows**

```bat
pyinstaller --onefile --windowed --icon assets/icon.ico --name LudusLatinus main.py
dist\LudusLatinus.exe --check
```

**macOS** — sans `--onefile`, pour obtenir un vrai bundle `.app` :

```bash
pyinstaller --windowed --icon assets/icon.icns --name LudusLatinus main.py
dist/LudusLatinus.app/Contents/MacOS/LudusLatinus --check
bash packaging/macos/construire-dmg.sh 1.0.0 arm64
```

**Linux**

```bash
pyinstaller --onefile --name LudusLatinus main.py
./dist/LudusLatinus --check
bash packaging/linux/construire-paquets.sh 1.0.0
```

---

## 3. Installateur Windows (Inno Setup)

Le script `packaging/installer.iss` est prêt à l'emploi. Il installe
**sans droits administrateur** (`PrivilegesRequired=lowest`), crée les
raccourcis, et propose une désinstallation propre — qui **ne supprime pas**
la progression de l'apprenant (`%USERPROFILE%\.latin-learn`).

1. Installer [Inno Setup 6](https://jrsoftware.org/isdl.php) (gratuit).
2. Générer d'abord `dist\LudusLatinus.exe` (étape 2).
3. Compiler :

```bat
iscc packaging\installer.iss
iscc /DMaVersion=1.0.0 packaging\installer.iss     :: version imposée
```

Le résultat est déposé dans `Output\LudusLatinus-Setup-<version>.exe`.

> `AppId` est l'identifiant qui permet à Windows de reconnaître une **mise à
> jour** plutôt que d'installer un second exemplaire côte à côte. Ne jamais
> le modifier une fois une version publiée.

---

## 4. Signature & avertissement SmartScreen (Windows)

Un exécutable **non signé** déclenche l'écran *« Windows a protégé votre
ordinateur »*. C'est normal et sans danger, mais ça inquiète les
utilisateurs. Trois options, de la plus simple à la plus professionnelle :

- **Ne rien signer** : indiquer aux utilisateurs de cliquer sur
  *« Informations complémentaires » → « Exécuter quand même »*. Tout à fait
  acceptable pour un projet libre.
- **Certificat de signature de code** (OV, ~70-150 €/an) : signe le binaire,
  mais la réputation SmartScreen se construit progressivement.
- **Certificat EV** (plus cher) : réputation immédiate, plus d'alerte.

Signer, si tu as un certificat `.pfx` :

```bat
signtool sign /f certificat.pfx /p MOT_DE_PASSE /tr http://timestamp.digicert.com /td sha256 /fd sha256 dist\PythonLearn.exe
```

> La signature **n'est pas obligatoire** pour distribuer : l'application
> fonctionne parfaitement sans, c'est uniquement une question de confiance
> affichée.

---

## 5. macOS : Gatekeeper et notarisation

Le script `packaging/macos/construire-dmg.sh` produit un `.dmg` contenant
l'application, un raccourci vers `/Applications` et un fichier `LISEZ-MOI`.
Il applique une **signature ad hoc** (`codesign --sign -`), gratuite : elle
ne remplace pas un compte développeur, mais évite un refus catégorique.

Au premier lancement, l'utilisateur doit faire **clic droit → Ouvrir**. En
cas de message « application endommagée » :

```bash
xattr -dr com.apple.quarantine /Applications/PythonLearn.app
```

La **notarisation** (compte développeur Apple, ~99 €/an) supprime
définitivement l'avertissement :

```bash
xcrun notarytool submit PythonLearn.dmg --apple-id … --team-id … --wait
xcrun stapler staple PythonLearn.dmg
```

### Le cas des Mac Intel

Un binaire arm64 ne démarre pas sur un processeur Intel, et GitHub a retiré
ses runners macOS Intel : il n'existe donc plus de machine gratuite capable
de produire un `.dmg` x86_64.

Trois voies si le besoin se présente un jour :

- **Les sources** (ce que recommande la Release) : `python main.py` fonctionne
  à l'identique sur un Mac Intel, il suffit d'installer Python.
- **Un binaire universal2**, qui contiendrait les deux architectures. Cela
  suppose un interpréteur Python lui-même universal2 — ni celui de
  `actions/setup-python`, ni celui de Homebrew ne le sont — puis
  `pyinstaller --target-arch universal2`.
- **Un runner auto-hébergé** : n'importe quel Mac Intel que tu possèdes peut
  être déclaré comme machine de construction dans les réglages du dépôt.

---

## 6. Linux : deux formats, deux publics

| Format | Pour qui | Installation |
|---|---|---|
| `.deb` | Debian, Ubuntu, Mint… | `sudo apt install ./python-learn_<version>_amd64.deb` |
| `.tar.gz` | toutes les autres distributions | `bash installer.sh`, sans `sudo` |

Le paquet `.deb` place le binaire dans `/usr/lib/python-learn/`, un lien
dans `/usr/bin/`, l'icône et le fichier `.desktop` aux emplacements
standard : l'application apparaît alors dans le menu des applications.

L'archive `.tar.gz` installe la même chose dans `~/.local/`, sans aucun
droit particulier — c'est la solution pour un poste sur lequel on n'est pas
administrateur, un cas fréquent en milieu scolaire.

Aucune dépendance n'est déclarée au-delà de la libc : le binaire embarque
Python **et** Tcl/Tk, donc `python3-tk` n'a pas à être installé sur la
machine de l'utilisateur.
