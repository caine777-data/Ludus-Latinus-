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
            "explications": [
                "",
                "La finale -us appartient aux adjectifs comme bonus, bona, bonum, qui suivent un autre modèle que fortis.",
                "-um est la finale de bonum, accusatif masculin ou neutre d'un autre modèle d'adjectifs, pas celle de fortis.",
                "Cette terminaison en -e est réservée au genre neutre (comme mare), or ce nom est masculin.",
            ],
            "explanation": "Au masculin singulier nominatif, l'adjectif est 'fortis' : miles fortis !",
            "grammaire": {
                "question": "Comment dit-on « une mère courageuse » ? (mater = la mère ; fortis, -e = courageux)",
                "options": ["Mater forta.", "Mater fortis.", "Mater forte.", "Mater fortus."],
                "answer": 1,
                "explications": [
                    "Cette fin est celle de bona, adjectif de 1re classe, qui ne se décline pas comme fortis.",
                    "",
                    "Cette fin sert pour un nom neutre.",
                    "Cette fin est celle du masculin des adjectifs comme bonus.",
                ],
            },
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

Applique la même règle à *ingens, ingentis* (immense), qui se décline comme *omnis*.
*Periculum, -i* (n.) = le danger ; au pluriel : *pericula*.
Complète pour dire : « Les soldats voient d'immenses dangers ».""",
            "consigne": "Accorde « immenses » avec pericula (neutre pluriel) :",
            "avant": "Milites ingent",
            "apres": " pericula vident.",
            "solution": "ia",
            "latin_complet": "Milites ingentia pericula vident.",
            "grammaire": {
                "question": "Complète pour dire « Les légionnaires portent de courts javelots » : Legionarii brev___ pila portant. (brevis, -e = court)",
                "options": ["-a", "-es", "-ium", "-ia"],
                "answer": 3,
                "explications": [
                    "Cette fin est celle d'adjectifs comme bonus, d'un autre modèle.",
                    "Cette fin va avec des noms masculins ou féminins au pluriel. Ici le nom est neutre.",
                    "Cette fin est celle du génitif pluriel, qui dit « de ».",
                    "",
                ],
            },
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

Exemple : *« Miles Romanus fortissimus est. »* = « Le soldat romain est le plus courageux. »

À toi ! Comparatif ou superlatif ? Regarde bien la terminaison :""",
            "latin": "Legio Romana fortior est.",
            "mots": ["La légion", "romaine", "est", "plus courageuse.", "la plus courageuse.", "Le soldat"],
            "solution": "La légion romaine est plus courageuse.",
            "grammaire": {
                "question": "Quelle phrase veut dire « La forêt est très haute » ? (silva = la forêt ; altus = haut)",
                "options": ["Silva altissima est.", "Silva altior est.", "Silva alta est.", "Silva altissimus est."],
                "answer": 0,
                "explications": [
                    "",
                    "Cette forme veut dire « plus haute » : elle compare avec une autre chose.",
                    "Cet adjectif n'a aucun suffixe : il dit seulement « haute ».",
                    "Cette fin est celle du masculin, or silva est féminin.",
                ],
            },
        },
        {
            "id": "m14-04",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : Le Centurion Vétéran",
            "content": """## L'épreuve tactique sur le champ de Mars
Le fier centurion de Scipion l'Africain évalue ta connaissance des légions. Réussis l'épreuve pour gagner une bourse de **sesterces 🪙** !""",
            "boss": {"nom": "Le Centurion Vétéran", "icone": "🎖️", "pv": 3},
            "questions": [
                {
                    "question": "Quel suffixe forme le comparatif de supériorité (ex: plus fort) en latin ?",
                    "options": ["-ior", "-issimus", "-illimus", "-errimus"],
                    "answer": 0,
                    "explanation": "Le comparatif se forme toujours avec le suffixe -ior (-ius au neutre) !"
                },
                {
                    "question": "Que signifie l'adjectif 'clarissimus' ?",
                    "options": ["Très célèbre", "Moins célèbre", "Aussi célèbre", "Plus célèbre"],
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
