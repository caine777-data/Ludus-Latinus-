# Tournée T54 : la question de grammaire des leçons

Tournée à l'écran sur l'émulateur Android (Pixel_Ludus, 1080x2400). APK debug reconstruit pour l'occasion et installé par-dessus l'ancien (les données du profil sont restées en place). Aucun fichier de code ni de données modifié. Les textes cités ci-dessous sont recopiés depuis des captures lues avec l'outil Read, toutes présentes dans `scratch/` (liste en fin de fichier).

## Méthode et réserves

- Profil d'origine sauvegardé dans `scratch/t54_profil_avant.json`. Profil de test (`scratch/t54_profil_test.json`) : 40 leçons terminées à 3 étoiles (tout ce qui précède `m9-04` dans les mondes 1 à 10, sauf `m4-01` et `m8-03`, laissées à faire), 100 HS. Conséquence : à la fin de `m4-01` et de `m8-03`, l'appli affiche « MONDE TERMINÉ ! » (le monde est complet dans mon profil de test), ce qui n'arrive pas en jeu normal.
- Les trois leçons ont été jouées de bout en bout. Pour chacune : exercice principal juste, une mauvaise réponse de grammaire exprès (deux pour `m4-01`), puis la bonne.
- Réserve d'honnêteté : sur `m4-01`, j'ai d'abord enchaîné les appuis sans lire les captures intermédiaires (l'outil de lecture d'image a refusé les premières). Je les ai relues ensuite : les textes de `m4-01` ci-dessous viennent bien de captures lues. En revanche je n'ai pas lu les captures des questions de vocabulaire 4 et 5 de `m4-01` (`t54_m4-01_vocab4*.png`), je ne peux donc pas dire si une erreur de vocabulaire a eu lieu ; je n'ai lu que la question 5 (« lupa », bonne réponse « la louve », vue en vert sur `t54_m4-01_vocab5_suite.png`).
- Ordre des options à l'écran : mélangé. Les options ont été retrouvées par leur texte.

## Données attendues (champ `grammaire` du jeu de données)

| Leçon | Type | Question attendue | Bonne réponse |
|---|---|---|---|
| `m4-01` | QCM | Que veut dire « Lupum agnus videt. » ? (videt = voit) | L'agneau voit le loup. |
| `m8-03` | trou | Comment dit-on « le bouclier de l'ami » ? (scutum = le bouclier) | Scutum amici. |
| `m9-04` | décodeur | Dans « Lupos agricolae vident. » (agricola = le paysan), quel mot est le sujet ? | Agricolae |

## 1. Leçon `m4-01` (QCM)

| Étape | Capture | Conforme | Observation |
|---|---|---|---|
| Exercice principal (1/5) | `t54_m4-01_exo.png` | Oui | « EXERCICE 1 / 5 », « En latin, qu'est-ce qui indique le rôle d'un mot dans la phrase ? », options La ponctuation, Sa place dans la phrase, Sa première lettre, Sa terminaison. Bonne réponse : « Sa terminaison ». |
| Arrivée de la carte de grammaire | `t54_m4-01_grammaire.png` (copie `t54_m4-01_fin_principal.png`) | Oui | Dès la bonne réponse, la carte « Exercice de grammaire » s'affiche sous la leçon, sans écran intermédiaire. Repère : « EXERCICE 2 / 5 • GRAMMAIRE ». Question : « Que veut dire « Lupum agnus videt. » ? (videt = voit) ». Options à l'écran : A « Les deux se voient. », B « Le loup voit l'agneau. », C « On ne peut pas savoir. », D « L'agneau voit le loup. ». Identique au jeu de données. |
| Mauvaise réponse 1 : « Les deux se voient. » | `t54_m4-01_mauvaise.png`, `t54_m4-01_mauvaise_explication.png` | Oui | Option en rouge avec une croix. Bloc « Pas tout à fait… Réessaie. » puis : « Un seul des deux fait l'action : les terminaisons disent lequel. » C'est l'explication de l'option « Les deux se voient. » dans `explications` (index 2). |
| Mauvaise réponse 2 : « Le loup voit l'agneau. » | `t54_m4-01_mauvaise2_explication.png` | Oui | Les deux options fausses restent rouges. Explication : « Tu as lu les mots dans l'ordre du français. En latin, c'est la terminaison qui décide. » C'est l'explication de cette option (index 0). Le texte s'est remplacé, il ne s'est pas ajouté. |
| Bonne réponse : « L'agneau voit le loup. » | `t54_m4-01_bonne.png` | Oui | L'appli passe aux questions de vocabulaire : « EXERCICE 3 / 5 • VOCABULAIRE », « Que signifie « lupus » ? » (la porte, l'esprit / l'intelligence, le loup, le gladiateur). Suite : `t54_m4-01_vocab4.png` (non lue), `t54_m4-01_vocab5.png`, `t54_m4-01_vocab5_suite.png` (« EXERCICE 5 / 5 • VOCABULAIRE », « Que signifie « lupa » ? », « Optime ! lupa, -ae : la louve »). |
| Bilan | `t54_m4-01_triumphus.png` (vidéo), `t54_m4-01_bilan.png` | Oui, avec réserve | « MONDE TERMINÉ ! », une étoile sur trois, « Nouvelle carte au Panthéon : Hercule », « C'est la terminaison (le cas) qui indique si un mot est Sujet ou COD ! », « +4 HS ». Solde 100 puis 104 HS à l'accueil (`t54_apres_m4-01.png`), cohérent. Une seule étoile après deux erreurs de grammaire (voir ma réserve sur le vocabulaire plus haut). |

## 2. Leçon `m8-03` (exercice à trou)

| Étape | Capture | Conforme | Observation |
|---|---|---|---|
| Exercice principal (1/5) | `t54_m8-03_exo.png`, `t54_m8-03_saisie.png`, `t54_m8-03_valider.png` | Oui | « Mets dominus au génitif (« du maître ») : », « Servus domin [ ] aquam portat. ». J'ai saisi « i » puis « VALIDER LA TERMINAISON ». Le clavier masque le bouton : il faut le refermer (touche retour) avant de valider. |
| Arrivée de la carte de grammaire | `t54_m8-03_fin_principal.png` (copie `t54_m8-03_grammaire.png`) | Oui | « EXERCICE 2 / 5 • GRAMMAIRE », « Exercice de grammaire », « Comment dit-on « le bouclier de l'ami » ? (scutum = le bouclier) ». Options : A « Scutum amicum. », B « Scutum amicae. », C « Scutum amicus. », D « Scutum amici. ». Identique au jeu de données. |
| Mauvaise réponse : « Scutum amicae. » | `t54_m8-03_mauvaise.png`, `t54_m8-03_mauvaise_explication.png` | Oui | « Pas tout à fait… Réessaie. » « Cette fin est bien un génitif, mais celui d'un nom féminin : l'amie. » Conforme à l'explication de cette option. |
| Bonne réponse : « Scutum amici. » | `t54_m8-03_bonne.png` | Oui | Passage à « EXERCICE 3 / 5 • VOCABULAIRE » (« Que signifie « dominus » ? »), puis `t54_m8-03_vocab4.png` (« Comment dit-on « les thermes, les bains publics » en latin ? ») et `t54_m8-03_vocab5.png` (« Que signifie « vendere » ? »). |
| Bilan | `t54_m8-03_triumphus.png`, `t54_m8-03_bilan.png` | Oui | « MONDE TERMINÉ ! », 2 étoiles sur 3, « Nouvelle carte au Panthéon : Les Thermes », « +7 HS », « 42 / 113 leçons ». Solde 111 HS à l'accueil (`t54_apres_m8-03.png`). |

## 3. Leçon `m9-04` (décodeur)

| Étape | Capture | Conforme | Observation |
|---|---|---|---|
| Exercice principal (1/5) | `t54_m9-04_exo.png`, `t54_m9-04_decodeur.png`, `t54_m9-04_avant_verif.png` | Oui | « LE DÉCODEUR DE CAS GRAMMATICAUX », mots « Equos », « servi », « vident ». J'ai attribué COD, Sujet, Verbe (réponses du jeu de données : cod, sujet, verbe), puis « VÉRIFIER LE DÉCODAGE ». |
| Arrivée de la carte de grammaire | `t54_m9-04_apres_verif.png` (copie `t54_m9-04_grammaire.png`) | Oui | « EXERCICE 2 / 5 • GRAMMAIRE », « Dans « Lupos agricolae vident. » (agricola = le paysan), quel mot est le sujet ? ». Options : A « Lupos », B « On ne peut pas savoir », C « Agricolae », D « Vident ». Identique au jeu de données. |
| Mauvaise réponse : « Lupos » | `t54_m9-04_mauvaise_explication.png` | Oui | « Pas tout à fait… Réessaie. » « C'est le premier mot, mais sa fin -os indique un COD pluriel. » Conforme. |
| Bonne réponse : « Agricolae » | `t54_m9-04_bonne.png` | Oui | Passage à « EXERCICE 3 / 5 • VOCABULAIRE » (« Que signifie « fortiter » ? »), puis `t54_m9-04_vocab4.png` (« Comment dit-on « le javelot » en latin ? »), `t54_m9-04_vocab5.png` (« Que signifie « aquila » ? »). |
| Bilan | `t54_m9-04_bilan.png` | Oui | « Bene ! », 2 étoiles sur 3, « Réussi avec une aide. Refais la leçon plus tard pour décrocher 3 étoiles. », « +7 HS », « 43 / 113 leçons ». Solde 118 HS (`t54_apres_m9-04_font13.png`). |

## 4. Police agrandie et petit écran

Leçon `m1-01` (qui a aussi une question de grammaire, repère « EXERCICE 2 / 2 • GRAMMAIRE ») : question « Comment les Romains prononçaient-ils le mot 'via' (la route) ? ».

| Étape | Capture | Conforme | Observation |
|---|---|---|---|
| Police 1.3, carte à l'arrivée | `t54_grammaire_font13.png` | Oui | Repère, titre, question sur trois lignes et quatre options entières, sans coupure ni débordement. |
| Police 1.3, mauvaise réponse | `t54_grammaire_font13_explication.png` | Oui | « C'est la façon de lire le V en français moderne, pas celle des Romains. » Bloc entier, carte entière visible. |
| Police 1.3, autres écrans | `t54_carte_font13.png`, `t54_m1-01_font13_a.png`, `t54_m1-01_font13_exo.png` | Oui, avec réserve | Sur la carte de la leçon suivante, le bouton « COMMENCER LA LEÇON ▶ » passe sur deux lignes et le titre « L'Alphabet secret des Rom… » est coupé par des points de suspension. Pas lié à la grammaire. |
| Petit écran 720x1280, densité 320 | `t54_grammaire_petit_ecran.png`, `t54_grammaire_petit_ecran_suite.png` | Oui | La carte tient sur l'écran avec ses quatre options et le bloc d'explication, après un défilement. Rien n'est coupé. |

Réglages remis : `font_scale` 1.0 (vérifié, réponse « 1.0 »), `wm size reset`, `wm density reset` (vérifié : « Physical size: 1080x2400 », « Physical density: 420 »).

## Mon avis

- **L'enchaînement est clair.** Après l'exercice principal, la carte apparaît sans écran de transition, avec le repère « EXERCICE 2 / 5 • GRAMMAIRE » et le titre « Exercice de grammaire ». L'élève comprend sans explication qu'on passe à une question sur la leçon. La bonne réponse l'emmène directement au vocabulaire.
- **La carte est lisible**, y compris à 1.3 et en 720x1280. Le titre de carte et la question sont bien hiérarchisés. Les explications sont courtes, en français simple, et ne donnent pas la réponse : elles disent pourquoi l'option est fausse. Le bloc « Pas tout à fait… Réessaie. » est un ton adapté à un collégien.
- **Pas de blocage constaté** : j'ai pu essayer plusieurs mauvaises réponses d'affilée, et l'explication se remplace à chaque fois.
- **Le nombre d'étapes est acceptable, avec une limite.** Une leçon passe de 4 à 5 questions : c'est une question de plus, sans plus. Le vrai coût est ailleurs : l'exercice principal est précédé d'un long texte de cours, et la carte de grammaire s'ajoute à la suite sur la même page défilante, donc plus la page s'allonge, plus l'élève doit remonter pour relire le cours en répondant (à l'écran la carte est en bas de la page, le cours au-dessus). Ce n'est pas bloquant.
- **Points à surveiller** (pas des défauts de la grammaire) : le nombre d'étoiles baisse apparemment dès qu'on se trompe en grammaire (1 erreur : 2 étoiles sur `m8-03` et `m9-04` ; 2 erreurs : 1 étoile sur `m4-01`). Je n'ai pas vérifié la règle dans le code ni lu les captures vocabulaire 4 et 5 de `m4-01`, c'est donc une observation, pas une preuve. Si c'est voulu, bien ; si un élève s'attend à ce que seule l'erreur finale compte, 1 étoile après deux essais de grammaire peut surprendre. La fenêtre « Bene ! » indique pour `m9-04` « Réussi avec une aide », ce qui éclaire un peu la règle.
- Écran « MONDE TERMINÉ » sur `m4-01` et `m8-03` : artefact de mon profil de test, pas un défaut.

## Restauration

| Étape | Capture ou fichier | Conforme | Observation |
|---|---|---|---|
| Profil d'origine remis | `t54_profil_restaure_verif.json` | Oui | `cmp` avec `t54_profil_avant.json` : fichiers identiques (message `IDENTIQUE`). Piège rencontré : la lecture par `adb shell cat` ajoute des retours chariot en fin de fichier ; ma première remise en place avait donc un caractère de trop. Je l'ai corrigée avec `scratch/t54_profil_original_corrige.json` (retours chariot retirés) puis revérifiée. |
| Accueil | `t54_accueil_restaure.png` | Oui | « Marcus », « CIVIS ROMANUS », « 5 / 113 leçons conquises », « 556 HS », série « 0 j ». Cette capture a été prise avant la correction du dernier octet de fin de fichier ; l'appli a ensuite été fermée de force avant la correction. |
| Dépôt | `git status` | Oui | Aucun fichier modifié sous `windows/flutter/` (rien à remettre) ; seuls des dossiers `.claude/` non suivis apparaissent. Rien commité, rien poussé. |

## Liste des captures

Sortie de `ls scratch/t54_*` :

```
scratch/t54_accueil_restaure.png
scratch/t54_accueil_test.png
scratch/t54_apres_m4-01.png
scratch/t54_apres_m8-03.png
scratch/t54_apres_m9-04_font13.png
scratch/t54_carte_a.png
scratch/t54_carte_b.png
scratch/t54_carte_font13.png
scratch/t54_grammaire_font13.png
scratch/t54_grammaire_font13_explication.png
scratch/t54_grammaire_petit_ecran.png
scratch/t54_grammaire_petit_ecran_suite.png
scratch/t54_m1-01_font13_a.png
scratch/t54_m1-01_font13_exo.png
scratch/t54_m4-01_bilan.png
scratch/t54_m4-01_bonne.png
scratch/t54_m4-01_exo.png
scratch/t54_m4-01_fin_principal.png
scratch/t54_m4-01_grammaire.png
scratch/t54_m4-01_mauvaise.png
scratch/t54_m4-01_mauvaise2_explication.png
scratch/t54_m4-01_mauvaise_explication.png
scratch/t54_m4-01_ouverture.png
scratch/t54_m4-01_triumphus.png
scratch/t54_m4-01_vocab3_suite.png
scratch/t54_m4-01_vocab4.png
scratch/t54_m4-01_vocab4_suite.png
scratch/t54_m4-01_vocab5.png
scratch/t54_m4-01_vocab5_suite.png
scratch/t54_m8-03_bilan.png
scratch/t54_m8-03_bonne.png
scratch/t54_m8-03_exo.png
scratch/t54_m8-03_fin_principal.png
scratch/t54_m8-03_grammaire.png
scratch/t54_m8-03_mauvaise.png
scratch/t54_m8-03_mauvaise_explication.png
scratch/t54_m8-03_saisie.png
scratch/t54_m8-03_triumphus.png
scratch/t54_m8-03_valider.png
scratch/t54_m8-03_vocab4.png
scratch/t54_m8-03_vocab5.png
scratch/t54_m9-04_apres_verif.png
scratch/t54_m9-04_avant_verif.png
scratch/t54_m9-04_bilan.png
scratch/t54_m9-04_bonne.png
scratch/t54_m9-04_decodeur.png
scratch/t54_m9-04_exo.png
scratch/t54_m9-04_grammaire.png
scratch/t54_m9-04_mauvaise_explication.png
scratch/t54_m9-04_vocab4.png
scratch/t54_m9-04_vocab5.png
scratch/t54_profil_avant.json
scratch/t54_profil_original_corrige.json
scratch/t54_profil_restaure_verif.json
scratch/t54_profil_test.json
```

Note : certaines captures intermédiaires (`t54_carte_a.png`, `t54_carte_b.png`, `t54_m4-01_ouverture.png`, `t54_m4-01_vocab3_suite.png`, `t54_m4-01_vocab4*.png`, `t54_m4-01_triumphus.png`) n'ont pas été relues ou ne servent qu'à la navigation ; elles ne sont citées nulle part comme preuve.
