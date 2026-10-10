"""
Monde 20 — Les Chemins de l'Empire.
Le pronom relatif (qui, quae, quod) et la proposition subordonnée relative.
Le réseau routier romain, les aqueducs (le Pont du Gard) et la romanisation des provinces.
"""

LEVEL = {
    "id": "monde20",
    "classe": "3eme",
    "title": "20 · Les Chemins de l'Empire 🛣️",
    "lessons": [
        {
            "id": "m20-01",
            "type": "quiz",
            "title": "Le Pronom Relatif : Qui, Quae, Quod",
            "content": """## Relier les phrases comme un orateur
Le pronom relatif permet d'enrichir le style en reliant deux phrases :
- « J'admire le soldat. Le soldat défend Rome » ➔ « J'admire le soldat **qui** défend Rome ».

En latin, le pronom relatif se décline ainsi au nominatif :
- **QUI** (masculin) : qui / lequel
- **QUAE** (féminin) : qui / laquelle
- **QUOD** (neutre) : qui / ce qui / lequel

À l'accusatif (quand il est COD de la relative) :
- **QUEM** (masculin sg.) : que / qu'
- **QUAM** (féminin sg.) : que / qu'
- **QUOD** (neutre sg.) : que / ce que

💡 **La règle d'or du pronom relatif en latin** :
Il prend le **GENRE** et le **NOMBRE** du mot qu'il remplace (son antécédent), mais son **CAS** dépend de son rôle dans sa propre proposition !""",
            "question": "Quel pronom relatif masculin singulier utilise-t-on pour le sujet 'le soldat qui combat' (miles ...) ?",
            "options": ["qui", "quae", "quod", "quem"],
            "answer": 0,
            "explications": [
                "",
                "Cette forme est le pronom relatif au genre féminin, comme dans femina quae cantat.",
                "Cette forme est réservée au genre neutre singulier, par exemple templum quod stat.",
                "Cette forme masculine est au cas complément d'objet direct : elle ne peut pas être sujet.",
            ],
            "explanation": "Pour un nom masculin singulier sujet, on emploie 'qui' : miles qui pugnat !",
        },
        {
            "id": "m20-02",
            "type": "trou",
            "title": "Le Pronom Relatif au Féminin : Quae et Quam",
            "content": """## Accorder avec un nom féminin
Si l'antécédent est féminin (par exemple *urbs*, la ville) :
- Sujet : *Urbs **quae** in colle stat.* (« La ville **qui** se dresse sur la colline. »)
- COD : *Urbs **quam** Caesar condidit.* (« La ville **que** César a fondée. »)

À toi ! *Aqua* (l'eau) est féminin. Dans la phrase suivante, c'est l'aqueduc qui fait l'action : l'eau est le COD de *ducit* (conduit).
Complète pour dire : « L'eau que l'aqueduc conduit est bonne ».""",
            "consigne": "Choisis le pronom relatif féminin : sujet ou COD ?",
            "avant": "Aqua ",
            "apres": " aquaeductus ducit bona est.",
            "solution": "quam",
            "latin_complet": "Aqua quam aquaeductus ducit bona est.",
        },
        {
            "id": "m20-03",
            "type": "puzzle",
            "title": "La Reine des Voies : La Via Appia",
            "content": """## 80 000 km de routes pavées !
Pour relier Rome à toutes les provinces d'Europe, d'Asie et d'Afrique, les Romains ont bâti un réseau routier pavé colossal. D'où le proverbe : *« Tous les chemins mènent à Rome ! »*

La plus célèbre est la **Via Appia**, reliant Rome au port de Brindisi vers l'Orient.

Exemple : *« Via Appia regina viarum est. »* = « La voie Appienne est la reine des routes. »

À toi ! Une phrase avec un pronom relatif : *quae* (qui) ou *quam* (que) ?
*Facio, -is, -ere, feci* = faire, construire ; *longus, -a, -um* = long.""",
            "latin": "Via quam Romani fecerunt longa est.",
            "mots": ["La route", "que", "les Romains", "ont construite", "est longue.", "qui", "Les routes"],
            "solution": "La route que les Romains ont construite est longue.",
        },
        {
            "id": "m20-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Préfet des Voies Impériales",
            "content": """## Au poste de garde de la Via Aurelia
Le préfet des routes impériales vérifie ton laissez-passer grammatical. Réussis pour remporter une bourse de **sesterces 🪙** !""",
            "boss": {"nom": "Le Préfet des Voies", "icone": "🏛️", "pv": 3},
            "questions": [
                {
                    "question": "De quoi dépend le cas d'un pronom relatif en latin ?",
                    "options": ["De sa fonction dans la proposition relative", "Du cas du nom qu'il remplace dans la phrase", "Du verbe principal placé devant la virgule", "De la terminaison exacte du mot précédent"],
                    "answer": 0,
                    "explanation": "Le cas dépend de la fonction du pronom dans sa propre proposition relative."
                },
                {
                    "question": "Complète : « Le soldat que César voit est courageux ». Miles ___ Caesar videt fortis est.",
                    "options": ["qui", "quam", "quod", "quem"],
                    "answer": 3,
                    "explanation": "« Miles » est masculin singulier, et le relatif est le COD de « videt » : accusatif masculin, « quem ». « Qui » serait le sujet, « quam » conviendrait à un mot féminin, « quod » à un neutre."
                },
                {
                    "question": "Quelle forme du pronom relatif est au neutre singulier ?",
                    "options": ["QUOD", "QUI", "QUAE", "QUEM"],
                    "answer": 0,
                    "explanation": "Quod est la forme neutre (singulier nominatif et accusatif)."
                }
            ]
        }
    ]
}
