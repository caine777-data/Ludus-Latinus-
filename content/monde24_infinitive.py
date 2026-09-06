"""
Monde 24 — Paroles Rapportées : La Proposition Infinitive.
La structure fondamentale du discours indirect en latin : Sujet à l'accusatif + Verbe à l'infinitif.
Pas de mot « que » en latin ! Les verbes de déclaration et d'opinion (dico, scio, puto, audio).
"""

LEVEL = {
    "id": "monde24",
    "classe": "3eme",
    "title": "24 · La Proposition Infinitive 🗣️",
    "lessons": [
        {
            "id": "m24-01",
            "type": "quiz",
            "title": "Le Mystère du « QUE » Disparu !",
            "content": """## Comment rapporter des paroles en latin ?
En français, quand on rapporte une parole ou une pensée, on utilise toujours la conjonction « QUE » :
*« Je sais **que** Marcus est courageux. »*

En latin classique, il n'y a **aucun mot pour dire « que »** dans ce cas !

À la place, les Romains utilisent une formule géniale et compacte appelée la **Proposition Infinitive** :
1. Le **Sujet** se met à l'**ACCUSATIF** !
2. Le **Verbe** se met à l'**INFINITIF** !

Regarde la transformation :
- Phrase de base : *Marcus fortis est.* (« Marcus est courageux »).
- Avec « Je sais que... » : *Scio **Marcum fortem esse**.*
  - *Marcum* = accusatif
  - *esse* = infinitif (« être »)
  - Traduction française : « Je sais **que** Marcus est courageux ».""",
            "question": "Comment se construisent le sujet et le verbe d'une proposition infinitive en latin ?",
            "options": [
                "Sujet à l'Accusatif + Verbe à l'Infinitif",
                "Sujet au Nominatif + Verbe au Passif",
                "Sujet à l'Ablatif + Verbe au Présent",
                "Sujet au Génitif + Verbe au Futur"
            ],
            "answer": 0,
            "explanation": "C'est la règle d'or : Sujet à l'Accusatif + Verbe à l'Infinitif !",
        },
        {
            "id": "m24-02",
            "type": "trou",
            "title": "Les Verbes Déclaratifs : Dico, Scio, Audio",
            "content": """## Qui déclenche une proposition infinitive ?
Tous les verbes de pensée, de parole ou de sensation :
- **Dico** : je dis (que...)
- **Scio** : je sais (que...)
- **Puto** : je pense / j'estime (que...)
- **Audio** : j'entends (dire que...)
- **Video** : je vois (que...)

Complète la phrase pour dire : « J'entends dire que l'ami arrive » (*Audio amicum venire*).""",
            "consigne": "Complète le verbe à l'infinitif 'arriver' (venire) :",
            "avant": "Audio amicum ven",
            "apres": ".",
            "solution": "ire",
            "latin_complet": "Audio amicum venire.",
        },
        {
            "id": "m24-03",
            "type": "puzzle",
            "title": "Une Rumeur au Palais Impérial",
            "content": """## Ce que disent les citoyens
Les courriers rapportent à Rome les nouvelles des provinces.

Reconstitue cette phrase contenant une proposition infinitive :
*« Dicit consulem Romam venire. »*
*(Dicit = il dit [que], consulem = le consul [Sujet à l'Acc.], Romam = à Rome, venire = venir [Infinitif])*""",
            "latin": "Dicit consulem Romam venire.",
            "mots": ["Il dit", "que le consul", "vient", "à Rome.", "La garde", "attend."],
            "solution": "Il dit que le consul vient à Rome.",
        },
        {
            "id": "m24-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Greffier Impérial",
            "content": """## Dans les archives secrètes du Palatin
Le greffier de l'Empereur retranscrit les dépêches officielles. Montre ta maîtrise des propositions infinitives pour remporter **50 Sesterces 🪙** !""",
            "boss": {"nom": "Le Greffier Impérial", "icone": "🖋️", "pv": 3},
            "questions": [
                {
                    "question": "Comment se traduit 'Scio te bonum discipulum esse' ?",
                    "options": [
                        "Je sais que tu es un bon élève",
                        "Tu sais que je suis un bon élève",
                        "Le maître punit le bon élève",
                        "Soyez de bons élèves !"
                    ],
                    "answer": 0,
                    "explanation": "Scio = je sais (que), te = tu (Acc.), esse = es (Infinitif), bonum discipulum = un bon élève."
                },
                {
                    "question": "Y a-t-il un mot équivalent à notre 'que' dans une proposition infinitive latine ?",
                    "options": [
                        "Non, la structure Accusatif + Infinitif exprime directement le lien",
                        "Oui, le mot 'quod' est obligatoire",
                        "Oui, le mot 'cum'",
                        "Oui, le mot 'ut'"
                    ],
                    "answer": 0,
                    "explanation": "Le latin classique n'utilise aucun mot de liaison : la structure Accusatif + Infinitif suffit !"
                },
                {
                    "question": "Quel cas porte le sujet dans une proposition infinitive ?",
                    "options": ["L'Accusatif", "Le Nominatif", "L'Ablatif", "Le Datif"],
                    "answer": 0,
                    "explanation": "Le sujet d'une infinitive est systématiquement au cas Accusatif."
                }
            ]
        }
    ]
}
