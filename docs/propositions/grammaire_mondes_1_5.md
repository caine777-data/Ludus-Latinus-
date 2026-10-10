# Deuxième question de grammaire : mondes 1 à 5

Brouillon pour validation par Cédric (audit des leçons, défaut 3). Chaque leçon de cours des mondes 1 à 5 reçoit une question de grammaire posée après l'exercice principal : 21 leçons (les 5 arènes sont exclues). Chaque bloc `grammaire` est prêt à recopier dans la leçon. Les questions portent sur une autre phrase que le modèle du cours et l'exercice. Le vocabulaire vient du monde ou des mondes précédents ; quand un mot est plus récent, sa traduction est dans l'énoncé. Les mauvaises options viennent d'erreurs réelles (terminaison, personne, rôle inversé). Les explications font 20 mots au plus et ne donnent jamais la bonne réponse. Huit leçons n'enseignent aucune règle de grammaire : la question reprend alors la dernière règle vue, et le titre le dit (« REPRISE »).

---

## m1-01 · L'Alphabet secret des Romains

Règle de la leçon : le V se prononce [OU] ou [W], le C toujours [K] (règle de prononciation).
Déjà utilisé dans le cours et l'exercice : *Circus* (C = K), *villa* (« ouilla »), *Caesar* (« Késar »).

```python
"grammaire": {
    "question": "Comment les Romains prononçaient-ils le mot 'via' (la route) ?",
    "options": ["Vi-a, avec le son [V]", "Oui-a, avec le son [OU]", "Bi-a, avec le son [B]", "Fi-a, avec le son [F]"],
    "answer": 1,
    "explications": [
        "C'est la façon de lire le V en français moderne, pas celle des Romains.",
        "",
        "B et V étaient deux lettres différentes : le V ne se prononçait pas comme un B.",
        "Le F est une autre lettre, avec son propre son. Le V ne se lisait pas comme lui.",
    ],
},
```

## m1-02 · Saluer comme un Romain

Règle de la leçon : *salve* pour une personne, *salvete* pour plusieurs ; *vale* pour dire au revoir.
Déjà utilisé dans le cours et l'exercice : *Salve, amice !*, *salve*, *salvete*, *vale*.

```python
"grammaire": {
    "question": "Tu arrives devant trois amis et tu veux leur dire bonjour. Que dis-tu ?",
    "options": ["Salve !", "Vale !", "Salvete !", "Amice !"],
    "answer": 2,
    "explications": [
        "Ce bonjour s'adresse à une seule personne. Ici, tu parles à un groupe.",
        "Ce mot sert à dire au revoir, pas bonjour.",
        "",
        "C'est le mot pour appeler un seul ami (« ô ami »). Ce n'est pas une salutation de groupe.",
    ],
},
```

## m1-03 · Se présenter : Comment t'appelles-tu ?

Règle de la leçon : *sum* = « je suis ».
Déjà utilisé dans le cours et l'exercice : *Discipulus sum*, *Romanus sum*, *Nomen mihi est Marcus*. À éviter aussi (arène du monde) : *Amicus sum*.

```python
"grammaire": {
    "question": "Que veut dire « Magister sum. » ? (magister = le maître d'école)",
    "options": ["Tu es le maître d'école.", "Il est le maître d'école.", "Nous sommes les maîtres d'école.", "Je suis le maître d'école."],
    "answer": 3,
    "explications": [
        "Sum ne s'adresse pas à l'autre personne : la forme de « tu » est différente.",
        "Sum ne parle pas d'une troisième personne : la forme de « il » est différente.",
        "Sum est au singulier : il ne peut pas parler d'un groupe de personnes.",
        "",
    ],
},
```

## m1-04 · Les Chiffres Romains Mystérieux

Règle de la leçon : une lettre après s'ajoute, une lettre avant se soustrait (règle de calcul, pas de grammaire à proprement parler).
Déjà utilisé dans le cours et l'exercice : VI, XII, IV, IX, XIV. Dans l'arène : IX et ses pièges VIII, XI, XIX.

```python
"grammaire": {
    "question": "Combien vaut le nombre romain XIX ?",
    "options": ["19", "21", "9", "11"],
    "answer": 0,
    "explications": [
        "",
        "Tu as tout additionné : X + I + X. Un I placé avant un chiffre plus grand se soustrait.",
        "Tu as oublié le X du début, qui vaut dix de plus.",
        "Tu as oublié le dernier X. Les trois lettres comptent toutes.",
    ],
},
```

## m1-05 · La Légende : Romulus, Rémus et la Louve : REPRISE (sum, m1-03)

Règle de la leçon : aucune (récit de la légende). Reprise de *sum*.
Déjà utilisé dans le cours et l'exercice : *Lupa pueros curat*. Pas de phrase avec *sum* dans cette leçon.

```python
"grammaire": {
    "question": "Complète pour dire « Je suis une louve » : Lupa ___ .",
    "options": ["sum", "curat", "vale", "salve"],
    "answer": 0,
    "explications": [
        "",
        "Ce verbe est celui de la légende : il veut dire « soigne », pas « je suis ».",
        "Ce mot sert à dire au revoir. Il n'exprime pas ce que l'on est.",
        "Ce mot sert à dire bonjour. Il n'exprime pas ce que l'on est.",
    ],
},
```

## m2-01 · La Famille Romaine : REPRISE (salve et salvete, m1-02)

Règle de la leçon : aucune (liste de vocabulaire). Reprise des salutations.
Déjà utilisé dans le cours et l'exercice : *pater, mater, filius, filia, frater, soror*, aucune phrase.

```python
"grammaire": {
    "question": "Tu entres dans la domus et tu vois ta sœur, seule. Quelle salutation est correcte ?",
    "options": ["Salvete, soror !", "Salve, soror !", "Vale, soror !", "Sum, soror !"],
    "answer": 1,
    "explications": [
        "Cette forme s'adresse à plusieurs personnes, or ta sœur est seule.",
        "",
        "Ce mot se dit en partant, pas en arrivant.",
        "Ce mot veut dire « je suis ». Ce n'est pas une salutation.",
    ],
},
```

## m2-02 · Les Animaux de compagnie : REPRISE (structure « X in horto est »)

Règle de la leçon : aucune règle de grammaire ; la leçon montre seulement la structure « sujet + in + lieu + est ». La question la reprend avec un autre animal.
Déjà utilisé dans le cours et l'exercice : *Canis in horto est*, *Felis in horto est*.

```python
"grammaire": {
    "question": "Que veut dire « Avis in horto est. » ?",
    "options": ["L'oiseau est dans la maison.", "Le chien est dans le jardin.", "L'oiseau est près du jardin.", "L'oiseau est dans le jardin."],
    "answer": 3,
    "explications": [
        "Le mot horto désigne le jardin. Il ne désigne pas la maison.",
        "Regarde le premier mot : ce n'est pas celui du chien.",
        "Le petit mot in veut dire « dans ». Il ne veut pas dire « près de ».",
        "",
    ],
},
```

## m2-03 · L'École Romaine (Schola)

Règle de la leçon : le verbe finit par -T quand il ou elle fait l'action (*scribit*, *legit*) ; *-o* pour « je ».
Déjà utilisé dans le cours et l'exercice : *scribo/scribit*, *lego*, *Discipulus in tabula legit*. Dans l'arène : *Mater in horto scribit*.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « Le père écrit » ?",
    "options": ["Pater scribit.", "Pater scribo.", "Pater legit.", "Pater lego."],
    "answer": 0,
    "explications": [
        "",
        "La terminaison -o veut dire « j'écris ». Pour « il écrit », il faut une autre fin.",
        "Le -t est juste, mais ce verbe ne veut pas dire « écrire ».",
        "Deux erreurs : la terminaison est celle de « je » et le verbe n'est pas le bon.",
    ],
},
```

## m2-04 · Visite de la Domus : L'Atrium et le Péristyle : REPRISE (-t, m2-03)

Règle de la leçon : aucune (vocabulaire de la maison). Reprise de la terminaison -t.
Déjà utilisé dans le cours et l'exercice : *atrium, triclinium, peristylum, insulae*, aucune phrase.

```python
"grammaire": {
    "question": "Complète pour dire « La sœur lit dans l'atrium » : Soror in atrio leg___",
    "options": ["-a", "-o", "-it", "-ere"],
    "answer": 2,
    "explications": [
        "Cette fin ressemble à celle d'un nom féminin comme filia, pas à celle d'un verbe qui dit « elle ».",
        "Cette terminaison veut dire « je lis », or c'est la sœur qui lit.",
        "",
        "C'est la forme du dictionnaire (legere, lire). Elle ne dit pas qui fait l'action.",
    ],
},
```

## m3-01 · Le Panthéon Romain : REPRISE (-t et -o, m2-03)

Règle de la leçon : aucune (noms des dieux). Reprise des terminaisons du verbe.
Déjà utilisé dans le cours et l'exercice : noms des dieux seulement, aucune phrase.

```python
"grammaire": {
    "question": "Que veut dire « Mars legit. » ?",
    "options": ["Mars écrit.", "Moi, j'écris.", "Moi, je lis.", "Mars lit."],
    "answer": 3,
    "explications": [
        "Tu as confondu lire et écrire : relis les deux verbes de la leçon de l'école.",
        "Double erreur : le verbe n'est pas le bon et le -t ne désigne pas celui qui parle.",
        "Le verbe est bon, mais le -t ne désigne pas celui qui parle.",
        "",
    ],
},
```

## m3-02 · Le Roi Midas et le toucher d'or : REPRISE (-o et -t, m2-03)

Règle de la leçon : aucune (récit, phrase *Midas aurum amat*). Reprise de la terminaison de « je ».
Déjà utilisé dans le cours et l'exercice : *Midas aurum amat*, *Midas panem amat*.

```python
"grammaire": {
    "question": "Midas parle de lui-même. Comment dit-il « J'aime l'or » ? (aurum = l'or, amare = aimer)",
    "options": ["Aurum amat.", "Aurum scribo.", "Aurum amo.", "Aurum legit."],
    "answer": 2,
    "explications": [
        "Le -t désigne une autre personne que celui qui parle.",
        "La terminaison -o est bonne, mais ce verbe ne veut pas dire « aimer ».",
        "",
        "Ce verbe n'est pas le bon, et son -t désigne une autre personne que celui qui parle.",
    ],
},
```

## m3-03 · Le Vol d'Icare : REPRISE (vale et valete, m1-02)

Règle de la leçon : aucune (étymologie du mot *sol*). Reprise de *vale*.
Déjà utilisé dans le cours et l'exercice : *Icarus ad solem volat*.

```python
"grammaire": {
    "question": "Icare quitte son père Dédale, seul, et lui dit au revoir. Que dit-il ? (valete = au revoir à plusieurs personnes)",
    "options": ["Salve !", "Vale !", "Salvete !", "Valete !"],
    "answer": 1,
    "explications": [
        "Ce mot sert à dire bonjour, pas à partir.",
        "",
        "Ce mot dit bonjour à plusieurs personnes : ni le bon moment, ni le bon nombre.",
        "Cet au revoir s'adresse à plusieurs personnes, mais Dédale est seul.",
    ],
},
```

## m3-04 · Méduse la Gorgone et le bouclier miroir : REPRISE (sum, m1-03)

Règle de la leçon : aucune (mythe de Méduse). Reprise de *sum*.
Déjà utilisé dans le cours et l'exercice : aucune phrase latine.

```python
"grammaire": {
    "question": "Minerve dit « Je suis une déesse ». Quelle phrase latine est correcte ? (dea = la déesse)",
    "options": ["Dea sum.", "Dea est.", "Dea vale.", "Dea salve."],
    "answer": 0,
    "explications": [
        "",
        "Cette forme s'emploie pour « il » ou « elle », pas pour celui qui parle de lui.",
        "Ce mot sert à dire au revoir. Il n'exprime pas ce que l'on est.",
        "Ce mot sert à dire bonjour. Il n'exprime pas ce que l'on est.",
    ],
},
```

## m4-01 · Pourquoi le latin change la fin des mots ?

Règle de la leçon : la terminaison (le cas) donne le rôle du mot ; l'ordre des mots est libre. Sujet sans -m, COD avec -m.
Déjà utilisé dans le cours et l'exercice : *Lupus agnum videt*, *Agnum lupus videt*.

```python
"grammaire": {
    "question": "Que veut dire « Lupum agnus videt. » ? (videt = voit)",
    "options": ["Le loup voit l'agneau.", "L'agneau voit le loup.", "Les deux se voient.", "On ne peut pas savoir."],
    "answer": 1,
    "explications": [
        "Tu as lu les mots dans l'ordre du français. En latin, c'est la terminaison qui décide.",
        "",
        "Un seul des deux fait l'action : les terminaisons disent lequel.",
        "Si : la terminaison de chaque nom indique son rôle, même quand l'ordre change.",
    ],
},
```

## m4-02 · Le Sujet : Le Nominatif

Règle de la leçon : le nominatif est le cas du sujet (noms en -a : *puella, rosa, silva*).
Déjà utilisé dans le cours et l'exercice : *Puella cantat*, *Puella in silva ambulat*.

```python
"grammaire": {
    "question": "Dans « In horto filia cantat. » (filia = la fille, cantat = chante), quel mot est le sujet ?",
    "options": ["In", "horto", "filia", "cantat"],
    "answer": 2,
    "explications": [
        "In est un petit mot de lieu (« dans »). Il ne fait jamais l'action.",
        "Ce nom dit où se passe la scène. Il ne fait pas l'action.",
        "",
        "C'est le verbe : il dit l'action, mais ce n'est pas lui qui l'accomplit.",
    ],
},
```

## m4-03 · La Cible de l'Action : L'Accusatif (le COD)

Règle de la leçon : un nom en -a au COD prend un -M (*rosam, puellam, silvam*).
Déjà utilisé dans le cours et l'exercice : *Puer rosam videt*, *Puer silvam videt*. Dans l'arène et le décodeur : *Puella rosam amat*, *Rosam puella videt*, *Puellam lupus videt*.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « Le loup voit la louve » ? (lupa = la louve)",
    "options": ["Lupus lupa videt.", "Lupum lupa videt.", "Lupus lupas videt.", "Lupus lupam videt."],
    "answer": 3,
    "explications": [
        "La louve n'a pas de terminaison de COD : elle ressemble à un sujet, comme le loup.",
        "Les rôles sont inversés : ici, c'est la louve qui voit le loup.",
        "Ajouter un -s est une habitude du français. Ici, le COD prend une autre lettre.",
        "",
    ],
},
```

## m4-04 · Le Décodeur de Cas en action !

Règle de la leçon : on lit le rôle d'un mot à sa fin (sujet, COD en -m, verbe en -t), pas à sa place.
Déjà utilisé dans le cours et l'exercice : *Lupus agnum videt*, *Puellam lupus videt*.

```python
"grammaire": {
    "question": "Dans « Lupam agnus videt. », quel mot est le sujet ?",
    "options": ["Agnus", "Lupam", "Videt", "Impossible à dire"],
    "answer": 0,
    "explications": [
        "",
        "C'est le premier mot, mais sa terminaison -m est celle du COD, celui qui subit l'action.",
        "Le -t montre que c'est le verbe. Il dit l'action sans la faire lui-même.",
        "Si : la terminaison de chaque mot donne son rôle, même quand l'ordre est inhabituel.",
    ],
},
```

## m5-01 · Le Verbe ÊTRE (Esse)

Règle de la leçon : *sum, es, est, sumus, estis, sunt* ; pas besoin de pronom, la terminaison suffit.
Déjà utilisé dans le cours et l'exercice : *Romanus sum*, *Roma magna est*, *Discipuli sunt*, *Romani sumus*.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « Vous êtes élèves » ? (discipuli = élèves)",
    "options": ["Discipuli sumus.", "Discipuli estis.", "Discipuli sunt.", "Discipuli es."],
    "answer": 1,
    "explications": [
        "Cette forme est celle de « nous », pas celle de « vous ».",
        "",
        "Cette forme est celle de « ils » ou « elles », pas celle de « vous ».",
        "Cette forme est celle de « tu », au singulier.",
    ],
},
```

## m5-02 · Les Verbes d'Action (1er groupe en -ARE)

Règle de la leçon : terminaisons du présent des verbes en -ARE (-o, -as, -at, -amus, -atis, -ant).
Déjà utilisé dans le cours et l'exercice : *amo, amas, amat, amamus, amatis, amant*, *Pueri in horto cantant*.

```python
"grammaire": {
    "question": "Quelle forme veut dire « nous travaillons » ? (laborare = travailler)",
    "options": ["Laborant", "Laborat", "Laboramus", "Laboratis"],
    "answer": 2,
    "explications": [
        "Cette forme parle de plusieurs autres personnes (« ils »), pas de « nous ».",
        "Cette forme parle d'une seule autre personne (« il » ou « elle »), pas de « nous ».",
        "",
        "Cette forme s'adresse à plusieurs personnes (« vous »), pas à un groupe dont tu fais partie.",
    ],
},
```

## m5-03 · Combattre et Vaincre : Les Verbes Héroïques

Règle de la leçon : verbe en -t quand un seul agit, en -nt quand plusieurs agissent ; le verbe s'accorde avec le sujet.
Déjà utilisé dans le cours et l'exercice : *Miles fortiter pugnat*, *Romani fortiter pugnant*.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « Les Romains se promènent » ? (ambulare = se promener)",
    "options": ["Romanus ambulat.", "Romani ambulat.", "Romani ambulant.", "Romanus ambulant."],
    "answer": 2,
    "explications": [
        "Le nom et le verbe sont au singulier, alors que la phrase parle de plusieurs Romains.",
        "Le sujet est au pluriel, mais le verbe garde sa terminaison du singulier.",
        "",
        "Le verbe est au pluriel, mais le sujet est au singulier : ils ne s'accordent pas.",
    ],
},
```

## m5-04 · Le Décodeur de l'Attaque !

Règle de la leçon : reconnaître sujet, COD (-m) et verbe (-t) à leur terminaison, même en -a.
Déjà utilisé dans le cours et l'exercice : *Miles gladium capit*, *Agricola amat equum*.

```python
"grammaire": {
    "question": "Dans « Rosam agricola amat. », quel mot est le COD ?",
    "options": ["Agricola", "Amat", "Rosam", "Il n'y en a pas"],
    "answer": 2,
    "explications": [
        "Ce mot finit par -a, mais il fait l'action : il n'en est pas la cible.",
        "C'est le verbe, reconnaissable à son -t. Il dit l'action, il ne la subit pas.",
        "",
        "Si : un mot subit l'action. Cherche la terminaison qui le marque.",
    ],
},
```

---

## Leçons traitées par reprise faute de règle

8 leçons sur 21 : m1-05 (sum), m2-01 (salve et salvete), m2-02 (structure « in horto est »), m2-04 (-t), m3-01 (-t et -o), m3-02 (-o), m3-03 (vale et valete), m3-04 (sum).
Deux autres ne portent pas sur une règle de grammaire au sens strict : m1-01 (prononciation) et m1-04 (calcul des chiffres romains). Je les ai gardées car la leçon enseigne bien une règle.

## Doutes pour l'enseignant

1. **Les mondes 2 et 3 ont très peu de grammaire.** Les reprises répètent trois idées (sum, -t/-o, salve/vale). La vraie solution serait d'ajouter une règle dans le cours de m2-02 ou m3-02 (par exemple l'accusatif de *panem*), pas de multiplier les reprises.
2. **m2-02 et m2-04** : *in horto* et *in atrio* sont à l'ablatif, jamais expliqué avant le monde 6 ou plus. Les élèves n'ont à lire que *in + lieu*, mais le doute est là.
3. **m1-03** : les options « tu es / il est / nous sommes » utilisent des formes qu'on ne voit qu'en m5-01. Elles servent de pièges, les explications n'en disent pas plus.
4. **m3-03** : *valete* n'est donné qu'au Thesaurus ; je l'ai traduit dans l'énoncé, ce qui aide un peu.
5. **m3-04** : l'option *Dea est* utilise *est*, vu seulement en exemple (m2-02).
6. **m4-01, m4-03, m4-04** : *lupum* et *lupam* sont de nouvelles formes à appliquer avec la règle du -m. C'est voulu, mais *lupum* est un accusatif en -um, pas en -m seul : le cours ne l'a pas dit pour la 2e déclinaison.
7. **m4-02** : sujet facile à trouver sans règle (un seul nom au nominatif) ; la question teste surtout qu'on écarte le nom de lieu.
8. **m5-03** : pour garder la règle « -t / -nt », je n'ai utilisé que des verbes en -ARE (*ambulat/ambulant*). Les verbes en -it font -unt au pluriel (*currunt*), ce que le cours n'enseigne pas encore. Attention si on ajoute *currere* ou *vincere* plus tard.
9. **m5-04** : *Agricola* finit en -a comme *Rosa* au nominatif, c'est le piège voulu.
10. **m1-04** : XIX a déjà servi de mauvaise option dans l'arène (pour le 9). Cela ne gêne pas, mais c'est le même nombre.
11. Index des bonnes réponses : 0 (5 fois), 1 (5), 2 (6), 3 (5). Pas de motif fixe.
