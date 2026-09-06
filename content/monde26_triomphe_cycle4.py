"""
Monde 26 — Le Grand Triomphe du Cycle 4 (Brevet des Collèges & Maître de Rome).
L'épreuve finale et suprême de tout le collège (5ème, 4ème, 3ème).
Synthèse complète de la langue, de la mythologie et de l'histoire romaine.
Face à l'Empereur Trajan, débloque le Grand Triomphe du Collège et la Toge Prétexte d'Or !
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

Prépare-toi à gravir les marches sacrées du Forum pour le couronnement suprême !""",
            "question": "Quelle construction réunit un nom et un participe tous deux au cas ablatif sans mot de liaison ?",
            "options": [
                "L'Ablatif Absolu (ex: Caesare duce, urbe capta)",
                "La Proposition Infinitive",
                "Le Comparatif de supériorité",
                "Le Vocatif d'apostrophe"
            ],
            "answer": 0,
            "explanation": "C'est l'Ablatif Absolu, véritable marque de fabrique du latin classique !",
        },
        {
            "id": "m26-02",
            "type": "trou",
            "title": "L'Épreuve du Manuscrit Impérial",
            "content": """## Déchiffrer la devise éternelle
Pour sceller ton parcours de latiniste du collège, complète la phrase :
« Le peuple romain conserve la liberté et la paix »
*(Populus Romanus libertatem et pacem servat)*.

- *Populus Romanus* = le peuple romain (Nom. sg.)
- *Libertatem* = la liberté (Acc. sg. en -em)
- *Pacem* = la paix (Acc. sg. en -em)
- *Servat* = conserve / protège (3e personne singulier du présent)""",
            "consigne": "Complète le verbe 'conserve' (servat) :",
            "avant": "Populus Romanus libertatem et pacem ser",
            "apres": ".",
            "solution": "vat",
            "latin_complet": "Populus Romanus libertatem et pacem servat.",
        },
        {
            "id": "m26-03",
            "type": "puzzle",
            "title": "Le Serment du Citoyen Émérite",
            "content": """## La flamme de la connaissance
Reconstitue cette noble sentence qui traversera les siècles :

*« Litterae et sapientia mentem hominis ornant. »*
*(Litterae = les lettres et les livres, sapientia = la sagesse, mentem hominis = l'esprit de l'homme, ornant = embellissent)*""",
            "latin": "Litterae et sapientia mentem hominis ornant.",
            "mots": ["Les lettres et la sagesse", "embellissent", "l'esprit de l'homme.", "La gloire", "demeure", "éternelle."],
            "solution": "Les lettres et la sagesse embellissent l'esprit de l'homme.",
        },
        {
            "id": "m26-04",
            "type": "arene",
            "title": "👑 Défi Suprême : L'Empereur Trajan en Majesté",
            "content": """## Le Triomphe de Rome — Fin du Cycle 4
Sous la colonne Trajane, en présence du Sénat au grand complet, l'Empereur Trajan (*Optimus Princeps*) te décerne la **Toge Prétexte d'Or** et **200 Sesterces 🪙** !""",
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
                    "options": [
                        "Je sais que la ville est grande",
                        "La grande ville sait tout",
                        "Je vois une grande ville",
                        "La ville est devenue grande"
                    ],
                    "answer": 0,
                    "explanation": "C'est une proposition infinitive : Scio = je sais (que), urbem magnam = la grande ville (Acc.), esse = est (Infinitif)."
                },
                {
                    "question": "Quel empereur a porté l'Empire romain à sa plus grande étendue territoriale ?",
                    "options": ["Trajan", "Néron", "Romulus", "Jules César"],
                    "answer": 0,
                    "explanation": "Sous l'empereur Trajan (98-117 ap. J.-C.), l'Empire s'étendait de l'Écosse à la Mésopotamie !"
                },
                {
                    "question": "Que signifie la devise 'Ad astra per aspera' ?",
                    "options": [
                        "Vers les étoiles à travers les épreuves",
                        "Le ciel appartient aux aigles",
                        "La victoire pour les plus forts",
                        "Partir sans jamais revenir"
                    ],
                    "answer": 0,
                    "explanation": "Ad astra = vers les étoiles, per aspera = à travers les difficultés / épreuves !"
                }
            ]
        }
    ]
}
