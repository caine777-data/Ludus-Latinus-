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
            "options": ["Virgile", "Ovide", "Horace", "Lucrèce"],
            "answer": 0,
            "explications": [
                "",
                "Cet auteur a composé les Métamorphoses et L'Art d'aimer, pas cette grande épopée nationale.",
                "Horace, poète du temps d'Auguste, a écrit des Odes et des Satires, pas l'Énéide.",
                "Lucrèce est mort avant le règne d'Auguste et il a écrit De la nature, pas l'Énéide.",
            ],
            "explanation": "C'est le poète Virgile qui a écrit les 12 chants de l'Énéide !",
            "grammaire": {
                "question": "Que veut dire « Urbe condita, Romulus rex fuit. » ? (condere = fonder ; rex = le roi)",
                "options": [
                    "Dans la ville fondée, Romulus fut roi.",
                    "Romulus fonda la ville et fut roi.",
                    "Romulus fut roi de la ville fondée.",
                    "La ville ayant été fondée, Romulus fut roi.",
                ],
                "answer": 3,
                "explications": [
                    "Pour dire « dans », il faudrait la préposition in. Elle manque ici.",
                    "Le seul verbe conjugué est fuit, « il fut ». Le verbe fonder n'y est pas conjugué.",
                    "Pour dire « de la ville », il faudrait un génitif, et urbe n'en est pas un.",
                    "",
                ],
            },
        },
        {
            "id": "m25-02",
            "type": "trou",
            "title": "Dédale et Icare chez Ovide",
            "content": """## Les Métamorphoses d'Ovide
L'autre géant de la poésie romaine est **Ovide** (*Ovidius*). Dans ses *Métamorphoses*, il raconte 250 mythes de transformations divines.

L'un des plus émouvants est celui de **Dédale et Icare** :
Pour s'échapper du labyrinthe de Crète, l'ingénieux Dédale fabrique des ailes de plumes collées avec de la cire d'abeille. Mais le jeune Icare, enivré par le vol, monte trop près du Soleil. La cire fond et il tombe dans la mer...

Pour exprimer un souhait, le latin emploie le subjonctif. Celui du verbe *esse* se forme sur **si-**, suivi des terminaisons habituelles (-m, -s, -t, -mus, -tis, -nt) :
*Felix sis !* = « Que tu sois heureux ! »

À toi ! *Poeta, -ae* (m.) = le poète.
Complète pour dire : « Que le poète soit heureux ! ».""",
            "consigne": "Complète le subjonctif de esse à la 3e personne du singulier :",
            "avant": "Felix s",
            "apres": " poeta !",
            "solution": "it",
            "latin_complet": "Felix sit poeta !",
            "grammaire": {
                "question": "Complète pour dire « Que je sois heureux ! » : Felix ___ !",
                "options": ["sum", "sis", "sim", "sit"],
                "answer": 2,
                "explications": [
                    "Cette forme est de l'indicatif : elle dit un fait, elle n'exprime pas un souhait.",
                    "Cette forme s'adresse à « tu », pas à celui qui parle.",
                    "",
                    "Cette forme parle d'une 3e personne, pas de « je ».",
                ],
            },
        },
        {
            "id": "m25-03",
            "type": "puzzle",
            "title": "Le Vers Immortel de Virgile",
            "content": """## La musique des mots
L'ouverture légendaire de l'Énéide : *« Arma virumque cano. »* = « Je chante les armes et le héros. »
Le petit mot **-que**, collé à la fin d'un mot, signifie « et » : *virumque* = *et virum*.

À toi ! Regarde bien les terminaisons.
*Poeta, -ae* (m.) = le poète ; *patria, -ae* = la patrie ; *vir, viri* = l'homme, le héros ; *cano, -is, -ere* = chanter.""",
            "latin": "Poeta patriam virosque canit.",
            "mots": ["Le poète", "chante", "la patrie", "et les héros.", "et le héros.", "chantent"],
            "solution": "Le poète chante la patrie et les héros.",
            "grammaire": {
                "question": "Que veut dire « Puellae puerique rosas amant. » ? (pueri = les enfants)",
                "options": [
                    "Les roses aiment les jeunes filles et les enfants.",
                    "Les jeunes filles des enfants aiment les roses.",
                    "La jeune fille ou l'enfant aime les roses.",
                    "Les jeunes filles et les enfants aiment les roses.",
                ],
                "answer": 3,
                "explications": [
                    "Rosas porte la fin du COD : les roses subissent l'action, elles ne la font pas.",
                    "Le -que ajouté au mot n'exprime pas un complément du nom.",
                    "Le petit mot -que ne propose pas un choix entre deux noms.",
                    "",
                ],
            },
        },
        {
            "id": "m25-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : La Muse Calliope",
            "content": """## Au sommet du Mont Parnasse
Calliope, muse protectrice de la poésie épique et de l'éloquence, teste ta sensibilité littéraire. Triomphe pour remporter une bourse de **sesterces 🪙** !""",
            "boss": {"nom": "La Muse Calliope", "icone": "✨", "pv": 3},
            "questions": [
                {
                    "question": "Qui était le héros troyen fondateur dont Virgile chante les aventures dans l'Énéide ?",
                    "options": ["Énée", "Hector", "Priam", "Pâris"],
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
                    "options": ["Et", "Ou", "Mais", "Car"],
                    "answer": 0,
                    "explanation": "Le suffixe enclitique -que signifie 'et' (comme dans virumque)."
                }
            ]
        }
    ]
}
