"""
Monde 3 — Les Dieux de l'Olympe & les Métamorphoses.
Jupiter, Minerve, Neptune, Mars, les mythes de Midas, d'Icare
et le regard de Méduse la Gorgone.
"""

LEVEL = {
    "id": "monde3",
    "title": "3 · Les Dieux de l'Olympe & Légendes ⚡",
    "lessons": [
        {
            "id": "m3-01",
            "type": "quiz",
            "title": "Le Panthéon Romain : Les Maîtres du Ciel et des Mers",
            "content": """## Qui règne sur le monde antique ?

Les Romains vénéraient douze grands dieux (*les dieux olympiens*). Leurs noms ont d'ailleurs donné les noms des planètes de notre système solaire !

- **JUPITER** (*Zeus chez les Grecs*) : Le roi des dieux, maître de la foudre et du tonnerre. Son symbole est l'aigle majestueux.
- **NEPTUNE** (*Poséidon*) : Dieu des océans et des tempêtes, armé d'un trident et chevauchant les vagues.
- **MARS** (*Arès*) : Dieu de la guerre, protecteur sacré de Rome (père légendaire de Romulus et Rémus !).
- **MINERVE** (*Athéna*) : Déesse de la sagesse, des arts et de la stratégie militaire. Son symbole est la chouette.
- **VÉNUS** (*Aphrodite*) : Déesse de la beauté et de l'amour.""",
            "question": "Quel dieu romain brandit le trident et commande aux océans ?",
            "options": ["Jupiter", "Neptune", "Mars", "Vulcain"],
            "answer": 1,
            "explications": [
                "Ce souverain des dieux commande au ciel et lance la foudre depuis le mont Capitole.",
                "",
                "Ce protecteur des légions porte le casque et la lance : il règne sur la guerre.",
                "Ce forgeron divin travaille le métal dans le feu des volcans avec son marteau.",
            ],
            "explanation": "C'est Neptune, dieu des mers et des séismes avec son trident !",
            "grammaire": {
                "question": "Que veut dire « Mars legit. » ?",
                "options": ["Mars écrit.", "Moi, j'écris.", "Moi, je lis.", "Mars lit."],
                "answer": 3,
                "explications": [
                    "Tu as confondu lire et écrire : relis les deux verbes de la leçon de l'école.",
                    "Double erreur : le verbe n'est pas le bon et le -t ne désigne pas celui qui parle.",
                    "Le verbe est bon, mais le -t ne désigne pas celui qui parle.",
                    "",
                ],
            },
        },
        {
            "id": "m3-02",
            "type": "puzzle",
            "title": "Le Roi Midas et le toucher d'or",
            "content": """## Le vœu dangereux du roi Midas

Le roi Midas rendit service au dieu Bacchus. Pour le remercier, le dieu lui accorda un souhait. Midas, très avide, demanda :
*« Que tout ce que je touche se transforme en or pur ! »*

Au début, il était fou de joie. Mais catastrophe : dès qu'il touchait du pain ou de l'eau, ils se transformaient en blocs d'or dur ! Il risquait de mourir de faim et supplia le dieu d'annuler ce sortilège.

Exemple : *« Midas aurum amat. »* = « Midas aime l'or. »

Mais après le sortilège, affamé, il ne rêve plus que d'une chose…
*(panis, -is = le pain ; aqua, -ae = l'eau)*

Traduis sa nouvelle envie :""",
            "latin": "Midas panem amat.",
            "mots": ["Midas", "aime", "le pain.", "l'or.", "l'eau.", "déteste"],
            "solution": "Midas aime le pain.",
            "grammaire": {
                "question": "Midas parle de lui-même. Comment dit-il « J'aime l'or » ? (aurum = l'or, amare = aimer)",
                "options": ["Aurum amat.", "Aurum scribo.", "Aurum amo.", "Aurum legit."],
                "answer": 2,
                "explications": [
                    "Le -t désigne une autre personne que celui qui parle.",
                    "La terminaison -o est bonne, mais ce verbe ne veut pas dire « aimer ».",
                    "",
                    "Ce verbe n'est pas le bon, et son -t désigne une autre personne que celui qui parle.",
                ],
            },
        },
        {
            "id": "m3-03",
            "type": "trou",
            "title": "Le Vol d'Icare (Les ailes de cire)",
            "content": """## Ne vole pas trop près du soleil !

Prisonniers du labyrinthe de Crète, l'ingénieux Dédale et son jeune fils **Icare** fabriquent des ailes géantes avec des plumes d'oiseaux collées avec de la cire d'abeille.

Avant de s'envoler, le père prévient son fils :
*« Ne vole ni trop bas près de la mer (l'eau mouillerait les plumes), ni trop haut près du soleil (la chaleur ferait fondre la cire) ! »*

Mais enivré par la magie du vol, Icare monte de plus en plus haut vers le soleil... La cire fond et il tombe dans la mer.

🔎 **Enquête** : le mot latin pour « soleil » se cache dans « **sol**aire », « para**sol** » et « **sol**stice ».""",
            "consigne": "Retrouve le mot latin « soleil » grâce aux mots français :",
            "avant": "Icarus ad ",
            "apres": "em volat (Icare vole vers le soleil).",
            "solution": "sol",
            "latin_complet": "Icarus ad solem volat.",
            "grammaire": {
                "question": "Icare quitte son père Dédale, seul, et lui dit au revoir. Que dit-il ? (valete = au revoir à plusieurs personnes)",
                "options": ["Salve !", "Vale !", "Salvete !", "Valete !"],
                "answer": 1,
                "explications": [
                    "Ce mot sert à dire bonjour, pas à partir.",
                    "",
                    "Ce mot dit bonjour à plusieurs personnes : ni le bon moment, ni le bon nombre.",
                    "Cet au revoir s'adresse à plusieurs personnes, mais Dédale est seul.",
                ],
            },
        },
        {
            "id": "m3-04",
            "type": "quiz",
            "title": "Méduse la Gorgone et le bouclier miroir",
            "content": """## Le monstre aux cheveux de serpents

**Méduse** était une créature terrifiante dont la chevelure grouillait de serpents venimeux. Quiconque croisait son regard était instantanément changé en statue de pierre !

Comment le héros **Persée** a-t-il réussi à la vaincre sans la regarder en face ?
Il a utilisé son bouclier de bronze poli comme un miroir, observant le reflet du monstre pour la décapiter d'un coup net d'épée !

Il offrit ensuite la tête de Méduse à la déesse Minerve, qui la fixa sur sa cuirasse magique (*l'égide*) pour terrifier ses ennemis.""",
            "question": "Quelle était l'arme secrète de Persée pour vaincre Méduse sans croiser ses yeux ?",
            "options": ["Un bandeau sur les yeux", "Un bouclier miroir poli", "Une cape d'invisibilité", "Une flèche empoisonnée"],
            "answer": 1,
            "explications": [
                "Aveuglé de la sorte, le héros n'aurait pas pu porter un coup d'épée précis au monstre.",
                "",
                "Persée avait bien un casque d'invisibilité, mais il ne le protégeait pas du regard pétrifiant de Méduse.",
                "Une flèche ne protège pas du regard pétrifiant. Persée devait approcher Méduse de près, pas la viser de loin.",
            ],
            "explanation": "Exactement ! Son bouclier servait de miroir magique pour voir le monstre sans être pétrifié.",
            "grammaire": {
                "question": "Minerve dit « Je suis une déesse ». Quelle phrase latine est correcte ? (dea = la déesse)",
                "options": ["Dea sum.", "Dea est.", "Dea vale.", "Dea salve."],
                "answer": 0,
                "explications": [
                    "",
                    "Cette forme s'emploie pour « il » ou « elle », pas pour celui qui parle de lui.",
                    "Ce mot sert à dire au revoir. Il n'exprime pas ce que l'on est.",
                    "Ce mot sert à dire bonjour. Il n'exprime pas ce que l'on est.",
                ],
            },
        },
        {
            "id": "m3-05",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Minotaure du Labyrinthe",
            "content": """## Au fond du labyrinthe de Crète !

Le féroce Minotaure, créature au corps d'homme et à tête de taureau, garde la sortie du labyrinthe !

Retrouve ton chemin grâce au fil d'Ariane et triomphe du monstre pour gagner une bourse de **sesterces 🪙** !""",
            "boss": {"nom": "Le Minotaure de Crète", "icone": "🐂", "pv": 3},
            "questions": [
                {
                    "question": "Quelle phrase veut dire « Midas lit » ?",
                    "options": ["Midas lego.", "Midas scribit.", "Midas legit.", "Midas sum."],
                    "answer": 2,
                    "explanation": "« legit » = il lit (-t = il ou elle). « Lego » = je lis, « scribit » = il écrit."
                },
                {
                    "question": "Pourquoi les ailes d'Icare ont-elles fondu ?",
                    "options": ["Il a volé trop près du soleil", "Il a traversé un violent orage", "La foudre a embrasé ses plumes", "Le vent glacial a brisé la cire"],
                    "answer": 0,
                    "explanation": "La cire tenant les plumes a fondu sous la chaleur du soleil !"
                },
                {
                    "question": "En quoi Méduse transformait-elle ceux qui croisaient son regard ?",
                    "options": ["En arbres morts", "En piliers de sel", "En statues de pierre", "En blocs de bronze"],
                    "answer": 2,
                    "explanation": "Son regard pétrifiait instantanément en pierre !"
                }
            ]
        }
    ]
}
