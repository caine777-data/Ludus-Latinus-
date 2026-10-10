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
            "options": ["Sa place dans la phrase", "Sa terminaison", "Sa première lettre", "La ponctuation"],
            "answer": 1,
            "explications": [
                "En latin, on peut déplacer les mots sans changer leur rôle : la place ne décide pas de la fonction.",
                "",
                "La première lettre d'un mot ne change pas quand sa fonction change : elle ne montre pas son rôle.",
                "La ponctuation sépare les phrases, mais elle ne dit pas si un mot est sujet ou complément.",
            ],
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

Exemple : *« Puella cantat. »* = « La jeune fille chante. » (*Puella* est le sujet.)

À toi ! Nouveaux mots : *ambulat* = se promène ; *in silva* = dans la forêt.
Reconstitue la traduction en français :""",
            "latin": "Puella in silva ambulat.",
            "mots": ["La jeune fille", "se promène", "dans la forêt.", "Le garçon", "chante", "la rose"],
            "solution": "La jeune fille se promène dans la forêt.",
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

Complète la terminaison pour que « la forêt » (*silva*) devienne le COD :""",
            "consigne": "Mets silva au COD :",
            "avant": "Puer silv",
            "apres": " videt (Le garçon voit la forêt).",
            "solution": "am",
            "latin_complet": "Puer silvam videt.",
        },
        {
            "id": "m4-04",
            "type": "decodeur",
            "title": "Le Décodeur de Cas en action !",
            "content": """## Utilise le Décodeur de Cas !

Voici une phrase modèle :
*« Lupus agnum videt. »* = « Le loup voit l'agneau. »

Les indices :
- 🔵 **Sujet (Nominatif)** : *Lupus*, terminaison **-us**.
- 🔴 **COD (Accusatif)** : *agnum*, il se termine par **-m** !
- 🟡 **Verbe (Action)** : *videt*, il se termine par **-t**.

À toi ! Voici une nouvelle phrase. Attention, l'ordre a changé : ne regarde pas la place des mots, regarde leur fin. Touche chaque mot pour lui donner son rôle.""",
            "mots": ["Puellam", "lupus", "videt"],
            "roles": {0: "cod", 1: "sujet", 2: "verbe"},
            "traduction": "Le loup voit la jeune fille.",
        },
        {
            "id": "m4-05",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Lion de Némée",
            "content": """## Le 1er Travail d'Hercule !

Le redoutable **Lion de Némée** rugit devant toi. Ses griffes d'acier et sa peau impénétrable font trembler les bergers.

Utilise ta maîtrise des cas latins pour terrasser la bête et remporter une bourse de **sesterces 🪙** et l'accès au monde suivant !""",
            "boss": {"nom": "Le Lion de Némée", "icone": "🦁", "pv": 3},
            "questions": [
                {
                    "question": "Dans « Rosam puella videt », quel mot est le sujet ?",
                    "options": ["Rosam", "Videt", "Puella", "Impossible à dire"],
                    "answer": 2,
                    "explanation": "« Puella » est au nominatif : c'est le sujet. « Rosam » porte un -m : c'est le COD. L'ordre ne décide pas."
                },
                {
                    "question": "Par quelle lettre se terminent très souvent les noms au COD (Accusatif singulier) ?",
                    "options": ["Par un -S", "Par un -M", "Par un -T", "Par un -R"],
                    "answer": 1,
                    "explanation": "Exactement ! Le -M est la marque magique de l'Accusatif singulier (rosam, agnum, puellam)."
                },
                {
                    "question": "Comment traduit-on : 'Puella rosam amat' ?",
                    "options": ["La rose voit la jeune fille", "La rose aime la jeune fille", "La jeune fille aime la rose", "La jeune fille voit la rose"],
                    "answer": 2,
                    "explanation": "« Puella » est le sujet, « rosam » (avec -m) est le COD, « amat » veut dire « aime »."
                }
            ]
        }
    ]
}
