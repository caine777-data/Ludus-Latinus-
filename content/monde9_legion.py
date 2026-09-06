"""
Monde 9 — L'Armée Romaine & les Légions (Legio & Bellum).
Découverte de l'équipement militaire, de la stratégie romaine,
de la célèbre formation de la Tortue (Testudo) et duel face au chef gaulois Vercingétorix !
"""

LEVEL = {
    "id": "monde9",
    "title": "9 · L'Armée Romaine & les Légions 🦅",
    "lessons": [
        {
            "id": "m9-01",
            "type": "quiz",
            "title": "L'Armement du Légionnaire (Miles)",
            "content": """## Dans les rangs de la Légion !
Le légionnaire romain (*miles*) était le soldat le mieux équipé de l'Antiquité :
- **Scutum** : le grand bouclier rectangulaire courbé en bois et cuir.
- **Pilum** : le javelot lourd conçu pour plier à l'impact et bloquer le bouclier ennemi.
- **Gladius** : le glaive court à double tranchant, parfait pour le combat rapproché.
- **Galea** : le casque de bronze ou de fer avec protège-joues.
- **Lorica** : la cuirasse articulée protégeant le torse.

💡 **Le savais-tu ?**
Un légionnaire portait sur son dos un sac de plus de 30 kg contenant son équipement, ses rations et ses outils de campement ! On les surnommait les « mulets de Marius » !""",
            "question": "Comment s'appelle le grand bouclier rectangulaire du soldat romain ?",
            "options": ["Le Scutum", "Le Pilum", "Le Gladius", "La Galea"],
            "answer": 0,
            "explanation": "C'est bien le Scutum, qui protégeait presque tout le corps du légionnaire !",
        },
        {
            "id": "m9-02",
            "type": "puzzle",
            "title": "La Légion au Combat",
            "content": """## Traduis l'action des troupes romaines
- **Legio** : la légion (l'armée de 5000 soldats).
- **Fortiter** : courageusement, vaillamment.
- **Pugnat** : combat, livre bataille (du verbe *pugnare*).

Reconstitue la phrase latine en français :""",
            "latin": "Legio fortiter pugnat.",
            "mots": ["La légion", "combat", "courageusement.", "fuit", "faiblement.", "le chef"],
            "solution": "La légion combat courageusement.",
            "hints": ["Legio = La légion", "fortiter = courageusement", "pugnat = combat"],
        },
        {
            "id": "m9-03",
            "type": "trou",
            "title": "La Célèbre Tortue Romaine (Testudo)",
            "content": """## Boucliers verrouillés !
Face à une pluie de flèches ou pour approcher les remparts d'une forteresse, le centurion criait l'ordre : **TESTUDO !**
Les légionnaires serraient les rangs :
- Les soldats de devant plaçaient leurs boucliers devant eux.
- Les soldats du milieu levaient leurs boucliers au-dessus de leur tête comme un toit hermétique.

La formation était si solide qu'on pouvait faire rouler un char au-dessus sans qu'elle ne cède !""",
            "consigne": "Complète le nom latin de la formation défensive en forme de tortue :",
            "phrase": "Pour résister aux flèches, les soldats forment la {trou}.",
            "options": ["Testudo", "Corona", "Aquila", "Domus"],
            "solution": "Testudo",
            "reponse": "Testudo",
            "solution_complete": "Pour résister aux flèches, les soldats forment la Testudo.",
            "explication": "Testudo signifie littéralement 'la tortue' en latin !",
        },
        {
            "id": "m9-04",
            "type": "decodeur",
            "title": "Le Décodeur de l'Attaque",
            "content": """## Décrypte l'ordre de combat !
Trouve la fonction de chaque élément :
- 🟢 **Sujet** : Qui attaque ?
- 🔵 **COD** : Quelle arme est lancée ?
- 🔴 **Verbe** : L'action de lancer (*iacere*) !""",
            "phrase_latine": "Miles pilum iacit",
            "mots_francais": ["Le soldat", "le javelot", "lance"],
            "roles": {0: "sujet", 1: "cod", 2: "verbe"},
        },
        {
            "id": "m9-05",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Chef Gaulois Vercingétorix",
            "content": """## Le grand duel de la Guerre des Gaules !
Le fier chef arverne se dresse devant toi avec son torque d'or et son épée longue.
Fais honneur à ta formation romaine pour remporter la victoire et **50 Sesterces 🪙** !""",
            "boss": {"nom": "Le Chef Gaulois Vercingétorix", "icone": "🗡️", "pv": 3},
            "questions": [
                {
                    "question": "Que signifie le mot latin 'miles' qui a donné le mot 'militaire' ?",
                    "options": ["Le soldat", "Le roi", "Le marchand", "Le paysan"],
                    "answer": 0,
                    "explanation": "Exactement ! Miles = le soldat !",
                },
                {
                    "question": "Quelle arme était le javelot lourd du légionnaire ?",
                    "options": ["Le Pilum", "Le Gladius", "La Scutum", "La Toge"],
                    "answer": 0,
                    "explanation": "Bravo ! Le pilum était lancé à 20 mètres avant la charge au glaive.",
                },
                {
                    "question": "Quel oiseau impérial servait d'emblème doré aux légions romaines ?",
                    "options": ["L'Aigle (Aquila)", "Le Faucon", "La Colombe", "Le Hibou"],
                    "answer": 0,
                    "explanation": "L'Aigle (Aquila) était l'insigne sacré porté par l'aquilifer !",
                },
            ],
        },
    ],
}
