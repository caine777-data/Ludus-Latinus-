"""
Monde 14 — Les Légions en Marche.
Les adjectifs de 2ème classe (fortis, ingens) calqués sur la 3ème déclinaison,
les degrés de l'adjectif (comparatif en -ior, superlatif en -issimus)
et les réformes militaires de la République (Scipion, Marius).
"""

LEVEL = {
    "id": "monde14",
    "classe": "4eme",
    "title": "14 · Les Légions en Marche 🦅",
    "lessons": [
        {
            "id": "m14-01",
            "type": "quiz",
            "title": "Les Adjectifs de 2ème Classe : Fortis et Ingens",
            "content": """## Comment qualifier les guerriers romains ?
En 5ème, tu as appris les adjectifs de 1ère classe (*bonus, bona, bonum*), qui se déclinent comme *dominus* et *rosa*.

En 4ème, voici les **adjectifs de 2ème classe** : ils suivent le modèle de la **3ème déclinaison** !

Le modèle le plus célèbre est **fortis, fortis, forte** (courageux, fort) :
- Masculin & Féminin : **fortis** (ex: *miles fortis* = le soldat courageux)
- Neutre : **forte** (ex: *bellum forte* = une guerre rude)

Autre exemple très fréquent :
- **Ingens, ingentis** : immense, gigantesque
- **Omnis, omnis, omne** : tout, chaque (*➔ omniscient, omnivore*)
- **Sapiens, sapientis** : sage, intelligent""",
            "question": "Comment s'accorde l'adjectif 'fortis' avec 'miles' (soldat, masculin singulier) ?",
            "options": ["Miles fortis", "Miles fortus", "Miles fortum", "Miles forte"],
            "answer": 0,
            "explanation": "Au masculin singulier nominatif, l'adjectif est 'fortis' : miles fortis !",
        },
        {
            "id": "m14-02",
            "type": "trou",
            "title": "Le Neutre des Adjectifs : Mare Ingens",
            "content": """## Accorder au neutre
Rappelle-toi la règle des neutres : au nominatif et à l'accusatif, ils ont la même forme.

Pour un adjectif de 2ème classe comme *omnis* (tout) :
- Au neutre singulier : **omne**
- Au neutre pluriel : **omnia** (*« Tout »*)

Exemple : *Omnia vincit amor* = « L'amour triomphe de tout » (citation célèbre de Virgile).

Complète la phrase pour dire : « Le général voit un immense péril » (*Dux ingens periculum videt*).""",
            "consigne": "Complète l'adjectif 'immense' (ingens) au neutre :",
            "avant": "Dux in",
            "apres": " periculum videt.",
            "solution": "gens",
            "latin_complet": "Dux ingens periculum videt.",
        },
        {
            "id": "m14-03",
            "type": "puzzle",
            "title": "Plus fort, le plus fort : Comparatif & Superlatif",
            "content": """## Les Degrés de l'Adjectif 🚀
En latin, pour comparer deux personnes ou désigner le meilleur, c'est très régulier et élégant :

1. **Le Comparatif de supériorité** (« plus courageux ») :
   - On ajoute le suffixe **-IOR** (m./f.) et **-IUS** (n.) au radical.
   - *fortis* ➔ **fortior** (plus courageux)
   - *altus* ➔ **altior** (plus haut)

2. **Le Superlatif** (« le plus courageux », « très courageux ») :
   - On ajoute **-ISSIMUS, -A, -UM**.
   - *fortis* ➔ **fortissimus** (le plus courageux / très courageux)
   - *clarus* ➔ **clarissimus** (très célèbre)

Reconstitue cette devise de gloire romaine :
*« Miles Romanus fortissimus est. »*""",
            "latin": "Miles Romanus fortissimus est.",
            "mots": ["Le soldat", "romain", "est", "le plus courageux.", "Le chef", "ordonne."],
            "solution": "Le soldat romain est le plus courageux.",
        },
        {
            "id": "m14-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Centurion Vétéran",
            "content": """## L'épreuve tactique sur le champ de Mars
Le fier centurion de Scipion l'Africain évalue ta connaissance des légions. Réussis l'épreuve pour gagner **50 Sesterces 🪙** !""",
            "boss": {"nom": "Le Centurion Vétéran", "icone": "🎖️", "pv": 3},
            "questions": [
                {
                    "question": "Quel suffixe forme le comparatif de supériorité (ex: plus fort) en latin ?",
                    "options": ["-IOR (ex: fortior)", "-ISSIMUS", "-UM", "-IS"],
                    "answer": 0,
                    "explanation": "Le comparatif se forme toujours avec le suffixe -ior (-ius au neutre) !"
                },
                {
                    "question": "Que signifie l'adjectif 'clarissimus' ?",
                    "options": [
                        "Le plus célèbre / très célèbre",
                        "Moins clair",
                        "Un peu célèbre",
                        "Pas célèbre du tout"
                    ],
                    "answer": 0,
                    "explanation": "Le superlatif en -issimus exprime le très haut degré d'une qualité."
                },
                {
                    "question": "Comment se traduit la célèbre maxime 'Omnia vincit amor' ?",
                    "options": [
                        "L'amour triomphe de tout",
                        "Tous les hommes aiment la victoire",
                        "L'amour est toujours vaincu",
                        "La victoire apporte l'amour"
                    ],
                    "answer": 0,
                    "explanation": "'Omnia' = toutes choses / tout, 'vincit' = vainc / triomphe, 'amor' = l'amour."
                }
            ]
        }
    ]
}
