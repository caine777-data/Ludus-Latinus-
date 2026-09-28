"""
Monde 15 — Récits d'autrefois : L'Imparfait.
Morphologie de l'imparfait de l'indicatif (le suffixe régulier -ba-),
l'imparfait du verbe esse (eram, eras, erat...)
et les récits des origines chez l'historien Tite-Live.
"""

LEVEL = {
    "id": "monde15",
    "classe": "4eme",
    "title": "15 · Récits d'Autrefois : L'Imparfait 📜",
    "lessons": [
        {
            "id": "m15-01",
            "type": "quiz",
            "title": "Le Suffixe Magique de l'Imparfait : -BA-",
            "content": """## Raconter le passé en latin
En 5ème, tu as appris le Présent (*amo* = j'aime, *amas* = tu aimes, *amat* = il aime).

En 4ème, place aux temps du passé ! Et bonne nouvelle : l'**Imparfait** latin est le temps le plus simple et régulier de toute la langue latine !

Il se forme en insérant le son magique **-BA-** entre le radical et les désinences personnelles :
- *Amo* (j'aime) ➔ **ama-BA-m** (j'aimais)
- *Amas* (tu aimes) ➔ **ama-BA-s** (tu aimais)
- *Amat* (il aime) ➔ **ama-BA-t** (il aimait)
- *Amamus* (nous aimons) ➔ **ama-BA-mus** (nous aimions)
- *Amatis* (vous aimez) ➔ **ama-BA-tis** (vous aimiez)
- *Amant* (ils aiment) ➔ **ama-BA-nt** (ils aimaient)

💡 **Même règle pour les autres groupes** :
- *Legere* (lire) ➔ *legebam, legebas, legebat...* (je lisais, tu lisais, il lisait...)
- *Audire* (entendre) ➔ *audiebam, audiebas, audiebat...*""",
            "question": "Quel son caractéristique s'intercale dans TOUS les verbes réguliers à l'imparfait latin ?",
            "options": ["-BA- (ex: amabam, legebat)", "-VI-", "-IS-", "-UR-"],
            "answer": 0,
            "explanation": "Le suffixe -ba- est la marque universelle de l'imparfait régulier latin !",
        },
        {
            "id": "m15-02",
            "type": "trou",
            "title": "L'Imparfait du Verbe Être : Eram, Eras, Erat",
            "content": """## J'étais, tu étais, il était...
Le verbe être (*esse*) à l'imparfait est indispensable pour tous les récits de contes et d'histoire :

- **ERAM** : j'étais
- **ERAS** : tu étais
- **ERAT** : il/elle était (*➔ formule magique pour commencer un récit !*)
- Au pluriel, on ajoute à *era-* les terminaisons habituelles : **-mus** (nous), **-tis** (vous), **-nt** (ils, elles).

Exemple classique de Tite-Live :
*« Romulus primus rex Romae erat. »* = « Romulus était le premier roi de Rome. »

Complète pour dire : « Les élèves étaient à l'école » (*in schola*).""",
            "consigne": "Complète le verbe être : « ils étaient » :",
            "avant": "Discipuli in schola er",
            "apres": ".",
            "solution": "ant",
            "latin_complet": "Discipuli in schola erant.",
        },
        {
            "id": "m15-03",
            "type": "puzzle",
            "title": "Une Scène dans la Rome Républicaine",
            "content": """## L'animation sur le Forum
À l'époque de la République, les citoyens se réunissaient chaque matin pour écouter les orateurs et débattre des lois.

Exemple : *« Romani in foro conveniebant. »* = « Les Romains se rassemblaient sur le forum. »

À toi ! *Clamare* = crier. Présent ou imparfait ? Cherche le **-ba-** :""",
            "latin": "Romani in foro clamabant.",
            "mots": ["Les Romains", "criaient", "sur le forum.", "crient", "Le Romain"],
            "solution": "Les Romains criaient sur le forum.",
        },
        {
            "id": "m15-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : L'Historien Tite-Live",
            "content": """## L'épreuve du parchemin historique
Le grand historien de Rome, Tite-Live (*Titus Livius*), vérifie si tu sais raconter les hauts faits de la République. Réponds juste pour gagner **50 Sesterces 🪙** !""",
            "boss": {"nom": "Tite-Live l'Historien", "icone": "🖋️", "pv": 3},
            "questions": [
                {
                    "question": "Comment se traduit 'pugnabant' (verbe pugnare, combattre) ?",
                    "options": ["Ils combattaient", "Ils combattront", "Ils combattent", "Ils ont combattu"],
                    "answer": 0,
                    "explanation": "Pugna-ba-nt : suffixe -ba- + 3e personne du pluriel -nt = ils combattaient."
                },
                {
                    "question": "Quelle forme du verbe 'esse' signifie 'il était' ?",
                    "options": ["Erat", "Est", "Fuit", "Erit"],
                    "answer": 0,
                    "explanation": "Eram = j'étais, eras = tu étais, erat = il était."
                },
                {
                    "question": "Que signifie la phrase 'Pueri in schola legebant' ?",
                    "options": [
                        "Les enfants lisaient à l'école",
                        "Les enfants vont à l'école",
                        "Les enfants dorment dans la maison",
                        "Le maître punit les enfants"
                    ],
                    "answer": 0,
                    "explanation": "Pueri = les enfants, in schola = à l'école, legebant = lisaient."
                }
            ]
        }
    ]
}
