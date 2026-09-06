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
            "explanation": "Filius est le fils (qui a donné 'filial' en français) !",
        },
        {
            "id": "m2-02",
            "type": "puzzle",
            "title": "Les Animaux de compagnie",
            "content": """## Les compagnons à 4 pattes des Romains

Les Romains adoraient leurs animaux de compagnie :
- **CANIS** : le chien *(qui monte la garde : Cave canem !)*
- **FELIS** : le chat
- **EQUUS** : le cheval *(la monture noble)*
- **AVIS** : l'oiseau

Reconstitue cette phrase de la vie quotidienne :
*« Canis in horto est. »*
*(Canis = le chien, in = dans, horto = le jardin, est = est)*""",
            "latin": "Canis in horto est.",
            "mots": ["Le chien", "est", "dans le jardin.", "Le cheval", "court", "la maison."],
            "solution": "Le chien est dans le jardin.",
        },
        {
            "id": "m2-03",
            "type": "trou",
            "title": "L'École Romaine (Schola)",
            "content": """## Une journée d'école à Rome

À 7 ans, les enfants vont à l'école (*schola*) avec leur précepteur.

Ils n'ont ni trousse ni cahier en papier ! Ils écrivent avec un stylet pointu en fer ou en os (*stilus*) sur une **tablette de bois recouverte de cire d'abeille noire**. S'ils se trompent, ils utilisent le bout plat du stylet pour lisser la cire et recommencer !

📌 **Le verbe écrire** :
- *Scribo* = j'écris
- *Scribit* = il/elle écrit (se termine par un **-t**)

Complète la phrase pour dire : « L'élève écrit sur la tablette » (*Discipulus scribit*).""",
            "consigne": "Complète le verbe 'écrit' (scribit) :",
            "avant": "Discipulus scri",
            "apres": " in tabula.",
            "solution": "bit",
            "latin_complet": "Discipulus scribit in tabula.",
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
            "explanation": "C'est bien l'atrium, la pièce maîtresse et lumineuse de la maison !",
        },
        {
            "id": "m2-05",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Sphinx de l'Atrium",
            "content": """## Le Sphinx protecteur de la Domus

Pour gagner ta place de membre d'honneur de la cité romaine et empocher **50 Sesterces 🪙**, réponds sans hésiter aux énigmes du Sphinx !""",
            "boss": {"nom": "Le Sphinx de l'Atrium", "icone": "🦁", "pv": 3},
            "questions": [
                {
                    "question": "Que signifie le mot 'mater' en français ?",
                    "options": ["La sœur", "La mère", "La fille", "La tante"],
                    "answer": 1,
                    "explanation": "Mater est la mère !"
                },
                {
                    "question": "Sur quoi écrivaient les écoliers romains ?",
                    "options": ["Des tablettes de cire avec un stylet", "Des feuilles de papier", "Des ardoises magiques", "De la soie"],
                    "answer": 0,
                    "explanation": "Ils écrivaient avec un stylet sur de la cire d'abeille."
                },
                {
                    "question": "Que veut dire 'Cave canem' inscrit sur les mosaïques de Pompéi ?",
                    "options": ["Bienvenue chez nous", "Attention au chien !", "Donnez à manger au chien", "Maison close"],
                    "answer": 1,
                    "explanation": "Cave canem = Attention au chien !"
                }
            ]
        }
    ]
}
