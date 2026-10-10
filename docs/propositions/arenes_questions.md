# Arènes : revue des questions (mondes 1 à 26)

## Résumé

- **82 questions** dans 26 arènes (3 questions, ou 4 aux mondes 6, 7, 10 et 26).
- **12 questions jamais enseignées** (14,6 %), donc 70 sur 82 sont conformes à la règle « ne garder que des questions vues dans le monde ». Les 12 : `m2-05` Q3 (Cave canem), `m7-04` Q1, Q2 et Q4 (Carpe diem, Alea jacta est, Mens sana), `m9-05` Q3 (l'aigle), `m10-05` Q4 (Ladon), `m12-04` Q1 (SPQR), `m17-04` Q1 (auteur de la Guerre des Gaules), `m20-04` Q2 (Pont du Gard), `m21-04` Q3 (« a Plinio » = par Pline, enseigné seulement au monde 23), `m26-04` Q3 et Q4 (Trajan, Ad astra per aspera).
- **9 arènes sans aucune question de grammaire** : mondes 1, 2, 3, 6, 7, 8, 9, 10 et 11. Les 17 autres en ont au moins une.
- **7 erreurs avérées** et **5 points défendables ou imprécis**.
  - Erreurs : `m4-05` Q1 (énoncé « mangeur/regardeur » et option « Aucun des deux » pour trois choix), `m6-04` Q2 (étymologie de quadrige fausse), `m9-05` Q2 (option « La Scutum » au mauvais genre, « 20 mètres » inventé), `m20-04` Q2 (Pont du Gard « sous Auguste »), `m24-04` Q1 et `m26-04` Q2 (« esse = es / est » au lieu de « être »), `m26-04` Q3 (« de l'Écosse »).
  - Défendables ou imprécis : `m1-06` Q2 (VIIII est attesté), `m9-05` Q3 (aigle « doré », d'abord en argent), `m11-04` Q3 (« réservé aux généraux » non soutenu), `m20-04` Q3 (`quae` est aussi un neutre, au pluriel), `m26-04` Q4 (devise non antique).
- **Défauts de forme** (bonne réponse repérable ou leurres sans intérêt) : `m12-04` Q1, `m23-04` Q2, `m24-04` Q2 (la bonne réponse est la seule à commencer par « Non » ou à contenir « ou »), `m6-04` Q1 et Q3, `m13-04` Q2, `m16-04` Q2, `m18-04` Q3.
- **Propositions** : 17 remplacements prêts à recopier dans 14 arènes (mondes 1, 2, 3, 6, 7 x3, 8, 9, 10, 11, 12, 17, 20, 21, 26 x2), des corrections de questions existantes qui gardent leur place (mondes 1, 4, 6, 9, 20, 24, 26), 3 retouches facultatives (mondes 23 x2 et 25). Après remplacement : plus aucune question « jamais enseignée » ni aucune arène sans grammaire.

Les 26 arènes du jeu exporté (`ludus_latinus_dataset.json`) sont identiques à celles des fichiers `content/monde*.py` (82 énoncés et toutes les options retrouvés).

Les notions de grammaire de chaque monde sont tirées de leurs leçons : voir le titre de chaque section.


Méthode : pour chaque question, j'ai relu le texte des leçons du monde et des mondes précédents (jeu exporté `ludus_latinus_dataset.json`, vérifié sur `content/monde*.py`). « Enseignée » veut dire : la notion demandée est écrite dans le cours ou dans l'exercice de la leçon citée. Une notion seulement citée, sans traduction ni explication, compte comme « jamais ».

Les réponses sont mélangées à l'affichage (règle 13 d'`AGENTS.md`), donc l'index de la bonne réponse dans les données compte peu. Je l'ai quand même varié dans mes propositions.

Types : `vocabulaire`, `grammaire` (cas, déclinaison, conjugaison, accord, fonction, construction), `culture`.

---

## Monde 1, `m1-06` : L'Épreuve de Mercure (3 questions)

Notion du monde : salutations, `sum`, alphabet, chiffres romains.

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Que veut dire « Vale » ? | vocabulaire | `m1-02` | oui |
| 2 | Chiffre 9 en chiffres romains | culture | `m1-04` (règle IX = 10 - 1) | oui, voir remarque |
| 3 | Quel animal a sauvé Romulus et Rémus | culture | `m1-05` | oui |

Grammaire : aucune. Toute l'arène est du vocabulaire et de la culture, alors que `m1-03` enseigne `sum`.

Remarques :
- Q1 : l'option « Bon appétit » ne trompe personne. Remplacer par « Merci » ou « À demain » (non enseignés, mais plausibles comme mots de politesse).
- Q2 : « VIIII » est attesté à l'époque romaine (cadrans, inscriptions). Un élève qui l'a vu peut défendre cette réponse. Option corrigée proposée : `VIII`, `IX`, `XI`, `XIX` (bonne réponse : `IX`, index 1).
- Q3 : « sauvé du fleuve » est un raccourci (les jumeaux sont recueillis puis allaités par la louve), mais aucune autre option n'est défendable.

### Remplacement proposé : question 3 (légende, culture) devient une question de grammaire

- **Énoncé** : Comment dit-on « Je suis un ami » en latin ?
- **Options** :
  0. Amice sum.
  1. Amicus vale.
  2. Amicus sum.
  3. Salve amicus.
- **Bonne réponse** : index 2
- **Explication** : « Sum » veut dire « je suis ». « Amice », avec -e, sert à appeler quelqu'un (« ô ami ») ; il ne peut pas être le sujet de la phrase.
- **Enseignée** : `sum` en `m1-03`, `amicus` et le vocatif `amice` en `m1-02`.
- Latin : vocabulaire de `m1-02` et `m1-03` seulement ; la phrase n'est pas dans le cours.

---

## Monde 2, `m2-05` : Le Sphinx de l'Atrium (3 questions)

Notion du monde : la famille, la maison, le verbe en `-t` (il/elle, `m2-03`).

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Que signifie « mater » | vocabulaire | `m2-01` | oui |
| 2 | Sur quoi écrivaient les écoliers | culture | `m2-03` | oui |
| 3 | Que veut dire « Cave canem » | culture | **jamais** : `m2-02` écrit « Cave canem ! » sans le traduire | oui |

Grammaire : aucune.

Remarques :
- Q2 : l'option « rouleaux de papyrus » est un peu défendable pour des écoliers plus grands, mais le cours dit clairement tablette de cire. Je garde.
- Q3 : la traduction n'est nulle part dans le monde. Soit on la met dans `m2-02` (une demi-ligne : « Cave canem = attention au chien »), soit on remplace la question.

### Remplacement proposé : question 3

- **Énoncé** : Dans « Mater in horto scribit », que montre la terminaison -t de « scribit » ?
- **Options** :
  0. Je fais l'action
  1. Il ou elle fait l'action
  2. Plusieurs personnes font l'action
  3. L'action est déjà finie
- **Bonne réponse** : index 1
- **Explication** : -t marque « il » ou « elle » : « scribit » = elle écrit. Avec « scribo », on dirait « j'écris ».
- **Enseignée** : `m2-03` (scribo, scribit, legit) ; `mater` en `m2-01`, `in horto` en `m2-02`.

---

## Monde 3, `m3-05` : Le Minotaure du Labyrinthe (3 questions)

Notion du monde : dieux et légendes. Le monde 3 n'a aucune règle de grammaire nouvelle.

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Quel dieu est maître de la foudre | culture | `m3-01` | oui |
| 2 | Pourquoi les ailes d'Icare ont fondu | culture | `m3-03` | oui |
| 3 | En quoi Méduse transformait | culture | `m3-04` | oui |

Grammaire : aucune.

Remarques :
- Q1 : « Apollon » n'est pas dans le cours, c'est un leurre acceptable.
- Q2 : la réponse est presque mot pour mot dans le cours (« ni trop haut près du soleil »). Acceptable pour une arène de révision.

### Remplacement proposé : question 1 (la plus générique), en reprise de `m2-03`

Comme le monde 3 n'enseigne pas de grammaire, la seule notion possible est une reprise du verbe en -t.

- **Énoncé** : Quelle phrase veut dire « Midas lit » ?
- **Options** :
  0. Midas lego.
  1. Midas scribit.
  2. Midas legit.
  3. Midas sum.
- **Bonne réponse** : index 2
- **Explication** : « legit » = il lit (-t = il ou elle). « Lego » = je lis, « scribit » = il écrit.
- **Enseignée** : `m2-03` ; `Midas` apparaît en `m3-02`.
- À valider par l'enseignant : voir décision D3 en fin de document (on peut préférer ajouter une notion de grammaire au monde 3 plutôt qu'une reprise).

---

## Monde 4, `m4-05` : Le Lion de Némée (3 questions)

Notion du monde : nominatif, accusatif en -m, ordre des mots libre.

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Dans « Lupus agnum videt », qui est le sujet | grammaire | `m4-01`, `m4-04` | **non** (énoncé fautif) |
| 2 | Terminaison du COD singulier | grammaire | `m4-03` | oui |
| 3 | Traduction de « Puella rosam amat » | grammaire | `m4-03` (règle), `amat` en `m3-02` | oui |

Grammaire : oui, trois questions sur trois.

Erreurs et défauts :
- Q1 : le mot « mangeur/regardeur » est faux (le loup ne mange rien dans la phrase, il voit). L'option « Aucun des deux » parle de deux choix alors qu'il y en a trois. La phrase est celle du cours : l'élève répond de mémoire.
- Q3 : trois options sur quatre sont absurdes (« La rose est rouge »), seule l'inversion est plausible. « cueille » n'est pas enseigné.

### Corrections proposées (pas de nouvelle question, même nombre)

**Question 1 réécrite** (phrase nouvelle, plus de « mangeur »)
- **Énoncé** : Dans « Rosam puella videt », quel mot est le sujet ?
- **Options** :
  0. Rosam
  1. Videt
  2. Puella
  3. Impossible à dire
- **Bonne réponse** : index 2
- **Explication** : « Puella » est au nominatif : c'est le sujet. « Rosam » porte un -m : c'est le COD. L'ordre ne décide pas.
- **Enseignée** : `m4-01`, `m4-02`, `m4-03`.

**Question 3, options réécrites** (même énoncé, un 2 x 2 sujet/verbe)
- **Options** :
  0. La rose voit la jeune fille
  1. La rose aime la jeune fille
  2. La jeune fille aime la rose
  3. La jeune fille voit la rose
- **Bonne réponse** : index 2
- **Explication** : « Puella » est le sujet, « rosam » (avec -m) est le COD, « amat » veut dire « aime ».

---

## Monde 5, `m5-05` : L'Hydre de Lerne (3 questions)

Notion du monde : `esse` au présent, verbes en -are, terminaisons -t et -nt.

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Que signifie « sumus » | grammaire (conjugaison) | `m5-01` | oui |
| 2 | Terminaison de « ils / elles » | grammaire | `m5-02`, `m5-03` | oui |
| 3 | Que signifie « vincit » | vocabulaire | `m5-03` | oui |

Grammaire : oui (Q1 et Q2). Rien à remplacer.

Remarques :
- Q2 : l'explication dit « exactement comme en français (ils aiment) ». En français on écrit -ent, pas -nt : la comparaison est approximative. Suggestion : retirer « exactement comme en français ».
- Q3 : « Il voit » (`videt`) est un bon leurre, vu au même monde.

---

## Monde 6, `m6-04` : Le Champion du Colisée (4 questions)

Notion du monde : gladiateurs, courses de chars, verbe en -nt (`m6-03`, « ils saluent »).

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Gladiateur au grand bouclier et casque à crête | culture | `m6-01` | oui |
| 2 | Nom du char à quatre chevaux | vocabulaire | `m6-02` (quadrige) | **non** (explication fausse) |
| 3 | Spectateurs du Circus Maximus | culture | `m6-02` (« plus de 150 000 ») | oui |
| 4 | Que veut dire « Ave Caesar » | vocabulaire | `m6-03` | oui |

Grammaire : aucune.

Erreurs et défauts :
- Q2 : l'explication dit « de quadri- = quatre et jumentum ». C'est faux : `quadriga` vient de `quadriiugae`, de `quattuor` (quatre) et `iugum` (le joug). `jumentum` veut dire « bête de somme ». Explication corrigée : « Un quadrige : quadri- = quatre, et le joug qui attelle les chevaux. »
- Q1 : « Le Chariot » et « L'Archer » ne sont pas des gladiateurs ; il reste deux vrais choix. Le Thrace est dans le cours et ferait un meilleur leurre. Options proposées : `Le Rétiaire`, `Le Thrace`, `Le Mirmillon`, `Le Cocher` (bonne réponse : index 2).
- Q3 : « 500 personnes » ne trompe personne. Si on la garde : `Environ 15 000`, `Plus de 150 000`, `Environ 50 000` (le Colisée, vu en `m6-01`), `Environ 5 000`.

### Remplacement proposé : question 3 (chiffre de culture) devient une question de grammaire

- **Énoncé** : Quelle phrase veut dire « Les Romains saluent » ?
- **Options** :
  0. Romanus salutant.
  1. Romani salutat.
  2. Romani salutant.
  3. Romanus salutat.
- **Bonne réponse** : index 2
- **Explication** : « Romani » est le pluriel de « Romanus », et le verbe prend -nt quand ils sont plusieurs : « salutant ».
- **Enseignée** : `Romani` en `m5-01`, -nt en `m5-02`, `salutant` en `m6-03`.

---

## Monde 7, `m7-04` : Le Grand Défi du Sénat (4 questions)

Notion du monde : étymologie, préfixes (sub-, trans-, post-, circum-), « Veni, vidi, vici » (passé).

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Sens de « Carpe diem » | culture | **jamais** | oui |
| 2 | Sens de « Alea jacta est » | culture | **jamais** | oui, voir remarque |
| 3 | Mot latin qui a donné « manuel » (manus) | vocabulaire | `m7-01` | oui |
| 4 | Sens de « Mens sana in corpore sano » | culture | **jamais** | oui |

Grammaire : aucune (la formation des mots avec les préfixes est du vocabulaire).

Remarques :
- Trois questions sur quatre sortent du monde. C'est le pire cas des 26 arènes.
- Q2 : « Les dés sont jetés » est la traduction courante ; le mot à mot est « le dé est jeté ». Aucun risque pour l'élève.
- Q3 : « Oculus » n'est pas dans le cours, mais « Pater » et « Lupus » sont connus : leurre correct.

### Remplacements proposés : questions 1, 2 et 4

**R1 (remplace « Carpe diem »)** : vocabulaire, étymologie
- **Énoncé** : Quel mot latin a donné « pédestre » et « pédicure » ?
- **Options** :
  0. Aqua (l'eau)
  1. Terra (la terre)
  2. Manus (la main)
  3. Pes (le pied)
- **Bonne réponse** : index 3
- **Explication** : « Pes, pedis » veut dire « le pied ». On le retrouve dans pédestre, pédicure, bipède.
- **Enseignée** : `m7-01` (pes, pedis ; piéton, pédale, bipède).

**R2 (remplace « Alea jacta est »)** : grammaire, présent et passé
- **Énoncé** : Quelle forme veut dire « il vainc » (au présent) ?
- **Options** :
  0. Vici
  1. Vidi
  2. Vincit
  3. Videt
- **Bonne réponse** : index 2
- **Explication** : « Vincit » finit par -t : c'est « il vainc ». « Vici » est au passé : « j'ai vaincu ». « Vidi » = j'ai vu, « videt » = il voit.
- **Enseignée** : `vincit` en `m5-03`, `vici` et `vidi` en `m7-03`.

**R3 (remplace « Mens sana »)** : vocabulaire, préfixe
- **Énoncé** : Que veut dire le préfixe TRANS- dans « transpercer » ?
- **Options** :
  0. Sous
  1. Après
  2. À travers
  3. Autour
- **Bonne réponse** : index 2
- **Explication** : TRANS- veut dire « à travers, au-delà » : transpercer, c'est percer de part en part.
- **Enseignée** : `m7-02` (sub- = sous, trans- = à travers, post- = après, circum- = autour).

Décision pour l'enseignant : voir D1 (garder les devises amusantes en les enseignant).

---

## Monde 8, `m8-05` : Bacchus le Maître des Festins (3 questions)

Notion du monde : marché, thermes, **génitif** (`m8-03`, `m8-04`).

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Que signifie « aqua » | vocabulaire | `m3-02`, `m7-01`, `m8-01` | oui |
| 2 | Instrument pour racler la peau aux thermes | culture | `m8-03` (strigile) | oui |
| 3 | Que signifie « pecunia » | vocabulaire | `m8-01` | oui |

Grammaire : aucune, alors que le monde enseigne le génitif.

Remarques :
- Q3 : « Le bétail » est un bon leurre (pecunia vient de pecus), pas défendable comme réponse.
- Q2 : le cours ne dit pas « de métal », mais c'est exact (bronze) et ne change pas la réponse.
- Q1 est la question la plus faible : le mot a déjà été vu trois fois et il est dans le titre de la leçon `m8-01`.

### Remplacement proposé : question 1

- **Énoncé** : Quelle phrase veut dire « L'enfant achète le pain du maître » ?
- **Options** :
  0. Puer panem dominum emit.
  1. Puer panem domini emit.
  2. Puer panem dominus emit.
  3. Puer panem domino emit.
- **Bonne réponse** : index 1
- **Explication** : -i est la marque du génitif : « domini » = du maître. « Dominum » serait un COD, « dominus » un sujet.
- **Enseignée** : génitif `domini` en `m8-03` et `m8-04` ; `emit` et `panem` en `m8-02`.
- Note : « domino » (datif, « au maître ») n'est enseigné qu'en `m10-04`. Comme leurre il est exact (il ne veut pas dire « du maître »). Je le garde faute de leurre plus simple ; « dominum » et « domino » sont des formes construites par la règle, pas écrites dans le cours.

---

## Monde 9, `m9-05` : Vercingétorix (3 questions)

Notion du monde : légion, **pluriel** des noms en -a et -us (`m9-03`, `m9-04`).

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Que signifie « miles » | vocabulaire | `m9-01` (titre « Miles »), `m5-04` | oui |
| 2 | Arme : javelot lourd | culture | `m9-01` (pilum) | **non** (option fautive) |
| 3 | Emblème doré des légions | culture | **jamais** (l'aigle n'est cité qu'en `m3-01`, symbole de Jupiter) | oui |

Grammaire : aucune.

Erreurs et défauts :
- Q2 : l'option « La Scutum » est fautive : le cours dit « Le Scutum ». L'élève peut l'éliminer sur le genre. Options corrigées : `Le Gladius`, `Le Pilum`, `Le Scutum`, `La Galea` (bonne réponse : index 1). Les quatre mots sont dans le cours, avec le bon genre.
- Q2 : l'explication dit « lancé à 20 mètres », ce qui n'est pas dans le cours. À retirer (ou à vérifier).
- Q3 : l'emblème « doré » est discutable : l'aigle de légion a d'abord été en argent. Raison de plus pour la remplacer.

### Remplacement proposé : question 3

- **Énoncé** : Quelle phrase veut dire « Les esclaves voient les roses » ?
- **Options** :
  0. Servi rosam vident.
  1. Rosae servos vident.
  2. Servi rosas vident.
  3. Servus rosas vident.
- **Bonne réponse** : index 2
- **Explication** : « Servi » est le sujet pluriel (-i), « rosas » le COD pluriel (-as), « vident » veut dire « ils voient » (-nt). « Rosae servos vident » inverse les rôles (« les roses voient les esclaves »).
- **Enseignée** : `m9-03` (servi, rosas, rosae, servos) et `m9-04` (vident) ; `videt` en `m4-04`.

---

## Monde 10, `m10-05` : Le Dragon Ladon (4 questions)

Notion du monde : monstres, **accord de l'adjectif** (`m10-03`), datif et ablatif (`m10-04`).

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Chien à trois têtes des Enfers | culture | `m10-02` (Cerbère) | oui |
| 2 | Particularité des Cyclopes | culture | `m10-03` | oui |
| 3 | Nom que donne Ulysse au Cyclope | culture | `m10-03` (Nemo) | oui |
| 4 | Ce que protège Ladon | culture | **jamais** : seule l'introduction de l'arène le dit, et elle donne la réponse | oui |

Grammaire : aucune, alors que le monde a deux notions.

Remarques :
- Q4 : l'introduction de l'arène (« garde les pommes d'or divines de l'immortalité ») contient la réponse. La question se résout sans rien savoir.
- Q3 : « Nihil » est un bon leurre (rien).

### Remplacement proposé : question 4

- **Énoncé** : Complète : « La jeune fille aime la grande rose ». Puella rosam ___ amat.
- **Options** :
  0. magnum
  1. magnus
  2. magnam
  3. magna
- **Bonne réponse** : index 2
- **Explication** : « Rosam » est un COD féminin singulier (-am). L'adjectif prend la même terminaison : « magnam ». « Magna » serait un sujet féminin.
- **Enseignée** : `m10-03` (magnus, -a, -um ; accord au COD) ; `puella` et `rosam` en `m4-02`, `m4-03`.

---

## Monde 11, `m11-04` : Le Décurion Étrusque (3 questions)

Notion du monde : héros de la République, `sum` au pluriel (`m11-02`), verbe en -it (`m11-03`), génitif des noms de la 3e déclinaison cités (`pontis`, `militis`).

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Sens de « Civis Romanus sum » | vocabulaire | `m11-02` | oui |
| 2 | Pourquoi Mucius est surnommé « Scaevola » | culture | `m11-02` | oui |
| 3 | Honneur accordé à Cloélie | culture | `m11-03` | oui, voir remarque |

Grammaire : aucune.

Remarques :
- Q1 : la devise est dans le cours avec sa traduction ; l'élève répond de mémoire.
- Q3 : l'explication dit « honneur jusqu'alors réservé aux plus grands généraux ». Le cours ne le dit pas, et l'affirmation est discutable (les sources antiques parlent d'un honneur rare, surtout pour une femme). À retirer : « Les Romains lui élèvent une statue équestre sur la Voie Sacrée. »

### Remplacement proposé : question 3

- **Énoncé** : Quelle phrase veut dire « Vous êtes romains » ?
- **Options** :
  0. Romani sumus.
  1. Romani sunt.
  2. Romani estis.
  3. Romanus es.
- **Bonne réponse** : index 2
- **Explication** : « Estis » veut dire « vous êtes ». « Sumus » = nous sommes, « sunt » = ils sont, « es » = tu es (et « Romanus » est au singulier).
- **Enseignée** : `esse` au présent et `Romani` en `m5-01` ; pluriel `Cives Romani sumus` en `m11-02`.

---

## Monde 12, `m12-04` : Le Tribun de la Plèbe (3 questions)

Notion du monde : **3e déclinaison** (génitif en -is, radical, tableau des cas).

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Que signifient les initiales S.P.Q.R. | culture | **jamais** : seul le titre du monde cite « SPQR », aucune leçon ne le développe | oui |
| 2 | Accusatif singulier de « rex, regis » | grammaire | `m12-02` (tableau) | oui |
| 3 | Nominatif pluriel de « rex » | grammaire | `m12-02` (tableau) | oui |

Grammaire : oui (Q2 et Q3).

Remarques :
- Q1 : forme inégale. Deux options portent une traduction entre parenthèses (dont la bonne), deux n'en ont pas : l'élève peut deviner. Latin des leurres : « Societas Publica Quiritium Romae » n'est pas un latin naturel. Voir D2 pour savoir si on garde SPQR en l'enseignant.
- Q2 et Q3 : les réponses sont dans le tableau du cours. Acceptable pour une arène de révision.

### Remplacement proposé : question 1

- **Énoncé** : Complète : « Le consul donne une loi au chef ». Consul legem ___ dat.
- **Options** :
  0. ducem
  1. duce
  2. duci
  3. ducis
- **Bonne réponse** : index 2
- **Explication** : Le chef reçoit la loi : c'est le datif, en -i. Le radical de « dux, ducis » est duc- : duc + i = duci. « Ducem » serait un COD, « ducis » un génitif.
- **Enseignée** : `dux, ducis` et radical en `m12-01` ; datif -i en `m12-02` ; `dat` en `m12-03`.

---

## Monde 13, `m13-04` : Le Corsaire Carthaginois (3 questions)

Notion du monde : noms en -i (génitif pluriel en -ium), **neutres** (nominatif = accusatif, pluriel en -a).

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Règle d'or des noms neutres | grammaire | `m13-02` | oui |
| 2 | Pluriel neutre de « corpus » | grammaire | `m13-02` | oui |
| 3 | Sens de « Mare Nostrum » | culture | `m13-03` | oui |

Grammaire : oui (Q1 et Q2). Rien à remplacer.

Remarques :
- Q2 : « Corpuses » et « Corpusum » ne tentent personne. Leurres plus plausibles : `Corpori`, `Corpores`, `Corpusa`.
- Q1 : la règle d'or du cours en a deux (nominatif = accusatif, pluriel en -a). La question en retient une seule ; aucune option ne soutient l'autre, donc pas d'ambiguïté.
- Aucune question sur le génitif pluriel en -ium (`m13-01`) : à garder en tête si une arène est refaite.

---

## Monde 14, `m14-04` : Le Centurion Vétéran (3 questions)

Notion du monde : adjectifs de 2e classe (`fortis`), neutre `ingentia`, comparatif et superlatif.

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Suffixe du comparatif de supériorité | grammaire | `m14-03` | oui |
| 2 | Sens de « clarissimus » | grammaire | `m14-03` | oui |
| 3 | Traduction de « Omnia vincit amor » | culture | `m14-02` (citée et traduite) | oui |

Grammaire : oui (Q1 et Q2). Rien à remplacer.

Remarques :
- Q3 : la traduction est dans le cours, mot pour mot. Acceptable.
- Q1 : « -illimus » et « -errimus » sont de vrais suffixes (facillimus, celerrimus) mais non enseignés. Aucune option n'est défendable comme réponse.
- Aucune question sur l'accord de `fortis` (`m14-01`) : à garder en tête si l'on remanie.

---

## Monde 15, `m15-04` : L'Historien Tite-Live (3 questions)

Notion du monde : **imparfait** (-ba-), `eram, eras, erat`.

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Traduction de « pugnabant » | grammaire | `m15-01` (-ba-), `m5-03` (pugnare) | oui |
| 2 | Forme de « esse » pour « il était » | grammaire | `m15-02` | oui |
| 3 | Traduction de « Pueri in schola legebant » | grammaire | `m15-01` (legebam, legebat), `m5-02`, `m2-03` | oui |

Grammaire : oui, trois questions sur trois. Rien à remplacer.

Remarques :
- Q2 : les leurres « Fuit » et « Erit » sont des formes que l'élève ne verra qu'aux mondes 16 et 17. C'est acceptable comme leurre, à condition de ne pas s'en servir pour une question sur le parfait avant ce monde.
- Q3 : le cours donne `legebam`, `legebas`, `legebat`, pas `legebant`. L'élève peut le déduire du modèle `ama-BA-nt`. Cohérent avec la règle « une autre phrase que le cours ».

---

## Monde 16, `m16-04` : Le Gladiateur Invaincu (3 questions)

Notion du monde : **parfait** (-i, -isti, -it, -imus, -istis, -erunt), `fui`.

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Traduction de « Veni, vidi, vici » | grammaire (parfait) | `m16-03` (aussi `m7-03`) | oui |
| 2 | Traduction de « Milites fortiter pugnaverunt » | grammaire | `m16-01` (-erunt), `m5-03` (fortiter) | oui |
| 3 | Forme de « esse » pour « nous avons été » | grammaire | `m16-02` | oui |

Grammaire : oui, trois sur trois. Rien à remplacer.

Remarques :
- Q1 : la phrase est déjà traduite au monde 7 et au monde 16 ; la réponse n'est pas à chercher.
- Q2 : deux leurres sur quatre sont hors sujet (« ont peur du combat », « Le général commande »). Seul « combattront demain » (futur) est plausible. Voir la liste des retouches d'options en fin de document.
- Q3 : bons leurres (`Fuerunt` = ils furent, `Eramus` = nous étions).

---

## Monde 17, `m17-04` : L'Aigle de la Xe Légion (3 questions)

Notion du monde : **futur** (-bo, -bis, -bit ; `ero, eris, erit`), pronom `is, ea, id`, imparfait au singulier.

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Qui a écrit « De Bello Gallico » | culture | **jamais** : aucune leçon ne dit que César a écrit un récit | oui |
| 2 | Traduction de « Cras in Gallia erimus » | grammaire | `m17-01` (erimus) | oui |
| 3 | Où Vercingétorix s'est-il rendu | culture | `m17-03` (siège d'Alésia) | oui |

Grammaire : oui (Q2).

Remarques :
- Q1 : question de culture générale, sans lien avec une leçon. Elle est aussi trop facile (le nom de la leçon donne « César »).
- Q3 : la même réponse (Vercingétorix, Alésia) revient dans l'arène du monde 18 et sert de boss à l'arène du monde 9. Beaucoup de Vercingétorix pour un seul élève.

### Remplacement proposé : question 1

- **Énoncé** : Quelle phrase veut dire « Les Romains combattront » ?
- **Options** :
  0. Romani pugnabant.
  1. Romani pugnabunt.
  2. Romani pugnaverunt.
  3. Romani pugnabit.
- **Bonne réponse** : index 1
- **Explication** : Au futur, on insère -bu- devant -nt (comme « amabunt » = ils aimeront). « Pugnabant » = ils combattaient, « pugnaverunt » = ils ont combattu, « pugnabit » = il combattra (un seul sujet).
- **Enseignée** : futur en `m17-01` ; imparfait en `m15-01` ; parfait en `m16-01` ; `Romani` en `m5-01` ; `pugnare` en `m5-03`.

---

## Monde 18, `m18-04` : Le Consul Suprême (3 questions)

Notion du monde : révision de la 4e (3e déclinaison, imparfait, parfait, génitif).

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Cas de la 3e déclinaison en -is | grammaire | `m12-01` | oui |
| 2 | Quel verbe est à l'imparfait | grammaire | `m15-01` (aussi `m17-01` pour « pugnabit ») | oui |
| 3 | Chef qui a unifié la Gaule | culture | `m17-03` | oui |

Grammaire : oui (Q1 et Q2). Rien à remplacer.

Remarques :
- Q1 : pour une arène de révision de la 4e, elle ne couvre ni le parfait (`m16`) ni le futur (`m17`) en tant que question propre. Acceptable, car Q2 les oppose (« pugnavit », « pugnabit »).
- Q3 : les leurres « Vercassivellaunos », « Ambiorix » et « Dumnorix » sont des noms que l'élève n'a jamais vus ; le seul nom connu est la bonne réponse. Il suffit de reconnaître le nom. Leurres plus utiles : un nom déjà vu dans le jeu, par exemple `Hannibal` (`m13-03`) ou `Porsenna` (`m11-01`).

---

## Monde 19, `m19-04` : L'Architecte Vitruve (3 questions)

Notion du monde : 4e et 5e déclinaisons, datif (`m19-03`).

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Déclinaison de « res, rei » | grammaire | `m19-02` | oui |
| 2 | Sens de « manus » | vocabulaire | `m19-01` (aussi `m7-01`) | oui |
| 3 | Nom de la période de paix d'Auguste | culture | `m19-03` | oui |

Grammaire : oui (Q1). Rien à remplacer.

Remarques :
- Q1 : c'est une question de classement, pas d'emploi. L'arène ne fait jamais décliner un mot de la 4e ni de la 5e. Pas bloquant.
- Q2 : excellents leurres (`La maison` est `domus`, vu dans la même leçon).

---

## Monde 20, `m20-04` : Le Préfet des Voies (3 questions)

Notion du monde : **pronom relatif** (qui, quae, quod, quem, quam).

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | De quoi dépend le cas du relatif | grammaire | `m20-01` (règle d'or) | oui |
| 2 | Aqueduc romain à 3 étages en France | culture | **jamais** (aucune mention du Pont du Gard) | **non** (explication) |
| 3 | Forme du relatif au neutre | grammaire | `m20-01` | oui, voir remarque |

Grammaire : oui (Q1 et Q3).

Erreurs et défauts :
- Q2 : l'explication dit « bâti sous Auguste ». La datation est discutée : les fouilles récentes le placent plutôt vers le milieu du Ier siècle ap. J.-C. À corriger en « bâti au Ier siècle ».
- Q3 : `QUAE` est aussi un neutre (au pluriel : « quae » = les choses qui). L'élève n'a vu que le singulier, mais un élève informé peut défendre deux réponses. Énoncé corrigé : « Quelle forme du pronom relatif est au neutre singulier ? »

### Remplacement proposé : question 2

- **Énoncé** : Complète : « Le soldat que César voit est courageux ». Miles ___ Caesar videt fortis est.
- **Options** :
  0. qui
  1. quam
  2. quod
  3. quem
- **Bonne réponse** : index 3
- **Explication** : « Miles » est masculin singulier, et le relatif est le COD de « videt » : accusatif masculin, « quem ». « Qui » serait le sujet, « quam » conviendrait à un mot féminin, « quod » à un neutre.
- **Enseignée** : `quem` en `m20-01`, COD d'une relative en `m20-02` ; `fortis` en `m14-01`.

---

## Monde 21, `m21-04` : Le Témoin de Pompéi (3 questions)

Notion du monde : **participe parfait passif** et son accord.

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Année de l'éruption du Vésuve | culture | `m21-03` (« 24 août 79 ») | oui |
| 2 | Sur quelle forme est bâti le PPP | grammaire | `m21-01` (supin) | oui |
| 3 | Traduction de « Epistula a Plinio scripta » | grammaire | PPP en `m21-01`, mais « a + ablatif » (par) seulement en **`m23-01`/`m23-02`** : jamais avant ce monde | oui |

Grammaire : oui (Q2), mais Q2 est de la théorie ; aucune question n'applique l'accord du PPP.

Remarques :
- Q3 : l'élève ne connaît pas « a Plinio » = « par Pline » au monde 21. Seul le mot « écrite » est déductible. Les mots `epistula` et `Plinio` ne sont pas non plus vus.
- Q2 : exact selon le cours (le supin donne le radical du PPP).

### Remplacement proposé : question 3

- **Énoncé** : Quelle phrase veut dire « L'ennemi a été vaincu » ?
- **Options** :
  0. Hostis victa est.
  1. Hostis victum est.
  2. Hostis victus est.
  3. Hostis victi sunt.
- **Bonne réponse** : index 2
- **Explication** : « Hostis » est masculin : le participe prend -us, « victus ». « Victa » serait féminin, « victum » neutre, et « sunt » parlerait de plusieurs ennemis.
- **Enseignée** : PPP et accord en `m21-01` et `m21-02` ; `hostis` (m.) en `m13-01` ; `victus` en `m21-01`.

---

## Monde 22, `m22-04` : Le Rhéteur Quintilien (3 questions)

Notion du monde : **ablatif absolu** (avec participe, puis sans participe).

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Traduction de « Hostibus victis » | grammaire | `m22-01`, `m22-02` ; `hostibus` en `m12-02` ; `victis` en `m21-01` | oui |
| 2 | Sens de « Cicerone consule » | grammaire | `m22-03` | oui |
| 3 | Pourquoi « absolue » | grammaire | `m22-01` (absolutus = détaché) | oui |

Grammaire : oui, trois sur trois. Rien à remplacer.

Remarques :
- Q2 : la tournure est dans le cours mot pour mot. L'élève répond de mémoire.
- Q1 : bon travail de reconnaissance (deux mots à l'ablatif). Les leurres sont plausibles.

---

## Monde 23, `m23-04` : Le Procureur du Barreau (3 questions)

Notion du monde : **voix passive** (-tur, -ntur) et complément d'agent.

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Traduction de « Milites a duce laudantur » | grammaire | `m23-01`, `m23-02` | oui, mais phrase déjà traduite |
| 2 | Préposition du complément d'agent | grammaire | `m23-01`, `m23-02` | oui, forme à égaliser |
| 3 | Plus grand orateur de Rome | culture | `m23-03` (Cicéron) | oui |

Grammaire : oui (Q1 et Q2).

Défauts :
- Q1 : la phrase est celle de l'exercice `m23-02` (« Fortes milites a duce laudantur », traduite par sa solution) moins un mot. L'élève a vu la réponse juste avant. Pas fausse, mais à renouveler.
- Q2 : seule la bonne réponse contient « ou » (« A ou AB »), les trois autres sont de la forme `MOT (+ cas)`. Elle se repère à la forme.

Aucun remplacement obligatoire (les trois questions sont enseignées et la grammaire est présente). Deux retouches proposées, à valider.

### Retouche A : question 1 avec une phrase nouvelle

- **Énoncé** : Quelle phrase veut dire « Le citoyen est loué par le consul » ?
- **Options** :
  0. Civis consulem laudat.
  1. Consul civem laudatur.
  2. Civis a consule laudatur.
  3. Consul a cive laudatur.
- **Bonne réponse** : index 2
- **Explication** : « Civis » est le sujet ; « laudatur » (-tur) est le passif ; « a consule » = par le consul. La phrase 3 inverse les rôles (« le consul est loué par le citoyen »).
- **Enseignée** : `m23-01` (laudatur, a + ablatif), `m23-02` (laudo), `m12-02` (consule, civem), `m13-01` (civis).

### Retouche B : question 2, options de même forme

- **Options** :
  0. AD ou APUD (+ accusatif)
  1. A ou AB (+ ablatif)
  2. CUM ou SINE (+ ablatif)
  3. PRO ou PRAE (+ ablatif)
- **Bonne réponse** : index 1 (explication inchangée : « A devant consonne, AB devant voyelle, suivi de l'ablatif »).

---

## Monde 24, `m24-04` : Le Greffier Impérial (3 questions)

Notion du monde : **proposition infinitive** (sujet à l'accusatif, verbe à l'infinitif, pas de « que »).

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Traduction de « Scio te bonum discipulum esse » | grammaire | `m24-01`, `m24-02` ; « te » jamais expliqué | **non** (explication fautive) |
| 2 | Y a-t-il un mot pour « que » | grammaire | `m24-01` | oui, forme à égaliser |
| 3 | Cas du sujet d'une infinitive | grammaire | `m24-01`, `m24-02` | oui |

Grammaire : oui, trois sur trois. Aucun remplacement obligatoire.

Défauts :
- Q1 : l'explication dit « esse = es (Infinitif) ». C'est faux : « esse » est l'infinitif, il veut dire « être » ; « es » est « tu es ». Le pronom « te » (accusatif de « tu ») n'est expliqué nulle part dans le jeu (il n'apparaît que dans la devise « Ave Caesar, morituri te salutant »).
- Q2 : trois options commencent par « Oui », la bonne par « Non » : elle se repère à la forme.
- Q3 : redite de Q1 et de la question du quiz `m24-01`. Trois questions sur la même règle.

### Corrections proposées (même nombre de questions)

**Question 1 réécrite** (sans « te »)
- **Énoncé** : Comment se traduit « Scio Marcum bonum discipulum esse » ?
- **Options** :
  0. Je sais que Marcus était un bon élève
  1. Marcus sait que je suis un bon élève
  2. Je sais que Marcus est un bon élève
  3. Je sais que Marcus sera un bon élève
- **Bonne réponse** : index 2
- **Explication** : « Scio » = je sais (que). « Marcum » est à l'accusatif : c'est le sujet de l'infinitive. « Esse » est l'infinitif présent (« être »), qui indique la même époque que « scio » : « est ».
- **Enseignée** : `m24-01`, `m24-02` (infinitif présent, même moment : `m24-03`) ; `Marcus` en `m1-03`, `discipulus` en `m2-03`, `bonus` en `m10-03`.

**Question 2, options égalisées**
- **Énoncé** : Quel mot latin traduit le « que » d'une proposition infinitive ?
- **Options** :
  0. Quod, placé avant le sujet
  1. Ut, placé avant le verbe
  2. Aucun, la structure suffit
  3. Quem, placé avant le verbe
- **Bonne réponse** : index 2
- **Explication** : Le latin n'emploie aucun mot de liaison : sujet à l'accusatif + verbe à l'infinitif suffisent (`m24-01`).

---

## Monde 25, `m25-04` : La Muse Calliope (3 questions)

Notion du monde : Virgile et Ovide, subjonctif de souhait de `esse` (`sit`), enclitique `-que`.

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Héros troyen chanté par Virgile | culture | `m25-01` (Énée) | oui |
| 2 | Auteur des Métamorphoses et de l'Art d'aimer | culture | `m25-02` (Ovide, Métamorphoses) | oui |
| 3 | Sens de « -que » dans « virumque » | grammaire | `m25-03` | oui |

Grammaire : oui, mais une seule question (Q3). Le subjonctif de souhait (`m25-02`) n'est pas interrogé. Je ne propose pas de remplacement, car la condition (au moins une question de grammaire sur la notion du monde) est remplie par Q3.

Remarques :
- Q2 : « L'Art d'aimer » n'est cité dans aucune leçon du monde, seulement dans la correction d'une mauvaise réponse du quiz `m25-01`. L'identification d'Ovide par les « Métamorphoses » suffit.
- Q3 : l'explication cite « SPQR : Senatus Populus-que ». SPQR n'est enseigné nulle part (voir monde 12) : un élève ne peut pas s'appuyer dessus. Conseil : retirer cette référence ou écrire « comme dans virumque ».

### Option (facultative) : question 2 remplacée par une question sur le subjonctif

À prendre si l'enseignant veut que le subjonctif de `m25-02` soit interrogé. Elle remplace Q2 (identification d'un auteur).
- **Énoncé** : Quelle phrase veut dire « Que l'ami soit heureux ! » ?
- **Options** :
  0. Amicus felix est !
  1. Amicus felix sum !
  2. Amicus felix sit !
  3. Amicus felix sis !
- **Bonne réponse** : index 2
- **Explication** : « Sit » est le subjonctif de « esse » (si- + -t) : il exprime un souhait. « Est » dit seulement « il est », « sis » = que tu sois, « sum » = je suis.
- **Enseignée** : `m25-02` (sis, sit) ; `amicus` en `m1-02`.

---

## Monde 26, `m26-04` : L'Empereur Trajan (4 questions)

Notion du monde : synthèse du cycle 4 (déclinaisons, temps, constructions).

| n° | Question | Type | Enseignée où | Juste |
|---|---|---|---|---|
| 1 | Nombre de déclinaisons | grammaire | `m26-01` (liste des 5) | oui |
| 2 | Traduction de « Scio urbem magnam esse » | grammaire | `m24-01`, `m24-02` ; `urbem` en `m21-03` ; `magnam` en `m10-03` | **non** (explication fautive) |
| 3 | Empereur de la plus grande étendue | culture | **jamais** : Trajan n'est cité que dans l'introduction de l'arène | **non** (explication) |
| 4 | Sens de « Ad astra per aspera » | culture | **jamais** | à écarter |

Grammaire : oui (Q1 et Q2).

Erreurs et défauts :
- Q2 : l'explication dit « esse = est (Infinitif) ». Faux : « esse » veut dire « être ». Même faute qu'au monde 24.
- Q3 : l'explication dit « de l'Écosse à la Mésopotamie ». Sous Trajan, l'empire ne comprenait pas l'Écosse (la frontière est dans le nord de l'Angleterre). À corriger en « de la Bretagne à la Mésopotamie ».
- Q4 : « Ad astra per aspera » n'est pas une devise de l'Antiquité romaine (aphorisme moderne, d'origine incertaine). Un cours de latin ne peut pas la présenter comme telle.
- Q1 : exacte mais très facile (le cours `m26-01` donne la liste).

### Remplacements proposés : questions 3 et 4

**R1 (remplace Trajan)** : grammaire, accord du verbe avec deux sujets
- **Énoncé** : Complète : « Le poète et le consul protègent la patrie ». Poeta et consul patriam ___.
- **Options** :
  0. servat
  1. servas
  2. servant
  3. servamus
- **Bonne réponse** : index 2
- **Explication** : Deux sujets (« le poète » et « le consul ») : le verbe se met au pluriel, en -nt. « Servat » ne convient qu'à un seul sujet.
- **Enseignée** : deux sujets et -nt en `m26-03` ; -nt en `m5-02` ; `servare` en `m18-02` ; `poeta` en `m25-02` ; `consul` en `m12-01` ; `patriam` en `m18-02`.

**R2 (remplace « Ad astra per aspera »)** : grammaire, les temps
- **Énoncé** : Quelle forme de « servare » veut dire « il a sauvé » ?
- **Options** :
  0. Servat
  1. Servavit
  2. Servabat
  3. Servabit
- **Bonne réponse** : index 1
- **Explication** : « Servavit » est au parfait (-v- puis -it, comme « amavit »). « Servat » = il sauve (présent), « servabat » = il sauvait (imparfait), « servabit » = il sauvera (futur).
- **Enseignée** : tableau des quatre temps en `m26-01` ; parfait en `m16-01` ; `servavi` en `m18-02` ; imparfait en `m15-01` ; futur en `m17-01`.

Si l'enseignant tient à garder une question de culture dans l'arène finale, voir D5.

**Correction à faire sur Q2** (même nombre de questions) : explication proposée : « C'est une proposition infinitive : scio = je sais (que), urbem magnam = la grande ville (accusatif), esse = être (infinitif), d'où "la ville est grande". »

---

## Points qui demandent une décision de l'enseignant

**D1. Enseigner les devises et les faits plutôt que remplacer les questions.** Douze questions portent sur un fait qui n'est écrit dans aucune leçon (Carpe diem, Alea jacta est, Mens sana, SPQR, Cave canem, l'aigle de légion, Ladon, Pont du Gard, César auteur, Trajan). Deux façons de corriger : (a) remplacer la question, comme proposé ; (b) ajouter une ligne au cours pour que la question devienne légitime. Option (b) est plus riche pour l'élève mais ajoute du texte à des leçons déjà longues. Quatre candidats naturels : `m7-03` (trois devises à côté de « Veni, vidi, vici »), `m2-02` (« Cave canem = attention au chien »), `m9-01` (l'aigle de la légion, à côté du scutum et du pilum), `m12-03` (SPQR). Dans ce cas, les questions d'origine restent bonnes et mes remplacements sont facultatifs.

**D2. Questions de culture amusantes à conserver.** Carpe diem, Alea jacta est et Mens sana plaisent aux élèves (ce sont des phrases qu'on retrouve en français). Si on les garde sans les enseigner, on contredit la règle de l'audit. Compromis : les mettre dans le cours (D1) plutôt que dans l'arène seule.

**D3. Monde 3 sans grammaire propre.** Il n'enseigne que des mythes. Ma proposition reprend le verbe en -t du monde 2. Autre choix : ajouter une notion de grammaire au monde 3 (par exemple le `-m` du COD, déjà présent dans « aurum », « panem » sans être expliqué), mais ce serait une nouvelle leçon.

**D4. Portée d'une arène.** J'ai accepté une question enseignée « dans le monde ou dans un monde précédent », comme demandé. Conséquence à valider : quand un monde n'a pas de grammaire propre (monde 3), la question de grammaire est une reprise d'un monde précédent. Autre point : plusieurs questions redemandent ce que le quiz d'ouverture du même monde a déjà posé (`m24-04` Q3, `m25-04` Q2, `m19-04` Q1). C'est de la révision, mais l'élève voit deux fois la même question.

**D5. L'arène finale du cycle 4 (`m26-04`).** Le boss est Trajan, mais aucune leçon ne parle de lui. Je remplace sa question par de la grammaire. Si l'enseignant veut une question sur Trajan, il faut d'abord ajouter une ligne dans `m26-01` (« Sous Trajan, en 117, l'empire atteint sa plus grande étendue, de la Bretagne à la Mésopotamie ») ; la question corrigée devient alors légitime.

**D6. Trois arènes très redondantes sur Vercingétorix** (`m9-05` en boss, `m17-04` Q3 et `m18-04` Q3). Je propose de garder `m17-04` et `m18-04` et de laisser la décision sur `m9-05` (boss) à l'enseignant.

**D7. Retouches d'options à décider en bloc** (travail du défaut 5 de l'audit, non fait ici sauf mention) : `m6-04` Q1 (leurres Chariot et Archer), `m13-04` Q2 (Corpuses, Corpusum), `m16-04` Q2 (deux leurres absurdes), `m18-04` Q3 (noms de chefs gaulois jamais vus), `m1-06` Q1 (« Bon appétit »), `m4-05` Q3. Je ne propose du texte que pour `m1-06`, `m4-05`, `m6-04`.

**D8. Arènes qui n'interrogent pas toutes les notions du monde.** Monde 13 (génitif pluriel en -ium), monde 14 (accord de `fortis`), monde 18 (parfait, futur), monde 19 (accusatif et datif des 4e et 5e déclinaisons), monde 25 (subjonctif). Ce n'est pas une erreur, la condition de l'audit est remplie. Si on veut aller plus loin, il faudrait allonger les arènes à 4 questions.
