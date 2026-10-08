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
            "explications": [
                "",
                "C'est le javelot lourd lancé par le soldat romain avant de charger au corps à corps.",
                "C'est l'épée courte à double tranchant servant à frapper dans les rangs serrés.",
                "C'est le casque de bronze ou de fer qui protégeait la tête du soldat.",
            ],
            "explanation": "C'est bien le Scutum, qui protégeait presque tout le corps du légionnaire !",
        },
        {
            "id": "m9-02",
            "type": "puzzle",
            "title": "La Légion au Combat",
            "content": """## Traduis l'action des troupes romaines
- **Legio** : la légion (l'armée de 5000 soldats) ; au pluriel : **legiones**.
- Exemple : *« Legio fortiter pugnat. »* = « La légion combat courageusement. »

César envoie maintenant plusieurs légions. Reconstitue la phrase en français :""",
            "latin": "Legiones fortiter pugnant.",
            "mots": ["Les légions", "combattent", "courageusement.", "La légion", "combat", "fuient"],
            "solution": "Les légions combattent courageusement.",
            "hints": ["legiones = pluriel de legio", "-nt = ils, elles (plusieurs)", "fortiter = courageusement"],
        },
        {
            "id": "m9-03",
            "type": "trou",
            "title": "La Tortue Romaine : le Pluriel",
            "content": """## Boucliers verrouillés !
Face à une pluie de flèches, le centurion crie : **TESTUDO !** (« la tortue »). Les légionnaires serrent les rangs. Ceux de devant tiennent leur bouclier devant eux, ceux du milieu le lèvent au-dessus de leur tête, comme un toit. La formation est si solide qu'un char peut rouler dessus !

## Un soldat, des soldats : le pluriel
Tu sais reconnaître le sujet et le COD au singulier. Au pluriel, la fin du mot change encore :
- Noms en **-a** : sujet *rosa* ➔ **rosae** ; COD *rosam* ➔ **rosas**.
- Noms en **-us** : sujet *servus* ➔ **servi** ; COD *servum* ➔ **servos**.

Exemple : *Puellae rosas amant.* = « Les jeunes filles aiment les roses. »
Tu as reconnu *-ae* et *-i* : ce sont aussi les terminaisons du génitif. C'est le sens de la phrase qui tranche.

À toi ! *Legionarius, -i* = le légionnaire ; *gladius, -i* = le glaive ; *portant* = portent.
Complète pour dire : « Les légionnaires portent leurs glaives ».""",
            "consigne": "Mets gladius au COD pluriel :",
            "avant": "Legionarii gladi",
            "apres": " portant.",
            "solution": "os",
            "latin_complet": "Legionarii gladios portant.",
        },
        {
            "id": "m9-04",
            "type": "decodeur",
            "title": "Le Décodeur de l'Attaque",
            "content": """## Décrypte l'ordre de combat !
Trouve la fonction de chaque élément :
- 🔵 **Sujet** : Qui attaque ?
- 🔴 **COD** : Quelle arme est lancée ?
- 🟡 **Verbe** : L'action de lancer (*iacere*) !""",
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
Fais honneur à ta formation romaine pour remporter la victoire et une bourse de **sesterces 🪙** !""",
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
                    "options": ["L'Aigle", "Le Faucon", "Le Vautour", "L'Épervier"],
                    "answer": 0,
                    "explanation": "L'Aigle (Aquila) était l'insigne sacré porté par l'aquilifer !",
                },
            ],
        },
    ],
}
