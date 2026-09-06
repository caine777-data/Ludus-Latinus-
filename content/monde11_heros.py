"""
Monde 11 — Les Héros de la République.
Horatius Coclès, Mucius Scaevola, Cloelie : la vertu romaine (virtus)
et la résistance républicaine face aux rois étrusques.
"""

LEVEL = {
    "id": "monde11",
    "classe": "4eme",
    "title": "11 · Les Héros de la République 🛡️",
    "lessons": [
        {
            "id": "m11-01",
            "type": "quiz",
            "title": "Horatius Coclès seul sur le pont",
            "content": """## Rome menacée par le roi Porsenna
En 509 av. J.-C., les Romains chassent leur dernier roi tyrannique, Tarquin le Superbe, et fondent la **République** (*Res Publica* : la chose publique).

Mais les Étrusques, menés par le roi Porsenna, attaquent Rome pour rétablir la royauté !

Un soldat romain légendaire, **Horatius Coclès** (*Coclès* signifie « le borgne »), accomplit un exploit digne des plus grands films d'action :
- Seul au bout du pont de bois menant à Rome (le pont Sublicius), il bloque à lui tout seul l'armée ennemie entière !
- Pendant ce temps, ses camarades détruisent le pont à coups de hache derrière lui.
- Une fois le pont effondré, tout armé, il plonge dans le Tibre et regagne Rome à la nage sain et sauf !

💡 **Vocabulaire républicain** :
- **PONS** (génitif *pontis*) : le pont
- **MILES** (génitif *militis*) : le soldat
- **VIRTUS** : le courage, la vaillance guerrière""",
            "question": "Quel acte héroïque a accompli Horatius Coclès pour sauver Rome ?",
            "options": [
                "Il a retenu seul l'armée ennemie sur un pont pendant que ses compagnons le coupaient",
                "Il a tué le roi Porsenna dans sa tente",
                "Il a franchi les Alpes avec des éléphants",
                "Il a construit la muraille de Rome en une seule nuit"
            ],
            "answer": 0,
            "explanation": "Coclès est resté seul face à toute l'armée ennemie sur le pont Sublicius !",
        },
        {
            "id": "m11-02",
            "type": "puzzle",
            "title": "Mucius Scaevola et le brasier sacré",
            "content": """## Le courage face à la douleur
Un autre jeune héros romain, **Mucius**, s'introduit de nuit dans le camp ennemi pour éliminer le roi Porsenna. Par erreur, il tue le secrétaire du roi.

Arrêté et menacé de tortures par le feu, Mucius tend calmement sa main droite dans les flammes d'un brasier sans laisser échapper un seul cri, en disant :
*« Civis Romanus sum ! »* (Je suis citoyen romain ! Trois cents jeunes Romains comme moi ont juré ta mort).

Terrifié et admiratif devant un tel courage, le roi Porsenna le libère et fait la paix avec Rome. Ayant perdu l'usage de sa main droite brûlée, Mucius est surnommé **Scaevola** (« le gaucher »).

Reconstitue sa fière déclaration républicaine :""",
            "latin": "Civis Romanus sum.",
            "mots": ["Je suis", "citoyen", "romain.", "Le roi", "a peur", "du feu."],
            "solution": "Je suis citoyen romain.",
        },
        {
            "id": "m11-03",
            "type": "trou",
            "title": "Cloélie, la jeune fille indomptable",
            "content": """## L'héroïsme au féminin (Virgo fortis)
Pour garantir la paix, Rome doit livrer de jeunes otages, parmi lesquels une jeune fille nommée **Cloélie** (*Cloelia*).

Refusant d'être prisonnière, Cloélie trompe la surveillance des gardes, entraîne ses compagnes et traverse le fleuve Tibre à la nage sous une pluie de flèches pour revenir libre à Rome !

Le roi Porsenna, stupéfait, exige qu'on lui renvoie Cloélie... non pour la punir, mais pour lui offrir un cheval d'honneur et libérer la moitié des autres otages de son choix. Les Romains lui érigèrent une statue équestre sur la Voie Sacrée !

Complète la phrase latine pour dire : « La courageuse jeune fille traverse le fleuve » (*Cloelia fluvium transit*).""",
            "consigne": "Complète le verbe 'traverse' (transit) :",
            "avant": "Cloelia fluvium tran",
            "apres": ".",
            "solution": "sit",
            "latin_complet": "Cloelia fluvium transit.",
        },
        {
            "id": "m11-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Décurion Étrusque",
            "content": """## L'ultime barrage du pont Sublicius
Le décurion de Porsenna te barre la route du Tibre. Fais triompher les vertus républicaines pour remporter **50 Sesterces 🪙** !""",
            "boss": {"nom": "Le Décurion Étrusque", "icone": "🛡️", "pv": 3},
            "questions": [
                {
                    "question": "Que signifie la devise légendaire 'Civis Romanus sum' ?",
                    "options": ["Je suis citoyen romain", "Rome sera détruite", "Vive la République", "Le roi est vaincu"],
                    "answer": 0,
                    "explanation": "'Civis' = citoyen, 'Romanus' = romain, 'sum' = je suis."
                },
                {
                    "question": "Pourquoi Mucius a-t-il été surnommé 'Scaevola' ?",
                    "options": [
                        "Parce qu'il a brûlé sa main droite dans le brasier et est devenu gaucher",
                        "Parce qu'il combattait avec deux glaives",
                        "Parce qu'il courait très vite",
                        "Parce qu'il n'avait qu'un œil"
                    ],
                    "answer": 0,
                    "explanation": "Scaevola signifie 'le gaucher' en latin !"
                },
                {
                    "question": "Quel honneur exceptionnel les Romains ont-ils accordé à Cloélie ?",
                    "options": [
                        "Une statue équestre (à cheval) sur la Voie Sacrée",
                        "Une couronne impériale en diamant",
                        "Le commandement des légions",
                        "Un temple sur le Capitole"
                    ],
                    "answer": 0,
                    "explanation": "Une statue équestre, honneur jusqu'alors réservé aux plus grands généraux romains !"
                }
            ]
        }
    ]
}
