"""
Monde 19 — La Paix d'Auguste (Pax Romana).
Les 4ème et 5ème déclinaisons (manus, exercitus, res, dies)
et l'avènement de l'Empire sous Octave Auguste (27 av. J.-C.).
"""

LEVEL = {
    "id": "monde19",
    "classe": "3eme",
    "title": "19 · La Paix d'Auguste (Pax Romana) 🏛️",
    "lessons": [
        {
            "id": "m19-01",
            "type": "quiz",
            "title": "La 4ème Déclinaison : Manus & Exercitus",
            "content": """## Bienvenue en 3ème : L'Ère Impériale !
En 3ème, tu découvres les deux dernières déclinaisons latines, très élégantes et compactes.

La **4ème déclinaison** regroupe des noms dont le génitif singulier se termine par **-US** (avec un son U long) :
- **Manus, manus** (f.) : la main, ou la troupe armée (*➔ manuel, manufacture*)
- **Exercitus, exercitus** (m.) : l'armée (*➔ exercice*)
- **Domus, domus** (f.) : la maison
- **Cornu, cornus** (n.) : la corne, l'aile d'une armée (*➔ cornemuse*)

💡 **Règle de reconnaissance** :
Au dictionnaire : *manus, -us* f. ou *exercitus, -us* m.
Le nominatif et le génitif singulier se terminent tous deux en **-us** !""",
            "question": "Quelle est la désinence du génitif singulier de la 4ème déclinaison (ex: manus, exercitus) ?",
            "options": ["-us", "-is", "-ae", "-ei"],
            "answer": 0,
            "explications": [
                "",
                "Cette désinence de possession au singulier caractérise les noms de la troisième déclinaison.",
                "Cette voyelle double indique le complément du nom singulier pour la première déclinaison.",
                "-ei est le génitif de la 5e déclinaison, comme res, rei : ce n'est pas celui de manus.",
            ],
            "explanation": "La 4e déclinaison se caractérise par son génitif singulier en -US !",
            "grammaire": {
                "question": "Quel nom est de la 4e déclinaison ? Un nom se reconnaît à son génitif (senatus = le sénat ; dominus = le maître de maison).",
                "options": ["dominus, domini", "rex, regis", "senatus, senatus", "res, rei"],
                "answer": 2,
                "explications": [
                    "Ce génitif en -i est celui de la 2e déclinaison.",
                    "Ce génitif en -is est celui de la 3e déclinaison.",
                    "",
                    "Ce génitif en -ei est celui de la 5e déclinaison.",
                ],
            },
        },
        {
            "id": "m19-02",
            "type": "trou",
            "title": "La 5ème Déclinaison : Res & Dies",
            "content": """## La déclinaison en -E-
La **5ème déclinaison** est la plus petite du latin mais contient des mots capitaux de la vie quotidienne et politique :

- Son génitif singulier se termine en **-EI** :
  - **Res, rei** (f.) : la chose, l'affaire (*➔ la Res Publica, la république !*)
  - **Dies, diei** (m./f.) : le jour (*➔ diurne, midi*)
  - **Spes, spei** (f.) : l'espoir, l'espérance
  - **Fides, fidei** (f.) : la loyauté, la foi (*➔ fidélité*)

Exemple d'Auguste : *Res gestae* (« Les hauts faits accomplis »).

Autre exemple : *Dies novus est* = « C'est un jour nouveau ». À l'accusatif (COD), *dies* devient **diem**.

Applique la même règle à *res* : dans la phrase suivante, *res publica* (la République) est COD.
*Servo, -as, -are* = protéger, conserver.
Complète pour dire : « Auguste protège la République ».""",
            "consigne": "Mets res à l'accusatif, sur le modèle dies ➔ diem :",
            "avant": "Augustus r",
            "apres": " publicam servat.",
            "solution": "em",
            "latin_complet": "Augustus rem publicam servat.",
            "grammaire": {
                "question": "Complète pour dire « Les Romains aiment la loyauté » : Romani ___ amant.",
                "options": ["fides", "fidem", "fidei", "fidam"],
                "answer": 1,
                "explications": [
                    "Cette forme est celle du sujet. Ici, la loyauté est aimée : elle subit l'action.",
                    "",
                    "Cette fin est celle du génitif (« de la loyauté »), pas celle du COD.",
                    "Cette fin appartient à la 1re déclinaison, comme rosam. Les noms en -es n'en font pas partie.",
                ],
            },
        },
        {
            "id": "m19-03",
            "type": "puzzle",
            "title": "Une Rome de Marbre",
            "content": """## Les métamorphoses de la Ville Éternelle
Après un siècle de guerres intestines, **Auguste** instaure la *Pax Romana* (la paix romaine qui durera deux siècles).

Il embellit magnifiquement la cité et déclara avec fierté :
*« Urbem latericiam accepi, marmoream relinquo. »*
(« J'ai reçu une ville de briques, je la laisse de marbre. »)

Exemple : *« Augustus pacem populo dedit. »* = « Auguste a donné la paix au peuple. » (*populo* : datif, « à qui ? »)

À toi ! Regarde bien la terminaison du datif : *civis, -is* (le citoyen) fait *civi* au singulier et *civibus* au pluriel.
*Imperator, -oris* = l'empereur.""",
            "latin": "Imperator civibus pacem dedit.",
            "mots": ["L'empereur", "a donné", "la paix", "aux citoyens.", "au citoyen.", "donne"],
            "solution": "L'empereur a donné la paix aux citoyens.",
            "grammaire": {
                "question": "Complète pour dire « Le chef donne de l'argent au soldat » : Dux ___ pecuniam dat.",
                "options": ["militem", "militis", "militibus", "militi"],
                "answer": 3,
                "explications": [
                    "Cette fin marque le COD. L'argent occupe déjà ce rôle dans la phrase.",
                    "Cette fin dit « du soldat » : elle complète un nom, elle ne désigne pas celui qui reçoit.",
                    "Cette fin est celle d'un pluriel : le chef ne donne qu'à un seul soldat.",
                    "",
                ],
            },
        },
        {
            "id": "m19-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : L'Architecte Vitruve",
            "content": """## Dans l'atelier du maître bâtisseur d'Auguste
Vitruve, le grand théoricien de l'architecture romaine, teste ta maîtrise des 4e et 5e déclinaisons. Réussis pour gagner une bourse de **sesterces 🪙** !""",
            "boss": {"nom": "Vitruve l'Architecte", "icone": "📐", "pv": 3},
            "questions": [
                {
                    "question": "À quelle déclinaison appartient le mot 'res, rei' (la chose, l'affaire) ?",
                    "options": ["La 5e déclinaison", "La 1re déclinaison", "La 3e déclinaison", "La 4e déclinaison"],
                    "answer": 0,
                    "explanation": "Res, rei appartient à la 5e déclinaison avec son génitif en -ei."
                },
                {
                    "question": "Que signifie le nom féminin de la 4e déclinaison 'manus' ?",
                    "options": ["La main", "Le matin", "La maison", "La menace"],
                    "answer": 0,
                    "explanation": "Manus = la main (qui a donné manuel, manucure...)."
                },
                {
                    "question": "Comment s'appelle la longue période de paix instaurée par Auguste ?",
                    "options": ["La Pax Romana", "La Pax Deorum", "La Concordia", "La Lex Julia"],
                    "answer": 0,
                    "explanation": "La Pax Romana est la période de stabilité et de prospérité ouverte par le règne d'Auguste."
                }
            ]
        }
    ]
}
