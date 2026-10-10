"""
Monde 12 — Le Sénat et le Peuple Romain (SPQR).
La 3ème déclinaison (noms consonantiques masculins et féminins)
et le fonctionnement des institutions républicaines (consuls, sénat).
"""

LEVEL = {
    "id": "monde12",
    "classe": "4eme",
    "title": "12 · Le Sénat et le Peuple (SPQR) 🏛️",
    "lessons": [
        {
            "id": "m12-01",
            "type": "quiz",
            "title": "La 3ème Déclinaison : Les Rois et les Consuls",
            "content": """## Le pilier grammatical de 4ème
Tu connais déjà la 1ère déclinaison (en *-a* comme *rosa*) et la 2ème (en *-us* comme *dominus*).

En 4ème, tu découvres la déclinaison la plus fréquente et la plus riche de toute la langue latine : la **3ème déclinaison** !

Dans le dictionnaire, un nom de la 3e déclinaison se reconnaît TOUJOURS à son **Génitif en -IS** :
- **Rex, regis** (m.) : le roi
- **Consul, consulis** (m.) : le consul (chef suprême de la République)
- **Dux, ducis** (m.) : le chef, le général (*➔ a donné duc, conduire*)
- **Miles, militis** (m.) : le soldat (*➔ militaire*)
- **Vox, vocis** (f.) : la voix

💡 **Astuce magique pour trouver le radical** :
Prends le génitif singulier (*reg-is*) et retire la terminaison **-is**. Tu obtiens le radical : **REG-** ! C'est sur ce radical que tu colles toutes les autres terminaisons.""",
            "question": "À quelle terminaison du génitif singulier reconnaît-on un nom de la 3ème déclinaison ?",
            "options": ["En -IS", "En -AE", "En -I", "En -UM"],
            "answer": 0,
            "explications": [
                "",
                "-ae est la marque du génitif des noms comme rosa, pas de ceux de la 3e déclinaison.",
                "Cette désinence caractérise les noms masculins et neutres de la deuxième déclinaison.",
                "-um marque le nominatif ou l'accusatif des noms neutres, ou un génitif pluriel, pas le génitif singulier.",
            ],
            "explanation": "Exactement ! Le génitif singulier en -is est la signature absolue de la 3e déclinaison !",
        },
        {
            "id": "m12-02",
            "type": "trou",
            "title": "Les Terminaisons de la 3e Déclinaison",
            "content": """## Le tableau des désinences (Masculin / Féminin)

Voici les terminaisons à mémoriser pour la 3e déclinaison consonantique :

| Cas | Singulier | Pluriel |
| :--- | :--- | :--- |
| **Nominatif** (Sujet) | variable *(rex, consul)* | **-ES** *(reges, consules)* |
| **Accusatif** (COD) | **-EM** *(regem, consulem)* | **-ES** *(reges, consules)* |
| **Génitif** (Compl. du Nom) | **-IS** *(regis, consulis)* | **-UM** *(regum, consulum)* |
| **Datif** (COI / Attribution) | **-I** *(regi, consuli)* | **-IBUS** *(regibus, consulibus)* |
| **Ablatif** (Circonstance) | **-E** *(rege, consule)* | **-IBUS** *(regibus, consulibus)* |

Complète pour mettre le mot *miles, militis* (le soldat) à l'accusatif singulier (COD) :
« Le consul convoque le soldat ».""",
            "consigne": "Complète le mot « soldat » à l'accusatif singulier :",
            "avant": "Consul milit",
            "apres": " convocat.",
            "solution": "em",
            "latin_complet": "Consul militem convocat.",
        },
        {
            "id": "m12-03",
            "type": "puzzle",
            "title": "Le Consul au Forum",
            "content": """## Le pouvoir républicain en action
Dans la République romaine, deux **consuls** élus pour un an dirigent l'État et commandent les légions.

Sur le Forum, le consul s'adresse aux citoyens avec autorité.

Sur les monuments et les enseignes, Rome signe **SPQR** : *Senatus Populusque Romanus*, « le Sénat et le peuple romain » (*senatus* = le Sénat, *populus* = le peuple, *-que* = et).

Exemple : *« Dux leges civibus dat. »* = « Le chef donne des lois aux citoyens. »

À toi ! Regarde bien les terminaisons de *lex, legis* (la loi) et de *civis* (le citoyen) :""",
            "latin": "Consul legem civibus dat.",
            "mots": ["Le consul", "donne", "une loi", "aux citoyens.", "des lois", "au citoyen."],
            "solution": "Le consul donne une loi aux citoyens.",
        },
        {
            "id": "m12-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Tribun de la Plèbe",
            "content": """## Face au protecteur des citoyens modestes
Le tribun de la plèbe veille sur les lois du Forum. Démontre ta maîtrise de la 3ème déclinaison pour gagner une bourse de **sesterces 🪙** !""",
            "boss": {"nom": "Le Tribun de la Plèbe", "icone": "⚖️", "pv": 3},
            "questions": [
                {
                    "question": "Complète : « Le consul donne une loi au chef ». Consul legem ___ dat.",
                    "options": ["ducem", "duce", "duci", "ducis"],
                    "answer": 2,
                    "explanation": "Le chef reçoit la loi : c'est le datif, en -i. Le radical de « dux, ducis » est duc- : duc + i = duci. « Ducem » serait un COD, « ducis » un génitif."
                },
                {
                    "question": "Quel est l'accusatif singulier (COD) de 'rex, regis' (le roi) ?",
                    "options": ["Regem", "Regis", "Regi", "Reges"],
                    "answer": 0,
                    "explanation": "Radical reg- + terminaison -em = regem !"
                },
                {
                    "question": "Comment dit-on 'les rois' au nominatif pluriel ?",
                    "options": ["Reges", "Regi", "Regibus", "Regos"],
                    "answer": 0,
                    "explanation": "La terminaison du nominatif pluriel de la 3e déclinaison est -es : reges."
                }
            ]
        }
    ]
}
