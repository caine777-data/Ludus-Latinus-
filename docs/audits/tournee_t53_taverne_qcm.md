# Tournée T53 : Taverne « Ad XXI » et explications des QCM

Tournée à l'écran sur l'émulateur Android (Pixel_Ludus, 1080x2400), APK debug reconstruit le 9 octobre. Aucun fichier de code ni de données modifié. Tout texte cité est recopié depuis une capture lue avec l'outil Read ; toutes les captures citées existent dans `scratch/` (liste collée en fin de fichier).

## Méthode et réserves

- Profil d'origine sauvegardé dans `scratch/t53_profil_avant.json`. Profil de test (`scratch/t53_profil_test.json`) : les 30 leçons des mondes 1 à 6 terminées à 3 étoiles, 100 HS, compteur de la Taverne à zéro.
- Condition d'ouverture de la Taverne, lue dans `profile.dart` : `isTaverneUnlocked => completedLessons.length >= 6`, soit 6 leçons terminées (et non six mondes). Le texte du code est « Termine 6 leçons pour ouvrir la Taverne ». Le profil de test la remplit largement.
- 7 manches jouées (5 demandées + 2 supplémentaires : une pour voir « Trop loin », une pour obtenir enfin une victoire). Pour chaque manche, la capture « dernier choix » est la capture prise après mon dernier appui sur « Encore un dé ». Pour la manche 6, j'ai enchaîné 4 appuis sans lire les captures intermédiaires : seule la capture finale existe, et je n'ai pas noté les dés de départ. Pour la manche 7, les appuis sont enchaînés deux par deux, d'où les captures `choix2`, `choix4`, `choix5`.
- Les totaux de Gaius ont été vérifiés par addition à partir des captures.

## 1. Taverne « Ad XXI »

### Ce qui était attendu (lu dans `taverne_screen.dart`)
2 dés au départ, totaux en chiffres romains, boutons « Encore un dé » et « Je m'arrête », Gaius relance tant qu'il a moins de XVII (17) et s'arrête à 17 ou plus, gain +8 HS par victoire limité à 3 par jour, pas de mise.

### Tableau de conformité

| Étape | Capture | Conforme | Observation |
|---|---|---|---|
| Accueil, carte « Défi de la Taverne des Dés » | `t53_accueil_test.png` | Oui, avec réserve | Bouton « JOUER · +10 HS », alors que l'écran de la Taverne annonce +8 HS par victoire (voir défaut 1). |
| Départ manche 1 | `t53_taverne_m1_depart.png` | Oui | 2 dés (I, III), « Total : IV », deux boutons, règles affichées, « Victoires payées aujourd'hui : encore 3 sur 3 (+8 HS chacune) ». Aucune mise. |
| Manche 1, dernier choix | `t53_taverne_m1_choix3.png` | Oui | 5 dés, « Total : XVII ». |
| Manche 1, résultat | `t53_taverne_m1_resultat.png` | Oui | Égalité à XVII, 100 HS avant, 100 après, pas de gain. |
| Manche 2 | `t53_taverne_m2_depart.png`, `t53_taverne_m2_gaius_en_cours.png`, `t53_taverne_m2_resultat.png` | Oui | Arrêt immédiat à VIII. Pendant que Gaius joue : « Gaius lance ses dés… ». Défaite, 100 HS avant et après. |
| Manche 3 | `t53_taverne_m3_depart.png`, `t53_taverne_m3_choix2.png`, `t53_taverne_m3_resultat.png` | Oui | Défaite à XVIII contre XX. |
| Manche 4 | `t53_taverne_m4_depart.png`, `t53_taverne_m4_choix4.png`, `t53_taverne_m4_resultat.png` | Oui | Défaite à XVII contre XXI. |
| Manche 5 | `t53_taverne_m5_depart.png`, `t53_taverne_m5_choix2.png`, `t53_taverne_m5_resultat.png` | Oui | Défaite à XVII contre XVIII. |
| Manche 6 (bonus), dépassement | `t53_taverne_m6_bonus_trop.png` | Oui, avec réserve | Total XXIV en rouge, « Trop loin ! ». Le cadre de Gaius reste vide (voir défaut 3). |
| Manche 7 (bonus), victoire | `t53_taverne_m7_depart.png`, `t53_taverne_m7_choix2.png`, `t53_taverne_m7_choix4.png`, `t53_taverne_m7_choix5.png`, `t53_taverne_m7_resultat.png` | Oui, avec réserve | Victoire XXI contre XIX. HS : 100 avant, 118 après, affiché « +18 HS » (voir défaut 1). |

### Manches recopiées depuis les captures

| N° | Dés de départ | Mes choix | Mes dés finaux | Mon total | Dés de Gaius | Total Gaius | Titre de fin | Message de fin | HS avant puis après |
|---|---|---|---|---|---|---|---|---|---|
| 1 | I, III (IV) | Encore x3, je m'arrête | I, III, III, VI, IV | XVII | VI, IV, I, II, III, I | XVII | Égalité | Vous avez tous les deux XVII (17). | 100, 100 |
| 2 | V, III (VIII) | Je m'arrête tout de suite | V, III | VIII | V, II, I, III, I, II, I, III | XVIII | Gaius l'emporte | Son XVIII (18) bat ton VIII (8). | 100, 100 |
| 3 | IV, VI (X) | Encore x2, je m'arrête | IV, VI, III, V | XVIII | VI, VI, II, VI | XX | Gaius l'emporte | Son XX (20) bat ton XVIII (18). | 100, 100 |
| 4 | III, III (VI) | Encore x4, je m'arrête | III, III, VI, II, II, I | XVII | IV, I, III, I, IV, I, II, V | XXI | Gaius l'emporte | Son XXI (21) bat ton XVII (17). | 100, 100 |
| 5 | IV, V (IX) | Encore x2, je m'arrête | IV, V, III, V | XVII | VI, IV, VI, II | XVIII | Gaius l'emporte | Son XVIII (18) bat ton XVII (17). | 100, 100 |
| 6 (bonus) | non relus | Encore x4 (dépassement) | VI, I, IV, III, VI, IV | XXIV | aucun dé | néant | Trop loin ! | XXIV (24) dépasse XXI (21). | 100, 100 |
| 7 (bonus) | IV, I (V) | Encore x5, je m'arrête | IV, I, II, I, V, III, V | XXI | IV, I, IV, IV, III, III | XIX | Tu bats Gaius ! | Ton XXI (21) bat son XIX (19). Gain : +18 HS | 100, 118 |

Dans la manche 3 le total affiché au départ est « X », et dans la manche 5 « IX » (captures `m3_depart`, `m5_depart`). Le bandeau du bas avant la manche 7 : « Victoires payées aujourd'hui : encore 3 sur 3 (+8 HS chacune) ». Après la victoire : « encore 2 sur 3 » (partiellement visible sur `t53_taverne_m7_resultat.png`, confirmé sur `t53_taverne_font13.png`).

### Vérification de la règle de Gaius (sommes faites à partir des captures)
- M1 : 6+4=10, +1=11, +2=13, +3=16, +1=17. Il a relancé à 16, s'est arrêté à 17. Conforme.
- M2 : 5+2+1+3+1+2+1=15, relance (+3), s'arrête à 18. Conforme.
- M3 : 6+6=12, +2=14 (relance), +6=20, s'arrête. Conforme.
- M4 : 4+1+3+1+4+1+2=16 (relance), +5=21, s'arrête. Conforme.
- M5 : 6+4+6=16 (relance), +2=18, s'arrête. Conforme.
- M7 : 4+1+4+4+3=16 (relance), +3=19, s'arrête. Conforme.
- Aucun cas de Gaius qui s'arrête sous 17, aucun cas de Gaius qui relance à 17 ou plus.

### Défauts et incohérences relevés
1. **Gain affiché non expliqué.** L'écran annonce « +8 HS chacune », mais la victoire de la manche 7 affiche « +18 HS » et le solde passe de 100 à 118. Les +10 viennent du défi quotidien de la Taverne (`accomplirDefi('taverne')` dans le code ; la carte de l'accueil devient ensuite « Défi accompli ! Reviens demain pour une nouvelle quête. », capture `t53_accueil_font13.png`). Le joueur voit « +18 » sans savoir pourquoi, alors que la règle écrite dit +8.
2. **Texte du bas sous la barre de gestes** sur l'écran de victoire (`t53_taverne_m7_resultat.png`) : « Victoires payées aujourd'hui… » est partiellement recouvert par la barre système. L'écran défile, donc ce n'est pas bloquant.
3. **Cadre de Gaius vide après un dépassement** (`t53_taverne_m6_bonus_trop.png`) : le cadre porte le titre « Gaius l'aubergiste » mais reste blanc, sans la phrase « Gaius attend… » ni dés. Pas faux (Gaius ne joue pas), mais l'enfant peut croire à un bug d'affichage.
4. **Les boutons changent de place** quand une deuxième rangée de dés apparaît (7e dé : les boutons descendent d'environ 150 pixels, comparer `t53_taverne_m7_choix4.png` et `t53_taverne_m7_choix5.png`). Un enfant qui tape deux fois vite peut toucher à côté. J'ai moi-même dû changer la coordonnée d'appui.
5. **Aucune victoire sur les manches 1 à 5** avec un jeu prudent (arrêt à XVII ou XVIII) : 1 égalité, 4 défaites. L'échantillon est trop petit pour conclure. À vérifier par une simulation avant de toucher aux règles.

### Avis franc : un enfant de 12 ans comprend-il sans aide ?
Oui pour l'essentiel. Le panneau de règles est court (trois lignes numérotées), la ligne « Aide : I = 1 · V = 5 · X = 10 · IV = 4 · IX = 9 · XXI = 21 » est utile, les boutons parlent d'eux-mêmes et le total en chiffres romains est lisible en gros caractères. L'enfant comprend vite qu'il faut s'approcher de 21 sans le dépasser. Trois points peuvent le perdre : (a) la règle de Gaius n'est écrite nulle part (« Gaius joue ensuite. Le plus près de XXI gagne. », mais pas qu'il relance jusqu'à XVII) ; (b) l'égalité n'est pas expliquée dans les règles (le message « Égalité » s'affiche, sans dire que personne ne gagne) ; (c) le gain +18 contre le +8 annoncé. Côté pédagogie, lire XVII, XXI, XXIV plusieurs fois en quelques minutes fait travailler les chiffres romains sans que ce soit une leçon.

## 2. Explications des QCM (mauvaise réponse choisie exprès)

Source : `ludus_latinus_mobile/assets/data/ludus_latinus_dataset.json`, champ `explications` (même index que `options`). Les options sont mélangées à l'écran, retrouvées par leur texte.

| Leçon | Captures | Réponse choisie (texte à l'écran) | Index dans `options` | Message affiché (recopié) | Champ `explications` de cet index | Conforme |
|---|---|---|---|---|---|---|
| `m1-01` | `t53_m1-01_question.png`, `t53_m1-01_mauvaise.png`, `t53_m1-01_explication.png` | « Toujours [S] : 'Sirsus' » | 1 | Titre « Pas tout à fait… » ; « Tu as choisi : « Toujours [S] : 'Sirsus' » » ; « Relis le passage de la leçon juste au-dessus : la réponse s'y trouve. » ; « Confusion avec le français moderne : en latin classique, le son [S] n'existe pas pour cette consonne. » | « Confusion avec le français moderne : en latin classique, le son [S] n'existe pas pour cette consonne. » | Oui |
| `m3-01` | `t53_m3-01_question.png`, `t53_m3-01_mauvaise.png` | « Mars » | 2 | Titre « Pas tout à fait… » ; « Tu as choisi : « Mars » » ; « Relis le passage de la leçon juste au-dessus : la réponse s'y trouve. » ; « Ce protecteur des légions porte le casque et la lance : il règne sur la guerre. » | « Ce protecteur des légions porte le casque et la lance : il règne sur la guerre. » | Oui |
| `m2-01` | `t53_m2-01_question.png`, `t53_m2-01_mauvaise.png` | « Servus » | 3 | Titre « Pas tout à fait… » ; « Tu as choisi : « Servus » » ; « Relis le passage de la leçon juste au-dessus : la réponse s'y trouve. » ; « Servus désigne l'esclave de la maison : ce n'est pas le mot pour l'enfant du père de famille. » | « Servus désigne l'esclave de la maison : ce n'est pas le mot pour l'enfant du père de famille. » | Oui |

Observations :
- Les trois explications sont identiques, mot pour mot, au champ du jeu de données. Le message affiché est la phrase fixe « Relis le passage de la leçon juste au-dessus : la réponse s'y trouve. » suivie de l'explication propre à l'option. Deux boutons : « Réessayer » et « Réessayer avec un indice ».
- Le titre « Pas tout à fait… » s'affiche même pour une réponse franchement fausse (Servus pour « fils »). C'est doux, pas faux.
- `m3-01` et `m2-01` affichent « EXERCICE 1 / 4 » au-dessus de la question (quatre exercices dans la leçon, hors périmètre de ce test). Ce compteur n'apparaît pas sur la capture de `m1-01`, qui n'a pas montré cette ligne.
- Navigation : la carte s'ouvre sur le monde 7 (première leçon non faite), il faut faire défiler plusieurs fois vers le haut pour atteindre le monde 1.

## 3. Police agrandie (`font_scale 1.3`)

| Écran | Capture | Conforme | Observation |
|---|---|---|---|
| QCM `m2-01`, réponse « Servus », explication | `t53_m2-01_font13_a.png`, `t53_m2-01_font13_explication.png` | Oui | Question, quatre réponses, bloc « Pas tout à fait… » et explication complète, boutons « Réessayer » et « Réessayer avec un indice » entiers. Aucun débordement. La ligne « Tu as choisi : » reste plus petite que le reste du bloc. Il faut faire défiler pour voir l'explication en entier. |
| Accueil à 1.3 | `t53_accueil_font13.png` | Oui | Titre « LUDUS LATINUS » entier, cartes lisibles. |
| Ludi à 1.3 | `t53_ludi_font13.png` | Oui, avec réserve | Libellés coupés par des points de suspension : « Colosseum Duellu… », « Arène tactique des cha… », « Une carte par monde te… ». Pas de débordement. |
| Taverne, départ | `t53_taverne_font13.png` | Oui | Règles entières, 2 dés (V, VI), « Total : XI », boutons côte à côte entiers, bandeau du bas sur deux lignes. |
| Taverne, résultat | `t53_taverne_font13_resultat.png` | Oui | Gaius IV, V, III, I, I, IV = XVIII ; moi V, VI = XI ; « Gaius l'emporte » ; « Son XVIII (18) bat ton XI (11). » ; bouton « NOUVELLE MANCHE » entier. |

`font_scale` remis à 1.0 (vérifié par `settings get system font_scale`, réponse « 1.0 »).

## 4. Restauration

| Étape | Capture ou fichier | Conforme | Observation |
|---|---|---|---|
| Profil d'origine remis | `t53_profil_restaure_verif.json` | Oui | `cmp` avec `t53_profil_avant.json` : fichiers identiques. |
| Accueil après relance | `t53_accueil_restaure.png` | Oui | « Marcus », « CIVIS ROMANUS », « 5 / 113 leçons conquises », « 556 HS », série « 0 j ». La carte de défi propose maintenant « Défi du Colosseum Duellum » (le défi du jour diffère de celui du début). |

Note : à la relance, mon appui sur « PASSER » (l'intro vidéo était déjà finie) a ouvert par erreur la fenêtre « TABERNA ROMANA ». Je l'ai fermée avec la croix, sans rien acheter ni équiper ; la capture finale de l'accueil montre 556 HS.

## Bilan

- Conforme : règles du code respectées à l'écran (2 dés au départ, chiffres romains, deux boutons, Gaius s'arrête à 17 ou plus, pas de mise, compteur de 3 victoires payées affiché) ; les trois explications de QCM correspondent mot pour mot au jeu de données ; police 1.3 sans débordement sur les écrans testés.
- À corriger : gain « +18 HS » non expliqué face au « +8 HS » annoncé ; règle de Gaius et égalité absentes du texte des règles ; texte du bas parfois sous la barre de gestes ; boutons qui descendent à l'apparition de la deuxième rangée de dés ; cadre de Gaius vide après un dépassement.
- À vérifier : l'équilibre du jeu (0 victoire en 5 manches prudentes) par simulation.

## Liste des captures

Sortie de `ls scratch/t53_*` : voir le bloc ci-dessous.

```
scratch/t53_accueil_apres_victoire.png
scratch/t53_accueil_font13.png
scratch/t53_accueil_restaure.png
scratch/t53_accueil_test.png
scratch/t53_carte.png
scratch/t53_carte_5e.png
scratch/t53_carte_haut.png
scratch/t53_carte_m2.png
scratch/t53_carte_m2b.png
scratch/t53_carte_m2c.png
scratch/t53_carte_m3.png
scratch/t53_ludi_font13.png
scratch/t53_m1-01_explication.png
scratch/t53_m1-01_mauvaise.png
scratch/t53_m1-01_ouverture.png
scratch/t53_m1-01_question.png
scratch/t53_m2-01_font13_a.png
scratch/t53_m2-01_font13_explication.png
scratch/t53_m2-01_mauvaise.png
scratch/t53_m2-01_question.png
scratch/t53_m3-01_mauvaise.png
scratch/t53_m3-01_question.png
scratch/t53_profil_avant.json
scratch/t53_profil_restaure_verif.json
scratch/t53_profil_test.json
scratch/t53_taverne_font13.png
scratch/t53_taverne_font13_resultat.png
scratch/t53_taverne_m1_choix1.png
scratch/t53_taverne_m1_choix2.png
scratch/t53_taverne_m1_choix3.png
scratch/t53_taverne_m1_depart.png
scratch/t53_taverne_m1_resultat.png
scratch/t53_taverne_m2_depart.png
scratch/t53_taverne_m2_gaius_en_cours.png
scratch/t53_taverne_m2_resultat.png
scratch/t53_taverne_m3_choix1.png
scratch/t53_taverne_m3_choix2.png
scratch/t53_taverne_m3_depart.png
scratch/t53_taverne_m3_resultat.png
scratch/t53_taverne_m4_choix1.png
scratch/t53_taverne_m4_choix2.png
scratch/t53_taverne_m4_choix3.png
scratch/t53_taverne_m4_choix4.png
scratch/t53_taverne_m4_depart.png
scratch/t53_taverne_m4_resultat.png
scratch/t53_taverne_m5_choix1.png
scratch/t53_taverne_m5_choix2.png
scratch/t53_taverne_m5_depart.png
scratch/t53_taverne_m5_resultat.png
scratch/t53_taverne_m6_bonus_trop.png
scratch/t53_taverne_m7_choix2.png
scratch/t53_taverne_m7_choix4.png
scratch/t53_taverne_m7_choix5.png
scratch/t53_taverne_m7_depart.png
scratch/t53_taverne_m7_resultat.png
```
