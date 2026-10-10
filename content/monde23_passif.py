"""
Monde 23 — Les Échos du Forum : La Voix Passive.
La voix passive au présent et à l'imparfait (-or, -ris, -tur, -mur, -mini, -ntur),
le complément d'agent introduit par a/ab + ablatif,
et l'art de l'éloquence chez Cicéron plaidant au Sénat.
"""

LEVEL = {
    "id": "monde23",
    "classe": "3eme",
    "title": "23 · Les Échos du Forum : La Voix Passive 🏛️",
    "lessons": [
        {
            "id": "m23-01",
            "type": "quiz",
            "title": "La Voix Passive : Quand le Sujet Subit l'Action",
            "content": """## Actif ou Passif ?
- **À la voix active** : le sujet fait l'action ➔ *« Le maître loue l'élève »* (*Magister discipulum laudat*).
- **À la voix passive** : le sujet subit l'action ➔ *« L'élève est loué par le maître »* (*Discipulus a magistro laudatur*).

Les désinences personnelles passives au présent :
- 1ère sg : **-OR** *(laudor = je suis loué)*
- 2ème sg : **-RIS** *(laudaris = tu es loué)*
- 3ème sg : **-TUR** *(laudatur = il est loué)*
- 1ère pl : **-MUR** *(laudamur = nous sommes loués)*
- 2ème pl : **-MINI** *(laudamini = vous êtes loués)*
- 3ème pl : **-NTUR** *(laudantur = ils sont loués)*

💡 **Le Complément d'Agent (par qui l'action est faite)** :
Il s'exprime avec la préposition **A** (ou **AB** devant voyelle) suivie de l'**Ablatif** !
*A magistro* = par le maître.""",
            "question": "Quelle est la désinence de 3e personne du singulier au passif (ex: 'il est aimé') ?",
            "options": ["-tur", "-ntur", "-ris", "-mur"],
            "answer": 0,
            "explications": [
                "",
                "Cette terminaison indique un sujet pluriel (ils ou elles), pas un sujet singulier.",
                "Cette finale s'emploie pour la deuxième personne du singulier (tu es félicité).",
                "-mur est la désinence de la 1re personne du pluriel au passif, comme amamur (nous sommes aimés).",
            ],
            "explanation": "La terminaison -tur indique la 3e personne singulier passive : amatur = il est aimé.",
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
        },
        {
            "id": "m23-02",
            "type": "trou",
            "title": "Le Complément d'Agent (A / Ab + Ablatif)",
            "content": """## Par qui ? (A ou AB)
Quand l'action est accomplie par une personne vivante, on utilise toujours la préposition **A** (ou **AB**) avec l'ablatif :

- *Urbs a civibus defenditur.* = « La ville est défendue par les citoyens. »
- *Lex a consule legitur.* = « La loi est lue par le consul. »

Au passif, la 3e personne se termine par **-tur** au singulier (*defenditur*) et par **-ntur** au pluriel.

À toi ! *Laudo, -as, -are* = louer, féliciter ; *dux, ducis* = le général.
Complète pour dire : « Les braves soldats sont loués par le général ».""",
            "consigne": "Complète le verbe au passif : son sujet est au pluriel.",
            "avant": "Fortes milites a duce lauda",
            "apres": ".",
            "solution": "ntur",
            "latin_complet": "Fortes milites a duce laudantur.",
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
        },
        {
            "id": "m23-03",
            "type": "puzzle",
            "title": "Le Discours de Cicéron au Sénat",
            "content": """## L'art oratoire au sommet
En 63 av. J.-C., le consul et grand orateur **Cicéron** prononce ses foudroyantes *Catilinaires* pour déjouer le complot de Catilina contre la République.

Exemple : *« Pax et concordia a civibus quaeruntur. »* = « La paix et la concorde sont recherchées par les citoyens. »

À toi ! Qui fait l'action, qui la subit ? Regarde la fin du verbe et la préposition *a*.
*Libertas, -atis* (f.) = la liberté ; *defendo, -is, -ere* = défendre.""",
            "latin": "Libertas a populo Romano defenditur.",
            "mots": ["La liberté", "est défendue", "par le peuple romain.", "défend", "le peuple romain."],
            "solution": "La liberté est défendue par le peuple romain.",
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
        },
        {
            "id": "m23-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Procureur du Barreau",
            "content": """## Devant les juges du Tribunal de Rome
Le procureur public de la Curie met à l'épreuve ton discernement de la voix passive. Remporte l'épreuve pour gagner une bourse de **sesterces 🪙** !""",
            "boss": {"nom": "L'Orateur du Barreau", "icone": "⚖️", "pv": 3},
            "questions": [
                {
                    "question": "Quelle phrase veut dire « Le citoyen est loué par le consul » ?",
                    "options": ["Civis consulem laudat.", "Consul civem laudatur.", "Civis a consule laudatur.", "Consul a cive laudatur."],
                    "answer": 2,
                    "explanation": "« Civis » est le sujet ; « laudatur » (-tur) est le passif ; « a consule » = par le consul. La phrase 3 inverse les rôles (« le consul est loué par le citoyen »)."
                },
                {
                    "question": "Quelle préposition introduit le complément d'agent en latin ?",
                    "options": ["AD ou APUD (+ accusatif)", "A ou AB (+ ablatif)", "CUM ou SINE (+ ablatif)", "PRO ou PRAE (+ ablatif)"],
                    "answer": 1,
                    "explanation": "A ou AB devant voyelle, suivi de l'ablatif, introduit l'auteur de l'action subie."
                },
                {
                    "question": "Qui était le plus grand orateur et maître de la rhétorique à Rome ?",
                    "options": ["Cicéron", "Sénèque", "Pompée", "Brutus"],
                    "answer": 0,
                    "explanation": "Cicéron est considéré comme l'inégalable maître de l'éloquence latine."
                }
            ]
        }
    ]
}
