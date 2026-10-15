# Tournée T57 : grammaire en 4e et 3e, trou, « Revoir le cours », prononciation

Vérification à l'écran sur l'émulateur Pixel_Ludus (1080x2400), APK debug déjà construit, installé avec `adb install -r`. Aucun fichier de code ni de données modifié. Les textes cités sont recopiés depuis des captures lues avec l'outil Read, toutes présentes dans `scratch/` (liste en fin de fichier).

## Méthode et réserves

- Profil d'origine lu en binaire (`adb exec-out run-as ... cat`) et sauvegardé dans `scratch/t57_profil_avant.json`. Profil de test : toutes les leçons terminées à 3 étoiles sauf la leçon testée (changée à chaque fois), 100 HS, niveaux 5e, 4e et 3e « vus ». Conséquence : l'accueil de test affichait « 112 / 113 leçons conquises », ce qui n'arrive pas en jeu normal.
- L'émulateur a planté plusieurs fois (écrans « Ludus Latinus isn't responding », « System UI isn't responding », puis appareil hors ligne). Je l'ai tué et relancé trois fois. Ça explique les captures `t57_dbg*.png` et les doublons.
- Réserve d'honnêteté sur `m12-02` : à la première passe, mes lectures de captures ont échoué (image non rendue). Les captures `t57_m12-02_exo/saisie/valide/gram/mauvaise/bonne/...` (sans suffixe `_b` ou `_c`) existent mais je ne les ai pas lues. J'ai donc refait la leçon et lu les captures `t57_m12-02_saisie_b`, `saisie_c`, `gram_b`, `mauvaise_b`, `bonne_b`. Tout ce qui est cité pour `m12-02` vient de celles-là. Pour `m1-03` et `m4-03`, la liste des boutons a d'abord été lue par uiautomator, puis les captures ont été relues avec Read : les textes cités viennent des captures.
- Ordre des options à l'écran : mélangé. Les options ont été retrouvées par leur texte.
- Dans le champ de `m12-02` une première saisie « em » a été tapée sans effet (champ non ciblé), puis refaite : c'est la capture `saisie_c` qui fait foi.

## 1. Questions de grammaire en 4e et 3e

Données attendues (champ `grammaire`, comparées mot à mot) :

| Leçon | Question | Bonne réponse |
|---|---|---|
| `m12-02` (trou) | Quelle phrase veut dire « Le sénateur voit le roi » ? (senator, senatoris = le sénateur) | Senator regem videt. |
| `m16-01` (quiz) | Quelle forme veut dire « tu as chanté » ? (cantare = chanter) | Cantavisti |
| `m21-02` (trou) | Complète pour dire « Les villes ont été détruites » : Urbes ___ sunt. | deletae |
| `m24-01` (quiz) | Complète pour dire « Je sais que le soldat court » : Scio ___ currere. | militem |

| Leçon | Étape | Capture | Conforme | Observation |
|---|---|---|---|---|
| `m12-02` | Exercice principal (trou) | `t57_m12-02_saisie_b.png`, `t57_m12-02_saisie_c.png` | Oui | « EXERCICE 1 / 5 », « Complète le mot « soldat » à l'accusatif singulier : », étiquette « Écris seulement la fin du mot », « Consul milit » + case + « convocat. ». Saisie « em » acceptée. |
| `m12-02` | Carte de grammaire | `t57_m12-02_gram_b.png` | Oui | « EXERCICE 2 / 5 • GRAMMAIRE », « Exercice de grammaire », question et quatre options identiques au jeu de données : A « Senator regem videt. », B « Senator rex videt. », C « Senator regis videt. », D « Senatorem rex videt. ». |
| `m12-02` | Mauvaise réponse : « Senatorem rex videt. » | `t57_m12-02_mauvaise_b.png` | Oui | Option en rouge avec croix, bloc « Pas tout à fait… Réessaie. » puis « Les rôles sont inversés : la fin -em marque celui qui subit l'action. » = explication de cette option (index 0). Non vide. |
| `m12-02` | Bonne réponse : « Senator regem videt. » | `t57_m12-02_bonne_b.png` | Oui | Passage à « EXERCICE 3 / 5 • VOCABULAIRE », « Que signifie « consul » ? » (le premier citoyen, le prince / le pied / le consul / la voix). |
| `m16-01` | Exercice principal (QCM) | `t57_m16-01_exo.png` | Oui | « Quelle est la désinence de la 3e personne du singulier au parfait (il/elle a fait) ? », options -ut, -it, -et, -at. « -it » choisi (bonne réponse). |
| `m16-01` | Carte de grammaire | `t57_m16-01_gram.png` | Oui | « EXERCICE 2 / 5 • GRAMMAIRE », « Quelle forme veut dire « tu as chanté » ? (cantare = chanter) », options Cantavi, Cantavit, Cantavisti, Cantabas. Identique. |
| `m16-01` | Mauvaise réponse : « Cantavit » | `t57_m16-01_mauvaise.png` | Oui | « Pas tout à fait… Réessaie. » puis « Cette fin désigne une autre personne, pas celui à qui l'on parle. » = explication de « Cantavit » (index 2). |
| `m16-01` | Bonne réponse : « Cantavisti » | `t57_m16-01_bonne.png` | Oui | Passage à « EXERCICE 3 / 5 • VOCABULAIRE », « Que signifie « puella » ? ». |
| `m21-02` | Exercice principal (trou) | `t57_m21-02_exo.png`, `t57_m21-02_saisie.png` | Oui | « Accorde le participe avec oppidum (neutre) : », « Écris seulement la fin du mot », « Oppidum capt » + case « fin » + « est. ». Saisie « um » acceptée. |
| `m21-02` | Carte de grammaire | `t57_m21-02_gram.png` | Oui | « Complète pour dire « Les villes ont été détruites » : Urbes ___ sunt. », options deletae, deletum, deleta, deleti. Identique. |
| `m21-02` | Mauvaise réponse : « deleta » | `t57_m21-02_mauvaise.png` | Oui | « Cette fin marque un féminin singulier. Ici, il y a plusieurs villes. » = explication de « deleta » (index 0). |
| `m21-02` | Bonne réponse : « deletae » | `t57_m21-02_bonne.png` | Oui | Passage à « EXERCICE 3 / 5 • VOCABULAIRE », « Que signifie « vicus » ? ». |
| `m24-01` | Exercice principal (QCM) | `t57_m24-01_exo.png` | Oui | « Comment se construisent le sujet et le verbe d'une proposition infinitive en latin ? », bonne réponse « Sujet à l'Accusatif + Verbe à l'Infinitif ». |
| `m24-01` | Carte de grammaire | `t57_m24-01_gram.png` | Oui | « Complète pour dire « Je sais que le soldat court » : Scio ___ currere. », options militis, miles, militem, militi. Identique. |
| `m24-01` | Mauvaise réponse : « militis » | `t57_m24-01_mauvaise.png` | Oui | « Cette forme est un génitif : « du soldat ». Elle compléterait un nom. » = explication de « militis » (index 3). |
| `m24-01` | Bonne réponse : « militem » | `t57_m24-01_bonne.png` | Oui | Passage à « EXERCICE 3 / 5 • VOCABULAIRE », « Que signifie « sapientia » ? ». |

Verdict du point 1 : conforme sur les quatre leçons. Aucune mauvaise réponse ne montre un bloc vide. Limite : je n'ai testé qu'une seule mauvaise réponse par carte (une option fausse sur trois), pas les trois. Les explications des autres options fausses ne sont donc vérifiées que dans le jeu de données (aucune vide hormis la bonne réponse, comme prévu), pas à l'écran.

## 2. Exercice à trou : fin de mot et mot entier

| Leçon | `avant` | Capture | Conforme | Observation |
|---|---|---|---|---|
| `m4-03` (fin de mot) | `Puer silv` (sans espace final) | `t57_m4-03_trou.png` | Oui | Consigne « Mets silva au COD : », étiquette bleue « Écris seulement la fin du mot », début de mot « Puer silv » collé à la case, indication dans la case « fin », puis, à la ligne, « videt (Le garçon voit la forêt). » (le début de la phrase et la case sont sur la première ligne, la suite passe en dessous). |
| `m1-03` (mot entier) | `Romanus ` (espace final) | `t57_m1-03_trou.png` | Oui | Consigne « Écris le verbe qui manque pour dire « Je suis romain » : », étiquette jaune « Écris le mot entier », « Romanus » suivi d'un espace avant la case (case séparée du mot), indication dans la case « mot », puis « . ». |

Vérifié aussi sur `m12-02` et `m21-02` : étiquette « Écris seulement la fin du mot » et indication « fin » (captures citées au point 1). Les autres leçons à espace final repérées dans le jeu de données : `m3-03` (`Icarus ad `), `m17-02` (`Caesar `), `m20-02` (`Aqua `), `m7-02` (`avant` vide) ; non ouvertes.

## 3. Bouton « Revoir le cours »

Leçon `m1-03`, au-dessus de l'exercice 1.

| Étape | Capture | Conforme | Observation |
|---|---|---|---|
| Bouton visible | `t57_m1-03_trou.png` | Oui | « 📖 Revoir le cours » aligné à droite, au-dessus de « EXERCICE 1 / 5 ». |
| Volet ouvert | `t57_m1-03_revoir.png` | Oui | Volet depuis le bas : « Se présenter : Comment t'appelles-tu ? », « Quis es ? (Qui es-tu ?) », le texte du cours, bouton jaune « Retour à l'exercice ». |
| Volet fermé, question toujours là | `t57_m1-03_apres_revoir.png` | Oui | Retour à la page : « EXERCICE 1 / 5 », « Écris le verbe qui manque pour dire « Je suis romain » : », étiquette « Écris le mot entier », case « mot » vide. La position de défilement est conservée. |

Fermé par le bouton « Retour à l'exercice » (appui à 540,1655). La fermeture par glissement ou par le bouton retour du système n'a pas été testée.

## 4. Fenêtre de prononciation

Ouverture : au Thesaurus (Bibliotheca, Thesaurus, Dictionnaire), icône haut-parleur à droite de « amica, -ae », qui appelle `LatinPronunciationModal.show` (`thesaurus_screen.dart:253`).

| Étape | Capture | Conforme | Observation |
|---|---|---|---|
| Fenêtre ouverte | `t57_prononc.png` | Oui | « PRONUNTIATIO LATINA », « Guide phonétique & accent tonique antique ». Puces de mot « amica » et « ae ». Syllabes « a » (« ▲ tonique »), « mi », « ca ». Bouton « Réciter au rythme antique ▶ ». Onglets « Restituée (Cicéron) » et « Ecclésiastique (Moyen Âge) ». « Transcription API : ['a.mi.ka] ». Loi de la Pénultième. |
| Pendant la récitation | `t57_recite_1.png` | Oui | Le bouton devient grisé « Récitation en cours... », la syllabe « mi » est surlignée en jaune plein. |
| Après la récitation | `t57_recite_2.png`, `t57_recite_fin.png` | Oui | Le bouton redevient « Réciter au rythme antique ▶ ». |

Ce que fait réellement le bouton de récitation :
- Dans le code (`latin_pronunciation_modal.dart`), toutes les 450 ms il surligne la syllabe suivante et appelle `HapticFeedback` (lourd sur la syllabe tonique, léger sinon) et `SystemSound.play(SystemSoundType.click)`.
- Il n'y a aucune voix, aucun synthétiseur ni fichier audio de mot. Ce que j'ai constaté à l'écran : le surlignage défile, rien d'autre. Je ne peux pas entendre l'émulateur : je n'affirme pas avoir « entendu » quoi que ce soit, je confirme seulement ce que le code déclenche (un clic système par syllabe) et ce que l'écran montre (surlignage). Sur un téléphone, l'élève entendra donc des clics au rythme des syllabes, pas le mot prononcé. Pour une fenêtre appelée « Pronuntiatio latina » avec un bouton « Réciter », c'est une promesse que le son ne tient pas.
- Détail visuel : le mot affiché en tête de la fenêtre est « amica, » avec la virgule collée (le mot est repris du lemme « amica, -ae » coupé après la virgule).

## 5. Police agrandie et petit écran

| Cas | Capture | Conforme | Observation |
|---|---|---|---|
| `font_scale 1.3`, carte de grammaire `m24-01` | `t57_m24-01_gram_font13.png`, `t57_m24-01_gram_font13_bas.png` | Oui | Le texte grossit, la question « Complète pour dire « Je sais que le soldat court » : Scio ___ currere. » passe sur deux lignes, les options restent lisibles, l'explication « Cette forme est un génitif : « du soldat ». Elle complèterait un nom. » reste dans son bloc. Pas de débordement ni de texte coupé. |
| `wm size 720x1280`, `wm density 320` | `t57_m24-01_gram_petit.png` | Oui | La carte tient en largeur, les quatre options et le bloc d'explication sont visibles et lisibles sans défilement horizontal. |
| Réglages remis | `t57_m24-01_reset.png` | Oui | `font_scale` 1.0, « Physical size: 1080x2400 », « Physical density: 420 ». |

## Avis franc

- La carte de grammaire fait ce qu'on attend en 4e et 3e : question, options et explications sont fidèles au jeu de données, le blocage d'une mauvaise réponse est net (rouge, croix, explication spécifique), et la bonne réponse enchaîne sur le vocabulaire. Rien à corriger de ce côté sur ces quatre leçons.
- L'étiquette du trou est utile et le début de mot collé à la case rend la consigne claire. Seul bémol : sur `m4-03` la suite de phrase passe à la ligne, c'est correct mais un peu aéré.
- « Revoir le cours » est bien pensé : le volet est propre et la question reste en place.
- Le vrai problème est la récitation : un bouton « Réciter » qui ne produit que des clics système va décevoir. Soit on le renomme (« Battre le rythme »), soit on y met une vraie voix ou des enregistrements. Autre point : le « amica, » avec virgule dans l'en-tête de la fenêtre est un défaut cosmétique mineur.
- Réserve générale : les tests ont été faits avec un profil artificiel (tout terminé), sur un émulateur instable. Cela n'affecte pas la lecture des cartes, mais les chiffres d'accueil de la session ne sont pas ceux d'un parcours réel.

## Restauration

- Profil d'origine restauré et vérifié avec `cmp` (`t57_profil_avant.json` et `t57_profil_apres.json` identiques), puis vérifié encore une fois après un relancement de l'appli (identique). Accueil final : « 461 HS », « 5 / 113 leçons conquises » (`t57_accueil_final.png`).
- `font_scale` 1.0, `wm size reset` (1080x2400), `wm density reset` (420) vérifiés.
- `git status` : aucun fichier sous `windows/flutter/` ; seul `.claude/` apparaît (non suivi, préexistant). Rien de commité ni poussé.

## Fichiers `scratch/t57_*` (liste `ls scratch/t57_*`)

t57_a3.png t57_accueil_final.png t57_accueil_test.png t57_accueil_test2.png t57_biblio.png t57_dbg.png t57_dbg2.png t57_dbg3.png t57_dbg4.png t57_dbg5.png t57_dbg6.png t57_dbg7.png t57_dbg8.png t57_dbg9.png t57_dbg10.png t57_dbg11.png t57_dbg12.png t57_dbg13.png t57_dbg14.png t57_dbg15.png t57_dbg16.png t57_dbg17.png t57_dbg18.png t57_dbg19.png t57_dbg20.png t57_dbg21.png t57_dbg22.png t57_m1-03_apres_revoir.png t57_m1-03_cours.png t57_m1-03_revoir.png t57_m1-03_trou.png t57_m12-02_apres_valid.png t57_m12-02_bonne.png t57_m12-02_bonne_b.png t57_m12-02_ecran.png t57_m12-02_exo.png t57_m12-02_gram.png t57_m12-02_gram_b.png t57_m12-02_map.png t57_m12-02_map2.png t57_m12-02_mauvaise.png t57_m12-02_mauvaise_b.png t57_m12-02_mauvaise_expl.png t57_m12-02_saisie.png t57_m12-02_saisie2.png t57_m12-02_saisie_b.png t57_m12-02_saisie_c.png t57_m12-02_valide.png t57_m16-01_bonne.png t57_m16-01_exo.png t57_m16-01_gram.png t57_m16-01_map.png t57_m16-01_map_dbg.png t57_m16-01_mauvaise.png t57_m21-02_bonne.png t57_m21-02_exo.png t57_m21-02_gram.png t57_m21-02_map.png t57_m21-02_mauvaise.png t57_m21-02_saisie.png t57_m24-01_avant_bonne.png t57_m24-01_bonne.png t57_m24-01_exo.png t57_m24-01_gram.png t57_m24-01_gram_font13.png t57_m24-01_gram_font13_bas.png t57_m24-01_gram_petit.png t57_m24-01_map.png t57_m24-01_mauvaise.png t57_m24-01_reset.png t57_m4-03_trou.png t57_nav1.png t57_nav4e.png t57_profil_apres.json t57_profil_avant.json t57_profil_test.json t57_prononc.png t57_recite_1.png t57_recite_2.png t57_recite_fin.png t57_thesaurus.png

Note : `t57_m21-02_gram.png` et `t57_m16-01_exo.png` ont été écrasées par une reprise (même nom), ce sont les versions lues. Les captures `t57_dbg*`, `t57_a3`, `t57_nav*`, `*_map*`, `*_ecran`, et les `m12-02` sans suffixe `_b`/`_c` sont des captures de navigation ou de première passe non citées ci-dessus.
