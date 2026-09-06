"""
Monde 10 — Monstres Fabuleux & Métamorphoses (Monstra & Fabulae).
Découverte des grandes créatures de la mythologie gréco-romaine (Pégase, Cerbère, Cyclope)
et combat ultime contre le Dragon cent-têtes Ladon des Hespérides !
"""

LEVEL = {
    "id": "monde10",
    "title": "10 · Monstres Fabuleux & Métamorphoses 🐉",
    "lessons": [
        {
            "id": "m10-01",
            "type": "quiz",
            "title": "Pégase le Cheval Ailé (Pegasus)",
            "content": """## Dans les airs avec les dieux !
Parmi les créatures les plus célèbres de l'Antiquité, **Pegasus** est le magnifique cheval ailé blanc :
- Il est né de l'écume marine et du sang de la Gorgone Méduse.
- D'un simple coup de sabot sur le mont Hélicon, il fit jaillir une source magique d'inspiration poétique (*l'Hippocrène*).
- Il aida le héros Bellérophon à vaincre la redoutable **Chimère** (créature crachant le feu, à tête de lion, corps de chèvre et queue de serpent).

💡 **Le savais-tu ?**
Après ses exploits, Jupiter plaça Pégase dans le ciel : il est devenu une brillante constellation d'étoiles visible les soirs d'automne !""",
            "question": "Quel monstre crachant le feu le héros Bellérophon a-t-il terrassé grâce à Pégase ?",
            "options": ["La Chimère", "Le Minotaure", "Le Sphinx", "L'Hydre"],
            "answer": 0,
            "explanation": "Exactement ! La Chimère fut vaincue d'en haut par les flèches de Bellérophon !",
        },
        {
            "id": "m10-02",
            "type": "puzzle",
            "title": "Cerbère le Gardien des Enfers (Cerberus)",
            "content": """## Aux portes du royaume souterrain
Pour empêcher les âmes de s'enfuir et les vivants d'entrer sans permission, le dieu Pluton a placé un gardien terrible :
- **Cerberus** : Cerbère, le chien colossal à trois têtes.
- **Portas** : les portes (à l'accusatif pluriel).
- **Custodit** : garde, surveille (du verbe *custodire* qui a donné « garde à vue » et « custode »).

Reconstitue la phrase :""",
            "latin": "Cerberus portas custodit.",
            "mots": ["Cerbère", "garde", "les portes.", "dévore", "la maison.", "le cheval"],
            "solution": "Cerbère garde les portes.",
            "hints": ["Cerberus = Cerbère", "portas = les portes", "custodit = garde"],
        },
        {
            "id": "m10-03",
            "type": "trou",
            "title": "Polyphème le Cyclope Géant (Cyclops)",
            "content": """## L'évasion de la grotte !
Sur l'île de Sicile vivait Polyphème, un géant berger féroce appartenant au peuple des **Cyclopes** :
- Il n'avait qu'un seul œil géant et rond au milieu du front.
- Ulysse et ses compagnons se retrouvèrent piégés dans sa caverne.
- Pour s'échapper, Ulysse fit boire au géant un vin doux très fort, puis le trompa en disant qu'il s'appelait **Nemo** (« Personne » en latin) !""",
            "consigne": "Complète le nom latin du géant à œil unique :",
            "phrase": "Le géant Polyphème appartient à la famille des {trou}.",
            "options": ["Cyclopes", "Centaures", "Sirènes", "Gladiateurs"],
            "solution": "Cyclopes",
            "reponse": "Cyclopes",
            "solution_complete": "Le géant Polyphème appartient à la famille des Cyclopes.",
            "explication": "Cyclops vient du grec signifiant 'œil rond' !",
        },
        {
            "id": "m10-04",
            "type": "decodeur",
            "title": "Le Décodeur des Héros",
            "content": """## Analyse le triomphe du héros antique !
Identifie chaque fonction grammaticale latine :
- 🟢 **Sujet** : Qui triomphe ?
- 🔵 **COD** : Quelle créature est vaincue ?
- 🔴 **Verbe** : L'action de terrasser (*superare*) !""",
            "phrase_latine": "Hercules monstrum superat",
            "mots_francais": ["Hercule", "le monstre", "vainc"],
            "roles": {0: "sujet", 1: "cod", 2: "verbe"},
        },
        {
            "id": "m10-05",
            "type": "arene",
            "title": "⚔️ Combat Suprême : Le Dragon Ladon des Hespérides",
            "content": """## L'ultime épreuve de l'Antiquité !
Le colossal dragon **Ladon**, qui ne dort jamais et garde les pommes d'or divines de l'immortalité, déploie ses ailes gigantesques !
Rassemble toute ta maîtrise du latin pour vaincre le Boss Suprême et empocher **100 Sesterces Royaux 🪙** !""",
            "boss": {"nom": "Le Dragon Ladon des Hespérides", "icone": "🐉", "pv": 4},
            "questions": [
                {
                    "question": "Comment s'appelle le chien à trois têtes qui garde les Enfers ?",
                    "options": ["Cerbère (Cerberus)", "Pégase (Pegasus)", "Ladon", "Polyphème"],
                    "answer": 0,
                    "explanation": "Bravo ! Cerbère aux trois têtes garde l'entrée des Enfers.",
                },
                {
                    "question": "Quelle particularité physique avaient les Cyclopes ?",
                    "options": ["Un seul œil au milieu du front", "Trois bras", "Des ailes de cire", "Une queue de poisson"],
                    "answer": 0,
                    "explanation": "Exactement ! Un seul grand œil rond !",
                },
                {
                    "question": "Quel nom signifiant 'Personne' Ulysse donna-t-il au Cyclope pour le tromper ?",
                    "options": ["Nemo", "Marcus", "Caesar", "Nihil"],
                    "answer": 0,
                    "explanation": "Oui ! 'Nemo' signifie 'Personne' en latin !",
                },
                {
                    "question": "Que protégeait le dragon Ladon dans le jardin des Hespérides ?",
                    "options": ["Les pommes d'or", "Le cheval ailé", "La toge pourpre", "Le labyrinthe"],
                    "answer": 0,
                    "explanation": "Triomphe absolu ! Ladon veillait sur les pommes d'or de l'immortalité !",
                },
            ],
        },
    ],
}
