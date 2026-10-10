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
- **Aquila** : l'aigle, emblème de chaque légion, porté par l'*aquilifer*.

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
            "grammaire": {
                "question": "Comment dit-on « le casque du légionnaire » ? (galea = le casque, legionarius = le légionnaire)",
                "options": ["Galea legionarius.", "Galea legionarii.", "Galea legionarium.", "Galeae legionarius."],
                "answer": 1,
                "explications": [
                    "Les deux mots ont la fin du sujet : rien n'indique « de ».",
                    "",
                    "La fin -m marque le COD, pas le complément du nom.",
                    "Le génitif est sur l'autre mot : cela dirait « le légionnaire du casque ».",
                ],
            },
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
            "grammaire": {
                "question": "Quelle phrase veut dire « La légion crie » ? (legio au pluriel : legiones ; clamare = crier)",
                "options": ["Legiones clamat.", "Legio clamant.", "Legio clamat.", "Legiones clamant."],
                "answer": 2,
                "explications": [
                    "Le sujet est au pluriel, mais le verbe a la fin du singulier.",
                    "Le sujet est au singulier, mais le verbe a la fin du pluriel.",
                    "",
                    "Les deux mots sont au pluriel : cela parle de plusieurs légions.",
                ],
            },
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
            "grammaire": {
                "question": "Quelle phrase veut dire « Les jeunes filles voient les agneaux » ?",
                "options": ["Puellae agnos vident.", "Puellas agni vident.", "Puellae agnum vident.", "Puella agnos vident."],
                "answer": 0,
                "explications": [
                    "",
                    "Les rôles sont inversés : ici, ce sont les agneaux qui voient.",
                    "La fin -um ne montre qu'un seul agneau.",
                    "Le sujet est au singulier, mais le verbe a la fin du pluriel.",
                ],
            },
        },
        {
            "id": "m9-04",
            "type": "decodeur",
            "title": "Le Décodeur de l'Attaque",
            "content": """## Décrypte l'ordre de combat !

Voici une phrase modèle, au pluriel :
*« Legionarii galeas portant. »* = « Les légionnaires portent les casques. »

- 🔵 **Sujet pluriel** : *Legionarii*, terminaison **-i**.
- 🔴 **COD pluriel** : *galeas*, terminaison **-as**.
- 🟡 **Verbe pluriel** : *portant*, terminaison **-nt**.

À toi ! L'ordre des mots a changé. Rappelle-toi que les noms en **-us** font leur COD pluriel en **-os**.""",
            "mots": ["Equos", "servi", "vident"],
            "roles": {0: "cod", 1: "sujet", 2: "verbe"},
            "traduction": "Les esclaves voient les chevaux.",
            "grammaire": {
                "question": "Dans « Lupos pueri vident. » (pueri = les enfants), quel mot est le sujet ?",
                "options": ["Lupos", "Pueri", "Vident", "On ne peut pas savoir"],
                "answer": 1,
                "explications": [
                    "C'est le premier mot, mais sa fin -os indique un COD pluriel.",
                    "",
                    "C'est le verbe, reconnaissable à sa fin -nt.",
                    "Si : la fin de chaque mot indique son rôle, même quand l'ordre change.",
                ],
            },
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
                    "question": "Quelle phrase veut dire « Les esclaves voient les roses » ?",
                    "options": ["Servi rosam vident.", "Rosae servos vident.", "Servi rosas vident.", "Servus rosas vident."],
                    "answer": 2,
                    "explanation": "« Servi » est le sujet pluriel (-i), « rosas » le COD pluriel (-as), « vident » veut dire « ils voient » (-nt). « Rosae servos vident » inverse les rôles (« les roses voient les esclaves »)."
                },
                {
                    "question": "Quelle arme était le javelot lourd du légionnaire ?",
                    "options": ["Le Gladius", "Le Pilum", "Le Scutum", "La Galea"],
                    "answer": 1,
                    "explanation": "Bravo ! Le pilum était lancé avant la charge au glaive."
                },
                {
                    "question": "Quel oiseau impérial servait d'emblème aux légions romaines ?",
                    "options": ["L'Aigle", "Le Faucon", "Le Vautour", "L'Épervier"],
                    "answer": 0,
                    "explanation": "L'Aigle (Aquila) était l'insigne sacré porté par l'aquilifer !"
                },
            ],
        },
    ],
}
