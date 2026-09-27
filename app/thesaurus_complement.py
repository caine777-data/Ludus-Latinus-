"""
Vocabulaire complémentaire du Thesaurus, rangé par monde de la Via Appia.

Chaque entrée indique le monde où le mot est rencontré (« monde ») : l'appli
mobile s'en sert pour fabriquer les exercices de vocabulaire de chaque leçon.
Les mots déjà présents dans DICTIONNAIRE_LATIN n'y sont pas répétés.
"""

VOCABULAIRE_COMPLEMENTAIRE = [
    # Monde 1 · Salve ! Premiers pas à Rome
    {"latin": "salve / salvete", "cat": "Invariable", "genre": "formule de salut", "fr": "bonjour (à une / à plusieurs personnes)", "etym": "salut, salutation", "ex": "Salve, magister !", "ex_fr": "Bonjour, maître !", "monde": "monde1"},
    {"latin": "vale / valete", "cat": "Invariable", "genre": "formule d'adieu", "fr": "au revoir, porte-toi bien", "etym": "valide, valeur", "ex": "Vale, amice !", "ex_fr": "Au revoir, mon ami !", "monde": "monde1"},
    {"latin": "magister, -tri", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "le maître d'école", "etym": "magistral, magistrat, maître", "ex": "Magister pueros docet.", "ex_fr": "Le maître instruit les enfants.", "monde": "monde1"},
    {"latin": "Roma, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "Rome", "etym": "romain, roman", "ex": "Roma in Italia est.", "ex_fr": "Rome est en Italie.", "monde": "monde1"},
    {"latin": "via, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la route, la rue", "etym": "voie, viaduc, via", "ex": "Via Appia longa est.", "ex_fr": "La voie Appienne est longue.", "monde": "monde1"},

    # Monde 2 · Dans la maison romaine
    {"latin": "filius, -i", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "le fils", "etym": "filial, filiation, fils", "ex": "Filius patrem amat.", "ex_fr": "Le fils aime son père.", "monde": "monde2"},
    {"latin": "filia, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la fille", "etym": "filiale, fille", "ex": "Filia matrem iuvat.", "ex_fr": "La fille aide sa mère.", "monde": "monde2"},
    {"latin": "frater, -tris", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le frère", "etym": "fraternel, fraternité", "ex": "Romulus et Remus fratres sunt.", "ex_fr": "Romulus et Rémus sont frères.", "monde": "monde2"},
    {"latin": "soror, -oris", "cat": "Nom", "genre": "fém. 3e décl.", "fr": "la sœur", "etym": "sororité", "ex": "Soror mea in horto ludit.", "ex_fr": "Ma sœur joue dans le jardin.", "monde": "monde2"},
    {"latin": "felis, -is", "cat": "Nom", "genre": "fém. 3e décl.", "fr": "le chat", "etym": "félin", "ex": "Felis murem capit.", "ex_fr": "Le chat attrape la souris.", "monde": "monde2"},
    {"latin": "avis, -is", "cat": "Nom", "genre": "fém. 3e décl.", "fr": "l'oiseau", "etym": "aviation, aviaire", "ex": "Avis in arbore cantat.", "ex_fr": "L'oiseau chante dans l'arbre.", "monde": "monde2"},
    {"latin": "servus, -i", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "l'esclave, le serviteur", "etym": "servir, servile, serf", "ex": "Servus aquam portat.", "ex_fr": "L'esclave porte de l'eau.", "monde": "monde2"},
    {"latin": "hortus, -i", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "le jardin", "etym": "horticulture, hortensia", "ex": "In horto rosae sunt.", "ex_fr": "Il y a des roses dans le jardin.", "monde": "monde2"},
    {"latin": "cena, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "le dîner, le repas du soir", "etym": "Cène", "ex": "Familia cenam parat.", "ex_fr": "La famille prépare le dîner.", "monde": "monde2"},

    # Monde 3 · Les dieux et les légendes
    {"latin": "deus, -i", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "le dieu", "etym": "divin, déité, adieu", "ex": "Iupiter deus caeli est.", "ex_fr": "Jupiter est le dieu du ciel.", "monde": "monde3"},
    {"latin": "dea, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la déesse", "etym": "déesse", "ex": "Minerva dea sapientiae est.", "ex_fr": "Minerve est la déesse de la sagesse.", "monde": "monde3"},
    {"latin": "caelum, -i", "cat": "Nom", "genre": "neutre 2e décl.", "fr": "le ciel", "etym": "céleste, ciel", "ex": "Aves in caelo volant.", "ex_fr": "Les oiseaux volent dans le ciel.", "monde": "monde3"},
    {"latin": "terra, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la terre", "etym": "terrestre, territoire, terrain", "ex": "Terra rotunda est.", "ex_fr": "La terre est ronde.", "monde": "monde3"},
    {"latin": "fulmen, -inis", "cat": "Nom", "genre": "neutre 3e décl.", "fr": "la foudre", "etym": "fulminer, fulgurant", "ex": "Iupiter fulmen iacit.", "ex_fr": "Jupiter lance la foudre.", "monde": "monde3"},
    {"latin": "ala, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "l'aile", "etym": "aile, ailier", "ex": "Icarus alas habet.", "ex_fr": "Icare a des ailes.", "monde": "monde3"},

    # Monde 4 · Les cas et Hercule
    {"latin": "leo, -onis", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le lion", "etym": "léonin, Léon", "ex": "Hercules leonem necat.", "ex_fr": "Hercule tue le lion.", "monde": "monde4"},
    {"latin": "agnus, -i", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "l'agneau", "etym": "agnelet", "ex": "Lupus agnum videt.", "ex_fr": "Le loup voit l'agneau.", "monde": "monde4"},
    {"latin": "heros, -ois", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le héros", "etym": "héros, héroïque", "ex": "Hercules heros clarus est.", "ex_fr": "Hercule est un héros célèbre.", "monde": "monde4"},
    {"latin": "labor, -oris", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le travail, l'effort", "etym": "labeur, laborieux, laboratoire", "ex": "Labor omnia vincit.", "ex_fr": "Le travail vient à bout de tout.", "monde": "monde4"},
    {"latin": "necare (neco, necavi, necatum)", "cat": "Verbe", "genre": "1er groupe", "fr": "tuer", "etym": "internécin", "ex": "Hercules hydram necat.", "ex_fr": "Hercule tue l'hydre.", "monde": "monde4"},

    # Monde 5 · Les verbes au présent
    {"latin": "currere (curro, cucurri, cursum)", "cat": "Verbe", "genre": "3e groupe", "fr": "courir", "etym": "courir, course, courrier", "ex": "Puer in via currit.", "ex_fr": "Le garçon court dans la rue.", "monde": "monde5"},
    {"latin": "ambulare (ambulo, ambulavi, ambulatum)", "cat": "Verbe", "genre": "1er groupe", "fr": "se promener, marcher", "etym": "ambulant, ambulance, préambule", "ex": "Marcus in foro ambulat.", "ex_fr": "Marcus se promène sur le forum.", "monde": "monde5"},
    {"latin": "cantare (canto, cantavi, cantatum)", "cat": "Verbe", "genre": "1er groupe", "fr": "chanter", "etym": "chanter, cantate, cantique", "ex": "Puella cantat.", "ex_fr": "La jeune fille chante.", "monde": "monde5"},
    {"latin": "laborare (laboro, laboravi, laboratum)", "cat": "Verbe", "genre": "1er groupe", "fr": "travailler", "etym": "labourer, laboratoire", "ex": "Agricola in agro laborat.", "ex_fr": "Le paysan travaille dans le champ.", "monde": "monde5"},
    {"latin": "agricola, -ae", "cat": "Nom", "genre": "masc. 1re décl.", "fr": "le paysan, l'agriculteur", "etym": "agricole, agriculture", "ex": "Agricola terram amat.", "ex_fr": "Le paysan aime la terre.", "monde": "monde5"},

    # Monde 6 · Les gladiateurs et le Colisée
    {"latin": "gladiator, -oris", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le gladiateur", "etym": "gladiateur, glaïeul", "ex": "Gladiator in arena pugnat.", "ex_fr": "Le gladiateur combat dans l'arène.", "monde": "monde6"},
    {"latin": "harena, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "le sable, l'arène", "etym": "arène", "ex": "Harena amphitheatri magna est.", "ex_fr": "L'arène de l'amphithéâtre est grande.", "monde": "monde6"},
    {"latin": "spectator, -oris", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le spectateur", "etym": "spectateur, spectacle", "ex": "Spectatores clamant.", "ex_fr": "Les spectateurs crient.", "monde": "monde6"},
    {"latin": "rete, -is", "cat": "Nom", "genre": "neutre 3e décl.", "fr": "le filet", "etym": "réseau, rétiaire", "ex": "Retiarius rete iacit.", "ex_fr": "Le rétiaire lance son filet.", "monde": "monde6"},
    {"latin": "clamare (clamo, clamavi, clamatum)", "cat": "Verbe", "genre": "1er groupe", "fr": "crier", "etym": "clamer, réclamer, exclamation", "ex": "Populus clamat.", "ex_fr": "Le peuple crie.", "monde": "monde6"},

    # Monde 7 · Détective des mots
    {"latin": "pes, pedis", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le pied", "etym": "pédestre, piéton, pédale", "ex": "Pedes mei fessi sunt.", "ex_fr": "Mes pieds sont fatigués.", "monde": "monde7"},
    {"latin": "oculus, -i", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "l'œil", "etym": "oculaire, oculiste", "ex": "Cyclops unum oculum habet.", "ex_fr": "Le Cyclope a un seul œil.", "monde": "monde7"},
    {"latin": "caput, -itis", "cat": "Nom", "genre": "neutre 3e décl.", "fr": "la tête", "etym": "capitale, capitaine, chef", "ex": "Roma caput mundi.", "ex_fr": "Rome, capitale du monde.", "monde": "monde7"},
    {"latin": "liber, -bri", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "le livre", "etym": "librairie, libraire", "ex": "Discipulus librum legit.", "ex_fr": "L'élève lit un livre.", "monde": "monde7"},
    {"latin": "tempus, -oris", "cat": "Nom", "genre": "neutre 3e décl.", "fr": "le temps", "etym": "temporel, temporaire, tempête", "ex": "Tempus fugit.", "ex_fr": "Le temps s'enfuit.", "monde": "monde7"},

    # Monde 8 · Marchés et vie quotidienne
    {"latin": "panis, -is", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le pain", "etym": "panier, panification", "ex": "Pistor panem vendit.", "ex_fr": "Le boulanger vend du pain.", "monde": "monde8"},
    {"latin": "vinum, -i", "cat": "Nom", "genre": "neutre 2e décl.", "fr": "le vin", "etym": "vin, vignoble", "ex": "Romani vinum cum aqua bibunt.", "ex_fr": "Les Romains boivent le vin coupé d'eau.", "monde": "monde8"},
    {"latin": "forum, -i", "cat": "Nom", "genre": "neutre 2e décl.", "fr": "la place publique, le marché", "etym": "forum, forain", "ex": "Mercator in foro est.", "ex_fr": "Le marchand est sur le forum.", "monde": "monde8"},
    {"latin": "mercator, -oris", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le marchand", "etym": "mercantile, commerce", "ex": "Mercator merces vendit.", "ex_fr": "Le marchand vend ses marchandises.", "monde": "monde8"},
    {"latin": "emere (emo, emi, emptum)", "cat": "Verbe", "genre": "3e groupe", "fr": "acheter", "etym": "exemption, préemption", "ex": "Mater panem emit.", "ex_fr": "La mère achète du pain.", "monde": "monde8"},
    {"latin": "vendere (vendo, vendidi, venditum)", "cat": "Verbe", "genre": "3e groupe", "fr": "vendre", "etym": "vendre, vendeur", "ex": "Agricola poma vendit.", "ex_fr": "Le paysan vend des fruits.", "monde": "monde8"},
    {"latin": "thermae, -arum", "cat": "Nom", "genre": "fém. pluriel 1re décl.", "fr": "les thermes, les bains publics", "etym": "thermal, thermomètre", "ex": "Romani in thermis lavant.", "ex_fr": "Les Romains se lavent aux thermes.", "monde": "monde8"},

    # Monde 9 · L'armée romaine
    {"latin": "legio, -onis", "cat": "Nom", "genre": "fém. 3e décl.", "fr": "la légion", "etym": "légion, légionnaire", "ex": "Legio castra ponit.", "ex_fr": "La légion installe son camp.", "monde": "monde9"},
    {"latin": "castra, -orum", "cat": "Nom", "genre": "neutre pluriel 2e décl.", "fr": "le camp militaire", "etym": "Chester, Lancaster (villes anglaises)", "ex": "Milites in castris dormiunt.", "ex_fr": "Les soldats dorment au camp.", "monde": "monde9"},
    {"latin": "pilum, -i", "cat": "Nom", "genre": "neutre 2e décl.", "fr": "le javelot", "etym": "pilum", "ex": "Miles pilum iacit.", "ex_fr": "Le soldat lance son javelot.", "monde": "monde9"},
    {"latin": "galea, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "le casque", "etym": "galéa (anatomie)", "ex": "Galea caput servat.", "ex_fr": "Le casque protège la tête.", "monde": "monde9"},
    {"latin": "fortiter", "cat": "Invariable", "genre": "adverbe", "fr": "courageusement", "etym": "fort, force", "ex": "Milites fortiter pugnant.", "ex_fr": "Les soldats combattent courageusement.", "monde": "monde9"},
    {"latin": "proelium, -i", "cat": "Nom", "genre": "neutre 2e décl.", "fr": "le combat, la bataille", "etym": "prélude (sens figuré)", "ex": "Proelium acre est.", "ex_fr": "La bataille est rude.", "monde": "monde9"},

    # Monde 10 · Monstres et métamorphoses
    {"latin": "monstrum, -i", "cat": "Nom", "genre": "neutre 2e décl.", "fr": "le monstre, le prodige", "etym": "monstre, monstrueux, montrer", "ex": "Minotaurus monstrum est.", "ex_fr": "Le Minotaure est un monstre.", "monde": "monde10"},
    {"latin": "porta, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la porte", "etym": "porte, portail, portier", "ex": "Cerberus portas custodit.", "ex_fr": "Cerbère garde les portes.", "monde": "monde10"},
    {"latin": "custodire (custodio, custodivi, custoditum)", "cat": "Verbe", "genre": "4e groupe", "fr": "garder, surveiller", "etym": "custode", "ex": "Canis domum custodit.", "ex_fr": "Le chien garde la maison.", "monde": "monde10"},
    {"latin": "forma, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la forme, la beauté", "etym": "forme, former, formule", "ex": "Deus formam mutat.", "ex_fr": "Le dieu change de forme.", "monde": "monde10"},
    {"latin": "mutare (muto, mutavi, mutatum)", "cat": "Verbe", "genre": "1er groupe", "fr": "changer, transformer", "etym": "muter, mutation, commuter", "ex": "Circe viros in porcos mutat.", "ex_fr": "Circé change les hommes en porcs.", "monde": "monde10"},

    # Monde 11 · Héros de la République
    {"latin": "pons, pontis", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le pont", "etym": "pont, pontife, ponton", "ex": "Horatius pontem defendit.", "ex_fr": "Horatius défend le pont.", "monde": "monde11"},
    {"latin": "patria, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la patrie", "etym": "patrie, patriote, patriotisme", "ex": "Patriam amamus.", "ex_fr": "Nous aimons notre patrie.", "monde": "monde11"},
    {"latin": "defendere (defendo, defendi, defensum)", "cat": "Verbe", "genre": "3e groupe", "fr": "défendre", "etym": "défendre, défense", "ex": "Milites urbem defendunt.", "ex_fr": "Les soldats défendent la ville.", "monde": "monde11"},

    # Monde 12 · Le Sénat et le peuple
    {"latin": "consul, -is", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le consul", "etym": "consul, consulat", "ex": "Duo consules Romam regunt.", "ex_fr": "Deux consuls gouvernent Rome.", "monde": "monde12"},
    {"latin": "senator, -oris", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le sénateur", "etym": "sénateur, sénile", "ex": "Senatores in curia sedent.", "ex_fr": "Les sénateurs siègent à la curie.", "monde": "monde12"},
    {"latin": "respublica, reipublicae", "cat": "Nom", "genre": "fém. 5e + 1re décl.", "fr": "l'État, la République", "etym": "république, public", "ex": "Cicero rem publicam servat.", "ex_fr": "Cicéron sauve la République.", "monde": "monde12"},
    {"latin": "vox, vocis", "cat": "Nom", "genre": "fém. 3e décl.", "fr": "la voix", "etym": "voix, vocal, vocabulaire", "ex": "Vox populi, vox dei.", "ex_fr": "La voix du peuple est la voix de Dieu.", "monde": "monde12"},

    # Monde 13 · Mare Nostrum
    {"latin": "nauta, -ae", "cat": "Nom", "genre": "masc. 1re décl.", "fr": "le marin", "etym": "nautique, nautile, astronaute", "ex": "Nautae navem ducunt.", "ex_fr": "Les marins mènent le navire.", "monde": "monde13"},
    {"latin": "unda, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la vague, l'onde", "etym": "onde, ondulation, inonder", "ex": "Undae navem pulsant.", "ex_fr": "Les vagues frappent le navire.", "monde": "monde13"},
    {"latin": "portus, -us", "cat": "Nom", "genre": "masc. 4e décl.", "fr": "le port", "etym": "port, portuaire", "ex": "Navis in portu est.", "ex_fr": "Le navire est au port.", "monde": "monde13"},
    {"latin": "navigare (navigo, navigavi, navigatum)", "cat": "Verbe", "genre": "1er groupe", "fr": "naviguer", "etym": "naviguer, navigation", "ex": "Romani in mari navigant.", "ex_fr": "Les Romains naviguent sur la mer.", "monde": "monde13"},

    # Monde 14 · Les légions en marche
    {"latin": "iter, itineris", "cat": "Nom", "genre": "neutre 3e décl.", "fr": "le chemin, l'étape", "etym": "itinéraire", "ex": "Legio iter facit.", "ex_fr": "La légion fait route.", "monde": "monde14"},
    {"latin": "signum, -i", "cat": "Nom", "genre": "neutre 2e décl.", "fr": "le signal, l'enseigne militaire", "etym": "signe, signal, enseigne", "ex": "Signifer signum portat.", "ex_fr": "Le porte-enseigne porte l'enseigne.", "monde": "monde14"},
    {"latin": "ducere (duco, duxi, ductum)", "cat": "Verbe", "genre": "3e groupe", "fr": "conduire, mener", "etym": "conduire, produire, aqueduc", "ex": "Dux milites ducit.", "ex_fr": "Le chef conduit les soldats.", "monde": "monde14"},

    # Monde 17 · César et la Gaule
    {"latin": "Gallia, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la Gaule", "etym": "gaulois, gallican", "ex": "Gallia est omnis divisa in partes tres.", "ex_fr": "La Gaule dans son ensemble est divisée en trois parties.", "monde": "monde17"},
    {"latin": "Gallus, -i", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "le Gaulois", "etym": "gaulois", "ex": "Galli fortiter pugnant.", "ex_fr": "Les Gaulois combattent courageusement.", "monde": "monde17"},
    {"latin": "oppidum, -i", "cat": "Nom", "genre": "neutre 2e décl.", "fr": "la place forte, la ville fortifiée", "etym": "oppidum", "ex": "Caesar oppidum capit.", "ex_fr": "César prend la place forte.", "monde": "monde17"},

    # Monde 18 · Le Grand Triomphe
    {"latin": "triumphus, -i", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "le triomphe", "etym": "triomphe, triompher", "ex": "Imperator triumphum agit.", "ex_fr": "Le général célèbre son triomphe.", "monde": "monde18"},
    {"latin": "gloria, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la gloire", "etym": "gloire, glorieux", "ex": "Gloria victoribus.", "ex_fr": "Gloire aux vainqueurs.", "monde": "monde18"},
    {"latin": "victoria, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la victoire", "etym": "victoire, victorieux", "ex": "Victoria nostra est.", "ex_fr": "La victoire est à nous.", "monde": "monde18"},

    # Monde 19 · La paix d'Auguste
    {"latin": "imperator, -oris", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le général vainqueur, l'empereur", "etym": "empereur, impérial", "ex": "Augustus imperator est.", "ex_fr": "Auguste est empereur.", "monde": "monde19"},
    {"latin": "imperium, -i", "cat": "Nom", "genre": "neutre 2e décl.", "fr": "le commandement, l'empire", "etym": "empire, impérieux", "ex": "Imperium Romanum magnum est.", "ex_fr": "L'Empire romain est grand.", "monde": "monde19"},

    # Monde 20 · Les chemins de l'Empire
    {"latin": "aquaeductus, -us", "cat": "Nom", "genre": "masc. 4e décl.", "fr": "l'aqueduc", "etym": "aqueduc", "ex": "Aquaeductus aquam in urbem ducit.", "ex_fr": "L'aqueduc conduit l'eau dans la ville.", "monde": "monde20"},
    {"latin": "milia passuum", "cat": "Invariable", "genre": "expression", "fr": "les milles romains (mille pas)", "etym": "mille, mile (anglais)", "ex": "Roma centum milia passuum abest.", "ex_fr": "Rome est à cent milles d'ici.", "monde": "monde20"},

    # Monde 21 · Pompéi
    {"latin": "ignis, -is", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le feu", "etym": "igné, ignifugé, ignition", "ex": "Vesuvius ignem emittit.", "ex_fr": "Le Vésuve crache du feu.", "monde": "monde21"},
    {"latin": "cinis, -eris", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "la cendre", "etym": "incinérer, cinéraire", "ex": "Cinis urbem tegit.", "ex_fr": "La cendre recouvre la ville.", "monde": "monde21"},
    {"latin": "fugere (fugio, fugi, fugitum)", "cat": "Verbe", "genre": "3e groupe mixte", "fr": "fuir", "etym": "fugitif, fugue", "ex": "Incolae e urbe fugiunt.", "ex_fr": "Les habitants fuient la ville.", "monde": "monde21"},

    # Monde 25 · Les poètes
    {"latin": "poeta, -ae", "cat": "Nom", "genre": "masc. 1re décl.", "fr": "le poète", "etym": "poète, poésie", "ex": "Vergilius poeta clarus est.", "ex_fr": "Virgile est un poète célèbre.", "monde": "monde25"},
    {"latin": "carmen, -inis", "cat": "Nom", "genre": "neutre 3e décl.", "fr": "le poème, le chant", "etym": "charme", "ex": "Poeta carmen scribit.", "ex_fr": "Le poète écrit un poème.", "monde": "monde25"},
    {"latin": "amor, -oris", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "l'amour", "etym": "amour, amoureux", "ex": "Omnia vincit amor.", "ex_fr": "L'amour triomphe de tout.", "monde": "monde25"},

    # ---- Mondes 15 à 26 : ajouts validés par Cédric le 27/09/2026 ----
    # Sans eux, Memoria restait presque vide en 3e (0 à 5 mots par monde).

    # Monde 15 · Récits d'autrefois : l'imparfait
    {"latin": "convenire (convenio, conveni, conventum)", "cat": "Verbe", "genre": "4e conjugaison", "fr": "se rassembler, se réunir", "etym": "convenir, convention", "ex": "Romani in foro conveniebant.", "ex_fr": "Les Romains se rassemblaient sur le forum.", "monde": "monde15"},
    {"latin": "primus, -a, -um", "cat": "Adjectif", "genre": "1re classe", "fr": "premier", "etym": "primaire, primitif, prime", "ex": "Romulus primus rex Romae erat.", "ex_fr": "Romulus était le premier roi de Rome.", "monde": "monde15"},
    {"latin": "Romanus, -a, -um", "cat": "Adjectif", "genre": "1re classe", "fr": "romain", "etym": "romain, roman", "ex": "Civis Romanus sum.", "ex_fr": "Je suis citoyen romain.", "monde": "monde15"},
    {"latin": "narrare (narro, narravi, narratum)", "cat": "Verbe", "genre": "1re conjugaison", "fr": "raconter", "etym": "narration, narrateur", "ex": "Magister fabulam narrabat.", "ex_fr": "Le maître racontait une histoire.", "monde": "monde15"},

    # Monde 16 · Le parfait
    {"latin": "orator, -oris", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "l'orateur", "etym": "orateur, oral, oraison", "ex": "Cicero magnus orator fuit.", "ex_fr": "Cicéron fut un grand orateur.", "monde": "monde16"},
    {"latin": "invictus, -a, -um", "cat": "Adjectif", "genre": "1re classe", "fr": "invaincu, invincible", "etym": "invincible, vaincre", "ex": "Gladiator invictus fuit.", "ex_fr": "Le gladiateur fut invaincu.", "monde": "monde16"},
    {"latin": "nuntius, -i", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "le messager, la nouvelle", "etym": "annoncer, nonce", "ex": "Nuntius Romam venit.", "ex_fr": "Le messager est venu à Rome.", "monde": "monde16"},

    # Monde 17 · César et la Gaule
    {"latin": "libertas, -atis", "cat": "Nom", "genre": "fém. 3e décl.", "fr": "la liberté", "etym": "liberté, libéral, libérer", "ex": "Galli pro libertate pugnabant.", "ex_fr": "Les Gaulois combattaient pour la liberté.", "monde": "monde17"},
    {"latin": "pro (+ ablatif)", "cat": "Invariable", "genre": "préposition", "fr": "pour, devant, à la place de", "etym": "pronom (« à la place du nom »)", "ex": "Pro patria pugnamus.", "ex_fr": "Nous combattons pour la patrie.", "monde": "monde17"},
    {"latin": "is, ea, id", "cat": "Pronom", "genre": "démonstratif", "fr": "il, elle / celui-ci, celle-ci", "etym": "id (« cela ») dans « id est »", "ex": "Caesar eum vincet.", "ex_fr": "César le vaincra.", "monde": "monde17"},
    {"latin": "aquilifer, -eri", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "le porte-aigle", "etym": "aquilin (aquila, l'aigle)", "ex": "Aquilifer aquilam portat.", "ex_fr": "Le porte-aigle porte l'aigle.", "monde": "monde17"},

    # Monde 18 · Le Grand Triomphe
    {"latin": "sapientia, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la sagesse", "etym": "sapience, Homo sapiens", "ex": "Virtus et sapientia rem publicam servant.", "ex_fr": "Le courage et la sagesse sauvent la République.", "monde": "monde18"},
    {"latin": "servare (servo, servavi, servatum)", "cat": "Verbe", "genre": "1re conjugaison", "fr": "sauver, garder, conserver", "etym": "conserver, observer, réserver", "ex": "Populus Romanus libertatem servat.", "ex_fr": "Le peuple romain garde sa liberté.", "monde": "monde18"},
    {"latin": "dictator, -oris", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le dictateur", "etym": "dictateur, dicter", "ex": "Caesar dictator perpetuus erat.", "ex_fr": "César était dictateur à vie.", "monde": "monde18"},

    # Monde 19 · La paix d'Auguste
    {"latin": "fides, -ei", "cat": "Nom", "genre": "fém. 5e décl.", "fr": "la loyauté, la foi, la confiance", "etym": "fidèle, confiance, fiancé", "ex": "Sine fide nulla amicitia est.", "ex_fr": "Sans loyauté, il n'y a pas d'amitié.", "monde": "monde19"},
    {"latin": "spes, spei", "cat": "Nom", "genre": "fém. 5e décl.", "fr": "l'espoir", "etym": "espérer, espérance", "ex": "Spes victoriae magna est.", "ex_fr": "L'espoir de la victoire est grand.", "monde": "monde19"},
    {"latin": "cornu, -us", "cat": "Nom", "genre": "neutre 4e décl.", "fr": "la corne ; l'aile d'une armée", "etym": "corne, cornet, licorne", "ex": "Taurus cornua habet.", "ex_fr": "Le taureau a des cornes.", "monde": "monde19"},
    {"latin": "marmor, -oris", "cat": "Nom", "genre": "neutre 3e décl.", "fr": "le marbre", "etym": "marbre, marmoréen", "ex": "Augustus urbem marmoream reliquit.", "ex_fr": "Auguste laissa une ville de marbre.", "monde": "monde19"},
    {"latin": "dare (do, dedi, datum)", "cat": "Verbe", "genre": "1re conjugaison", "fr": "donner", "etym": "datif, date, données", "ex": "Augustus pacem populo dedit.", "ex_fr": "Auguste donna la paix au peuple.", "monde": "monde19"},
    {"latin": "novus, -a, -um", "cat": "Adjectif", "genre": "1re classe", "fr": "nouveau", "etym": "nouveau, novice, innover", "ex": "Dies novus est.", "ex_fr": "C'est un jour nouveau.", "monde": "monde19"},

    # Monde 20 · Les chemins de l'Empire
    {"latin": "qui, quae, quod", "cat": "Pronom", "genre": "relatif", "fr": "qui, que, lequel", "etym": "quiconque", "ex": "Via quae Romam ducit longa est.", "ex_fr": "La route qui mène à Rome est longue.", "monde": "monde20"},
    {"latin": "regina, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la reine", "etym": "reine, régner, régent", "ex": "Via Appia regina viarum est.", "ex_fr": "La Via Appia est la reine des routes.", "monde": "monde20"},
    {"latin": "collis, -is", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "la colline", "etym": "colline, col", "ex": "Urbs in colle stat.", "ex_fr": "La ville se dresse sur une colline.", "monde": "monde20"},
    {"latin": "condere (condo, condidi, conditum)", "cat": "Verbe", "genre": "3e conjugaison", "fr": "fonder", "etym": "ab Urbe condita : depuis la fondation de Rome", "ex": "Romulus urbem condidit.", "ex_fr": "Romulus fonda la ville.", "monde": "monde20"},
    {"latin": "lapis, -idis", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "la pierre", "etym": "lapider, lapidaire", "ex": "Via lapidibus strata est.", "ex_fr": "La route est pavée de pierres.", "monde": "monde20"},

    # Monde 21 · Pompéi
    {"latin": "nubes, -is", "cat": "Nom", "genre": "fém. 3e décl.", "fr": "le nuage", "etym": "nuage, nuée, nébuleuse", "ex": "Nubes atra e monte oriebatur.", "ex_fr": "Un nuage noir s'élevait de la montagne.", "monde": "monde21"},
    {"latin": "ater, atra, atrum", "cat": "Adjectif", "genre": "1re classe", "fr": "noir, sombre", "etym": "atrabilaire", "ex": "Nubes atra caelum tegit.", "ex_fr": "Un nuage noir couvre le ciel.", "monde": "monde21"},
    {"latin": "delere (deleo, delevi, deletum)", "cat": "Verbe", "genre": "2e conjugaison", "fr": "détruire", "etym": "indélébile", "ex": "Pompeii urbs deleta est.", "ex_fr": "La ville de Pompéi a été détruite.", "monde": "monde21"},
    {"latin": "vicus, -i", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "le quartier, le village", "etym": "vicinal (chemin)", "ex": "Vicus cinere deletus est.", "ex_fr": "Le quartier a été détruit par la cendre.", "monde": "monde21"},

    # Monde 22 · L'ablatif absolu
    {"latin": "sol, solis", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le soleil", "etym": "solaire, solstice, parasol", "ex": "Sole oriente, agricolae laborant.", "ex_fr": "Au lever du soleil, les paysans travaillent.", "monde": "monde22"},
    {"latin": "facere (facio, feci, factum)", "cat": "Verbe", "genre": "3e conjugaison mixte", "fr": "faire", "etym": "fait, facteur, facile", "ex": "Pace facta, cives gaudent.", "ex_fr": "La paix faite, les citoyens se réjouissent.", "monde": "monde22"},
    {"latin": "gaudere (gaudeo, gavisus sum)", "cat": "Verbe", "genre": "2e conjugaison", "fr": "se réjouir", "etym": "joie (de gaudium)", "ex": "Cives victoria gaudent.", "ex_fr": "Les citoyens se réjouissent de la victoire.", "monde": "monde22"},
    {"latin": "redire (redeo, redii, reditum)", "cat": "Verbe", "genre": "irrégulier (comme ire)", "fr": "revenir", "etym": "re- + ire : aller de nouveau", "ex": "Urbe capta, milites redierunt.", "ex_fr": "La ville prise, les soldats revinrent.", "monde": "monde22"},
    {"latin": "oriri (orior, ortus sum)", "cat": "Verbe", "genre": "4e conjugaison, déponent", "fr": "se lever, naître", "etym": "orient (là où le soleil se lève), origine", "ex": "Sol oritur.", "ex_fr": "Le soleil se lève.", "monde": "monde22"},

    # Monde 23 · La voix passive
    {"latin": "laudare (laudo, laudavi, laudatum)", "cat": "Verbe", "genre": "1re conjugaison", "fr": "louer, faire l'éloge", "etym": "louange, laudatif", "ex": "Miles fortis a duce laudatur.", "ex_fr": "Le soldat courageux est loué par le général.", "monde": "monde23"},
    {"latin": "a / ab (+ ablatif)", "cat": "Invariable", "genre": "préposition", "fr": "par (complément d'agent) ; de, depuis", "etym": "absent, abstenir", "ex": "Patria a Romanis amatur.", "ex_fr": "La patrie est aimée par les Romains.", "monde": "monde23"},
    {"latin": "concordia, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la concorde, l'entente", "etym": "concorde, concordance", "ex": "Pax et concordia a civibus quaeruntur.", "ex_fr": "La paix et la concorde sont recherchées par les citoyens.", "monde": "monde23"},
    {"latin": "quaerere (quaero, quaesivi, quaesitum)", "cat": "Verbe", "genre": "3e conjugaison", "fr": "chercher, demander", "etym": "question, quête, enquête", "ex": "Pax a civibus quaeritur.", "ex_fr": "La paix est recherchée par les citoyens.", "monde": "monde23"},

    # Monde 24 · La proposition infinitive
    {"latin": "scire (scio, scivi, scitum)", "cat": "Verbe", "genre": "4e conjugaison", "fr": "savoir", "etym": "science, conscience", "ex": "Scio Marcum fortem esse.", "ex_fr": "Je sais que Marcus est courageux.", "monde": "monde24"},
    {"latin": "putare (puto, putavi, putatum)", "cat": "Verbe", "genre": "1re conjugaison", "fr": "penser, croire", "etym": "réputation, supputer", "ex": "Puto amicum venire.", "ex_fr": "Je pense que l'ami arrive.", "monde": "monde24"},
    {"latin": "nuntiare (nuntio, nuntiavi, nuntiatum)", "cat": "Verbe", "genre": "1re conjugaison", "fr": "annoncer", "etym": "annoncer, dénoncer", "ex": "Nuntiant hostes venire.", "ex_fr": "Ils annoncent que les ennemis arrivent.", "monde": "monde24"},
    {"latin": "fama, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la rumeur, la renommée", "etym": "fameux, infâme", "ex": "Fama est consulem Romam venire.", "ex_fr": "Le bruit court que le consul vient à Rome.", "monde": "monde24"},

    # Monde 25 · Les poètes
    {"latin": "arma, -orum", "cat": "Nom", "genre": "neutre pluriel, 2e décl.", "fr": "les armes", "etym": "arme, armée, armure", "ex": "Arma virumque cano.", "ex_fr": "Je chante les armes et le héros.", "monde": "monde25"},
    {"latin": "vir, viri", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "l'homme, le héros", "etym": "viril, triumvir", "ex": "Vir fortis patriam defendit.", "ex_fr": "L'homme courageux défend sa patrie.", "monde": "monde25"},
    {"latin": "canere (cano, cecini, cantum)", "cat": "Verbe", "genre": "3e conjugaison", "fr": "chanter, célébrer", "etym": "incantation, chant", "ex": "Poeta heroes canit.", "ex_fr": "Le poète chante les héros.", "monde": "monde25"},
    {"latin": "felix, -icis", "cat": "Adjectif", "genre": "2e classe", "fr": "heureux", "etym": "félicité, féliciter", "ex": "Felix sis !", "ex_fr": "Sois heureux !", "monde": "monde25"},
    {"latin": "-que", "cat": "Invariable", "genre": "conjonction (collée au mot)", "fr": "et", "etym": "SPQR : Senatus Populusque Romanus", "ex": "Senatus Populusque Romanus.", "ex_fr": "Le Sénat et le peuple romain.", "monde": "monde25"},

    # Monde 26 · Le Grand Triomphe du collège
    {"latin": "littera, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la lettre (au pluriel : les lettres, la culture)", "etym": "lettre, littérature", "ex": "Litterae mentem ornant.", "ex_fr": "Les lettres ornent l'esprit.", "monde": "monde26"},
    {"latin": "mens, mentis", "cat": "Nom", "genre": "fém. 3e décl.", "fr": "l'esprit, l'intelligence", "etym": "mental, mentionner, démence", "ex": "Mens sana in corpore sano.", "ex_fr": "Un esprit sain dans un corps sain.", "monde": "monde26"},
    {"latin": "ornare (orno, ornavi, ornatum)", "cat": "Verbe", "genre": "1re conjugaison", "fr": "orner, embellir", "etym": "orner, ornement", "ex": "Litterae et sapientia mentem hominis ornant.", "ex_fr": "Les lettres et la sagesse ornent l'esprit de l'homme.", "monde": "monde26"},
    {"latin": "princeps, -ipis", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le premier citoyen, le prince", "etym": "prince, principal", "ex": "Traianus optimus princeps erat.", "ex_fr": "Trajan était le meilleur des princes.", "monde": "monde26"},
    {"latin": "optimus, -a, -um", "cat": "Adjectif", "genre": "superlatif de bonus", "fr": "le meilleur, excellent", "etym": "optimal, optimiste", "ex": "Optimus magister patiens est.", "ex_fr": "Le meilleur maître est patient.", "monde": "monde26"},
]
