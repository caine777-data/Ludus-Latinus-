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
  audio/            bruitages WAV mono 44,1 kHz + 3 musiques OGG — voir AudioService
  cinematics/       vidéos 9:16 avec bande-son : intro, triumph, boss_entrance (secours),
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
13. **Lupulus : utilise `lupulusAnimation(LupulusMood.xxx)`** ou
    `AnimatedLupulusAvatar(mood: …)` plutôt qu'un chemin d'image en dur.
    Les images fixes de `images/lupulus/` ne servent plus que de secours
    (`errorBuilder`) et pour les costumes (centurion, gladiateur, imperator,
    philosophe…), qui n'ont pas d'animation.

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

**Tests Flutter : 3 échecs sont connus et antérieurs** (analyse d'exercices
×2, phonétique « Veni vidi vici »). Ils ne doivent pas augmenter. Tout
nouvel échec est de ta responsabilité.

**Une modification visible à l'écran se vérifie sur l'émulateur**, avec une
capture d'écran jointe au compte rendu. « Ça compile » ne suffit pas.

---

## 5. Contenu et images

### Le contenu pédagogique

Le contenu se modifie **côté Python**, puis s'exporte vers le mobile :

1. modifier `content/` ou `app/thesaurus*.py` ;
2. lancer `python scripts/exporter_dataset_mobile.py` ;
3. commiter la source **et** le JSON régénéré ensemble.

`app/thesaurus_complement.py` (88 mots) n'a **pas encore été relu** par
Cédric. N'y ajoute rien sans que la tâche le demande.

### Les images générées dans Gemini

Cédric génère les images et les dépose dans
`C:\Users\caine\Downloads\LATIN_LEARN\gemini ludus\`. Les scripts de
`scripts/assets/` les traitent :

| Script | Entrée | Sortie |
|---|---|---|
| `chroma_boutique.py [id …]` | `<id>.jpg` sur fond vert | `images/boutique/<id>.png` détouré, 256 px |
| `chroma_avatars.py [genre_toge …]` | `avatar_<genre>_<toge>.jpg` | `images/avatars/…_140.png` et `_48.png` |
| `decors_mondes.py [N …]` | `decor_monde<N>.jpg` | `images/mondes/monde<N>.webp` |
| `via_elements.py [nom …]` | `via_<nom>.jpg` | `images/via/<nom>.png`, recadré au ras, sans carré |
| `lupulus_videos.py [humeur …]` | `lupulus_<humeur>.mp4` (fond vert) | `images/animated/lupulus_*.webp`, son retiré |

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

- **Lupulus triomphant animé** — coupe levée et étincelles, en fin de monde,
  à la victoire du Duel et du Circus, et dans Memoria (série de 5 et bilan).
  Les 5 humeurs de Lupulus sont désormais toutes animées.

- **Assets refaits** — Sphinx à visage humain, Lupulus joyeux qui garde sa
  couronne sur toute l'animation, nouvelle acclamation de la foule (coupée à
  2,6 s et baissée de 5 dB : `DUREE_MAX` et `GAIN_EXTRA` dans
  `scripts/assets/bruitages.py`).

- **Boss du Duel** — chacun des 5 boss a sa vidéo d'entrée (clé `video` de
  sa fiche dans `duel_screen.dart`) ; `boss_entrance.mp4` reste en secours.
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

### Prochaines étapes envisagées (décidées par l'architecte)

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
