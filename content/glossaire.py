"""Glossaire latin : termes essentiels, vocabulaire et civilisation romaine."""

GLOSSAIRE_FR = [
    ("Accusatif", "Le cas qui indique le Complément d'Objet Direct (COD). Se termine souvent par -M au singulier (ex. : rosam, agnum)."),
    ("Amicus", "L'ami en latin (donne 'amical' en français)."),
    ("Aqua", "L'eau (donne 'aquatique', 'aquarium', 'aqueduc')."),
    ("Atrium", "La grande pièce centrale d'accueil d'une maison romaine, éclairée par le toit."),
    ("Canis", "Le chien. 'Cave canem' = Attention au chien !"),
    ("Cas", "La terminaison d'un mot qui indique son rôle dans la phrase (Sujet, COD...)."),
    ("Colisée", "Le grand amphithéâtre de Rome dédié aux combats de gladiateurs et spectacles."),
    ("Déclinaison", "La famille de terminaisons que prend un nom selon sa fonction."),
    ("Domus", "La maison romaine d'une famille aisée."),
    ("Equus", "Le cheval (donne 'équitation', 'équestre')."),
    ("Familia", "L'ensemble de la maisonnée romaine : parents, enfants et serviteurs."),
    ("Gladius", "Le glaive court à deux tranchants des soldats et gladiateurs."),
    ("Lupa", "La louve (célèbre pour avoir nourri Romulus et Rémus)."),
    ("Mater", "La mère (donne 'maternel', 'maternité')."),
    ("Mirmillon", "Gladiateur équipé d'un grand bouclier (scutum) et d'un casque à crête de poisson."),
    ("Nominatif", "Le cas qui indique le Sujet (le maître de l'action)."),
    ("Pater", "Le père (donne 'paternel', 'patrimoine')."),
    ("Quadrige", "Un char de course antique tiré par quatre chevaux au galop."),
    ("Rétiaire", "Gladiateur agile combattant avec un filet plombé et un grand trident."),
    ("Salve", "La formule de salutation romaine : 'Bonjour !' ou 'Salut !'"),
    ("Sesterce", "La monnaie en bronze ou argent utilisée dans toute la Rome antique."),
    ("Sum", "Le verbe être à la première personne : 'Je suis'."),
    ("Triclinium", "La salle à manger romaine où les convives mangeaient allongés sur des banquettes."),
    ("Vale", "La formule d'adieu romaine : 'Au revoir !' ou 'Porte-toi bien !'"),
]

GLOSSAIRE_EN = GLOSSAIRE_FR  # L'application est centrée sur le français pour le collégien

GLOSSAIRE = GLOSSAIRE_FR


def get_glossaire(lang="fr"):
    return GLOSSAIRE_FR
