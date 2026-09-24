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

Statut : FAIT

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

---

## T3 — Jouer la vidéo d'intro à chaque démarrage

Statut : FAIT

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
