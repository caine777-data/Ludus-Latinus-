# Deuxième question de grammaire : mondes 19 à 26

Brouillon pour validation par Cédric (audit des leçons, défaut 3), à la suite des documents des mondes 1 à 5, 6 à 10 et 11 à 18. Chaque leçon de cours des mondes 19 à 26 reçoit une question de grammaire posée après l'exercice principal : 24 leçons (les 8 arènes sont exclues). Chaque bloc `grammaire` est prêt à recopier dans la leçon. Les questions portent sur une autre phrase que le modèle du cours, l'exercice et l'arène du monde. Le vocabulaire vient du monde ou des mondes précédents ; quand un mot est plus récent ou rare, sa traduction est dans l'énoncé. Les mauvaises options viennent d'erreurs réelles (cas, temps, voix, accord en genre et nombre, rôle du relatif). Les explications font 20 mots au plus et ne donnent jamais la bonne réponse. Trois leçons n'enseignent aucune règle propre (récit, culture, synthèse) ou répètent une notion ancienne : la question reprend alors une notion déjà vue, et le titre le dit (« REPRISE »). Les notions reprises changent d'une leçon à l'autre : imparfait (m21-03), ablatif absolu (m25-01), pronom relatif (m26-01).

---

## m19-01 · La 4ème Déclinaison : Manus & Exercitus

Règle de la leçon : un nom de la 4e déclinaison a un génitif singulier en -us.
Déjà utilisé dans le cours et l'exercice : *manus*, *exercitus*, *domus*, *cornu*. Dans l'arène : *res, rei*, *manus*. *Senatus* vient du monde 12.

```python
"grammaire": {
    "question": "Quel nom est de la 4e déclinaison ? Un nom se reconnaît à son génitif (senatus = le sénat ; dominus = le maître de maison).",
    "options": ["dominus, domini", "rex, regis", "senatus, senatus", "res, rei"],
    "answer": 2,
    "explications": [
        "Ce génitif en -i est celui de la 2e déclinaison.",
        "Ce génitif en -is est celui de la 3e déclinaison.",
        "",
        "Ce génitif en -ei est celui de la 5e déclinaison.",
    ],
},
```

## m19-02 · La 5ème Déclinaison : Res & Dies

Règle de la leçon : génitif en -ei ; à l'accusatif, *dies* devient *diem*, *res* devient *rem*.
Déjà utilisé dans le cours et l'exercice : *res publica*, *dies*, *spes*, *fides*, *rem publicam servat*.

```python
"grammaire": {
    "question": "Complète pour dire « Les Romains aiment la loyauté » : Romani ___ amant.",
    "options": ["fides", "fidem", "fidei", "fidam"],
    "answer": 1,
    "explications": [
        "Cette forme est celle du sujet. Ici, la loyauté est aimée : elle subit l'action.",
        "",
        "Cette fin est celle du génitif (« de la loyauté »), pas celle du COD.",
        "Cette fin appartient à la 1re déclinaison, comme rosam. Les noms en -es n'en font pas partie.",
    ],
},
```

## m19-03 · Une Rome de Marbre

Règle de la leçon : le datif de la 3e déclinaison (*civi* au singulier, *civibus* au pluriel) désigne celui qui reçoit.
Déjà utilisé dans le cours et l'exercice : *populo*, *civibus*, *pacem dedit*. Dans l'arène : aucune phrase latine.

```python
"grammaire": {
    "question": "Complète pour dire « Le chef donne de l'argent au soldat » : Dux ___ pecuniam dat.",
    "options": ["militem", "militis", "militibus", "militi"],
    "answer": 3,
    "explications": [
        "Cette fin marque le COD. L'argent occupe déjà ce rôle dans la phrase.",
        "Cette fin dit « du soldat » : elle complète un nom, elle ne désigne pas celui qui reçoit.",
        "Cette fin est celle d'un pluriel : le chef ne donne qu'à un seul soldat.",
        "",
    ],
},
```

## m20-01 · Le Pronom Relatif : Qui, Quae, Quod

Règle de la leçon : le relatif prend le genre et le nombre de son antécédent ; son cas dépend de son rôle dans sa propre proposition.
Déjà utilisé dans le cours et l'exercice : *miles qui pugnat*. Dans l'arène : *Miles quem Caesar videt fortis est*.

```python
"grammaire": {
    "question": "Que veut dire « Dux qui urbem videt fortis est. » ? (dux = le chef ; urbs = la ville)",
    "options": [
        "Le chef que la ville voit est courageux.",
        "La ville que le chef voit est courageuse.",
        "Le chef qui voit la ville est courageux.",
        "Les chefs qui voient la ville sont courageux.",
    ],
    "answer": 2,
    "explications": [
        "Urbem, avec sa fin -m, est le COD de videt : le relatif ne peut pas l'être aussi.",
        "Qui, au masculin, ne peut pas reprendre un nom féminin comme la ville.",
        "",
        "Videt est au singulier : un seul chef agit.",
    ],
},
```

## m20-02 · Le Pronom Relatif au Féminin : Quae et Quam

Règle de la leçon : *quae* est le relatif féminin sujet, *quam* le relatif féminin COD.
Déjà utilisé dans le cours et l'exercice : *Urbs quae in colle stat*, *Urbs quam Caesar condidit*, *Aqua quam aquaeductus ducit*. *Regina* vient du monde 20, *pulcher, pulchra* du monde 10.

```python
"grammaire": {
    "question": "Complète pour dire « La reine qui voit la ville est belle » : Regina ___ urbem videt pulchra est.",
    "options": ["quae", "qui", "quam", "quem"],
    "answer": 0,
    "explications": [
        "",
        "Cette forme est masculine, alors que la reine est féminine.",
        "Cette forme est celle du COD. Qui fait l'action de voir dans la relative ?",
        "Cette forme est masculine, et elle marque aussi le COD.",
    ],
},
```

## m20-03 · La Reine des Voies : La Via Appia

Règle de la leçon : choisir entre *quae* (sujet) et *quam* (COD) ; le relatif copie le genre et le nombre de son antécédent. Cette question applique la forme neutre du cours (*quod*).
Déjà utilisé dans le cours et l'exercice : *Via quam Romani fecerunt longa est*. Dans l'arène : *Miles quem Caesar videt*, *quod* neutre en choix.

```python
"grammaire": {
    "question": "Complète pour dire « La place forte que les Romains défendent est grande » : Oppidum ___ Romani defendunt magnum est.",
    "options": ["quem", "quod", "quam", "qui"],
    "answer": 1,
    "explications": [
        "Cette forme est masculine ; elle irait avec un nom comme miles, pas avec un neutre.",
        "",
        "Cette forme est féminine ; elle irait avec un nom comme urbs.",
        "Cette forme est masculine ; elle ne s'accorde pas avec un nom neutre.",
    ],
},
```

## m21-01 · Le Participe Parfait Passif (PPP)

Règle de la leçon : le PPP se construit sur la 4e forme du dictionnaire (le supin) ; il se décline comme *bonus, bona, bonum*.
Déjà utilisé dans le cours et l'exercice : *amatus*, *captus*, *scriptus*, *victus*. Dans l'arène : *scriptum*, *victus*. *Mittere (mitto, misi, missum)* vient du monde 7, et la forme du supin est donnée dans l'énoncé.

```python
"grammaire": {
    "question": "Quel est le participe parfait passif de mittere (mitto, misi, missum), « envoyé », au masculin ?",
    "options": ["missus", "mittus", "misus", "mittatus"],
    "answer": 0,
    "explications": [
        "",
        "Cette forme garde le radical du présent. Le PPP se construit sur une autre forme du dictionnaire.",
        "Cette forme part du parfait (misi). Le PPP se construit sur une autre forme du dictionnaire.",
        "Cette forme copie amatus avec le radical du présent. Le PPP part de la 4e forme du dictionnaire.",
    ],
},
```

## m21-02 · Accorder le PPP : Urbs Deleto ou Deleta ?

Règle de la leçon : le PPP s'accorde en genre et en nombre avec son nom (*urbs deleta*, *oppidum deletum*, *vicus deletus*).
Déjà utilisé dans le cours et l'exercice : *urbs deleta*, *oppidum deletum*, *vicus deletus*, *oppidum captum est*. Dans l'arène : *Hostis victus est*. Ici, un pluriel féminin (*urbes*, m12-02).

```python
"grammaire": {
    "question": "Complète pour dire « Les villes ont été détruites » : Urbes ___ sunt.",
    "options": ["deleta", "deleti", "deletum", "deletae"],
    "answer": 3,
    "explications": [
        "Cette fin marque un féminin singulier. Ici, il y a plusieurs villes.",
        "Cette fin est celle du masculin pluriel. Urbs est un nom féminin.",
        "Cette fin est celle du neutre singulier. Ni le genre ni le nombre ne conviennent.",
        "",
    ],
},
```

## m21-03 · La Lettre de Pline le Jeune (79 ap. J.-C.) : REPRISE (imparfait, m15-01)

Règle de la leçon : aucune règle nouvelle ; le cours dit seulement « même temps, l'imparfait en -bat ». Reprise de l'imparfait, avec un verbe en -are au pluriel.
Déjà utilisé dans le cours et l'exercice : *erigebat*, *tegebat*. Dans l'arène : aucune phrase latine.

```python
"grammaire": {
    "question": "Complète pour dire « Les citoyens criaient sur le forum » : Cives in foro ___.",
    "options": ["clamant", "clamabant", "clamabunt", "clamaverunt"],
    "answer": 1,
    "explications": [
        "Cette forme est au présent : elle dit ce qui se passe maintenant.",
        "",
        "Cette forme est au futur : elle dit ce qui arrivera.",
        "Cette forme est un passé ponctuel, qui ne montre pas une action qui durait.",
    ],
},
```

## m22-01 · Qu'est-ce que l'Ablatif Absolu ?

Règle de la leçon : un ablatif absolu réunit un nom et un participe, tous deux à l'ablatif, sans mot de liaison.
Déjà utilisé dans le cours et l'exercice : *Urbe capta*. Dans l'arène : *Hostibus victis*, *Cicerone consule*.

```python
"grammaire": {
    "question": "Quelle phrase contient un ablatif absolu ? (nauta = le marin ; navis = le navire ; fugere = fuir)",
    "options": [
        "Nauta navem deletam videt.",
        "Nauta in nave fugit.",
        "Navis deleta est.",
        "Nave deleta, nauta fugit.",
    ],
    "answer": 3,
    "explications": [
        "Ici le nom et le participe sont à l'accusatif : ils forment le COD du verbe.",
        "Il y a un nom à l'ablatif après in, mais aucun participe à côté de lui.",
        "Le nom et le participe sont au nominatif, avec est : c'est une phrase ordinaire.",
        "",
    ],
},
```

## m22-02 · Les Deux Mots qui Résument une Bataille

Règle de la leçon : dans l'ablatif absolu, le participe s'accorde avec son nom (*bello confecto*, *pace facta*).
Déjà utilisé dans le cours et l'exercice : *bello confecto*, *sole oriente*, *pace facta*, *oppido capto*. Ici, un nom féminin (*regina*) et un verbe du monde 4 (*necare, necatum*), donné dans l'énoncé.

```python
"grammaire": {
    "question": "Complète pour dire « La reine ayant été tuée, les soldats crient » : Regina ___, milites clamant. (necare = tuer)",
    "options": ["necato", "necatae", "necata", "necatum"],
    "answer": 2,
    "explications": [
        "Cette fin est celle du masculin ou du neutre. Regina est un nom féminin.",
        "Cette fin est celle du génitif ou du pluriel. Ici, une seule reine à l'ablatif.",
        "",
        "Cette fin est celle de l'accusatif neutre, qui ne convient pas au féminin.",
    ],
},
```

## m22-03 · Sous la Conduite de César (Caesare duce)

Règle de la leçon : un ablatif absolu peut réunir deux noms à l'ablatif, avec « étant » sous-entendu (*Caesare duce*).
Déjà utilisé dans le cours et l'exercice : *Caesare duce*, *Cicerone consule*, *Romulo rege*.

```python
"grammaire": {
    "question": "Que veut dire « Augusto imperatore, pax erat. » ? (imperator = l'empereur ; pax = la paix)",
    "options": [
        "Auguste étant empereur, la paix existait.",
        "Auguste sera l'empereur de la paix.",
        "Auguste donne la paix à l'empereur.",
        "L'empereur d'Auguste faisait la paix.",
    ],
    "answer": 0,
    "explications": [
        "",
        "Le verbe erat est à l'imparfait : il parle du passé, jamais du futur.",
        "Le verbe de la phrase est erat, « il était ». Il ne veut pas dire « donne ».",
        "Pour dire « d'Auguste », il faudrait le génitif. Et le verbe ne veut pas dire « faisait ».",
    ],
},
```

## m23-01 · La Voix Passive : Quand le Sujet Subit l'Action

Règle de la leçon : au passif, le sujet subit l'action ; la 3e personne finit par -tur (singulier) ou -ntur (pluriel) ; l'agent est introduit par *a/ab* + ablatif.
Déjà utilisé dans le cours : *laudatur*, *a magistro*, *laudantur*. Dans l'arène : *Civis a consule laudatur*.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « Le chef est aimé par les soldats » ?",
    "options": [
        "Dux milites amat.",
        "Dux a militibus amatur.",
        "Milites a duce amantur.",
        "Dux a militibus amantur.",
    ],
    "answer": 1,
    "explications": [
        "Le verbe est à l'actif : le chef fait l'action au lieu de la subir.",
        "",
        "Les rôles sont inversés : ici ce sont les soldats qui sont aimés.",
        "Le chef est seul, mais le verbe en -ntur est au pluriel.",
    ],
},
```

## m23-02 · Le Complément d'Agent (A / Ab + Ablatif)

Règle de la leçon : le complément d'agent s'exprime avec *a/ab* + ablatif ; la 3e personne passive finit par -tur ou -ntur.
Déjà utilisé dans le cours et l'exercice : *Urbs a civibus defenditur*, *Lex a consule legitur*, *milites a duce laudantur*.

```python
"grammaire": {
    "question": "Complète pour dire « Les citoyens sont sauvés par le consul » : Cives ___ consule servantur.",
    "options": ["a", "ad", "in", "pro"],
    "answer": 0,
    "explications": [
        "",
        "Cette préposition se construit avec l'accusatif et marque un mouvement vers quelqu'un.",
        "Cette préposition situe un lieu (« dans », « sur »). Elle n'introduit pas l'auteur de l'action.",
        "Cette préposition veut dire « pour, à la place de ». Elle n'introduit pas l'auteur.",
    ],
},
```

## m23-03 · Le Discours de Cicéron au Sénat

Règle de la leçon : au passif, le sujet subit l'action et le complément d'agent est à l'ablatif avec *a* ; le verbe finit par -tur.
Déjà utilisé dans le cours et l'exercice : *Pax et concordia a civibus quaeruntur*, *Libertas a populo Romano defenditur*. Dans l'arène : *Civis a consule laudatur*.

```python
"grammaire": {
    "question": "Que veut dire « Pecunia a mercatore portatur. » ? (pecunia = l'argent ; mercator = le marchand ; portare = porter)",
    "options": [
        "Le marchand porte l'argent.",
        "Le marchand est porté par l'argent.",
        "L'argent est porté par les marchands.",
        "L'argent est porté par le marchand.",
    ],
    "answer": 3,
    "explications": [
        "Le verbe finit par -tur : le sujet subit l'action, il ne la fait pas.",
        "Après a, le mot à l'ablatif est celui qui agit. Ici, c'est un autre mot.",
        "Mercatore est au singulier : la fin -e va avec un seul marchand.",
        "",
    ],
},
```

## m24-01 · Le Mystère du « QUE » Disparu !

Règle de la leçon : dans une proposition infinitive, le sujet est à l'accusatif et le verbe à l'infinitif, sans mot pour dire « que ».
Déjà utilisé dans le cours : *Scio Marcum fortem esse*. Dans l'arène : *Scio Marcum bonum discipulum esse*, *Scio urbem magnam esse*.

```python
"grammaire": {
    "question": "Complète pour dire « Je sais que le soldat court » : Scio ___ currere.",
    "options": ["miles", "militi", "militem", "militis"],
    "answer": 2,
    "explications": [
        "Cette forme est le nominatif, cas du sujet d'une phrase simple.",
        "Cette forme est un datif : celui qui reçoit. Personne ne reçoit rien ici.",
        "",
        "Cette forme est un génitif : « du soldat ». Elle complèterait un nom.",
    ],
},
```

## m24-02 · Les Verbes Déclaratifs : Dico, Scio, Audio

Règle de la leçon : *dico, scio, puto, audio, video* introduisent une proposition infinitive (sujet à l'accusatif, verbe à l'infinitif).
Déjà utilisé dans le cours et l'exercice : *Scio consulem venire*, *Puto amicum venire*. Ici, un sujet pluriel de la 1re déclinaison (accusatif en -as, m9-03).

```python
"grammaire": {
    "question": "Complète pour dire « Je dis que les marins courent » : Dico ___ currere. (nauta = le marin)",
    "options": ["nautae", "nautas", "nautam", "nauta"],
    "answer": 1,
    "explications": [
        "Cette forme est le sujet d'une phrase simple, pas le sujet d'une proposition infinitive.",
        "",
        "Cette forme est au singulier. La phrase parle de plusieurs marins.",
        "Cette forme est le nominatif singulier : un seul marin, sujet d'une phrase simple.",
    ],
},
```

## m24-03 · Une Rumeur au Palais Impérial

Règle de la leçon : l'infinitif présent indique une action qui se passe au même moment que le verbe principal.
Déjà utilisé dans le cours et l'exercice : *Dicit consulem Romam venire*, *Nuntius dicit hostes venire*.

```python
"grammaire": {
    "question": "Que veut dire « Puto reginam ambulare. » ? (regina = la reine ; ambulare = se promener)",
    "options": [
        "Je pense que la reine se promène.",
        "Je pense que la reine se promenait.",
        "Je pense que les reines se promènent.",
        "La reine pense que je me promène.",
    ],
    "answer": 0,
    "explications": [
        "",
        "L'infinitif présent ne marque pas une action passée par rapport à puto.",
        "Reginam est au singulier : la fin -am désigne une seule reine.",
        "Puto veut dire « je pense » : celui qui pense, c'est « je », pas la reine.",
    ],
},
```

## m25-01 · L'Énéide de Virgile : Le Chant des Armes et du Héros : REPRISE (ablatif absolu, m22)

Règle de la leçon : aucune (récit sur Virgile et l'Énéide). Reprise de l'ablatif absolu, avec un participe du monde 20 (*condere, conditum*).
Déjà utilisé dans le cours et l'exercice : *Arma virumque cano*. Dans l'arène : aucune phrase d'ablatif absolu.

```python
"grammaire": {
    "question": "Que veut dire « Urbe condita, Romulus rex fuit. » ? (condere = fonder ; rex = le roi)",
    "options": [
        "Dans la ville fondée, Romulus fut roi.",
        "Romulus fonda la ville et fut roi.",
        "Romulus fut roi de la ville fondée.",
        "La ville ayant été fondée, Romulus fut roi.",
    ],
    "answer": 3,
    "explications": [
        "Pour dire « dans », il faudrait la préposition in. Elle manque ici.",
        "Le seul verbe conjugué est fuit, « il fut ». Le verbe fonder n'y est pas conjugué.",
        "Pour dire « de la ville », il faudrait un génitif, et urbe n'en est pas un.",
        "",
    ],
},
```

## m25-02 · Dédale et Icare chez Ovide

Règle de la leçon : le subjonctif de souhait de *esse* se forme sur *si-* + -m, -s, -t, -mus, -tis, -nt (*Felix sis !*).
Déjà utilisé dans le cours et l'exercice : *Felix sis*, *Felix sit poeta*.

```python
"grammaire": {
    "question": "Complète pour dire « Que je sois heureux ! » : Felix ___ !",
    "options": ["sum", "sis", "sim", "sit"],
    "answer": 2,
    "explications": [
        "Cette forme est de l'indicatif : elle dit un fait, elle n'exprime pas un souhait.",
        "Cette forme s'adresse à « tu », pas à celui qui parle.",
        "",
        "Cette forme parle d'une 3e personne, pas de « je ».",
    ],
},
```

## m25-03 · Le Vers Immortel de Virgile

Règle de la leçon : le petit mot -que, collé à la fin d'un mot, veut dire « et ».
Déjà utilisé dans le cours et l'exercice : *virumque*, *Poeta patriam virosque canit*. Dans l'arène : *virumque*.

```python
"grammaire": {
    "question": "Que veut dire « Puellae puerique rosas amant. » ? (pueri = les enfants)",
    "options": [
        "Les roses aiment les jeunes filles et les enfants.",
        "Les jeunes filles des enfants aiment les roses.",
        "La jeune fille ou l'enfant aime les roses.",
        "Les jeunes filles et les enfants aiment les roses.",
    ],
    "answer": 3,
    "explications": [
        "Rosas porte la fin du COD : les roses subissent l'action, elles ne la font pas.",
        "Le -que ajouté au mot n'exprime pas un complément du nom.",
        "Le petit mot -que ne propose pas un choix entre deux noms.",
        "",
    ],
},
```

## m26-01 · La Grande Synthèse du Cycle 4 : REPRISE (pronom relatif, m20)

Règle de la leçon : aucune règle nouvelle (bilan de tout le cycle). Reprise du pronom relatif, avec un piège de genre : *poeta* est masculin malgré sa fin en -a.
Déjà utilisé dans le cours et l'exercice : *urbe capta*, *scio te venire*, *laudatur*, *amatus*. Dans l'arène : *Miles quem Caesar videt* (m20), *Scio urbem magnam esse*.

```python
"grammaire": {
    "question": "Complète pour dire « Le poète que le consul loue est heureux » : Poeta ___ consul laudat felix est.",
    "options": ["quem", "quam", "qui", "quae"],
    "answer": 0,
    "explications": [
        "",
        "Cette forme est féminine. Le poète est un homme, même si son nom finit en -a.",
        "Le sujet de laudat est déjà consul. Cette forme serait un sujet masculin.",
        "Cette forme est féminine au nominatif. Elle ne va pas avec un poète.",
    ],
},
```

## m26-02 · L'Épreuve du Manuscrit Impérial

Règle de la leçon : le verbe s'accorde avec son sujet ; un sujet pluriel donne la fin -nt.
Déjà utilisé dans le cours et l'exercice : *Populus Romanus libertatem et pacem servat*, *Cives Romani libertatem servant*. Dans l'arène : *Poeta et consul patriam servant*.

```python
"grammaire": {
    "question": "Complète pour dire « Les poètes louent la victoire » : Poetae victoriam ___.",
    "options": ["laudat", "laudant", "laudas", "laudatis"],
    "answer": 1,
    "explications": [
        "Cette fin va avec un seul sujet. Ici, plusieurs poètes agissent.",
        "",
        "Cette fin va avec « tu ». Le sujet est un nom, pas « tu ».",
        "Cette fin va avec « vous ». Le sujet est à la 3e personne.",
    ],
},
```

## m26-03 · Le Serment du Citoyen Émérite

Règle de la leçon : deux sujets coordonnés par *et* donnent un verbe au pluriel (*Virtus et sapientia ... servant*).
Déjà utilisé dans le cours et l'exercice : *Litterae et sapientia mentem hominis ornant*, *Virtus et sapientia rem publicam servant*.

```python
"grammaire": {
    "question": "Que veut dire « Gloria et victoria imperatorem ornant. » ? (ornare = embellir ; imperator = l'empereur)",
    "options": [
        "L'empereur embellit la gloire et la victoire.",
        "La gloire embellit l'empereur de la victoire.",
        "La gloire et la victoire embellissent l'empereur.",
        "La gloire et la victoire ont embelli l'empereur.",
    ],
    "answer": 2,
    "explications": [
        "Imperatorem a la fin -em du COD : il subit l'action, il ne la fait pas.",
        "Ta traduction n'a qu'un seul sujet, alors que le verbe finit par -nt.",
        "",
        "Ornant est au présent. Rien dans le verbe ne marque un passé.",
    ],
},
```

---

## Leçons traitées par reprise faute de règle

3 leçons sur 24 : m21-03 (imparfait, m15-01), m25-01 (ablatif absolu, m22), m26-01 (pronom relatif, m20).
Les 21 autres appliquent la règle de leur leçon. La reprise de m21-03 est choisie parce que le cours de cette leçon ne fait que rappeler l'imparfait ; celle de m25-01 prolonge la construction la plus utile de la 3e dans une leçon de culture ; celle de m26-01 sert de bilan et teste le genre du relatif sur un nom masculin en -a.

## Doutes pour l'enseignant

1. **m19-01** : *senatus, senatus* est donné par le thesaurus du monde 12 sans que la 4e déclinaison soit nommée à ce moment-là. Le cours cite *manus, exercitus, domus, cornu*.
2. **m19-02** : *fidem* se déduit de *dies ➔ diem* et de *rem*. Le cours ne donne pas l'accusatif de *fides*.
3. **m20-03** : la leçon travaille *quae / quam*. La question utilise *quod* (neutre), listé dans le cours du m20-01, avec *oppidum* (m17). *Quod* sert à la fois de sujet et de COD, d'où le relatif COD dans l'énoncé.
4. **m21-01** : *missus* se déduit du supin *missum* donné dans l'énoncé ; la règle « supin ➔ -us, -a, -um » est celle du cours.
5. **m21-02** : le cours n'illustre pas le PPP au pluriel. L'accord pluriel (*deletae*) découle de la règle « genre, nombre et cas » et du nominatif pluriel *urbes* (m12-02).
6. **m22-01, m22-02** : *nave deleta* (ablatif en -e d'un nom en -i) et *regina necata* utilisent des ablatifs vus en m10-04 et m12-02. Dans m22-02, *necata* a la même forme qu'un nominatif féminin ; c'est le rôle dans la phrase qui tranche.
7. **m22-03** : l'énoncé contient *erat* (imparfait de *esse*, m15-02) et *pax erat* se traduit « la paix existait » ou « il y avait la paix ». La bonne réponse choisit « existait » pour éviter un contresens.
8. **m23-01** : *militibus* (ablatif pluriel de la 3e déclinaison) est dans le tableau du m12-02. Aucun ablatif pluriel de 1re ou 2e déclinaison n'est utilisé, car le cours ne l'enseigne pas.
9. **m23-02, m23-03, m24** : seuls des verbes en *-are* sont employés au passif (*servantur*, *portatur*, *amatur*) : les formes en -tur / -ntur du cours, pas les passifs des autres conjugaisons.
10. **m24-02** : *nautas* (accusatif pluriel de la 1re déclinaison) vient du m9-03. L'option *nautae* est un piège voulu (nominatif pluriel).
11. **m25-02** : *sim* se déduit de la règle donnée (*si-* + -m). Le cours ne cite que *sis* et *sit*.
12. **m25-03** : *agricolae* remplacé par *pueri* par l'architecte, pour écarter le piège du génitif en -ae, comme Cédric l'a demandé pour le décodeur `m9-04`.
13. **m26-01** : *poeta* est masculin (m25-02 le précise). Le piège du genre (*quem*, pas *quam*) n'est pas dans le cours du m20. Si c'est trop difficile, remplacer par *Consul quem poeta laudat...*.
14. **m26-02, m26-03** : les deux portent sur l'accord du verbe pluriel, comme l'arène du monde 26. J'ai changé de verbe (*laudare*, *ornare*) et de forme de question, mais la notion est la même.
15. Index des bonnes réponses : 0 (6 fois), 1 (6), 2 (6), 3 (6). Pas de motif fixe.
