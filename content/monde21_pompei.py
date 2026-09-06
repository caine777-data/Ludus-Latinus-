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

Complète pour dire : « Pompéi est une ville détruite par la cendre » (*Pompeii urbs deleta est*).""",
            "consigne": "Complète le PPP au féminin 'détruite' (deleta) :",
            "avant": "Pompeii urbs delet",
            "apres": " est.",
            "solution": "a",
            "latin_complet": "Pompeii urbs deleta est.",
        },
        {
            "id": "m21-03",
            "type": "puzzle",
            "title": "La Lettre de Pline le Jeune (79 ap. J.-C.)",
            "content": """## Le témoignage du 24 août 79
Le jeune Pline le Jeune observe depuis la baie de Naples une colonne de fumée colossale s'élevant du mont Vésuve, ayant la forme d'un pin parasol géant.

Reconstitue cette phrase adaptée de sa célèbre lettre à l'historien Tacite :
*« Mons Vesuvius nubes atra erigebat. »*
*(Mons Vesuvius = le mont Vésuve, nubes atra = un nuage noir, erigebat = dressait / projetait)*""",
            "latin": "Mons Vesuvius nubes atra erigebat.",
            "mots": ["Le mont Vésuve", "dressait", "un nuage noir.", "La cendre", "tombait", "sur la cité."],
            "solution": "Le mont Vésuve dressait un nuage noir.",
        },
        {
            "id": "m21-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Témoin de Pompéi",
            "content": """## Parmi les ruines figées par le temps
Un centurion de garde à Pompéi te soumet l'épreuve de la cendre volcanique. Réponds juste pour remporter **50 Sesterces 🪙** !""",
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
                    "options": ["Le supin (4e temps primitif, ex: amatum)", "L'infinitif présent", "Le parfait", "Le présent"],
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
