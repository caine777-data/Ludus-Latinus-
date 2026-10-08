"""
Monde 21 — Sous la Cendre du Vésuve.
Le Participe Parfait Passif (PPP : amatus, captus, scriptus),
sa formation à partir du supin et sa déclinaison en adjectif 1ère classe.
La catastrophe de Pompéi (79 ap. J.-C.) et les lettres de Pline le Jeune.
"""

LEVEL = {
    "id": "monde21",
    "classe": "3eme",
    "title": "21 · Sous la Cendre du Vésuve 🌋",
    "lessons": [
        {
            "id": "m21-01",
            "type": "quiz",
            "title": "Le Participe Parfait Passif (PPP)",
            "content": """## Le 4ème temps primitif du verbe
Tu te souviens des 4 formes énoncées dans le dictionnaire pour chaque verbe ?
*Amo, amas, amare, amavi, **amatum***.

Cette 4ème forme, le **supin** (*amatum*), donne naissance au **Participe Parfait Passif (PPP)** :
- *Amatum* ➔ **amatus, amata, amatum** (« ayant été aimé » / « aimé »)
- *Captum* ➔ **captus, capta, captum** (« ayant été pris » / « capturé »)
- *Scriptum* ➔ **scriptus, scripta, scriptum** (« ayant été écrit » / « écrit »)
- *Victum* ➔ **victus, victa, victum** (« ayant été vaincu » / « vaincu »)

💡 **Comment se décline le PPP ?**
Exactement comme un adjectif ordinaire de 1ère classe en *-us, -a, -um* (comme *bonus, bona, bonum*) ! Il s'accorde en genre, en nombre et en cas avec le nom qu'il qualifie.""",
            "question": "Que signifie le participe parfait passif 'urbs capta' (urbs = la ville) ?",
            "options": ["La ville capturée / prise", "La ville qui capture", "Capturer la ville", "La ville libre"],
            "answer": 0,
            "explications": [
                "",
                "Le sens serait actif, or ce participe passif exprime que la cité subit l'assaut.",
                "Cette tournure utilise un infinitif, alors que ce participe s'accorde comme un adjectif avec la cité.",
                "« Libre » se dit liber en latin ; rien dans capta n'évoque la liberté.",
            ],
            "explanation": "Capta est le PPP féminin s'accordant avec urbs : la ville ayant été prise / capturée.",
        },
        {
            "id": "m21-02",
            "type": "trou",
            "title": "Accorder le PPP : Urbs Deleto ou Deleta ?",
            "content": """## L'accord parfait
Comme le mot *urbs* (la ville) est féminin :
- *Urbs deleta* = la ville détruite (au féminin en **-a**).
- *Oppidum deletum* = la place forte détruite (au neutre en **-um**).
- *Vicus deletus* = le village détruit (au masculin en **-us**).

Applique la même règle à un autre participe : *captus, -a, -um* (pris), du verbe *capere* (prendre).
*Oppidum* (la place forte) est neutre.
Complète pour dire : « La place forte a été prise ».""",
            "consigne": "Accorde le participe avec oppidum (neutre) :",
            "avant": "Oppidum capt",
            "apres": " est.",
            "solution": "um",
            "latin_complet": "Oppidum captum est.",
        },
        {
            "id": "m21-03",
            "type": "puzzle",
            "title": "La Lettre de Pline le Jeune (79 ap. J.-C.)",
            "content": """## Le témoignage du 24 août 79
Le jeune Pline le Jeune observe depuis la baie de Naples une colonne de fumée colossale s'élevant du mont Vésuve, ayant la forme d'un pin parasol géant.

Exemple, adapté de sa célèbre lettre à l'historien Tacite : *« Mons Vesuvius nubem atram erigebat. »* = « Le mont Vésuve dressait un nuage noir. »

À toi ! Même adjectif, même temps (l'imparfait en *-bat*), autre phrase.
*Cinis, -eris* (m.) = la cendre ; *tego, -is, -ere* = recouvrir ; *urbs, urbis* (f.) = la ville.""",
            "latin": "Cinis ater urbem tegebat.",
            "mots": ["La cendre noire", "recouvrait", "la ville.", "recouvre", "les villes."],
            "solution": "La cendre noire recouvrait la ville.",
        },
        {
            "id": "m21-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Témoin de Pompéi",
            "content": """## Parmi les ruines figées par le temps
Un centurion de garde à Pompéi te soumet l'épreuve de la cendre volcanique. Réponds juste pour remporter une bourse de **sesterces 🪙** !""",
            "boss": {"nom": "Le Témoin de Pompéi", "icone": "🏛️", "pv": 3},
            "questions": [
                {
                    "question": "En quelle année l'éruption du Vésuve a-t-elle enseveli Pompéi et Herculanum ?",
                    "options": ["En 79 après J.-C.", "En 44 avant J.-C.", "En 52 avant J.-C.", "En 14 après J.-C."],
                    "answer": 0,
                    "explanation": "L'éruption eut lieu sous le règne de l'empereur Titus, en 79 ap. J.-C."
                },
                {
                    "question": "Sur quelle forme verbale le Participe Parfait Passif (PPP) est-il bâti ?",
                    "options": ["Le supin", "Le parfait", "Le présent", "L'infinitif"],
                    "answer": 0,
                    "explanation": "Le supin (en -um) fournit le radical du PPP (ex: scriptum -> scriptus, a, um)."
                },
                {
                    "question": "Comment se traduit 'Epistula a Plinio scripta' ?",
                    "options": [
                        "La lettre écrite par Pline",
                        "Pline écrit une lettre",
                        "La lettre que Pline lira",
                        "Pline reçoit une lettre"
                    ],
                    "answer": 0,
                    "explanation": "Scripta est le PPP féminin qualifiant epistula : la lettre écrite."
                }
            ]
        }
    ]
}
