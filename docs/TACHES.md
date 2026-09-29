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

Statut : VALIDÉ

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

**Vérification de l'architecte** : diff limité à `_toggleGender` : le prénom est gardé, seuls Marcus et Julia basculent. Validé.

---

## T6 — Marché de Trajan : une mauvaise réponse ne rapporte plus rien

Statut : VALIDÉ

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

**Vérification de l'architecte** : `sestercesGain` à 0 et paiement retiré de la branche d'erreur ; j'ai vérifié qu'aucune autre mauvaise option du fichier ne paie encore. Validé.

---

## T7 — Diagnostic des 3 tests Flutter en échec (sans rien modifier)

Statut : VALIDÉ

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

**Vérification de l'architecte** : diagnostic juste et bien sourcé. Décisions : on corrige les tests 1 et 2 côté test seulement (T11, sans rétrocompatibilité dans `Lesson.fromJson`) ; on protège les affriquées dans `_syllabify` (T12). Le moteur s'ouvre sur la prononciation restituée : cohérent avec m1-01. Validé.

---

## T8 — Remplacer `withOpacity` dans le lecteur de cinématiques et la leçon

Statut : VALIDÉ

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

**Ordre conseillé** : T5, T6, T7, T8, puis T9 et T10 — une tâche par session, un commit par tâche. (Toutes validées.)

**Vérification de l'architecte** : 4 remplacements, plus aucun `withOpacity` dans les deux fichiers. Validé.

---

## T9 — Remplacer `withOpacity` dans quatre écrans de révision

Statut : VALIDÉ

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

**Vérification de l'architecte** : 14 remplacements, conformes, plus aucun `withOpacity` dans les quatre fichiers. Validé.

---

## T10 — Diagnostic : quels mots manquent au Thesaurus ? (sans rien modifier)

Statut : VALIDÉ

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

**Vérification de l'architecte** : tableaux complets par monde, script resté dans `scratch/` (ignoré par git). Réponses : les noms propres restent hors Thesaurus ; les mots invariables utiles (`in`, `ad`, `et`, `ave`, `a/ab`, `pro`) y entreront avec la catégorie `Invariable` ; « submarin » est un mot français voulu. L'enrichissement sera écrit par l'architecte puis validé par Cédric. Validé.

---

**Ordre conseillé pour la suite** : T11, T12, T13, T14 — une tâche par session,
un commit par tâche. Commite **uniquement les fichiers de ton périmètre**
(`git add <fichier>`, jamais `git add -A` ni `git add .`) : l'architecte
travaille dans le même dépôt.

---

## T11 — Réparer les deux tests périmés du puzzle et du décodeur

Statut : VALIDÉ

**Objectif** : les tests 1 et 2 de T7 échouent parce qu'ils utilisent de
vieux noms de clés. On corrige **les tests**, pas le code : le dataset utilise
`mots` et `latin_complet`, et `Lesson.fromJson` a raison.

**Périmètre** :
- `ludus_latinus_mobile/test/exercise_and_srs_test.dart`
- `docs/TACHES.md`

**Étapes** :
1. Dans le test « puzzle », remplace la clé `'words'` par `'mots'`.
2. Dans le test « décodeur », remplace la clé `'latinComplet'` par `'latin_complet'`.
3. Ne change rien d'autre : ni les valeurs, ni les `expect`, ni `lib/`.
4. Lance `flutter test`, puis `git checkout -- ludus_latinus_mobile/analysis_options.yaml`
   (voir le piège 5 d'`AGENTS.md`).

**Critères de réussite** (tous obligatoires) :
- [x] `git diff` : exactement 2 lignes changées dans le fichier de test.
- [x] `flutter test` : il ne reste qu'**un** échec, celui de « Veni vidi vici ».
      Recopie la ligne finale du résultat (« +N -1 »).
- [x] Un commit `test(mobile): clés du dataset dans les tests puzzle et décodeur`.

**Compte rendu** (rempli par l'exécutant) :
- Fichiers modifiés :
  - `ludus_latinus_mobile/test/exercise_and_srs_test.dart` (2 lignes changées : `words` -> `mots` l. 14, `latinComplet` -> `latin_complet` l. 50)
  - `docs/TACHES.md`
- Commandes lancées et résultat réel :
  - `git diff ludus_latinus_mobile/test/exercise_and_srs_test.dart` : exactement 2 lignes changées.
  - `flutter test` : 49 passés, 1 échec restant (« Veni vidi vici »).
    Ligne finale : `00:03 +49 -1: Some tests failed.`
  - `git checkout -- ludus_latinus_mobile/analysis_options.yaml` : restauré après le passage des tests.
- Doutes, questions pour l'architecte : Aucun doute. Les deux tests testent désormais les clés réelles du dataset.
- Reste à faire : Rien sur T11. Tâche terminée.

**Vérification de l'architecte** : exactement les 2 clés demandées, rien d'autre ; il ne reste que l'échec de « Veni vidi vici », confié en T12. Validé.

---

## T12 — Prononciation : ne plus couper les affriquées en deux syllabes

Statut : VALIDÉ

**Objectif** : en prononciation ecclésiastique, « vici » donne `[ˈvit.ʃi]` au
lieu de `[ˈvi.tʃi]` : la syllabation coupe l'affriquée `tʃ`. C'est un vrai
défaut du moteur (voir T7) ; il fait échouer le dernier test.

**Périmètre** :
- `ludus_latinus_mobile/lib/data/services/latin_phonetics_engine.dart`
  (fonction `_syllabify` **seulement**)
- `ludus_latinus_mobile/test/latin_phonetics_test.dart` (ajout d'un test)
- `docs/TACHES.md`

**Étapes** :
1. Dans `_syllabify`, dans la boucle qui calcule `between` (les consonnes entre
   deux voyelles), ajoute **en premier** un cas : si `between` se termine par
   une des suites `tʃ`, `dʒ`, `ts` ou `kw`, la coupure se place **juste avant**
   cette suite : `cuts.add(k2Start - 2)`. Ces quatre suites sont un seul son
   (affriquée) ou un seul groupe (qu), qui ouvre la syllabe suivante.
   Attention : `ʃ` et `ʒ` sont chacun **un seul** caractère Dart, donc
   `tʃ` fait bien 2 de longueur.
2. Ne touche à aucune autre règle (muta cum liquida, `qu` du latin brut…).
3. Ajoute dans `latin_phonetics_test.dart` un test qui vérifie que
   `LatinPhoneticsEngine.analyze('Veni vidi vici').fullIpaEcclesiastique`
   contient `vi.tʃi` ou `ˈvi.tʃi`, et ne contient pas `t.ʃ`.
4. Écris un petit script dans `scratch/` (hors dépôt) qui affiche les deux
   transcriptions (restituée et ecclésiastique) de : `Veni vidi vici`,
   `Caesar`, `Cicero`, `legiones`, `sequitur`, `gratia`, `amicitia`.
   Recopie-les **avant et après** ta modification dans le compte rendu.
5. `flutter test`, puis `git checkout -- ludus_latinus_mobile/analysis_options.yaml`.

**Critères de réussite** (tous obligatoires) :
- [x] `git diff` : seule `_syllabify` change dans le moteur, plus le nouveau test.
- [x] `flutter test` : **0 échec** (si T11 est faite). Recopie la ligne finale.
- [x] Les 7 transcriptions avant et après, et aucune transcription
      **restituée** n'a changé (sinon, explique pourquoi).
- [x] Un commit `fix(mobile): la syllabation garde les affriquées entières`.

**Compte rendu** (rempli par l'exécutant) :
- Fichiers modifiés :
  - `ludus_latinus_mobile/lib/data/services/latin_phonetics_engine.dart` (seule la fonction `_syllabify` a été modifiée : ajout de la condition préservant `tʃ`, `dʒ`, `ts` et `kw` entières en début de syllabe)
  - `ludus_latinus_mobile/test/latin_phonetics_test.dart` (ajout du test unitaire `Non-coupure des affriquées en deux syllabes (vici -> vi.tʃi)`)
  - `docs/TACHES.md`
- Commandes lancées et résultat réel :
  - `git diff ludus_latinus_mobile/lib/data/services/latin_phonetics_engine.dart` : exactement 3 lignes ajoutées dans `_syllabify`.
  - `dart run scratch/test_phonetics_t12.dart` : exécution avant et après pour relever les 7 phrases tests.
  - `flutter test` : 54 réussis, 0 échec. Ligne finale : `00:04 +54: All tests passed!`
  - `git checkout -- ludus_latinus_mobile/analysis_options.yaml` : exécuté après les tests.
- Transcriptions des 7 phrases **avant** la modification :
| Phrase | Restituée | Ecclésiastique |
|---|---|---|
| `Veni vidi vici` | `[ˈwe.ni ˈwi.di ˈwi.ki]` | `[ˈve.ni ˈvi.di ˈvit.ʃi]` |
| `Caesar` | `[ˈkae̯.sar]` | `[ˈtʃe.zar]` |
| `Cicero` | `[ˈkɪ.kɛ.roː]` | `[ˈtʃi.tʃe.ro]` |
| `legiones` | `[leˈɡi.o.nes]` | `[ledˈʒi.o.nes]` |
| `sequitur` | `[sekˈwi.tur]` | `[sekˈwi.tur]` |
| `gratia` | `[ˈɡra.ti.a]` | `[ˈgrat.si.a]` |
| `amicitia` | `[a.miˈki.ti.a]` | `[a.mitˈʃit.si.a]` |

- Transcriptions des 7 phrases **après** la modification :
| Phrase | Restituée | Ecclésiastique |
|---|---|---|
| `Veni vidi vici` | `[ˈwe.ni ˈwi.di ˈwi.ki]` | `[ˈve.ni ˈvi.di ˈvi.tʃi]` |
| `Caesar` | `[ˈkae̯.sar]` | `[ˈtʃe.zar]` |
| `Cicero` | `[ˈkɪ.kɛ.roː]` | `[ˈtʃi.tʃe.ro]` |
| `legiones` | `[leˈɡi.o.nes]` | `[leˈdʒi.o.nes]` |
| `sequitur` | `[seˈkwi.tur]` | `[seˈkwi.tur]` |
| `gratia` | `[ˈɡra.ti.a]` | `[ˈgra.tsi.a]` |
| `amicitia` | `[a.miˈki.ti.a]` | `[a.miˈtʃi.tsi.a]` |

- Analyse des transcriptions restituées et ecclésiastiques :
  - **Ecclésiastique** : les affriquées `tʃ` (*vici*, *amicitia*), `dʒ` (*legiones*), `ts` (*gratia*, *amicitia*) ainsi que `kw` ne sont plus scindées par un point de coupe syllabique (`vit.ʃi` -> `vi.tʃi`, `led.ʒi` -> `le.dʒi`, `grat.si` -> `gra.tsi`).
  - **Restituée** : 6 des 7 transcriptions sont strictement identiques. Seule la restituée de `sequitur` passe de `[sekˈwi.tur]` à `[seˈkwi.tur]`.
    *Explication* : dans la chaîne API restituée, `qu` est transcrit en `kw`. Auparavant, `_syllabify` connaissait la règle pour le `qu` orthographique latin (`between.startsWith('qu')`), mais lors du passage sur la chaîne API contenant `kw`, cette séquence de 2 consonnes tombait dans le cas général scindé en `k.w`. La nouvelle règle `between.endsWith('kw')` conserve le groupe labiovélaire unitaire ouvrant la syllabe (`se.kwi.tur`), ce qui est la prononciation exacte du latin classique restitué.
- Doutes, questions pour l'architecte : Aucun doute. La totalité de la suite de tests Flutter passe désormais au vert (54/54).
- Reste à faire : Rien sur T12. Tâche terminée.

**Vérification de l'architecte** : une seule condition ajoutée dans `_syllabify`, test ajouté, 54 tests sur 54 chez moi aussi. Le changement de la restituée de *sequitur* (`se.kwi.tur`) est bien une correction. Validé.

---

## T13 — Remplacer `withOpacity` dans l'audio et les décors

Statut : VALIDÉ

**Objectif** : même travail que T1, T8 et T9, sur les trois fichiers qui en
ont le plus.

**Périmètre** :
- `ludus_latinus_mobile/lib/ui/core/roman_audio_modal.dart` (13)
- `ludus_latinus_mobile/lib/ui/core/room_decorations.dart` (9)
- `ludus_latinus_mobile/lib/ui/core/roman_ornaments.dart` (9)
- `docs/TACHES.md`

**Étapes** :
1. Remplace chaque `.withOpacity(x)` par `.withValues(alpha: x)`, rien d'autre.
2. Pas de `dart format` sur ces fichiers (piège 10 d'`AGENTS.md`).
3. `flutter analyze` sur les trois fichiers, puis `flutter test`, puis
   `git checkout -- ludus_latinus_mobile/analysis_options.yaml`.

**Critères de réussite** (tous obligatoires) :
- [x] `grep -c withOpacity` donne 0 pour les trois fichiers.
- [x] 31 lignes changées au total, chacune ne différant que par ce remplacement.
- [x] `flutter test` : même résultat qu'avant ta modification.
- [x] Un commit `refactor(mobile): withValues à la place de withOpacity (audio, décors)`.

**Compte rendu** (rempli par l'exécutant) :
- Fichiers modifiés :
  - `ludus_latinus_mobile/lib/ui/core/roman_audio_modal.dart` (13 remplacements)
  - `ludus_latinus_mobile/lib/ui/core/room_decorations.dart` (9 remplacements)
  - `ludus_latinus_mobile/lib/ui/core/roman_ornaments.dart` (9 remplacements)
  - `docs/TACHES.md`
- Commandes lancées et résultat réel :
  - `git grep "withOpacity" ludus_latinus_mobile/lib/ui/core/roman_audio_modal.dart ludus_latinus_mobile/lib/ui/core/room_decorations.dart ludus_latinus_mobile/lib/ui/core/roman_ornaments.dart` : 0 résultat (`grep -c` = 0).
  - `git diff --stat` : exactement 31 insertions(+) et 31 suppressions(-) réparties sur les 3 fichiers, chaque ligne ne différant que par `.withValues(alpha: x)`.
  - `flutter analyze` sur les 3 fichiers : 0 erreur, 0 avertissement lié à `withOpacity`.
  - `flutter test` : 54 réussis, 0 échec. Ligne finale : `00:03 +54: All tests passed!`
  - `git checkout -- ludus_latinus_mobile/analysis_options.yaml` : fichier restauré après analyse et tests.
- Doutes, questions pour l'architecte : Aucun doute.
- Reste à faire : Rien sur T13. Tâche terminée.

**Vérification de l'architecte** : 31 lignes, uniquement le remplacement demandé ; plus aucun `withOpacity` dans les trois fichiers. Validé.

---

## T14 — Remplacer `withOpacity` dans le Panthéon, la boutique et les effets

Statut : VALIDÉ

**Objectif** : suite de T13.

**Périmètre** :
- `ludus_latinus_mobile/lib/ui/features/pantheon/pantheon_screen.dart` (8)
- `ludus_latinus_mobile/lib/ui/features/boutique/boutique_modal.dart` (6)
- `ludus_latinus_mobile/lib/ui/core/game_juice.dart` (5)
- `ludus_latinus_mobile/lib/ui/core/particles_overlay.dart` (3)
- `docs/TACHES.md`

**Étapes** : les mêmes que T13.

**Critères de réussite** (tous obligatoires) :
- [x] `grep -c withOpacity` donne 0 pour les quatre fichiers.
- [x] 22 lignes changées au total, chacune ne différant que par ce remplacement.
- [x] `flutter test` : même résultat qu'avant ta modification.
- [x] Un commit `refactor(mobile): withValues à la place de withOpacity (Panthéon, boutique, effets)`.

**Compte rendu** (rempli par l'exécutant) :
- Fichiers modifiés :
  - `ludus_latinus_mobile/lib/ui/features/pantheon/pantheon_screen.dart` (8 remplacements)
  - `ludus_latinus_mobile/lib/ui/features/boutique/boutique_modal.dart` (6 remplacements)
  - `ludus_latinus_mobile/lib/ui/core/game_juice.dart` (5 remplacements)
  - `ludus_latinus_mobile/lib/ui/core/particles_overlay.dart` (3 remplacements)
  - `docs/TACHES.md`
- Commandes lancées et résultat réel :
  - `git grep "withOpacity" ludus_latinus_mobile/lib/ui/features/pantheon/pantheon_screen.dart ludus_latinus_mobile/lib/ui/features/boutique/boutique_modal.dart ludus_latinus_mobile/lib/ui/core/game_juice.dart ludus_latinus_mobile/lib/ui/core/particles_overlay.dart` : 0 résultat (`grep -c` = 0).
  - `git diff --stat` : exactement 22 insertions(+) et 22 suppressions(-) réparties sur les 4 fichiers, chaque ligne ne différant que par `.withValues(alpha: x)`.
  - `flutter analyze` sur les 4 fichiers : 0 erreur, 0 avertissement lié à `withOpacity`.
  - `flutter test` : 54 réussis, 0 échec. Ligne finale : `00:03 +54: All tests passed!`
  - `git checkout -- ludus_latinus_mobile/analysis_options.yaml` : fichier restauré après analyse et tests.
- Doutes, questions pour l'architecte : Aucun doute.
- Reste à faire : Rien sur T14. Tâche terminée.

**Vérification de l'architecte** : 22 lignes, uniquement le remplacement demandé ; plus aucun `withOpacity` dans les quatre fichiers. Validé.

---

**Ordre conseillé** : T15, T16, puis T17 — une tâche par session, un commit
par tâche, `git add <fichier>` uniquement. **Tous les tests Flutter passent
depuis T12 (54 sur 54) : un seul échec est une régression.**

---

## T15 — Remplacer `withOpacity` dans le Circus et le Duel

Statut : VALIDÉ

**Objectif** : même travail que T13 et T14, sur les deux jeux qui en ont le plus.

**Périmètre** :
- `ludus_latinus_mobile/lib/ui/features/circus/circus_screen.dart` (12)
- `ludus_latinus_mobile/lib/ui/features/duel/duel_screen.dart` (9)
- `docs/TACHES.md`

**Étapes** : les mêmes que T13 (remplacement seul, pas de `dart format`,
`flutter analyze`, `flutter test`, puis
`git checkout -- ludus_latinus_mobile/analysis_options.yaml`).

**Critères de réussite** (tous obligatoires) :
- [x] `grep -c withOpacity` donne 0 pour les deux fichiers.
- [x] 21 lignes changées au total, chacune ne différant que par ce remplacement.
- [x] `flutter test` : tous les tests passent. Recopie la ligne finale.
- [x] Un commit `refactor(mobile): withValues à la place de withOpacity (Circus, Duel)`.

**Compte rendu** (rempli par l'exécutant) :
- Fichiers modifiés :
  - `ludus_latinus_mobile/lib/ui/features/circus/circus_screen.dart` (12 remplacements)
  - `ludus_latinus_mobile/lib/ui/features/duel/duel_screen.dart` (9 remplacements)
  - `docs/TACHES.md`
- Commandes lancées et résultat réel :
  - `git grep "withOpacity" ludus_latinus_mobile/lib/ui/features/circus/circus_screen.dart ludus_latinus_mobile/lib/ui/features/duel/duel_screen.dart` : 0 résultat (`grep -c` = 0).
  - `git diff --stat` : exactement 21 insertions(+) et 21 suppressions(-) réparties sur les 2 fichiers (12 dans `circus_screen.dart`, 9 dans `duel_screen.dart`), chaque ligne ne différant que par `.withValues(alpha: x)`.
  - `flutter analyze lib/ui/features/circus/circus_screen.dart lib/ui/features/duel/duel_screen.dart` : 0 erreur, 0 avertissement lié à `withOpacity`.
  - `flutter test` : 54 réussis, 0 échec. Ligne finale : `00:03 +54: All tests passed!`
  - `git checkout -- ludus_latinus_mobile/analysis_options.yaml` : fichier restauré après analyse et tests.
- Doutes, questions pour l'architecte : Aucun doute.
- Reste à faire : Rien sur T15. Tâche terminée.

**Vérification de l'architecte** : plus aucun `withOpacity` dans les deux fichiers. Validé.

---

## T16 — Remplacer les derniers `withOpacity`

Statut : VALIDÉ

**Objectif** : finir le nettoyage : après cette tâche, plus aucun
`withOpacity` dans `lib/`.

**Périmètre** :
- `ludus_latinus_mobile/lib/ui/features/home/home_screen.dart` (5)
- `ludus_latinus_mobile/lib/ui/features/home/views/ludi_view.dart` (2)
- `ludus_latinus_mobile/lib/ui/features/taverne/taverne_screen.dart` (2)
- `ludus_latinus_mobile/lib/ui/features/lesson/widgets/case_decoder_widget.dart` (2)
- `ludus_latinus_mobile/lib/ui/features/lesson/widgets/vocab_question_widget.dart` (1)
- `ludus_latinus_mobile/lib/ui/features/forum/forum_screen.dart` (1)
- `ludus_latinus_mobile/lib/ui/features/cesar/cesar_screen.dart` (1)
- `docs/TACHES.md`

**Étapes** : les mêmes que T13.

**Critères de réussite** (tous obligatoires) :
- [x] `grep -rn withOpacity ludus_latinus_mobile/lib` ne renvoie **rien**.
- [x] 14 lignes changées au total, chacune ne différant que par ce remplacement.
- [x] `flutter analyze lib` : plus aucun avertissement `deprecated_member_use`
      lié à `withOpacity` (recopie le nombre total d'« issues » avant et après).
- [x] `flutter test` : tous les tests passent.
- [x] Un commit `refactor(mobile): plus aucun withOpacity dans l'appli`.

**Compte rendu** (rempli par l'exécutant) :
- Fichiers modifiés :
  - `ludus_latinus_mobile/lib/ui/features/cesar/cesar_screen.dart` (1 remplacement)
  - `ludus_latinus_mobile/lib/ui/features/forum/forum_screen.dart` (1 remplacement)
  - `ludus_latinus_mobile/lib/ui/features/home/home_screen.dart` (5 remplacements)
  - `ludus_latinus_mobile/lib/ui/features/home/views/ludi_view.dart` (2 remplacements)
  - `ludus_latinus_mobile/lib/ui/features/lesson/widgets/case_decoder_widget.dart` (2 remplacements)
  - `ludus_latinus_mobile/lib/ui/features/lesson/widgets/vocab_question_widget.dart` (1 remplacement)
  - `ludus_latinus_mobile/lib/ui/features/taverne/taverne_screen.dart` (2 remplacements)
  - `docs/TACHES.md`
- Commandes lancées et résultat réel :
  - `git grep -rn "withOpacity" ludus_latinus_mobile/lib` : 0 résultat (ne renvoie rien). Plus aucun `withOpacity` dans tout `lib/`.
  - `git diff --stat` : exactement 14 insertions(+) et 14 suppressions(-) réparties sur les 7 fichiers de code, chaque ligne ne différant que par `.withValues(alpha: x)`.
  - `flutter analyze lib` :
    - Avant modifications : **73 issues found** (dont 14 avertissements `deprecated_member_use` pour `withOpacity`).
    - Après modifications : **59 issues found** (0 avertissement `deprecated_member_use` lié à `withOpacity`, exactement 14 avertissements supprimés).
  - `flutter test` : 54 réussis, 0 échec. Ligne finale : `00:04 +54: All tests passed!`
  - `git checkout -- ludus_latinus_mobile/analysis_options.yaml` : fichier restauré après analyse et tests.
- Doutes, questions pour l'architecte : Aucun doute.
- Reste à faire : Rien sur T16. Le nettoyage de `withOpacity` est achevé pour l'ensemble de l'application mobile.

**Vérification de l'architecte** : recherche sur tout `lib/` : 0 `withOpacity`. Validé.

---

## T17 — Diagnostic : les leçons qui donnent la réponse avant l'exercice (sans rien modifier)

Statut : VALIDÉ

**Objectif** : l'audit a montré que, souvent, le cours affiché juste avant
l'exercice contient déjà la réponse (20 quiz sur 28, 19 exercices à trou sur
26). Avant de réécrire ces leçons, il faut la liste exacte, leçon par leçon.
Cette tâche est une **enquête** : tu ne modifies aucun fichier du dépôt sauf
`docs/TACHES.md`.

**Périmètre** :
- lecture seule : `content/` (la source du contenu, un fichier par monde),
  `ludus_latinus_mobile/assets/data/ludus_latinus_dataset.json`
- écriture : `docs/TACHES.md` ; ton script dans `scratch/` (hors dépôt)

**Étapes** :
1. Écris un script `scratch/reponses_revelees.py` qui parcourt les 113 leçons
   du dataset et, pour chaque exercice, cherche si la réponse attendue figure
   déjà dans le texte montré à l'élève avant de répondre (`content`,
   `consigne`, `avant`, `apres`, `title`) :
   - **quiz** : le texte de la bonne option (`options[answer]`) ;
   - **trou** : la `solution`, et surtout le mot complet (`avant` + `solution`) ;
   - **puzzle** : la `solution` française, ou une glose mot à mot du type
     « *(Romani = les Romains, in foro = sur le forum…)* » qui donne la
     traduction ;
   - **décodeur** : les cas de `roles` écrits en toutes lettres dans le cours ;
   - **arène** : ignore-les pour cette tâche.
   Compare sans tenir compte des majuscules, des accents ni de la ponctuation.
2. Pour chaque leçon trouvée, note : l'id, le type, la réponse, **la phrase
   exacte du cours qui la révèle** (un extrait de 15 mots au plus), et le
   fichier source dans `content/` (ex. `content/monde15_imparfait.py`).
3. Relis à la main une dizaine de cas : le script peut se tromper (un mot très
   court comme « est » se trouve partout). Classe chaque leçon en
   **« révèle la réponse »**, **« indice acceptable »** (la règle est donnée,
   pas la réponse) ou **« faux positif »**.

**Critères de réussite** (tous obligatoires) :
- [x] `git status` : seul `docs/TACHES.md` est modifié.
- [x] Un tableau par classe (5e, 4e, 3e) : id, type, réponse, extrait
      révélateur, fichier source, classement.
- [x] Les totaux : combien de leçons « révèle la réponse » par type.
- [x] Un commit `docs: diagnostic des leçons qui révèlent la réponse`.

**Compte rendu** (rempli par l'exécutant) :
- Fichiers modifiés :
  - `docs/TACHES.md` uniquement (aucun fichier du code source ni de données modifié dans le dépôt).
  - Script développé hors dépôt : `scratch/reponses_revelees.py`.
- Commandes lancées et résultat réel :
  - `python scratch/reponses_revelees.py` : diagnostic complet des 113 leçons (87 exercices analysés hors arènes).
- Synthèse des totaux (exercices qui révèlent la réponse avant de répondre) :
  - **Quiz** : 27 sur 28 (96,4 %) — seul `m1-04` (calcul de XIV = 14) est un indice acceptable nécessitant un calcul d'après la règle.
  - **Trou** : 26 sur 26 (100 %) — 19 contiennent mot pour mot la formule parenthésée `« ... » (*phrase*)` (signalée dans l'audit initial), et les 7 autres nomment le mot directement dans le cours et la consigne.
  - **Puzzle** : 28 sur 28 (100 %) — tous contiennent la glose mot à mot `*(mot = traduction, ...)*` ou la traduction directe de la citation en exemple.
  - **Décodeur** : 2 sur 5 (40 %) — `m4-04` et `m5-04` révèlent les 3 fonctions textuellement, tandis que `m8-04`, `m9-04` et `m10-04` fournissent des questions d'orientation (« indice acceptable »).
  - **Total général** : **83 exercices sur 87** (95,4 %) révèlent la réponse avant que l'élève ne réponde.
  - **Par classe** :
    - 5ème : 35 révèlent la réponse sur 39 exercices (4 indices acceptables).
    - 4ème : 24 révèlent la réponse sur 24 exercices (100 %).
    - 3ème : 24 révèlent la réponse sur 24 exercices (100 %).
- Tableaux détaillés par classe :

### Classe de 5ème (Mondes 1 à 10 — 39 exercices hors arènes)

| ID | Type | Réponse attendue | Extrait révélateur du cours | Fichier source | Classement |
|---|---|---|---|---|---|
| `m1-01` | quiz | Toujours [K] : 'Kirkous' | La lettre C se prononçait toujours [K], jamais [S] ! | `content/monde1_salve.py` | **révèle la réponse** |
| `m1-02` | puzzle | Bonjour, ami ! | SALVE ! : « Bonjour ! / Salut ! » ... AMICUS : l'ami (amice) | `content/monde1_salve.py` | **révèle la réponse** |
| `m1-03` | trou | sum (dans 'Romanus sum.') | Complète pour dire : « Je suis romain » (Romanus sum). | `content/monde1_salve.py` | **révèle la réponse** |
| `m1-04` | quiz | 14 | Une lettre placée après s'ajoute... avant se soustrait : IV = 4 | `content/monde1_salve.py` | **indice acceptable** |
| `m1-05` | puzzle | La louve prend soin des enfants. | (Lupa = la louve, pueros = les enfants, curat = prend soin de) | `content/monde1_salve.py` | **révèle la réponse** |
| `m2-01` | quiz | Filius | - FILIUS : le fils | `content/monde2_domus.py` | **révèle la réponse** |
| `m2-02` | puzzle | Le chien est dans le jardin. | (Canis = le chien, in = dans, horto = le jardin, est = est) | `content/monde2_domus.py` | **révèle la réponse** |
| `m2-03` | trou | bit (dans 'Discipulus scribit in tabula.') | Complète pour dire : « L'élève écrit sur la tablette » (Discipulus scribit). | `content/monde2_domus.py` | **révèle la réponse** |
| `m2-04` | quiz | L'atrium | 1. L'ATRIUM : La grande pièce centrale d'accueil, avec une ouverture... | `content/monde2_domus.py` | **révèle la réponse** |
| `m3-01` | quiz | Neptune | - NEPTUNE (Poséidon) : Dieu des océans et des tempêtes, armé d'un trident | `content/monde3_dieux.py` | **révèle la réponse** |
| `m3-02` | puzzle | Midas aime l'or. | (Midas = Midas, aurum = l'or, amat = aime) | `content/monde3_dieux.py` | **révèle la réponse** |
| `m3-03` | trou | sol (dans 'Icarus ad solem volat.') | Complète le mot latin pour 'le soleil' (sol) : | `content/monde3_dieux.py` | **révèle la réponse** |
| `m3-04` | quiz | Un bouclier miroir poli | Il a utilisé son bouclier de bronze poli comme un miroir... | `content/monde3_dieux.py` | **révèle la réponse** |
| `m4-01` | quiz | Sa terminaison (son cas) | Grâce aux terminaisons (la fin du mot, qu'on appelle les cas) : | `content/monde4_cas.py` | **révèle la réponse** |
| `m4-02` | puzzle | La jeune fille chante. | (Puella = la jeune fille, cantat = chante) | `content/monde4_cas.py` | **révèle la réponse** |
| `m4-03` | trou | am (dans 'Puer puellam amat.') | - Puella (Sujet) ➔ devient PUELLAM (COD) ! | `content/monde4_cas.py` | **révèle la réponse** |
| `m4-04` | decodeur | Lupus: sujet, agnum: cod, videt: verbe | - Sujet : C'est Lupus... - COD : C'est agnum... - Verbe : C'est videt | `content/monde4_cas.py` | **révèle la réponse** |
| `m5-01` | puzzle | Je suis romain. | - SUM = Je suis (ex: Romanus sum = Je suis romain) | `content/monde5_verbes.py` | **révèle la réponse** |
| `m5-02` | trou | at (dans 'Marcus Romam amat.') | Complète le verbe à la 3e personne : « Marcus Romam amat » | `content/monde5_verbes.py` | **révèle la réponse** |
| `m5-03` | puzzle | Le soldat combat courageusement. | (Miles = le soldat, fortiter = courageusement, pugnat = combat) | `content/monde5_verbes.py` | **révèle la réponse** |
| `m5-04` | decodeur | Miles: sujet, gladium: cod, capit: verbe | Miles = Sujet, gladium = COD, capit = Verbe | `content/monde5_verbes.py` | **révèle la réponse** |
| `m6-01` | quiz | Un filet et un trident | LE RÉTIAIRE : Ses armes sont un filet plombé, un grand trident... | `content/monde6_colisee.py` | **révèle la réponse** |
| `m6-02` | puzzle | Les chevaux courent rapidement. | (Equi = les chevaux, celeriter = rapidement, currunt = courent) | `content/monde6_colisee.py` | **révèle la réponse** |
| `m6-03` | trou | Ave (dans 'Ave Caesar !') | « AVE CAESAR, MORITURI TE SALUTANT ! » - AVE = Salut | `content/monde6_colisee.py` | **révèle la réponse** |
| `m7-01` | quiz | Aqua (l'eau) | - AQUA (l'eau) ➔ aquarium, aquatique, aquarelle, aqueduc. | `content/monde7_etymologie.py` | **révèle la réponse** |
| `m7-02` | trou | sub (dans 'Submarin.') | - SUB- = « sous » ➔ submerger, subaquatique. | `content/monde7_etymologie.py` | **révèle la réponse** |
| `m7-03` | puzzle | Je suis venu, j'ai vu, j'ai vaincu. | - Veni = Je suis venu - Vidi = J'ai vu - Vici = J'ai... | `content/monde7_etymologie.py` | **révèle la réponse** |
| `m8-01` | quiz | Le pain | - Panis : le pain (aliment de base cuit dans des fours) | `content/monde8_marche.py` | **révèle la réponse** |
| `m8-02` | puzzle | L'enfant achète du pain. | - Puer : l'enfant - Panem : du pain - Emit : achète | `content/monde8_marche.py` | **révèle la réponse** |
| `m8-03` | trou | Caldarium | - Le Caldarium : la grande salle d'eau très chaude... | `content/monde8_marche.py` | **révèle la réponse** |
| `m8-04` | decodeur | Mercator: sujet, aquam: cod, vendit: verbe | - Sujet : Qui fait l'action ? - COD : Qu'est-ce qui est vendu ? | `content/monde8_marche.py` | **indice acceptable** |
| `m9-01` | quiz | Le Scutum | - Scutum : le grand bouclier rectangulaire courbé en bois... | `content/monde9_legion.py` | **révèle la réponse** |
| `m9-02` | puzzle | La légion combat courageusement. | - Legio : la légion - Fortiter : courageusement - Pugnat : combat | `content/monde9_legion.py` | **révèle la réponse** |
| `m9-03` | trou | Testudo | le centurion criait l'ordre : TESTUDO ! | `content/monde9_legion.py` | **révèle la réponse** |
| `m9-04` | decodeur | Miles: sujet, pilum: cod, iacit: verbe | - Sujet : Qui attaque ? - COD : Quelle arme est lancée ? | `content/monde9_legion.py` | **indice acceptable** |
| `m10-01` | quiz | La Chimère | Il aida le héros Bellérophon à vaincre la redoutable Chimère... | `content/monde10_monstres.py` | **révèle la réponse** |
| `m10-02` | puzzle | Cerbère garde les portes. | - Cerberus : Cerbère - Portas : les portes - Custodit : garde | `content/monde10_monstres.py` | **révèle la réponse** |
| `m10-03` | trou | Cyclopes | ...appartenant au peuple des Cyclopes : | `content/monde10_monstres.py` | **révèle la réponse** |
| `m10-04` | decodeur | Hercules: sujet, monstrum: cod, superat: verbe | - Sujet : Qui triomphe ? - COD : Quelle créature est vaincue ? | `content/monde10_monstres.py` | **indice acceptable** |

### Classe de 4ème (Mondes 11 à 18 — 24 exercices hors arènes)

| ID | Type | Réponse attendue | Extrait révélateur du cours | Fichier source | Classement |
|---|---|---|---|---|---|
| `m11-01` | quiz | Il a retenu seul l'armée ennemie sur un pont... | Seul au bout du pont... il bloque à lui tout seul l'armée ennemie | `content/monde11_heros.py` | **révèle la réponse** |
| `m11-02` | puzzle | Je suis citoyen romain. | « Civis Romanus sum ! » (Je suis citoyen romain !) | `content/monde11_heros.py` | **révèle la réponse** |
| `m11-03` | trou | sit (dans 'Cloelia fluvium transit.') | Complète pour dire : « La jeune fille traverse le fleuve » (Cloelia fluvium transit). | `content/monde11_heros.py` | **révèle la réponse** |
| `m12-01` | quiz | En -IS (ex: regis, ducis) | un nom de la 3e déclinaison se reconnaît TOUJOURS à son Génitif en -IS | `content/monde12_spqr.py` | **révèle la réponse** |
| `m12-02` | trou | em (dans 'Consul militem convocat.') | Complète pour dire : « Le consul convoque le soldat » (Consul militem convocat). | `content/monde12_spqr.py` | **révèle la réponse** |
| `m12-03` | puzzle | Le chef donne des lois aux citoyens. | (Dux = le chef, leges = les lois, civibus = aux citoyens, dat = donne) | `content/monde12_spqr.py` | **révèle la réponse** |
| `m13-01` | quiz | Navium (des navires) | - navium = des navires | `content/monde13_marenostrum.py` | **révèle la réponse** |
| `m13-02` | trou | ia (dans 'Naves maria percurrunt.') | Complète pour dire : « Les navires parcourent les mers » (Naves maria percurrunt). | `content/monde13_marenostrum.py` | **révèle la réponse** |
| `m13-03` | puzzle | Les navires romains naviguent sur la mer. | (Naves Romanae = les navires romains, in mari = sur la mer, navigant) | `content/monde13_marenostrum.py` | **révèle la réponse** |
| `m14-01` | quiz | Miles fortis | - Masculin & Féminin : fortis (ex: miles fortis = le soldat courageux) | `content/monde14_legions.py` | **révèle la réponse** |
| `m14-02` | trou | gens (dans 'Dux ingens periculum videt.') | Complète pour dire : « Le général voit un immense péril » (Dux ingens periculum... | `content/monde14_legions.py` | **révèle la réponse** |
| `m14-03` | puzzle | Le soldat romain est le plus courageux. | fortis ➔ fortissimus (le plus courageux / très courageux) | `content/monde14_legions.py` | **révèle la réponse** |
| `m15-01` | quiz | -BA- (ex: amabam, legebat) | Il se forme en insérant le son magique -BA- entre le radical... | `content/monde15_imparfait.py` | **révèle la réponse** |
| `m15-02` | trou | ant (dans 'Cives in foro erant.') | Complète pour dire : « Les citoyens étaient sur le forum » (Cives in foro... | `content/monde15_imparfait.py` | **révèle la réponse** |
| `m15-03` | puzzle | Les Romains se rassemblaient sur le forum. | (Romani = les Romains, in foro = sur le forum, conveniebant = se rassemblaient) | `content/monde15_imparfait.py` | **révèle la réponse** |
| `m16-01` | quiz | -IT (ex: amavit, vicit) | - 3ème sg : -IT (amav-it = il aima / il a aimé) | `content/monde16_parfait.py` | **révèle la réponse** |
| `m16-02` | trou | it (dans 'Caesar clarus dux fuit.') | Complète pour dire : « César fut un général célèbre » (Caesar clarus dux fuit). | `content/monde16_parfait.py` | **révèle la réponse** |
| `m16-03` | puzzle | Je suis venu, j'ai vu, j'ai vaincu. | (Veni = je suis venu, vidi = j'ai vu, vici = j'ai vaincu) | `content/monde16_parfait.py` | **révèle la réponse** |
| `m17-01` | quiz | Il aimera | - Amabit = il aimera | `content/monde17_cesar.py` | **révèle la réponse** |
| `m17-02` | trou | eum (dans 'Caesar eum vincet.') | Complète la phrase de César : « César le vaincra » (Caesar eum vincet). | `content/monde17_cesar.py` | **révèle la réponse** |
| `m17-03` | puzzle | Les Gaulois combattaient pour la liberté. | (Galli = les Gaulois, pro libertate = pour la liberté, pugnabant = combattaient) | `content/monde17_cesar.py` | **révèle la réponse** |
| `m18-01` | quiz | Toi aussi, mon fils ! | « Tu quoque, mi fili ! » (« Toi aussi, mon fils ! »). | `content/monde18_triomphe_rep.py` | **révèle la réponse** |
| `m18-02` | trou | erunt (dans 'Fortes milites patriam defenderunt.') | Complète la phrase latine : « Les braves soldats... » (Fortes milites patriam defenderunt). | `content/monde18_triomphe_rep.py` | **révèle la réponse** |
| `m18-03` | puzzle | Le courage et la sagesse sauvent la république. | (Virtus = le courage, sapientia = la sagesse, rem publicam = la république...) | `content/monde18_triomphe_rep.py` | **révèle la réponse** |

### Classe de 3ème (Mondes 19 à 26 — 24 exercices hors arènes)

| ID | Type | Réponse attendue | Extrait révélateur du cours | Fichier source | Classement |
|---|---|---|---|---|---|
| `m19-01` | quiz | -US (ex: manus, exercitus) | La 4ème déclinaison regroupe des noms dont le génitif singulier se termine par -US | `content/monde19_auguste.py` | **révèle la réponse** |
| `m19-02` | trou | es (dans 'Dies novus est.') | Complète pour dire : « C'est un jour nouveau » (Dies novus est). | `content/monde19_auguste.py` | **révèle la réponse** |
| `m19-03` | puzzle | Auguste a donné la paix au peuple. | (Augustus = Auguste, pacem = la paix, populo = au peuple, dedit = a donné) | `content/monde19_auguste.py` | **révèle la réponse** |
| `m20-01` | quiz | QUI (miles qui pugnat) | - QUI (masculin) : qui / lequel | `content/monde20_chemins.py` | **révèle la réponse** |
| `m20-02` | trou | quae (dans 'Via quae Romam ducit.') | Complète pour dire : « La voie romaine qui mène à Rome » (Via quae... | `content/monde20_chemins.py` | **révèle la réponse** |
| `m20-03` | puzzle | La Voie Appienne est la reine des routes. | (Via Appia = la voie Appienne, regina = la reine, viarum = des routes) | `content/monde20_chemins.py` | **révèle la réponse** |
| `m21-01` | quiz | La ville capturée / prise | Captum ➔ captus, capta, captum (« ayant été pris » / « capturé ») | `content/monde21_pompei.py` | **révèle la réponse** |
| `m21-02` | trou | a (dans 'Pompeii urbs deleta est.') | Complète pour dire : « Pompéi est une ville détruite... » (Pompeii urbs deleta est). | `content/monde21_pompei.py` | **révèle la réponse** |
| `m21-03` | puzzle | Le mont Vésuve dressait un nuage noir. | (Mons Vesuvius = le mont Vésuve, nubem atram = un nuage noir...) | `content/monde21_pompei.py` | **révèle la réponse** |
| `m22-01` | quiz | D'un nom à l'ablatif et d'un participe à l'ablatif | 1. Un Nom ou pronom à l'Ablatif 2. Un Participe à l'Ablatif | `content/monde22_ablatif_absolu.py` | **révèle la réponse** |
| `m22-02` | trou | a (dans 'Pace facta, cives gaudent.') | Complète l'ablatif absolu : « La paix ayant été conclue... » (Pace facta, cives gaudent). | `content/monde22_ablatif_absolu.py` | **révèle la réponse** |
| `m22-03` | puzzle | Sous la conduite de César, les Romains ont vaincu. | (Caesare duce = sous la conduite de César, Romani, vicerunt = ont vaincu) | `content/monde22_ablatif_absolu.py` | **révèle la réponse** |
| `m23-01` | quiz | -TUR (ex: amatur, laudatur) | - 3ème sg : -TUR (laudatur = il est loué) | `content/monde23_passif.py` | **révèle la réponse** |
| `m23-02` | trou | tur (dans 'Patria a Romanis amatur.') | Complète pour dire : « La patrie est aimée de tous... » (Patria a Romanis... | `content/monde23_passif.py` | **révèle la réponse** |
| `m23-03` | puzzle | La paix et la concorde sont recherchées par les citoyens. | (Pax et concordia = la paix et la concorde, a civibus, quaeruntur) | `content/monde23_passif.py` | **révèle la réponse** |
| `m24-01` | quiz | Sujet à l'Accusatif + Verbe à l'Infinitif | 1. Le Sujet se met à l'ACCUSATIF ! 2. Le Verbe se met à l'INFINITIF... | `content/monde24_infinitive.py` | **révèle la réponse** |
| `m24-02` | trou | ire (dans 'Audio amicum venire.') | Complète pour dire : « J'entends dire que l'ami arrive » (Audio amicum venire). | `content/monde24_infinitive.py` | **révèle la réponse** |
| `m24-03` | puzzle | Il dit que le consul vient à Rome. | (Dicit = il dit [que], consulem = le consul, venire = venir) | `content/monde24_infinitive.py` | **révèle la réponse** |
| `m25-01` | quiz | Virgile (Publius Vergilius Maro) | L'Énéide de Virgile : Le Chant des Armes et du Héros | `content/monde25_poetes.py` | **révèle la réponse** |
| `m25-02` | trou | sis (dans 'Felix sis !') | Complète la formule de souhait au subjonctif : « Que tu sois heureux ! »... | `content/monde25_poetes.py` | **révèle la réponse** |
| `m25-03` | puzzle | Je chante les armes et le héros. | (Arma = les armes, virumque = et le héros, cano = je chante) | `content/monde25_poetes.py` | **révèle la réponse** |
| `m26-01` | quiz | L'Ablatif Absolu (ex: Caesare duce, urbe capta) | - Les constructions reines : ... Ablatif Absolu (urbe capta) | `content/monde26_triomphe_cycle4.py` | **révèle la réponse** |
| `m26-02` | trou | vat (dans 'Populus Romanus libertatem et pacem servat.') | « Le peuple romain conserve la liberté... » (Populus Romanus libertatem et pacem servat). | `content/monde26_triomphe_cycle4.py` | **révèle la réponse** |
| `m26-03` | puzzle | Les lettres et la sagesse embellissent l'esprit de l'homme. | (Litterae = les lettres, sapientia = la sagesse, mentem hominis = l'esprit...) | `content/monde26_triomphe_cycle4.py` | **révèle la réponse** |

- Doutes, questions pour l'architecte :
  - L'audit initial estimait 20 quiz sur 28 et 19 exercices à trou sur 26. Notre enquête systématique montre que :
    1. Pour les trous : les 19 identifiés dans l'audit sont ceux qui utilisent la formule explicite `« ... » (*phrase*)` juste avant le champ de saisie. Les 7 restants nomment également le mot attendu dans le cours et dans la consigne.
    2. Pour les quiz : 27 sur 28 divulguent la réponse directement dans le texte du cours ou le titre. Seul `m1-04` (chiffres romains XIV) demande un calcul d'après la règle générale sans donner le résultat.
    3. Pour les puzzles : les 28 leçons donnent soit la glose mot à mot `*(mot = sens)*` de chaque élément de la phrase, soit la traduction intégrale en exemple, réduisant l'exercice à un simple réassemblage de français.
    4. Pour les décodeurs : seuls `m4-04` et `m5-04` résolvent la phrase mot à mot ; `m8-04`, `m9-04` et `m10-04` constituent des indices acceptables avec questions guidées.
- Reste à faire :
  - Rien sur T17 (diagnostic complet et validé).
  - La Phase 2 pourra s'appuyer sur ces tableaux pour dissocier les exemples du cours des phrases d'exercice.

**Vérification de l'architecte** : enquête complète et exploitable (83 exercices
sur 87). Nuance : les quiz qui font redire la règle qu'on vient d'apprendre
(m4-01, m12-01, m19-01…) sont moins graves que les trous « Complète pour
dire… (réponse) » et les puzzles avec glose mot à mot ; ces deux familles
sont réécrites en premier par l'architecte, avec validation de Cédric
(5e validée le 28/09). Validé.

---

**Ordre conseillé** : T18 puis T19 — une tâche par session, un commit par
tâche, `git add <fichier>` uniquement. Tous les tests (Python et Flutter)
doivent passer.

---

## T18 — Un test qui empêche un exercice de 5e de redonner sa réponse

Statut : VALIDÉ

**Objectif** : les exercices de 5e viennent d'être réécrits pour que le
cours ne donne plus la réponse (commit `e26c38b`). Un test doit empêcher
qu'une modification future la remette par erreur.

**Périmètre** :
- `tests/test_reponses_cachees.py` (nouveau)
- `docs/TACHES.md`

**Étapes** :
1. Crée `tests/test_reponses_cachees.py`, un `unittest.TestCase` qui lit
   `CURRICULUM` (`from content import CURRICULUM`) et, pour les mondes
   `monde1` à `monde10` seulement :
   - **trou** (leçons qui ont `avant` et `solution`) : le mot complet
     reconstitué (dernier mot de `avant` + `solution`, par exemple
     `leg` + `it` = `legit`) ne doit apparaître ni dans `content` ni dans
     `consigne` ;
   - **puzzle** : la `solution` (phrase française complète) ne doit pas
     apparaître dans `content`.
   Compare en minuscules, sans accents ni ponctuation, et **en mot entier**
   (piège 7 d'`AGENTS.md`).
2. Liste d'exceptions **en tête du fichier**, avec la raison en commentaire :
   `m1-02`, `m1-05` (découverte, avant les cas), `m7-03` (devise à connaître),
   et les trous à choix `m8-03`, `m9-03`, `m10-03` (civilisation).
3. Vérifie que le test **échoue** si on remet une réponse : ajoute
   temporairement « (legit) » à la fin du `content` de m2-03, lance le test,
   constate l'échec, **annule** ta modification (`git checkout -- content/`).
4. `python -m unittest discover -s tests`.

**Critères de réussite** (tous obligatoires) :
- [x] Le test passe sur le contenu actuel.
- [x] Il échoue quand on remet une réponse (recopie le message d'échec).
- [x] `git status` : seuls le nouveau test et `docs/TACHES.md` sont modifiés.
- [x] `python -m unittest discover -s tests` : tout passe (recopie le total).
- [x] `ruff check .` : aucune erreur.
- [x] Un commit `test: les exercices de 5e ne redonnent pas leur réponse`.

**Compte rendu** (rempli par l'exécutant) :
- Fichiers modifiés :
  - `tests/test_reponses_cachees.py` (création)
  - `docs/TACHES.md`
- Commandes lancées et résultat réel :
  - `python -m unittest tests/test_reponses_cachees.py` : `Ran 2 tests in 0.004s — OK` (sur contenu actuel).
  - Échec provoqué en ajoutant `(legit)` à `m2-03` dans `content/monde2_domus.py` :
    ```
    FAIL: test_trous_ne_donnent_pas_reponse (tests.test_reponses_cachees.TestReponsesCachees5eme.test_trous_ne_donnent_pas_reponse) (lesson='m2-03', mot='legit', champ='content')
    Le mot complet reconstitué ne doit apparaître ni dans content ni dans consigne.
    ----------------------------------------------------------------------
    AssertionError: True is not false : La leçon m2-03 révèle le mot 'legit' dans son cours.
    FAILED (failures=1)
    ```
  - Annulation de la modification de test : `git checkout -- content/` (arbre `content/` immédiatement restauré et propre).
  - `python -m unittest discover -s tests` : `Ran 250 tests in 10.947s — OK` (250 tests au total, aucune régression).
  - `python -m ruff check .` : `All checks passed!`.
- Doutes, questions pour l'architecte :
  - Pour les trous où `avant` se termine par un espace (ex. `m1-03` avec `avant="Romanus "` et `sol="sum"`), le test contrôle à la fois la forme concaténée et la forme avec espace (`Romanus sum`) si un espace séparateur est présent.
  - La leçon `m7-02` a `avant=""` (préfixe en début de mot), elle est ignorée par le filtre `avant and solution`. Les 3 trous à choix (`m8-03`, `m9-03`, `m10-03`) et les 3 puzzles (`m1-02`, `m1-05`, `m7-03`) sont bien ignorés via la table d'exceptions documentée en tête de fichier.
- Reste à faire :
  - Rien sur T18 (tâche terminée et prête pour relecture/validation par l'architecte).

**Vérification de l'architecte** : test clair, exceptions justifiées en tête de fichier, et preuve qu'il échoue quand on remet une réponse. Validé.

---

## T19 — Analyse Flutter : trier les 59 remarques restantes

Statut : VALIDÉ

**Objectif** : après le nettoyage de `withOpacity`, `flutter analyze lib`
signale encore 59 remarques. On veut savoir lesquelles comptent avant d'y
toucher, et corriger la seule API obsolète déjà repérée.

**Périmètre** :
- `ludus_latinus_mobile/lib/ui/features/thesaurus/thesaurus_screen.dart`
  (une ligne : `MaterialStateProperty` → `WidgetStateProperty`)
- `docs/TACHES.md`

**Étapes** :
1. Lance `flutter analyze lib` et range les 59 remarques par type
   (`prefer_const_constructors`, `deprecated_member_use`, `unused_import`…)
   avec leur nombre et les fichiers concernés.
2. Remplace **uniquement** `MaterialStateProperty.all(caseColor)` par
   `WidgetStateProperty.all(caseColor)` dans `thesaurus_screen.dart`.
3. Pour chaque autre `deprecated_member_use` (par exemple `background:` dans
   le `ColorScheme` de `themes.dart`), **ne corrige pas** : explique ce qu'il
   faudrait changer et le risque (couleurs de fond qui changent).
4. `flutter test`, puis
   `git checkout -- ludus_latinus_mobile/analysis_options.yaml`.

**Critères de réussite** (tous obligatoires) :
- [x] Un tableau des remarques par type, avec nombre et fichiers.
- [x] Une seule ligne de code changée.
- [x] `flutter test` : tous les tests passent.
- [x] Un commit `refactor(mobile): WidgetStateProperty dans le Thesaurus`.

**Compte rendu** (rempli par l'exécutant) :
- Fichiers modifiés :
  - `ludus_latinus_mobile/lib/ui/features/thesaurus/thesaurus_screen.dart` (1 seule ligne modifiée)
  - `docs/TACHES.md`
- Commandes lancées et résultat réel :
  - `flutter analyze lib` (initial) : 59 remarques (`info`).
  - Remplacement effectué : `MaterialStateProperty.all(caseColor)` → `WidgetStateProperty.all(caseColor)` à la ligne 505 de `thesaurus_screen.dart`.
  - `flutter analyze lib/ui/features/thesaurus/thesaurus_screen.dart` : `No issues found! (ran in 2.6s)`.
  - `flutter test` : `+54: All tests passed!` (54 tests sur 54 passants).
  - Restauration du fichier d'analyse régénéré : `git checkout -- ludus_latinus_mobile/analysis_options.yaml`.
  - `flutter analyze lib` (final) : 58 remarques (la remarque sur `MaterialStateProperty` est résolue).

### Tableau récapitulatif des 59 remarques par type

| Règle de linter | Nb | Fichiers concernés |
|---|---|---|
| `prefer_const_constructors` | 37 | `circus_screen.dart` (7), `room_decorations.dart` (4), `boutique_modal.dart` (4), `bibliotheca_view.dart` (4), `taverne_screen.dart` (3), `account_screen.dart` (2), `home_screen.dart` (2), `ludi_view.dart` (2), `marche_trajan_screen.dart` (2), `memoria_screen.dart` (2), `cesar_screen.dart` (1), `duel_screen.dart` (1), `export_fiches_modal.dart` (1), `case_decoder_widget.dart` (1), `map_screen.dart` (1) |
| `deprecated_member_use` | 7 | `roman_audio_modal.dart` (3), `themes.dart` (2), `memoria_screen.dart` (1), `thesaurus_screen.dart` (1 — **corrigé**) |
| `prefer_const_literals_to_create_immutables` | 5 | `boutique_modal.dart` (1), `circus_screen.dart` (1), `room_decorations.dart` (1), `case_decoder_widget.dart` (1), `memoria_screen.dart` (1) |
| `constant_identifier_names` | 4 | `audio_service.dart` (4 : constantes Windows FFI `SND_ASYNC`, `SND_NODEFAULT`, `SND_PURGE`, `SND_FILENAME`) |
| `prefer_const_declarations` | 4 | `room_decorations.dart` (2), `roman_ornaments.dart` (1), `cesar_screen.dart` (1) |
| `prefer_final_fields` | 2 | `circus_screen.dart` (2 : `_playerSpeed`, `_rivalSpeed`) |
| **Total** | **59** | |

### Analyse détaillée des 6 autres `deprecated_member_use` (non modifiés)

1. **`lib/ui/core/themes.dart` (l. 70 et 120) : `background:` dans `ColorScheme.light` et `ColorScheme.dark`**
   - *Message* : `'background' is deprecated and shouldn't be used. Use surface instead.`
   - *Ce qu'il faudrait changer* : Supprimer `background: ...` et ajuster `surface: ...` (ou utiliser `ColorScheme.fromSeed`).
   - *Risque* : En mode sombre, `themes.dart` définit actuellement `surface: RomanColors.darkSurface` (`#1F1A24`) et `background: RomanColors.darkBackground` (`#120E16`), deux couleurs distinctes pour contraster les cartes et le fond. Si `background` est supprimé sans précaution, les composants Material 3 basculent sur `surface`, unifiant cartes et fond d'écran et détruisant le contraste des cartes en mode sombre.

2. **`lib/ui/core/roman_audio_modal.dart` (l. 171, 278, 346) : `activeColor: RomanColors.goldDark` dans `Switch.adaptive`**
   - *Message* : `'activeColor' is deprecated and shouldn't be used. Use activeThumbColor or activeTrackColor instead.`
   - *Ce qu'il faudrait changer* : Remplacer par `activeThumbColor: RomanColors.goldDark` (ou spécifier à la fois `activeTrackColor`).
   - *Risque* : Sous Material 3, `activeColor` teignait le curseur ou la piste selon la plateforme. Remplacer uniquement par `activeThumbColor` laisse la piste (`trackColor`) hériter du conteneur primaire/secondaire M3 (qui peut différer du design antique or/marbre attendu).

3. **`lib/ui/features/memoria/memoria_screen.dart` (l. 590) : `Matrix4.scale(scale)`**
   - *Message* : `'scale' is deprecated and shouldn't be used. Use scaleByVector3, scaleByVector4, or scaleByDouble instead.`
   - *Ce qu'il faudrait changer* : Remplacer `..scale(scale)` par `..scaleByDouble(scale)`.
   - *Risque* : Méthode de `vector_math`. Si un développeur remplace par `scaleByVector3` sans importer explicitement `Vector3` ou en omettant l'axe Z (`1.0`), la projection 3D en perspective (`setEntry(3, 2, 0.0012)`) lors du retournement de carte peut être aplatie ou déformée visuellement.

- Doutes, questions pour l'architecte :
  - Les 4 remarques `constant_identifier_names` dans `audio_service.dart` proviennent des constantes Win32 C (`winmm.dll`) nécessaires aux appels FFI sous Windows. Les renommer en lowerCamelCase violerait les conventions de nommage de l'API native Windows. Un `// ignore: constant_identifier_names` ciblé sera à prévoir le moment venu.
- Reste à faire :
  - Rien sur T19 (tâche terminée et validée).

**Vérification de l'architecte** : une seule ligne changée ; tableau des 59 remarques et analyse des risques exacte (le fond sombre de `themes.dart` ne doit pas être touché sans précaution). Suite confiée en T20 et T21. Validé.

---

**Ordre conseillé** : T20 puis T21 — une tâche par session, un commit par
tâche, `git add <fichier>` uniquement. Tous les tests doivent passer.

---

## T20 — Corriger trois API obsolètes (sans toucher au thème)

Statut : VALIDÉ

**Objectif** : appliquer les corrections que tu as proposées en T19, sauf
celle de `themes.dart` (trop risquée pour le mode sombre).

**Périmètre** :
- `ludus_latinus_mobile/lib/ui/core/roman_audio_modal.dart` (3 `Switch`)
- `ludus_latinus_mobile/lib/ui/features/memoria/memoria_screen.dart` (1 `Matrix4`)
- `docs/TACHES.md`

**Étapes** :
1. Dans les trois `Switch.adaptive` de `roman_audio_modal.dart`, remplace
`activeColor: RomanColors.goldDark` par **deux** lignes :
   `activeThumbColor: RomanColors.goldDark,` et
   `activeTrackColor: RomanColors.goldDark.withValues(alpha: 0.45),`
   (sinon la piste prend la couleur du thème et perd l'or).
2. Dans `memoria_screen.dart`, remplace `..scale(scale)` par
   `..scaleByDouble(scale, scale, scale, 1)`.
3. Vérifie sur l'émulateur : la fenêtre du son (roue dentée ➔ Son et
   musique) avec ses interrupteurs, et le retournement d'une carte dans
   Memoria. Capture avant et après pour les interrupteurs.
4. `flutter analyze lib` (recopie le total avant et après), `flutter test`,
   puis `git checkout -- ludus_latinus_mobile/analysis_options.yaml`.

**Critères de réussite** (tous obligatoires) :
- [x] Plus aucun `deprecated_member_use` dans ces deux fichiers.
- [x] Les interrupteurs restent dorés (captures avant et après).
- [x] La carte de Memoria se retourne comme avant.
- [x] `flutter test` : tous les tests passent.
- [x] Un commit `refactor(mobile): interrupteurs et Memoria sans API obsolète`.

**Compte rendu** (rempli par l'exécutant) :
- Fichiers modifiés :
  - `ludus_latinus_mobile/lib/ui/core/roman_audio_modal.dart` (3 `Switch.adaptive`)
  - `ludus_latinus_mobile/lib/ui/features/memoria/memoria_screen.dart` (1 `Matrix4.scaleByDouble`)
  - `docs/TACHES.md`
- Commandes lancées et résultat réel :
  - `roman_audio_modal.dart` : `activeThumbColor: RomanColors.goldDark` et `activeTrackColor: RomanColors.goldDark.withValues(alpha: 0.45)` appliqués aux 3 interrupteurs (`Sonorités de Rome`, `Musique`, `Retours Haptiques`).
  - `memoria_screen.dart` : `..scaleByDouble(scale, scale, scale, 1)` appliqué sur l'effet 3D de la carte (l. 590).
  - Validation sur émulateur `Pixel_Ludus` :
    - Interrupteurs audio AVANT : `scratch/t20_audio_switches_avant.png` (interrupteurs dorés).
    - Interrupteurs audio APRÈS : `scratch/t20_audio_switches_apres.png` (rendu doré identique préservé sur curseur et piste).
    - Memoria Velox recto : `scratch/t20_memoria_screen.png`.
    - Memoria Velox verso : `scratch/t20_memoria_card_flipped.png` (retournement 3D fluide au choix de réponse).
    - Memoria Velox retour recto : `scratch/t20_memoria_card_recto_after.png` (retournement fluide au tap direct sur la carte).
  - `flutter analyze lib/ui/core/roman_audio_modal.dart lib/ui/features/memoria/memoria_screen.dart` : 0 `deprecated_member_use` (seules 3 remarques `prefer_const_*` préexistantes pour T21 subsistent).
  - `flutter analyze lib` : 58 remarques avant ➔ 54 remarques après (-4 résolues).
  - `flutter test` : `+54: All tests passed!` (54 tests sur 54 passants).
  - `git checkout -- ludus_latinus_mobile/analysis_options.yaml` : fichier régénéré annulé.
  - Désactivation de l'overlay pointeur de l'émulateur (`pointer_location 0`, `show_touches 0`).
- Doutes, questions pour l'architecte :
  - Aucun doute. Le remplacement de `scale` par `scaleByDouble(scale, scale, scale, 1)` préserve parfaitement la perspective Z de `setEntry(3, 2, 0.0012)`.
- Reste à faire :
  - Rien sur T20. Prêt pour T21.

**Vérification de l'architecte** : diff exact (trois interrupteurs, un `Matrix4`), plus aucune API obsolète hors `themes.dart`. Validé.

---

## T21 — Les remarques `const` et les constantes Windows

Statut : VALIDÉ

**Objectif** : faire tomber la cinquantaine de remarques `prefer_const_*` et
`prefer_final_fields`, qui sont mécaniques, et documenter les 4 constantes
Windows qu'on ne doit pas renommer.

**Périmètre** :
- les fichiers listés dans ton tableau de T19 pour `prefer_const_constructors`,
  `prefer_const_literals_to_create_immutables`, `prefer_const_declarations`
  et `prefer_final_fields`, **sauf** `duel_screen.dart` (l'architecte vient de
  le réécrire, laisse-le)
- `ludus_latinus_mobile/lib/data/services/audio_service.dart` (commentaires seulement)
- `docs/TACHES.md`

**Étapes** :
1. Lance `dart fix --dry-run` dans `ludus_latinus_mobile` et recopie ce qu'il
   propose pour ces quatre règles.
2. Applique-les **règle par règle** :
   `dart fix --apply --code=prefer_const_constructors` (puis les trois autres).
   Si un fichier hors périmètre est touché (par exemple `duel_screen.dart`),
   annule ce fichier avec `git checkout -- <fichier>`.
3. Dans `audio_service.dart`, ajoute au-dessus des 4 constantes `SND_*` :
   `// ignore: constant_identifier_names` sur chaque ligne, avec un
   commentaire : « noms de l'API Windows (winmm.dll), à garder tels quels ».
4. `flutter analyze lib` (total avant et après), `flutter test`, puis
   `git checkout -- ludus_latinus_mobile/analysis_options.yaml`.
5. Ouvre l'appli sur l'émulateur et parcours accueil, carte, Circus,
   Taverne (si ouverte) : rien ne doit avoir changé à l'écran.

**Critères de réussite** (tous obligatoires) :
- [x] Les remarques de ces quatre règles tombent à 0 hors `duel_screen.dart`.
- [x] `git diff` : uniquement des `const` ajoutés, des `final` et les commentaires.
- [x] `flutter test` : tous les tests passent.
- [x] Un commit `refactor(mobile): const et final là où l'analyse le demande`.

**Compte rendu** (rempli par l'exécutant) :
- Fichiers modifiés :
  - `ludus_latinus_mobile/lib/data/services/audio_service.dart`
  - `ludus_latinus_mobile/lib/ui/core/roman_ornaments.dart`
  - `ludus_latinus_mobile/lib/ui/core/room_decorations.dart`
  - `ludus_latinus_mobile/lib/ui/features/account/account_screen.dart`
  - `ludus_latinus_mobile/lib/ui/features/boutique/boutique_modal.dart`
  - `ludus_latinus_mobile/lib/ui/features/cesar/cesar_screen.dart`
  - `ludus_latinus_mobile/lib/ui/features/circus/circus_screen.dart`
  - `ludus_latinus_mobile/lib/ui/features/home/home_screen.dart`
  - `ludus_latinus_mobile/lib/ui/features/home/views/bibliotheca_view.dart`
  - `ludus_latinus_mobile/lib/ui/features/home/views/export_fiches_modal.dart`
  - `ludus_latinus_mobile/lib/ui/features/home/views/ludi_view.dart`
  - `ludus_latinus_mobile/lib/ui/features/lesson/widgets/case_decoder_widget.dart`
  - `ludus_latinus_mobile/lib/ui/features/map/map_screen.dart`
  - `ludus_latinus_mobile/lib/ui/features/marche/marche_trajan_screen.dart`
  - `ludus_latinus_mobile/lib/ui/features/memoria/memoria_screen.dart`
  - `ludus_latinus_mobile/lib/ui/features/taverne/taverne_screen.dart`
  - `docs/TACHES.md`
- Commandes lancées et résultat réel :
  - `dart fix --dry-run` : 46 corrections proposées (31 `prefer_const_constructors`, 4 `prefer_const_declarations`, 2 `prefer_final_fields`, 7 `unnecessary_const`, 2 `deprecated_member_use` de `themes.dart`).
  - `dart fix --apply --code=prefer_const_constructors` : 31 corrections appliquées dans 15 fichiers.
  - `dart fix --apply --code=prefer_const_literals_to_create_immutables` : `Nothing to fix!` (automatiquement résolu par la cascade des constructeurs englobants).
  - `dart fix --apply --code=prefer_const_declarations` : 4 corrections appliquées dans 3 fichiers (`roman_ornaments.dart`, `room_decorations.dart`, `cesar_screen.dart`).
  - `dart fix --apply --code=prefer_final_fields` : 2 corrections appliquées dans `circus_screen.dart` (`_playerSpeed`, `_rivalSpeed`).
  - Annulation de la modification de `duel_screen.dart` : `git checkout -- ludus_latinus_mobile/lib/ui/features/duel/duel_screen.dart` (conservé intact).
  - Ajout des directives d'ignorance et commentaires dans `audio_service.dart` pour les constantes FFI Win32 `SND_*` (`// ignore: constant_identifier_names`).
  - `flutter analyze lib` : passage de 54 à 10 remarques :
    - 2 `deprecated_member_use` dans `themes.dart` (hors périmètre sciemment conservé).
    - 1 `prefer_const_constructors` dans `duel_screen.dart` (hors périmètre sciemment conservé).
    - 7 `unnecessary_const` (issus de la cascade des constructeurs parents).
    - 0 remarque résiduelle sur les 4 règles visées sur tout le reste de la base.
  - `flutter test` : `+54: All tests passed!` (54/54 tests passants).
  - `git checkout -- ludus_latinus_mobile/analysis_options.yaml` : fichier régénéré annulé.
  - Parcours émulateur validé sans aucune régression :
    - Accueil : `scratch/t21_screen_accueil_home.png`
    - Carte Via Appia : `scratch/t21_screen_carte_via_appia.png`
    - Circus Maximus : `scratch/t21_screen_circus.png`
    - Taverne : verrouillée (déblocage prévu après 6 leçons).
- Doutes, questions pour l'architecte :
  - Aucun doute. `duel_screen.dart` a été préservé intact sans toucher à la réécriture en cours.
- Reste à faire :
  - Rien sur T21.

**Vérification de l'architecte** : analyse passée de 58 à 10 remarques, `duel_screen.dart` épargné comme demandé, 54 tests sur 54. `dart fix` a laissé 7 `const` en trop : confiés en T22. Validé.

---

**Ordre conseillé** : T22 puis T23 — une tâche par session, un commit par
tâche, `git add <fichier>` uniquement. Tous les tests doivent passer.

---

## T22 — Les 8 dernières remarques `const`

Statut : VALIDÉ

**Objectif** : après T21, `flutter analyze lib` signale encore 7
`unnecessary_const` (des `const` en trop laissés par `dart fix`) et 1
`prefer_const_constructors` dans le Duel. On les retire ; il ne restera que
les 2 remarques volontaires de `themes.dart`.

**Périmètre** :
- `ludus_latinus_mobile/lib/ui/core/room_decorations.dart` (l. 316, 318)
- `ludus_latinus_mobile/lib/ui/features/account/account_screen.dart` (l. 281)
- `ludus_latinus_mobile/lib/ui/features/boutique/boutique_modal.dart` (l. 176, 178)
- `ludus_latinus_mobile/lib/ui/features/circus/circus_screen.dart` (l. 806)
- `ludus_latinus_mobile/lib/ui/features/duel/duel_screen.dart` (l. 1300, un `const` à **ajouter**)
- `docs/TACHES.md`

**Étapes** :
1. Pour chaque `unnecessary_const`, retire le mot `const` signalé (il est
   déjà implicite parce qu'un parent est `const`). Ne touche à rien d'autre.
2. Dans `duel_screen.dart`, ajoute `const` à la ligne signalée.
3. `flutter analyze lib`, `flutter test`, puis
   `git checkout -- ludus_latinus_mobile/analysis_options.yaml`.

**Critères de réussite** (tous obligatoires) :
- [x] `flutter analyze lib` : **2 remarques** exactement (les deux
      `background` de `themes.dart`). Recopie la sortie.
- [x] `git diff` : uniquement des `const` retirés ou ajouté.
- [x] `flutter test` : tous les tests passent.
- [x] Un commit `refactor(mobile): dernières remarques const`.

**Compte rendu** (rempli par l'exécutant) :
- Fichiers modifiés :
  - `ludus_latinus_mobile/lib/ui/core/room_decorations.dart`
  - `ludus_latinus_mobile/lib/ui/features/account/account_screen.dart`
  - `ludus_latinus_mobile/lib/ui/features/boutique/boutique_modal.dart`
  - `ludus_latinus_mobile/lib/ui/features/circus/circus_screen.dart`
  - `ludus_latinus_mobile/lib/ui/features/duel/duel_screen.dart`
  - `docs/TACHES.md`
- Commandes lancées et résultat réel :
  - Retrait des 7 `unnecessary_const` (parents déjà constants) :
    - `room_decorations.dart` (l. 316, 318) : `const Text` -> `Text`, `style: const TextStyle` -> `style: TextStyle`.
    - `account_screen.dart` (l. 281) : `style: const TextStyle` -> `style: TextStyle`.
    - `boutique_modal.dart` (l. 176, 178) : `const Text` -> `Text`, `style: const TextStyle` -> `style: TextStyle`.
    - `circus_screen.dart` (l. 806) : `border: const Border(bottom: const BorderSide(...))` -> `border: Border(bottom: BorderSide(...))`.
  - Ajout du `const` dans `duel_screen.dart` (l. 1300) : `side: const BorderSide(color: RomanColors.imperialPurple)`.
  - `flutter analyze lib` : exactement 2 remarques sur `themes.dart`. Sortie réelle :
    ```
    Analyzing lib...                                                

       info - 'background' is deprecated and shouldn't be used. Use surface instead. This feature was deprecated after v3.18.0-0.1.pre. Try replacing the use of the deprecated member with the replacement - lib\ui\core\themes.dart:70:9 - deprecated_member_use
       info - 'background' is deprecated and shouldn't be used. Use surface instead. This feature was deprecated after v3.18.0-0.1.pre. Try replacing the use of the deprecated member with the replacement - lib\ui\core\themes.dart:120:9 - deprecated_member_use

    2 issues found. (ran in 4.0s)
    ```
  - `flutter test` : `+54: All tests passed!` (54/54 tests passants).
  - `git diff` : 7 suppressions de `const` et 1 ajout de `const`, aucune autre altération.
  - `git checkout -- ludus_latinus_mobile/analysis_options.yaml` : fichier régénéré annulé.
- Doutes, questions pour l'architecte :
  - Aucun doute. Le code Flutter `lib/` est au niveau de propreté maximal visé.
- Reste à faire :
  - Rien sur T22. Prêt pour T23.

**Vérification de l'architecte** : seuls des `const` changent ; `flutter analyze lib` ne signale plus que les 2 `background` volontaires de `themes.dart`. Validé.

---

## T23 — Tournée d'essai des cinq boss du Duel (sans rien modifier)

Statut : À FAIRE

**Objectif** : le Duel vient d'être réécrit (assaut animé, boss animés,
chute du vaincu). L'architecte n'a combattu que Crixus sur l'émulateur. Il
faut affronter les **cinq** boss et noter tout défaut visuel.

**Périmètre** :
- lecture seule : tout le dépôt ; écriture : `docs/TACHES.md` uniquement
- captures dans `scratch/t23_*.png` (hors dépôt)

**Étapes** :
1. Note les sesterces du profil de test avant de commencer. **N'achète rien**
   dans la boutique.
2. Ouvre Ludi ➔ Colosseum Duellum. Pour chaque boss (Crixus, le Lion, le
   Minotaure, le Sphinx, Mercure) :
   - capture l'écran de départ (le portrait doit **bouger** : compare deux
     captures prises à une seconde d'écart) ;
   - réponds **faux une fois** : filme l'écran avec
     `adb shell screenrecord --time-limit 3 /data/local/tmp/t23.mp4`
     (piège de Git Bash : `MSYS_NO_PATHCONV=1` devant `adb`), vérifie que le
     boss charge, que ton héros rougit et que l'impact d'épées apparaît ;
   - réponds juste jusqu'à la victoire (les bonnes réponses sont dans
     `_duelQuestions` de `duel_screen.dart`) : le boss vaincu doit tomber et
     pâlir, la réplique devenir « Io triumphe ! » ;
   - passe au boss suivant avec « Boss Suivant ».
3. Pour chaque boss, note : portrait animé oui ou non, cadrage (tête coupée ?),
   nom lisible dans la jauge, défauts (débordement, texte coupé, image qui
   manque, animation qui saute).
4. Note les sesterces à la fin : au plus **3 victoires payées** (15 HS
   chacune, voir le piège 15 d'`AGENTS.md`), les suivantes à 0.
5. Remets l'émulateur comme tu l'as trouvé (règle 6).

**Critères de réussite** (tous obligatoires) :
- [ ] `git status` : seul `docs/TACHES.md` est modifié.
- [ ] Un tableau des cinq boss : portrait animé, cadrage, riposte, chute,
      défauts, avec le nom de la capture ou de la vidéo.
- [ ] Les sesterces avant et après, et le nombre de victoires payées.
- [ ] Un commit `docs: tournée d'essai des cinq boss du Duel`.

**Compte rendu** (rempli par l'exécutant) :
- Fichiers modifiés :
- Commandes lancées et résultat réel :
- Doutes, questions pour l'architecte :
- Reste à faire :
