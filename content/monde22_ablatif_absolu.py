"""
Monde 22 — Le Secret de l'Ablatif Absolu.
La structure reine de la prose latine classique : Nom à l'ablatif + Participe à l'ablatif.
Sa traduction fluide en français (temporelle, causale) et ses formules emblématiques.
"""

LEVEL = {
    "id": "monde22",
    "classe": "3eme",
    "title": "22 · Le Secret de l'Ablatif Absolu 📜",
    "lessons": [
        {
            "id": "m22-01",
            "type": "quiz",
            "title": "Qu'est-ce que l'Ablatif Absolu ?",
            "content": """## Le chef-d'œuvre de la grammaire latine !
En 3ème, l'**Ablatif Absolu** est la construction la plus célèbre et la plus fréquente chez César, Cicéron et Tite-Live.

Le mot *absolu* vient du latin *absolutus* qui veut dire **« détaché, libre »**.

C'est une petite proposition indépendante insérée dans la phrase, composée de :
1. Un **Nom ou pronom à l'Ablatif** (le sujet de l'action)
2. Un **Participe à l'Ablatif** (le verbe de l'action)

Exemple magique :
*« **Urbe capta**, milites redierunt. »*
- *Urbe* = la ville (à l'ablatif singulier)
- *Capta* = ayant été prise (PPP à l'ablatif singulier féminin)

En français, on traduit élégamment par :
➔ **« La ville ayant été prise... »**
➔ ou **« Une fois la ville prise... »**
➔ ou **« Après la prise de la ville... »**""",
            "question": "De quoi est composé un ablatif absolu classique ?",
            "options": [
                "D'un nom à l'ablatif et d'un participe à l'ablatif",
                "D'un verbe à l'infinitif et d'un adjectif au nominatif",
                "D'un nom au génitif avec une préposition",
                "D'un verbe au futur et d'un adverbe"
            ],
            "answer": 0,
            "explanation": "Nom à l'ablatif + participe à l'ablatif forme la proposition absolue !",
        },
        {
            "id": "m22-02",
            "type": "trou",
            "title": "Les Deux Mots qui Résument une Bataille",
            "content": """## Déchiffrer les formules célèbres
L'ablatif absolu permet aux auteurs romains d'exprimer des événements entiers en seulement deux mots !

- *Bello confecto* = La guerre étant achevée / Une fois la guerre finie
- *Sole oriente* = Le soleil se levant / Au lever du soleil
- *Pace facta* = La paix ayant été conclue

Complète l'ablatif absolu pour dire : « La paix ayant été conclue, les citoyens se réjouissent » (*Pace facta, cives gaudent*).""",
            "consigne": "Complète le participe à l'ablatif féminin 'faite/conclue' (facta) :",
            "avant": "Pace fact",
            "apres": ", cives gaudent.",
            "solution": "a",
            "latin_complet": "Pace facta, cives gaudent.",
        },
        {
            "id": "m22-03",
            "type": "puzzle",
            "title": "Sous la Conduite de César (Caesare duce)",
            "content": """## L'ablatif absolu sans participe !
Parfois, quand le verbe sous-entendu est le verbe « être » (qui n'a pas de participe présent en latin), l'ablatif absolu est formé de **deux noms à l'ablatif** :
- *Caesare duce* = « César étant le chef » ➔ **« Sous la conduite de César »**
- *Cicerone consule* = « Cicéron étant consul » ➔ **« Sous le consulat de Cicéron »**

Reconstitue cette phrase historique :
*« Caesare duce, Romani vicerunt. »*
*(Caesare duce = sous la conduite de César [Abl. Abs.], Romani = les Romains, vicerunt = ont vaincu)*""",
            "latin": "Caesare duce, Romani vicerunt.",
            "mots": ["Sous la conduite de César,", "les Romains", "ont vaincu.", "La légion", "défile."],
            "solution": "Sous la conduite de César, les Romains ont vaincu.",
        },
        {
            "id": "m22-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Rhéteur Quintilien",
            "content": """## L'épreuve du grand professeur de rhétorique
Quintilien, précepteur des princes impériaux, examine ta compréhension de l'ablatif absolu. Triomphe pour empocher **50 Sesterces 🪙** !""",
            "boss": {"nom": "Quintilien le Rhéteur", "icone": "📜", "pv": 3},
            "questions": [
                {
                    "question": "Comment se traduit fidèlement l'ablatif absolu 'Hostibus victis' ?",
                    "options": [
                        "Les ennemis ayant été vaincus (une fois les ennemis vaincus)",
                        "L'ennemi combat courageusement",
                        "Pour vaincre les ennemis",
                        "Avec des armes ennemies"
                    ],
                    "answer": 0,
                    "explanation": "Hostibus (Abl. pl.) + victis (PPP Abl. pl.) = une fois les ennemis vaincus."
                },
                {
                    "question": "Que signifie 'Cicerone consule' ?",
                    "options": [
                        "Sous le consulat de Cicéron (Cicéron étant consul)",
                        "Cicéron parle au consul",
                        "Le consul condamne Cicéron",
                        "Cicéron cherche un consul"
                    ],
                    "answer": 0,
                    "explanation": "C'est un ablatif absolu nominal : Cicéron étant consul."
                },
                {
                    "question": "Pourquoi dit-on que cette proposition est 'absolue' ?",
                    "options": [
                        "Parce qu'elle est grammaticalement détachée (absolutus) du reste de la phrase",
                        "Parce qu'elle donne un ordre absolu",
                        "Parce qu'elle ne contient que des noms divins",
                        "Parce qu'elle est toujours vraie"
                    ],
                    "answer": 0,
                    "explanation": "Absolutus signifie délié / détaché des liens grammaticaux de la phrase principale."
                }
            ]
        }
    ]
}
