"""
Monde 8 — La Cité de Rome, les Marchés & la Vie Quotidienne (Urbs & Mercatus).
Découverte de la vie quotidienne romaine, du marché (nourriture, commerce),
des thermes romains et duel contre le Dieu des Festins : Bacchus !
"""

LEVEL = {
    "id": "monde8",
    "title": "8 · La Cité de Rome, Marchés & Vie Quotidienne 🍇",
    "lessons": [
        {
            "id": "m8-01",
            "type": "quiz",
            "title": "Le Grand Marché du Forum (Mercatus)",
            "content": """## Bienvenue au marché du Forum !
Les Romains se pressent chaque matin au marché (*mercatus*) pour acheter de quoi manger :
- **Panis** : le pain (aliment de base cuit dans des fours à bois).
- **Aqua** : l'eau pure acheminée par les immenses aqueducs.
- **Vinum** : le vin (que les Romains buvaient toujours coupé d'eau et de miel).
- **Malum** : la pomme (et les fruits frais).
- **Pecunia** : l'argent (qui a donné le mot français « pécuniaire » !).

💡 **Le savais-tu ?**
Les Romains mangeaient peu le matin : un morceau de pain (*panis*) frotté d'ail et quelques olives. Le vrai grand repas avait lieu le soir, c'était la **cena** !""",
            "question": "Que signifie le mot latin 'panis' qui a donné notre mot 'panier' ?",
            "options": ["Le pain", "La pomme", "Le panier", "Le poisson"],
            "answer": 0,
            "explanation": "Bravo ! 'Panis' est le pain, la nourriture essentielle du citoyen romain !",
        },
        {
            "id": "m8-02",
            "type": "puzzle",
            "title": "Faire ses courses au marché",
            "content": """## Commander comme un Romain
Au comptoir du marchand, utilise les mots appris :
- **Puer** : le jeune garçon (ou l'enfant).
- **Panem** : du pain (à l'accusatif, car c'est ce qu'il achète !).
- **Emit** : achète (du verbe *emere*).

Reconstitue la phrase pour dire que l'enfant achète du pain.""",
            "latin": "Puer panem emit.",
            "mots": ["L'enfant", "achète", "du pain.", "vend", "la pomme.", "le soldat"],
            "solution": "L'enfant achète du pain.",
            "hints": ["Puer = L'enfant", "panem = du pain", "emit = achète"],
        },
        {
            "id": "m8-03",
            "type": "trou",
            "title": "Détente aux Thermes Romains (Thermae)",
            "content": """## Après le marché, direction les bains !
Les Romains adoraient aller aux thermes (*thermae*) pour se laver, faire du sport et discuter politique :
- Le **Frigidarium** : le bain d'eau glacée pour raffermir la peau.
- Le **Tepidarium** : la salle tiède pour s'habituer à la température.
- Le **Caldarium** : la grande salle d'eau très chaude chauffée par le sol (*hypocauste*).

Comme ils n'avaient pas de savon, ils s'enduisaient d'huile d'olive puis raclaient leur peau avec un instrument courbé en métal appelé le **strigile** !""",
            "consigne": "Complète le nom de la salle d'eau très chaude des thermes :",
            "phrase": "Dans les thermes, la salle la plus chaude est le {trou}.",
            "options": ["Caldarium", "Frigidarium", "Aqueduc", "Amphithéâtre"],
            "solution": "Caldarium",
            "reponse": "Caldarium",
            "solution_complete": "Dans les thermes, la salle la plus chaude est le Caldarium.",
            "explication": "Caldarium vient de 'calidus' qui signifie chaud (qui a donné 'calorique' et 'chaud') !",
        },
        {
            "id": "m8-04",
            "type": "decodeur",
            "title": "Le Décodeur du Marchand",
            "content": """## Analyse la phrase romaine !
Active les couleurs magiques du décodeur pour identifier :
- 🟢 **Sujet (Nominatif)** : Qui fait l'action ?
- 🔵 **COD (Accusatif)** : Qu'est-ce qui est vendu ?
- 🔴 **Verbe** : L'action de vendre !""",
            "phrase_latine": "Mercator aquam vendit",
            "mots_francais": ["Le marchand", "de l'eau", "vend"],
            "roles": {0: "sujet", 1: "cod", 2: "verbe"},
        },
        {
            "id": "m8-05",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Bacchus le Maître des Festins",
            "content": """## L'épreuve du Dieu du Vin et de la Fête !
Bacchus te défie au milieu des vignes et des banquets.
Réponds à ses énigmes sur la vie romaine pour remporter **50 Sesterces 🪙** !""",
            "boss": {"nom": "Bacchus le Maître des Festins", "icone": "🍇", "pv": 3},
            "questions": [
                {
                    "question": "Que signifie le mot 'aqua' présent dans les 'aqueducs' ?",
                    "options": ["L'eau", "Le feu", "Le vin", "La terre"],
                    "answer": 0,
                    "explanation": "Exactement ! Aqua = l'eau !",
                },
                {
                    "question": "Comment s'appelait l'instrument de métal servant à se nettoyer la peau aux thermes ?",
                    "options": ["Le strigile", "Le glaive", "Le stylet", "Le compas"],
                    "answer": 0,
                    "explanation": "Oui ! Le strigile servait à racler l'huile et la sueur.",
                },
                {
                    "question": "Que signifie 'pecunia' en latin ?",
                    "options": ["L'argent / la monnaie", "Le poisson", "La maison", "Le cheval"],
                    "answer": 0,
                    "explanation": "Parfait ! Pecunia = l'argent, qui a donné le mot français pécuniaire !",
                },
            ],
        },
    ],
}
