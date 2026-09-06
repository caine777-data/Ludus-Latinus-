"""
Monde 13 — Mare Nostrum & Les Conquêtes.
La 3ème déclinaison (suite) : les thèmes en -i (civis, navis) et les neutres (mare, corpus).
Les guerres puniques contre Carthage et la maîtrise de la Méditerranée.
"""

LEVEL = {
    "id": "monde13",
    "classe": "4eme",
    "title": "13 · Mare Nostrum & Les Conquêtes ⛵",
    "lessons": [
        {
            "id": "m13-01",
            "type": "quiz",
            "title": "Les Noms en -I : Civis et Navis",
            "content": """## Les frères jumeaux (Parisyllabiques)
Dans la 3ème déclinaison, certains noms ont le **même nombre de syllabes** au nominatif et au génitif singulier. On les appelle les *parisyllabiques* (thèmes en -i) :
- **Civis, civis** (m.) : le citoyen
- **Navis, navis** (f.) : le navire, la trirème
- **Hostis, hostis** (m.) : l'ennemi (*➔ hostile*)
- **Ignis, ignis** (m.) : le feu

💡 **La seule différence avec les autres noms de la 3e déclinaison** :
Au génitif pluriel (complément du nom), ils prennent **-IUM** au lieu de -um !
- *civium* = des citoyens
- *navium* = des navires
- *hostium* = des ennemis""",
            "question": "Quel est le génitif pluriel de 'navis, navis' (le navire) ?",
            "options": ["Navium (des navires)", "Navum", "Navibus", "Navarum"],
            "answer": 0,
            "explanation": "Les thèmes en -i font leur génitif pluriel en -ium !",
        },
        {
            "id": "m13-02",
            "type": "trou",
            "title": "Les Noms Neutres : Mare et Corpus",
            "content": """## La Règle d'Or des Noms Neutres ⚖️
En latin, les noms neutres respectent TOUJOURS une règle absolue, quelle que soit la déclinaison :
1. **Nominatif = Vocatif = Accusatif** (la même forme pour le sujet et le COD !).
2. **Au pluriel, ils se terminent toujours par un -A** (ou **-IA**) !

Exemples majeurs de 3e déclinaison :
- **Mare, maris** (n.) : la mer ➔ pluriel : **maria** (les mers)
- **Corpus, corporis** (n.) : le corps ➔ pluriel : **corpora** (les corps)
- **Flumen, fluminis** (n.) : le fleuve ➔ pluriel : **flumina** (les fleuves)
- **Tempus, temporis** (n.) : le temps ➔ pluriel : **tempora** (les temps)

Complète pour dire : « Les navires parcourent les mers » (*Naves maria percurrunt*).""",
            "consigne": "Complète 'les mers' au pluriel neutre (-ia) :",
            "avant": "Naves mar",
            "apres": " percurrunt.",
            "solution": "ia",
            "latin_complet": "Naves maria percurrunt.",
        },
        {
            "id": "m13-03",
            "type": "puzzle",
            "title": "La Flotte de Rome sur la Mer",
            "content": """## Pourquoi « Mare Nostrum » ?
Après avoir vaincu la cité maritime de **Carthage** (commandée par le redoutable Hannibal Barca) lors des trois guerres puniques, Rome contrôle toutes les côtes de la Méditerranée.

Les Romains appellent désormais fièrement la mer Méditerranée :
*« Mare Nostrum »* (« Notre Mer »).

Reconstitue cette phrase sur la puissance maritime romaine :
*« Naves Romanae in mari navigant. »*
*(Naves Romanae = les navires romains [Nom. pl.], in mari = sur la mer [Abl. sg.], navigant = naviguent)*""",
            "latin": "Naves Romanae in mari navigant.",
            "mots": ["Les navires", "romains", "naviguent", "sur la mer.", "L'ennemi", "fuit."],
            "solution": "Les navires romains naviguent sur la mer.",
        },
        {
            "id": "m13-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Corsaire Carthaginois",
            "content": """## Combat naval au large de la Sicile
Une galère ennemie aborde ton navire de guerre ! Montre ta science des neutres et de la mer pour remporter **50 Sesterces 🪙** !""",
            "boss": {"nom": "Le Corsaire d'Hannibal", "icone": "⚓", "pv": 3},
            "questions": [
                {
                    "question": "Quelle est la règle d'or de TOUS les noms neutres latins ?",
                    "options": [
                        "Le Nominatif, le Vocatif et l'Accusatif sont toujours identiques",
                        "Ils n'existent qu'au singulier",
                        "Leur génitif finit toujours par -ae",
                        "Ils désignent uniquement des personnes"
                    ],
                    "answer": 0,
                    "explanation": "Les 3 cas directs (Nom., Voc., Acc.) sont toujours identiques pour les neutres !"
                },
                {
                    "question": "Comment dit-on 'les corps' au pluriel neutre pour 'corpus, corporis' ?",
                    "options": ["Corpora", "Corpuses", "Corpori", "Corpusum"],
                    "answer": 0,
                    "explanation": "Radical corpor- + désinence neutre pluriel -a = corpora !"
                },
                {
                    "question": "Que signifiait l'expression 'Mare Nostrum' pour les Romains ?",
                    "options": [
                        "Notre Mer (la Méditerranée)",
                        "La Grande Eau",
                        "La Mer Rouge",
                        "L'Océan infini"
                    ],
                    "answer": 0,
                    "explanation": "Mare Nostrum désignait la mer Méditerranée entièrement entourée de provinces romaines."
                }
            ]
        }
    ]
}
