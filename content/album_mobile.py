"""Album « Héros et Créatures » de l'appli mobile : 32 cartes, chacune gagnée par un succès.

Les cartes partent de content/cartes_data.py (celles de l'appli bureau, inchangées) :
11 sujets qui doublaient une carte du Panthéon sont remplacés, et quelques textes
corrigés pour ne pas répéter une devise du Panthéon. Proposition de l'architecte du
17/10/2026, validée sur le principe par Cédric ; les textes restent à relire.
"""

from content.cartes_data import CARTES_COLLECTION

# Récompense en sesterces selon la rareté de la carte.
SESTERCES_PAR_RARETE = {"commune": 10, "rare": 20, "epique": 40, "legendaire": 80}

# Les 11 cartes qui doublaient le Panthéon, et leurs remplaçantes.
_REMPLACEES = {
    "div_jupiter", "div_neptune", "her_hercule", "her_vercingetorix", "her_pline",
    "her_ciceron", "her_virgile", "mon_pegase", "mon_cesar", "mon_auguste", "mon_via_appia",
}

_NOUVELLES = [
    {"id": "div_junon", "nom": "Junon", "nom_latin": "Iuno Regina", "categorie": "divinites",
     "rarete": "legendaire", "atk": 93, "def": 98,
     "citation": "Iuno Romam custodit.", "traduction": "Junon garde Rome.",
     "anecdote": "Reine des dieux et épouse de Jupiter. Ses oies sacrées, sur le Capitole, "
                 "donnèrent l'alerte une nuit où les Gaulois escaladaient la colline."},
    {"id": "div_vesta", "nom": "Vesta", "nom_latin": "Vesta Mater", "categorie": "divinites",
     "rarete": "rare", "atk": 78, "def": 90,
     "citation": "Ignis Vestae numquam exstinguitur.", "traduction": "Le feu de Vesta ne s'éteint jamais.",
     "anecdote": "Déesse du foyer de chaque maison et de Rome entière. Son temple rond, sur le "
                 "Forum, abritait un feu qui ne devait jamais s'éteindre."},
    {"id": "her_persee", "nom": "Persée", "nom_latin": "Perseus Gorgonis Victor", "categorie": "heros",
     "rarete": "commune", "atk": 84, "def": 80,
     "citation": "Perseus Medusam in clipeo videt.", "traduction": "Persée voit Méduse dans son bouclier.",
     "anecdote": "Fils de Jupiter, il vainquit Méduse sans croiser son regard, en guettant son "
                 "reflet dans un bouclier de bronze poli."},
    {"id": "her_brennus", "nom": "Brennus", "nom_latin": "Brennus Dux Gallorum", "categorie": "heros",
     "rarete": "epique", "atk": 91, "def": 86,
     "citation": "Vae victis !", "traduction": "Malheur aux vaincus !",
     "anecdote": "Chef gaulois qui prit Rome vers 390 av. J.-C. Quand les Romains contestèrent "
                 "le poids de la rançon, il jeta son épée dans la balance."},
    {"id": "her_pline_jeune", "nom": "Pline le Jeune", "nom_latin": "Caius Plinius Caecilius Secundus",
     "categorie": "heros", "rarete": "epique", "atk": 80, "def": 88,
     "citation": "Nubes ex monte oriebatur.", "traduction": "Un nuage s'élevait de la montagne.",
     "anecdote": "À 17 ans, il vit l'éruption du Vésuve depuis Misène et la raconta dans deux "
                 "lettres à l'historien Tacite."},
    {"id": "her_caton", "nom": "Caton l'Ancien", "nom_latin": "Marcus Porcius Cato", "categorie": "heros",
     "rarete": "epique", "atk": 86, "def": 91,
     "citation": "Carthago delenda est.", "traduction": "Il faut détruire Carthage.",
     "anecdote": "Sénateur austère qui terminait chacun de ses discours en réclamant la "
                 "destruction de Carthage, la grande rivale de Rome."},
    {"id": "her_ovide", "nom": "Ovide", "nom_latin": "Publius Ovidius Naso", "categorie": "heros",
     "rarete": "epique", "atk": 83, "def": 86,
     "citation": "Omnia mutantur.", "traduction": "Tout change.",
     "anecdote": "Poète des Métamorphoses, où il raconte plus de deux cents légendes, dont le "
                 "vol de Dédale et d'Icare."},
    {"id": "mon_centaure", "nom": "Le Centaure", "nom_latin": "Centaurus Velox", "categorie": "monstres",
     "rarete": "commune", "atk": 80, "def": 76,
     "citation": "Centaurus celerius vento currit.", "traduction": "Le centaure court plus vite que le vent.",
     "anecdote": "Moitié homme, moitié cheval. Le sage centaure Chiron fut le maître d'Achille "
                 "et de nombreux héros."},
    {"id": "mon_sceau", "nom": "Le Sceau impérial", "nom_latin": "Signum Imperatoris", "categorie": "monuments",
     "rarete": "legendaire", "atk": 88, "def": 97,
     "citation": "Signum fidem facit.", "traduction": "Le sceau garantit la confiance.",
     "anecdote": "Les Romains scellaient tablettes et lettres avec un anneau gravé : un sceau "
                 "brisé prouvait que le message avait été ouvert."},
    {"id": "mon_roma", "nom": "Roma Aeterna", "nom_latin": "Urbs Aeterna", "categorie": "monuments",
     "rarete": "legendaire", "atk": 99, "def": 99,
     "citation": "Roma caput mundi.", "traduction": "Rome, capitale du monde.",
     "anecdote": "Les Romains appelaient leur ville l'Urbs, « la Ville ». Bâtie sur sept "
                 "collines, elle comptait près d'un million d'habitants sous Auguste."},
    {"id": "mon_borne", "nom": "La Borne milliaire", "nom_latin": "Miliarium", "categorie": "monuments",
     "rarete": "commune", "atk": 70, "def": 90,
     "citation": "Lapis viam metitur.", "traduction": "La pierre mesure la route.",
     "anecdote": "Tous les mille pas, soit environ 1,5 km, une colonne de pierre indiquait aux "
                 "voyageurs la distance jusqu'à Rome."},
]

# Corrections des cartes conservées : rareté selon le succès, devises qui doublaient
# le Panthéon, chiffre aligné sur la leçon m6-02, anecdote de Julia sur les Vestales.
_CORRECTIONS = {
    "her_romulus": {"rarete": "commune"},
    "her_enee": {"citation": "Sum pius Aeneas.", "traduction": "Je suis le pieux Énée."},
    "div_apollon": {"citation": "Apollo lyra canit.", "traduction": "Apollon chante avec sa lyre."},
    "mon_circus": {"anecdote": "L'hippodrome géant de Rome, où plus de 150 000 spectateurs "
                               "vibraient au passage des chars lancés à pleine vitesse."},
    "her_julia": {"anecdote": "Choisie enfant, une Vestale servait trente ans la déesse Vesta : "
                              "elle gardait le feu sacré et les testaments confiés au temple."},
}

# Traductions des devises conservées (la carte bureau n'en a pas).
_TRADUCTIONS = {
    "div_minerve": "La sagesse et le courage l'emportent.",
    "div_mars": "Si tu veux la paix, prépare la guerre.",
    "div_mercure": "Il vole rapidement à travers les airs.",
    "mon_cerbere": "Trois gueules, une seule garde.",
    "mon_meduse": "Regarde, et tu seras pierre.",
    "mon_minotaure": "Il mugit dans les ténèbres du labyrinthe.",
    "mon_lion": "Une peau qu'aucune arme ne peut percer.",
    "mon_sphinx": "Résous l'énigme, ou tu périras.",
    "her_romulus": "Ici naît la Rome éternelle.",
    "her_ulysse": "Plus par l'intelligence que par la force.",
    "her_achille": "Une mort rapide, une gloire éternelle.",
    "her_julia": "La fortune sourit aux audacieux.",
    "mon_colisee": "Tant que le Colisée est debout, Rome est debout.",
    "mon_scutum": "Dans le bouclier la confiance, dans le glaive le courage.",
    "mon_circus": "Du pain et des jeux.",
    "mon_aqueduc": "L'eau, vie de la cité.",
    "her_scipion": "Par le courage et la constance, nous vaincrons.",
    "her_hannibal": "Je trouverai un chemin, ou j'en ferai un.",
    "her_horace": "Cueille le jour, et ne crois pas au lendemain.",
}

# Succès : identifiant de la carte gagnée, statistique suivie, seuil, texte affiché.
# Les statistiques sont calculées par l'appli (voir docs/propositions/succes_et_cartes.md).
SUCCES_ALBUM = [
    # Héros : la progression dans les leçons.
    {"carte": "her_romulus", "stat": "monde_termine:1", "seuil": 1, "texte": "Terminer le monde 1"},
    {"carte": "her_julia", "stat": "monde_termine:2", "seuil": 1, "texte": "Terminer le monde 2"},
    {"carte": "her_persee", "stat": "monde_termine:3", "seuil": 1, "texte": "Terminer le monde 3"},
    {"carte": "her_ulysse", "stat": "monde_termine:10", "seuil": 1, "texte": "Terminer le monde 10"},
    {"carte": "her_horace", "stat": "lecons_reussies", "seuil": 50, "texte": "Réussir 50 leçons"},
    {"carte": "her_achille", "stat": "lecons_trois_etoiles", "seuil": 30, "texte": "Réussir 30 leçons avec 3 étoiles"},
    {"carte": "her_enee", "stat": "classe_terminee:5eme", "seuil": 1, "texte": "Terminer toute la 5e"},
    {"carte": "her_scipion", "stat": "monde_termine:13", "seuil": 1, "texte": "Terminer le monde 13"},
    {"carte": "her_brennus", "stat": "monde_termine:17", "seuil": 1, "texte": "Terminer le monde 17"},
    {"carte": "her_pline_jeune", "stat": "monde_termine:21", "seuil": 1, "texte": "Terminer le monde 21"},
    {"carte": "her_caton", "stat": "monde_termine:23", "seuil": 1, "texte": "Terminer le monde 23"},
    {"carte": "her_ovide", "stat": "monde_termine:25", "seuil": 1, "texte": "Terminer le monde 25"},
    {"carte": "her_hannibal", "stat": "classe_terminee:4eme", "seuil": 1, "texte": "Terminer toute la 4e"},
    # Dieux : la régularité.
    {"carte": "div_apollon", "stat": "serie_jours", "seuil": 3, "texte": "Jouer 3 jours de suite"},
    {"carte": "div_mercure", "stat": "marche_operations", "seuil": 10, "texte": "Réussir 10 opérations au Marché de Trajan"},
    {"carte": "div_vesta", "stat": "quetes_du_jour", "seuil": 10, "texte": "Accomplir 10 quêtes du jour"},
    {"carte": "div_mars", "stat": "gladiateurs_vaincus", "seuil": 5, "texte": "Vaincre les 5 gladiateurs du Duel"},
    {"carte": "div_minerve", "stat": "memoria_maitrises", "seuil": 20, "texte": "Maîtriser 20 mots dans Memoria"},
    {"carte": "div_junon", "stat": "serie_jours", "seuil": 30, "texte": "Jouer 30 jours de suite"},
    # Créatures : les jeux.
    {"carte": "mon_centaure", "stat": "courses_finies", "seuil": 1, "texte": "Finir une course au Circus"},
    {"carte": "mon_sphinx", "stat": "missions_cesar", "seuil": 1, "texte": "Résoudre une énigme de l'Atelier de César"},
    {"carte": "mon_lion", "stat": "gladiateurs_vaincus", "seuil": 1, "texte": "Vaincre Crixus, le premier gladiateur"},
    {"carte": "mon_minotaure", "stat": "epigraphes", "seuil": 3, "texte": "Déchiffrer 3 inscriptions"},
    {"carte": "mon_meduse", "stat": "duels_sans_faute", "seuil": 1, "texte": "Gagner un duel sans aucune faute"},
    {"carte": "mon_cerbere", "stat": "taverne_victoires", "seuil": 10, "texte": "Gagner 10 parties à la Taverne"},
    # Monuments : Rome et ses richesses.
    {"carte": "mon_borne", "stat": "lecons_reussies", "seuil": 5, "texte": "Réussir 5 leçons"},
    {"carte": "mon_scutum", "stat": "objets_achetes", "seuil": 1, "texte": "Acheter un objet à la Taberna"},
    {"carte": "mon_aqueduc", "stat": "monuments_restaures", "seuil": 1, "texte": "Restaurer un monument du Forum"},
    {"carte": "mon_circus", "stat": "courses_gagnees", "seuil": 5, "texte": "Gagner 5 courses au Circus"},
    {"carte": "mon_colisee", "stat": "duels_gagnes", "seuil": 10, "texte": "Gagner 10 duels"},
    {"carte": "mon_sceau", "stat": "missions_cesar_toutes", "seuil": 1, "texte": "Réussir toutes les missions de César"},
    {"carte": "mon_roma", "stat": "mondes_termines", "seuil": 26, "texte": "Terminer les 26 mondes"},
]


def _construire_cartes():
    cartes = []
    for carte in CARTES_COLLECTION:
        if carte["id"] in _REMPLACEES:
            continue
        copie = {k: v for k, v in carte.items() if k != "img"}  # img : portraits de boss, sans rapport
        copie.update(_CORRECTIONS.get(carte["id"], {}))
        if "traduction" not in copie:
            copie["traduction"] = _TRADUCTIONS[carte["id"]]
        cartes.append(copie)
    cartes.extend(_NOUVELLES)
    for carte in cartes:
        carte["image"] = f"assets/images/album/{carte['id']}.jpg"
    return cartes


ALBUM_CARTES = _construire_cartes()
