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
            "options": ["-US (ex: manus, exercitus)", "-IS", "-AE", "-I"],
            "answer": 0,
            "explanation": "La 4e déclinaison se caractérise par son génitif singulier en -US !",
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

Complète pour dire : « C'est un jour nouveau » (*Dies novus est*).""",
            "consigne": "Complète le mot 'jour' (dies) au nominatif :",
            "avant": "Di",
            "apres": " novus est.",
            "solution": "es",
            "latin_complet": "Dies novus est.",
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

Reconstitue cette phrase célébrant la grandeur impériale :
*« Augustus pacem populo dedit. »*
*(Augustus = Auguste, pacem = la paix [Acc.], populo = au peuple [Dat.], dedit = a donné)*""",
            "latin": "Augustus pacem populo dedit.",
            "mots": ["Auguste", "a donné", "la paix", "au peuple.", "Le sénat", "délibère."],
            "solution": "Auguste a donné la paix au peuple.",
        },
        {
            "id": "m19-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : L'Architecte Vitruve",
            "content": """## Dans l'atelier du maître bâtisseur d'Auguste
Vitruve, le grand théoricien de l'architecture romaine, teste ta maîtrise des 4e et 5e déclinaisons. Réussis pour gagner **50 Sesterces 🪙** !""",
            "boss": {"nom": "Vitruve l'Architecte", "icone": "📐", "pv": 3},
            "questions": [
                {
                    "question": "À quelle déclinaison appartient le mot 'res, rei' (la chose, l'affaire) ?",
                    "options": ["La 5ème déclinaison (génitif en -ei)", "La 1ère déclinaison", "La 2ème déclinaison", "La 3ème déclinaison"],
                    "answer": 0,
                    "explanation": "Res, rei appartient à la 5e déclinaison avec son génitif en -ei."
                },
                {
                    "question": "Que signifie le nom féminin de la 4e déclinaison 'manus' ?",
                    "options": ["La main (ou la troupe armée)", "Le matin", "La mer", "La maison"],
                    "answer": 0,
                    "explanation": "Manus = la main (qui a donné manuel, manucure...)."
                },
                {
                    "question": "Comment s'appelle la longue période de paix instaurée par Auguste ?",
                    "options": ["La Pax Romana (Paix Romaine)", "La Pax Deorum", "L'Aura Populi", "La Concordia Magna"],
                    "answer": 0,
                    "explanation": "La Pax Romana est la période de stabilité et de prospérité ouverte par le règne d'Auguste."
                }
            ]
        }
    ]
}
