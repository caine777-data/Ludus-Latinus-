"""
Monde 1 — Salve ! Premiers pas à Rome.
Découverte de l'alphabet, de la prononciation, des salutations,
des chiffres romains et de la légende de Romulus et Rémus.
"""

LEVEL = {
    "id": "monde1",
    "title": "1 · Salve ! Premiers pas à Rome 🏛️",
    "lessons": [
        {
            "id": "m1-01",
            "type": "quiz",
            "title": "L'Alphabet secret des Romains",
            "content": """## Bienvenue dans la Rome Antique !

Tu viens de traverser le temps et tu arrives au cœur de **Rome**, la capitale du plus vaste empire de l'Antiquité.

Pour te faire comprendre des Romains, il faut percer les secrets de leur écriture.

## Le savais-tu ? 💡
L'alphabet latin est l'ancêtre direct de notre alphabet français ! Pourtant, à l'époque de Jules César :
- Il n'y avait **pas de J ni de W**.
- La lettre **V** s'écrivait comme un V mais se prononçait toujours **[OU]** ou **[W]** ! Par exemple, le mot *villa* se prononçait *« ouilla »*.
- La lettre **C** se prononçait **toujours [K]**, jamais [S] ! On disait *« Késar »* et non « César ».

📌 **À retenir** : Les Romains écrivaient presque tout en lettres capitales sur la pierre, sans espaces entre les mots ! Heureusement, nous allons utiliser des espaces pour faciliter ta lecture.""",
            "question": "Comment les Romains prononçaient-ils la lettre C dans le mot 'Circus' ?",
            "options": ["Toujours [K] : 'Kirkous'", "Toujours [S] : 'Sirsus'", "Comme un [CH] : 'Chirchus'", "Elle était muette"],
            "answer": 0,
            "explanation": "Exactement ! En latin classique, le C claque toujours comme un [K] !",
        },
        {
            "id": "m1-02",
            "type": "puzzle",
            "title": "Saluer comme un Romain",
            "content": """## Dire bonjour et au revoir

Dans la rue à Rome, tu croises un citoyen en toge. Comment le saluer poliment ?

- **SALVE !** *(se prononce « Sal-oué »)* : « Bonjour ! / Salut ! » à une personne.
- **SALVETE !** : « Bonjour ! » à plusieurs personnes.
- **VALE !** *(se prononce « Oua-lé »)* : « Au revoir ! / Porte-toi bien ! »
- **AMICUS** : l'ami (au vocatif pour l'appeler : *amice*, « ô ami »).

💡 **Le savais-tu ?**
*Salve* vient d'un verbe qui signifie « être en bonne santé ». Quand un Romain te dit *Salve*, il te souhaite littéralement d'être en pleine forme !""",
            "latin": "Salve, amice !",
            "mots": ["Bonjour,", "ami !", "Au revoir,", "ennemi,", "le soldat"],
            "solution": "Bonjour, ami !",
        },
        {
            "id": "m1-03",
            "type": "trou",
            "title": "Se présenter : Comment t'appelles-tu ?",
            "content": """## Quis es ? (Qui es-tu ?)

Un garde de la légion romaine s'approche et te demande ton identité :
- *« Quis es ? »* = « Qui es-tu ? »
- *« Nomen mihi est Marcus. »* = « Mon nom est Marcus » (littéralement : *Le nom pour moi est Marcus*).

📌 **La règle d'or** :
En latin, pour dire « je suis », on utilise le petit mot magique **SUM** !
Exemple : *Discipulus sum* = « Je suis un élève ».

Complète la phrase pour dire : « Je suis romain » (*Romanus sum*).""",
            "consigne": "Complète le mot pour dire 'Je suis' (sum) :",
            "avant": "Romanus ",
            "apres": ".",
            "solution": "sum",
            "latin_complet": "Romanus sum.",
        },
        {
            "id": "m1-04",
            "type": "quiz",
            "title": "Les Chiffres Romains Mystérieux",
            "content": """## Décoder les nombres romains

Pas de 0, 1, 2, 3 à Rome ! Les Romains comptaient avec des lettres majuscules inspirées des doigts de la main :

- **I** = 1 (un doigt levé)
- **V** = 5 (la main ouverte formant un V entre le pouce et les doigts)
- **X** = 10 (deux mains croisées en X)
- **L** = 50
- **C** = 100 (*Centum*)
- **M** = 1000 (*Mille*)

💡 **Règle magique** :
- Une lettre placée **après** s'ajoute : **VI** = 5 + 1 = **6** ; **XII** = 10 + 2 = **12**.
- Une lettre placée **avant** se soustrait : **IV** = 5 - 1 = **4** ; **IX** = 10 - 1 = **9**.""",
            "question": "Combien vaut le nombre romain XIV ?",
            "options": ["16", "14", "24", "11"],
            "answer": 1,
            "explanation": "Bravo ! X vaut 10 et IV vaut 4 (5 - 1), donc 10 + 4 = 14 !",
        },
        {
            "id": "m1-05",
            "type": "puzzle",
            "title": "La Légende : Romulus, Rémus et la Louve",
            "content": """## Comment Rome est-elle née ?

Selon la légende la plus célèbre de l'Antiquité, en **753 avant J.-C.**, deux jumeaux royaux, **Romulus et Rémus**, sont jetés dans un panier sur le fleuve Tibre par un oncle cruel.

Miracle ! Le panier s'échoue au pied d'un figuier sauvage. Une louve (*Lupa*) entend leurs pleurs, les prend en pitié et les allaite dans sa grotte sacrée du mont Palatin.

Reconstitue cette phrase légendaire :
*« Lupa pueros curat. »*
*(Lupa = la louve, pueros = les enfants, curat = soigne / prend soin de)*""",
            "latin": "Lupa pueros curat.",
            "mots": ["La louve", "prend soin", "des enfants.", "Le lion", "chasse", "au bois."],
            "solution": "La louve prend soin des enfants.",
        },
        {
            "id": "m1-06",
            "type": "arene",
            "title": "⚔️ Défi de l'Arène : L'Épreuve de Mercure",
            "content": """## Le messager des dieux te met au défi !

Mercure (*Mercurius*), reconnaissable à son casque et ses sandales ailées, bloque le passage vers le Forum !

Pour prouver ta valeur et gagner l'accès au cœur de Rome ainsi qu'une bourse de **50 Sesterces 🪙**, réponds à ses questions sans faillir !""",
            "boss": {"nom": "Mercure aux sandales ailées", "icone": "🪽", "pv": 3},
            "questions": [
                {
                    "question": "Que veut dire 'Vale' quand tu quittes un ami romain ?",
                    "options": ["Bonjour", "Au revoir / Porte-toi bien", "Merci", "À l'aide"],
                    "answer": 1,
                    "explanation": "Vale signifie 'porte-toi bien / au revoir'."
                },
                {
                    "question": "Comment s'écrit le chiffre 9 en chiffres romains ?",
                    "options": ["VIIII", "IX", "XI", "VIV"],
                    "answer": 1,
                    "explanation": "9 s'écrit IX (10 moins 1)."
                },
                {
                    "question": "Quel animal a sauvé Romulus et Rémus du fleuve ?",
                    "options": ["Une biche", "Une louve (Lupa)", "Une aigle", "Un dauphin"],
                    "answer": 1,
                    "explanation": "C'est bien la louve Lupa qui les a allaités !"
                }
            ]
        }
    ]
}
