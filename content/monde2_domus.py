"""
Monde 2 — Dans la maison romaine (Domus & Familia).
La famille, les animaux familiers, la journée d'école d'un enfant romain
et l'architecture de la maison romaine (atrium, péristyle).
"""

LEVEL = {
    "id": "monde2",
    "title": "2 · Dans la Maison Romaine 🏠",
    "lessons": [
        {
            "id": "m2-01",
            "type": "quiz",
            "title": "La Famille Romaine (Familia)",
            "content": """## Qui vit dans la Domus ?

Dans une maison romaine aisée (*la domus*), la famille est très soudée autour du chef de famille :

- **PATER** : le père *(paterfamilias)*
- **MATER** : la mère
- **FILIUS** : le fils
- **FILIA** : la fille
- **FRATER** : le frère
- **SOROR** : la sœur

💡 **Regarde le français !**
Tu reconnais déjà ces racines :
- *Pater* ➔ **paternel**, patrimoine
- *Mater* ➔ **maternel**, maternité
- *Frater* ➔ **fraternité**, fraternel""",
            "question": "Quel mot latin désigne le fils dans la famille romaine ?",
            "options": ["Filius", "Frater", "Pater", "Servus"],
            "answer": 0,
            "explications": [
                "",
                "Ce mot désigne le frère dans la famille, qui a donné fraternité en français.",
                "Ce mot désigne le père et chef de famille, comme dans paternel ou patriarche.",
                "Servus désigne l'esclave de la maison : ce n'est pas le mot pour l'enfant du père de famille.",
            ],
            "explanation": "Filius est le fils (qui a donné 'filial' en français) !",
            "grammaire": {
                "question": "Tu entres dans la domus et tu vois ta sœur, seule. Quelle salutation est correcte ?",
                "options": ["Salvete, soror !", "Salve, soror !", "Vale, soror !", "Sum, soror !"],
                "answer": 1,
                "explications": [
                    "Cette forme s'adresse à plusieurs personnes, or ta sœur est seule.",
                    "",
                    "Ce mot se dit en partant, pas en arrivant.",
                    "Ce mot veut dire « je suis ». Ce n'est pas une salutation.",
                ],
            },
        },
        {
            "id": "m2-02",
            "type": "puzzle",
            "title": "Les Animaux de compagnie",
            "content": """## Les compagnons à 4 pattes des Romains

Les Romains adoraient leurs animaux de compagnie :
- **CANIS** : le chien *(qui monte la garde : Cave canem = attention au chien !)*
- **FELIS** : le chat
- **EQUUS** : le cheval *(la monture noble)*
- **AVIS** : l'oiseau

Exemple : *« Canis in horto est. »* = « Le chien est dans le jardin. »
*(in horto = dans le jardin)*

À toi : traduis une autre phrase en t'aidant de la liste des animaux.""",
            "latin": "Felis in horto est.",
            "mots": ["Le chat", "est", "dans le jardin.", "Le chien", "Le cheval", "court"],
            "solution": "Le chat est dans le jardin.",
            "grammaire": {
                "question": "Que veut dire « Avis in horto est. » ?",
                "options": ["L'oiseau est dans la maison.", "Le chien est dans le jardin.", "L'oiseau est près du jardin.", "L'oiseau est dans le jardin."],
                "answer": 3,
                "explications": [
                    "Le mot horto désigne le jardin. Il ne désigne pas la maison.",
                    "Regarde le premier mot : ce n'est pas celui du chien.",
                    "Le petit mot in veut dire « dans ». Il ne veut pas dire « près de ».",
                    "",
                ],
            },
        },
        {
            "id": "m2-03",
            "type": "trou",
            "title": "L'École Romaine (Schola)",
            "content": """## Une journée d'école à Rome

À 7 ans, les enfants vont à l'école (*schola*) avec leur précepteur.

Ils n'ont ni trousse ni cahier en papier ! Ils écrivent avec un stylet pointu en fer ou en os (*stilus*) sur une **tablette de bois recouverte de cire d'abeille noire**. S'ils se trompent, ils utilisent le bout plat du stylet pour lisser la cire et recommencer !

📌 **Il ou elle fait l'action : le verbe finit par -T**
- *Scribo* = j'écris ➔ *Scribit* = il/elle écrit
- *Lego* = je lis ➔ à toi de trouver « il/elle lit » !

Complète la phrase pour dire : « L'élève lit sur la tablette ».""",
            "consigne": "Complète le verbe « lit » (de lego, je lis) :",
            "avant": "Discipulus in tabula leg",
            "apres": ".",
            "solution": "it",
            "latin_complet": "Discipulus in tabula legit.",
            "grammaire": {
                "question": "Quelle phrase veut dire « Le père écrit » ?",
                "options": ["Pater scribit.", "Pater scribo.", "Pater legit.", "Pater lego."],
                "answer": 0,
                "explications": [
                    "",
                    "La terminaison -o veut dire « j'écris ». Pour « il écrit », il faut une autre fin.",
                    "Le -t est juste, mais ce verbe ne veut pas dire « écrire ».",
                    "Deux erreurs : la terminaison est celle de « je » et le verbe n'est pas le bon.",
                ],
            },
        },
        {
            "id": "m2-04",
            "type": "quiz",
            "title": "Visite de la Domus : L'Atrium et le Péristyle",
            "content": """## Le plan d'une maison romaine

Quand on franchit la porte d'entrée d'une belle maison romaine :
1. **L'ATRIUM** : La grande pièce centrale d'accueil, avec une ouverture dans le toit pour laisser entrer la lumière et la pluie, qui tombe dans un bassin (*l'impluvium*).
2. **LE TRICLINIUM** : La salle à manger où les Romains mangent allongés sur des banquettes !
3. **LE PERISTYLUM** : Un magnifique jardin intérieur bordé de colonnes en marbre, fleuri de roses et orné de fontaines.

💡 **Le savais-tu ?**
Les Romains les plus modestes ne vivaient pas dans une domus mais dans des immeubles à étages très serrés appelés les **insulae** (qui veut dire 'îles').""",
            "question": "Comment s'appelle le grand salon central avec ouverture sur le toit d'une domus ?",
            "options": ["L'atrium", "Le triclinium", "L'insula", "Le forum"],
            "answer": 0,
            "explications": [
                "",
                "C'est la salle à manger romaine où les convives mangeaient allongés sur trois lits.",
                "C'est un immeuble collectif de plusieurs étages pour le peuple, pas une pièce d'habitation privée.",
                "C'est la grande place publique de la cité, située à l'extérieur des habitations privées.",
            ],
            "explanation": "C'est bien l'atrium, la pièce maîtresse et lumineuse de la maison !",
            "grammaire": {
                "question": "Complète pour dire « La sœur lit dans l'atrium » : Soror in atrio leg___",
                "options": ["-a", "-o", "-it", "-ere"],
                "answer": 2,
                "explications": [
                    "Cette fin ressemble à celle d'un nom féminin comme filia, pas à celle d'un verbe qui dit « elle ».",
                    "Cette terminaison veut dire « je lis », or c'est la sœur qui lit.",
                    "",
                    "C'est la forme du dictionnaire (legere, lire). Elle ne dit pas qui fait l'action.",
                ],
            },
        },
        {
            "id": "m2-05",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Sphinx de l'Atrium",
            "content": """## Le Sphinx protecteur de la Domus

Pour gagner ta place de membre d'honneur de la cité romaine et empocher une bourse de **sesterces 🪙**, réponds sans hésiter aux énigmes du Sphinx !""",
            "boss": {"nom": "Le Sphinx de l'Atrium", "icone": "🦁", "pv": 3},
            "questions": [
                {
                    "question": "Que signifie le mot 'mater' en français ?",
                    "options": ["La sœur", "La mère", "La fille", "La tante"],
                    "answer": 1,
                    "explanation": "Mater est la mère !"
                },
                {
                    "question": "Dans « Mater in horto scribit », que montre la terminaison -t de « scribit » ?",
                    "options": ["Je fais l'action", "Il ou elle fait l'action", "Plusieurs personnes font l'action", "L'action est déjà finie"],
                    "answer": 1,
                    "explanation": "-t marque « il » ou « elle » : « scribit » = elle écrit. Avec « scribo », on dirait « j'écris »."
                },
                {
                    "question": "Que veut dire 'Cave canem' inscrit sur les mosaïques de Pompéi ?",
                    "options": ["Bienvenue chez nous", "Attention au chien !", "Donnez à manger au chien", "Chien à vendre"],
                    "answer": 1,
                    "explanation": "Cave canem = Attention au chien !"
                }
            ]
        }
    ]
}
