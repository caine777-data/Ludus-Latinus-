"""
Monde 25 — L'Or des Poètes : L'Énéide & Les Métamorphoses.
Les grands chefs-d'œuvre de la poésie augustéenne :
Virgile et l'épopée fondatrice d'Énée (Arma virumque cano),
Ovide et les fables des Métamorphoses (Dédale & Icare),
et le subjonctif de souhait (optatif).
"""

LEVEL = {
    "id": "monde25",
    "classe": "3eme",
    "title": "25 · L'Or des Poètes : Virgile & Ovide 📜",
    "lessons": [
        {
            "id": "m25-01",
            "type": "quiz",
            "title": "L'Énéide de Virgile : Le Chant des Armes et du Héros",
            "content": """## Le poème national de Rome
Commandée par l'empereur Auguste pour célébrer les origines divines de Rome, l'**Énéide** est le plus grand chef-d'œuvre poétique de l'Antiquité romaine.

Elle raconte l'histoire du prince troyen **Énée** (*Aeneas*), fils de la déesse Vénus, qui fuit Troie en flammes en portant son vieux père Anchise sur ses épaules et tenant son jeune fils Iule par la main.

Après un long voyage maritime plein de périls à travers la Méditerranée, Énée aborde en Italie pour y fonder la lignée qui donnera naissance à Rome.

Les tout premiers mots de l'Énéide, appris par cœur par tous les écoliers de l'Empire :
*« **Arma virumque cano**... »*
(« Je chante les armes et le héros... »).""",
            "question": "Quel poète romain a composé l'Énéide sous le règne d'Auguste ?",
            "options": ["Virgile (Publius Vergilius Maro)", "Ovide", "Homère", "Cicéron"],
            "answer": 0,
            "explanation": "C'est le poète Virgile qui a écrit les 12 chants de l'Énéide !",
        },
        {
            "id": "m25-02",
            "type": "trou",
            "title": "Dédale et Icare chez Ovide",
            "content": """## Les Métamorphoses d'Ovide
L'autre géant de la poésie romaine est **Ovide** (*Ovidius*). Dans ses *Métamorphoses*, il raconte 250 mythes de transformations divines.

L'un des plus émouvants est celui de **Dédale et Icare** :
Pour s'échapper du labyrinthe de Crète, l'ingénieux Dédale fabrique des ailes de plumes collées avec de la cire d'abeille. Mais le jeune Icare, enivré par le vol, monte trop près du Soleil. La cire fond et il tombe dans la mer...

Complète la formule de souhait au subjonctif : « Que tu sois heureux ! » (*Felix sis !*).""",
            "consigne": "Complète le verbe être au subjonctif 'que tu sois' (sis) :",
            "avant": "Felix ",
            "apres": " !",
            "solution": "sis",
            "latin_complet": "Felix sis !",
        },
        {
            "id": "m25-03",
            "type": "puzzle",
            "title": "Le Vers Immortel de Virgile",
            "content": """## La musique des mots
Reconstitue l'ouverture légendaire de l'Énéide :
*« Arma virumque cano. »*
*(Arma = les armes [Neutre pl.], virumque = et le héros [Acc. + que = et], cano = je chante)*""",
            "latin": "Arma virumque cano.",
            "mots": ["Je chante", "les armes", "et le héros.", "Rome", "naîtra", "de Troie."],
            "solution": "Je chante les armes et le héros.",
        },
        {
            "id": "m25-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : La Muse Calliope",
            "content": """## Au sommet du Mont Parnasse
Calliope, muse protectrice de la poésie épique et de l'éloquence, teste ta sensibilité littéraire. Triomphe pour remporter **50 Sesterces 🪙** !""",
            "boss": {"nom": "La Muse Calliope", "icone": "✨", "pv": 3},
            "questions": [
                {
                    "question": "Qui était le héros troyen fondateur dont Virgile chante les aventures dans l'Énéide ?",
                    "options": ["Énée (Aeneas)", "Achille", "Ulysse", "Romulus"],
                    "answer": 0,
                    "explanation": "Énée est le héros troyen dont les descendants fonderont Rome."
                },
                {
                    "question": "Quel poète a écrit les Métamorphoses et l'Art d'Aimer ?",
                    "options": ["Ovide", "Horace", "César", "Sénèque"],
                    "answer": 0,
                    "explanation": "Ovide est l'auteur des fabuleuses Métamorphoses."
                },
                {
                    "question": "Que signifie la particule attachée '-que' dans 'virumque' ?",
                    "options": ["Et ('virumque' = et l'homme / le héros)", "Non", "Mais", "Si"],
                    "answer": 0,
                    "explanation": "Le suffixe enclitique -que signifie 'et' (comme dans SPQR : Senatus Populus-que)."
                }
            ]
        }
    ]
}
