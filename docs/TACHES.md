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

Statut : À FAIRE

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
- [ ] `flutter analyze` sur le fichier : aucune erreur.
- [ ] `grep -n "estBonChoix: false" -A1` ne montre plus aucun `sestercesGain` non nul.
- [ ] Sur l'émulateur, Marché de Trajan, négociation : choisir une option
      fausse ne change pas le solde de sesterces (capture avant / après).
- [ ] Une bonne option rapporte toujours ses sesterces.
- [ ] Affichage du pointeur éteint.
- [ ] Un commit `fix(mobile): le Marché ne paie plus les mauvaises réponses`.

Note : le Marché se déverrouille après 18 leçons. Si le profil de
l'émulateur n'en a pas assez, écris-le dans le compte rendu et vérifie
seulement par la lecture du code : **ne modifie pas la progression** pour
contourner le verrou.

**Compte rendu** :
- Fichiers modifiés :
- Commandes lancées et résultat réel :
- Doutes, questions pour l'architecte :
- Reste à faire :

---

## T7 — Diagnostic des 3 tests Flutter en échec (sans rien modifier)

Statut : À FAIRE

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
- [ ] `git status` : seul `docs/TACHES.md` est modifié.
- [ ] Pour chacun des 3 tests : cause, fautif (test ou code), correction proposée.
- [ ] Les sorties phonétiques de « Veni vidi vici », « Caesar », « Cicero ».
- [ ] Un commit `docs: diagnostic des 3 tests Flutter en échec`.

**Compte rendu** :
- Fichiers modifiés :
- Commandes lancées et résultat réel :
- Diagnostic test 1 :
- Diagnostic test 2 :
- Diagnostic test 3 et prononciation :
- Doutes, questions pour l'architecte :

---

## T8 — Remplacer `withOpacity` dans le lecteur de cinématiques et la leçon

Statut : À FAIRE

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
- [ ] `grep -c "withOpacity"` vaut `0` sur les deux fichiers.
- [ ] `flutter analyze` sur les deux fichiers : aucune erreur, plus aucun
      `deprecated_member_use`.
- [ ] `flutter test` : 39 réussis et les 3 échecs connus.
- [ ] Sur l'émulateur : l'intro (bouton « Passer ») et une leçon
      s'affichent comme avant (captures, pointeur éteint).
- [ ] Un commit `refactor(mobile): withValues à la place de withOpacity (cinématiques, leçon)`.

**Compte rendu** :
- Fichiers modifiés :
- Commandes lancées et résultat réel :
- Doutes, questions pour l'architecte :
- Reste à faire :

**Ordre conseillé** : T5, T6, T7, T8, puis T9 et T10 — une tâche par session, un commit par tâche.

---

## T9 — Remplacer `withOpacity` dans quatre écrans de révision

Statut : À FAIRE

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
- [ ] `grep -c "withOpacity"` vaut `0` sur les quatre fichiers.
- [ ] `flutter analyze` sur les quatre fichiers : aucune erreur, plus aucun
      `deprecated_member_use` lié à `withOpacity`.
- [ ] `flutter test` : 39 réussis et les 3 échecs connus.
- [ ] Sur l'émulateur, captures (pointeur éteint) de : Bibliotheca, Memoria
      (une carte avec ses 4 réponses), Thesaurus, et la bulle de Lupulus de
      l'accueil — rendu identique à avant.
- [ ] Un commit `refactor(mobile): withValues à la place de withOpacity (révisions)`.

**Compte rendu** :
- Fichiers modifiés :
- Commandes lancées et résultat réel :
- Doutes, questions pour l'architecte :
- Reste à faire :

---

## T10 — Diagnostic : quels mots manquent au Thesaurus ? (sans rien modifier)

Statut : À FAIRE

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
- [ ] `git status` : seul `docs/TACHES.md` est modifié.
- [ ] Un tableau par monde (1 à 26) : mots absents du Thesaurus, puis
      « probablement connus ».
- [ ] La liste des 16 mots sans monde, avec leur catégorie.
- [ ] Le chemin du script dans `scratch/`, pour que l'architecte puisse le relancer.
- [ ] Un commit `docs: diagnostic des mots manquants au Thesaurus`.

**Compte rendu** :
- Fichiers modifiés :
- Commandes lancées et résultat réel :
- Mots manquants par monde :
- Mots du Thesaurus sans monde :
- Doutes, questions pour l'architecte :
