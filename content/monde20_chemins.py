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
            "options": ["QUI (miles qui pugnat)", "QUAE", "QUOD", "QUEM"],
            "answer": 0,
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

Complète la phrase pour dire : « La voie romaine qui mène à Rome » (*Via quae Romam ducit*).""",
            "consigne": "Complète le pronom relatif féminin 'qui' (quae) :",
            "avant": "Via ",
            "apres": " Romam ducit.",
            "solution": "quae",
            "latin_complet": "Via quae Romam ducit.",
        },
        {
            "id": "m20-03",
            "type": "puzzle",
            "title": "La Reine des Voies : La Via Appia",
            "content": """## 80 000 km de routes pavées !
Pour relier Rome à toutes les provinces d'Europe, d'Asie et d'Afrique, les Romains ont bâti un réseau routier pavé colossal. D'où le proverbe : *« Tous les chemins mènent à Rome ! »*

La plus célèbre est la **Via Appia**, reliant Rome au port de Brindisi vers l'Orient.

Reconstitue cette phrase sur la renommée de cette route :
*« Via Appia regina viarum est. »*
*(Via Appia = la voie Appienne, regina = la reine, viarum = des routes [Gén. pl.], est = est)*""",
            "latin": "Via Appia regina viarum est.",
            "mots": ["La Voie Appienne", "est", "la reine", "des routes.", "Les légions", "marchent."],
            "solution": "La Voie Appienne est la reine des routes.",
        },
        {
            "id": "m20-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Préfet des Voies Impériales",
            "content": """## Au poste de garde de la Via Aurelia
Le préfet des routes impériales vérifie ton laissez-passer grammatical. Réussis pour remporter **50 Sesterces 🪙** !""",
            "boss": {"nom": "Le Préfet des Voies", "icone": "🏛️", "pv": 3},
            "questions": [
                {
                    "question": "De quoi dépend le cas d'un pronom relatif en latin ?",
                    "options": [
                        "De sa fonction (sujet, COD, etc.) à l'intérieur de la proposition relative",
                        "Uniquement de la terminaison du mot précédent",
                        "Il est toujours au nominatif",
                        "Du bon vouloir du locuteur"
                    ],
                    "answer": 0,
                    "explanation": "Le cas dépend de la fonction du pronom dans sa propre proposition relative."
                },
                {
                    "question": "Quel célèbre aqueduc romain à 3 étages peut-on encore admirer en France (Gaule) ?",
                    "options": ["Le Pont du Gard", "Le Viaduc de Millau", "Le Pont d'Avignon", "L'Aqueduc de Lyon"],
                    "answer": 0,
                    "explanation": "Le Pont du Gard, bâti sous Auguste pour alimenter la ville de Nîmes en eau !"
                },
                {
                    "question": "Quelle forme du pronom relatif est au neutre ?",
                    "options": ["QUOD", "QUI", "QUAE", "QUEM"],
                    "answer": 0,
                    "explanation": "Quod est la forme neutre (singulier nominatif et accusatif)."
                }
            ]
        }
    ]
}
