# AGENTS.md — Règles de travail pour les agents IA

Ce fichier s'adresse à **tout agent IA** qui intervient sur ce dépôt :
Claude Code, Antigravity, Gemini, ou autre. Lis-le en entier avant de
toucher au code. Il prime sur tes habitudes par défaut.

---

## 1. Qui fait quoi

| Rôle | Qui | Responsabilité |
|---|---|---|
| **Porteur du projet** | Cédric | Décide de ce qu'on construit. Valide les contenus pédagogiques. Seul à publier sur le Play Store. |
| **Architecte** | Claude Code | Conçoit, découpe le travail en tâches, rédige `docs/TACHES.md`, relit et corrige ce qui a été fait. |
| **Exécutants** | Antigravity, Gemini 3.8 Flash | Réalisent **une tâche à la fois**, telle qu'elle est écrite dans `docs/TACHES.md`, puis rédigent un compte rendu. |

### Si tu es un exécutant

1. Ouvre `docs/TACHES.md` et prends **la première tâche au statut `À FAIRE`**.
   Fais-en une seule par session.
2. Respecte son **périmètre** : ne modifie que les fichiers qu'elle cite. Si
   tu dois en toucher un autre, arrête-toi et signale-le dans ton compte
   rendu plutôt que de décider seul.
3. Vérifie chaque **critère de réussite** de la tâche, avec les commandes de
   la section 4. Une tâche n'est finie que si tous passent.
4. Remplis le **compte rendu** sous la tâche : fichiers modifiés, commandes
   lancées et leur résultat réel, doutes, ce qui reste à faire. Passe le
   statut à `FAIT` ou `BLOQUÉ`.
5. Fais **un commit** par tâche (voir section 6). Ne pousse pas.
6. **Laisse l'émulateur comme tu l'as trouvé** : si tu actives une option de
   développeur (affichage du pointeur, des touchers…), éteins-la avant de
   finir (`adb shell settings put system pointer_location 0` et
   `show_touches 0`).

### Ce qu'un exécutant ne fait jamais

- Changer l'architecture, renommer ou déplacer des dossiers, créer un
  nouveau service ou un nouvel écran qui n'est pas demandé.
- Ajouter une dépendance (`pubspec.yaml`, `requirements.txt`, `pyproject.toml`).
- Modifier la signature Android, les clés, `key.properties`, les workflows CI
  (`.github/workflows/`), ou tout ce qui touche à la publication.
- Éditer à la main `assets/data/ludus_latinus_dataset.json` : ce fichier est
  **généré** (voir section 5).
- Réécrire du contenu pédagogique (leçons, traductions, Thesaurus) sans que la
  tâche le demande explicitement. Tout texte latin ajouté est marqué
  « à relire par Cédric » dans le compte rendu.
- Supprimer ou désactiver un test pour le faire passer.
- Faire `git push`, `git push --force`, `git reset --hard`, ou commiter sur
  `main`.
- Écrire une clé d'API, un mot de passe ou un jeton dans un fichier.

**En cas de doute, arrête-toi et écris la question dans le compte rendu.**
L'architecte tranchera. Une tâche `BLOQUÉ` bien expliquée vaut mieux qu'une
tâche `FAIT` qui a improvisé.

---

## 2. Le projet

**Ludus Latinus** : un jeu pour apprendre le latin au collège, de la 5e à la
3e : 26 mondes, 113 leçons, dans l'univers de la Rome antique. La mascotte
est **Lupulus**, un louveteau en toge. Le public a entre 11 et 15 ans : les
contenus, les textes et les images doivent convenir à cet âge.

Le dépôt contient **deux applications** qui partagent le même contenu :

| Dossier | Quoi | Statut |
|---|---|---|
| `ludus_latinus_mobile/` | **Application Flutter pour Android.** C'est la cible : publication sur le Play Store. | **Prioritaire** |
| `app/`, `main.py` | Ancienne application de bureau en Python + Tkinter. | Maintenue, mais secondaire |
| `content/` | Curriculum : mondes, leçons, exercices (Python). **Source de vérité du contenu.** | Partagé |
| `scripts/` | Export du contenu vers le mobile, outils d'images. | Partagé |
| `tests/` | Tests Python (unittest). | Partagé |

Sauf mention contraire, une tâche porte sur **l'application mobile**.

### Carte de l'application mobile

```
ludus_latinus_mobile/lib/
  data/
    models/          Modèles : UserProfile (profile.dart), GoodieItem, VocabQuestion…
    repositories/    GameRepository : progression, sesterces, étoiles, achats
    services/        AudioService (musiques + bruitages)
  ui/
    core/            Thème (RomanColors, RomanFonts), widgets communs, AvatarAssets
    features/        Un dossier par écran : home, map, lesson, boutique, duel…
      map/           Via Appia : map_screen.dart (bornes, bannières des mondes)
                     et via_appia_road.dart (la chaussée pavée, peinte rangée par rangée,
                     et ViaAppiaProp : les éléments plantés au bord de la route)
assets/
  data/ludus_latinus_dataset.json   GÉNÉRÉ — ne pas éditer
  images/boutique/  <id>.png         20 articles, 256 px, fond transparent
  images/avatars/   <genre>_<toge>_<140|48>.png
  images/mondes/    monde<N>.webp    26 décors, bannières de la Via Appia
  images/via/       <nom>.png        8 éléments de bord de route, proportions réelles
  images/animated/  lupulus_<humeur>.webp  Lupulus animé (WebP transparent, en boucle) :
                    idle (= attente), joie, reflexion, salut, triomphe — voir LupulusMood
  (windows/          projet Windows versionné : exe LudusLatinus.exe, fenêtre portrait 460x900)
  audio/            bruitages WAV mono 44,1 kHz + 3 musiques OGG — voir AudioService
  cinematics/       vidéos 9:16 avec bande-son : intro, triumph,
                    boss_<retiaire|lion|minotaure|sphinx|mercure>, niveau_<5e|4e|3e>
  fonts/
```

---

## 3. Les pièges déjà rencontrés

Chacun de ces pièges a déjà coûté du temps sur ce projet. Lis-les.

1. **La classe de profil s'appelle `UserProfile`**, pas `Profile`
   (`lib/data/models/profile.dart`).
2. **Un build qui échoue peut sembler réussir.** Si le code Dart ne compile
   pas, l'APK précédent reste en place et s'installe sans erreur visible.
   Lance **toujours** `flutter analyze` avant `flutter build`, et lis la
   dernière ligne de sortie du build.
3. **Ne jamais écrire le chemin d'un avatar en dur.** Passe par
   `AvatarAssets.medaillon(profile)` (ou `taille: 48` pour la carte).
4. **Tests Tkinter : ferme toujours la racine avec
   `detruire_racine(root)`** (`tests/tk_base.py`), jamais avec
   `root.destroy()` seul. Sinon la CI Linux plante en fin de suite
   (`Tcl_AsyncDelete … core dumped`).
5. **Icônes Tkinter : passe la fenêtre** — `charger_icone(nom, taille,
   master=self.root)`. Une image n'appartient qu'à un seul interpréteur Tk.
6. **`flutter test` peut régénérer `analysis_options.yaml`.** Vérifie
   `git status` avant de commiter et ne commite pas ce fichier par accident.
7. **Recherche de mots latins : mot entier uniquement.** « ire » ne doit pas
   correspondre dans « écrire ». Utilise les regex existantes
   (`VocabQuestion._appearsIn`, `_monde_du_mot` côté Python).
8. **PowerShell** : `$` dans une chaîne entre guillemets doubles est
   interprété. Pour modifier un fichier, préfère l'outil d'édition de fichier
   à une commande shell.
9. **La route de la Via Appia dépend de la géométrie des bornes.** Le
   serpentin vient de `serpentinOffset()` (`via_appia_road.dart`), partagé
   par les bornes et la route. La hauteur du centre de la borne est calculée
   à la main dans `map_screen.dart` : marge 10 + pion 46 (s'il est là) + demi-
   borne 31. **Si tu changes la taille d'une borne, du pion ou leur marge,
   mets ce calcul à jour**, sinon la route ne passe plus sous les bornes.
10. **Ne lance pas `dart format` sur un fichier existant entier** : il
    reformate tout le fichier et noie la vraie modification dans le diff.
    Formate seulement les fichiers que tu crées.
11. **Un `Stack` aligne ses enfants en haut à gauche par défaut.** Sur la
    carte, envelopper une borne dans un `Stack` sans
    `alignment: Alignment.topCenter` la décale hors de la route (déjà
    arrivé). Vérifie toujours une modification de la carte sur l'émulateur.
12. **Vidéo d'entrée de niveau : une seule fois, décidée par
    `GameRepository.enterLevelOf()`**, appelée à l'ouverture de
    `LessonScreen`. Ne la déclenche pas ailleurs : les leçons s'ouvrent
    depuis la carte et depuis l'accueil, c'est pour ça qu'elle est dans
    l'écran de leçon. Un profil qui a déjà validé une leçon du niveau ne la
    voit pas.
13. **Tout QCM doit mélanger ses réponses au premier affichage.** Dans le
    dataset, la bonne réponse est très souvent la première (82 % des QCM,
    78 % des questions d'arène) : un écran qui affiche les options dans
    l'ordre des données laisse gagner sans lire.
14. **Lupulus : utilise `lupulusAnimation(LupulusMood.xxx)`** ou
    `AnimatedLupulusAvatar(mood: …)` plutôt qu'un chemin d'image en dur.
    Les images fixes de `images/lupulus/` ne servent plus que de secours
    (`errorBuilder`) et pour les costumes (centurion, gladiateur, imperator,
    philosophe…), qui n'ont pas d'animation.
15. **Un mini-jeu ne verse jamais de sesterces avec `addSesterces` en direct.**
    Une partie gagnée passe par `GameRepository.payerPartie(jeu, montant)`
    (3 parties payées par jour et par jeu), un exercice unique par
    `payerUneFois(cle, montant)` ou `validerMissionCesar`, qui l'enregistrent
    dans le profil, et toute
    réussite appelle `accomplirDefi(jeu)` pour le défi du jour. Barème : une
    partie gagnée vaut à peu près une leçon (10 HS) ; `gainCircus`,
    `gainDuel`, `gainMissionCesar`, `gainMemoria`. Sans ça, un jeu en boucle
    rapportait plus que toutes les leçons.
16. **Ne commite que les fichiers de ta tâche** (`git add <fichier>`, jamais
    `git add -A` ni `git add .`) : l'architecte et l'exécutant travaillent
    parfois en même temps dans le même dépôt.
17. **Une animation WebP ne rejoue pas toute seule** : Flutter garde l'image
    décodée en cache et la reprend là où elle en était. Pour la rejouer
    depuis le début (l'impact d'épées du Duel à chaque coup), appelle
    `AssetImage(...).evict()` et donne au widget `Image` une nouvelle `key`.

---

## 4. Commandes

Sur la machine de Cédric (Windows). Les chemins sont absolus.

```bash
# --- Application mobile (depuis ludus_latinus_mobile/) ---
C:/Users/caine/dev/flutter/bin/flutter.bat analyze          # OBLIGATOIRE avant tout build
C:/Users/caine/dev/flutter/bin/flutter.bat test
C:/Users/caine/dev/flutter/bin/flutter.bat build apk --debug

# Émulateur
C:/Users/caine/dev/android-sdk/emulator/emulator.exe -avd Pixel_Ludus -no-boot-anim
C:/Users/caine/dev/android-sdk/platform-tools/adb.exe install -r build/app/outputs/flutter-apk/app-debug.apk
C:/Users/caine/dev/android-sdk/platform-tools/adb.exe shell monkey -p com.luduslatinus.app -c android.intent.category.LAUNCHER 1
C:/Users/caine/dev/android-sdk/platform-tools/adb.exe exec-out screencap -p > capture.png

# --- Python (depuis la racine du dépôt) ---
python -m unittest discover -s tests       # 248 tests, doivent tous passer
python -m ruff check .                     # style, doit afficher « All checks passed! »
python main.py --check                     # contrôle de l'installation
python scripts/exporter_dataset_mobile.py  # régénère le dataset du mobile
```

**Tests Flutter : tous doivent passer** (57 sur 57 le 01/10/2026 ; 54 sur 54 depuis T12, le
27/09/2026). Il n'y a plus d'échec connu : tout échec est une régression,
et il est de ta responsabilité.

### Construction automatique (GitHub Actions)

**Un seul workflow : `.github/workflows/appli.yml`.** Il se lance à chaque
envoi de code sur toute branche sauf `main` (qui est une copie de la branche
de travail ; un envoi qui ne touche que `docs/` ou des `.md` ne déclenche
rien), et à la main par « Run workflow ».

| Job | Fait | Produit |
|---|---|---|
| `contenu` | tests Python, `main.py --check`, style (ruff) | rien |
| `android` | `flutter analyze`, `flutter test`, puis compilation | `LudusLatinus.apk`, `LudusLatinus-PlayStore.aab` |
| `windows` | compilation Flutter Windows | `LudusLatinus-Windows.zip` |

Les trois jobs sont indépendants : un échec de `contenu` n'empêche pas
d'obtenir l'APK. **Ne renomme pas `appli.yml`** : le numéro de version du Play
Store est le numéro d'exécution de ce workflow, un renommage le remettrait à 1.
Les anciens `tests.yml` et `build.yml` (installateurs de l'appli Python de
bureau) sont supprimés : `DIFFUSION.md` et `packaging/` ne servent plus qu'à
une construction en local.

Flutter est figé à la même version qu'en local (`FLUTTER_VERSION` dans
`appli.yml`) : si tu mets Flutter à jour sur le PC, mets aussi ce numéro à
jour. La signature Play Store vient de secrets GitHub (voir
`ludus_latinus_mobile/PUBLICATION.md`) ; **`key.properties` et `*.jks` ne
doivent jamais être commités** (ils sont dans `.gitignore`).

La version Windows ne peut pas être compilée sur ce PC (Visual Studio absent) :
elle se vérifie avec l'archive produite par `appli.yml`.

**Une modification visible à l'écran se vérifie sur l'émulateur**, avec une
capture d'écran jointe au compte rendu. « Ça compile » ne suffit pas.

---

## 5. Contenu et images

### Le contenu pédagogique

Le contenu se modifie **côté Python**, puis s'exporte vers le mobile :

1. modifier `content/` ou `app/thesaurus*.py` ;
2. lancer `python scripts/exporter_dataset_mobile.py` : il écrit
   `assets/data/ludus_latinus_dataset.json` **et** la copie que lit l'appli
   mobile, `ludus_latinus_mobile/assets/data/ludus_latinus_dataset.json` ;
3. commiter la source **et** les deux JSON régénérés ensemble.

Dans `app/thesaurus_complement.py`, seule la section « Mondes 15 à 26 »
(52 mots) a été validée par Cédric ; le reste (88 mots) n'a **pas encore été
relu**. N'y ajoute rien sans que la tâche le demande. Un mot sans clé
`monde` est rattaché au premier monde dont une leçon l'emploie sous sa forme
de dictionnaire ; donne-lui un `monde` explicite si les leçons n'emploient
qu'une forme fléchie (comme `homo`, qu'on ne lit que sous la forme
*hominis*).

### Les images générées dans Gemini

Cédric génère les images et les dépose dans
`C:\Users\caine\Downloads\LATIN_LEARN\gemini ludus\`. Les scripts de
`scripts/assets/` les traitent :

| Script | Entrée | Sortie |
|---|---|---|
| `chroma_boutique.py [id …]` | `<id>.jpg` sur fond vert | `images/boutique/<id>.png` détouré, 256 px |
| `chroma_avatars.py [genre_toge …]` | `avatar_<genre>_<toge>.jpg` | `images/avatars/…_140.png` et `_48.png` |
| `icones.py` | `icone_<nom>.jpg` (liste `ICONES`) | `images/icone_<nom>.png`, marge pour un médaillon rond |
| `decors_mondes.py [N …]` | `decor_monde<N>.jpg` | `images/mondes/monde<N>.webp` |
| `via_elements.py [nom …]` | `via_<nom>.jpg` | `images/via/<nom>.png`, recadré au ras, sans carré |
| `lupulus_videos.py [humeur ou effet …]` | `lupulus_<humeur>.mp4`, ou un effet de `EFFETS` (fond vert) | `images/animated/*.webp`, son retiré ; un effet peut ne garder qu'une plage d'images |
| `illustrations.py [nom …]` | `stele_vierge`, `cas_<cas>`, `boss_retiaire`, `decor_colisee_duel` | `images/epigraphie/`, `images/cas/`, `images/duel/`, WebP ; détourage par « verdeur », qui tient sur un fond vert dégradé |

| `bruitages.py [nom …]` | `<nom>.wav` | `audio/<nom>.wav` : silences coupés, crête -3 dB, mono 44,1 kHz |

`lupulus_videos.py` et `bruitages.py` demandent `pip install imageio-ffmpeg numpy`
(outils de préparation seulement, pas des dépendances de l'app).

Les **cinématiques** (vidéos plein écran avec son) sont seulement ré-encodées
pour alléger l'APK, avec le ffmpeg d'`imageio_ffmpeg` :
`-c:v libx264 -preset slow -crf 25 -pix_fmt yuv420p -movflags +faststart -c:a aac -b:a 96k`.

Règles pour les images :
- tout ce qui doit être détouré est généré sur **fond vert uni `#00FF00`** ;
- **aucun texte** dans les images ;
- contrôle **toujours** le résultat visuellement (frange verte, sujet rogné)
  avant de commiter ;
- garde l'APK léger : vise quelques dizaines de Ko par image.

Pour les **prompts Gemini** : ne donne jamais d'âge chiffré à un personnage
enfant (« 12-year-old » est refusé) ; écris « young Roman schoolboy with
childlike cartoon proportions ». Décris le personnage en entier dans chaque
prompt : « same character » seul est traité comme une retouche de photo et
refusé.

---

## 6. Conventions

- **Langue : français** partout — commentaires, messages de commit, textes de
  l'interface, comptes rendus. Les identifiants de code restent tels quels.
- **Imite le code voisin** : même densité de commentaires, même nommage. Un
  commentaire explique *pourquoi*, pas *quoi*.
- **Accents obligatoires** : écris « leçon », jamais « lecon ».
- **Commits** : un par tâche, au format `type(portée): résumé en français`,
  par exemple `fix(mobile): …`, `feat(mobile): …`, `fix(tests): …`. Le corps
  du message explique le problème et la solution.
- **Branche** : travaille sur la branche courante (`git branch --show-current`),
  jamais sur `main`.

---

## 7. Dernières évolutions

Tenue à jour par l'architecte à chaque changement. La plus récente en haut.

- **L'Épigraphie se mérite** (01/10/2026) — avant, la traduction complète
  était affichée d'emblée et un seul bouton payait 15 HS. Maintenant
  (`latin_epigraph_modal.dart`) : la traduction complète est cachée tant que
  la stèle n'est pas déchiffrée ; le bouton « Estamper » ne s'active qu'une
  fois chaque fragment examiné ; il lance trois questions (« Que signifie ce
  fragment ? », choix tirés des autres fragments de la même stèle) ;
  15 HS sans erreur, 8 HS après une erreur. Test :
  `test/epigraphie_test.dart` (57 tests Flutter). Limite connue : fermer et
  rouvrir la stèle remet le compteur d'erreurs à zéro. Pas encore vu à
  l'écran : c'est dans T30.

- **Exercices de 3e réécrits** (validés par Cédric le 01/10/2026) — les 16
  trous et puzzles des mondes 19 à 26 suivent le même principe que la 5e et
  la 4e : le cours garde son exemple traduit, l'exercice applique la règle
  à une autre phrase, les pièges des puzzles sont grammaticaux.
  `tests/test_reponses_cachees.py` couvre maintenant les mondes 1 à 26.
  Deux mots ajoutés au Thesaurus : *longus* (monde 20), *tegere* (monde 21).
  Le brouillon T29 de Gemini annonçait à tort que tout le vocabulaire était
  au Thesaurus : toujours revérifier ce genre d'affirmation.

- **T24 à T29 relues, série T30 à T36** (01/10/2026) — corrections tirées
  des tournées de Gemini (commit `63fb54d`) : les boutons de fin du Duel et
  du Circus sont dans un `Wrap`, le panneau de fin du Circus défile, la
  hauteur des cartes des cas suit la taille de police
  (`MediaQuery.textScalerOf`), les badges de l'en-tête de leçon sont
  `Flexible`. Sept fichiers qu'aucun code ne citait sont supprimés (2,4 Mo).
  **Ces corrections n'ont pas encore été vues à l'écran** : c'est T30.
  Suite confiée : test anti-débordement (T31), tournée sur petit téléphone
  (T32), Circus qu'on ne gagne plus sans répondre (T33), titres rognés
  (T34), poids de l'appli (T35), brouillon du README (T36).

- **Branches** (01/10/2026) — `main` a été avancée jusqu'à la branche de
  travail `fix/mobile-publiable-lisible` ; l'architecte la remet à niveau à
  chaque étape. Les exécutants continuent de travailler sur la branche de
  travail et ne poussent jamais sur `main`.

- **Un seul workflow GitHub** (01/10/2026) — `tests.yml` et `build.yml`
  supprimés, leur contenu utile repris dans `appli.yml` : un job `contenu`
  (tests Python, ruff), un job `android` (qui lance désormais aussi
  `flutter test`), un job `windows`. Déclenché à chaque envoi de code, plus
  en double sur les pull requests. Voir la section 4.

- **T23 validée et ses défauts corrigés** — les cinq boss testés sur
  l'émulateur. Le panneau de victoire du Duel défile (il ne déborde plus),
  le message du quota est raccourci (« Pour la gloire : 3 duels payés par
  jour », idem Circus), et la jauge affiche le nom court du boss (clé
  `court` de sa fiche). Série confiée pendant l'absence de l'architecte :
  T24 à T29 (tests anti-débordement, tournées d'essai du Circus, de César,
  du Marché, de la Taverne et des écrans de révision, images orphelines,
  brouillon des exercices de 3e).
- **T22 validée** — `flutter analyze lib` : 2 remarques seulement (le `background` volontaire de `themes.dart`). Reste T23 pour Gemini.
- **T20 et T21 validées** — plus d'API obsolète hors `themes.dart` (le
  `background` du thème reste volontairement : le changer éclaircirait le
  fond du mode sombre) ; `flutter analyze lib` passe de 58 à 10 remarques.
  Suite confiée : T22 (les 8 dernières) et T23 (tournée d'essai des cinq boss).
- **Sphinx et Minotaure animés, pièces en 3D** — portraits animés
  `boss_sphinx_anime.webp` et `boss_minotaure_anime.webp` (vidéos Gemini,
  jouées à l'aller puis au retour ; `PORTRAITS` dans `illustrations.py`).
  `RomanLottieEffects.showCoinShower` joue désormais `pieces_or.webp`.
  Les anciens `boss_sphinx_140.png` et `boss_minotaure_140.png` restent :
  l'appli de bureau (`app/vues_exercices.py`) s'en sert. Les cinq boss du
  Duel sont désormais animés (`boss_<nom>_anime.webp`, vidéos Gemini
  `Le_Retiaire`, `Le_Lion`, `Le_Mercure`, `Le_Sphinx`, `Le_Minotaure`).
- **Duel animé et visuels du 28/09** (vérifiés sur l'émulateur) —
  `duel_screen.dart` : décor `images/duel/decor_colisee.webp`, scène
  `_buildScene` pilotée par `_assaut` (900 ms : élan de l'attaquant, recul,
  flash rouge et bascule de la cible, impact `duel_impact.webp`, dégâts qui
  s'élèvent) ; le vaincu tombe et pâlit ; les jauges abrègent les noms.
  Le premier boss s'appelle **Crixus le Rétiaire** (`boss_retiaire.webp`) ;
  l'enfant gladiateur `boss_gladiateur_140.png` reste l'icône du Colisée dans
  Ludi. L'éclat d'épées et la pluie de pièces Lottie ne servent plus dans le
  Duel (la pluie de pièces a depuis été refaite en 3D).
  Stèle de l'Épigraphie (`images/epigraphie/stele_vierge.webp`), cartes des
  six cas en tête de l'onglet Déclinaisons du Thesaurus
  (`images/cas/cas_<cas>.webp`), Lupulus qui encourage après une erreur de
  leçon (`LupulusMood.encouragement`), explication de « HS » en touchant les
  sesterces de la boutique. **À revoir** : l'Épigraphie affiche la
  traduction complète avant tout déchiffrage.
- **T18 et T19 validées** — un test garde la 5e ; les 59 remarques de
  l'analyse sont triées. Suite confiée : T20 et T21.

- **Exercices de 5e : la réponse n'est plus dans le cours** (validé par
  Cédric) — 16 exercices réécrits sur les 22 de 5e. Principe à suivre pour
  la 4e et la 3e : le cours garde son exemple traduit comme modèle, et
  l'exercice porte sur **une autre phrase** qui applique la même règle ; les
  puzzles n'ont plus de glose mot à mot (seulement les mots nouveaux, sous
  leur forme de dictionnaire) et leurs pièges portent sur la grammaire
  (singulier ou pluriel, sujet ou COD) ; aucune consigne ne donne la
  solution entre parenthèses. Gardés tels quels : m1-02, m1-05 (découverte),
  m7-03 (devise), m8-03, m9-03, m10-03 (civilisation à choix). Diagnostic
  complet : T17. **4e faite aussi** (16 exercices, validés par Cédric le
  28/09) : m14-02 teste enfin l'accord au neutre (*ingentia*) ; les
  tableaux d'*esse* (m15-02, m16-02) donnent le singulier et la règle du
  pluriel au lieu des formes toutes faites. `tests/test_reponses_cachees.py`
  garde les mondes 1 à 18 (`MONDES_REECRITS`). **Reste la 3e.**
- **T15 à T17 validées** — plus aucun `withOpacity` dans `lib/` ;
  diagnostic des leçons qui donnent la réponse (83 exercices sur 87).
- **Visuels demandés à Cédric (28/09)** — `stele_vierge.jpg` (support des
  inscriptions de l'Épigraphie), six cartes des cas `cas_<cas>.jpg` (Lupulus
  illustre le rôle du cas, sans halo : la couleur du cas sera un cadre dans
  l'appli), vidéo `lupulus_encouragement.mp4` (après une erreur). Aucun
  script ne les traite encore : à écrire à leur arrivée.

- **Thesaurus enrichi pour la 3e** (validé par Cédric) — 52 mots pour les
  mondes 15 à 26, tirés des leçons de chaque monde (219 entrées en tout ;
  4 à 11 mots par monde au lieu de 0 à 5). Nouvelle catégorie « Pronom »
  (*is, ea, id* ; *qui, quae, quod*), avec son filtre dans le Thesaurus
  mobile et de bureau. `homo` rattaché au monde 26. Latin corrigé en m21-03 :
  « Mons Vesuvius nubem atram erigebat ». L'export écrit désormais aussi la
  copie mobile du dataset.

- **Icône de l'Épigraphie** (vérifiée sur l'émulateur) — stèle et loupe
  Gemini (`images/icone_epigraphie.png`, `scripts/assets/icones.py`) sur la
  tuile de la Bibliotheca, à la place du logo du centurion, et dans
  l'en-tête de l'atelier du Forum, dont le titre passe désormais à la ligne
  au lieu de déborder.

- **Économie des mini-jeux** (tests `recompenses_jeux_test.dart` et
  `cesar_mission_test.dart`) — Circus et Duel : 12 et 15 HS par victoire,
  3 parties payées par jour et par jeu (`UserProfile.recompensesJeux`) ; le
  score en course et en combat est affiché en points. César : l'énoncé ne
  donne plus la clé ; une fois la clé trouvée, l'élève choisit la
  traduction parmi trois ; 10 HS par mission, une seule fois (5 après une
  erreur), missions retenues dans `UserProfile.missionsCesar`. Le décodeur
  entre camarades ne paie plus. Défi du jour : 10 HS, versés par
  `accomplirDefi` quand le défi est réussi dans le jeu (course ou duel
  gagné, mission de César, 5 bonnes réponses dans Memoria, étal du Marché
  réussi, Gaius battu), et plus au toucher du bouton de l'accueil.
  Marché (test `marche_paiement_test.dart`) : étal 5 HS, rendu de monnaie
  5 HS, négociation 10 HS, chacun payé une seule fois
  (`GameRepository.payerUneFois`, clés `marche:etal:<n>`… dans
  `UserProfile.recompensesUniques`) et rien s'il a été raté pendant la
  visite ; la somme à rendre n'est plus affichée. **La phase 1 est terminée.** Le latin fautif de deux missions de César
  (*nitidet* n'existe pas) est remplacé : « Alea iacta est. Rubiconem
  transeo ! » et « Fortiter pugnate, milites ! Victoria nostra erit ! ».
- **T13 et T14 validées** — `withOpacity` retiré de 7 fichiers de plus.
  Suite confiée : T15 et T16 (les 35 derniers), T17 (diagnostic des leçons
  qui donnent la réponse avant l'exercice, base du prochain chantier de la
  phase 2).
- **T12 validée : toute la suite Flutter passe (54 tests sur 54).** La
  syllabation garde entiers `tʃ`, `dʒ`, `ts` et `kw` (« vi.tʃi »,
  « se.kwi.tur »). Un test qui échoue est désormais une vraie régression.
- **T11 validée** — les tests du puzzle et du décodeur utilisent les clés
  du dataset ; seul reste l'échec de la prononciation (T12).
- **T5 à T10 validées** (exécutant Gemini) — le compte garde le prénom ; le
  Marché ne paie plus d'erreur ; diagnostics des tests et du Thesaurus ;
  `withOpacity` retiré de six fichiers. Suite confiée : T11 à T14.

- **Memoria honnête** (vérifiée sur l'émulateur) — le paquet vient de
  `GameRepository.memoriaCards` : les mots du Thesaurus des mondes où au
  moins une leçon est validée (vide avant la première leçon, avec un message).
  L'élève choisit la traduction parmi quatre, au lieu de se noter lui-même ;
  la carte ne se retourne qu'après la réponse. Gain :
  `GameRepository.gainMemoria` (2 HS), seulement sur une carte à réviser.
  **Le paquet est figé pour la séance** (`_seance`) : retrié à chaque
  affichage, il faisait passer une autre carte sous la carte retournée.
  Les filtres 5e / 4e / 3e suivent le monde du mot. Clés de progression :
  `th:<latin>`.
  Depuis l'enrichissement du 27/09, chaque monde de 15 à 26 a de 4 à 11 mots.

- **Paramètres et choix du héros** (vérifiés sur l'émulateur ; formulaire
  couvert par `test/hero_form_test.dart`) — `lib/ui/features/settings/` : `HeroForm` (fille ou garçon
  avec aperçu de l'avatar, prénom de 18 caractères au plus), partagé par
  `HeroCreationScreen` (premier lancement, juste après l'intro, impossible à
  quitter sans prénom) et `SettingsScreen` (héros, son via
  `RomanAudioModal`, revoir l'intro), ouvert par la roue dentée de l'accueil
  qui remplace l'icône du son. `UserProfile.heroChoisi` est vrai d'office
  pour un profil qui a déjà progressé.
- **T2 et T3 validées** (exécutant Gemini) — réponses mélangées dès
  l'affichage dans les leçons et l'arène ; intro à chaque démarrage.
  T4 validée : l'arène ne révèle plus la bonne réponse après une erreur.

- **Vidéos allégées** — l'intro et le triomphe ré-encodés (6,3 Mo → 2,6 Mo) ;
  `boss_entrance.mp4` supprimé, devenu inutile depuis les vidéos par boss.

- **CI simplifiée** — un seul workflow `appli.yml` produit l'APK, l'AAB Play
  Store (numéro de version = numéro d'exécution) et la version Windows. Le
  projet Windows est versionné (plus régénéré à chaque exécution), l'exe
  s'appelle `LudusLatinus.exe`. L'ancien `build_mobile.yml` est supprimé ;
  le workflow de l'appli Python ne se lance plus qu'à la main.

- **Lupulus triomphant animé** — coupe levée et étincelles, en fin de monde,
  à la victoire du Duel et du Circus, et dans Memoria (série de 5 et bilan).
  Les 5 humeurs de Lupulus sont désormais toutes animées.

- **Assets refaits** — Sphinx à visage humain, Lupulus joyeux qui garde sa
  couronne sur toute l'animation, nouvelle acclamation de la foule (coupée à
  2,6 s et baissée de 5 dB : `DUREE_MAX` et `GAIN_EXTRA` dans
  `scripts/assets/bruitages.py`).

- **Boss du Duel** — chacun des 5 boss a sa vidéo d'entrée (clé `video` de
  sa fiche dans `duel_screen.dart`) ; à défaut, celle du Rétiaire.
- **Vidéos de niveau** — survol de la Rome de chaque époque, joué la
  première fois que l'élève ouvre une leçon de 5e, de 4e ou de 3e
  (`UserProfile.niveauxVus`, `RomanCinematicOverlay.showLevel`).
- **Bruitages** — achat (`playPurchase`), fin de monde
  (`playWorldComplete`, après la vidéo de triomphe), carte révélée au
  Panthéon (`playCardObtained`, à la place de la fanfare), page tournée
  (`playPage`, onglets de la boutique et du Thesaurus) ; le choc d'épées est
  remplacé par la version Gemini.

- **Lupulus animé** — les 4 vidéos Gemini sont devenues des WebP animés
  transparents (environ 280 Ko chacun, 10 images/s, son retiré).
  `LupulusMood` choisit l'animation ; la leçon (réussite, indice) et Memoria
  utilisent désormais « joie » et « réflexion » animés.
- **Bord de route** — 8 éléments (pin, cyprès, borne, fontaine, amphores,
  mausolée, charrette, colonne) plantés une borne sur deux, du côté libre du
  serpentin, estompés devant l'élève comme la route.

- **Via Appia pavée** — la chaussée n'est plus un fond fixe : chaque rangée
  de la carte peint son tronçon (`ViaAppiaRoadPainter`), qui passe sous sa
  borne et se raccorde aux voisines. Pavés de basalte, bordure de travertin,
  bas-côtés en terre. La route est pleine là où l'élève est passé, estompée
  devant lui.
- **Décors des mondes** — les 26 décors Gemini servent de bannière à chaque
  monde sur la carte (`_WorldBanner`, `assets/images/mondes/`).
- **Avatars selon la toge** — `AvatarAssets.medaillon()` ; seules les 5 toges
  changent l'avatar, pas encore les couronnes ni les accessoires.
- **Boutique illustrée** — 20 articles avec image détourée.
- **CI Linux** — plus d'abandon Tcl en fin de suite (`tests/tk_base.py`).

### Décisions de Cédric (à respecter)

- **La première leçon de chaque monde reste ouverte d'emblée**, y compris
  en 4e et en 3e : un professeur doit pouvoir faire travailler directement
  le niveau de sa classe. Ne pas verrouiller.
- **Trois leçons par notion lourde** (ablatif absolu, passif, proposition
  infinitive…), la troisième servant de révision.
- Pas de version web : les cibles sont Android (APK, Play Store) et
  Windows (test sur PC).
- **Prononciation : restituée par défaut.** La leçon m1-01 enseigne la
  prononciation restituée (C = [k], V = [w]) ; le diagnostic T7 montre que
  le moteur produit les deux et que la fenêtre de prononciation s'ouvre sur
  la restituée, l'ecclésiastique restant en option. C'est cohérent : rien à
  trancher, sauf avis contraire de Cédric. Le défaut de syllabation de
  l'ecclésiastique (« vit.ʃi ») est corrigé (T12).

### Prochaines étapes envisagées (décidées par l'architecte)

Issues de l'audit pédagogique du 24/09/2026 (rapport :
https://claude.ai/artifact/5G9NxprB69Ehc7Tng1oXSY). Dans l'ordre :

1. **Phase 1, réparer ce qui fausse le jeu** — réponses mélangées dès
   l'affichage (T2) ; intro à chaque démarrage (T3) ; Memoria limitée aux
   mondes atteints et sans auto-évaluation payée ; menu Paramètres (nom,
   fille ou garçon, son, revoir l'intro) et choix du héros au premier
   lancement ; icône de l'Épigraphie ; **économie tenue** : un plafond
   quotidien par mini-jeu (comme la Taverne, 3 par jour), missions de César
   et étals du Marché payés une seule fois et retenus dans le profil, plus de
   pièces pour une mauvaise réponse, César validé par une réponse et non
   par la roue.
2. **Phase 2, refonte pédagogique** (contenu validé par Cédric) — enseigner
   les 1re et 2e déclinaisons en 5e ; trois exercices tirés du cours par
   leçon (reconnaître, appliquer, traduire, y compris français → latin) ;
   ne plus écrire la réponse dans le cours ni la consigne ; une explication
   par mauvaise réponse ; arènes rééquilibrées et avec un vrai enjeu ;
   Circus et Duel qui tirent une partie de leurs questions des mondes
   atteints ; une carte du Panthéon par monde terminé.
3. **Phase 3, visuels Gemini** — cartes des six cas, en-têtes des
   leçons-récits de 4e et 3e, stèle vierge de l'Épigraphie.
- Teinte du sol qui change avec le cycle (5e, 4e, 3e).

---

## 8. Passation entre l'architecte et les exécutants

`docs/TACHES.md` est le seul canal de passation. Il contient :

- **les tâches**, écrites par l'architecte, chacune avec un objectif, un
  périmètre, des étapes et des critères de réussite ;
- **les comptes rendus**, écrits par l'exécutant sous chaque tâche.

Quand l'architecte reprend la main, il lit les comptes rendus, vérifie le
travail et corrige si besoin. **C'est l'architecte qui tient ce fichier
`AGENTS.md` à jour.** Si tu découvres un piège ou une convention qui
manque, ne modifie pas `AGENTS.md` : écris-le dans ton compte rendu, sous
« Doutes, questions pour l'architecte ». **Un compte rendu honnête** (« le test X échoue
encore », « je n'ai pas pu vérifier sur l'émulateur ») est plus utile qu'un
compte rendu rassurant. Ne prétends jamais avoir vérifié ce que tu n'as pas
vérifié.
