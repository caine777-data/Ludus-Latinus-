"""
Monde 4 — Les 12 Travaux d'Hercule & l'Enquête des Cas.
Le grand secret des déclinaisons latines : le Sujet (Nominatif)
et le Complément d'Objet (Accusatif), avec le Décodeur de Cas.
"""

LEVEL = {
    "id": "monde4",
    "title": "4 · Les Cas & Travaux d'Hercule 🦁",
    "lessons": [
        {
            "id": "m4-01",
            "type": "quiz",
            "title": "Le Grand Mystère : Pourquoi le Latin change la fin des mots ?",
            "content": """## L'Ordre des Mots n'est pas ce que tu crois !

En français, l'ordre des mots décide de tout :
- *« Le loup mange l'agneau »* ➔ c'est le loup qui est le mangeur (Sujet).
- Si on inverse : *« L'agneau mange le loup »* ➔ la phrase devient complètement absurde !

Mais en LATIN, **l'ordre des mots est totalement libre** ! On peut écrire les mots dans n'importe quel ordre sans changer le sens de l'histoire !

## Comment les Romains savaient-ils qui fait quoi ? 💡
Grâce aux **terminaisons** (la fin du mot, qu'on appelle les **cas**) :
- Le mot qui fait l'action porte l'étiquette du **Sujet** (le **NOMINATIF**).
- Le mot qui subit l'action porte l'étiquette du **COD** (l'**ACCUSATIF**).

*Lupus agnum videt* = *Agnum lupus videt* = « Le loup voit l'agneau » !""",
            "question": "En latin, qu'est-ce qui indique le rôle d'un mot dans la phrase ?",
            "options": ["Sa position au tout début de la phrase", "Sa terminaison (son cas)", "Sa longueur en lettres", "La ponctuation"],
            "answer": 1,
            "explanation": "C'est la terminaison (le cas) qui indique si un mot est Sujet ou COD !",
        },
        {
            "id": "m4-02",
            "type": "puzzle",
            "title": "Le Sujet : Le Nominatif (Qui fait l'action ?)",
            "content": """## Le Maître de la phrase : Le Nominatif

Le **NOMINATIF** est le cas du **Sujet**. C'est le mot qui réalise l'action ou qui 'est' quelque chose.

Exemples avec des noms féminins en **-a** :
- **PUELLA** : la jeune fille (Sujet)
- **ROSA** : la rose (Sujet)
- **SILVA** : la forêt (Sujet)

Regarde cette phrase :
*« Puella cantat. »*
*(Puella = la jeune fille, cantat = chante)*

Reconstitue la traduction en français :""",
            "latin": "Puella cantat.",
            "mots": ["La jeune fille", "chante.", "Le garçon", "dort", "fleurit."],
            "solution": "La jeune fille chante.",
        },
        {
            "id": "m4-03",
            "type": "trou",
            "title": "Le Cible de l'Action : L'Accusatif (Le COD)",
            "content": """## Quand le mot devient COD, il attrape un -M !

Quand un nom en **-a** devient la cible de l'action (le Complément d'Objet Direct / COD), les Romains lui ajoutaient un **-M** à la fin :
- *Rosa* (Sujet) ➔ devient **ROSAM** (COD) !
- *Puella* (Sujet) ➔ devient **PUELLAM** (COD) !

Exemple magique :
*« Puer rosam videt. »*
- *Puer* = l'enfant (Sujet)
- *rosam* = la rose (COD, parce qu'il y a le **-m** !)
- *videt* = voit (Verbe)

Complète la terminaison pour mettre 'la fille' (puella) au COD (accusatif) :""",
            "consigne": "Mets la terminaison du COD (-am) :",
            "avant": "Puer puell",
            "apres": " amat (Le garçon aime la jeune fille).",
            "solution": "am",
            "latin_complet": "Puer puellam amat.",
        },
        {
            "id": "m4-04",
            "type": "decodeur",
            "title": "Le Décodeur de Cas en action !",
            "content": """## Utilise le Décodeur de Cas !

Voici une phrase romaine complète :
*« Lupus agnum videt. »*

Rappelle-toi les indices :
- 🔵 **Sujet (Nominatif)** : C'est *Lupus* (le loup qui regarde).
- 🔴 **COD (Accusatif)** : C'est *agnum* (l'agneau qui subit le regard, il se termine par **-m** !).
- 🟢 **Verbe (Action)** : C'est *videt* (l'action de voir, se termine par **-t**).

Clique sur chaque mot ci-dessous pour lui attribuer sa couleur et son rôle exact !""",
            "mots": ["Lupus", "agnum", "videt"],
            "roles": {0: "sujet", 1: "cod", 2: "verbe"},
        },
        {
            "id": "m4-05",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Lion de Némée",
            "content": """## Le 1er Travail d'Hercule !

Le redoutable **Lion de Némée** rugit devant toi. Ses griffes d'acier et sa peau impénétrable font trembler les bergers.

Utilise ta maîtrise des cas latins pour terrasser la bête et remporter **50 Sesterces 🪙** ainsi que sa peau légendaire !""",
            "boss": {"nom": "Le Lion de Némée", "icone": "🦁", "pv": 3},
            "questions": [
                {
                    "question": "Dans 'Lupus agnum videt', qui est le mangeur/regardeur (le Sujet) ?",
                    "options": ["Agnum", "Lupus", "Videt", "Aucun des deux"],
                    "answer": 1,
                    "explanation": "C'est Lupus qui est au Nominatif (Sujet) !"
                },
                {
                    "question": "Par quelle lettre se terminent très souvent les noms au COD (Accusatif singulier) ?",
                    "options": ["Par un -S", "Par un -M", "Par un -T", "Par un -R"],
                    "answer": 1,
                    "explanation": "Exactement ! Le -M est la marque magique de l'Accusatif singulier (rosam, agnum, puellam)."
                },
                {
                    "question": "Comment traduit-on : 'Puella rosam amat' ?",
                    "options": ["La rose aime la fille", "La jeune fille aime la rose", "La fille cueille une rose", "La rose est rouge"],
                    "answer": 1,
                    "explanation": "Puella (Sujet) aime rosam (COD) = La jeune fille aime la rose !"
                }
            ]
        }
    ]
}
