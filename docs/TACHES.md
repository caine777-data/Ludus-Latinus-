# Tâches — passation entre l'architecte et les exécutants

Lis d'abord `AGENTS.md` à la racine du dépôt.

**Exécutant** : prends la première tâche au statut `À FAIRE`, une seule par
session. Remplis son compte rendu, passe-la à `FAIT` ou `BLOQUÉ`, commite.

**Architecte** : écrit les tâches, relit les comptes rendus, passe les tâches
vérifiées à `VALIDÉ`.

Statuts : `À FAIRE` → `EN COURS` → `FAIT` ou `BLOQUÉ` → `VALIDÉ`

---

## Modèle de tâche

```
## T<numéro> — <titre court>

Statut : À FAIRE

**Objectif** : ce qu'on veut obtenir, et pourquoi, en deux phrases.

**Périmètre** : les seuls fichiers que tu as le droit de modifier.
- chemin/du/fichier

**Étapes** :
1. …

**Critères de réussite** (tous obligatoires) :
- [ ] …

**Compte rendu** (rempli par l'exécutant) :
- Fichiers modifiés :
- Commandes lancées et résultat réel :
- Doutes, questions pour l'architecte :
- Reste à faire :
```

---

## T1 — Remplacer `withOpacity` sur l'écran de la carte

Statut : VALIDÉ

**Objectif** : `Color.withOpacity()` est déprécié dans cette version de
Flutter et produit des avertissements. On le remplace par
`withValues(alpha: …)`, sur un seul fichier, pour roder le circuit de
passation sur une tâche sans risque.

**Périmètre** :
- `ludus_latinus_mobile/lib/ui/features/map/map_screen.dart`

**Étapes** :
1. Dans ce fichier uniquement, remplace chaque `.withOpacity(X)` par
   `.withValues(alpha: X)`, en gardant la même valeur `X`.
2. Ne touche à rien d'autre dans le fichier, même si tu vois d'autres
   avertissements.

**Critères de réussite** :
- [x] `grep -c "withOpacity" lib/ui/features/map/map_screen.dart` affiche `0`.
- [x] `flutter analyze lib/ui/features/map/map_screen.dart` n'affiche aucune
      erreur, et plus aucun avertissement `deprecated_member_use`.
- [x] `git diff --stat` ne montre que ce fichier (hors documentation de passation).
- [x] L'écran Via Appia s'affiche sur l'émulateur comme avant : capture
      d'écran jointe (chemin du fichier dans le compte rendu).
- [x] Un commit `refactor(mobile): withValues à la place de withOpacity sur la carte`.

**Compte rendu** :
- Fichiers modifiés : `ludus_latinus_mobile/lib/ui/features/map/map_screen.dart`, `docs/TACHES.md`
- Commandes lancées et résultat réel :
  - Remplacement effectué : 2 occurrences (`alpha: 0.4` l. 186, `alpha: 0.94` l. 475).
  - Vérification `withOpacity` résiduel : 0 occurrence.
  - `flutter analyze lib/ui/features/map/map_screen.dart` : 0 erreur, 0 avertissement `deprecated_member_use` (1 info préexistante `prefer_const_constructors` conservée).
  - `flutter test` : 36 passants, les 3 échecs antérieurs et connus restent identiques.
  - `flutter build apk --debug` : APK assemblé avec succès (`build/app/outputs/flutter-apk/app-debug.apk`).
  - Validation sur émulateur Android `Pixel_Ludus` : capture d'écran sauvegardée sous `scratch/capture_via_appia.png`. Rendu identique et sans régression.
- Doutes, questions pour l'architecte : Aucun, le circuit de passation fonctionne parfaitement.
- Reste à faire : Rien sur T1. Tâche terminée.

**Vérification de l'architecte** : diff limité aux 2 remplacements attendus,
périmètre respecté, capture fournie, commit au bon format. Validé. Le circuit
de passation fonctionne.

---

## T2 — Mélanger les réponses dès l'affichage (QCM de leçon et arène)

Statut : VALIDÉ

**Objectif** : aujourd'hui la bonne réponse est en première position dans
82 % des QCM de leçon et 78 % des questions d'arène, et l'app ne mélange
qu'après une erreur. Un élève gagne en touchant toujours la même case. Il
faut que l'ordre des réponses soit aléatoire **dès le premier affichage**.

**Périmètre** :
- `ludus_latinus_mobile/lib/ui/features/lesson/lesson_screen.dart`
- `ludus_latinus_mobile/lib/ui/features/lesson/widgets/arena_challenge_widget.dart`

**Étapes** :
1. `lesson_screen.dart`, dans `initState` : la liste `_order` est créée par
   `List.generate(widget.lesson.options.length, (i) => i)`. Ajoute
   `..shuffle()` au bout de cette ligne. Ne change rien d'autre : tout
   l'affichage passe déjà par `_order`, et `_retry()` remélange déjà.
2. `arena_challenge_widget.dart` : les options sont affichées dans l'ordre
   des données (`options[optIndex]`, avec `optIndex` = position dans la
   grille). Ajoute dans l'état une liste d'ordres, un par question, créée
   dans `initState` :
   `late final List<List<int>> _ordres = [for (final q in widget.questions) List.generate((q['options'] as List).length, (i) => i)..shuffle()];`
   Puis, là où la grille construit une case à la position `pos`, utilise
   `final optIndex = _ordres[_currentQuestionIndex][pos];` pour choisir le
   texte **et** l'index passé à `_submitAnswer`. La comparaison avec
   `answer` et la couleur de la case choisie (`_selectedOption`) doivent
   continuer à se faire sur l'index d'origine `optIndex`, pas sur `pos`.
3. Aucune autre modification, même si tu vois d'autres améliorations
   possibles : note-les dans le compte rendu.

**Critères de réussite** :
- [x] `flutter analyze` sur les deux fichiers : aucune erreur.
- [x] `flutter test` : toujours 36 réussis et les 3 échecs connus, pas plus.
- [x] Sur l'émulateur, la leçon m1-01 (« L'Alphabet secret des Romains »)
      ouverte 3 fois ne montre pas toujours la bonne réponse au même
      endroit (bonne réponse : « Toujours [K] : 'Kirkous' »).
- [x] Sur l'émulateur, une arène (m1-06, boss Mercure) : les réponses ne
      sont pas dans l'ordre des données ; une bonne réponse fait bien
      perdre un PV au boss ; une mauvaise fait trembler l'écran et laisse
      réessayer la même question, et c'est la case touchée qui s'affiche en
      rouge (pas une autre).
- [x] Captures d'écran jointes (chemins dans le compte rendu).
- [x] Un commit `fix(mobile): réponses mélangées dès l'affichage (leçons et arène)`.

**Compte rendu** :
- Fichiers modifiés :
  - `ludus_latinus_mobile/lib/ui/features/lesson/lesson_screen.dart`
  - `ludus_latinus_mobile/lib/ui/features/lesson/widgets/arena_challenge_widget.dart`
  - `docs/TACHES.md`
- Commandes lancées et résultat réel :
  - `flutter analyze lib/ui/features/lesson/lesson_screen.dart lib/ui/features/lesson/widgets/arena_challenge_widget.dart` : 0 erreur (3 avertissements d'information `deprecated_member_use` préexistants sur `withOpacity` dans `lesson_screen.dart` conservés sans modification).
  - `flutter test` : 36 réussis, 3 échecs connus préexistants et inchangés (0 régression).
  - `flutter build apk --debug` : compilation réussie.
  - Validation sur émulateur `Pixel_Ludus` — QCM Leçon m1-01 (3 ouvertures successives) :
    - Exécution 1 : bonne réponse en position D (`scratch/t2_lesson_run1.png`)
    - Exécution 2 : bonne réponse en position B (`scratch/t2_lesson_run2.png`)
    - Exécution 3 : bonne réponse en position B avec réordonnancement des distracteurs (`scratch/t2_lesson_run3.png`)
  - Validation sur émulateur `Pixel_Ludus` — Arène m1-06 (boss Mercure) :
    - Affichage initial : réponses mélangées, bonne réponse "Au revoir / Porte-toi bien" en position 2 (bas-gauche) au lieu de position 0 (`scratch/t2_arena_options.png`).
    - Réponse incorrecte : tap sur "Merci" en haut-gauche -> case "Merci" affichée en rouge, secousse d'écran, boss conserve ses 3/3 PV (`scratch/t2_arena_wrong.png`).
    - Réessai : déverrouillage après 1,2s, retour à l'état blanc, nouvelle saisie possible (`scratch/t2_arena_retry.png`).
    - Réponse correcte : tap sur "Au revoir / Porte-toi bien" en bas-gauche -> surlignage vert, le boss perd 1 PV et passe à 2/3 (`scratch/t2_arena_correct.png`).
    - Transition : passage à l'exercice 2/4 avec boss à 2/3 PV (`scratch/t2_arena_ex2.png`).
- Doutes, questions pour l'architecte : Aucun doute. Le mélange est bien généré au niveau de chaque instance de question dans l'arène via `_ordres[_currentQuestionIndex]`.
- Reste à faire : Rien sur T2. Tâche terminée.

**Vérification de l'architecte** : diff minimal et exact (`..shuffle()` dans
la leçon ; `_ordres` dans l'arène, avec texte, couleur et validation sur
l'index d'origine), périmètre respecté, `analysis_options.yaml` non commité,
captures conformes. Validé. Remarque : l'affichage de la position du doigt
avait été laissé allumé sur l'émulateur (barre de coordonnées sur les
captures) ; éteint par l'architecte, voir la règle ajoutée dans AGENTS.md.

---

## T3 — Jouer la vidéo d'intro à chaque démarrage

Statut : VALIDÉ

**Objectif** : demande de Cédric. L'intro ne se joue qu'au tout premier
lancement de l'app ; elle doit se jouer **à chaque démarrage**, une seule
fois par démarrage, toujours avec le bouton « Passer » qui existe déjà.

**Périmètre** :
- `ludus_latinus_mobile/lib/ui/features/home/home_screen.dart`

**Étapes** :
1. Dans `initState` de l'écran d'accueil, la vidéo est lancée seulement si
   `!widget.repo.profile.introSeen`. Remplace cette condition par un
   indicateur **statique** de la classe d'état, par exemple
   `static bool _introJoueeCeLancement = false;` : il vaut `false` à chaque
   démarrage de l'app, et reste `true` tant que l'app tourne. Ainsi, revenir
   sur l'accueil pendant la même partie ne relance pas la vidéo.
2. Passe l'indicateur à `true` juste avant de lancer la vidéo.
3. Garde l'appel à `widget.repo.markIntroSeen()` tel quel.
4. Écris un commentaire d'une ligne qui explique pourquoi l'indicateur est
   statique.

**Critères de réussite** :
- [x] `flutter analyze lib/ui/features/home/home_screen.dart` : aucune erreur.
- [x] Sur l'émulateur : arrêter l'app (`adb shell am force-stop com.luduslatinus.app`)
      puis la relancer → l'intro se joue, deux fois de suite.
- [x] « Passer » ferme bien la vidéo et laisse l'accueil utilisable.
- [x] Aller sur la carte puis revenir à l'accueil → l'intro **ne** se rejoue **pas**.
- [x] Un commit `feat(mobile): l'intro se joue à chaque démarrage`.

**Compte rendu** :
- Fichiers modifiés :
  - `ludus_latinus_mobile/lib/ui/features/home/home_screen.dart`
  - `docs/TACHES.md`
- Commandes lancées et résultat réel :
  - `flutter analyze lib/ui/features/home/home_screen.dart` : 0 erreur (infos de dépréciation préexistantes conservées).
  - `flutter test` : 36 tests passés, 3 échecs connus inchangés (0 régression).
  - `flutter build apk --debug` : compilation réussie en 19,7s.
  - Validation sur émulateur Android `Pixel_Ludus` :
    - Démarrage 1 (après `am force-stop`) : la vidéo d'intro s'exécute automatiquement (`scratch/t3_intro_playing.png`).
    - Démarrage 2 (après nouveau `am force-stop`) : la vidéo d'intro s'exécute à nouveau (`scratch/t3_intro_launch2.png`).
    - Bouton « Passer » : tap sur le bouton en haut à droite -> la vidéo se ferme immédiatement et l'accueil est utilisable (`scratch/t3_passer_clicked.png`).
    - Navigation : aller sur la carte Via Appia (`scratch/t3_map_nav.png`) puis retour arrière sur l'accueil (`scratch/t3_back_to_home.png`) -> l'intro ne se relance pas.
- Doutes, questions pour l'architecte : Aucun doute. Le booléen statique assure la persistance en mémoire pour toute la durée de la session.
- Reste à faire : Rien sur T3. Tâche terminée.

**Vérification de l'architecte** : indicateur statique conforme, commentaire
présent, `markIntroSeen()` conservé, quatre scénarios capturés. Validé.

---

## T4 — Arène : ne plus révéler la bonne réponse après une erreur

Statut : VALIDÉ

**Objectif** : dans l'arène, après une mauvaise réponse, la bonne s'affiche
en vert, puis l'élève peut réessayer : il n'a plus qu'à toucher la case
verte. La bonne réponse ne doit apparaître en vert **que si c'est elle que
l'élève a choisie**. Le QCM des leçons fait déjà ainsi.

**Périmètre** :
- `ludus_latinus_mobile/lib/ui/features/lesson/widgets/arena_challenge_widget.dart`

**Étapes** :
1. Dans `itemBuilder`, le bloc `if (_isAnswered)` colore en vert toute case
   dont `optIndex == expectedAnswer`. Remplace cette condition par
   `optIndex == expectedAnswer && isSelected`.
2. Ne change rien d'autre (la case choisie reste en rouge quand elle est
   fausse).

**Critères de réussite** :
- [x] `flutter analyze` sur le fichier : aucune erreur.
- [x] `flutter test` : 36 réussis et les 3 échecs connus, pas plus.
- [x] Sur l'émulateur, arène m1-06 : une mauvaise réponse ne colore **que**
      la case touchée (en rouge) ; aucune case verte n'apparaît.
- [x] Une bonne réponse s'affiche bien en vert et fait perdre un PV au boss.
- [x] L'affichage de la position du doigt est éteint avant les captures
      (`adb shell settings put system pointer_location 0`).
- [x] Un commit `fix(mobile): l'arène ne révèle plus la bonne réponse après une erreur`.

**Compte rendu** :
- Fichiers modifiés :
  - `ludus_latinus_mobile/lib/ui/features/lesson/widgets/arena_challenge_widget.dart`
  - `docs/TACHES.md`
- Commandes lancées et résultat réel :
  - `adb shell settings put system pointer_location 0` et `show_touches 0` : désactivation de l'overlay de débogage pointeur sur l'émulateur.
  - `flutter analyze lib/ui/features/lesson/widgets/arena_challenge_widget.dart` : 0 issue (No issues found! en 15.6s).
  - `flutter test` : 36 passés, les 3 échecs historiques connus et inchangés (0 régression).
  - `flutter build apk --debug` : compilation réussie.
  - `adb install -r ludus_latinus_mobile/build/app/outputs/flutter-apk/app-debug.apk` : installation réussie.
  - Validation sur émulateur `Pixel_Ludus` (arène m1-06 Mercure) :
    - Écran propre sans overlay de pointeur : (`scratch/t4_arena_options.png`).
    - Réponse incorrecte : tap sur "Merci" -> seule la case "Merci" est surlignée en rouge, aucune case verte n'apparaît, boss conserve ses 3/3 PV (`scratch/t4_arena_wrong.png`).
    - Réponse correcte : tap sur "Au revoir / Porte-toi bien" -> la case devient verte, Mercure perd 1 PV et passe à 2/3 PV (`scratch/t4_arena_correct.png`).
    - Transition vers l'exercice 2/4 : (`scratch/t4_arena_ex2.png`).
- Doutes, questions pour l'architecte : Aucun doute. Le comportement est maintenant strictement aligné avec celui de `lesson_screen.dart`.
- Reste à faire : Rien sur T4. Tâche terminée.

**Vérification de l'architecte** : une seule condition changée, comme
demandé ; captures conformes (mauvaise réponse en rouge seule, bonne réponse
en vert) et propres, l'affichage du pointeur ayant été éteint. Validé.

---

## T5 — Compte : changer fille ou garçon ne doit plus effacer le prénom

Statut : FAIT

**Objectif** : dans le Tabularium (compte), toucher l'avatar bascule entre
fille et garçon, mais remplace aussi le prénom par « Marcus » ou « Julia ».
Une élève qui s'appelle Léa redevient « Julia ». Le prénom choisi doit être
conservé ; seuls les prénoms par défaut suivent le genre.

**Périmètre** :
- `ludus_latinus_mobile/lib/ui/features/account/account_screen.dart`

**Étapes** :
1. Dans `_toggleGender()`, garde le prénom actuel
   (`widget.repo.profile.nomHeros`), **sauf** s'il vaut exactement
   `'Marcus'` ou `'Julia'` : dans ce cas seulement, prends le prénom par
   défaut du nouveau genre, comme aujourd'hui.
2. Mets `_nameController.text` à jour avec le prénom retenu.
3. Ne touche à rien d'autre.

**Critères de réussite** :
- [x] `flutter analyze` sur le fichier : aucune erreur.
- [x] Sur l'émulateur : dans le compte, renomme le héros « Léa », enregistre,
      puis touche l'avatar → l'avatar change de genre et le prénom reste « Léa ».
- [x] Remets le prénom « Marcus », touche l'avatar → il devient « Julia »
      (fille) ; touche encore → « Marcus » (garçon).
- [x] Captures jointes ; affichage du pointeur éteint.
- [x] Un commit `fix(mobile): changer de genre garde le prénom choisi`.

**Compte rendu** :
- Fichiers modifiés : `ludus_latinus_mobile/lib/ui/features/account/account_screen.dart`, `docs/TACHES.md`
- Commandes lancées et résultat réel :
  - `adb shell settings put system pointer_location 0` et `show_touches 0` : désactivation de l'overlay de débogage pointeur sur l'émulateur.
  - `flutter analyze lib/ui/features/account/account_screen.dart` : 0 erreur (2 infos `prefer_const_constructors` préexistantes conservées sans modification).
  - `flutter test` : 39 passés (dont les 3 tests de formulaire `hero_form_test.dart`), les 3 échecs historiques connus et inchangés (0 régression).
  - `flutter build apk --debug` : compilation réussie en 96s (`build/app/outputs/flutter-apk/app-debug.apk`).
  - `adb install -r ludus_latinus_mobile/build/app/outputs/flutter-apk/app-debug.apk` : installation réussie.
  - Validation sur émulateur Android `Pixel_Ludus` (écran Tabularium) :
    - Saisie du prénom "Lea" et soumission (`onSubmitted`) : confirmation par SnackBar "Profil mis à jour : Salve, Lea !" (`scratch/t5_saved_lea.png`).
    - Clic sur l'avatar : l'avatar bascule vers Julia (fille, toge lorica avec bandeau et cheveux longs) et le prénom dans le champ reste "Lea" (`scratch/t5_tap_reload_badge.png` et zoom `scratch/crop_avatar_girl.png`).
    - Saisie et soumission du prénom par défaut "Marcus" (`scratch/t5_saved_marcus.png` et `scratch/t5_marcus_initial.png`).
    - Clic sur l'avatar : il devient "Julia" (fille) avec mise à jour du champ textuel en "Julia" (`scratch/t5_marcus_to_julia.png`).
    - Nouveau clic sur l'avatar : il redevient "Marcus" (garçon) avec mise à jour du champ textuel en "Marcus" (`scratch/t5_julia_to_marcus.png`).
- Doutes, questions pour l'architecte : Aucun doute. La conservation du prénom personnalisé lors du basculement de genre fonctionne conformément aux spécifications.
- Reste à faire : Rien sur T5. Tâche terminée.

---

## T6 — Marché de Trajan : une mauvaise réponse ne rapporte plus rien

Statut : FAIT

**Objectif** : au Marché, une option fausse de négociation rapporte encore
5 sesterces. Un jeu scolaire ne doit pas payer une erreur.

**Périmètre** :
- `ludus_latinus_mobile/lib/ui/features/marche/marche_trajan_screen.dart`

**Étapes** :
1. Dans la liste des missions de négociation, l'option
   « Minime ! Pretium XVIII HS immutabile est, miles ! » a
   `estBonChoix: false` et `sestercesGain: 5`. Passe `sestercesGain` à `0`,
   et retire « (+5 HS) » de la fin de son `reactionClient` (garde le reste
   de la phrase, guillemets compris).
2. Vérifie qu'aucune autre option avec `estBonChoix: false` n'a un
   `sestercesGain` supérieur à 0 (il ne doit y en avoir aucune après l'étape 1).
3. Dans la méthode qui traite le choix (branche `else`, quand
   `option.estBonChoix` est faux), supprime le bloc
   `if (option.sestercesGain > 0) { widget.repo.addSesterces(...); }`.
   Garde la vibration, le son d'erreur et le message du client.

**Critères de réussite** :
- [x] `flutter analyze` sur le fichier : aucune erreur.
- [x] `grep -n "estBonChoix: false" -A1` ne montre plus aucun `sestercesGain` non nul.
- [x] Sur l'émulateur, Marché de Trajan, négociation : choisir une option
      fausse ne change pas le solde de sesterces (capture avant / après).
- [x] Une bonne option rapporte toujours ses sesterces.
- [x] Affichage du pointeur éteint.
- [x] Un commit `fix(mobile): le Marché ne paie plus les mauvaises réponses`.

Note : le Marché se déverrouille après 18 leçons. Si le profil de
l'émulateur n'en a pas assez, écris-le dans le compte rendu et vérifie
seulement par la lecture du code : **ne modifie pas la progression** pour
contourner le verrou.

**Compte rendu** :
- Fichiers modifiés :
  - `ludus_latinus_mobile/lib/ui/features/marche/marche_trajan_screen.dart`
  - `docs/TACHES.md`
- Commandes lancées et résultat réel :
  - `adb shell settings get system pointer_location` : retourne 0 (overlay pointeur bien éteint).
  - `git grep -n -A 1 "estBonChoix: false" -- ludus_latinus_mobile/lib/ui/features/marche/marche_trajan_screen.dart` :
    4 occurrences trouvées (lignes 260, 267, 299, 331), toutes avec `sestercesGain: 0`. Aucune option fausse ne rapporte de sesterces.
  - `flutter analyze lib/ui/features/marche/marche_trajan_screen.dart` : 0 erreur (3 avertissements de style préexistants : 2 `prefer_const_constructors` et 1 `deprecated_member_use`).
  - `flutter test` : 39 tests réussis, 3 échecs connus préexistants et documentés pour T7 (0 régression).
  - Constat sur l'émulateur `Pixel_Ludus` :
    - Navigation vers l'onglet Ludi (`scratch/t6_marche_locked.png`) : le Marché de Trajan affiche un cadenas avec la mention « Termine 18 leçons pour ouvrir le Marché de Trajan » (barre de progression à 5/18 leçons).
    - Conformément à la consigne explicite (« Si le profil de l'émulateur n'en a pas assez, écris-le dans le compte rendu et vérifie seulement par la lecture du code : ne modifie pas la progression pour contourner le verrou »), la progression n'a pas été altérée pour forcer le déverrouillage.
    - La vérification par le code confirme :
      1. Dans `_choisirOption()` (lignes 404-422), le bloc `if (option.sestercesGain > 0) { widget.repo.addSesterces(option.sestercesGain); }` a été supprimé de la branche `else` (mauvais choix). La vibration tactile, le son d'erreur `AudioService().playError()` et l'affichage de la réaction mécontente du client sont conservés intacts.
      2. Dans la branche `if (option.estBonChoix)` (lignes 383-393), l'appel `widget.repo.addSesterces(option.sestercesGain);` est bien conservé, garantissant qu'une bonne réponse crédite toujours la récompense prévue.
      3. Dans `kMissionsNegociation`, l'option négative « Minime ! Pretium XVIII HS immutabile est, miles ! » a bien `sestercesGain: 0` et sa réplique a été nettoyée de la mention « (+5 HS) ».
- Doutes, questions pour l'architecte : Aucun doute. La non-rémunération des erreurs est garantie à double titre : dans les données (`sestercesGain: 0`) et dans le contrôleur d'événements (`addSesterces` supprimé de la branche d'échec).
- Reste à faire : Rien sur T6. Tâche terminée.

---

## T7 — Diagnostic des 3 tests Flutter en échec (sans rien modifier)

Statut : FAIT

**Objectif** : trois tests échouent depuis longtemps. Avant de corriger, il
faut savoir pour chacun si c'est **le test** ou **le code** qui a tort.
Cette tâche est une enquête : **tu ne modifies aucun fichier** sauf
`docs/TACHES.md` (ton compte rendu).

**Périmètre** :
- lecture seule : `ludus_latinus_mobile/test/`, `ludus_latinus_mobile/lib/`,
  `ludus_latinus_mobile/assets/data/ludus_latinus_dataset.json`
- écriture : `docs/TACHES.md` uniquement

**Les trois tests** (sortie de `flutter test`) :
1. `exercise_and_srs_test.dart` — Type « puzzle » : attend les mots
   `['Romulus', 'Romam', 'condit']`, obtient une liste vide.
2. `exercise_and_srs_test.dart` — Type « decodeur » : attend
   `latinComplet == 'Marcus gladium tenet'`, obtient `null`.
3. `latin_phonetics_test.dart` — « Veni vidi vici » : attend `tʃ`, obtient
   `[ˈve.ni ˈvi.di ˈvit.ʃi]`.

**Étapes** :
1. Pour chaque test, trouve la cause exacte : quelle clé JSON, quel champ du
   modèle, quelle fonction. Compare la donnée utilisée par le test avec la
   structure réelle des leçons dans le dataset (clés `mots`, `phrase_latine`,
   `mots_francais`, `latin_complet`, `roles`…).
2. Dis si c'est le test qui est périmé (le format des données a changé) ou
   le code qui est faux, et propose la correction en une ou deux phrases.
3. **Test 3, point pédagogique** : la leçon m1-01 enseigne la prononciation
   **restituée** (C toujours [k], V toujours [w] : « Késar », « ouilla »).
   Indique quelle prononciation le moteur `LatinPhoneticsEngine` utilise
   réellement (restituée ou ecclésiastique / italienne) sur « Veni vidi
   vici », « Caesar » et « Cicero », avec la sortie exacte obtenue pour
   chacun (écris un petit script ou lance le test en mode verbeux, sans
   modifier les fichiers du dépôt).

**Critères de réussite** :
- [x] `git status` : seul `docs/TACHES.md` est modifié.
- [x] Pour chacun des 3 tests : cause, fautif (test ou code), correction proposée.
- [x] Les sorties phonétiques de « Veni vidi vici », « Caesar », « Cicero ».
- [x] Un commit `docs: diagnostic des 3 tests Flutter en échec`.

**Compte rendu** :
- Fichiers modifiés :
  - `docs/TACHES.md` uniquement (aucun fichier de code ou de test modifié dans le dépôt).
- Commandes lancées et résultat réel :
  - `flutter test` (rappel résultat initial) : 39 passés, 3 échecs (`exercise_and_srs_test.dart` [puzzle & decodeur] et `latin_phonetics_test.dart` [Veni vidi vici]).
  - `git grep '"words"' ludus_latinus_mobile/assets/data/ludus_latinus_dataset.json` : 0 résultat (la clé n'existe pas dans le dataset).
  - `git grep '"mots"' ludus_latinus_mobile/assets/data/ludus_latinus_dataset.json` : 30 occurrences (clé standard de toutes les leçons puzzle / décodeur).
  - `git grep '"latin_complet"' ludus_latinus_mobile/assets/data/ludus_latinus_dataset.json` : 23 occurrences (clé standard du dataset).
  - `git grep '"latinComplet"' ludus_latinus_mobile/assets/data/ludus_latinus_dataset.json` : 0 résultat.
  - `dart scratch/test_phonetics.dart` (script temporaire de lecture phonétique sans modification du code) : analyse exacte des transcriptions API restituée et ecclésiastique.
- Diagnostic test 1 :
  - **Fichier & Ligne** : `test/exercise_and_srs_test.dart` (l. 14).
  - **Cause exacte** : Le test fournit dans son JSON fictif la clé `'words': ['Romulus', 'Romam', 'condit']`. Or, la méthode `Lesson.fromJson` (`lib/data/models/lesson.dart`, l. 47) lit la clé française `json['mots']` (`var rawWords = json['mots'] as List<dynamic>? ?? [];`). Comme la clé `'mots'` est absente, `rawWords` reste vide (`[]`), d'où `lesson.words == []`. Dans `ludus_latinus_dataset.json`, toutes les leçons puzzle (ex: `m1-02`, `m1-05`) utilisent exclusivement `"mots"`.
  - **Qui a tort** : **Le test** (test mal écrit/périmé qui utilise le nom de la variable Dart `words` au lieu de la clé JSON du dataset `mots`).
  - **Correction proposée** : Remplacer dans le test `'words': ['Romulus', 'Romam', 'condit']` par `'mots': ['Romulus', 'Romam', 'condit']`. *(Optionnellement, ajouter `?? json['words']` dans `Lesson.fromJson` pour tolérance aux deux formats).*
- Diagnostic test 2 :
  - **Fichier & Ligne** : `test/exercise_and_srs_test.dart` (l. 50).
  - **Cause exacte** : Le test fournit la clé camelCase `'latinComplet': 'Marcus gladium tenet'`. Or, `Lesson.fromJson` (`lib/data/models/lesson.dart`, l. 86) recherche la clé snake_case standard du dataset : `latinComplet: json['latin_complet'] as String? ?? json['solution_complete'] as String?`. Comme `'latinComplet'` n'est pas géré, la valeur reste `null`. Dans le dataset, la clé utilisée est toujours `"latin_complet"`.
  - **Qui a tort** : **Le test** (test qui utilise le nom de propriété Dart camelCase `latinComplet` au lieu de la clé normalisée du dataset `latin_complet`).
  - **Correction proposée** : Remplacer dans le test `'latinComplet': 'Marcus gladium tenet'` par `'latin_complet': 'Marcus gladium tenet'`. *(Optionnellement, ajouter `?? json['latinComplet']` dans `Lesson.fromJson`).*
- Diagnostic test 3 et prononciation :
  - **Fichier & Ligne** : `test/latin_phonetics_test.dart` (l. 51) et `lib/data/services/latin_phonetics_engine.dart` (l. 258-263, 397, 414-422).
  - **Cause exacte** : Le test vérifie que la transcription ecclésiastique contient l'affriquée `tʃ` (`expect(res.fullIpaEcclesiastique, contains('tʃ'))`). Dans `_transcribeEcclesiastique`, le `c` devant `i` de *vici* est transformé en digramme `tʃ` (`vitʃi`). Ensuite, `_syllabify("vitʃi")` est appelé sur cette chaîne API. Comme `_syllabify` ne connaît que les règles consonnantiques du latin brut (et ignore que `tʃ` forme une consonne affriquée insécable), il applique la coupure consonnantique par défaut entre `t` et `ʃ` (`cuts.add(k1End + 1)`). L'assemblage final insère un point syllabique (`.`), produisant `[ˈvit.ʃi]`. La chaîne générée contient donc `t.ʃ` au lieu de `tʃ`, faisant échouer le test.
  - **Qui a tort** : **Le code** (`LatinPhoneticsEngine`). Phonétiquement, [t͡ʃ] est une affriquée unitaire qui débute la syllabe d'attaque (`vi-ci` -> `[ˈvi.tʃi]`). Couper l'affriquée en deux (`vit.ʃi`) est une erreur de traitement dans la chaîne de transformation syllabique. Dans le lexique pré-annoté (`_curatedLexicon`), `Cicero` et `Caesar` contiennent bien `tʃ` sans coupure (`[ˈtʃi.tʃe.ro]` et `[ˈtʃe.zar]`).
  - **Correction proposée** : Dans `LatinPhoneticsEngine`, découper les syllabes sur le mot latin *avant* la conversion en affriquées API, ou protéger les digrammes affriqués (`tʃ`, `dʒ`, `ts`) dans `_syllabify` pour éviter qu'un point de séparation syllabique ne s'insère entre le `t` et le `ʃ`.
  - **Sorties exactes obtenues du moteur pour les 3 expressions** :
    1. **« Veni vidi vici »** :
       - Restituée : `[ˈwe.ni ˈwi.di ˈwi.ki]`
       - Ecclésiastique : `[ˈve.ni ˈvi.di ˈvit.ʃi]`
    2. **« Caesar »** :
       - Restituée : `[ˈkae̯.sar]`
       - Ecclésiastique : `[ˈtʃe.zar]`
    3. **« Cicero »** :
       - Restituée : `[ˈkɪ.kɛ.roː]`
       - Ecclésiastique : `[ˈtʃi.tʃe.ro]`
  - **Point pédagogique (concordance avec la leçon m1-01)** :
    - La leçon `m1-01` enseigne expressément la prononciation classique restituée (Cicéron, Ier s. av. J.-C.) : C se prononce toujours [k] dur (« Késar »), V se prononce toujours [w] (« ouilla »).
    - Le moteur `LatinPhoneticsEngine` implémente bien les deux systèmes :
      - Il génère à la fois la transcription restituée classique (`fullIpaRestituee`, conforme à m1-01 avec [w] et [k]) et la transcription ecclésiastique médiévale/italienne (`fullIpaEcclesiastique` avec [v] et [tʃ]).
      - Dans l'application mobile (`LatinPronunciationModal`), le mode par défaut à l'ouverture est configuré sur la prononciation restituée (`_isRestituee = true`), permettant à l'élève de basculer sur l'ecclésiastique à titre d'enrichissement culturel et historique.
- Doutes, questions pour l'architecte :
  - Pour une tâche ultérieure de correction des tests : souhaites-tu qu'on corrige uniquement les tests 1 et 2 pour refléter fidèlement le dataset (`mots`, `latin_complet`), ou qu'on rende aussi `Lesson.fromJson` rétrocompatible (`?? json['words']`, `?? json['latinComplet']`) ?
  - Pour le test 3 : pour corriger le comportement de `_syllabify` sur `vitʃi`, préconises-tu d'ajuster `_syllabify` pour qu'il reconnaisse les affriquées API, ou de découper le mot en syllabes avant la substitution API ?
- Reste à faire : Rien sur T7. Tâche d'enquête terminée.

---

## T8 — Remplacer `withOpacity` dans le lecteur de cinématiques et la leçon

Statut : FAIT

**Objectif** : même travail que T1, sur deux autres fichiers qui produisent
des avertissements `deprecated_member_use`.

**Périmètre** :
- `ludus_latinus_mobile/lib/ui/core/cinematic_player.dart`
- `ludus_latinus_mobile/lib/ui/features/lesson/lesson_screen.dart`

**Étapes** :
1. Dans ces deux fichiers uniquement, remplace chaque `.withOpacity(X)` par
   `.withValues(alpha: X)`, en gardant la même valeur `X`.
2. Rien d'autre.

**Critères de réussite** :
- [x] `grep -c "withOpacity"` vaut `0` sur les deux fichiers.
- [x] `flutter analyze` sur les deux fichiers : aucune erreur, plus aucun
      `deprecated_member_use`.
- [x] `flutter test` : 39 réussis et les 3 échecs connus.
- [x] Sur l'émulateur : l'intro (bouton « Passer ») et une leçon
      s'affichent comme avant (captures, pointeur éteint).
- [x] Un commit `refactor(mobile): withValues à la place de withOpacity (cinématiques, leçon)`.

**Compte rendu** :
- Fichiers modifiés :
  - `ludus_latinus_mobile/lib/ui/core/cinematic_player.dart` (2 remplacements)
  - `ludus_latinus_mobile/lib/ui/features/lesson/lesson_screen.dart` (3 remplacements)
  - `docs/TACHES.md`
- Commandes lancées et résultat réel :
  - `git grep "withOpacity" -- ludus_latinus_mobile/lib/ui/core/cinematic_player.dart ludus_latinus_mobile/lib/ui/features/lesson/lesson_screen.dart` : 0 occurrence trouvée (`grep -c` = 0).
  - `flutter analyze lib/ui/core/cinematic_player.dart lib/ui/features/lesson/lesson_screen.dart` : 0 issue (`No issues found! en 6.9s`), aucun `deprecated_member_use`.
  - `flutter test` : 39 passés, 3 échecs historiques connus documentés dans T7 (aucune régression).
  - `flutter build apk --debug` : compilation réussie en 24,1s (`build/app/outputs/flutter-apk/app-debug.apk`).
  - `adb install -r` : installation réussie (`Success`).
  - Validation sur l'émulateur `Pixel_Ludus` :
    - Vidéo d'introduction : bouton « Passer » affiché avec son fond translucide et contour doré (`scratch/t8_intro_passer.png`).
    - Écran de leçon : ouverture de la leçon m1-05 depuis la Via Appia (`scratch/t8_lesson_display.png`), les badges et styles avec transparence s'affichent parfaitement (`scratch/t8_lesson_exercise.png`).
    - Overlay pointeur vérifié éteint (`pointer_location = 0`).
- Doutes, questions pour l'architecte : Aucun doute. La migration vers `.withValues(alpha: X)` élimine complètement les avertissements de dépréciation sur ces deux fichiers.
- Reste à faire : Rien sur T8. Tâche terminée.

**Ordre conseillé** : T5, T6, T7, T8, puis T9 et T10 — une tâche par session, un commit par tâche.

---

## T9 — Remplacer `withOpacity` dans quatre écrans de révision

Statut : FAIT

**Objectif** : même travail que T1 et T8, sur quatre fichiers (14
occurrences) qui produisent des avertissements `deprecated_member_use`.

**Périmètre** :
- `ludus_latinus_mobile/lib/ui/features/memoria/memoria_screen.dart` (3)
- `ludus_latinus_mobile/lib/ui/core/widgets.dart` (3)
- `ludus_latinus_mobile/lib/ui/features/home/views/bibliotheca_view.dart` (2)
- `ludus_latinus_mobile/lib/ui/features/thesaurus/thesaurus_screen.dart` (6)

**Étapes** :
1. Dans ces quatre fichiers uniquement, remplace chaque `.withOpacity(X)`
   par `.withValues(alpha: X)`, en gardant la même valeur `X`.
2. Rien d'autre.

**Critères de réussite** :
- [x] `grep -c "withOpacity"` vaut `0` sur les quatre fichiers.
- [x] `flutter analyze` sur les quatre fichiers : aucune erreur, plus aucun
      `deprecated_member_use` lié à `withOpacity`.
- [x] `flutter test` : 39 réussis et les 3 échecs connus.
- [x] Sur l'émulateur, captures (pointeur éteint) de : Bibliotheca, Memoria
      (une carte avec ses 4 réponses), Thesaurus, et la bulle de Lupulus de
      l'accueil — rendu identique à avant.
- [x] Un commit `refactor(mobile): withValues à la place de withOpacity (révisions)`.

**Compte rendu** :
- Fichiers modifiés :
  - `ludus_latinus_mobile/lib/ui/core/widgets.dart` (3 remplacements)
  - `ludus_latinus_mobile/lib/ui/features/home/views/bibliotheca_view.dart` (2 remplacements)
  - `ludus_latinus_mobile/lib/ui/features/memoria/memoria_screen.dart` (3 remplacements)
  - `ludus_latinus_mobile/lib/ui/features/thesaurus/thesaurus_screen.dart` (6 remplacements)
  - `docs/TACHES.md`
- Commandes lancées et résultat réel :
  - `git grep "withOpacity" -- ludus_latinus_mobile/lib/ui/core/widgets.dart ludus_latinus_mobile/lib/ui/features/home/views/bibliotheca_view.dart ludus_latinus_mobile/lib/ui/features/memoria/memoria_screen.dart ludus_latinus_mobile/lib/ui/features/thesaurus/thesaurus_screen.dart` : 0 occurrence (`grep -c` = 0).
  - `flutter analyze lib/ui/core/widgets.dart lib/ui/features/home/views/bibliotheca_view.dart lib/ui/features/memoria/memoria_screen.dart lib/ui/features/thesaurus/thesaurus_screen.dart` : 0 erreur, aucun `deprecated_member_use` lié à `withOpacity`.
  - `flutter test` : 39 réussis, 3 échecs historiques connus documentés dans T7 (aucune régression).
  - `flutter build apk --debug` et `adb install -r` : compilation et installation réussies sur `Pixel_Ludus`.
  - Captures sur l'émulateur (pointeur éteint `pointer_location = 0`) :
    - Accueil avec bulle Lupulus : `scratch/t9_accueil_lupulus.png`
    - Bibliotheca (grille des outils et révisions) : `scratch/t9_bibliotheca.png`
    - Memoria Velox (carte active avec 4 choix de réponse) : `scratch/t9_memoria.png`
    - Thesaurus (dictionnaire et filtres lexicaux) : `scratch/t9_thesaurus.png`
- Doutes, questions pour l'architecte : Aucun doute. La migration vers `.withValues(alpha: X)` est complète sur ces quatre écrans de révision.
- Reste à faire : Rien sur T9. Tâche terminée.

---

## T10 — Diagnostic : quels mots manquent au Thesaurus ? (sans rien modifier)

Statut : FAIT

**Objectif** : Memoria révise désormais les mots du Thesaurus des mondes
déjà travaillés. Or, à partir du monde 15, chaque monde n'apporte que 0 à 5
mots (le monde 22 : aucun). Avant que l'architecte rédige les mots
manquants, il faut **la liste des mots latins employés dans les leçons et
absents du Thesaurus**, monde par monde. C'est une enquête : **tu ne
modifies aucun fichier du dépôt** sauf `docs/TACHES.md`.

**Périmètre** :
- lecture seule : `ludus_latinus_mobile/assets/data/ludus_latinus_dataset.json`
- script jetable : dans `scratch/` (ignoré par git), jamais dans le dépôt
- écriture : `docs/TACHES.md` uniquement

**Étapes** :
1. Écris un script Python dans `scratch/` qui, pour chaque monde :
   - relève les mots latins des champs `latin`, `latin_complet`,
     `phrase_latine` et, pour les décodeurs, `mots` ;
   - retire la ponctuation et met en minuscules ;
   - les compare aux entrées du Thesaurus (`thesaurus.dictionnaire`, champ
     `latin`, en ne gardant que la forme avant la première virgule ou
     parenthèse, et toutes les formes séparées par `/`).
2. Les formes fléchies comptent comme connues si le radical est évident
   (ex. `Romam` pour `Roma`, `amat` pour `amo`) : signale-les à part,
   « probablement connu », sans les mettre dans la liste principale.
3. Liste aussi les 16 mots du Thesaurus dont le champ `monde` est vide, avec
   leur catégorie, et indique si tu trouves une leçon qui les emploie sous
   une forme fléchie.
4. **N'écris aucune traduction ni aucune entrée de Thesaurus** : c'est du
   contenu pédagogique, réservé à l'architecte et à Cédric.

**Critères de réussite** :
- [x] `git status` : seul `docs/TACHES.md` est modifié.
- [x] Un tableau par monde (1 à 26) : mots absents du Thesaurus, puis
      « probablement connus ».
- [x] La liste des 16 mots sans monde, avec leur catégorie.
- [x] Le chemin du script dans `scratch/`, pour que l'architecte puisse le relancer.
- [x] Un commit `docs: diagnostic des mots manquants au Thesaurus`.

**Compte rendu** :
- Fichiers modifiés :
  - `docs/TACHES.md` uniquement (aucun fichier source ni de données modifié dans le dépôt).
- Commandes lancées et résultat réel :
  - Script développé et exécuté : `python scratch/thesaurus_diagnostic.py` (exécution complète, 26 mondes analysés, 16 mots sans monde investigués).
  - Chemin du script reproductible : `scratch/thesaurus_diagnostic.py`.
- Mots manquants par monde (Mondes 1 à 26) :

### Monde 1 — 1 · Salve ! Premiers pas à Rome 🏛️
- **Phrases sources** :
  - `m1-02` (puzzle) : *Salve, amice !*
  - `m1-03` (trou) : *Romanus sum.*
  - `m1-05` (puzzle) : *Lupa pueros curat.*
- **Mots absents du Thesaurus (0)** :
  *(Aucun mot absent)*
- **Mots « probablement connus » (formes fléchies du Thesaurus) (5)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `amice` | `amicus, -i` | vocatif singulier de amicus |
| `romanus` | `Roma, -ae` | dérivé de Roma |
| `sum` | `esse (sum, fui)` | présent 1sg de esse |
| `pueros` | `puer, -eri` | accusatif pluriel de puer |
| `curat` | `curare` | présent 3sg de curare |
- **Formes exactes du Thesaurus (2)** : `salve` (salve / salvete), `lupa` (lupa, -ae)

### Monde 2 — 2 · Dans la Maison Romaine 🏠
- **Phrases sources** :
  - `m2-02` (puzzle) : *Canis in horto est.*
  - `m2-03` (trou) : *Discipulus scribit in tabula.*
- **Mots absents du Thesaurus (3)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `in` | `in` | préposition |
| `discipulus` | `discipulus, -i` | nom masculin |
| `tabula` | `tabula, -ae` | nom féminin |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (3)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `horto` | `hortus, -i` | ablatif singulier de hortus |
| `est` | `esse (sum, fui)` | présent 3sg de esse |
| `scribit` | `scribere` | présent 3sg de scribere |
- **Formes exactes du Thesaurus (1)** : `canis` (canis, -is)

### Monde 3 — 3 · Les Dieux de l'Olympe & Légendes ⚡
- **Phrases sources** :
  - `m3-02` (puzzle) : *Midas aurum amat.*
  - `m3-03` (trou) : *Icarus ad solem volat.*
- **Mots absents du Thesaurus (6)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `midas` | `Midas` | nom propre mythologique |
| `aurum` | `aurum, -i` | nom neutre |
| `icarus` | `Icarus` | nom propre mythologique |
| `ad` | `ad` | préposition |
| `solem` | `sol, solis` | accusatif singulier de sol |
| `volat` | `volare` | présent 3sg de volare |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (1)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `amat` | `amare` | présent 3sg de amare |

### Monde 4 — 4 · Les Cas & Travaux d'Hercule 🦁
- **Phrases sources** :
  - `m4-02` (puzzle) : *Puella cantat.*
  - `m4-03` (trou) : *Puer puellam amat.*
  - `m4-04` (decodeur) : *Lupus agnum videt*
- **Mots absents du Thesaurus (0)** :
  *(Aucun mot absent)*
- **Mots « probablement connus » (formes fléchies du Thesaurus) (5)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `cantat` | `cantare` | présent 3sg de cantare |
| `puellam` | `puella, -ae` | accusatif singulier de puella |
| `amat` | `amare` | présent 3sg de amare |
| `agnum` | `agnus, -i` | accusatif singulier de agnus |
| `videt` | `videre` | présent 3sg de videre |
- **Formes exactes du Thesaurus (3)** : `puella` (puella, -ae), `puer` (puer, -eri), `lupus` (lupus, -i)

### Monde 5 — 5 · Les Verbes au Présent & L'Action ⚔️
- **Phrases sources** :
  - `m5-01` (puzzle) : *Romanus sum.*
  - `m5-02` (trou) : *Marcus Romam amat.*
  - `m5-03` (puzzle) : *Miles fortiter pugnat.*
  - `m5-04` (decodeur) : *Miles gladium capit*
- **Mots absents du Thesaurus (1)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `marcus` | `Marcus` | nom propre |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (7)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `romanus` | `Roma, -ae` | dérivé de Roma |
| `sum` | `esse (sum, fui)` | présent 1sg de esse |
| `romam` | `Roma, -ae` | accusatif singulier de Roma |
| `amat` | `amare` | présent 3sg de amare |
| `pugnat` | `pugnare` | présent 3sg de pugnare |
| `gladium` | `gladius, -i` | accusatif singulier de gladius |
| `capit` | `capere` | présent 3sg de capere |
- **Formes exactes du Thesaurus (2)** : `miles` (miles, -itis), `fortiter` (fortiter)

### Monde 6 — 6 · Les Gladiateurs & le Colisée 🛡️
- **Phrases sources** :
  - `m6-02` (puzzle) : *Equi celeriter currunt.*
  - `m6-03` (trou) : *Ave Caesar !*
- **Mots absents du Thesaurus (3)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `celeriter` | `celeriter` | adverbe |
| `ave` | `ave` | salutation/interjection |
| `caesar` | `Caesar` | nom propre historique |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (2)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `equi` | `equus, -i` | nominatif pluriel de equus |
| `currunt` | `currere` | présent 3pl de currere |

### Monde 7 — 7 · Détective des Mots & Devises 📜
- **Phrases sources** :
  - `m7-02` (trou) : *Submarin.*
  - `m7-03` (puzzle) : *Veni, vidi, vici.*
- **Mots absents du Thesaurus (1)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `submarin` | `submarin` | mot français (exercice didactique préfixe sub-) |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (3)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `veni` | `venire` | parfait 1sg de venire |
| `vidi` | `videre` | parfait 1sg de videre |
| `vici` | `vincere` | parfait 1sg de vincere |

### Monde 8 — 8 · La Cité de Rome, Marchés & Vie Quotidienne 🍇
- **Phrases sources** :
  - `m8-02` (puzzle) : *Puer panem emit.*
  - `m8-04` (decodeur) : *Mercator aquam vendit*
- **Mots absents du Thesaurus (0)** :
  *(Aucun mot absent)*
- **Mots « probablement connus » (formes fléchies du Thesaurus) (4)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `panem` | `panis, -is` | accusatif singulier de panis |
| `emit` | `emere` | présent 3sg de emere |
| `aquam` | `aqua, -ae` | accusatif singulier de aqua |
| `vendit` | `vendere` | présent 3sg de vendere |
- **Formes exactes du Thesaurus (2)** : `puer` (puer, -eri), `mercator` (mercator, -oris)

### Monde 9 — 9 · L'Armée Romaine & les Légions 🦅
- **Phrases sources** :
  - `m9-02` (puzzle) : *Legio fortiter pugnat.*
  - `m9-04` (decodeur) : *Miles pilum iacit*
- **Mots absents du Thesaurus (1)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `iacit` | `iacere` | présent 3sg de iacere |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (1)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `pugnat` | `pugnare` | présent 3sg de pugnare |
- **Formes exactes du Thesaurus (4)** : `legio` (legio, -onis), `fortiter` (fortiter), `miles` (miles, -itis), `pilum` (pilum, -i)

### Monde 10 — 10 · Monstres Fabuleux & Métamorphoses 🐉
- **Phrases sources** :
  - `m10-02` (puzzle) : *Cerberus portas custodit.*
  - `m10-04` (decodeur) : *Hercules monstrum superat*
- **Mots absents du Thesaurus (3)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `cerberus` | `Cerberus` | nom propre mythologique |
| `hercules` | `Hercules` | nom propre mythologique |
| `superat` | `superare` | présent 3sg de superare |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (2)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `portas` | `porta, -ae` | accusatif pluriel de porta |
| `custodit` | `custodire` | présent 3sg de custodire |
- **Formes exactes du Thesaurus (1)** : `monstrum` (monstrum, -i)

### Monde 11 — 11 · Les Héros de la République 🛡️
- **Phrases sources** :
  - `m11-02` (puzzle) : *Civis Romanus sum.*
  - `m11-03` (trou) : *Cloelia fluvium transit.*
- **Mots absents du Thesaurus (3)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `cloelia` | `Cloelia` | nom propre historique |
| `fluvium` | `fluvius, -i` | accusatif singulier de fluvius |
| `transit` | `transire` | présent 3sg de transire |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (2)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `romanus` | `Roma, -ae` | dérivé de Roma |
| `sum` | `esse (sum, fui)` | présent 1sg de esse |
- **Formes exactes du Thesaurus (1)** : `civis` (civis, -is)

### Monde 12 — 12 · Le Sénat et le Peuple (SPQR) 🏛️
- **Phrases sources** :
  - `m12-02` (trou) : *Consul militem convocat.*
  - `m12-03` (puzzle) : *Dux leges civibus dat.*
- **Mots absents du Thesaurus (2)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `convocat` | `convocare` | présent 3sg de convocare |
| `dat` | `dare` | présent 3sg de dare |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (3)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `militem` | `miles, -itis` | accusatif singulier de miles |
| `leges` | `lex, legis` | accusatif pluriel de lex |
| `civibus` | `civis, -is` | datif/ablatif pluriel de civis |
- **Formes exactes du Thesaurus (2)** : `consul` (consul, -is), `dux` (dux, ducis)

### Monde 13 — 13 · Mare Nostrum & Les Conquêtes ⛵
- **Phrases sources** :
  - `m13-02` (trou) : *Naves maria percurrunt.*
  - `m13-03` (puzzle) : *Naves Romanae in mari navigant.*
- **Mots absents du Thesaurus (2)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `percurrunt` | `percurrere` | présent 3pl de percurrere |
| `in` | `in` | préposition |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (5)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `naves` | `navis, -is` | nominatif/accusatif pluriel de navis |
| `maria` | `mare, -is` | nominatif/accusatif pluriel de mare |
| `romanae` | `Roma, -ae` | dérivé féminin pluriel de Roma |
| `mari` | `mare, -is` | ablatif singulier de mare |
| `navigant` | `navigare` | présent 3pl de navigare |

### Monde 14 — 14 · Les Légions en Marche 🦅
- **Phrases sources** :
  - `m14-02` (trou) : *Dux ingens periculum videt.*
  - `m14-03` (puzzle) : *Miles Romanus fortissimus est.*
- **Mots absents du Thesaurus (2)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `ingens` | `ingens, -entis` | adjectif |
| `periculum` | `periculum, -i` | nom neutre |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (4)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `videt` | `videre` | présent 3sg de videre |
| `romanus` | `Roma, -ae` | dérivé de Roma |
| `fortissimus` | `fortis, -e` | superlatif de fortis |
| `est` | `esse (sum, fui)` | présent 3sg de esse |
- **Formes exactes du Thesaurus (2)** : `dux` (dux, ducis), `miles` (miles, -itis)

### Monde 15 — 15 · Récits d'Autrefois : L'Imparfait 📜
- **Phrases sources** :
  - `m15-02` (trou) : *Cives in foro erant.*
  - `m15-03` (puzzle) : *Romani in foro conveniebant.*
- **Mots absents du Thesaurus (2)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `in` | `in` | préposition |
| `conveniebant` | `convenire` | imparfait 3pl de convenire |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (4)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `cives` | `civis, -is` | nominatif/accusatif pluriel de civis |
| `foro` | `forum, -i` | ablatif singulier de forum |
| `erant` | `esse (sum, fui)` | imparfait 3pl de esse |
| `romani` | `Roma, -ae` | dérivé masculin pluriel de Roma |

### Monde 16 — 16 · Veni, Vidi, Vici : Le Parfait ⚡
- **Phrases sources** :
  - `m16-02` (trou) : *Caesar clarus dux fuit.*
  - `m16-03` (puzzle) : *Veni, vidi, vici.*
- **Mots absents du Thesaurus (1)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `caesar` | `Caesar` | nom propre historique |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (4)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `fuit` | `esse (sum, fui)` | parfait 3sg de esse |
| `veni` | `venire` | parfait 1sg de venire |
| `vidi` | `videre` | parfait 1sg de videre |
| `vici` | `vincere` | parfait 1sg de vincere |
- **Formes exactes du Thesaurus (2)** : `clarus` (clarus, -a, -um), `dux` (dux, ducis)

### Monde 17 — 17 · César et la Guerre des Gaules 🏹
- **Phrases sources** :
  - `m17-02` (trou) : *Caesar eum vincet.*
  - `m17-03` (puzzle) : *Galli pro libertate pugnabant.*
- **Mots absents du Thesaurus (4)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `caesar` | `Caesar` | nom propre historique |
| `eum` | `is, ea, id` | pronom accusatif masculin singulier |
| `pro` | `pro` | préposition |
| `libertate` | `libertas, -atis` | ablatif singulier de libertas |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (3)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `vincet` | `vincere` | futur 3sg de vincere |
| `galli` | `Gallus, -i` | nominatif pluriel de Gallus |
| `pugnabant` | `pugnare` | imparfait 3pl de pugnare |

### Monde 18 — 18 · Le Grand Triomphe de la République 👑
- **Phrases sources** :
  - `m18-02` (trou) : *Fortes milites patriam defenderunt.*
  - `m18-03` (puzzle) : *Virtus et sapientia rem publicam servant.*
- **Mots absents du Thesaurus (3)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `et` | `et` | conjonction |
| `sapientia` | `sapientia, -ae` | nom féminin |
| `servant` | `servare` | présent 3pl de servare |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (6)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `fortes` | `fortis, -e` | nominatif pluriel de fortis |
| `milites` | `miles, -itis` | nominatif pluriel de miles |
| `patriam` | `patria, -ae` | accusatif singulier de patria |
| `defenderunt` | `defendere` | parfait 3pl de defendere |
| `rem` | `res, rei` | accusatif singulier de res |
| `publicam` | `respublica, reipublicae` | accusatif féminin sg de publicus / respublica |
- **Formes exactes du Thesaurus (1)** : `virtus` (virtus, -utis)

### Monde 19 — 19 · La Paix d'Auguste (Pax Romana) 🏛️
- **Phrases sources** :
  - `m19-02` (trou) : *Dies novus est.*
  - `m19-03` (puzzle) : *Augustus pacem populo dedit.*
- **Mots absents du Thesaurus (3)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `novus` | `novus, -a, -um` | adjectif |
| `augustus` | `Augustus` | nom propre historique |
| `dedit` | `dare` | parfait 3sg de dare |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (3)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `est` | `esse (sum, fui)` | présent 3sg de esse |
| `pacem` | `pax, pacis` | accusatif singulier de pax |
| `populo` | `populus, -i` | datif singulier de populus |
- **Formes exactes du Thesaurus (1)** : `dies` (dies, -ei)

### Monde 20 — 20 · Les Chemins de l'Empire 🛣️
- **Phrases sources** :
  - `m20-02` (trou) : *Via quae Romam ducit.*
  - `m20-03` (puzzle) : *Via Appia regina viarum est.*
- **Mots absents du Thesaurus (3)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `quae` | `qui, quae, quod` | pronom relatif |
| `appia` | `Appius, -a, -um` | nom propre/adjectif |
| `regina` | `regina, -ae` | nom féminin |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (4)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `romam` | `Roma, -ae` | accusatif singulier de Roma |
| `ducit` | `ducere` | présent 3sg de ducere |
| `viarum` | `via, -ae` | génitif pluriel de via |
| `est` | `esse (sum, fui)` | présent 3sg de esse |
- **Formes exactes du Thesaurus (1)** : `via` (via, -ae)

### Monde 21 — 21 · Sous la Cendre du Vésuve 🌋
- **Phrases sources** :
  - `m21-02` (trou) : *Pompeii urbs deleta est.*
  - `m21-03` (puzzle) : *Mons Vesuvius nubes atra erigebat.*
- **Mots absents du Thesaurus (6)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `pompeii` | `Pompeii` | nom propre toponyme |
| `deleta` | `delere` | participe parfait passif de delere |
| `vesuvius` | `Vesuvius` | nom propre toponyme |
| `nubes` | `nubes, -is` | nom féminin |
| `atra` | `ater, atra, atrum` | adjectif |
| `erigebat` | `erigere` | imparfait 3sg de erigere |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (1)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `est` | `esse (sum, fui)` | présent 3sg de esse |
- **Formes exactes du Thesaurus (2)** : `urbs` (urbs, urbis), `mons` (mons, montis)

### Monde 22 — 22 · Le Secret de l'Ablatif Absolu 📜
- **Phrases sources** :
  - `m22-02` (trou) : *Pace facta, cives gaudent.*
  - `m22-03` (puzzle) : *Caesare duce, Romani vicerunt.*
- **Mots absents du Thesaurus (3)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `facta` | `facere` | participe parfait passif de facere |
| `gaudent` | `gaudere` | présent 3pl de gaudere |
| `caesare` | `Caesar` | ablatif de Caesar |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (5)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `pace` | `pax, pacis` | ablatif singulier de pax |
| `cives` | `civis, -is` | nominatif/accusatif pluriel de civis |
| `duce` | `dux, ducis` | ablatif singulier de dux |
| `romani` | `Roma, -ae` | dérivé masculin pluriel de Roma |
| `vicerunt` | `vincere` | parfait 3pl de vincere |

### Monde 23 — 23 · Les Échos du Forum : La Voix Passive 🏛️
- **Phrases sources** :
  - `m23-02` (trou) : *Patria a Romanis amatur.*
  - `m23-03` (puzzle) : *Pax et concordia a civibus quaeruntur.*
- **Mots absents du Thesaurus (4)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `a` | `a / ab` | préposition |
| `et` | `et` | conjonction |
| `concordia` | `concordia, -ae` | nom féminin |
| `quaeruntur` | `quaerere` | présent passif 3pl de quaerere |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (3)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `romanis` | `Roma, -ae` | dérivé ablatif pluriel de Roma |
| `amatur` | `amare` | présent passif 3sg de amare |
| `civibus` | `civis, -is` | datif/ablatif pluriel de civis |
- **Formes exactes du Thesaurus (2)** : `patria` (patria, -ae), `pax` (pax, pacis)

### Monde 24 — 24 · La Proposition Infinitive 🗣️
- **Phrases sources** :
  - `m24-02` (trou) : *Audio amicum venire.*
  - `m24-03` (puzzle) : *Dicit consulem Romam venire.*
- **Mots absents du Thesaurus (0)** :
  *(Aucun mot absent)*
- **Mots « probablement connus » (formes fléchies du Thesaurus) (5)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `audio` | `audire` | présent 1sg de audire |
| `amicum` | `amicus, -i` | accusatif singulier de amicus |
| `dicit` | `dicere` | présent 3sg de dicere |
| `consulem` | `consul, -is` | accusatif singulier de consul |
| `romam` | `Roma, -ae` | accusatif singulier de Roma |
- **Formes exactes du Thesaurus (1)** : `venire` (venire)

### Monde 25 — 25 · L'Or des Poètes : Virgile & Ovide 📜
- **Phrases sources** :
  - `m25-02` (trou) : *Felix sis !*
  - `m25-03` (puzzle) : *Arma virumque cano.*
- **Mots absents du Thesaurus (4)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `felix` | `felix, -icis` | adjectif |
| `arma` | `arma, -orum` | nom neutre pluriel |
| `virumque` | `vir, -i + -que` | accusatif de vir + enclitique -que |
| `cano` | `canere` | présent 1sg de canere |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (1)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `sis` | `esse (sum, fui)` | subjonctif présent 2sg de esse |

### Monde 26 — 26 · Le Grand Triomphe du Collège 👑
- **Phrases sources** :
  - `m26-02` (trou) : *Populus Romanus libertatem et pacem servat.*
  - `m26-03` (puzzle) : *Litterae et sapientia mentem hominis ornant.*
- **Mots absents du Thesaurus (7)** :
| Mot dans la leçon | Lemme / Radical suggéré | Nature grammaticale |
|---|---|---|
| `libertatem` | `libertas, -atis` | accusatif singulier de libertas |
| `et` | `et` | conjonction |
| `servat` | `servare` | présent 3sg de servare |
| `litterae` | `littera, -ae` | nominatif pluriel de littera |
| `sapientia` | `sapientia, -ae` | nom féminin |
| `mentem` | `mens, mentis` | accusatif singulier de mens |
| `ornant` | `ornare` | présent 3pl de ornare |
- **Mots « probablement connus » (formes fléchies du Thesaurus) (3)** :
| Forme fléchie | Entrée Thesaurus de rattachement | Analyse morphologique |
|---|---|---|
| `romanus` | `Roma, -ae` | dérivé de Roma |
| `pacem` | `pax, pacis` | accusatif singulier de pax |
| `hominis` | `homo, -inis` | génitif singulier de homo (Thesaurus sans monde) |
- **Formes exactes du Thesaurus (1)** : `populus` (populus, -i)

- Mots du Thesaurus sans monde :

| # | Entrée latine | Catégorie | Emploi fléchi dans les leçons ? |
|---|---|---|---|
| 1 | `amica, -ae` | Nom | Non (absent des leçons) |
| 2 | `arcus, -us` | Nom | Non (absent des leçons) |
| 3 | `homo, -inis` | Nom | **Oui** : `m26-03` (*hominis*, génitif singulier) |
| 4 | `verbum, -i` | Nom | Non (absent des leçons) |
| 5 | `docere (doceo, docui, doctum)` | Verbe | Non (absent des leçons) |
| 6 | `habere (habeo, habui, habitum)` | Verbe | Non (absent des leçons) |
| 7 | `mittere (mitto, misi, missum)` | Verbe | Non (absent des leçons) |
| 8 | `monere (moneo, monui, monitum)` | Verbe | Non (absent des leçons) |
| 9 | `posse (possum, potui)` | Verbe | Non (absent des leçons) |
| 10 | `vivere (vivo, vixi, victum)` | Verbe | Non (absent des leçons) |
| 11 | `brevis, -e` | Adjectif | Non (absent des leçons) |
| 12 | `malus, -a, -um` | Adjectif | Non (absent des leçons) |
| 13 | `parvus, -a, -um` | Adjectif | Non (absent des leçons) |
| 14 | `pulcher, -chra, -chrum` | Adjectif | Non (absent des leçons) |
| 15 | `Alea iacta est` | Devise | Non (absent des leçons) |
| 16 | `Festina lente` | Devise | Non (absent des leçons) |

- Doutes, questions pour l'architecte :
  - Sur `submarin` (monde 7, `m7-02`) : mot français pour l'exercice didactique sur le préfixe latin `sub-`.
  - Sur les noms propres (ex. `Midas`, `Icarus`, `Marcus`, `Caesar`, `Cerberus`, `Hercules`, `Cloelia`, `Pompeii`, `Vesuvius`) : à trancher si l'architecte souhaite les intégrer au Thesaurus ou les considérer hors lexique d'apprentissage de base.
  - Sur les mots grammaticaux invariants (prépositions `in`, `ad`, `pro`, `a/ab`, conjonction `et`, salutation `ave`, pronom relatif `qui, quae, quod`) : à décider s'ils doivent entrer dans la catégorie `Invariable` du Thesaurus.
- Reste à faire : Rien sur T10. Tâche terminée.
