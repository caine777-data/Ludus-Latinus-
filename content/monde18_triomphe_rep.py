"""
Monde 18 — Le Grand Triomphe de la République (Fin du Programme de 4ème).
Grand défi récapitulatif de tout le cycle de 4ème : 3ème déclinaison,
adjectifs de 2ème classe, temps du passé (imparfait, parfait) et futur.
La fin de la République, les Ides de Mars (44 av. J.-C.) et remise du Brevet de 4ème.
"""

LEVEL = {
    "id": "monde18",
    "classe": "4eme",
    "title": "18 · Le Grand Triomphe de la République 👑",
    "lessons": [
        {
            "id": "m18-01",
            "type": "quiz",
            "title": "La Fin de la République et les Ides de Mars",
            "content": """## Le destin tragique de Jules César
Devenu maître incontesté de Rome après ses victoires en Gaule et lors de la guerre civile contre Pompée, Jules César est nommé **dictateur à vie** en 44 av. J.-C.

Craignant le retour d'un roi et la mort définitive de la République, un groupe de sénateurs menés par Brutus et Cassius conspire contre lui.

Le **15 mars 44 av. J.-C.** (les célèbres *Ides de Mars*), au Sénat, César tombe sous 23 coups de poignard. Ses derniers mots pour son fils adoptif Brutus résonnent encore :
*« Tu quoque, mi fili ! »* (« Toi aussi, mon fils ! »).

Mais loin de sauver la République, cet assassinat déclenche de nouvelles guerres civiles dont émergera le premier empereur de Rome : **Octave Auguste** !""",
            "question": "Que signifient les derniers mots attribués à César : 'Tu quoque, mi fili' ?",
            "options": [
                "Toi aussi, mon fils !",
                "Tue-les tous, mon fils !",
                "Adieu, peuple de Rome !",
                "La République est sauvée !"
            ],
            "answer": 0,
            "explanation": "Tu = toi, quoque = aussi, mi fili = mon fils (au vocatif) !",
        },
        {
            "id": "m18-02",
            "type": "trou",
            "title": "Le Grand Défi Grammatical de 4ème",
            "content": """## Mets à l'épreuve tes connaissances de 4ème !
Pour prouver que tu as assimilé la 3ème déclinaison et le Parfait :

Complète la phrase latine :
« Les braves soldats ont défendu la patrie. »
*(Fortes milites patriam defenderunt)*.

- *Milites* = les soldats (Nom. pl. 3e déclinaison)
- *Fortes* = courageux (Adjectif 2e classe, Nom. pl.)
- *Defenderunt* = ont défendu (Verbe au parfait, 3e personne du pluriel en -erunt)""",
            "consigne": "Complète le verbe 'ont défendu' au parfait (-erunt) :",
            "avant": "Fortes milites patriam defend",
            "apres": ".",
            "solution": "erunt",
            "latin_complet": "Fortes milites patriam defenderunt.",
        },
        {
            "id": "m18-03",
            "type": "puzzle",
            "title": "Proclamation Républicaine",
            "content": """## L'écho des siècles
Reconstitue cette noble maxime républicaine qui résume tout l'honneur des citoyens romains de 4ème :

*« Virtus et sapientia rem publicam servant. »*
*(Virtus = le courage [3e décl.], sapientia = la sagesse [1re décl.], rem publicam = la république [Acc.], servant = sauvent)*""",
            "latin": "Virtus et sapientia rem publicam servant.",
            "mots": ["Le courage", "et la sagesse", "sauvent", "la république.", "Le tyran", "s'enfuit."],
            "solution": "Le courage et la sagesse sauvent la république.",
        },
        {
            "id": "m18-04",
            "type": "arene",
            "title": "👑 Épreuve Finale de 4ème : Le Consul Suprême",
            "content": """## L'épreuve suprême du Capitole
Le grand consul de la République romaine monte les marches du temple de Jupiter Capitolin. Réponds sans faute pour décrocher le **Grand Diplôme de 4ème** et **100 Sesterces 🪙** !""",
            "boss": {"nom": "Le Consul Suprême", "icone": "🏛️", "pv": 3},
            "questions": [
                {
                    "question": "Quel cas de la 3ème déclinaison possède toujours la désinence -IS au singulier ?",
                    "options": ["Le Génitif (complément du nom)", "L'Accusatif (COD)", "Le Datif (COI)", "L'Ablatif"],
                    "answer": 0,
                    "explanation": "Le génitif singulier en -is est l'indicateur universel de la 3e déclinaison !"
                },
                {
                    "question": "Parmi ces verbes, lequel est à l'imparfait ?",
                    "options": ["Pugnabat (il combattait)", "Pugnavit (il combattit)", "Pugnat (il combat)", "Pugnabit (il combattra)"],
                    "answer": 0,
                    "explanation": "Le suffixe -ba- caractérise l'imparfait : pugna-ba-t."
                },
                {
                    "question": "Quel grand chef a unifié la Gaule face à César en 52 av. J.-C. ?",
                    "options": ["Vercingétorix", "Astérix", "Brennus", "Clovis"],
                    "answer": 0,
                    "explanation": "Vercingétorix, chef des Arvernes, mena la coalition gauloise à Alésia !"
                }
            ]
        }
    ]
}
