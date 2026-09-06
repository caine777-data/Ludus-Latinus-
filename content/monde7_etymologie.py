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
            "explanation": "Aqua signifie l'eau en latin !",
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

Complète le préfixe latin qui veut dire 'sous' (sub-) dans ce mot français :""",
            "consigne": "Complète le préfixe latin 'sous' (sub) :",
            "avant": "",
            "apres": "marin (un engin qui va sous la mer).",
            "solution": "sub",
            "latin_complet": "Submarin.",
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

Reconstitue cette citation légendaire en français :""",
            "latin": "Veni, vidi, vici.",
            "mots": ["Je suis venu,", "j'ai vu,", "j'ai vaincu.", "J'ai fui,", "j'ai couru,", "j'ai perdu."],
            "solution": "Je suis venu, j'ai vu, j'ai vaincu.",
        },
        {
            "id": "m7-04",
            "type": "arene",
            "title": "⚔️ Le Grand Défi du Sénat : L'Épreuve Suprême",
            "content": """## Devant l'Assemblée du Sénat de Rome !

Les sénateurs et consuls en toge blanche bordée d'or sont réunis pour évaluer ton parcours.

Réponds avec brio à leurs ultimes énigmes pour décrocher la toge de **Triumphator** et une pluie royale de **50 Sesterces 🪙** !""",
            "boss": {"nom": "Le Conseil des Sages du Sénat", "icone": "🏛️", "pv": 4},
            "questions": [
                {
                    "question": "Que signifie la célèbre maxime 'Carpe diem' ?",
                    "options": ["Mange des carpes tous les jours", "Cueille le jour présent (profite de l'instant)", "Dors bien cette nuit", "Attention au danger"],
                    "answer": 1,
                    "explanation": "Carpe diem = Cueille le jour présent / profite de la vie !"
                },
                {
                    "question": "Que veut dire l'expression 'Alea jacta est' prononcée au passage du Rubicon ?",
                    "options": ["La route est fermée", "Les dés sont jetés", "L'armée fait demi-tour", "La paix est signée"],
                    "answer": 1,
                    "explanation": "Alea jacta est = Les dés sont jetés (le sort en est jeté) !"
                },
                {
                    "question": "Quel mot latin signifiant 'main' a donné les mots français 'manuel' et 'manipuler' ?",
                    "options": ["Manus", "Pater", "Lupus", "Oculus"],
                    "answer": 0,
                    "explanation": "Manus est la main en latin !"
                },
                {
                    "question": "Que veut dire la formule 'Mens sana in corpore sano' ?",
                    "options": ["Un esprit sain dans un corps sain", "Un grand corps sans tête", "La santé avant tout", "Toujours s'entraîner"],
                    "answer": 0,
                    "explanation": "Mens sana in corpore sano = Un esprit sain dans un corps sain !"
                }
            ]
        }
    ]
}
