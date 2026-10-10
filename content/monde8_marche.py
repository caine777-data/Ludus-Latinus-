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
            "explications": [
                "",
                "La pomme se disait malum ou pomum en latin, jamais panis.",
                "Le panier est le mot français qui descend de panis : la question demande le sens du mot latin.",
                "Cet animal aquatique se disait piscis en latin, qui a donné piscine et pisciculture en français.",
            ],
            "explanation": "Bravo ! 'Panis' est le pain, la nourriture essentielle du citoyen romain !",
        },
        {
            "id": "m8-02",
            "type": "puzzle",
            "title": "Faire ses courses au marché",
            "content": """## Commander comme un Romain
Au comptoir, l'enfant achète : *« Puer panem emit. »* = « L'enfant achète du pain. »

De l'autre côté du comptoir, que fait le marchand ?
- **Mercator, -oris** : le marchand.
- **Vendere** : vendre (*emere* : acheter).

Traduis la phrase du marchand :""",
            "latin": "Mercator panem vendit.",
            "mots": ["Le marchand", "vend", "du pain.", "L'enfant", "achète", "de l'eau."],
            "solution": "Le marchand vend du pain.",
            "hints": ["mercator = le marchand (sujet)", "vendere = vendre", "panis, -is = le pain (ici COD)"],
        },
        {
            "id": "m8-03",
            "type": "trou",
            "title": "Aux Thermes : le Génitif (à qui est-ce ?)",
            "content": """## Après le marché, direction les bains !
Les Romains vont aux thermes (*thermae*) pour se laver, faire du sport et discuter. On passe du bain froid (*frigidarium*) au bain tiède (*tepidarium*), puis au bain très chaud (*caldarium*). Pas de savon : on s'enduit d'huile, puis on racle la peau avec un **strigile**.

## À qui est ce strigile ? Le génitif
Pour dire « de quelqu'un » ou « de quelque chose », le latin change encore la fin du mot. C'est le **GÉNITIF**, le cas du complément du nom.
- Les noms en **-a** prennent **-ae** : rosa puell**ae** = la rose **de la** jeune fille.
- Les noms en **-us** prennent **-i** : equus amic**i** = le cheval **de l'**ami.

À toi ! *Servus, -i* = l'esclave ; *dominus, -i* = le maître ; *portat* = porte.
Complète pour dire : « L'esclave du maître porte l'eau ».""",
            "consigne": "Mets dominus au génitif (« du maître ») :",
            "avant": "Servus domin",
            "apres": " aquam portat.",
            "solution": "i",
            "latin_complet": "Servus domini aquam portat.",
        },
        {
            "id": "m8-04",
            "type": "decodeur",
            "title": "Le Décodeur du Marchand",
            "content": """## Analyse la phrase romaine !

Voici une phrase modèle :
*« Servus aquam domini portat. »* = « L'esclave porte l'eau du maître. »

- 🔵 **Sujet (Nominatif)** : *Servus*, terminaison **-us**.
- 🔴 **COD (Accusatif)** : *aquam*, terminaison **-m**.
- 🟢 **Complément du nom (Génitif)** : *domini*, terminaison **-i** : « du maître ».
- 🟡 **Verbe** : *portat*, terminaison **-t**.

À toi ! Décode la phrase du marchand : quatre mots, quatre rôles.""",
            "mots": ["Mercator", "vinum", "domini", "vendit"],
            "roles": {0: "sujet", 1: "cod", 2: "genitif", 3: "verbe"},
            "traduction": "Le marchand vend le vin du maître.",
        },
        {
            "id": "m8-05",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Bacchus le Maître des Festins",
            "content": """## L'épreuve du Dieu du Vin et de la Fête !
Bacchus te défie au milieu des vignes et des banquets.
Réponds à ses énigmes sur la vie romaine pour remporter une bourse de **sesterces 🪙** !""",
            "boss": {"nom": "Bacchus le Maître des Festins", "icone": "🍇", "pv": 3},
            "questions": [
                {
                    "question": "Quelle phrase veut dire « L'enfant achète le pain du maître » ?",
                    "options": ["Puer panem dominum emit.", "Puer panem domini emit.", "Puer panem dominus emit.", "Puer panem domino emit."],
                    "answer": 1,
                    "explanation": "-i est la marque du génitif : « domini » = du maître. « Dominum » serait un COD, « dominus » un sujet."
                },
                {
                    "question": "Comment s'appelait l'instrument de métal servant à se nettoyer la peau aux thermes ?",
                    "options": ["Le strigile", "Le glaive", "Le stylet", "Le compas"],
                    "answer": 0,
                    "explanation": "Oui ! Le strigile servait à racler l'huile et la sueur.",
                },
                {
                    "question": "Que signifie 'pecunia' en latin ?",
                    "options": ["L'argent", "Le bétail", "Le grenier", "Le marché"],
                    "answer": 0,
                    "explanation": "Parfait ! Pecunia = l'argent, qui a donné le mot français pécuniaire !",
                },
            ],
        },
    ],
}
