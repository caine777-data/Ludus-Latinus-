"""
Monde 7 — Détective des Mots (Étymologie & Citations Célèbres).
Comment le latin a façonné la langue française, les préfixes magiques
et les plus grandes devises de l'Histoire humaine.
"""

LEVEL = {
    "id": "monde7",
    "title": "7 · Détective des Mots & Devises 📜",
    "lessons": [
        {
            "id": "m7-01",
            "type": "quiz",
            "title": "Les Trésors Cachés : D'où viennent nos mots ?",
            "content": """## Le super-pouvoir du Latin en Français

Savais-tu que plus de **80 % des mots du dictionnaire français** proviennent directement du latin ?

Quand tu connais un seul mot latin, tu comprends instantanément toute une famille de mots français compliqués !

Exemples extraordinaires :
- **AQUA** (l'eau) ➔ *aquarium*, *aquatique*, *aquarelle*, *aqueduc*.
- **TERRA** (la terre) ➔ *territoire*, *terrestre*, *terrier*, *atterrir*, *souterrain*.
- **MANUS** (la main) ➔ *manuel*, *manipuler*, *manufacture*, *manucure*.
- **PES, PEDIS** (le pied) ➔ *piéton*, *pédale*, *bipède*, *expédition* (littéralement : se sortir les pieds d'un piège !).""",
            "question": "Quel mot latin a donné en français 'aquarium' et 'aquatique' ?",
            "options": ["Aqua (l'eau)", "Avis (l'oiseau)", "Ager (le champ)", "Arbor (l'arbre)"],
            "answer": 0,
            "explications": [
                "",
                "Ce mot a donné en français aviation et avicole, qui se rapportent aux oiseaux et au vol.",
                "Ce mot a donné en français agriculture et agraire, désignant la terre cultivée et les campagnes.",
                "Ce mot a donné en français arbre et arboriculture, liés aux végétaux et aux forêts.",
            ],
            "explanation": "Aqua signifie l'eau en latin !",
            "grammaire": {
                "question": "Quel mot latin se cache dans « oculiste », le médecin des yeux ?",
                "options": ["Oculus (l'œil)", "Caput (la tête)", "Pes (le pied)", "Manus (la main)"],
                "answer": 0,
                "explications": [
                    "",
                    "Ce mot a donné « capitaine » et « capital », qui parlent de la tête ou du chef.",
                    "Ce mot a donné « pédale » et « piéton », qui parlent du pied.",
                    "Ce mot a donné « manuel » et « manucure », qui parlent de la main.",
                ],
            },
        },
        {
            "id": "m7-02",
            "type": "trou",
            "title": "Les Préfixes Magiques (Sub, Trans, Post...)",
            "content": """## Les petits blocs qui construisent les mots

Les Romains adoraient accrocher de petits préfixes devant les mots pour en changer le sens. Nous faisons exactement la même chose en français aujourd'hui :

- **SUB-** = « sous » ➔ *submerger* (mettre sous l'eau), *subaquatique*.
- **TRANS-** = « à travers, au-delà » ➔ *transporter*, *transatlantique* (qui traverse l'Atlantique).
- **POST-** = « après » ➔ *post-scriptum* (écrit après la lettre), *posthume*.
- **CIRCUM-** = « autour » ➔ *circonférence*, *circumnavigation*.

Complète le préfixe latin qui veut dire « sous » dans ce mot français :""",
            "consigne": "Quel préfixe veut dire « sous » ?",
            "avant": "",
            "apres": "marin (un engin qui va sous la mer).",
            "solution": "sub",
            "latin_complet": "Submarin.",
            "grammaire": {
                "question": "Dans « postface » (le texte qui vient en dernier dans un livre), que veut dire post- ?",
                "options": ["Autour", "Sous", "Après", "À travers"],
                "answer": 2,
                "explications": [
                    "C'est le sens de circum-, comme dans circonférence.",
                    "C'est le sens de sub-, comme dans submerger.",
                    "",
                    "C'est le sens de trans-, comme dans transporter.",
                ],
            },
        },
        {
            "id": "m7-03",
            "type": "puzzle",
            "title": "Les Devises Immortelles : Veni, Vidi, Vici",
            "content": """## Le message le plus court et célèbre de l'Histoire

En 47 avant J.-C., après avoir remporté une bataille éclair en seulement quatre heures, **Jules César** envoya une lettre de trois mots seulement au Sénat de Rome :

*« VENI, VIDI, VICI ! »*
*(Prononcé à l'époque : « Ouéni, ouidi, ouiki ! »)*

Trois verbes magiques au passé :
- *Veni* = Je suis venu
- *Vidi* = J'ai vu
- *Vici* = J'ai vaincu

Trois autres devises à retenir :
- *Carpe diem* = « Cueille le jour présent » (profite du jour)
- *Alea iacta est* = « Le sort en est jeté » (on dit aussi « les dés sont jetés »), mot de César au Rubicon
- *Mens sana in corpore sano* = « Un esprit sain dans un corps sain »

Reconstitue cette citation légendaire en français :""",
            "latin": "Veni, vidi, vici.",
            "mots": ["Je suis venu,", "j'ai vu,", "j'ai vaincu.", "J'ai fui,", "j'ai couru,", "j'ai perdu."],
            "solution": "Je suis venu, j'ai vu, j'ai vaincu.",
            "grammaire": {
                "question": "Sur le modèle de « veni » (je suis venu), que veut dire « misi » ? (mittere = envoyer)",
                "options": ["J'envoie.", "Il envoie.", "Il a envoyé.", "J'ai envoyé."],
                "answer": 3,
                "explications": [
                    "« J'envoie » se dit mitto, avec la fin -o du présent.",
                    "« Il envoie » se dit mittit, avec un -t.",
                    "Ce passé parle d'une autre personne que celui qui parle.",
                    "",
                ],
            },
        },
        {
            "id": "m7-04",
            "type": "arene",
            "title": "⚔️ Le Grand Défi du Sénat : L'Épreuve Suprême",
            "content": """## Devant l'Assemblée du Sénat de Rome !

Les sénateurs et consuls en toge blanche bordée d'or sont réunis pour évaluer ton parcours.

Réponds avec brio à leurs ultimes énigmes pour ouvrir la suite de ton voyage et gagner une bourse de **sesterces 🪙** !""",
            "boss": {"nom": "Le Conseil des Sages du Sénat", "icone": "🏛️", "pv": 4},
            "questions": [
                {
                    "question": "Que signifie la célèbre maxime 'Carpe diem' ?",
                    "options": ["Pense toujours à demain", "Cueille le jour présent", "Bannis la peine présente", "Retiens le temps qui fuit"],
                    "answer": 1,
                    "explanation": "Carpe diem = Cueille le jour présent / profite de la vie !"
                },
                {
                    "question": "Que veut dire l'expression 'Alea iacta est' prononcée au passage du Rubicon ?",
                    "options": ["La route est fermée", "Les dés sont jetés", "L'armée fait demi-tour", "La paix est signée"],
                    "answer": 1,
                    "explanation": "Alea iacta est = Les dés sont jetés (le sort en est jeté) !"
                },
                {
                    "question": "Quelle forme veut dire « il vainc » (au présent) ?",
                    "options": ["Vici", "Vidi", "Vincit", "Videt"],
                    "answer": 2,
                    "explanation": "« Vincit » finit par -t : c'est « il vainc ». « Vici » est au passé : « j'ai vaincu ». « Vidi » = j'ai vu, « videt » = il voit."
                },
                {
                    "question": "Que veut dire la formule 'Mens sana in corpore sano' ?",
                    "options": ["Un esprit sain dans un corps sain", "Un corps robuste pour un esprit pur", "La force du corps guide la pensée", "Une vie paisible sans aucun souci"],
                    "answer": 0,
                    "explanation": "Mens sana in corpore sano = Un esprit sain dans un corps sain !"
                }
            ]
        }
    ]
}
