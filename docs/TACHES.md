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

Statut : FAIT

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
