"""
Monde 5 — Au Cœur de l'Action (Les Verbes au Présent).
Le verbe ÊTRE (sum, es, est...), les verbes du 1er groupe (-are),
les verbes d'action des héros et le combat contre l'Hydre de Lerne.
"""

LEVEL = {
    "id": "monde5",
    "title": "5 · Les Verbes au Présent & L'Action ⚔️",
    "lessons": [
        {
            "id": "m5-01",
            "type": "puzzle",
            "title": "Le Verbe ÊTRE (Esse)",
            "content": """## Le verbe le plus important de l'Empire

Le verbe **ÊTRE** en latin s'appelle *ESSE*. Voici ses formes au présent :

- **SUM** = Je suis *(ex: Romanus sum = Je suis romain)*
- **ES** = Tu es
- **EST** = Il / Elle est *(ex: Roma magna est = Rome est grande)*
- **SUMUS** = Nous sommes
- **ESTIS** = Vous êtes
- **SUNT** = Ils / Elles sont *(ex: Discipuli sunt = Ils sont élèves)*

💡 **Astuce magique** :
En latin, pas besoin d'écrire 'je', 'tu', 'il' devant le verbe : la terminaison du verbe suffit ! *Sum* veut dire directement « je suis » !

À toi ! *Romani* = les Romains (pluriel de *Romanus*).
Reconstitue la traduction :""",
            "latin": "Romani sumus.",
            "mots": ["Nous sommes", "romains.", "Je suis", "Ils sont", "romain."],
            "solution": "Nous sommes romains.",
        },
        {
            "id": "m5-02",
            "type": "trou",
            "title": "Les Verbes d'Action (1er groupe en -ARE)",
            "content": """## Comment conjuguer au présent ?

Prenons le verbe d'amour et d'amitié : **AMARE** (aimer).

Observe les terminaisons de chaque personne :
- *Am-**O*** = j'aime
- *Am-**AS*** = tu aimes
- *Am-**AT*** = il / elle aime (toujours un **-t** !)
- *Am-**AMUS*** = nous aimons
- *Am-**ATIS*** = vous aimez
- *Am-**ANT*** = ils / elles aiment (toujours un **-nt** !)

Les autres verbes en **-ARE** suivent le même modèle. Avec *cantare* (chanter), complète pour dire : « Les enfants chantent dans le jardin ».""",
            "consigne": "Complète la terminaison de « ils chantent » :",
            "avant": "Pueri in horto cant",
            "apres": ".",
            "solution": "ant",
            "latin_complet": "Pueri in horto cantant.",
        },
        {
            "id": "m5-03",
            "type": "puzzle",
            "title": "Combattre et Vaincre : Les Verbes Héroïques",
            "content": """## Les verbes des grands généraux

Voici les verbes préférés de Jules César et des héros de Rome :
- **PUGNAT** = il combat *(a donné : pugnace, pugilat)*
- **VINCIT** = il vainc / il gagne *(a donné : vaincre, victoire)*
- **CURRIT** = il court *(a donné : courir, coursier)*
- **VIDET** = il voit *(a donné : vidéo, visible)*

Exemple : *« Miles fortiter pugnat. »* = « Le soldat combat courageusement. »

À toi ! Attention à la terminaison du verbe : **-t** pour un seul, **-nt** pour plusieurs.""",
            "latin": "Romani fortiter pugnant.",
            "mots": ["Les Romains", "combattent", "courageusement.", "Le Romain", "combat", "fuient"],
            "solution": "Les Romains combattent courageusement.",
        },
        {
            "id": "m5-04",
            "type": "decodeur",
            "title": "Le Décodeur de l'Attaque !",
            "content": """## Analyse la phrase du légionnaire

Voici une phrase modèle :
*« Miles gladium capit. »* = « Le soldat prend son glaive. »

Les rôles :
- *Miles* = le soldat (Qui prend ? ➔ 🔵 Sujet / Nominatif)
- *gladium* = le glaive (Qu'est-ce qui est pris ? Il y a le **-m** ! ➔ 🔴 COD / Accusatif)
- *capit* = prend (L'action, avec son **-t** ➔ 🟡 Verbe)

À toi ! Dans cette nouvelle phrase, l'ordre des mots a changé. Regarde bien chaque terminaison, même celle d'un mot en **-a**.""",
            "mots": ["Agricola", "amat", "equum"],
            "roles": {0: "sujet", 1: "verbe", 2: "cod"},
            "traduction": "Le paysan aime le cheval.",
        },
        {
            "id": "m5-05",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : L'Hydre de Lerne",
            "content": """## Le 2e Travail d'Hercule !

L'Hydre géante surgit des marais de Lerne ! À chaque tête tranchée, deux nouvelles repoussent...

Frappe avec la précision d'un centurion pour vaincre l'Hydre et empocher une bourse de **sesterces 🪙** !""",
            "boss": {"nom": "L'Hydre de Lerne", "icone": "🐉", "pv": 3},
            "questions": [
                {
                    "question": "Que signifie 'sumus' en français ?",
                    "options": ["Je suis", "Vous êtes", "Nous sommes", "Ils sont"],
                    "answer": 2,
                    "explanation": "Sumus = nous sommes !"
                },
                {
                    "question": "Quelle est la terminaison des verbes latins pour 'ils / elles' au pluriel ?",
                    "options": ["-t", "-nt", "-mus", "-s"],
                    "answer": 1,
                    "explanation": "C'est bien -NT (par exemple « amant » = ils aiment) !"
                },
                {
                    "question": "Que signifie le verbe 'vincit' ?",
                    "options": ["Il vit", "Il vainc", "Il vient", "Il voit"],
                    "answer": 1,
                    "explanation": "Vincit = il vainc (qui a donné victoire et vainqueur) !"
                }
            ]
        }
    ]
}
