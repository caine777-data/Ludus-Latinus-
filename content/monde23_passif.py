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
            "options": ["-TUR (ex: amatur, laudatur)", "-T", "-NTUR", "-RIS"],
            "answer": 0,
            "explanation": "La terminaison -tur indique la 3e personne singulier passive : amatur = il est aimé.",
        },
        {
            "id": "m23-02",
            "type": "trou",
            "title": "Le Complément d'Agent (A / Ab + Ablatif)",
            "content": """## Par qui ? (A ou AB)
Quand l'action est accomplie par une personne vivante, on utilise toujours la préposition **A** (ou **AB**) avec l'ablatif :

- *Urbs a civibus defenditur.* = « La ville est défendue par les citoyens. »
- *Lex a consule legitur.* = « La loi est lue par le consul. »

Complète pour dire : « La patrie est aimée de tous les Romains » (*Patria a Romanis amatur*).""",
            "consigne": "Complète le verbe passif 'est aimée' (amatur) :",
            "avant": "Patria a Romanis ama",
            "apres": ".",
            "solution": "tur",
            "latin_complet": "Patria a Romanis amatur.",
        },
        {
            "id": "m23-03",
            "type": "puzzle",
            "title": "Le Discours de Cicéron au Sénat",
            "content": """## L'art oratoire au sommet
En 63 av. J.-C., le consul et grand orateur **Cicéron** prononce ses foudroyantes *Catilinaires* pour déjouer le complot de Catilina contre la République.

Reconstitue cette phrase sur la concorde et la paix :
*« Pax et concordia a civibus quaeruntur. »*
*(Pax et concordia = la paix et la concorde [Nom. pl.], a civibus = par les citoyens [Compl. d'agent], quaeruntur = sont recherchées [Passif pl.])*""",
            "latin": "Pax et concordia a civibus quaeruntur.",
            "mots": ["La paix et la concorde", "sont recherchées", "par les citoyens.", "L'orateur", "dénonce", "le complot."],
            "solution": "La paix et la concorde sont recherchées par les citoyens.",
        },
        {
            "id": "m23-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Procureur du Barreau",
            "content": """## Devant les juges du Tribunal de Rome
Le procureur public de la Curie met à l'épreuve ton discernement de la voix passive. Remporte l'épreuve pour gagner **50 Sesterces 🪙** !""",
            "boss": {"nom": "L'Orateur du Barreau", "icone": "⚖️", "pv": 3},
            "questions": [
                {
                    "question": "Comment se traduit 'Milites a duce laudantur' ?",
                    "options": [
                        "Les soldats sont loués par le chef",
                        "Le chef loue les soldats",
                        "Les soldats louent le chef",
                        "Le chef combat avec les soldats"
                    ],
                    "answer": 0,
                    "explanation": "Laudantur est au passif pluriel : les soldats sont loués (par le chef)."
                },
                {
                    "question": "Quelle préposition introduit le complément d'agent en latin ?",
                    "options": ["A ou AB (+ ablatif)", "IN (+ accusatif)", "CUM (+ ablatif)", "PRO (+ ablatif)"],
                    "answer": 0,
                    "explanation": "A ou AB devant voyelle, suivi de l'ablatif, introduit l'auteur de l'action subie."
                },
                {
                    "question": "Qui était le plus grand orateur et maître de la rhétorique à Rome ?",
                    "options": ["Cicéron (Marcus Tullius Cicero)", "Néron", "Pompée", "Romulus"],
                    "answer": 0,
                    "explanation": "Cicéron est considéré comme l'inégalable maître de l'éloquence latine."
                }
            ]
        }
    ]
}
