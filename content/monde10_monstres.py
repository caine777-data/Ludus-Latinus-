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
            "explications": [
                "",
                "Cet être à tête de taureau a été vaincu par Thésée dans le labyrinthe de Crète.",
                "Cette créature posant des énigmes aux voyageurs a été défiée par Œdipe près de Thèbes.",
                "Ce monstre aquatique dont les têtes repoussaient a été combattu par Hercule à Lerne.",
            ],
            "explanation": "Exactement ! La Chimère fut vaincue d'en haut par les flèches de Bellérophon !",
            "grammaire": {
                "question": "Quelle phrase veut dire « Les amis aiment les chevaux » ?",
                "options": ["Equi amicos amant.", "Amici equum amant.", "Amicus equos amat.", "Amici equos amant."],
                "answer": 3,
                "explications": [
                    "Les rôles sont inversés : ici, ce sont les chevaux qui aiment.",
                    "Le COD est au singulier : la fin ne montre qu'un seul cheval.",
                    "Le sujet et le verbe sont au singulier, alors qu'il y a plusieurs amis.",
                    "",
                ],
            },
        },
        {
            "id": "m10-02",
            "type": "puzzle",
            "title": "Cerbère le Gardien des Enfers (Cerberus)",
            "content": """## Aux portes du royaume souterrain
Pour empêcher les âmes de s'enfuir et les vivants d'entrer sans permission, le dieu Pluton a placé un gardien terrible :
- **Cerberus** : Cerbère, le chien colossal à trois têtes.
- **Porta, -ae** : la porte. Au COD : *portam* (une porte) ou *portas* (plusieurs).
- **Custodire** : garder, surveiller (qui a donné « custode »).
- Exemple : *« Cerberus portas custodit. »* = « Cerbère garde les portes. »

Ce soir, une seule porte reste ouverte. Reconstitue la phrase :""",
            "latin": "Cerberus portam custodit.",
            "mots": ["Cerbère", "garde", "la porte.", "les portes.", "gardent", "dévore"],
            "solution": "Cerbère garde la porte.",
            "hints": ["Cerberus = Cerbère (sujet)", "portam : -am = un seul COD", "custodit : -t = il"],
            "grammaire": {
                "question": "Quelle phrase veut dire « Le chien garde les portes » ? (canis = le chien)",
                "options": ["Canis porta custodit.", "Canis portam custodit.", "Canis portae custodit.", "Canis portas custodit."],
                "answer": 3,
                "explications": [
                    "Porta a la fin d'un sujet, mais le chien est déjà le sujet.",
                    "La fin -am ne montre qu'une seule porte.",
                    "Cette fin n'est pas celle d'un COD.",
                    "",
                ],
            },
        },
        {
            "id": "m10-03",
            "type": "trou",
            "title": "Polyphème le Cyclope : l'Adjectif s'accorde",
            "content": """## L'évasion de la grotte !
En Sicile vit Polyphème, un Cyclope : un géant berger qui n'a qu'un œil, rond, au milieu du front. Ulysse et ses compagnons sont piégés dans sa caverne. Ulysse lui fait boire un vin très fort et lui dit s'appeler **Nemo** (« Personne ») !

## Bon, bonne : l'adjectif s'accorde
L'adjectif latin prend le genre, le nombre et le cas du nom qu'il accompagne. *Bonus* (bon) se décline comme *servus* au masculin et comme *rosa* au féminin :
- Sujet : amicus bon**us** = un bon ami ; puella bon**a** = une bonne jeune fille.
- COD : amicum bon**um** ; puellam bon**am**.

Il existe une troisième forme, *bonum*, pour les noms neutres : tu la verras en 4e.

À toi ! *Magnus, -a, -um* = grand, se décline comme *bonus* ; *spelunca, -ae* = la grotte.
Complète pour dire : « Ulysse voit une grande grotte ».""",
            "consigne": "Accorde « grande » avec speluncam :",
            "avant": "Ulixes speluncam magn",
            "apres": " videt.",
            "solution": "am",
            "latin_complet": "Ulixes speluncam magnam videt.",
            "grammaire": {
                "question": "Complète pour dire « La grande louve voit l'agneau » : Lupa magn___ agnum videt.",
                "options": ["-a", "-am", "-us", "-um"],
                "answer": 0,
                "explications": [
                    "",
                    "Le genre est bon, mais -m marque un COD. Ici, la louve est le sujet.",
                    "Cette fin est masculine, alors que lupa est féminin.",
                    "Cette fin est masculine et sert pour un COD.",
                ],
            },
        },
        {
            "id": "m10-04",
            "type": "puzzle",
            "title": "Les Six Cas : le Datif et l'Ablatif",
            "content": """## Les deux derniers cas
Tu connais déjà quatre cas : le nominatif (sujet), le vocatif (appel), l'accusatif (COD) et le génitif (« de qui ? »). Voici les deux derniers.

**Le DATIF : à qui ?** C'est le cas de celui qui reçoit.
- Noms en **-a** : puell**ae** = à la jeune fille.
- Noms en **-us** : serv**o** = à l'esclave.

Exemple : *Puella servo rosam dat.* = « La jeune fille donne une rose à l'esclave. »

**L'ABLATIF : où ? avec quoi ?** Tu l'emploies depuis le monde 2 sans le savoir : *in horto* (dans le jardin), *in silva* (dans la forêt).
- Noms en **-a** : in silv**a**.
- Noms en **-us** : in hort**o**.

Tu connais maintenant les six cas du latin !

À toi ! *Dat* = donne ; *gladius, -i* = le glaive ; *spelunca, -ae* = la grotte.""",
            "latin": "Ulixes amico gladium in spelunca dat.",
            "mots": ["Ulysse", "donne", "un glaive", "à l'ami", "dans la grotte.", "de l'ami", "des glaives"],
            "solution": "Ulysse donne un glaive à l'ami dans la grotte.",
            "grammaire": {
                "question": "Complète pour dire « Le maître donne de l'eau à la jeune fille » : Dominus aquam puell___ dat.",
                "options": ["-a", "-ae", "-am", "-o"],
                "answer": 1,
                "explications": [
                    "Cette fin ne marque pas celui qui reçoit. Ici, la jeune fille reçoit l'eau.",
                    "",
                    "Cette fin est celle du COD, qui subit l'action, pas de celui qui reçoit.",
                    "Cette fin va avec les noms en -us, pas avec les noms en -a.",
                ],
            },
        },
        {
            "id": "m10-05",
            "type": "arene",
            "title": "⚔️ Combat Suprême : Le Dragon Ladon des Hespérides",
            "content": """## L'ultime épreuve de l'Antiquité !
Le colossal dragon **Ladon**, qui ne dort jamais et garde les pommes d'or divines de l'immortalité, déploie ses ailes gigantesques !
Rassemble toute ta maîtrise du latin pour vaincre le Boss Suprême et empocher une bourse de **sesterces 🪙** !""",
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
                    "options": ["Un seul œil sur le front", "Trois têtes de serpent", "Cent bras et cinquante têtes", "Des cornes de taureau sauvage"],
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
                    "question": "Complète : « La jeune fille aime la grande rose ». Puella rosam ___ amat.",
                    "options": ["magnum", "magnus", "magnam", "magna"],
                    "answer": 2,
                    "explanation": "« Rosam » est un COD féminin singulier (-am). L'adjectif prend la même terminaison : « magnam ». « Magna » serait un sujet féminin."
                },
            ],
        },
    ],
}
