# Deuxième question de grammaire : mondes 11 à 18

Brouillon pour validation par Cédric (audit des leçons, défaut 3), à la suite des documents des mondes 1 à 5 et 6 à 10. Chaque leçon de cours des mondes 11 à 18 reçoit une question de grammaire posée après l'exercice principal : 24 leçons (les 8 arènes sont exclues). Chaque bloc `grammaire` est prêt à recopier dans la leçon. Les questions portent sur une autre phrase que le modèle du cours, l'exercice et l'arène du monde. Le vocabulaire vient du monde ou des mondes précédents ; quand un mot est plus récent ou rare, sa traduction est dans l'énoncé. Les mauvaises options viennent d'erreurs réelles (temps confondus, cas confondus, personne, nombre, genre). Les explications font 20 mots au plus et ne donnent jamais la bonne réponse. Quatre leçons n'enseignent aucune règle propre (récit, culture) : la question reprend alors une notion déjà vue, et le titre le dit (« REPRISE »). Les notions reprises changent d'une leçon à l'autre : datif (m11-01), nominatif pluriel de la 3e déclinaison (m13-03), parfait (m17-03), futur et pronom *is, ea, id* (m18-01).

---

## m11-01 · Horatius Coclès seul sur le pont : REPRISE (datif, m10-04)

Règle de la leçon : aucune (récit sur Horatius Coclès). Reprise du datif, celui qui reçoit.
Déjà utilisé dans le cours et l'exercice : aucune phrase latine.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « Le soldat donne un glaive à l'ami » ? (dat = il donne ; gladius = le glaive)",
    "options": ["Miles amicus gladium dat.", "Miles amici gladium dat.", "Miles amico gladium dat.", "Miles amicum gladium dat."],
    "answer": 2,
    "explications": [
        "Cette fin est celle du sujet : l'ami ferait l'action, comme le soldat.",
        "Cette fin dit « de l'ami » : elle complète un nom, elle ne désigne pas celui qui reçoit.",
        "",
        "La fin -m marque le COD, ce qui est donné. Le glaive occupe déjà ce rôle.",
    ],
},
```

## m11-02 · Mucius Scaevola et le brasier sacré

Règle de la leçon : le verbe *sum* au pluriel (*sumus* : nous sommes).
Déjà utilisé dans le cours et l'exercice : *Civis Romanus sum*, *Cives Romani sumus*. Dans l'arène : *Romani sumus / sunt / estis*.

```python
"grammaire": {
    "question": "Complète pour dire « Nous sommes des amis » : Amici ___.",
    "options": ["sum", "sumus", "estis", "sunt"],
    "answer": 1,
    "explications": [
        "Cette forme veut dire « je suis » : un seul parle.",
        "",
        "Cette forme s'adresse à plusieurs personnes (« vous »), pas à un groupe dont tu fais partie.",
        "Cette forme parle de plusieurs autres personnes (« ils »).",
    ],
},
```

## m11-03 · Cloélie, la jeune fille indomptable

Règle de la leçon : le verbe *transit* finit par -it quand un seul agit ; le mot en -m est le COD.
Déjà utilisé dans le cours et l'exercice : *Cloelia fluvium transit*.

```python
"grammaire": {
    "question": "Que veut dire « Puella silvam transit. » ? (silva = la forêt ; transire = traverser)",
    "options": ["La forêt traverse la jeune fille.", "Les jeunes filles traversent la forêt.", "Tu traverses la forêt.", "La jeune fille traverse la forêt."],
    "answer": 3,
    "explications": [
        "Les rôles sont inversés : la fin -m marque ce qui subit l'action.",
        "Le verbe finit par un seul -t : un seul fait l'action.",
        "Pour « tu », la fin du verbe serait -s. Ici elle est différente.",
        "",
    ],
},
```

## m12-01 · La 3ème Déclinaison : Les Rois et les Consuls

Règle de la leçon : le génitif en -is signale la 3e déclinaison ; on retire -is pour trouver le radical.
Déjà utilisé dans le cours et l'exercice : *rex, regis*, *consul, consulis*, *dux, ducis*, *miles, militis*, *vox, vocis*. *Pons, pontis* est donné au monde 11.

```python
"grammaire": {
    "question": "Quel est le radical de « pons, pontis » (le pont) ?",
    "options": ["Pont-", "Pons-", "Pontis-", "Ponti-"],
    "answer": 0,
    "explications": [
        "",
        "Tu as gardé le nominatif tel quel. Le radical se lit dans le génitif.",
        "Il reste la terminaison -is, qu'il faut retirer.",
        "Il reste le i de la terminaison -is.",
    ],
},
```

## m12-02 · Les Terminaisons de la 3e Déclinaison

Règle de la leçon : le COD de la 3e déclinaison prend -em (*regem*, *militem*), le radical vient du génitif.
Déjà utilisé dans le cours et l'exercice : *Consul militem convocat*. Dans l'arène : *regem*, *ducem*, *duci*.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « Le sénateur voit le roi » ? (senator, senatoris = le sénateur)",
    "options": ["Senatorem rex videt.", "Senator rex videt.", "Senator regem videt.", "Senator regis videt."],
    "answer": 2,
    "explications": [
        "Les rôles sont inversés : la fin -em marque celui qui subit l'action.",
        "Aucun mot ne porte la fin du COD : on ne sait pas qui est vu.",
        "",
        "Cette fin est celle du génitif (« de »). Elle ne marque pas le COD.",
    ],
},
```

## m12-03 · Le Consul au Forum

Règle de la leçon : le datif de la 3e déclinaison (-i au singulier, -ibus au pluriel) désigne celui qui reçoit.
Déjà utilisé dans le cours et l'exercice : *Dux leges civibus dat*, *Consul legem civibus dat*.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « Le chef donne le pain au soldat » ? (panis = le pain)",
    "options": ["Dux militem panem dat.", "Dux militi panem dat.", "Dux militis panem dat.", "Dux militibus panem dat."],
    "answer": 1,
    "explications": [
        "La fin -em marque un COD, mais le pain occupe déjà ce rôle.",
        "",
        "Cette fin dit « du soldat » : elle complète un nom au lieu de désigner celui qui reçoit.",
        "Cette fin est celle du pluriel : plusieurs soldats recevraient le pain.",
    ],
},
```

## m13-01 · Les Noms en -I : Civis et Navis

Règle de la leçon : les noms en -i font leur génitif pluriel en -ium (*civium*, *navium*, *hostium*).
Déjà utilisé dans le cours et l'exercice : *civium*, *navium*, *hostium*. Les noms *avis* et *vox* viennent des mondes 2 et 12.

```python
"grammaire": {
    "question": "Comment dit-on « la voix des oiseaux » ? (vox = la voix ; avis, avis = l'oiseau, un nom en -i)",
    "options": ["Vox avum.", "Vox avibus.", "Vox avarum.", "Vox avium."],
    "answer": 3,
    "explications": [
        "Ce génitif pluriel copie regum, mais avis fait partie d'une autre famille de noms.",
        "Cette fin sert pour celui qui reçoit ou pour une circonstance, pas pour dire « de ».",
        "Cette fin est celle du génitif pluriel des noms comme rosa.",
        "",
    ],
},
```

## m13-02 · Les Noms Neutres : Mare et Corpus

Règle de la leçon : au pluriel, les neutres finissent par -a (ou -ia).
Déjà utilisé dans le cours et l'exercice : *maria*, *corpora*, *flumina*, *tempora*, *nomina*. Dans l'arène : *corpora*.

```python
"grammaire": {
    "question": "Quelle forme veut dire « les têtes » ? (caput, capitis = la tête, un nom neutre)",
    "options": ["Capita", "Capites", "Capiti", "Capitos"],
    "answer": 0,
    "explications": [
        "",
        "Cette fin est celle des noms masculins ou féminins comme reges. Un neutre suit une autre règle.",
        "Cette forme est au singulier.",
        "Cette fin est celle du COD pluriel des noms comme servus.",
    ],
},
```

## m13-03 · La Flotte de Rome sur la Mer : REPRISE (nominatif pluriel en -es, m12-02)

Règle de la leçon : aucune (récit sur Carthage, « Mare Nostrum »). Reprise du nominatif pluriel de la 3e déclinaison et de l'accord du verbe.
Déjà utilisé dans le cours et l'exercice : *Naves Romanae in mari navigant*, *Navis Romana in mari navigat*.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « Les chefs courent » ? (dux, ducis = le chef ; currere = courir)",
    "options": ["Dux currunt.", "Ducem currit.", "Duces currunt.", "Duces currit."],
    "answer": 2,
    "explications": [
        "Le verbe est au pluriel, mais le sujet a la forme du singulier.",
        "La fin -em marque le COD : ce mot ne fait pas l'action.",
        "",
        "Le sujet est au pluriel, mais le verbe a la fin du singulier.",
    ],
},
```

## m14-01 · Les Adjectifs de 2ème Classe : Fortis et Ingens

Règle de la leçon : *fortis* garde la même forme au masculin et au féminin ; *forte* est réservé au neutre.
Déjà utilisé dans le cours et l'exercice : *miles fortis*, *bellum forte*.

```python
"grammaire": {
    "question": "Comment dit-on « une mère courageuse » ? (mater = la mère ; fortis, -e = courageux)",
    "options": ["Mater forta.", "Mater fortis.", "Mater forte.", "Mater fortus."],
    "answer": 1,
    "explications": [
        "Cette fin est celle de bona, adjectif de 1re classe, qui ne se décline pas comme fortis.",
        "",
        "Cette fin sert pour un nom neutre.",
        "Cette fin est celle du masculin des adjectifs comme bonus.",
    ],
},
```

## m14-02 · Le Neutre des Adjectifs : Mare Ingens

Règle de la leçon : au neutre pluriel, les adjectifs de 2e classe finissent par -ia (*omnia*, *ingentia*).
Déjà utilisé dans le cours et l'exercice : *omnia*, *ingentia pericula*.

```python
"grammaire": {
    "question": "Complète pour dire « Les légionnaires portent de courts javelots » : Legionarii brev___ pila portant. (brevis, -e = court)",
    "options": ["-a", "-es", "-ium", "-ia"],
    "answer": 3,
    "explications": [
        "Cette fin est celle d'adjectifs comme bonus, d'un autre modèle.",
        "Cette fin va avec des noms masculins ou féminins au pluriel. Ici le nom est neutre.",
        "Cette fin est celle du génitif pluriel, qui dit « de ».",
        "",
    ],
},
```

## m14-03 · Plus fort, le plus fort : Comparatif & Superlatif

Règle de la leçon : comparatif en -ior / -ius, superlatif en -issimus, -a, -um.
Déjà utilisé dans le cours et l'exercice : *fortior*, *altior*, *fortissimus*, *clarissimus*, *Legio Romana fortior est*. Dans l'arène : *clarissimus*.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « La forêt est très haute » ? (silva = la forêt ; altus = haut)",
    "options": ["Silva altissima est.", "Silva altior est.", "Silva alta est.", "Silva altissimus est."],
    "answer": 0,
    "explications": [
        "",
        "Cette forme veut dire « plus haute » : elle compare avec une autre chose.",
        "Cet adjectif n'a aucun suffixe : il dit seulement « haute ».",
        "Cette fin est celle du masculin, or silva est féminin.",
    ],
},
```

## m15-01 · Le Suffixe Magique de l'Imparfait : -BA-

Règle de la leçon : l'imparfait s'obtient en insérant -ba- entre le radical et la fin personnelle.
Déjà utilisé dans le cours et l'exercice : *amabam, amabas, amabat, amabamus, amabatis, amabant*, *legebam*, *audiebam*. Dans l'arène : *pugnabant*.

```python
"grammaire": {
    "question": "Quelle forme veut dire « nous marchions » ? (ambulare = marcher)",
    "options": ["Ambulamus", "Ambulabant", "Ambulabamus", "Ambulabatis"],
    "answer": 2,
    "explications": [
        "Cette forme est au présent : il n'y a pas de -ba- dans le verbe.",
        "Cette fin parle de plusieurs autres personnes (« ils »), pas de « nous ».",
        "",
        "Cette fin s'adresse à plusieurs personnes (« vous »).",
    ],
},
```

## m15-02 · L'Imparfait du Verbe Être : Eram, Eras, Erat

Règle de la leçon : *eram, eras, erat* (j'étais, tu étais, il était) ; au pluriel *era-* + -mus, -tis, -nt.
Déjà utilisé dans le cours et l'exercice : *Romulus primus rex Romae erat*, *Discipuli in schola erant*. Dans l'arène : *erat*.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « Tu étais dans le jardin » ? (hortus = le jardin)",
    "options": ["In horto eram.", "In horto erat.", "In horto es.", "In horto eras."],
    "answer": 3,
    "explications": [
        "La fin -m est celle de « je » : celui qui parle.",
        "La fin -t désigne une autre personne, pas celui à qui l'on parle.",
        "Ce verbe est au présent : il n'a pas le radical era-.",
        "",
    ],
},
```

## m15-03 · Une Scène dans la Rome Républicaine

Règle de la leçon : présent ou imparfait ? On cherche le -ba- (*clamabant* : ils criaient).
Déjà utilisé dans le cours et l'exercice : *conveniebant*, *clamabant*. Dans l'arène : *legebant*.

```python
"grammaire": {
    "question": "Laquelle de ces phrases est à l'imparfait ? (amare = aimer ; dominus = le maître)",
    "options": ["Servus dominum amat.", "Servus dominum amabat.", "Servus dominum amavit.", "Servi dominum amant."],
    "answer": 1,
    "explications": [
        "Il n'y a pas de -ba- entre le radical et la fin : c'est le présent.",
        "",
        "Cette forme n'a pas le -ba- de l'imparfait : le -v- appartient à un autre temps.",
        "Cette forme est au présent et parle de plusieurs esclaves.",
    ],
},
```

## m16-01 · Le Parfait : L'Action Accomplie

Règle de la leçon : les désinences du parfait -i, -isti, -it, -imus, -istis, -erunt.
Déjà utilisé dans le cours et l'exercice : *amavi, amavisti, amavit, amavimus, amavistis, amaverunt*. Dans l'arène : *pugnaverunt*.

```python
"grammaire": {
    "question": "Quelle forme veut dire « tu as chanté » ? (cantare = chanter)",
    "options": ["Cantavisti", "Cantavi", "Cantavit", "Cantabas"],
    "answer": 0,
    "explications": [
        "",
        "Cette fin est celle de « j'ai chanté » : elle désigne celui qui parle.",
        "Cette fin désigne une autre personne, pas celui à qui l'on parle.",
        "Ce verbe a un -ba- : il dit que l'action durait, pas qu'elle est finie.",
    ],
},
```

## m16-02 · Le Parfait du Verbe Être : Fui, Fuisti, Fuit

Règle de la leçon : le parfait de *esse* se forme sur *fu-* avec les désinences du parfait.
Déjà utilisé dans le cours et l'exercice : *Cicero magnus orator fuit*, *Caesar et Pompeius clari duces fuerunt*. Dans l'arène : *fuimus*, *fuerunt*.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « Vous avez été des soldats » ?",
    "options": ["Milites fuisti.", "Milites fuimus.", "Milites fuistis.", "Milites fuerunt."],
    "answer": 2,
    "explications": [
        "Cette fin désigne une seule personne (« tu »), pas plusieurs.",
        "La fin -mus désigne un groupe dont celui qui parle fait partie.",
        "",
        "La fin -erunt désigne d'autres personnes (« ils »), pas celles à qui l'on parle.",
    ],
},
```

## m16-03 · Les Trois Mots de César

Règle de la leçon : le parfait à la 3e personne du singulier finit par -it (*vicit* : il a vaincu).
Déjà utilisé dans le cours et l'exercice : *veni, vidi, vici*, *vicit*, *Caesar Gallos vicit*.

```python
"grammaire": {
    "question": "Que veut dire « Puer lupum vidit. » ? (videre = voir ; lupus = le loup)",
    "options": ["L'enfant voit le loup.", "L'enfant voyait le loup.", "Le loup voit l'enfant.", "L'enfant a vu le loup."],
    "answer": 3,
    "explications": [
        "Le présent de ce verbe est videt, avec une autre voyelle.",
        "L'imparfait aurait le son -ba- dans le verbe.",
        "Les rôles sont inversés : la fin -m marque ce qui subit l'action.",
        "",
    ],
},
```

## m17-01 · Le Futur de l'Indicatif : Amabo & Legam

Règle de la leçon : le futur des verbes en -are et -ere s'obtient avec -bo, -bis, -bit, -bimus, -bitis, -bunt.
Déjà utilisé dans le cours et l'exercice : *amabo, amabis, amabit, amabimus, amabitis, amabunt*, *ero, eris, erit...*. Dans l'arène : *pugnabunt*, *erimus*.

```python
"grammaire": {
    "question": "Quelle forme veut dire « vous chanterez » ? (cantare = chanter)",
    "options": ["Cantabatis", "Cantabitis", "Cantatis", "Cantavistis"],
    "answer": 1,
    "explications": [
        "Le suffixe -ba- raconte le passé : il dit que l'action durait.",
        "",
        "Ce verbe n'a aucun suffixe : c'est le présent.",
        "Le -vi- appartient au temps de l'action achevée.",
    ],
},
```

## m17-02 · Le Pronom Démonstratif : Is, Ea, Id

Règle de la leçon : *is, ea, id* ; au COD *eum* (masculin), *eam* (féminin), *id* (neutre).
Déjà utilisé dans le cours et l'exercice : *Caesar eum vincet*, *Caesar eam capiet*.

```python
"grammaire": {
    "question": "Complète pour dire « L'enfant le voit » : Puer lupum videt. Puer ___ videt.",
    "options": ["eum", "eam", "id", "is"],
    "answer": 0,
    "explications": [
        "",
        "Cette forme remplace un nom féminin, or lupus est masculin.",
        "Cette forme remplace un nom neutre.",
        "Cette forme est celle du sujet, alors qu'il faut remplacer le COD.",
    ],
},
```

## m17-03 · Le Siège d'Alésia (52 av. J.-C.) : REPRISE (parfait, m16)

Règle de la leçon : aucune règle nouvelle (récit sur Alésia ; l'exercice rappelle l'imparfait). Reprise du parfait, souvent confondu avec l'imparfait.
Déjà utilisé dans le cours et l'exercice : *Galli pro libertate pugnabant*, *Vercingetorix pro libertate pugnabat*. Dans l'arène : *Romani pugnabunt*.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « Les Gaulois ont envoyé des messagers » ? (mittere = envoyer, parfait misi ; nuntius = le messager)",
    "options": ["Gallus nuntios miserunt.", "Galli nuntios misit.", "Galli nuntios miserunt.", "Galli nuntios mittebant."],
    "answer": 2,
    "explications": [
        "Le sujet est au singulier, mais le verbe a la fin du pluriel.",
        "Le sujet est au pluriel, mais le verbe a la fin du singulier.",
        "",
        "Le suffixe -ba- raconte une action qui durait, pas une action achevée.",
    ],
},
```

## m18-01 · La Fin de la République et les Ides de Mars : REPRISE (futur et is, ea, id, m17)

Règle de la leçon : aucune (récit sur César et les Ides de Mars). Reprise du futur et du pronom COD.
Déjà utilisé dans le cours et l'exercice : *Tu quoque, mi fili*, aucune autre phrase.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « Brutus le verra » ? (le = César, un homme ; videre = voir)",
    "options": ["Brutus is videbit.", "Brutus eum videbat.", "Brutus eam videbit.", "Brutus eum videbit."],
    "answer": 3,
    "explications": [
        "Cette forme est celle du sujet. Brutus est déjà le sujet de la phrase.",
        "Le suffixe -ba- raconte le passé, pas ce qui arrivera.",
        "Cette forme remplace un nom féminin, or César est un homme.",
        "",
    ],
},
```

## m18-02 · Le Grand Défi Grammatical de 4ème

Règle de la leçon : le parfait à la 3e personne du pluriel finit par -erunt (*servaverunt*).
Déjà utilisé dans le cours et l'exercice : *servavi*, *Milites patriam servaverunt*.

```python
"grammaire": {
    "question": "Quelle phrase veut dire « Les citoyens ont défendu la patrie » ? (defendere = défendre, parfait defendi)",
    "options": ["Cives patriam defendit.", "Cives patriam defenderunt.", "Cives patriam defendebant.", "Cives patriam defendunt."],
    "answer": 1,
    "explications": [
        "Le sujet est au pluriel, mais le verbe a la fin du singulier.",
        "",
        "Le suffixe -ba- raconte une action qui durait, pas une action achevée.",
        "Ce verbe est au présent : sa fin ne marque pas une action achevée.",
    ],
},
```

## m18-03 · Proclamation Républicaine

Règle de la leçon : le génitif de la 3e déclinaison (-is) et le parfait dans une même phrase.
Déjà utilisé dans le cours et l'exercice : *Virtus et sapientia rem publicam servant*, *Sapientia consulis rem publicam servavit*.

```python
"grammaire": {
    "question": "Complète pour dire « la voix du chef » : Vox duc___. (dux = le chef)",
    "options": ["-is", "-em", "-i", "-es"],
    "answer": 0,
    "explications": [
        "",
        "Cette fin est celle du COD, qui subit l'action, pas du complément du nom.",
        "Cette fin marque celui qui reçoit, pas le complément du nom.",
        "Cette fin désigne plusieurs chefs, au sujet ou au COD.",
    ],
},
```

---

## Leçons traitées par reprise faute de règle

4 leçons sur 24 : m11-01 (datif, m10-04), m13-03 (nominatif pluriel en -es, m12-02), m17-03 (parfait, m16), m18-01 (futur et *is, ea, id*, m17).
Les 20 autres appliquent la règle de leur leçon. La reprise de m17-03 est choisie parce que l'exercice de la leçon ne fait que rappeler l'imparfait ; la question teste donc l'autre temps du passé, le plus souvent confondu.

## Doutes pour l'enseignant

1. **m11-03** : le cours ne donne que *transit*. L'explication de la mauvaise option « Tu traverses la forêt » dit que la fin serait -s ; c'est exact (*transis*), mais le cours ne le montre pas.
2. **m12-02, m12-03** : *panem*, *militi*, *militem* sont des formes dérivables du cours (radical + terminaison), mais *panem* vient du monde 8 sans que la 3e déclinaison soit alors nommée. *Senatorem* n'apparaît que comme mauvaise option.
3. **m13-01** : *avis* est bien un nom en -i (*avium*). Le cours ne cite que *civis, navis, hostis, ignis* ; la traduction et la mention « nom en -i » sont dans l'énoncé. Je n'ai pas pris *canis* : son génitif pluriel est *canum*, une exception.
4. **m13-02** : *capita* se déduit de *caput, capitis* (radical *capit-* + -a). *Caput* vient du monde 7, sans règle des neutres à ce moment-là.
5. **m14-02** : *brevis* n'a pas de monde dans le thesaurus ; sa traduction est dans l'énoncé. Le neutre pluriel *brevia* suit *omnia*.
6. **m14-03** : l'option « Silva altissimus est. » teste l'accord en genre, que le cours du monde 14 n'aborde qu'implicitement (« -issimus, -a, -um »).
7. **m15-03** : *audire* (imparfait *audiebat*, en -ieba-, jamais enseigné) remplacé par *amare* par l'architecte. L'explication de *amavit* parle d'« un autre temps » sans le nommer, car le parfait n'arrive qu'au monde 16.
8. **m16-03, m18-02** : *vidit* et *defendit* se confondent avec le présent à la lecture rapide (*defendit* est identique au présent). Dans m18-02 *defendit* n'est qu'une mauvaise option, rejetée pour le nombre. Dans m16-03 *videt* et *vidit* diffèrent par la voyelle.
9. **m17-03** : j'ai donné *misi* dans l'énoncé (il vient de m7-03) pour que la forme *miserunt* se déduise des désinences du parfait.
10. **m17-01 et m18-01** : le cours dit « verbes en -are et -ere » pour le futur en -bo. Je n'ai utilisé que *cantare* et *videre* (2e conjugaison), jamais un verbe de la 3e conjugaison dont le futur est en -am.
11. **m18-01** : « le » est précisé par « César, un homme » dans l'énoncé, pour que *eum* soit la seule forme possible.
12. **m15-01, m16-01, m17-01** : le même verbe *cantare* ou *ambulare* sert de modèle pour fixer le suffixe de chaque temps ; la comparaison d'une leçon à l'autre est voulue.
13. Index des bonnes réponses : 0 (6 fois), 1 (6), 2 (6), 3 (6). Pas de motif fixe.
