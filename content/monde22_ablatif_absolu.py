"""
Monde 22 — Le Secret de l'Ablatif Absolu.
La structure reine de la prose latine classique : Nom à l'ablatif + Participe à l'ablatif.
Sa traduction fluide en français (temporelle, causale) et ses formules emblématiques.
"""

LEVEL = {
    "id": "monde22",
    "classe": "3eme",
    "title": "22 · Le Secret de l'Ablatif Absolu 📜",
    "lessons": [
        {
            "id": "m22-01",
            "type": "quiz",
            "title": "Qu'est-ce que l'Ablatif Absolu ?",
            "content": """## Le chef-d'œuvre de la grammaire latine !
En 3ème, l'**Ablatif Absolu** est la construction la plus célèbre et la plus fréquente chez César, Cicéron et Tite-Live.

Le mot *absolu* vient du latin *absolutus* qui veut dire **« détaché, libre »**.

C'est une petite proposition indépendante insérée dans la phrase, composée de :
1. Un **Nom ou pronom à l'Ablatif** (le sujet de l'action)
2. Un **Participe à l'Ablatif** (le verbe de l'action)

Exemple magique :
*« **Urbe capta**, milites redierunt. »*
- *Urbe* = la ville (à l'ablatif singulier)
- *Capta* = ayant été prise (PPP à l'ablatif singulier féminin)

En français, on traduit élégamment par :
➔ **« La ville ayant été prise... »**
➔ ou **« Une fois la ville prise... »**
➔ ou **« Après la prise de la ville... »**""",
            "question": "De quoi est composé un ablatif absolu classique ?",
            "options": [
                "D'un nom à l'ablatif et d'un participe à l'ablatif",
                "D'un verbe à l'infinitif et d'un adjectif au nominatif",
                "D'un nom au génitif avec une préposition",
                "D'un verbe au futur et d'un adverbe"
            ],
            "answer": 0,
            "explications": [
                "",
                "Un adjectif au nominatif est le cas du sujet. Ici, aucun des deux mots n'est au cas sujet.",
                "Le génitif n'est pas le cas de cette construction, et un génitif ne s'emploie jamais avec une préposition.",
                "Cette construction ne contient aucun verbe conjugué : un futur et un adverbe ne suffisent pas à la former.",
            ],
            "explanation": "Nom à l'ablatif + participe à l'ablatif forme la proposition absolue !",
        },
        {
            "id": "m22-02",
            "type": "trou",
            "title": "Les Deux Mots qui Résument une Bataille",
            "content": """## Déchiffrer les formules célèbres
L'ablatif absolu permet aux auteurs romains d'exprimer des événements entiers en seulement deux mots !

- *Bello confecto* = La guerre étant achevée / Une fois la guerre finie
- *Sole oriente* = Le soleil se levant / Au lever du soleil
- *Pace facta* = La paix ayant été conclue

Le participe s'accorde avec son nom, tous deux à l'ablatif : *bello confecto* (neutre), *pace facta* (féminin).

À toi ! *Oppidum, -i* (n.) = la place forte ; *captus, -a, -um* = pris.
Complète pour dire : « La place forte prise, les soldats se réjouissent ».""",
            "consigne": "Accorde le participe avec oppido (ablatif neutre) :",
            "avant": "Oppido capt",
            "apres": ", milites gaudent.",
            "solution": "o",
            "latin_complet": "Oppido capto, milites gaudent.",
        },
        {
            "id": "m22-03",
            "type": "puzzle",
            "title": "Sous la Conduite de César (Caesare duce)",
            "content": """## L'ablatif absolu sans participe !
Parfois, quand le verbe sous-entendu est le verbe « être » (qui n'a pas de participe présent en latin), l'ablatif absolu est formé de **deux noms à l'ablatif** :
- *Caesare duce* = « César étant le chef » ➔ **« Sous la conduite de César »**
- *Cicerone consule* = « Cicéron étant consul » ➔ **« Sous le consulat de Cicéron »**

Exemple : *« Caesare duce, Romani vicerunt. »* = « Sous la conduite de César, les Romains ont vaincu. »

À toi ! *Rex, regis* = le roi ; *parvus, -a, -um* = petit.""",
            "latin": "Romulo rege, Roma parva erat.",
            "mots": ["Sous le règne de Romulus,", "Rome", "était", "petite.", "est", "Le roi Romulus"],
            "solution": "Sous le règne de Romulus, Rome était petite.",
        },
        {
            "id": "m22-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Rhéteur Quintilien",
            "content": """## L'épreuve du grand professeur de rhétorique
Quintilien, précepteur des princes impériaux, examine ta compréhension de l'ablatif absolu. Triomphe pour empocher une bourse de **sesterces 🪙** !""",
            "boss": {"nom": "Quintilien le Rhéteur", "icone": "📜", "pv": 3},
            "questions": [
                {
                    "question": "Comment se traduit fidèlement l'ablatif absolu 'Hostibus victis' ?",
                    "options": ["Une fois les ennemis vaincus", "Pendant que l'ennemi combattait", "Avant la défaite des ennemis", "Pour faire fuir les ennemis"],
                    "answer": 0,
                    "explanation": "Hostibus (Abl. pl.) + victis (PPP Abl. pl.) = une fois les ennemis vaincus."
                },
                {
                    "question": "Que signifie 'Cicerone consule' ?",
                    "options": ["Sous le consulat de Cicéron", "Sur l'ordre du consul Cicéron", "Devant le tribunal de Cicéron", "Pendant le discours de Cicéron"],
                    "answer": 0,
                    "explanation": "C'est un ablatif absolu nominal : Cicéron étant consul."
                },
                {
                    "question": "Pourquoi dit-on que cette proposition est 'absolue' ?",
                    "options": ["Elle est détachée du reste de la phrase", "Elle exprime une certitude incontestable", "Elle dépend directement du verbe principal", "Elle donne un ordre impératif et définitif"],
                    "answer": 0,
                    "explanation": "Absolutus signifie délié / détaché des liens grammaticaux de la phrase principale."
                }
            ]
        }
    ]
}
