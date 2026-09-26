# Publier Ludus Latinus sur le Google Play Store

Ce guide couvre ce que le code ne peut pas faire à ta place : créer la clé de
signature, et remplir la Play Console.

---

## 1. Créer la clé d'upload (une seule fois)

La clé prouve à Google que chaque mise à jour vient bien de toi.
**Si tu la perds, tu ne pourras plus mettre l'application à jour** (sauf
procédure de réinitialisation auprès de Google, longue).

Dans un terminal, depuis le dossier `ludus_latinus_mobile` :

```bash
keytool -genkey -v -keystore %USERPROFILE%\cles\ludus-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

`keytool` te demande deux mots de passe et quelques informations (nom,
organisation…). Choisis des mots de passe solides et note-les dans ton
gestionnaire de mots de passe.

Sauvegarde ensuite `ludus-upload.jks` **hors de ce PC** (clé USB, coffre en
ligne chiffré). Ne le mets jamais dans le dépôt git.

## 2. Déclarer la clé au projet

Crée le fichier `android/key.properties` (déjà exclu de git) :

```properties
storePassword=LE_MOT_DE_PASSE_DU_FICHIER
keyPassword=LE_MOT_DE_PASSE_DE_LA_CLE
keyAlias=upload
storeFile=C:\\Users\\caine\\cles\\ludus-upload.jks
```

Sans ce fichier, le build release est signé avec la clé de debug et un
avertissement s'affiche : ce paquet-là sera refusé par le Play Store.

## 3. Construire le paquet

### Le plus simple : GitHub le fait pour toi

À chaque modification de l'appli envoyée sur GitHub, le workflow
`.github/workflows/appli.yml` construit trois fichiers, à télécharger dans
l'onglet **Actions** → l'exécution → rubrique **Artifacts** :

| Fichier | Usage |
|---|---|
| `LudusLatinus.apk` | installer sur un téléphone |
| `LudusLatinus-PlayStore.aab` | envoyer sur la Play Console |
| `LudusLatinus-Windows.zip` | tester sur PC : décompresser, lancer `LudusLatinus.exe` |

Le numéro de version (celui après `+`) est celui de l'exécution du workflow :
il augmente tout seul, comme l'exige le Play Store.

Pour que GitHub signe avec **ta** clé, et que l'AAB soit accepté, ajoute ces
4 secrets dans le dépôt : **Settings → Secrets and variables → Actions →
New repository secret**.

| Secret | Valeur |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | le fichier `.jks` encodé en texte (commande ci-dessous) |
| `ANDROID_STORE_PASSWORD` | le mot de passe du fichier |
| `ANDROID_KEY_PASSWORD` | le mot de passe de la clé |
| `ANDROID_KEY_ALIAS` | `upload` |

Pour obtenir le texte du premier secret (PowerShell), puis le coller dans GitHub :

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("$env:USERPROFILE\cles\ludus-upload.jks")) | Set-Clipboard
```

Sans ces secrets, tout se construit quand même, mais signé avec une clé de
test : bien pour essayer, refusé par le Play Store. Le résumé de l'exécution
indique quelle signature a été utilisée.

### À la main, sur ce PC

```bash
flutter build appbundle --release --build-number 2
```

Le fichier à envoyer est `build/app/outputs/bundle/release/app-release.aab`.
Le `--build-number` doit toujours croître d'un envoi à l'autre.

## 4. Play Console : ce qui est obligatoire pour une appli destinée aux enfants

- **Signature d'application par Google Play** : l'activer à la création de l'appli.
- **Public cible** : tranche 9-12 ans et/ou 13-15 ans → l'appli relève du
  programme **Familles** (règles plus strictes).
- **Politique de confidentialité** : une page web publique, en français,
  qui explique quelles données sont collectées (nom du héros, email et
  synchronisation Tabularium, progression) et comment les supprimer.
- **Sécurité des données** : déclarer exactement la même chose.
- **Classification du contenu** (questionnaire IARC).
- **Publicités** : aucune, ou uniquement des réseaux certifiés Familles.
- **Test fermé** : un compte développeur personnel récent doit faire tester
  l'appli par au moins 12 testeurs pendant 14 jours avant la production.

## 5. Vérifier avant chaque envoi

- `flutter analyze` sans erreur.
- Tester le `.aab` via « Test interne » sur un vrai téléphone Android.
- Vérifier le son, le mode silencieux et un petit écran.
