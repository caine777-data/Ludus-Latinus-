"""
Monde 17 — César et la Guerre des Gaules.
Le futur simple de l'indicatif (amabo, legam),
les pronoms démonstratifs (is, ea, id)
et le grand affrontement entre César et Vercingétorix à Alésia (52 av. J.-C.).
"""

LEVEL = {
    "id": "monde17",
    "classe": "4eme",
    "title": "17 · César et la Guerre des Gaules 🏹",
    "lessons": [
        {
            "id": "m17-01",
            "type": "quiz",
            "title": "Le Futur de l'Indicatif : Amabo & Legam",
            "content": """## Ce qui arrivera demain !
Après le présent et les temps du passé, découvrons le **Futur** latin :

1. **Pour les 1ère et 2ème conjugaisons** (verbes en *-are* et *-ere*) :
   - On insère le son **-B- / -BI-** :
   - *Amabo* = j'aimerai
   - *Amabis* = tu aimeras
   - *Amabit* = il aimera
   - *Amabimus* = nous aimerons
   - *Amabitis* = vous aimerez
   - *Amabunt* = ils aimeront

2. **Pour le verbe être (*esse*)** :
   - *Ero* = je serai
   - *Eris* = tu seras
   - *Erit* = il sera
   - *Erimus* = nous serons
   - *Eritis* = vous serez
   - *Erunt* = ils seront""",
            "question": "Que signifie la forme 'amabit' au futur ?",
            "options": ["Il aimera", "Il aimait", "Il aima", "Qu'il aime"],
            "answer": 0,
            "explications": [
                "",
                "Cette traduction correspond au temps de la description (amabat), reconnaissable à son suffixe en -ba-.",
                "Cette traduction correspond au temps de l'action achevée (amavit), pas à ce temps à venir.",
                "Cette traduction exprime un souhait ou un ordre au subjonctif (amet), pas une certitude future.",
            ],
            "explanation": "Le suffixe -bi- avec le -t de 3e personne singulier indique le futur : il aimera !",
        },
        {
            "id": "m17-02",
            "type": "trou",
            "title": "Le Pronom Démonstratif : Is, Ea, Id",
            "content": """## Celui-ci, celle-ci, cela (ou il, elle)
En latin, pour désigner une personne ou un objet dont on vient de parler, on utilise le pronom démonstratif **is, ea, id** :

- Masculin singulier : **IS** (celui-ci / il)
- Féminin singulier : **EA** (celle-ci / elle)
- Neutre singulier : **ID** (cela / ce fait)

À l'accusatif (COD) :
- *Eum* = le / lui (masculin)
- *Eam* = la (féminin)
- *Id* = cela (neutre)

Exemple : *Caesar Vercingetorigem vincet ? Caesar eum vincet.* = « César le vaincra. »

À toi ! Il s'agit maintenant de la ville d'Alésia (*urbs*, féminin). Complète pour dire : « César la prendra ».""",
            "consigne": "Complète le pronom COD « la » (féminin) :",
            "avant": "Caesar ",
            "apres": " capiet.",
            "solution": "eam",
            "latin_complet": "Caesar eam capiet.",
        },
        {
            "id": "m17-03",
            "type": "puzzle",
            "title": "Le Siège d'Alésia (52 av. J.-C.)",
            "content": """## L'ultime résistance gauloise
Enfermé sur la colline d'Alésia avec 80 000 guerriers, le jeune chef arverne **Vercingétorix** unifie les tribus gauloises pour défendre leur indépendance.

César fait creuser une double ligne de fortifications géante tout autour de la ville.

Exemple : *« Galli pro libertate pugnabant. »* = « Les Gaulois combattaient pour la liberté. »

À toi ! Un seul guerrier, cette fois : regarde la fin du verbe.""",
            "latin": "Vercingetorix pro libertate pugnabat.",
            "mots": ["Vercingétorix", "combattait", "pour la liberté.", "combattaient", "César"],
            "solution": "Vercingétorix combattait pour la liberté.",
        },
        {
            "id": "m17-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : L'Aigle de la Xe Légion",
            "content": """## Face à l'élite des légionnaires de César
Le porte-enseigne (*aquilifer*) de la 10e Légion favorite de César t'attend. Triomphe pour remporter une bourse de **sesterces 🪙** !""",
            "boss": {"nom": "L'Aigle de César", "icone": "🦅", "pv": 3},
            "questions": [
                {
                    "question": "Quelle phrase veut dire « Les Romains combattront » ?",
                    "options": ["Romani pugnabant.", "Romani pugnabunt.", "Romani pugnaverunt.", "Romani pugnabit."],
                    "answer": 1,
                    "explanation": "Au futur, on insère -bu- devant -nt (comme « amabunt » = ils aimeront). « Pugnabant » = ils combattaient, « pugnaverunt » = ils ont combattu, « pugnabit » = il combattra (un seul sujet)."
                },
                {
                    "question": "Comment se traduit 'Cras in Gallia erimus' (cras = demain) ?",
                    "options": [
                        "Demain nous serons en Gaule",
                        "Hier nous étions en Gaule",
                        "Aujourd'hui nous combattons en Gaule",
                        "La Gaule est pacifiée"
                    ],
                    "answer": 0,
                    "explanation": "'Erimus' est la 1ère personne du pluriel du futur du verbe être : nous serons."
                },
                {
                    "question": "Où eut lieu la reddition de Vercingétorix en 52 av. J.-C. ?",
                    "options": ["À Alésia", "À Gergovie", "À Rome", "À Lutèce"],
                    "answer": 0,
                    "explanation": "Alésia est le lieu du siège légendaire qui scella la victoire de César."
                }
            ]
        }
    ]
}
