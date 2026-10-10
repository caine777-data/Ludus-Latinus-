"""
Monde 26 — Le Grand Triomphe du Cycle 4 (Brevet des Collèges & Maître de Rome).
L'épreuve finale et suprême de tout le collège (5ème, 4ème, 3ème).
Synthèse complète de la langue, de la mythologie et de l'histoire romaine.
Face à l'Empereur Trajan, mène à son terme le grand voyage à travers Rome !
"""

LEVEL = {
    "id": "monde26",
    "classe": "3eme",
    "title": "26 · Le Grand Triomphe du Collège 👑",
    "lessons": [
        {
            "id": "m26-01",
            "type": "quiz",
            "title": "La Grande Synthèse du Cycle 4",
            "content": """## Tu touches au but, jeune érudit !
De ton premier *« Salve ! »* en 5ème jusqu'aux chefs-d'œuvre de Virgile et à l'Ablatif Absolu en 3ème, tu as parcouru **1000 ans d'histoire et de langue romaine** :

- **Les 5 déclinaisons** : *rosa* (1), *dominus/templum* (2), *rex/civis/mare* (3), *manus* (4), *res/dies* (5).
- **Tous les cas** : Nominatif (Sujet), Vocatif (Appel), Accusatif (COD), Génitif (Complément du nom), Datif (COI), Ablatif (Complément circonstanciel).
- **Tous les temps de l'indicatif** : Présent (*amat*), Imparfait (*amabat*), Parfait (*amavit*), Futur (*amabit*).
- **Les constructions reines** : Participe Parfait Passif (*amatus*), Ablatif Absolu (*urbe capta*), Proposition Infinitive (*scio te venire*), Voix Passive (*laudatur*).
- Sous Trajan, en 117, l'empire atteint sa plus grande étendue, de la Bretagne à la Mésopotamie.

Prépare-toi à gravir les marches sacrées du Forum pour le couronnement suprême !""",
            "question": "Quelle construction réunit un nom et un participe tous deux au cas ablatif sans mot de liaison ?",
            "options": ["L'Ablatif absolu", "L'Accusatif de relation", "La Proposition infinitive", "Le Datif de possession"],
            "answer": 0,
            "explications": [
                "",
                "Le nom est à l'accusatif dans cette construction, alors que la question parle de deux mots à l'ablatif.",
                "La proposition infinitive met son sujet à l'accusatif et son verbe à l'infinitif : aucun ablatif.",
                "Le datif de possession dit à qui appartient une chose, avec le verbe être : il n'utilise pas deux ablatifs.",
            ],
            "explanation": "C'est l'Ablatif Absolu, véritable marque de fabrique du latin classique !",
        },
        {
            "id": "m26-02",
            "type": "trou",
            "title": "L'Épreuve du Manuscrit Impérial",
            "content": """## Déchiffrer la devise éternelle
Pour sceller ton parcours de latiniste du collège, lis cette devise :
*Populus Romanus libertatem et pacem servat.* = « Le peuple romain conserve la liberté et la paix. »

- *Populus Romanus* = le peuple romain (Nom. sg.)
- *Libertatem* = la liberté (Acc. sg. en -em)
- *Pacem* = la paix (Acc. sg. en -em)
- *Servat* = conserve / protège (3e personne du singulier du présent)

À toi ! Le sujet change : *cives Romani* (les citoyens romains) est au pluriel.
Complète pour dire : « Les citoyens romains protègent la liberté ».""",
            "consigne": "Accorde le verbe avec son sujet au pluriel :",
            "avant": "Cives Romani libertatem serv",
            "apres": ".",
            "solution": "ant",
            "latin_complet": "Cives Romani libertatem servant.",
        },
        {
            "id": "m26-03",
            "type": "puzzle",
            "title": "Le Serment du Citoyen Émérite",
            "content": """## La flamme de la connaissance
Une noble sentence qui traversera les siècles :

*« Litterae et sapientia mentem hominis ornant. »* = « Les lettres et la sagesse embellissent l'esprit de l'homme. »

À toi ! Deux sujets, un verbe : regarde sa terminaison.
*Virtus, -utis* (f.) = le courage ; *res publica* = la République ; *servo, -as, -are* = protéger.""",
            "latin": "Virtus et sapientia rem publicam servant.",
            "mots": ["Le courage et la sagesse", "protègent", "la République.", "protège", "de la République."],
            "solution": "Le courage et la sagesse protègent la République.",
        },
        {
            "id": "m26-04",
            "type": "arene",
            "title": "👑 Défi Suprême : L'Empereur Trajan en Majesté",
            "content": """## Le Triomphe de Rome — Fin du Cycle 4
Sous la colonne Trajane, en présence du Sénat au grand complet, l'Empereur Trajan (*Optimus Princeps*) te décerne une bourse de **sesterces 🪙** !""",
            "boss": {"nom": "L'Empereur Trajan", "icone": "👑", "pv": 4},
            "questions": [
                {
                    "question": "Combien de déclinaisons régulières compte la langue latine ?",
                    "options": ["5 déclinaisons", "3 déclinaisons", "7 déclinaisons", "12 déclinaisons"],
                    "answer": 0,
                    "explanation": "La langue latine s'articule sur 5 grandes déclinaisons nominales."
                },
                {
                    "question": "Comment se traduit l'expression 'Scio urbem magnam esse' ?",
                    "options": ["Je sais que la ville est grande", "La grande ville sait tout", "Je vois une grande ville", "La ville est devenue grande"],
                    "answer": 0,
                    "explanation": "C'est une proposition infinitive : scio = je sais (que), urbem magnam = la grande ville (accusatif), esse = être (infinitif), d'où \"la ville est grande\"."
                },
                {
                    "question": "Quel empereur a porté l'Empire romain à sa plus grande étendue territoriale ?",
                    "options": ["Trajan", "Néron", "Romulus", "Jules César"],
                    "answer": 0,
                    "explanation": "Sous l'empereur Trajan (98-117 ap. J.-C.), l'Empire s'étendait de la Bretagne à la Mésopotamie !"
                },
                {
                    "question": "Complète : « Le poète et le consul protègent la patrie ». Poeta et consul patriam ___.",
                    "options": ["servat", "servas", "servant", "servamus"],
                    "answer": 2,
                    "explanation": "Deux sujets (« le poète » et « le consul ») : le verbe se met au pluriel, en -nt. « Servat » ne convient qu'à un seul sujet."
                }
            ]
        }
    ]
}
