"""
Leçons complémentaires : les notions du programme de LCA (BO n°11 du 17 mars 2016)
que l'appli n'enseignait pas encore. Rédaction de l'architecte du 18/10/2026,
relues et branchées le 18/10/2026 : content/__init__.py les insère avant l'arène
de leur monde.

Clé = identifiant du monde ; valeur = liste des leçons à insérer, dans l'ordre,
juste avant l'arène de ce monde.
"""

LECONS_COMPLEMENTAIRES = {
    # 4e : après « is, ea, id » (m17-02). Programme 5e-4e : « hic, ille, iste ; idem ; ipse ».
    "monde17": [{
        "id": "m17-05",
        "type": "quiz",
        "title": "Hic, Ille, Iste : Celui-ci, Celui-là",
        "content": """## Montrer du doigt en latin
Tu connais déjà **is, ea, id** (il, elle, cela). Le latin a d'autres démonstratifs, plus précis :

- **HIC, HAEC, HOC** = celui-ci, celle-ci, ceci (tout près de moi)
- **ILLE, ILLA, ILLUD** = celui-là, celle-là (loin de moi, ou célèbre : *ille Caesar*, « le fameux César »)
- **ISTE, ISTA, ISTUD** = celui-là (près de toi), souvent avec mépris
- **IDEM, EADEM, IDEM** = le même, la même
- **IPSE, IPSA, IPSUM** = lui-même, elle-même

Exemple : *« Hic miles Romanus est, ille Gallus. »* = « Ce soldat-ci est romain, celui-là est gaulois. »

À toi ! Sur la colline d'Alésia, un soldat montre au loin le chef ennemi.""",
        "question": "Que veut dire « ille dux » ?",
        "options": ["Ce chef-là, ce fameux chef", "Ce chef-ci, tout près", "Le même chef", "Le chef lui-même"],
        "answer": 0,
        "explications": [
            "",
            "« Ce chef-ci » se dit hic dux : hic désigne ce qui est proche.",
            "« Le même chef » se dit idem dux.",
            "« Le chef lui-même » se dit dux ipse.",
        ],
        "explanation": "Ille montre ce qui est loin, ou ce qui est célèbre : ille dux, ce chef-là.",
        "grammaire": {
            "question": "Comment dit-on « César lui-même combat » ? (pugnare = combattre)",
            "options": ["Caesar ipse pugnat.", "Caesar idem pugnat.", "Caesar hic pugnat.", "Caesar iste pugnat."],
            "answer": 0,
            "explications": [
                "",
                "Idem veut dire « le même », pas « lui-même ».",
                "Hic veut dire « celui-ci » : il montre, il n'insiste pas.",
                "Iste montre quelqu'un près de toi, souvent avec mépris.",
            ],
        },
    }],
    # 3e : le monde des voies romaines. Programme : « les formes des verbes eo, fio, fero ».
    "monde20": [{
        "id": "m20-05",
        "type": "trou",
        "title": "Eo, Fero, Fio : Aller, Porter, Devenir",
        "content": """## Trois verbes irréguliers pour voyager
Sur les routes de l'Empire, trois verbes très fréquents ne suivent pas les modèles habituels.

**EO, IRE** = aller
- *eo, is, it* = je vais, tu vas, il va
- *imus, itis, eunt* = nous allons, vous allez, ils vont

**FERO, FERRE** = porter
- *fero, fers, fert* = je porte, tu portes, il porte
- *ferimus, fertis, ferunt* = nous portons, vous portez, ils portent

**FIO, FIERI** = devenir, être fait
- *fio, fis, fit* = je deviens, tu deviens, il devient

Exemple : *« Mercator Romam it. »* = « Le marchand va à Rome. » Devant un nom de ville, pas de préposition : *Romam*.

À toi ! Les soldats, cette fois, sont plusieurs.""",
        "consigne": "Complète le verbe « vont » :",
        "avant": "Milites Romam ",
        "apres": ".",
        "solution": "eunt",
        "latin_complet": "Milites Romam eunt.",
        "grammaire": {
            "question": "Que veut dire « Servus aquam fert. » ? (servus = l'esclave ; aqua = l'eau)",
            "options": ["L'esclave porte de l'eau.", "L'esclave va vers l'eau.", "L'esclave devient l'eau.", "L'esclave a porté de l'eau."],
            "answer": 0,
            "explications": [
                "",
                "« Il va » se dit it, du verbe eo.",
                "« Il devient » se dit fit, du verbe fio.",
                "Fert est au présent : il porte maintenant.",
            ],
        },
    }],
    # 3e : après la voix passive. Programme : « la formation du passif et du déponent ».
    "monde23": [{
        "id": "m23-05",
        "type": "quiz",
        "title": "Les Verbes Déponents : Passifs de Forme, Actifs de Sens",
        "content": """## Des verbes déguisés
Certains verbes latins ont la forme du **passif**, mais un sens **actif**. On les appelle **déponents** : ils ont « déposé » leurs formes actives.

- **LOQUOR** = je parle (et non « je suis parlé ») ; *loquitur* = il parle
- **SEQUOR** = je suis (du verbe suivre) ; *sequitur* = il suit
- **HORTOR** = j'encourage ; *hortatur* = il encourage
- **CONOR** = j'essaie ; *conatur* = il essaie

Exemple : *« Cicero in senatu loquitur. »* = « Cicéron parle au Sénat. »

Pour les reconnaître : le dictionnaire les donne avec une forme en **-or** (*loquor*) et un infinitif en **-i** (*loqui*, parler).

À toi ! Les légionnaires marchent derrière leur général.""",
        "question": "Que veut dire « Milites ducem sequuntur. » ? (dux, ducis = le chef)",
        "options": [
            "Les soldats suivent le chef.",
            "Les soldats sont suivis par le chef.",
            "Le chef suit les soldats.",
            "Les soldats suivaient le chef.",
        ],
        "answer": 0,
        "explications": [
            "",
            "Sequor est déponent : sa forme est passive, mais son sens est actif.",
            "Ducem est à l'accusatif : le chef est suivi, il ne suit pas.",
            "Sequuntur est au présent : ils suivent maintenant.",
        ],
        "explanation": "Sequuntur a une forme passive mais un sens actif : les soldats suivent.",
        "grammaire": {
            "question": "Laquelle de ces formes est un verbe déponent ?",
            "options": ["amatur", "loquitur", "portatur", "laudatur"],
            "answer": 1,
            "explications": [
                "C'est le passif de amare : il est aimé.",
                "",
                "C'est le passif de portare : il est porté.",
                "C'est le passif de laudare : il est loué.",
            ],
        },
    }],
    # 3e : le monde des verbes de parole. Programme : « la formation du gérondif ».
    "monde24": [{
        "id": "m24-05",
        "type": "trou",
        "title": "Le Gérondif : l'Art de Parler",
        "content": """## Un verbe qui se déguise en nom
Le **gérondif** permet d'employer un verbe comme un nom. Il se forme avec **-ND-** :

- **-NDI** : *ars dicendi* = l'art de parler (mot à mot : l'art du parler)
- **-NDO** : *legendo discimus* = nous apprenons en lisant
- **AD + -NDUM** : *venit ad pugnandum* = il vient pour combattre

Pour le former : on part du verbe (*dicere*, parler) et on ajoute **-endi**, **-endo** ou **-endum** (*-andi* pour les verbes en *-are* : *amandi*, d'aimer).

Exemple : *« Cicero artem dicendi docet. »* = « Cicéron enseigne l'art de parler. »

À toi ! Les jeunes Romains veulent apprendre l'art d'écrire (*scribere*).""",
        "consigne": "Complète le gérondif « d'écrire » :",
        "avant": "Pueri artem ",
        "apres": " discunt.",
        "solution": "scribendi",
        "latin_complet": "Pueri artem scribendi discunt.",
        "grammaire": {
            "question": "Que veut dire « Legendo discimus. » ? (legere = lire ; discere = apprendre)",
            "options": ["En lisant, nous apprenons.", "Nous lisons pour apprendre.", "Nous avons appris à lire.", "Lis, et nous apprendrons."],
            "answer": 0,
            "explications": [
                "",
                "« Pour apprendre » se dirait ad discendum ou ut discamus.",
                "Discimus est au présent : nous apprenons maintenant.",
                "Legendo n'est pas un ordre : c'est « en lisant ».",
            ],
        },
    }],
    # 3e : après le subjonctif de souhait. Programme : subjonctif du but, de la conséquence, de la condition.
    # Coupé en deux à la demande de Cédric : le but d'abord, la conséquence et la condition ensuite.
    "monde25": [
        {
            "id": "m25-05",
            "type": "puzzle",
            "title": "Le Subjonctif de But : Pour Que",
            "content": """## Le mode des intentions
Tu connais le subjonctif du souhait (*Felix sim !* = Que je sois heureux !). Il sert aussi à dire **dans quel but** on agit :

- **UT + subjonctif** = pour que, pour : *Legimus ut discamus.* = Nous lisons pour apprendre.
- **NE + subjonctif** = pour ne pas, pour que... ne... pas : *Fugit ne capiatur.* = Il fuit pour ne pas être pris.

Pour reconnaître le subjonctif présent : *amet* (au lieu de *amat*), *legat* (au lieu de *legit*), *defendant* (au lieu de *defendunt*), *sit* (au lieu de *est*).

À toi ! Les Romains se battent dans un but précis.""",
            "latin": "Romani pugnant ut patriam defendant.",
            "mots": ["Les Romains", "combattent", "pour défendre la patrie.", "ont combattu", "car ils défendent la patrie."],
            "solution": "Les Romains combattent pour défendre la patrie.",
            "grammaire": {
                "question": "Que veut dire « Fugit ne capiatur. » ? (fugere = fuir ; capere = prendre)",
                "options": [
                    "Il fuit pour ne pas être pris.",
                    "Il fuit pour être pris.",
                    "Il fuit car il n'est pas pris.",
                    "Il ne fuit pas, il est pris.",
                ],
                "answer": 0,
                "explications": [
                    "",
                    "Ne rend le but négatif : pour ne pas être pris.",
                    "Ne + subjonctif exprime un but, pas une cause.",
                    "Ne porte sur capiatur : il fuit bien.",
                ],
            },
        },
        {
            "id": "m25-06",
            "type": "quiz",
            "title": "Si Bien Que, Si : Conséquence et Condition",
            "content": """## Quand le subjonctif imagine
Le subjonctif sert aussi à dire **ce qui en résulte** et **ce qui arriverait si** :

- **TAM... UT + subjonctif** = si... que (la **conséquence**) : *Tam fortis est ut omnes eum timeant.* = Il est si courageux que tous le craignent.
- **ITA... UT + subjonctif** = de telle façon que : *Ita clamat ut omnes audiant.* = Il crie si fort que tous l'entendent.
- **SI + subjonctif** = si (une **condition** imaginée) : *Si venias, gaudeam.* = Si tu venais, je me réjouirais.

Astuce : un petit mot annonce la conséquence (*tam*, *ita*). Sans lui, *ut* + subjonctif exprime le plus souvent le but.

À toi ! Virgile raconte qu'Énée respecte tant les dieux qu'ils veillent sur lui.""",
            "question": "Que veut dire « Aeneas tam pius est ut di eum servent. » ? (di = les dieux ; servare = protéger)",
            "options": [
                "Énée est si pieux que les dieux le protègent.",
                "Énée est pieux pour que les dieux le protègent.",
                "Si Énée était pieux, les dieux le protégeraient.",
                "Les dieux sont si pieux qu'ils protègent Énée.",
            ],
            "answer": 0,
            "explications": [
                "",
                "Tam annonce la conséquence : si pieux que.",
                "Il n'y a pas de si ici : c'est ut, après tam.",
                "Aeneas est au nominatif : c'est Énée qui est pieux.",
            ],
            "explanation": "Après tam (si), ut + subjonctif exprime la conséquence : si pieux que les dieux le protègent.",
            "grammaire": {
                "question": "Que veut dire « Si venias, gaudeam. » ? (venire = venir ; gaudere = se réjouir)",
                "options": [
                    "Si tu venais, je me réjouirais.",
                    "Quand tu viens, je me réjouis.",
                    "Viens pour que je me réjouisse.",
                    "Tu es venu, je me suis réjoui.",
                ],
                "answer": 0,
                "explications": [
                    "",
                    "Venias et gaudeam sont au subjonctif : la condition est imaginée.",
                    "Si veut dire « si », pas « pour que ».",
                    "Ce sont des subjonctifs présents, pas des parfaits.",
                ],
            },
        },
    ],
}
