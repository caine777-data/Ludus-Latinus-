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
      settings/      settings_screen.dart (réglages, entrée « À propos ») et
                     about_screen.dart (logo de l'éditeur, version lue par package_info_plus)
      map/           Via Appia : map_screen.dart (bornes, bannières des mondes)
                     et via_appia_road.dart (la chaussée pavée, peinte rangée par rangée,
                     et ViaAppiaProp : les éléments plantés au bord de la route)
assets/
  data/ludus_latinus_dataset.json   GÉNÉRÉ — ne pas éditer
  images/boutique/  <id>.png         20 articles, 256 px, fond transparent
  images/avatars/   <genre>_<toge>_<140|48>.png
  images/mondes/    monde<N>.webp    26 décors, bannières de la Via Appia
  images/via/       <nom>.png        8 éléments de bord de route, proportions réelles
  images/studio/    logo_icare_dedale_<clair|sombre>.png  logo de l'éditeur (À propos)
  images/animated/  lupulus_<humeur>.webp  Lupulus animé (WebP transparent, en boucle) :
                    idle (= attente), joie, reflexion, salut, triomphe — voir LupulusMood
  (windows/          projet Windows versionné : exe LudusLatinus.exe, fenêtre portrait 460x900)
  audio/            bruitages WAV mono 44,1 kHz + 3 musiques OGG — voir AudioService
  cinematics/       vidéos 9:16 avec bande-son : icare_dedale (studio), intro, triumph,
                    circus_depart, boss_<retiaire|lion|minotaure|sphinx|mercure>,
                    niveau_<5e|4e|3e>
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
18. **Une hauteur fixe qui contient du texte casse en police agrandie.**
    Pour la faire suivre la police, mesure le facteur sur une petite taille :
    `MediaQuery.textScalerOf(context).scale(12) / 12`. Android agrandit moins
    les grandes tailles : `scale(84)` ne bouge presque pas. Et un écran se
    vérifie aussi en 360 x 640 (`adb shell wm size 720x1280` et
    `wm density 320`, puis `reset`) : un `GridView` non défilable y pousse
    ses dernières cases hors de l'écran.

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

**Tests Flutter : tous doivent passer** (76 sur 76 le 08/10/2026 ; 54 sur 54 depuis T12, le
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
| `icone_appli.py` | `icone_appli.jpg` (casque de centurion, portrait) | icône Android adaptative (`mipmap-*/ic_launcher_foreground.png` + `mipmap-anydpi-v26/ic_launcher.xml` + couleur `values/ic_launcher_background.xml`), icône classique `ic_launcher.png`, `store/icone_play_store_512.png`, `windows/runner/resources/app_icon.ico` |
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

- **Compte Play Console créé** (22/10/2026). Compte personnel, nom public
  « Icare & Dédale », validation d'identité en cours (aucune fiche d'appli
  possible avant). `docs/publication/fiche_store.md` : adresse de
  confidentialité passée à `icareetdedale.fr/confidentialite/`, mention de
  l'achat intégré à reprendre. `docs/publication/invitation_testeurs.md` :
  messages pour recruter les testeurs du test fermé.
- **Suites des audits appliquées** (24/10/2026, validées par Cédric).
  Correctifs (commit 27fd368) : bouton Continuer du vocabulaire ramené à
  l'écran (test `vocab_continuer_visible_test`), place sous les champs quand
  le clavier s'ouvre, case du texte à trou extensible et « Valider le mot » /
  « Valider la terminaison », zones à toucher à 48 dp, lecteur d'écran
  (`annoncerAuLecteur` dans `widgets.dart`, réponses en `Semantics`).
  Décisions : leçon 1 ouverte d'office après la création du héros
  (`HeroCreationScreen.showIfNeeded` renvoie vrai) ; annonce des déblocages
  (`deblocagesAAnnoncer`, profil `rang_annonce` / `jeux_annonces`, relevé
  silencieux pour une ancienne sauvegarde ; `views/annonce_deblocage.dart`,
  test `deblocages_test`) ; Lupulus selon le moment
  (`views/conseil_lupulus.dart`, 9 phrases à relire par Cédric) ;
  contrastes (gris en black54, étoiles en goldDark) ; mode « Lecture confort »
  (profil `lecture_confort`, `RomanTheme.confort`, Paramètres > Affichage)
  avec la police Atkinson Hyperlegible (Braille Institute, licence OFL dans
  `assets/fonts/OFL_AtkinsonHyperlegible.txt`, `RomanFonts.lecture`),
  téléchargée avec l'accord de Cédric le 24/10/2026. Vérifié à l'émulateur sur un premier lancement, profil démo restauré.
  Économie et nouveaux jeux : étude rendue dans docs/propositions/etude_economie_et_jeux.md (recommandé : parties payées ouvertes par les leçons + prime de série ; Paires éclair puis Mot du jour). En attente de la décision de Cédric.

- **Audits T58 à T63 relus** (24/10/2026). Synthèse et tri dans
  `docs/audits/synthese_audits_gemini_2026-10.md` : 5 défauts à corriger
  (D1 « Continuer » caché après une question de vocabulaire, confirmé à
  l'émulateur ; clavier sur les boutons ; case du texte à trou ; zones à
  toucher ; lecteur d'écran), 9 décisions pour Cédric, l'économie (les jeux
  rapportent deux fois plus que les leçons), 6 idées de jeux. Doublons de T59
  supprimés. Rapports de Gemini fiables sur les chiffres du code, pas sur
  certains noms.

- **Six tâches d'audit pour Gemini** (23/10/2026, demandées par Cédric) :
  T58 à T63 dans `docs/TACHES.md` (dix premières minutes, cohérence visuelle,
  8 jeux Ludi, une semaine d'élève et économie, accessibilité, idées venues
  d'ailleurs). Observation seulement ; un rapport par tâche dans
  `docs/audits/`, propositions à trier par l'architecte avec Cédric.

- **Deux vidéos branchées** (22/10/2026, générées par Cédric dans Flow).
  `circus_arrivee.mp4` (1,9 Mo) jouée à la victoire au Circus, avant la
  fanfare et la pluie de lauriers (la clameur de la foule est dans la vidéo,
  `playCrowdCheer` retiré à cet endroit) ; `bataille_crassus.mp4` (1,2 Mo)
  à l'ouverture de la Bataille (`BatailleScreen.avecEntree`, coupé dans
  `bataille_test.dart`). Recompressées comme `circus_depart.mp4` (CRF 25,
  PSNR 41,6 dB), originaux dans « gemini ludus ». Vérifié à l'émulateur, course
  gagnée de bout en bout.

- **Circus Maximus : chars animés, vidéo de départ allégée** (22/10/2026,
  demandé par Cédric). Piste à 28 % de la hauteur d'écran (185 à 300 dp au
  lieu de 185 fixes), chars à l'échelle de la voie (au plus 30 % de la
  largeur), voies calées de part et d'autre de la spina (le char du joueur
  passait dessous), poussière dessinée (`_PoussierePainter`) au lieu de
  l'émoji 💨, traînées de vitesse et nuage orangé en turbo, rival décalé
  d'une demi-foulée. `circus_depart.mp4` recompressé avec l'accord de Cédric
  (exception à « pas de recompression ») : 9,0 Mo en 1080 × 1920 → 2,7 Mo en
  720 × 1280 comme les autres vidéos, CRF 25, PSNR 40 dB, vérifié à l'œil et
  à l'émulateur ; original dans `LATIN_LEARN/scratch/anciennes_videos/`.
  Prompts de deux vidéos à générer (arrivée de la course, entrée de Crassus) :
  `docs/propositions/videos_circus_bataille.md` ; branchement après réception.

- **Captures du Store refaites** (18/10/2026) : 8 captures téléphone
  1200 × 2400 (leçon, Via Appia avec la puce « Au programme », duel, album,
  Bataille, exercice, page des professeurs, accueil) ; Panthéon, Thesaurus et
  Taverne retirés (Google limite à 8). Script `scripts/assets/captures_store.py`
  (bords prolongés). Description du Store complétée (album, Bataille, page des
  professeurs, 119 leçons), à valider par Cédric. Corrigé au passage : dans la
  Bataille, les réponses longues (devises) étaient coupées à la 3e ligne ; la
  hauteur des cases suit maintenant la taille de police. Captures tablette refaites
  aussi (2560 × 1440, recadrage des captures 2560 × 1600 sur y 80 à 1520) :
  boutique, Panthéon et Thesaurus remplacés par album, Bataille et page des
  professeurs.

- **Programme de LCA affiché** (18/10/2026, tableau validé par Cédric) :
  `content/programme_lca.py` (PROGRAMME_MONDES : langue et culture par monde ;
  PROGRAMME_LCA : présentation, référence, 4 écarts, contact), exporté dans
  chaque monde (`programme`) et en bloc `programme_lca`. Puce « Au programme »
  sur la bannière de chaque monde (fiche en bas d'écran) et page « Pour les
  professeurs » dans Paramètres > Application (`professeurs_screen.dart`).
  Espaces insécables dans les guillemets ajoutés à l'export. Tests :
  `tests/test_dataset_mobile.py`, `test/professeurs_test.dart`. Vérifié sur
  l'émulateur (téléphone). Relecture par un professeur de latin : à faire
  côté Cédric.

- **Six leçons complémentaires branchées** (18/10/2026, relues et
  demandées par Cédric) : hic/ille/iste/idem/ipse (m17-05), eo/fero/fio
  (m20-05), déponent (m23-05), gérondif (m24-05), subjonctif de but (m25-05),
  subjonctif de conséquence et de condition (m25-06, leçon du subjonctif coupée
  en deux à sa demande). Source `content/lecons_complementaires.py` (valeur =
  liste de leçons par monde) ; `content/__init__.py` (`_inserer_complements`)
  les insère juste avant l'arène, les identifiants -05/-06 viennent donc avant
  l'arène -04 dans la liste. Jeu de données réexporté : 119 leçons.
  Illustrations de Cédric converties en WebP qualité 90 (~170 Ko chacune) et
  ajoutées à `illustrations_lecons.dart` (93 leçons illustrées). Test
  `test/lecons_complementaires_test.dart` : place avant l'arène et ouverture de
  chaque leçon. Relecture : `docs/propositions/lecons_complementaires.md`.

- **Programme de latin par monde** (18/10/2026). Tableau langue / culture /
  culture des 26 mondes dans `docs/propositions/programme_lca.md`, confronté
  au programme officiel (BO n°11 du 17 mars 2016, intitulés cités mot pour
  mot ; projet de révision du CSP du 22/05/2025 non adopté). Écarts relevés
  (armée en 5e, Gaule en 4e, fin de la République en 4e) et notions non
  couvertes (hic/ille, déponent, eo/fio/fero, subjonctif hors souhait). À
  valider par Cédric avant affichage (« Au programme », page professeurs).

- **Bataille des Légendes** (18/10/2026, nom, Crassus et cartes de prêt validés
  par Cédric). 8e jeu de Ludi, ouvert à 3 cartes d'album. Règles pures dans
  `lib/ui/features/bataille/bataille_logique.dart` (main de 5, cartes de prêt
  communes d'abord, main de Crassus de même rareté carte à carte, question :
  devise de la carte posée à 60 %, sinon vocabulaire des mondes atteints ;
  bonne réponse = l'élève choisit attaque ou défense, sinon Crassus prend
  l'avantage ; premier à 3, 5 manches au plus). Écran `bataille_screen.dart`.
  Victoire : `GameRepository.noterBataille` (12 HS, 3 parties payées par jour,
  série et record `bataille`), quête du jour `quest_bataille`. Tests
  `bataille_test.dart` (règles, récompense, déblocage, manche jouée). Partie
  complète jouée à l'émulateur ; corrigés en jouant : carte posée encore dans
  la main, sélection peu visible (coche), numéro de manche, pluriel du score.

- **Album illustré** (18/10/2026). Les 32 cartes livrées par Cédric (Google
  Flow, 896 × 1200), contrôlées sur planche, converties en WebP qualité 90
  (24,8 Mo -> 4,9 Mo) dans `assets/images/album/<id>.webp`. Test : chaque carte
  a son image. Vu à l'émulateur : album et fiche de carte. Prochaine étape :
  maquette de la bataille de cartes.

- **Illustrations en WebP** (18/10/2026, décision de Cédric : exception à la
  règle « pas de recompression », pour les illustrations de leçon et les cartes
  de l'album seulement). Script `scripts/assets/webp_illustrations.py`, qualité
  90 (écart ~40 dB, invisible sur détail agrandi). Leçons : 68,4 Mo -> 14,4 Mo.
  Chemins en `.webp` (illustrations_lecons.dart, `content/album_mobile.py`,
  script de l'image Store). Originaux JPG conservés dans `gemini ludus`.

- **Bruitages : les 8 refaits sont intégrés** (18/10/2026). `achat` et
  `sesterces_clink` passent aussi en MP3, choisis par Cédric à l'écoute alors
  que la mesure les disait stridents (99 % d'aigus). Leçon : pour des pièces,
  sons naturellement aigus, la part d'aigus ne suffit pas ; l'oreille tranche.

- **Bruitages, second essai** (18/10/2026). `indice` et `sword_clash` passent en
  MP3 ElevenLabs (mesurés : 0 % et 6 % d'aigus). `achat` et `sesterces_clink`
  restent les anciens WAV (nouveaux essais encore stridents) ; troisième piste
  de prompts dans `docs/propositions/bruitages_elevenlabs.md`.

- **Portrait sur téléphone, illustrations complètes** (18/10/2026, accord de
  Cédric). `main.dart` : `estUnTelephone` (petit côté < 600 points) bloque le
  portrait ; les tablettes tournent librement. Raison : en paysage sur
  téléphone, le Circus est injouable (question invisible) et le Duel cache ses
  réponses. Vu à l'émulateur : téléphone tourné, appli restée en portrait ;
  tablette en portrait (1600 × 2560) correcte pour l'accueil, la leçon, le Duel.
  Illustrations : 40 images de plus (5e entière et m14-03), contrôlées sur
  planche : les 87 leçons de cours sont illustrées (93 depuis les leçons complémentaires).

- **Tablette, suite** (17/10/2026). Composant `ColonneLecture` (widgets.dart :
  colonne centrée de largeur limitée, `heightFactor: 1` pour ne pas s'étirer en
  hauteur dans une barre du bas). Appliqué à Panthéon, Thesaurus (900),
  Taverne (corps et boutons), Atelier de César, Marché, Memoria, Forum, Compte,
  Réglages. Revue de tous les écrans en tablette 10 pouces paysage : accueil,
  Ludi, Bibliotheca, carte, leçon, Duel, Circus, album, boutique, épigraphie et
  fiches étaient déjà corrects. Test `tablette_ecrans_test.dart` (9 écrans) :
  il échoue bien si le défaut de la Taverne revient (vérifié). Corrigé au
  passage : double `Flexible` dans un bouton du Forum (erreur d'affichage).
  Captures tablette du Panthéon et du Thesaurus refaites.

- **Objectif du jour et rappel quotidien** (17/10/2026, validés par Cédric).
  Objectif : 1 à 3 activités (une leçon réussie ou 10 cartes Memoria), barre
  sous la carte du héros, 5 sesterces une fois par jour, choix dans la carte
  ou les Réglages. Rappel : `flutter_local_notifications` 22.3.2 + `timezone`,
  Android seulement, désactivé par défaut, proposé une fois par Lupulus après
  la première leçon (boîte non refermable par un toucher à côté), 17 h 30 par
  défaut. `RappelService` programme les 7 prochains jours à chaque
  changement : texte « Ta série de N jours t'attend, <prénom du héros> ! » le
  jour où la série est en jeu, rappel simple ensuite ; rien le soir si
  l'objectif est atteint. Android : désucrage (`desugar_jdk_libs` 2.1.4),
  récepteurs et `RECEIVE_BOOT_COMPLETED` dans le manifeste, icône
  `drawable/ic_stat_ludus.xml`. Vu à l'émulateur (Android 16) : autorisation
  demandée, 6 rappels programmés, notification reçue avec l'icône et le
  prénom. Aucune donnée ne sort de l'appareil : politique de confidentialité
  inchangée.

- **Album « Héros et Créatures » et succès** (17/10/2026, catalogue validé par
  Cédric). Données : `content/album_mobile.py` (32 cartes, dont 11 remplacées
  pour ne pas doubler le Panthéon, et leurs 32 succès), exportées dans le bloc
  `album` du dataset ; l'ancien bloc `succes` (8 succès) n'est plus exporté.
  Appli : `lib/data/models/album.dart`, profil (`compteurs`,
  `gladiateurs_vaincus`, `cartes_album`), dépôt (`valeurStat`,
  `verifierSucces` appelé dans `notifyListeners`, `cartesAAnnoncer`), compteurs
  branchés dans Circus, Duel (combat sans faute), Taverne, Marché, quêtes,
  Taberna, César (`total` des missions). Écrans : `lib/ui/features/album/` (album
  dans Ludi, fiche de carte, annonce à l'accueil seulement quand il est l'écran
  affiché, résumé dans le Compte à la place des 5 trophées en dur). Vu à
  l'émulateur : le profil de démonstration reçoit 10 cartes et 170 sesterces
  d'un coup. Images attendues dans `assets/images/album/<id>.jpg` ; prompts
  dans `docs/propositions/illustrations_album.md`.

- **Succès : maquette et catalogue** (17/10/2026). Le dataset n'a que 8 succès
  (l'inventaire de Sonnet en annonçait 80 à tort : erreur non recoupée par
  l'architecte, notée dans `.claude/mods/deleguer/REGLES.md`). Proposition :
  32 succès, un par carte de l'album « Héros et Créatures », dans
  `docs/propositions/succes_et_cartes.md`. En attente de validation de Cédric.

- **Tablette** (17/10/2026). Trois défauts vus à l'émulateur en tablette
  10 pouces paysage (2560 × 1600, 320 dpi via `wm size` / `wm density`), corrigés :
  la leçon s'étirait sur toute la largeur (colonne de lecture de 760 points,
  bandeau illustré plus haut au-delà de 600 points, `hauteurBandeau`) ; le fond
  de la Via Appia, peint en portrait, ne montrait que le ciel (calé au tiers
  bas sur écran large) ; les cases de réponse du Duel, de l'arène et de Memoria
  grandissaient avec la largeur et sortaient de l'écran (hauteur fixe
  `mainAxisExtent`, identique au téléphone). 8 captures tablette 16:9 dans
  `store/captures_tablette/`. Reste perfectible : Panthéon et Thesaurus en
  pleine largeur sur tablette.

- **Fiche Store, brouillon** (17/10/2026). Textes (nom, description courte et
  complète) dans `docs/publication/fiche_store.md`, à valider par Cédric.
  8 captures téléphone dans `ludus_latinus_mobile/store/captures/` (1200 ×
  2400 : Google refuse au-delà de 2:1, bords prolongés), prises à l'émulateur
  en mode démo sur une sauvegarde de démonstration importée (59 leçons,
  série 12 j). Image de présentation 1024 × 500 (`store/presentation_1024x500.png`,
  script `scripts/assets/presentation_store.py`, illustration m21-03). Le
  bandeau illustré des leçons est vérifié à l'émulateur (m13-03).

- **Bataille de cartes en priorité 2** (17/10/2026, retenue par Cédric). Jeu
  Ludi avec les cartes du second album (ATK/DEF de `content/cartes_data.py`),
  une question de latin par manche décide qui choisit la caractéristique.
  Ordre : succès, puis second album, puis bataille. Détail dans
  `docs/audits/analyse_best_seller.md`.

- **Illustrations de leçon, 2e lot** (17/10/2026). 30 images m17-01 à
  m26-03, contrôlées sur planche, copiées sans recompression : 47 leçons de 4e
  et 3e illustrées sur 48 (manque m14-03). Prompts de la 5e envoyés à Cédric.

- **Politique de confidentialité en ligne** (17/10/2026, feu vert de Cédric) :
  https://icare-et-dedale.netlify.app/ludus-latinus/confidentialite/ . Site Netlify `icare-et-dedale` (équipe de Cédric), source
  `docs/publication/netlify/`. Republier : depuis ce dossier,
  `npx netlify-cli deploy --prod --dir . --site 0c26af25-2ec7-46dd-acfd-524c2e8e8809`.
  La racine du site n'a pas encore de page (404).

- **Contact et second album** (17/10/2026). Adresse de contact des applis :
  `icareetdedale.studio@gmail.com` (politique de confidentialité et sa page).
  Priorité 2 : second album « Héros et Créatures » (32 cartes de
  `content/cartes_data.py`, une par succès, illustrations à générer), retenu
  par Cédric.

- **Glossaire branché, cartes de collection retirées** (17/10/2026, accord de
  Cédric). Les 24 termes du glossaire s'affichent dans un 4e onglet
  « Glossaire » du Thesaurus (ordre alphabétique, onglets défilants). Les 32
  cartes de collection ne sont plus exportées vers l'appli mobile (doublon du
  Panthéon) ; elles restent dans `content/cartes_data.py` pour l'appli bureau.
  Dataset réexporté : seul le bloc `cartes_collection` disparaît, attribution
  du Thesaurus inchangée. Vu à l'émulateur.

- **Priorité 1 du Store, première partie** (17/10/2026). Faux « compte
  Tabularium Cloud » (saisie d'e-mail) et faux « code Tessera » retirés du
  modèle, du repository et de l'écran Compte, remplacés par une carte
  « Sauvegarde » : export et import d'un fichier JSON enveloppé
  (`format: ludus_latinus_sauvegarde`, version 1) via `file_picker` 13.1.0.
  Le fichier est vérifié avant la confirmation ; une ancienne sauvegarde avec
  le bloc `compte` se relit. Le fichier local reste le profil brut.
  Permission INTERNET retirée du manifeste principal, gardée dans `debug/` et
  `profile/` pour le débogage. Vérifié à l'émulateur : export dans
  Téléchargements, faux fichier refusé sans confirmation, import réel appliqué.
  Code par Sonnet, relu et corrigé par l'architecte. Politique de
  confidentialité (`docs/publication/politique_confidentialite.md`, page
  `docs/publication/site/index.html`) et réponses du formulaire Sécurité des
  données prêtes. Restent : adresse de contact dédiée à créer par Cédric,
  publication Netlify (feu vert de Cédric), fiche Store, sort du glossaire
  et des 32 cartes de collection.

- **Inventaire et analyse « best-seller »** (17/10/2026). Inventaire factuel
  A à L par Sonnet (`docs/audits/inventaire_fonctionnel.md`, recoupé), analyse
  de l'architecte dans `docs/audits/analyse_best_seller.md`. À retenir : le
  « compte Tabularium Cloud » et le « code Tessera » sont factices, 8 succès (et non 80),
  le glossaire et 32 cartes du dataset ne sont pas lus, aucun rappel, aucun
  monde verrouillé, l'Édition complète n'est pas codée. Propositions en
  attente de l'arbitrage de Cédric.
- **Artefacts CI gardés 3 jours** (17/10/2026) au lieu de 30 : quota de
  stockage GitHub atteint. Les anciens artefacts restent comptés jusqu'à leur
  suppression ou expiration.

- **Illustrations de leçon, 1er lot** (17/10/2026). 17 images 16:9
  (1376 × 768) de m11-01 à m16-03, copiées sans recompression dans
  `assets/images/lecons/lecon_mXX-YY.jpg`. Liste des leçons illustrées dans
  `lib/ui/features/lesson/illustrations_lecons.dart`, à allonger à chaque
  livraison (le test `illustrations_lecons_test.dart` exige qu'elle colle aux
  fichiers). Ces images remplissent le bandeau (`BoxFit.cover`), les pièces
  du musée restent entières. Manque m14-03. La 5e (39 leçons) n'a pas
  d'image propre : 9 seulement ont un repli musée. Prompts de la 5e en
  16:9 dans `docs/propositions/illustrations_lecons_5e.md` (fichiers
  `lecon_m1-01.jpg` : identifiants du dataset, sans zéro devant le monde).

- **Audit des bruitages** (17/10/2026). Mesure des 17 WAV (part d'aigus
  au-dessus de 4 kHz) : `lecon_validee`, `indice`, `achat` et
  `carte_obtenue` sont stridents (70 à 99 %), `dice_roll`, `sesterces_clink`
  et `sword_clash` sont à réécouter. Prompts ElevenLabs dans
  `docs/propositions/bruitages_elevenlabs.md`. Cédric génère les sons, puis
  l'architecte les remplace un par un, sans conversion ni recompression.
  Première livraison : `lecon_validee`, `carte_obtenue`, `dice_roll` et
  `triumph_fanfare` passent en MP3 (WAV retirés, chemins dans
  `audio_service.dart`). `achat`, `indice`, `sesterces_clink` (encore
  stridents) et `sword_clash` (presque inaudible) sont à regénérer avec les
  prompts du second essai.

- **Nouvelle icône de l'appli** (11/10/2026). Casque de centurion doré
  entre deux lauriers, sur rouge pompéien, sans texte (l'ancienne affichait
  « LVDVS ROMANA »). Générée dans Gemini, déclinée par
  `scripts/assets/icone_appli.py`. L'icône Android est désormais
  **adaptative** : le sujet occupe 58 % du calque de 108 dp pour rester entier
  dans un cercle comme dans un carré arrondi. Ne pas agrandir le sujet.
- **Licence et modèle économique** (11/10/2026). `LICENSE` passe de MIT à
  « © 2026 Icare & Dédale, tous droits réservés » : la MIT permettait à
  n'importe qui de republier l'appli, y compris payante. Icare & Dédale est
  le studio d'édition de Cédric (nom affiché dans les stores). Modèle retenu :
  voir « Décisions de Cédric ». Le dépôt GitHub doit passer en privé.
- **Textes de l'interface dans un fichier de langue** (15/10/2026, étape 2 du
  plan de traduction). `lib/l10n/app_fr.arb` (446 clés), classes générées
  commitées dans `lib/l10n/`, accès par `context.l10n.cle`, locale forcée `fr`.
  Rien n'est traduit : un script a vérifié que chaque texte existait mot pour
  mot avant la migration. Après un ajout de clé : `flutter gen-l10n`. Restent en
  dur : les jeux César, Duel, Circus et Marché, les fenêtres de prononciation et
  d'épigraphie, les sous-titres des cinématiques, le catalogue de la boutique
  (`goodie_item.dart`), les rangs du Cursus, les monuments, la quête du jour.
  Le contenu pédagogique (données, questions des jeux, tables du Thesaurus et
  des fiches A4) sera réécrit par langue, pas traduit.

- **Éditeur Icare & Dédale** (11/10/2026). À chaque lancement, l'animation du
  studio (`cinematics/icare_dedale.mp4`, fournie telle quelle) puis l'intro, dans
  une seule page (`RomanCinematicOverlay.showStudioPuisIntro`) : « Passer » passe
  du studio à l'intro, et l'accueil n'apparaît jamais entre les deux (un double
  appui ouvrait la boutique dessous). Muette si le son est coupé, comme l'intro.
  Paramètres → « À propos » (`settings/about_screen.dart`) : logo clair ou sombre
  selon le thème, « Version X.Y.Z (N) » par `package_info_plus` (numéro du build
  CI), « Édité par Icare & Dédale », copyright, bouton « Revoir l'animation du
  studio ». Aucun nom de personne, e-mail ni lien. Le mode nuit étant désactivé
  (`modeSombreDisponible = false`), le logo sombre n'est vérifié que par
  `test/a_propos_test.dart`. Piège : après un ajout de dépendance, construire
  sans `--no-pub` une fois, sinon `GeneratedPluginRegistrant` n'est pas régénéré
  et le module ne répond pas (« Version … » restait affiché).

- **Pas de voix dans l'appli** (11/10/2026). La fenêtre de prononciation ne
  joue qu'un clic par syllabe : son bouton s'appelle désormais « Battre le
  rythme des syllabes » (il promettait une récitation). *Caesar* restitué :
  « KAÏ-SAR » (AE = [aï]). Une vraie voix demanderait des enregistrements :
  aucune voix Android ne lit le latin restitué.

- **Exercice à trou : fin de mot ou mot entier** (11/10/2026, retour de Clovis).
  Quand `avant` finit sans espace (21 exercices sur 26), le début du mot est
  collé à la case, une étiquette dit « ✂️ Écris seulement la fin du mot » et la
  case affiche « fin » ; sinon « ✍️ Écris le mot entier » et « mot ».

- **Sons et départ du Circus** (10/10/2026, retour de Cédric) : plus de bruit
  de carte ni de bouton pour changer d'onglet, ouvrir une page, une leçon ou la
  boutique ; les tuiles de Ludi ne jouent plus de bruitage (les jeux ont leur
  musique). Le Circus part après un décompte III, II, I, ITE ! (`_lancerDepart`),
  précédé de la cinématique `cinematics/circus_depart.mp4` (vidéo de Cédric, copiée
  telle quelle, 9 Mo ; bouton Passer), vue à l'émulateur le 11/10.

- **Revoir le cours** (10/10/2026) : un bouton « 📖 Revoir le cours » au-dessus
  de chaque exercice (sauf arène) rouvre le cours dans un volet, sans perdre
  la question. Le cyprès de la Via Appia (`via/cypres.png`, montage raté) est
  remplacé le 10/10 par un cyprès détouré (avec l'accord de Cédric) depuis le JPG
  sur fond blanc livré par Gemini (Gemini ne sait pas faire de vraie transparence :
  il dessine un damier). Fond de la Via Appia : une peinture pâle par classe
  (`via/fond_via_5e.jpg`, `_4e`, `_3e`, `_fondsParClasse` dans
  `map_screen.dart`, « Tout le cycle » prend celui de la 5e), repli sur le
  dessin d'origine. Vu à l'émulateur le 10/10 (`scratch/t55_via_*.png`). Les six illustrations
  de leçons (`musee_gladiateur`, `legion`, `louve`, `pegase`, `circus`,
  `thermes`) sont refaites par Cédric au style 3D des cartes, sans texte,
  en JPG copiés tels quels.

- **Deuxième question de grammaire** (validé par Cédric le 10/10/2026,
  point 6 de l'audit des leçons). Champ `grammaire` d'une leçon (question,
  4 options, `answer`, `explications` dont une seule vide) : posé juste
  après l'exercice principal, avant le vocabulaire, par
  `lesson/widgets/grammar_question_widget.dart` ; une erreur affiche son
  explication et l'élève réessaie. Les 26 mondes sont intégrés (87 questions,
  `docs/propositions/grammaire_mondes_1_5.md`, `_6_10.md`, `_11_18.md`,
  `_19_26.md`). Attention : la clé est `explications`, pas `explanations`. Règles : une autre phrase que le
  cours et l'exercice, vocabulaire déjà vu, aucune forme non enseignée dans
  une bonne réponse. `tests/test_grammaire_lecons.py` vérifie le format.

- **Arènes revues** (validé par Cédric le 10/10/2026, point 3 de l'audit
  des leçons, `docs/propositions/arenes_questions.md`). Chaque question
  d'arène porte sur une notion enseignée dans le monde ou avant, et chaque
  arène a au moins une question de grammaire. Plutôt que de retirer les
  devises appréciées, on les a ajoutées au cours : trois devises en
  `m7-03`, *Cave canem* en `m2-02`, l'aigle en `m9-01`, Trajan en `m26-01`,
  *SPQR* en `m12-03`. Dix questions hors cours remplacées par de la
  grammaire, sept erreurs corrigées (*esse* = « être », Bretagne et non
  Écosse, quadrige, *le* scutum, etc.). *Ad astra per aspera* (pas antique)
  est retiré. Le rattachement des mots du Thesaurus est inchangé.

- **Taverne vue à l'écran** (10/10/2026, tournée T53 d'un agent Sonnet,
  `docs/audits/tournee_t53_taverne_qcm.md`, 55 vraies captures ; règles
  et explications de QCM conformes). Corrigé ensuite : le gain détaille
  la victoire (+8) et le défi du jour (+10) au lieu d'un « +18 » inexpliqué ;
  les deux boutons sont fixés en bas de l'écran ; le texte du bas ne passe
  plus sous la barre de gestes ; le cadre de Gaius explique qu'il ne joue
  pas quand l'élève a dépassé XXI ; la règle 3 dit qu'il relance sous XVII
  et qu'une égalité ne paie pas. Simulation : s'arrêter à 18 ou 19 gagne
  une manche sur deux, s'arrêter à 15 seulement une sur six.

- **Décodeurs refaits** (validé par Cédric le 09/10/2026, point 2 de
  l'audit des leçons, `docs/propositions/decodeurs.md`). Les quatre
  décodeurs (`m4-04`, `m5-04`, `m8-04`, `m9-04`) ont un cours avec une phrase
  modèle et une **autre** phrase à décoder, dans un ordre de mots différent ;
  champ `traduction` montré après la réussite. `m8-04` et `m9-04` ne
  s'affichaient pas (pas de champ `mots`) : corrigé. Rôle `genitif` (🟢,
  bouton proposé seulement si la phrase en contient un) ; le verbe est 🟡.
  `tests/test_reponses_cachees.py` vérifie mots, rôles, traduction, ordre
  varié et phrase absente du cours.

- **Panthéon, Duel et Circus refaits** (validé par Cédric le 09/10/2026,
  propositions 3, 4 et 5 de l'audit des jeux). **Panthéon** : 26 cartes
  dans `assets/data/pantheon.json` (textes de
  `docs/propositions/pantheon_cartes.md`, à garder identiques), une par
  monde ; gagnée quand `repo.isWorldCompleted(monde)`, rien de stocké dans
  le profil ; face cachée sinon. Image `assets/images/pantheon/carte_mondeNN.jpg`
  (les 26 livrées par Cédric le 09/10, copiées sans recompression), repli sur
  `assets/images/mondes/mondeN.webp` si une image manque. `LessonResult.carteGagnee` affiche une bannière et joue
  `carte_obtenue.wav` à la fin d'un monde. Les 9 anciennes cartes figées,
  leurs raretés et le faux « Rang : Patricien » sont retirés. Le Panthéon est
  ouvert dès le départ (décision de Cédric du 09/10) : l'élève voit d'emblée
  les 26 cartes cachées. **Duel** :
  barème dans `duel/duel_equilibre.dart` (seule source des chiffres et des
  textes des postures) ; boss à 200, 260, 320, 400, 500 PV (doublés le 15/10 après le retour de Clovis : 4 à 10 bonnes réponses par boss en attaque lourde) ; lourde 50
  dégâts et riposte x1,5, vive 35 (44 en moins de 4 s) et x1, parade 25 et
  x0,5 ; les boss 3 à 5 piochent dans les 6, 4 puis 3 derniers mondes
  atteints. **Circus** : `circus/circus_deck.dart`, par blocs de trois
  questions, deux des mondes atteints et une du cirque, pas de répétition
  dans les 8 dernières, repli sur le cirque si peu de mondes. Tournée à
  l'écran : T52.

- **QCM : options rééquilibrées et une explication par mauvaise réponse**
  (validé par Cédric le 08/10/2026). 43 questions (quiz et arènes) ont des
  options de longueur et de forme égales, sans blague. Les 28 leçons `quiz`
  ont un champ `explications` : une chaîne par option, vide pour la bonne,
  affichée par `lesson_screen.dart` sous le conseil de Lupulus quand
  l'élève choisit cette mauvaise option. Règle : 20 mots au plus, jamais la
  bonne réponse, rien de faux. L'export ne tient plus compte des
  `explications` pour rattacher un mot du Thesaurus à un monde. Les objets
  de la boutique n'ont plus de champ `bonus` (aucun n'avait d'effet).
  Brouillons et relectures : `docs/propositions/options_qcm.md`,
  `explications_quiz.md`, `relecture_explications_quiz.md`,
  `integration_qcm_explications.md`. Panthéon proposé dans
  `docs/propositions/pantheon_cartes.md` (validé le 09/10). Tournée à l'écran :
  T51.

- **Agents Sonnet 5.5 en renfort** (08/10/2026) — l'architecte peut confier
  des chantiers bien délimités à des agents Sonnet 5.5, en parallèle, sur
  des fichiers disjoints, sans commit de leur part : l'architecte relit et
  committe. Premiers chantiers : débordements de l'écran du compte, de la
  boutique et de la carte (plus aucun `skip` dans `textes_ecrases_test.dart` ;
  le podium de la boutique défile désormais avec la liste) ; textes qui
  mentaient (arènes « 50 à 200 sesterces », effets inventés du Forum) ;
  relecture du brouillon T43. 106 tests Flutter. T41 à T50 relues et
  validées (T41 et T50 avec réserve : citations inexactes).

- **La Taverne devient « Ad XXI »** (08/10/2026) — retour de Clovis : il ne
  comprenait pas la Taverne (deux modes, cinq combinaisons aux noms latins,
  une question de total qui surgissait après le lancer). Elle est remplacée
  par un seul jeu : l'élève ajoute des dés un par un et s'arrête quand il
  veut ; le plus près de XXI gagne, au-dessus il perd ; Gaius tire ensuite
  jusqu'à XVII au moins. Les totaux ne s'affichent qu'en chiffres romains
  pendant la manche (les nombres arabes n'apparaissent qu'au résultat) :
  **lire le latin est la façon de jouer, pas un péage avant la
  récompense.** C'est la règle pour tous les jeux. Victoire : +8 HS, trois
  fois par jour (`consumeTaverneReward`), et le défi du jour. Logique dans
  la classe `PartieAdXXI`, testée dans `taverne_test.dart` (76 tests).
  Pas encore vue à l'écran.

- **Audit des jeux : propositions 1, 2 et 6** (validées par Cédric le
  04/10/2026). (1) **Taverne** : le gain d'un lancer n'est versé que si
  l'élève donne le total des quatre dés en chiffres romains (quatre choix) ;
  barème baissé (paire 5, Vénus 8, brelan 15, carré 30 HS, environ 7 HS par
  lancer au lieu de 26) ; la « Protection de Série », qui n'existait pas, est
  retirée. Conversion : `chiffreRomain()` en tête de `taverne_screen.dart`.
  (2) **César** : un 7e onglet « Message libre ∞ » chiffre une phrase d'un
  puzzle des mondes atteints avec une clé au hasard, payé par
  `payerPartie('cesar')` (3 par jour). **Marché** : un étal ou un client
  déjà payé revient avec un prix tiré au hasard (`_tirages`), payé comme une
  partie. (6) **Records** : `profile.records` (clé `records` du JSON),
  `repo.record(jeu)` et `repo.enregistrerRecord(jeu, valeur)` ; points au
  Circus, bonnes réponses d'affilée au Duel et à Memoria, affichés en fin de
  partie et sur les tuiles. Tests : `taverne_test.dart`, `records_test.dart`,
  un cas de plus dans `cesar_mission_test.dart` et `marche_paiement_test.dart`
  (73 tests). Pas encore vu à l'écran : T50.

- **Premiers retours d'un élève (Clovis)** (04/10/2026) — corrigés :
  (1) la fenêtre de fin de leçon était bornée à 9/16 de l'écran
  (`showModalBottomSheet` sans `isScrollControlled`) et cachait le bouton
  « Continuer » : elle défile maintenant ; (2) les réponses du Circus
  rétrécissaient (`FittedBox`) jusqu'à être illisibles : deux lignes à
  13 px ; celles des arènes passent de 12 à 13,5 px ; (3) la boutique ne
  s'ouvrait qu'en touchant le compteur de sesterces : une carte « Taberna
  Romana » est ajoutée à l'accueil (vue à l'écran) ; (4) dans le Duel, le
  héros respire et se balance comme les boss animés. (5) Les textes « écrits
  à la verticale » de l'accueil : la carte du défi du jour, dont le bouton
  écrasait le titre et la consigne à une lettre par ligne ; le bouton passe
  sous le texte. `test/textes_ecrases_test.dart` détecte ce défaut (un texte
  de plus de 4 lettres dans moins de 48 points) sur cinq réglages de taille
  et de police ; T46 l'étend aux autres écrans. À
  vérifier à l'écran : T45. **Retour d'élève > tournée d'exécutant** : en
  cas de conflit, le retour d'élève l'emporte.

- **Audit des jeux, première partie** (03/10/2026) — rapport :
  `docs/audits/audit_jeux_2026-10-03.md`, tiré du code ; les mesures de
  T41 le compléteront. Principaux défauts : la Taverne rapporte environ
  78 HS par jour au hasard, plus que les leçons ; César, le Marché et le
  Panthéon n'ont plus rien à offrir une fois finis ; le Duel se gagne en
  deux réponses. Six propositions, en attente de la décision de Cédric.

- **Les deux premières déclinaisons enseignées en 5e** (validé par Cédric
  le 02/10/2026) — premier chantier de l'audit des leçons. Trois leçons
  gardent leur histoire mais remplacent un choix de mot de culture par une
  terminaison à écrire : `m8-03` le génitif (*Servus domini aquam portat*),
  `m9-03` le pluriel (*Legionarii gladios portant*), `m10-03` l'accord de
  l'adjectif (*Ulixes speluncam magnam videt*). Trois mots ajoutés au
  Thesaurus (*portare*, *legionarius*, *spelunca*) ; *dominus*, *bonus* et
  *magnus* sont désormais rattachés aux mondes 8 et 10. Le test
  anti-réponse n'a plus que trois exceptions (`m1-02`, `m1-05`, `m7-03`).
  Dans un cours, n'imbrique pas le gras dans l'italique (`*mot**fin***`) :
  écris `mot**fin**`. À voir à l'écran : T44. Complément du même jour, validé
  par Cédric : `m10-04` n'est plus un décodeur mais un puzzle sur le datif
  et l'ablatif (*Ulixes amico gladium in spelunca dat*), qui clôt la 5e sur
  « tu connais maintenant les six cas ». L'ablatif y est présenté par
  *in horto* et *in silva*, déjà connus ; le pluriel en *-is* et l'ablatif
  de moyen sont laissés à la 4e. Il reste quatre décodeurs (mondes 4, 5, 8
  et 9).

- **Audit des leçons** (02/10/2026) — rapport :
  `docs/audits/audit_lecons_2026-10-02.md`. Sept défauts, dont deux
  majeurs : la 4e suppose acquises les 1re et 2e déclinaisons que la 5e
  n'enseigne pas, et la grammaire s'arrête au monde 5. Corrigé le jour
  même : une réponse déplacée en `m2-05`, et les couleurs annoncées par les
  cinq décodeurs (désormais celles de l'écran : sujet bleu, COD rouge,
  verbe doré). Les six propositions du rapport attendent la décision de
  Cédric. L'audit des jeux viendra après les mesures de T41.

- **Jeux liés à la progression, arènes à enjeu** (02/10/2026) — deux points
  de la phase 2. (1) Le Duel et le Circus : `VocabQuestion.pourJeu`
  fabrique des questions de vocabulaire à partir du Thesaurus des mondes
  atteints (`repo.mondesAtteints`). Chaque question fixe du Duel porte une
  clé `monde` (rang du monde où sa notion est enseignée) et ne sort qu'une
  fois ce monde atteint (`_questionsDuJoueur`) ; si le paquet a moins de
  12 questions, il est complété par les mondes suivants les plus proches.
  Le Circus garde ses 46 questions sur le cirque et y ajoute 24 questions de
  vocabulaire atteint. (2) Les arènes de fin de monde
  (`arena_challenge_widget.dart`) : trois vies, une erreur en coûte une, à
  zéro l'arène se retente avec les réponses remélangées ; après une bonne
  réponse, l'explication (clé `explanation`, jamais affichée jusqu'ici)
  reste à l'écran jusqu'au bouton « Continuer le combat ». Tests :
  `arene_test.dart` et deux cas dans `vocab_question_test.dart` (64 tests
  Flutter). Restent de la phase 2 : déclinaisons en 5e et explications par
  mauvaise réponse (contenu à valider par Cédric, brouillon en T43), carte
  du Panthéon par monde (état des lieux en T42).

- **Tournée de la 3e (T39) et deux retouches d'exercices** (02/10/2026) —
  les 16 exercices de 3e ont été joués à l'écran : aucun ne redonne sa
  réponse. Deux retouches : la case de saisie des trous
  (`cloze_fill_widget.dart`) fait 72, 96 ou 120 px selon la longueur de la
  réponse, au lieu de 120 toujours, ce qui évitait rarement un retour à la
  ligne ; le puzzle (`word_puzzle_widget.dart`) dit « Les mots ne sont pas
  tous les bons » quand une étiquette-piège est posée, et garde « pas le
  bon ordre » quand seuls les mots sont mal rangés. Le tableau de T39
  contenait des phrases inventées : voir la règle ajoutée en section 8.

- **Petits téléphones et T30 à T36 relues** (02/10/2026) — la tournée T32
  en 360 x 640 a montré un blocage : au Duel, deux réponses sur quatre
  sortaient de l'écran, sans défilement possible. Corrigé et vu à l'écran
  par l'architecte : le panneau de quiz défile (`_quizScroll`), ses cases
  s'aplatissent quand la hauteur manque, et il descend vers l'explication
  après une réponse. Aussi : la carte de Memoria défile, les tuiles de Ludi
  sont plus hautes sur écran étroit, le titre du Duel rétrécit. Cartes des
  cas : voir le piège 18. Gemini a baissé la vitesse de croisière du Circus
  (`_playerSpeed` 0.085 : on perd sans répondre) et mis les titres d'écran
  dans des `FittedBox`. `test/fin_de_partie_test.dart` (écrit par Gemini)
  garde la fin du Duel en 360 x 640 : 59 tests Flutter. `README.md` est
  réécrit pour l'appli Flutter. Suite : T37 (vérification) et T39 (tournée des
  exercices de 3e) ; T38 est annulée.

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

- **Modèle économique** (11/10/2026). **Partie gratuite** : les mondes 1 à 3
  de 5e en entier (16 leçons, pour ne pas fermer la porte aux débutants)
  **plus la 1re leçon de chacun des autres mondes** (mondes 4 à 26, aperçu
  pour les professeurs) ; soit 39 leçons sur 113. Tout le reste se débloque
  par l'« Édition complète », **achat unique à 3,99 €** via Google Play Billing. **Aucune
  publicité. Les sesterces ne s'achètent jamais avec de l'argent réel** (appli
  du programme Familles, public de 12 à 15 ans). Calendrier : test fermé
  (12 testeurs, 14 jours) avec la version complète gratuite pendant que Cédric
  fait les démarches (cumul d'activité, micro-entreprise, profil marchand),
  puis mise en production directement avec l'achat. La règle suivante (1re
  leçon de chaque monde ouverte d'emblée) reste valable : ces leçons font
  partie de la partie gratuite. Éditeur affiché : Icare & Dédale.
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
- **Pas de recompression des médias** (02/10/2026). Cédric préfère garder
  la qualité des musiques, des vidéos et des images telle quelle, même si
  l'audit T35 chiffre un gain de plusieurs Mo. Ne réencode rien et ne
  convertis aucun format pour gagner du poids ; T38 est annulée. Supprimer
  un fichier que plus aucun code ne cite reste permis.

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
   atteints ; une carte du Panthéon par monde terminé (faits le 09/10).
3. **Phase 3, visuels Gemini** — cartes des six cas, en-têtes des
   leçons-récits de 4e et 3e, stèle vierge de l'Épigraphie.
- Teinte du sol qui change avec le cycle (5e, 4e, 3e).
- **Traduction, en trois temps** (décidé avec Cédric le 11/10/2026). 1. Lancer en
  français (France et francophonie : Belgique, Suisse, Québec). 2. Sortir les
  textes de l'interface dans des fichiers de langue (`lib/l10n/app_fr.arb`),
  sans rien traduire. 3. Si l'appli prend, une deuxième langue (anglais ou
  allemand) : le contenu pédagogique se réécrit, il ne se traduit pas
  (étymologie par les mots français, grammaire française, programme de 5e-3e),
  un cycle à la fois en commençant par la 5e.

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

**Ce que tu cites se recopie depuis l'écran ou le fichier, jamais de
mémoire.** Une phrase latine, un message de Lupulus, un chiffre : rouvre la
capture ou le fichier au moment d'écrire. En T39, les captures étaient
justes mais le tableau citait des phrases absentes de l'appli. Et tu
t'arrêtes au statut `FAIT` : seul l'architecte écrit `VALIDÉ`.

**Toute capture citée doit exister dans `scratch/` au moment du commit.**
En T51, le compte rendu citait une trentaine de captures absentes et
décrivait des parties de Taverne qui ne pouvaient pas avoir eu lieu (mise,
gain et messages inexistants dans le code). Avant de committer, lance
`ls scratch/tNN_*` et vérifie que chaque nom cité y figure. Si une étape n'a
pas pu être faite, écris-le : un compte rendu incomplet et vrai vaut mieux
qu'un compte rendu complet et faux.
