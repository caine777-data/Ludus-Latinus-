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
            "options": ["En -IS (ex: regis, ducis)", "En -AE (ex: rosae)", "En -I (ex: domini)", "En -UM (ex: templi)"],
            "answer": 0,
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

Complète pour mettre le mot *miles* (le soldat) à l'accusatif singulier (COD) :
« Le consul convoque le soldat » (*Consul militem convocat*).""",
            "consigne": "Complète le mot 'soldat' à l'accusatif singulier (-em) :",
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

Reconstitue cette phrase en latin de la 3e déclinaison :
*« Dux leges civibus dat. »*
*(Dux = le chef [Nom.], leges = les lois [Acc. pl.], civibus = aux citoyens [Dat. pl.], dat = donne)*""",
            "latin": "Dux leges civibus dat.",
            "mots": ["Le chef", "donne", "des lois", "aux citoyens.", "Le soldat", "marche."],
            "solution": "Le chef donne des lois aux citoyens.",
        },
        {
            "id": "m12-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Tribun de la Plèbe",
            "content": """## Face au protecteur des citoyens modestes
Le tribun de la plèbe veille sur les lois du Forum. Démontre ta maîtrise de la 3ème déclinaison pour gagner **50 Sesterces 🪙** !""",
            "boss": {"nom": "Le Tribun de la Plèbe", "icone": "⚖️", "pv": 3},
            "questions": [
                {
                    "question": "Que signifient les célèbres initiales S.P.Q.R. ?",
                    "options": [
                        "Senatus Populusque Romanus (Le Sénat et le Peuple Romain)",
                        "Semper Primus Quisque Romanus (Toujours premier, chaque Romain)",
                        "Societas Publica Quiritium Romae",
                        "Salus Populi Quotidie Regnat"
                    ],
                    "answer": 0,
                    "explanation": "SPQR = Le Sénat et le Peuple Romain, devise officielle de la République !"
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
