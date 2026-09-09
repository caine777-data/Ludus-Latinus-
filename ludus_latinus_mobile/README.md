# 🏛️ Ludus Latinus Mobile (Android & Windows Multiplateforme)

Application mobile et desktop native d'apprentissage du latin pour le Collège et le Lycée, développée avec **Flutter & Dart**, propulsée par le moteur pédagogique et le dataset universel de **Ludus Latinus**.

---

## 🌟 Points Forts & Architecture

- **100% Natif & Sans Émulation** : Le même code Dart compile nativement en binaire ARM64 pour smartphones et tablettes Android, et en binaire x64 natif pour Windows.
- **Dataset Universel Embarqué** : Consomme directement ssets/data/ludus_latinus_dataset.json (26 Mondes, 113 Leçons, QCM, Dictionnaire Thesaurus, Forum Romanum, Flashcards Memoria Velox).
- **Mise à Jour Instantanée** : Si le cursus latin est modifié ou enrichi dans le cœur Python, l'exécution de python scripts/exporter_dataset_mobile.py régénère immédiatement le dataset mobile.
- **Offline-First & Cloud Sync** : Fonctionne 100% hors-ligne dans les transports ou en classe, avec synchronisation Tabularium Cloud et code secret **Tessera Hospitalis** pour transférer la progression d'un appareil à l'autre.

---

## 📱 Fonctionnalités Incluses dans l'App Mobile

1. **Tableau de Bord Impérial (HomeScreen)** :
   - Avatar Citoyen (Marcus 🤴 / Julia 👸) personnalisable.
   - Compteur de Sesterces (🪙 HS), série de flammes (🔥), et jauge de progression.
   - Accès rapide à la Via Appia, Memoria Velox, Forum Romanum et Thesaurus.
2. **La Via Appia Tactile (MapScreen)** :
   - Tracé vertical fluide adapté aux écrans de smartphones.
   - 26 bornes milliaires romaines gravées (I à XXVI) avec arcs de triomphe dorés.
   - Défilement tactile avec statut en temps réel (Validé, Débloqué, Verrouillé).
3. **Lecteur de Leçon Interactif (LessonScreen)** :
   - Parchemins d'immersion avec cartouches « Le Savais-tu ? » et « À Retenir ».
   - Clavier tactile de validation et QCM 2x2 avec retours visuels immédiats et sesterces de récompense.
4. **Memoria Velox Flashcards 3D (MemoriaScreen)** :
   - Cartes en marbre travertin avec animation de retournement 3D (Transform.rotateY).
   - Notation d'espacement Leitner (Facile, Moyen, Difficile).
   - Session chronométrée de 2 minutes pour réviser rapidement dans le bus ou la cour.
5. **Forum Romanum Impérial (ForumScreen)** :
   - 6 grands monuments historiques à reconstruire avec vos sesterces.
   - Bonus passifs permanents (+20% sesterces, +10% XP, indices quotidiens, titres honorifiques).
6. **Thesaurus Linguae Latinae (ThesaurusScreen)** :
   - Dictionnaire bilingue latin-français avec recherche instantanée et filtres catégoriels (Noms, Verbes, Adjectifs, Invariables).
   - Tables de déclinaisons interactives (1ère à 5ème déclinaison) avec ruban de couleurs grammaticales (Nominatif, Vocatif, Accusatif, Génitif, Datif, Ablatif).
7. **Tabularium & Profil (AccountScreen)** :
   - Gestion de l'identité citoyenne.
   - Sauvegarde par email et synchronisation Cloud.
   - Jeton d'hospitalité **Tessera Hospitalis** (SPQR-XXXX-XXXX) pour transfert instantané.

---

## 🚀 Guide de Démarrage & Compilation

### Prérequis
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version >= 3.19.0)
- Pour Android : Android Studio, Android SDK Platform 34, et un émulateur ou téléphone avec le Débogage USB activé.
- Pour Windows : Visual Studio 2022 avec la charge de travail *Développement C++ pour poste de travail*.

### 1. Installation des dépendances
Placez-vous dans le dossier ludus_latinus_mobile :
`ash
cd ludus_latinus_mobile
flutter pub get
`

### 2. Exécution en mode Développement
`ash
# Sur un smartphone Android connecté ou un émulateur :
flutter run

# Sur votre PC en exécutable natif Windows :
flutter run -d windows
`

### 3. Compilation pour Android (Google Play Store & APK)

#### A. Google Play Store (Android App Bundle - Recommandé)
Génère le paquet .aab optimisé avec compression dynamique par appareil :
`ash
flutter build appbundle --release
`
Le fichier généré se trouvera dans :
uild/app/outputs/bundle/release/app-release.aab

#### B. APK universel ou divisé par architecture (Installation directe)
`ash
# APK autonome :
flutter build apk --release

# APKs ultra-légers par processeur (ARM64, ARMv7, x86_64) :
flutter build apk --split-per-abi --release
`
Les fichiers générés se trouveront dans :
uild/app/outputs/flutter-apk/app-arm64-v8a-release.apk

### 4. Compilation pour Windows (.exe autonome natif)
`ash
flutter build windows --release
`
L'exécutable natif ultra-rapide (sans aucune VM Java ni émulateur) se trouve dans :
uild/windows/x64/runner/Release/ludus_latinus_mobile.exe

---

## 🔄 Régénération du Dataset depuis Python

Pour exporter les dernières leçons, exercices et mots du dictionnaire depuis le projet Python vers le mobile :
`ash
# Depuis la racine du projet latin_learn :
python scripts/exporter_dataset_mobile.py
`
Le script met à jour automatiquement ssets/data/ludus_latinus_dataset.json et synchronise le dossier ludus_latinus_mobile/assets/data/.