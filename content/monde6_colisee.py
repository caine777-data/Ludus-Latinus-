"""
Monde 6 — Les Gladiateurs & le Colisée.
Les types de gladiateurs (Rétiaire, Mirmillon), les courses de chars
au Circus Maximus, le serment des combattants et l'épreuve de l'Arène.
"""

LEVEL = {
    "id": "monde6",
    "title": "6 · Les Gladiateurs & le Colisée 🛡️",
    "lessons": [
        {
            "id": "m6-01",
            "type": "quiz",
            "title": "Les Rois de l'Arène : Rétiaires et Mirmillons",
            "content": """## Dans les coulisses de l'amphithéâtre

Au Colisée (*Amphitheatrum Flavium*), 50 000 spectateurs retiennent leur souffle.

Les gladiateurs ne combattaient pas avec les mêmes armes, c'était un duel de styles :
1. **LE RÉTIAIRE** (*Retiarius*) : Vêtu d'un simple pagne, il est rapide et agile. Ses armes sont un **filet plombé** (*rete*) pour emprisonner son adversaire, un grand **trident** et un poignard.
2. **LE MIRMILLON** (*Murmillo*) : Un gladiateur lourdement protégé avec un grand bouclier rectangulaire (*scutum*), un glaive et un casque imposant orné d'un poisson.
3. **LE THRACE** (*Thraex*) : Armé d'un poignard à lame courbée (*sica*) et d'un petit bouclier rond.

💡 **Le savais-tu ?**
La plupart des gladiateurs étaient de véritables stars très populaires à Rome, avec leurs portraits peints sur les murs de la ville !""",
            "question": "Quelle arme redoutable caractérise le gladiateur Rétiaire ?",
            "options": ["Un arc géant", "Un filet et un trident", "Une massue de fer", "Deux longues haches"],
            "answer": 1,
            "explanation": "Le Rétiaire combat avec son filet (rete) et son trident !",
        },
        {
            "id": "m6-02",
            "type": "puzzle",
            "title": "Les Courses de Chars au Circus Maximus",
            "content": """## Plus rapide que le vent : Le Quadrige !

Le plus grand stade de Rome n'était pas le Colisée, mais le **Circus Maximus** (plus de 150 000 places !).

Les cochers (*auriges*) pilotaient des chars tirés par 4 chevaux au galop : le **QUADRIGE** (*quadriga*). Il fallait faire 7 tours de piste à toute vitesse en frôlant les bornes de virage (*metae*) où les accidents spectaculaires étaient fréquents !

Reconstitue cette clameur de la foule :
*« Equi celeriter currunt. »*
*(Equi = les chevaux, celeriter = rapidement, currunt = courent)*""",
            "latin": "Equi celeriter currunt.",
            "mots": ["Les chevaux", "courent", "rapidement.", "Les chars", "s'arrêtent", "au virage."],
            "solution": "Les chevaux courent rapidement.",
        },
        {
            "id": "m6-03",
            "type": "trou",
            "title": "Le Salut Historique : Ave Caesar !",
            "content": """## Devant la loge impériale

Avant d'entamer les combats, les gladiateurs défilaient en toge chamarrée devant la tribune de l'empereur, levaient le bras droit et clamaient la devise immortelle :

*« AVE CAESAR, MORITURI TE SALUTANT ! »*
*(Salut César, ceux qui vont mourir te saluent !)*

- **AVE** = Salut / Sois le bienvenu
- **SALUTANT** = ils saluent (verbe se terminant par **-nt**)

Complète la phrase pour dire « Salut César » :""",
            "consigne": "Complète le mot de salutation (Ave) :",
            "avant": "",
            "apres": " Caesar !",
            "solution": "Ave",
            "latin_complet": "Ave Caesar !",
        },
        {
            "id": "m6-04",
            "type": "arene",
            "title": "⚔️ Combat d'Arène Ultime : Le Champion du Colisée",
            "content": """## Le Maître de l'Arène s'avance !

Maximus, le gladiateur mirmillon invaincu depuis 20 combats, se dresse au centre de la piste de sable doré.

Démontre toute ta science du latin et tes réflexes pour décrocher la palme de victoire et empocher **50 Sesterces 🪙** !""",
            "boss": {"nom": "Maximus le Mirmillon du Colisée", "icone": "🛡️", "pv": 4},
            "questions": [
                {
                    "question": "Quel gladiateur se bat avec un grand bouclier et un casque à crête ?",
                    "options": ["Le Mirmillon", "Le Rétiaire", "Le Chariot", "L'Archer"],
                    "answer": 0,
                    "explanation": "C'est le Mirmillon, le guerrier cuirassé !"
                },
                {
                    "question": "Comment s'appelle un char tiré par quatre chevaux ?",
                    "options": ["Un bige", "Un quadrige", "Une calèche", "Un fiacre"],
                    "answer": 1,
                    "explanation": "Un quadrige (de quadri- = quatre et jumentum) !"
                },
                {
                    "question": "Dans le Circus Maximus, combien de spectateurs pouvaient prendre place ?",
                    "options": ["Environ 5 000", "Plus de 150 000", "Environ 20 000", "500 personnes"],
                    "answer": 1,
                    "explanation": "Le Circus Maximus accueillait plus de 150 000 spectateurs romains !"
                },
                {
                    "question": "Que veut dire la formule : 'Ave Caesar' ?",
                    "options": ["Gare à César", "Salut à toi, César !", "Adieu César", "Victoire à César"],
                    "answer": 1,
                    "explanation": "Ave Caesar = Salut César !"
                }
            ]
        }
    ]
}
