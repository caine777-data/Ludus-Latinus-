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

```bash
flutter build appbundle --release
```

Le fichier à envoyer est `build/app/outputs/bundle/release/app-release.aab`.
Pense à augmenter `version:` dans `pubspec.yaml` (ex. `1.0.1+2`) à chaque envoi :
le nombre après `+` doit toujours croître.

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
