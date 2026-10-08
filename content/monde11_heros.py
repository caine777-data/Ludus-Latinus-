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
            "options": ["Il a défendu seul le pont du Tibre contre l'armée ennemie", "Il a pénétré seul dans le camp ennemi pour frapper le roi", "Il a incendié la flotte ennemie sur le Tibre", "Il a gardé les portes de la ville pendant la fuite du peuple"],
            "answer": 0,
            "explications": [
                "",
                "C'est l'audace de Mucius Scaevola, qui s'est glissé dans le camp de Porsenna pour tuer le roi.",
                "Aucun navire n'est brûlé dans ce récit : relis ce que fait Horatius face à l'armée de Porsenna.",
                "Les récits ne parlent d'aucune porte de la ville : ce n'est pas le lieu de l'exploit d'Horatius.",
            ],
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

Ses trois cents compagnons pourraient tous répondre au pluriel. Traduis leur réponse :""",
            "latin": "Cives Romani sumus.",
            "mots": ["Nous sommes", "citoyens", "romains.", "Je suis", "citoyen", "romain."],
            "solution": "Nous sommes citoyens romains.",
        },
        {
            "id": "m11-03",
            "type": "trou",
            "title": "Cloélie, la jeune fille indomptable",
            "content": """## L'héroïsme au féminin (Virgo fortis)
Pour garantir la paix, Rome doit livrer de jeunes otages, parmi lesquels une jeune fille nommée **Cloélie** (*Cloelia*).

Refusant d'être prisonnière, Cloélie trompe la surveillance des gardes, entraîne ses compagnes et traverse le fleuve Tibre à la nage sous une pluie de flèches pour revenir libre à Rome !

Le roi Porsenna, stupéfait, exige qu'on lui renvoie Cloélie... non pour la punir, mais pour lui offrir un cheval d'honneur et libérer la moitié des autres otages de son choix. Les Romains lui érigèrent une statue équestre sur la Voie Sacrée !

*Transire* = traverser ; *fluvius, -i* = le fleuve.
Complète la phrase latine pour dire : « Cloélie traverse le fleuve ».""",
            "consigne": "Complète le verbe « traverse » (il ou elle fait l'action) :",
            "avant": "Cloelia fluvium trans",
            "apres": ".",
            "solution": "it",
            "latin_complet": "Cloelia fluvium transit.",
        },
        {
            "id": "m11-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Décurion Étrusque",
            "content": """## L'ultime barrage du pont Sublicius
Le décurion de Porsenna te barre la route du Tibre. Fais triompher les vertus républicaines pour remporter une bourse de **sesterces 🪙** !""",
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
                    "options": ["Il a laissé brûler sa main droite dans le feu et est devenu le Gaucher", "Il a combattu deux généraux ennemis à la fois avec son seul glaive", "Il a perdu son œil gauche lors du siège de la ville par Porsenna", "Il a brisé ses chaînes de prisonnier sans l'aide d'aucun soldat"],
                    "answer": 0,
                    "explanation": "Scaevola signifie 'le gaucher' en latin !"
                },
                {
                    "question": "Quel honneur exceptionnel les Romains ont-ils accordé à Cloélie ?",
                    "options": ["Une statue équestre sur la Voie Sacrée", "Une couronne triomphale de lauriers d'or", "Le droit de siéger au Sénat avec les pères", "Un monument de marbre blanc sur le Forum"],
                    "answer": 0,
                    "explanation": "Une statue équestre, honneur jusqu'alors réservé aux plus grands généraux romains !"
                }
            ]
        }
    ]
}
