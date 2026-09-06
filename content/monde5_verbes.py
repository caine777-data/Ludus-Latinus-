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

Reconstitue la phrase : *« Romanus sum. »*""",
            "latin": "Romanus sum.",
            "mots": ["Je suis", "romain.", "Tu es", "un soldat", "grec."],
            "solution": "Je suis romain.",
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

Complète le verbe à la 3e personne du singulier (*il aime*) pour la phrase :
*« Marcus Romam amat »* (Marcus aime Rome).""",
            "consigne": "Complète la terminaison 'il aime' (-at) :",
            "avant": "Marcus Romam am",
            "apres": ".",
            "solution": "at",
            "latin_complet": "Marcus Romam amat.",
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

Reconstitue cette phrase de victoire :
*« Miles fortiter pugnat. »*
*(Miles = le soldat, fortiter = courageusement, pugnat = combat)*""",
            "latin": "Miles fortiter pugnat.",
            "mots": ["Le soldat", "combat", "courageusement.", "Le général", "fuit", "la forêt."],
            "solution": "Le soldat combat courageusement.",
        },
        {
            "id": "m5-04",
            "type": "decodeur",
            "title": "Le Décodeur de l'Attaque !",
            "content": """## Analyse la phrase du légionnaire

Voici la manœuvre du soldat romain :
*« Miles gladium capit. »*
*(Le soldat prend son glaive)*

Repère les rôles :
- *Miles* = le soldat (Qui prend ? ➔ 🔵 Sujet / Nominatif)
- *gladium* = le glaive (Qu'est-ce qui est pris ? Il y a le **-m** ! ➔ 🔴 COD / Accusatif)
- *capit* = prend (L'action ➔ 🟢 Verbe)

Attribue les couleurs avec le Décodeur !""",
            "mots": ["Miles", "gladium", "capit"],
            "roles": {0: "sujet", 1: "cod", 2: "verbe"},
        },
        {
            "id": "m5-05",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : L'Hydre de Lerne",
            "content": """## Le 2e Travail d'Hercule !

L'Hydre géante surgit des marais de Lerne ! À chaque tête tranchée, deux nouvelles repoussent...

Frappe avec la précision d'un centurion pour vaincre l'Hydre et empocher **50 Sesterces 🪙** !""",
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
                    "explanation": "C'est bien -NT, exactement comme en français (ils aiment) !"
                },
                {
                    "question": "Que signifie le verbe 'vincit' ?",
                    "options": ["Il dort", "Il vainc / il triomphe", "Il mange", "Il court"],
                    "answer": 1,
                    "explanation": "Vincit = il vainc (qui a donné victoire et vainqueur) !"
                }
            ]
        }
    ]
}
