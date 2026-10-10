# Deuxième question de grammaire : mondes 6 à 10

Brouillon pour validation par Cédric (audit des leçons, défaut 3), à la suite du document des mondes 1 à 5. Chaque leçon de cours des mondes 6 à 10 reçoit une question de grammaire posée après l'exercice principal : 18 leçons (les 5 arènes sont exclues). Chaque bloc `grammaire` est prêt à recopier dans la leçon. Les questions portent sur une autre phrase que le modèle du cours, l'exercice et l'arène du monde. Le vocabulaire vient du monde ou des mondes précédents ; quand un mot est plus récent, sa traduction est dans l'énoncé. Les mauvaises options viennent d'erreurs réelles (terminaison, personne, rôle inversé, nombre). Les explications font 20 mots au plus et ne donnent jamais la bonne réponse. Quatre leçons n'enseignent aucune règle de grammaire : la question reprend alors une règle déjà vue, et le titre le dit (« REPRISE »).

---

## m6-01 · Les Rois de l'Arène : Rétiaires et Mirmillons : REPRISE (COD en -m, m4-03)

Règle de la leçon : aucune (culture sur les gladiateurs). Reprise du COD en -m.
Déjà utilisé dans le cours et l'exercice : aucune phrase latine (*rete*, *scutum*, *sica* seulement).

```python
"grammaire": {
    "question": "Dans « Gladiator harenam videt. » (harena = le sable), quel mot est le COD ?",
    "options": ["Harenam", "Gladiator", "Videt", "Il n'y en a pas"],
    "answer": 0,
    "explications": [
        "",
        "Ce mot n'a pas la fin du COD : c'est lui qui fait l'action.",
        "C'est le verbe, reconnaissable à son -t. Il dit l'action.",
        "Si : un mot subit l'action. Cherche la fin qui le marque.",
    ],
},
```

## m6-02 · Les Courses de Chars au Circus Maximus

Règle de la leçon : le verbe finit par -t quand un seul agit (*currit*), par une autre fin quand plusieurs agissent (*currunt*, vu seulement en exemple).
Déjà utilisé dans le cours et l'exercice : *Equi celeriter currunt*, *Equus celeriter currit*.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « L'enfant court » ?",
    "options": ["Puer curro.", "Puer currunt.", "Puer currit.", "Puerum currit."],
    "answer": 2,
    "explications": [
        "La fin -o veut dire « je » : celui qui parle, pas l'enfant.",
        "Cette forme est celle de la phrase du cours sur les chevaux : elle parle de plusieurs.",
        "",
        "La fin -m est celle du COD, celui qui subit l'action. Ici l'enfant agit.",
    ],
},
```

## m6-03 · Le Salut Historique : Ave Caesar !

Règle de la leçon : le verbe finit par -nt quand plusieurs agissent (*salutant*).
Déjà utilisé dans le cours et l'exercice : *salutat*, *salutant*. Dans l'arène : *Romani salutant*.

```python
"grammaire": {
    "question": "Que veut dire « Clamant. » ? (clamare = crier)",
    "options": ["Il crie.", "Je crie.", "Nous crions.", "Ils crient."],
    "answer": 3,
    "explications": [
        "Pour une seule personne, le verbe finit par -t.",
        "« Je crie » se dit clamo : la fin -o désigne celui qui parle.",
        "« Nous crions » se dit clamamus, avec la fin -mus.",
        "",
    ],
},
```

## m7-01 · Les Trésors Cachés : D'où viennent nos mots ?

Règle de la leçon : un mot latin donne toute une famille de mots français (étymologie).
Déjà utilisé dans le cours et l'exercice : *aqua*, *terra*, *manus*, *pes*, *avis*, *ager*, *arbor*.

```python
"grammaire": {
    "question": "Quel mot latin se cache dans « oculiste », le médecin des yeux ?",
    "options": ["Oculus (l'œil)", "Caput (la tête)", "Pes (le pied)", "Manus (la main)"],
    "answer": 0,
    "explications": [
        "",
        "Ce mot a donné « capitaine » et « capital », qui parlent de la tête ou du chef.",
        "Ce mot a donné « pédale » et « piéton », qui parlent du pied.",
        "Ce mot a donné « manuel » et « manucure », qui parlent de la main.",
    ],
},
```

## m7-02 · Les Préfixes Magiques (Sub, Trans, Post...)

Règle de la leçon : un préfixe latin change le sens du mot (*sub-* sous, *trans-* à travers, *post-* après, *circum-* autour).
Déjà utilisé dans le cours et l'exercice : *submerger*, *transatlantique*, *post-scriptum*, *circonférence*, *sous-marin*.

```python
"grammaire": {
    "question": "Dans « postface » (le texte qui vient en dernier dans un livre), que veut dire post- ?",
    "options": ["Autour", "Sous", "Après", "À travers"],
    "answer": 2,
    "explications": [
        "C'est le sens de circum-, comme dans circonférence.",
        "C'est le sens de sub-, comme dans submerger.",
        "",
        "C'est le sens de trans-, comme dans transporter.",
    ],
},
```

## m7-03 · Les Devises Immortelles : Veni, Vidi, Vici

Règle de la leçon : trois verbes au passé en -i (*veni* je suis venu, *vidi* j'ai vu, *vici* j'ai vaincu).
Déjà utilisé dans le cours et l'exercice : *veni, vidi, vici*, *Carpe diem*, *Alea iacta est*, *Mens sana*.

```python
"grammaire": {
    "question": "Sur le modèle de « veni » (je suis venu), que veut dire « misi » ? (mittere = envoyer)",
    "options": ["J'envoie.", "Il envoie.", "Il a envoyé.", "J'ai envoyé."],
    "answer": 3,
    "explications": [
        "« J'envoie » se dit mitto, avec la fin -o du présent.",
        "« Il envoie » se dit mittit, avec un -t.",
        "Ce passé parle d'une autre personne que celui qui parle.",
        "",
    ],
},
```

## m8-01 · Le Grand Marché du Forum (Mercatus) : REPRISE (COD en -m, m4-03)

Règle de la leçon : aucune (vocabulaire du marché). Reprise du COD en -m.
Déjà utilisé dans le cours et l'exercice : *panis, aqua, vinum, malum, pecunia*, aucune phrase.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « La jeune fille voit l'eau » ? (aqua = l'eau)",
    "options": ["Puella aquam videt.", "Puellam aqua videt.", "Puella aqua videt.", "Puellam aquam videt."],
    "answer": 0,
    "explications": [
        "",
        "Les rôles sont inversés : ici, c'est l'eau qui voit.",
        "Aucun mot ne porte la fin du COD : on ne sait pas qui est vu.",
        "Deux mots portent la fin du COD, mais il faut aussi un sujet.",
    ],
},
```

## m8-02 · Faire ses courses au marché

Règle de la leçon : le sujet fait l'action (*mercator*), le COD la subit (*panem*), le verbe finit par -t.
Déjà utilisé dans le cours et l'exercice : *Puer panem emit*, *Mercator panem vendit*.

```python
"grammaire": {
    "question": "Dans « Mercator amicum videt. », qui est vu ?",
    "options": ["Le marchand", "L'ami", "Les deux", "Personne"],
    "answer": 1,
    "explications": [
        "Ce mot n'a pas la fin du COD : c'est lui qui fait l'action.",
        "",
        "Le verbe n'a qu'un -t : un seul fait l'action, l'autre la subit.",
        "Le verbe a un complément : cherche le mot qui porte la fin du COD.",
    ],
},
```

## m8-03 · Aux Thermes : le Génitif (à qui est-ce ?)

Règle de la leçon : le génitif dit « de quelqu'un » ; -ae pour les noms en -a, -i pour les noms en -us.
Déjà utilisé dans le cours et l'exercice : *puellae*, *amici*, *domini*, *servus domini aquam portat*. Dans l'arène : *panem domini*.

```python
"grammaire": {
    "question": "Comment dit-on « le bouclier de l'ami » ? (scutum = le bouclier)",
    "options": ["Scutum amicus.", "Scutum amicae.", "Scutum amicum.", "Scutum amici."],
    "answer": 3,
    "explications": [
        "Cette fin est celle du sujet. Pour dire « de l'ami », il faut changer la fin.",
        "Cette fin est bien un génitif, mais celui d'un nom féminin : l'amie.",
        "La fin -m marque le COD, pas le complément du nom.",
        "",
    ],
},
```

## m8-04 · Le Décodeur du Marchand

Règle de la leçon : reconnaître sujet (-us), COD (-m), génitif (-i) et verbe (-t) à leur terminaison.
Déjà utilisé dans le cours et l'exercice : *Servus aquam domini portat*, *Mercator vinum domini vendit*.

```python
"grammaire": {
    "question": "Dans « Puer scutum amici videt. » (scutum = le bouclier), quel mot est au génitif ?",
    "options": ["Puer", "Scutum", "Amici", "Videt"],
    "answer": 2,
    "explications": [
        "C'est le sujet : il fait l'action.",
        "C'est le COD : il subit l'action.",
        "",
        "C'est le verbe, reconnaissable à son -t.",
    ],
},
```

## m9-01 · L'Armement du Légionnaire (Miles) : REPRISE (génitif, m8-03)

Règle de la leçon : aucune (vocabulaire militaire). Reprise du génitif.
Déjà utilisé dans le cours et l'exercice : *scutum, pilum, gladius, galea, lorica, aquila*, aucune phrase.

```python
"grammaire": {
    "question": "Comment dit-on « le casque du légionnaire » ? (galea = le casque, legionarius = le légionnaire)",
    "options": ["Galea legionarius.", "Galea legionarii.", "Galea legionarium.", "Galeae legionarius."],
    "answer": 1,
    "explications": [
        "Les deux mots ont la fin du sujet : rien n'indique « de ».",
        "",
        "La fin -m marque le COD, pas le complément du nom.",
        "Le génitif est sur l'autre mot : cela dirait « le légionnaire du casque ».",
    ],
},
```

## m9-02 · La Légion au Combat

Règle de la leçon : pluriel *legio* ➔ *legiones*, verbe en -nt quand plusieurs agissent ; le verbe s'accorde avec le sujet.
Déjà utilisé dans le cours et l'exercice : *Legio fortiter pugnat*, *Legiones fortiter pugnant*.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « La légion crie » ? (legio au pluriel : legiones ; clamare = crier)",
    "options": ["Legiones clamat.", "Legio clamant.", "Legio clamat.", "Legiones clamant."],
    "answer": 2,
    "explications": [
        "Le sujet est au pluriel, mais le verbe a la fin du singulier.",
        "Le sujet est au singulier, mais le verbe a la fin du pluriel.",
        "",
        "Les deux mots sont au pluriel : cela parle de plusieurs légions.",
    ],
},
```

## m9-03 · La Tortue Romaine : le Pluriel

Règle de la leçon : sujet pluriel *-ae* / *-i*, COD pluriel *-as* / *-os*.
Déjà utilisé dans le cours et l'exercice : *Puellae rosas amant*, *Legionarii gladios portant*, *Legionarii galeas portant*. Dans l'arène : *Servi rosas vident*.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « Les jeunes filles voient les agneaux » ?",
    "options": ["Puellae agnos vident.", "Puellas agni vident.", "Puellae agnum vident.", "Puella agnos vident."],
    "answer": 0,
    "explications": [
        "",
        "Les rôles sont inversés : ici, ce sont les agneaux qui voient.",
        "La fin -um ne montre qu'un seul agneau.",
        "Le sujet est au singulier, mais le verbe a la fin du pluriel.",
    ],
},
```

## m9-04 · Le Décodeur de l'Attaque

Règle de la leçon : reconnaître sujet pluriel (-ae, -i), COD pluriel (-as, -os) et verbe en -nt, quel que soit l'ordre.
Déjà utilisé dans le cours et l'exercice : *Legionarii galeas portant*, *Equos servi vident*.

```python
"grammaire": {
    "question": "Dans « Lupos pueri vident. » (pueri = les enfants), quel mot est le sujet ?",
    "options": ["Lupos", "Pueri", "Vident", "On ne peut pas savoir"],
    "answer": 1,
    "explications": [
        "C'est le premier mot, mais sa fin -os indique un COD pluriel.",
        "",
        "C'est le verbe, reconnaissable à sa fin -nt.",
        "Si : la fin de chaque mot indique son rôle, même quand l'ordre change.",
    ],
},
```

## m10-01 · Pégase le Cheval Ailé (Pegasus) : REPRISE (pluriel, m9-03)

Règle de la leçon : aucune (mythe de Pégase). Reprise du pluriel (sujet en -i, COD en -os, verbe en -nt).
Déjà utilisé dans le cours et l'exercice : aucune phrase latine.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « Les amis aiment les chevaux » ?",
    "options": ["Equi amicos amant.", "Amici equum amant.", "Amicus equos amat.", "Amici equos amant."],
    "answer": 3,
    "explications": [
        "Les rôles sont inversés : ici, ce sont les chevaux qui aiment.",
        "Le COD est au singulier : la fin ne montre qu'un seul cheval.",
        "Le sujet et le verbe sont au singulier, alors qu'il y a plusieurs amis.",
        "",
    ],
},
```

## m10-02 · Cerbère le Gardien des Enfers (Cerberus)

Règle de la leçon : COD singulier *portam* (-am), COD pluriel *portas* (-as) ; verbe en -t.
Déjà utilisé dans le cours et l'exercice : *Cerberus portas custodit*, *Cerberus portam custodit*.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « Le chien garde les portes » ? (canis = le chien)",
    "options": ["Canis porta custodit.", "Canis portam custodit.", "Canis portae custodit.", "Canis portas custodit."],
    "answer": 3,
    "explications": [
        "Porta a la fin d'un sujet, mais le chien est déjà le sujet.",
        "La fin -am ne montre qu'une seule porte.",
        "Cette fin n'est pas celle d'un COD.",
        "",
    ],
},
```

## m10-03 · Polyphème le Cyclope : l'Adjectif s'accorde

Règle de la leçon : l'adjectif prend le genre, le nombre et le cas du nom (*bonus, magnus*).
Déjà utilisé dans le cours et l'exercice : *amicus bonus, puella bona, magnam speluncam*. Dans l'arène : *rosam magnam*.

```python
"grammaire": {
    "question": "Complète pour dire « La grande louve voit l'agneau » : Lupa magn___ agnum videt.",
    "options": ["-a", "-am", "-us", "-um"],
    "answer": 0,
    "explications": [
        "",
        "Le genre est bon, mais -m marque un COD. Ici, la louve est le sujet.",
        "Cette fin est masculine, alors que lupa est féminin.",
        "Cette fin est masculine et sert pour un COD.",
    ],
},
```

## m10-04 · Les Six Cas : le Datif et l'Ablatif

Règle de la leçon : le datif dit « à qui ? » (-ae pour les noms en -a, -o pour les noms en -us) ; l'ablatif dit « où ? » (-a, -o).
Déjà utilisé dans le cours et l'exercice : *Puella servo rosam dat*, *Ulixes amico gladium in spelunca dat*, *in horto*, *in silva*.

```python
"grammaire": {
    "question": "Complète pour dire « Le maître donne de l'eau à la jeune fille » : Dominus aquam puell___ dat.",
    "options": ["-a", "-ae", "-am", "-o"],
    "answer": 1,
    "explications": [
        "Cette fin ne marque pas celui qui reçoit. Ici, la jeune fille reçoit l'eau.",
        "",
        "Cette fin est celle du COD, qui subit l'action, pas de celui qui reçoit.",
        "Cette fin va avec les noms en -us, pas avec les noms en -a.",
    ],
},
```

---

## Leçons traitées par reprise faute de règle

4 leçons sur 18 : m6-01 (COD en -m, m4-03), m8-01 (COD en -m, m4-03), m9-01 (génitif, m8-03), m10-01 (pluriel, m9-03).
Les 14 autres appliquent la règle de leur leçon. m7-01 (étymologie) et m7-02 (préfixes) enseignent un savoir de vocabulaire plutôt qu'une règle de grammaire au sens strict.

## Doutes pour l'enseignant

1. **m6-02** : *currit* et *currunt* appartiennent à la 3e conjugaison (le cours ne donne que ces deux formes). J'ai évité tout autre verbe en -it au pluriel (*-unt*) dans les bonnes réponses ; *currunt* apparaît seulement comme mauvaise option, avec une explication tirée du cours.
2. **m6-03, m9-02, m9-03, m10-01** : *clamant*, *vident*, *amant* se forment avec -nt, comme *salutant*. Pour *videre* (2e conjugaison), le cours n'a vu que *vident* en m9-04 ; la règle « -nt = plusieurs » reste celle de m5-03.
3. **m7-03** : le cours ne dit pas que le passé de « je » finit par -i, il donne seulement *veni, vidi, vici*. La question demande de généraliser sur *misi*. À garder seulement si Cédric accepte ce petit saut ; sinon, remplacer par une question de sens sur une devise (mais *Carpe diem* et *Alea iacta est* sont déjà dans l'arène).
4. **m8-03, m8-04, m9-01** : *scutum amici*, *galea legionarii* : *scutum* (neutre) a un COD en -um. Le cours n'a jamais parlé des neutres, mais le mot n'est employé qu'au COD ou au nominatif, jamais décliné pour ce qui est enseigné.
5. **m8-04** : le choix du génitif ne dit pas à quel nom *amici* se rapporte (*puer* ou *scutum*). Je n'ai donc demandé que le rôle du mot.
6. **m9-03, m9-04, m10-01** : *-ae* et *-i* sont aussi des terminaisons de génitif (le cours le dit en m9-03). Dans *agricolae vident*, le verbe en -nt lève le doute ; c'est voulu.
7. **m10-01 et m9-03** utilisent des phrases proches (deux noms pluriels, un verbe en -nt). Le vocabulaire change, le schéma est volontairement le même pour que la règle soit réutilisée.
8. **m10-02** : l'option *portae* peut aussi se lire comme un sujet pluriel ; l'explication dit seulement que ce n'est pas un COD, ce qui est vrai.
9. **m10-04** : seule la partie datif est testée ; l'ablatif ressemble trop au nominatif (-a) pour fournir une bonne question à quatre options. La question ablatif reste possible ailleurs.
10. **Mots plus récents que la leçon** : *scutum* (m6) est traduit dans les énoncés de m8-03 et m8-04 (m8 vient après m6, donc déjà vu). Rien de plus récent que le monde de la leçon, sauf *legionarius* et *galea* en m9-01, traduits dans l'énoncé.
11. **Pas de dépendance à la 3e déclinaison** : aucune bonne réponse ne contient *gladiatores*, *mercatorem* ni un neutre pluriel ; *panem* n'apparaît nulle part.
12. Index des bonnes réponses : 0 (5 fois), 1 (4), 2 (4), 3 (5). Pas de motif fixe.
