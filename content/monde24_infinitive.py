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
            "explications": [
                "",
                "Dans cette subordonnée, le sujet ne reste pas au cas sujet habituel de la principale.",
                "Le sujet n'est jamais à l'ablatif ici. L'ablatif sert plutôt aux compléments de moyen, de lieu ou de temps.",
                "Le cas du complément du nom ne peut jamais introduire le sujet d'une telle proposition.",
            ],
            "explanation": "C'est la règle d'or : Sujet à l'Accusatif + Verbe à l'Infinitif !",
            "grammaire": {
                "question": "Complète pour dire « Je sais que le soldat court » : Scio ___ currere.",
                "options": ["miles", "militi", "militem", "militis"],
                "answer": 2,
                "explications": [
                    "Cette forme est le nominatif, cas du sujet d'une phrase simple.",
                    "Cette forme est un datif : celui qui reçoit. Personne ne reçoit rien ici.",
                    "",
                    "Cette forme est un génitif : « du soldat ». Elle complèterait un nom.",
                ],
            },
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

Dans la proposition infinitive, le sujet se met à l'**accusatif** et le verbe à l'**infinitif** :
*Scio consulem venire.* = « Je sais que le consul arrive. » (*consul* ➔ *consulem*)

À toi ! *Amicus, -i* = l'ami.
Complète pour dire : « Je pense que l'ami arrive ».""",
            "consigne": "Mets le sujet de l'infinitive au bon cas :",
            "avant": "Puto amic",
            "apres": " venire.",
            "solution": "um",
            "latin_complet": "Puto amicum venire.",
            "grammaire": {
                "question": "Complète pour dire « Je dis que les marins courent » : Dico ___ currere. (nauta = le marin)",
                "options": ["nautae", "nautas", "nautam", "nauta"],
                "answer": 1,
                "explications": [
                    "Cette forme est le sujet d'une phrase simple, pas le sujet d'une proposition infinitive.",
                    "",
                    "Cette forme est au singulier. La phrase parle de plusieurs marins.",
                    "Cette forme est le nominatif singulier : un seul marin, sujet d'une phrase simple.",
                ],
            },
        },
        {
            "id": "m24-03",
            "type": "puzzle",
            "title": "Une Rumeur au Palais Impérial",
            "content": """## Ce que disent les citoyens
Les courriers rapportent à Rome les nouvelles des provinces.

Exemple : *« Dicit consulem Romam venire. »* = « Il dit que le consul vient à Rome. »

À toi ! L'infinitif présent indique une action qui se passe au même moment.
*Nuntius, -i* = le messager ; *hostis, -is* = l'ennemi.""",
            "latin": "Nuntius dicit hostes venire.",
            "mots": ["Le messager dit", "que les ennemis", "arrivent.", "que l'ennemi", "sont arrivés."],
            "solution": "Le messager dit que les ennemis arrivent.",
            "grammaire": {
                "question": "Que veut dire « Puto reginam ambulare. » ? (regina = la reine ; ambulare = se promener)",
                "options": [
                    "Je pense que la reine se promène.",
                    "Je pense que la reine se promenait.",
                    "Je pense que les reines se promènent.",
                    "La reine pense que je me promène.",
                ],
                "answer": 0,
                "explications": [
                    "",
                    "L'infinitif présent ne marque pas une action passée par rapport à puto.",
                    "Reginam est au singulier : la fin -am désigne une seule reine.",
                    "Puto veut dire « je pense » : celui qui pense, c'est « je », pas la reine.",
                ],
            },
        },
        {
            "id": "m24-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Greffier Impérial",
            "content": """## Dans les archives secrètes du Palatin
Le greffier de l'Empereur retranscrit les dépêches officielles. Montre ta maîtrise des propositions infinitives pour remporter une bourse de **sesterces 🪙** !""",
            "boss": {"nom": "Le Greffier Impérial", "icone": "🖋️", "pv": 3},
            "questions": [
                {
                    "question": "Comment se traduit « Scio Marcum bonum discipulum esse » ?",
                    "options": ["Je sais que Marcus était un bon élève", "Marcus sait que je suis un bon élève", "Je sais que Marcus est un bon élève", "Je sais que Marcus sera un bon élève"],
                    "answer": 2,
                    "explanation": "« Scio » = je sais (que). « Marcum » est à l'accusatif : c'est le sujet de l'infinitive. « Esse » est l'infinitif présent (« être »), qui indique la même époque que « scio » : « est »."
                },
                {
                    "question": "Quel mot latin traduit le « que » d'une proposition infinitive ?",
                    "options": ["Quod, placé avant le sujet", "Ut, placé avant le verbe", "Aucun, la structure suffit", "Quem, placé avant le verbe"],
                    "answer": 2,
                    "explanation": "Le latin n'emploie aucun mot de liaison : sujet à l'accusatif + verbe à l'infinitif suffisent."
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
