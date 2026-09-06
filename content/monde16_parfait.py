"""
Monde 16 — Veni, Vidi, Vici : Le Parfait.
Le parfait de l'indicatif (valeur de passé simple et passé composé),
ses désinences universelles (-i, -isti, -it, -imus, -istis, -erunt),
le parfait du verbe être (fui, fuisti, fuit...)
et les célèbres mots de Jules César après la bataille de Zéla.
"""

LEVEL = {
    "id": "monde16",
    "classe": "4eme",
    "title": "16 · Veni, Vidi, Vici : Le Parfait ⚡",
    "lessons": [
        {
            "id": "m16-01",
            "type": "quiz",
            "title": "Le Parfait : L'Action Accomplie",
            "content": """## Le roi des temps historiques !
Tandis que l'imparfait décrit une action qui durait dans le passé, le **Parfait** exprime une action ponctuelle et achevée.

En français, il se traduit selon le contexte :
- Soit par un **Passé Simple** (*« il vainquit »*)
- Soit par un **Passé Composé** (*« il a vaincu »*)

🔥 **Les désinences magiques du parfait (les mêmes pour TOUS les verbes latins !)** :
- 1ère sg : **-I** *(amav-i = j'aimai / j'ai aimé)*
- 2ème sg : **-ISTI** *(amav-isti = tu aimas / tu as aimé)*
- 3ème sg : **-IT** *(amav-it = il aima / il a aimé)*
- 1ère pl : **-IMUS** *(amav-imus = nous aimâmes / nous avons aimé)*
- 2ème pl : **-ISTIS** *(amav-istis = vous aimâtes / vous avez aimé)*
- 3ème pl : **-ERUNT** *(amav-erunt = ils aimèrent / ils ont aimé)*""",
            "question": "Quelle est la désinence de la 3e personne du singulier au parfait (il/elle a fait) ?",
            "options": ["-IT (ex: amavit, vicit)", "-AT", "-ET", "-BA"],
            "answer": 0,
            "explanation": "La 3e personne du singulier du parfait se termine toujours par -IT !",
        },
        {
            "id": "m16-02",
            "type": "trou",
            "title": "Le Parfait du Verbe Être : Fui, Fuisti, Fuit",
            "content": """## J'ai été, tu as été, il fut...
Le parfait du verbe *esse* (être) utilise le radical régulier **FU-** :

- **FUI** : je fus / j'ai été
- **FUISTI** : tu fus / tu as été
- **FUIT** : il fut / il a été
- **FUIMUS** : nous fûmes / nous avons été
- **FUISTIS** : vous fûtes / vous avez été
- **FUERUNT** : ils furent / ils ont été

Exemple : *Cicero magnus orator fuit.* = « Cicéron fut un grand orateur. »

Complète pour dire : « César fut un général célèbre » (*Caesar clarus dux fuit*).""",
            "consigne": "Complète le verbe être au parfait (fuit) :",
            "avant": "Caesar clarus dux fu",
            "apres": ".",
            "solution": "it",
            "latin_complet": "Caesar clarus dux fuit.",
        },
        {
            "id": "m16-03",
            "type": "puzzle",
            "title": "Les Trois Mots de César",
            "content": """## Une dépêche éclair devenue immortelle
En 47 av. J.-C., après avoir écrasé l'armée du roi Pharnace en un clin d'œil à la bataille de Zéla, Jules César envoie ce rapport ultra-bref au Sénat romain :

*« VENI, VIDI, VICI »*
*(Veni = je suis venu, vidi = j'ai vu, vici = j'ai vaincu)*

Trois verbes au parfait, à la première personne singulier en **-I** !

Reconstitue cette citation triomphale :""",
            "latin": "Veni, vidi, vici.",
            "mots": ["Je suis venu,", "j'ai vu,", "j'ai vaincu.", "Rome", "a fêté", "le héros."],
            "solution": "Je suis venu, j'ai vu, j'ai vaincu.",
        },
        {
            "id": "m16-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Gladiateur Invaincu",
            "content": """## Le choc des titans dans l'arène de Capoue
Le champion des arènes met ta maîtrise du parfait à l'épreuve. Triomphe pour empocher **50 Sesterces 🪙** !""",
            "boss": {"nom": "Le Gladiateur Invaincu", "icone": "⚔️", "pv": 3},
            "questions": [
                {
                    "question": "Que signifie exactement 'Veni, vidi, vici' ?",
                    "options": [
                        "Je suis venu, j'ai vu, j'ai vaincu",
                        "Je viens, je vois, je triomphe",
                        "Partir, combattre, mourir",
                        "Vivre, voir et vaincre"
                    ],
                    "answer": 0,
                    "explanation": "Ce sont 3 verbes au parfait : venir, voir et vaincre !"
                },
                {
                    "question": "Comment se traduit 'Milites fortiter pugnaverunt' ?",
                    "options": [
                        "Les soldats ont combattu courageusement",
                        "Les soldats combattront demain",
                        "Les soldats ont peur du combat",
                        "Le général commande les soldats"
                    ],
                    "answer": 0,
                    "explanation": "Pugnav-erunt est la 3e personne du pluriel du parfait = ils ont combattu."
                },
                {
                    "question": "Quelle forme du verbe être correspond à 'nous avons été / nous fûmes' ?",
                    "options": ["Fuimus", "Fuerunt", "Sumus", "Eramus"],
                    "answer": 0,
                    "explanation": "Radical fu- + désinence -imus = fuimus."
                }
            ]
        }
    ]
}
