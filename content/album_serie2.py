"""Album « Héros et Créatures », série 2 : 34 cartes de plus (29-30/10/2026).

Catalogue validé par Cédric (docs/propositions/album_serie2.md) après le
premier retour de Clovis : plus de cartes à débloquer pour la Bataille,
dont Rémus et Jules César, qu'il a demandés.
Chaque carte se gagne par un succès (stat, seuil) ou s'achète à prix fixe
à la Taberna (prix, sans tirage au hasard). Le champ « scene » ne sert
qu'aux prompts d'illustration (scripts/docs), pas à l'appli.
"""

# Prix d'achat à la Taberna selon la rareté. Une carte achetée ne rapporte
# pas la prime de sesterces d'une carte gagnée.
PRIX_PAR_RARETE = {"commune": 80, "rare": 150, "epique": 300, "legendaire": 600}

CARTES_SERIE2 = [
    # --- Gagnées en jouant à la Bataille contre Crassus ---
    {"id": "her_clelie", "nom": "Clélie", "nom_latin": "Cloelia Virgo Fortis", "categorie": "heros",
     "rarete": "commune", "atk": 76, "def": 84,
     "citation": "Cloelia Tiberim tranat.", "traduction": "Clélie traverse le Tibre à la nage.",
     "anecdote": "Otage du roi étrusque Porsenna, cette jeune Romaine s'enfuit avec ses compagnes en "
                 "traversant le Tibre à la nage. Admiratif, Porsenna lui rendit sa liberté.",
     "stat": "bataille_victoires", "seuil": 1, "texte": "Gagner une Bataille contre Crassus",
     "scene": "Clélie, jeune Romaine aux cheveux nattés en tunique claire, nage avec énergie dans le "
              "Tibre vers la rive de Rome, ses compagnes derrière elle, les collines et les remparts au loin"},
    {"id": "her_remus", "nom": "Rémus", "nom_latin": "Remus Frater Romuli", "categorie": "heros",
     "rarete": "commune", "atk": 86, "def": 76,
     "citation": "Remus sulcum transilit.", "traduction": "Rémus saute par-dessus le sillon.",
     "anecdote": "Jumeau de Romulus, élevé avec lui par la louve. Il franchit par défi le sillon sacré "
                 "que son frère venait de tracer, et ce geste lui coûta la vie.",
     "stat": "bataille_victoires", "seuil": 2, "texte": "Gagner 2 Batailles contre Crassus",
     # Jumeau de la carte Romulus : l'image de celle-ci sert de référence.
     "reference": "assets/images/album/her_romulus.webp",
     "scene": "Rémus, le frère jumeau du jeune homme de l'image de référence, mêmes traits du visage et "
              "mêmes cheveux sombres et bouclés, en tunique claire et cape bleu sombre, saute d'un bond "
              "joyeux et plein de défi par-dessus un sillon fraîchement tracé dans la terre, sur la "
              "colline du Palatin à l'aube, un sourire moqueur aux lèvres"},
    {"id": "div_cupidon", "nom": "Cupidon", "nom_latin": "Cupido Sagittarius", "categorie": "divinites",
     "rarete": "commune", "atk": 80, "def": 72,
     "citation": "Cupido sagittas mittit.", "traduction": "Cupidon lance des flèches.",
     "anecdote": "Fils de Vénus, il porte un arc et deux sortes de flèches : celles d'or font tomber "
                 "amoureux, celles de plomb font fuir l'amour.",
     "stat": "bataille_victoires", "seuil": 3, "texte": "Gagner 3 Batailles contre Crassus",
     "scene": "Cupidon, petit garçon ailé et malicieux aux boucles blondes, bande son petit arc doré "
              "en visant vers le ciel, perché sur un nuage rose"},
    {"id": "her_mucius", "nom": "Mucius Scaevola", "nom_latin": "Gaius Mucius Scaevola", "categorie": "heros",
     "rarete": "rare", "atk": 86, "def": 88,
     "citation": "Et facere et pati fortia Romanum est.",
     "traduction": "Agir et souffrir avec courage, c'est être romain.",
     "anecdote": "Capturé par Porsenna, il tendit sa main droite au-dessus d'un brasier pour montrer "
                 "qu'aucune menace ne ferait céder un Romain. On le surnomma Scaevola, « le gaucher ».",
     "stat": "bataille_victoires", "seuil": 5, "texte": "Gagner 5 Batailles contre Crassus",
     "scene": "Mucius Scaevola, jeune Romain en tunique et cape rouge, debout fièrement face à un "
              "brasier sur un trépied de bronze, le regard droit et calme, dans la tente d'un roi étrusque"},
    {"id": "mon_capitole", "nom": "Le Capitole", "nom_latin": "Capitolium", "categorie": "monuments",
     "rarete": "rare", "atk": 78, "def": 92,
     "citation": "Capitolium arx Romae est.", "traduction": "Le Capitole est la citadelle de Rome.",
     "anecdote": "La plus sacrée des sept collines, avec le grand temple de Jupiter. Les généraux "
                 "vainqueurs y montaient à la fin de leur triomphe.",
     "stat": "bataille_victoires", "seuil": 10, "texte": "Gagner 10 Batailles contre Crassus",
     "scene": "La colline du Capitole couronnée du grand temple de Jupiter aux colonnes blanches et au "
              "toit doré, un escalier monumental, des oies blanches au premier plan"},
    {"id": "div_vulcain", "nom": "Vulcain", "nom_latin": "Vulcanus Faber", "categorie": "divinites",
     "rarete": "epique", "atk": 93, "def": 88,
     "citation": "Vulcanus arma fabricat.", "traduction": "Vulcain forge les armes.",
     "anecdote": "Dieu du feu et des forges, il travaillait sous l'Etna. Il forgeait les foudres de "
                 "Jupiter, et le mot « volcan » vient de son nom.",
     "stat": "bataille_victoires", "seuil": 20, "texte": "Gagner 20 Batailles contre Crassus",
     "scene": "Vulcain, dieu forgeron barbu et musclé au tablier de cuir, frappe de son marteau une "
              "épée rougeoyante sur une enclume, des étincelles dorées autour de lui, dans une forge "
              "creusée sous un volcan"},
    {"id": "mon_chimere", "nom": "La Chimère", "nom_latin": "Chimaera Flammifera", "categorie": "monstres",
     "rarete": "epique", "atk": 95, "def": 80,
     "citation": "Chimaera flammas spirat.", "traduction": "La Chimère souffle des flammes.",
     "anecdote": "Lion devant, chèvre au milieu, serpent pour queue, elle crachait du feu. Le héros "
                 "Bellérophon la vainquit, monté sur le cheval ailé Pégase.",
     "stat": "bataille_victoires", "seuil": 35, "texte": "Gagner 35 Batailles contre Crassus",
     "scene": "La Chimère, créature fantastique à tête de lion, avec une tête de chèvre sur le dos et "
              "une queue de serpent, soufflant une petite gerbe de flammes orangées, sur un rocher "
              "volcanique, l'air plus impressionnant qu'effrayant"},
    {"id": "div_fortuna", "nom": "Fortuna", "nom_latin": "Fortuna Dea", "categorie": "divinites",
     "rarete": "legendaire", "atk": 94, "def": 96,
     "citation": "Audentes fortuna iuvat.", "traduction": "La fortune sourit aux audacieux.",
     "anecdote": "Déesse de la chance, on la représentait avec une corne d'abondance et un "
                 "gouvernail : elle mène la vie des hommes où elle veut. La devise vient de Virgile.",
     "stat": "bataille_victoires", "seuil": 50, "texte": "Gagner 50 Batailles contre Crassus",
     "scene": "Fortuna, déesse souriante en longue robe dorée, tenant d'une main une corne d'abondance "
              "d'où tombent des fruits et des pièces d'or, de l'autre un gouvernail de navire, "
              "sur fond de ciel lumineux"},
    # --- Gagnées contre Cléopâtre ---
    {"id": "mon_phenix", "nom": "Le Phénix", "nom_latin": "Phoenix Avis", "categorie": "monstres",
     "rarete": "rare", "atk": 84, "def": 86,
     "citation": "Phoenix e cineribus resurgit.", "traduction": "Le phénix renaît de ses cendres.",
     "anecdote": "Oiseau unique au monde, venu des légendes d'Égypte : tous les cinq cents ans, il "
                 "brûle puis renaît de ses propres cendres.",
     "stat": "bataille_victoires_cleopatre", "seuil": 1, "texte": "Gagner une Bataille contre Cléopâtre",
     "scene": "Le Phénix, grand oiseau aux plumes rouges et or, ailes déployées, s'élevant d'un nid de "
              "braises dorées, devant des palmiers et une pyramide lointaine"},
    {"id": "mon_scylla", "nom": "Scylla", "nom_latin": "Scylla Monstrum Maris", "categorie": "monstres",
     "rarete": "epique", "atk": 94, "def": 84,
     "citation": "Scylla nautas terret.", "traduction": "Scylla effraie les marins.",
     "anecdote": "Monstre aux six têtes de chien, cachée dans un rocher du détroit de Sicile, face au "
                 "tourbillon de Charybde. Ulysse dut passer entre les deux.",
     "stat": "bataille_victoires_cleopatre", "seuil": 5, "texte": "Gagner 5 Batailles contre Cléopâtre",
     "scene": "Scylla, monstre marin aux longs cous terminés par des têtes de chien grondantes, "
              "surgissant d'une grotte dans une falaise, un petit navire grec qui passe au loin "
              "sur une mer agitée, l'air plus impressionnant qu'effrayant"},
    # Exception au « pas de doublon avec le Panthéon », demandée par Clovis (30/10/2026) :
    # les cartes du Panthéon ne jouent pas à la Bataille, et la scène du Rubicon est différente.
    {"id": "her_cesar", "nom": "Jules César", "nom_latin": "Gaius Iulius Caesar", "categorie": "heros",
     "rarete": "legendaire", "atk": 98, "def": 93,
     "citation": "Veni, vidi, vici.", "traduction": "Je suis venu, j'ai vu, j'ai vaincu.",
     "anecdote": "Vainqueur de la Gaule, il franchit le Rubicon avec son armée en 49 av. J.-C. et "
                 "déclencha la guerre civile. Sa devise résume une victoire éclair de 47 av. J.-C.",
     "stat": "bataille_victoires_cleopatre", "seuil": 7, "texte": "Gagner 7 Batailles contre Cléopâtre",
     "scene": "Jules César, général romain d'une cinquantaine d'années, visage maigre et énergique, "
              "front dégarni, couronne de laurier d'or, cuirasse de bronze et grande cape écarlate, "
              "debout à la proue d'une barque qui traverse une petite rivière à l'aube, le bras tendu "
              "vers l'autre rive, ses légionnaires et leurs enseignes derrière lui"},
    {"id": "div_venus", "nom": "Vénus", "nom_latin": "Venus Genetrix", "categorie": "divinites",
     "rarete": "legendaire", "atk": 92, "def": 99,
     "citation": "Amor omnia vincit.", "traduction": "L'amour triomphe de tout.",
     "anecdote": "Déesse de l'amour et de la beauté, mère d'Énée. Jules César disait que sa famille "
                 "descendait d'elle. La devise vient de Virgile.",
     "stat": "bataille_victoires_cleopatre", "seuil": 10, "texte": "Gagner 10 Batailles contre Cléopâtre",
     "scene": "Vénus, déesse gracieuse aux longs cheveux dorés, en robe blanche et rose, debout sur "
              "une grande coquille nacrée au bord de la mer, des colombes autour d'elle"},
    # --- Gagnées dans les nouveaux jeux ---
    {"id": "her_atalante", "nom": "Atalante", "nom_latin": "Atalanta Velox", "categorie": "heros",
     "rarete": "commune", "atk": 84, "def": 74,
     "citation": "Atalanta celerrime currit.", "traduction": "Atalante court très vite.",
     "anecdote": "Chasseresse plus rapide que tous les hommes. Hippomène ne la battit à la course "
                 "qu'en lâchant trois pommes d'or qu'elle s'arrêta ramasser.",
     "stat": "paires_victoires", "seuil": 1, "texte": "Gagner une partie de Paires éclair",
     "scene": "Atalante, jeune chasseresse grecque en tunique courte, cheveux au vent, court à toute "
              "vitesse sur un stade de terre, une pomme d'or roulant devant elle"},
    {"id": "mon_harpies", "nom": "Les Harpies", "nom_latin": "Harpyiae Rapaces", "categorie": "monstres",
     "rarete": "rare", "atk": 86, "def": 78,
     "citation": "Harpyiae cibum rapiunt.", "traduction": "Les Harpies volent la nourriture.",
     "anecdote": "Femmes-oiseaux aux griffes crochues, elles volaient les repas du roi Phinée, jusqu'à "
                 "ce que les Argonautes les chassent.",
     "stat": "paires_victoires", "seuil": 10, "texte": "Gagner 10 parties de Paires éclair",
     "scene": "Deux Harpies, créatures mi-femmes mi-oiseaux aux ailes grises, fondent en riant sur une "
              "table de banquet pour emporter des fruits et du pain, l'air espiègle plus que menaçant"},
    {"id": "mon_griffon", "nom": "Le Griffon", "nom_latin": "Gryps Custos Auri", "categorie": "monstres",
     "rarete": "epique", "atk": 90, "def": 92,
     "citation": "Gryps aurum custodit.", "traduction": "Le griffon garde l'or.",
     "anecdote": "Corps de lion, tête et ailes d'aigle : les Anciens racontaient qu'il gardait les "
                 "mines d'or des montagnes du Nord.",
     "stat": "record:paires", "seuil": 30, "texte": "Finir Paires éclair avec 30 secondes d'avance",
     "scene": "Le Griffon, créature majestueuse au corps de lion doré, à la tête et aux grandes ailes "
              "d'aigle, posé sur un tas de pépites d'or au sommet d'une montagne"},
    {"id": "div_janus", "nom": "Janus", "nom_latin": "Ianus Bifrons", "categorie": "divinites",
     "rarete": "commune", "atk": 74, "def": 86,
     "citation": "Ianus portas custodit.", "traduction": "Janus garde les portes.",
     "anecdote": "Dieu aux deux visages, l'un vers le passé, l'autre vers l'avenir, il veille sur les "
                 "portes et les commencements. Janvier porte son nom.",
     "stat": "mots_du_jour_trouves", "seuil": 1, "texte": "Trouver un Mot du jour",
     "scene": "Janus, dieu barbu à deux visages regardant chacun d'un côté, tenant une grande clé, "
              "debout sous une arche de pierre à deux portes"},
    {"id": "her_cornelie", "nom": "Cornélie", "nom_latin": "Cornelia Mater Gracchorum", "categorie": "heros",
     "rarete": "rare", "atk": 78, "def": 90,
     "citation": "Haec ornamenta mea sunt.", "traduction": "Voici mes bijoux.",
     "anecdote": "Mère des Gracques. À une dame qui lui montrait ses bijoux, elle présenta ses deux "
                 "fils : « Voici mes bijoux. »",
     "stat": "mots_du_jour_trouves", "seuil": 7, "texte": "Trouver 7 Mots du jour",
     "scene": "Cornélie, dame romaine digne en stola bleue, la main posée sur les épaules de ses deux "
              "jeunes fils souriants, dans l'atrium d'une maison romaine"},
    {"id": "div_saturne", "nom": "Saturne", "nom_latin": "Saturnus Sator", "categorie": "divinites",
     "rarete": "epique", "atk": 86, "def": 94,
     "citation": "Saturnus aetatem auream regebat.", "traduction": "Saturne régnait sur l'âge d'or.",
     "anecdote": "Dieu des semailles, il régnait sur l'âge d'or, quand la terre donnait tout sans "
                 "travail. En décembre, les Saturnales inversaient les rôles : les maîtres servaient.",
     "stat": "mots_du_jour_trouves", "seuil": 30, "texte": "Trouver 30 Mots du jour",
     "scene": "Saturne, vieux dieu barbu et bienveillant tenant une faucille dorée, au milieu de "
              "champs de blé dorés baignés de lumière, symbole de l'âge d'or"},
    # --- Achetées à prix fixe à la Taberna ---
    {"id": "mon_forum", "nom": "Le Forum romain", "nom_latin": "Forum Romanum", "categorie": "monuments",
     "rarete": "commune", "atk": 72, "def": 88,
     "citation": "Forum cor urbis est.", "traduction": "Le forum est le cœur de la ville.",
     "anecdote": "Grande place au cœur de Rome : on y faisait ses achats, on y écoutait les orateurs "
                 "à la tribune des Rostres, on y rendait la justice.",
     "achat": True,
     "scene": "Le Forum romain animé, temples à colonnes et basiliques, une foule en toges et "
              "tuniques, un orateur sur une tribune, des marchands"},
    {"id": "mon_maison_carree", "nom": "La Maison carrée", "nom_latin": "Templum Nemausense",
     "categorie": "monuments", "rarete": "commune", "atk": 70, "def": 90,
     "citation": "Templum Nemausi adhuc stat.", "traduction": "Le temple de Nîmes est encore debout.",
     "anecdote": "Temple romain de Nîmes, construit au début de notre ère. C'est l'un des temples "
                 "romains les mieux conservés au monde.",
     "achat": True,
     "scene": "La Maison carrée de Nîmes, temple romain rectangulaire à colonnes corinthiennes sur un "
              "haut podium, dans sa pierre claire, sous un ciel bleu du Midi"},
    {"id": "mon_theatre_orange", "nom": "Le Théâtre d'Orange", "nom_latin": "Theatrum Arausionense",
     "categorie": "monuments", "rarete": "commune", "atk": 74, "def": 86,
     "citation": "Fabula agitur.", "traduction": "La pièce se joue.",
     "anecdote": "Son immense mur de scène est encore debout. Louis XIV l'aurait appelé « la plus "
                 "belle muraille de mon royaume ».",
     "achat": True,
     "scene": "Le théâtre antique d'Orange, gradins en demi-cercle face à un immense mur de scène à "
              "colonnes, des acteurs masqués sur la scène, des spectateurs romains"},
    {"id": "mon_sanglier", "nom": "Le Sanglier d'Érymanthe", "nom_latin": "Aper Erymanthius",
     "categorie": "monstres", "rarete": "commune", "atk": 85, "def": 78,
     "citation": "Aper silvam vastat.", "traduction": "Le sanglier ravage la forêt.",
     "anecdote": "Pour son quatrième travail, Hercule dut le rapporter vivant. Effrayé, le roi "
                 "Eurysthée alla se cacher dans une grande jarre.",
     "achat": True,
     "scene": "Un énorme sanglier sauvage aux défenses blanches, poil hérissé, chargeant dans une "
              "forêt de montagne enneigée, l'air plus impressionnant qu'effrayant"},
    {"id": "div_ceres", "nom": "Cérès", "nom_latin": "Ceres Frugifera", "categorie": "divinites",
     "rarete": "commune", "atk": 75, "def": 85,
     "citation": "Ceres agros fecundat.", "traduction": "Cérès rend les champs fertiles.",
     "anecdote": "Déesse des moissons et du blé. Le mot « céréale » vient de son nom.",
     "achat": True,
     "scene": "Cérès, déesse souriante couronnée d'épis de blé, tenant une gerbe dorée et une "
              "torche, au milieu de champs mûrs"},
    {"id": "div_diane", "nom": "Diane", "nom_latin": "Diana Venatrix", "categorie": "divinites",
     "rarete": "rare", "atk": 89, "def": 80,
     "citation": "Diana silvas custodit.", "traduction": "Diane garde les forêts.",
     "anecdote": "Sœur jumelle d'Apollon, déesse de la chasse et de la Lune. Elle parcourait les "
                 "forêts avec son arc d'argent et ses chiens.",
     "achat": True,
     "scene": "Diane, chasseresse en tunique courte, un croissant de lune dans les cheveux, un arc "
              "d'argent à la main, accompagnée d'une biche, dans une forêt sous la lune"},
    {"id": "div_bacchus", "nom": "Bacchus", "nom_latin": "Bacchus Liber Pater", "categorie": "divinites",
     "rarete": "rare", "atk": 82, "def": 84,
     "citation": "Bacchus vites amat.", "traduction": "Bacchus aime les vignes.",
     "anecdote": "Dieu de la vigne et des fêtes. Le théâtre est né des fêtes données en son honneur.",
     "achat": True,
     "scene": "Bacchus, jeune dieu joyeux couronné de feuilles de vigne et de grappes de raisin, "
              "tenant un thyrse orné de lierre, entouré de vignes dorées par le soleil"},
    {"id": "mon_sirene", "nom": "La Sirène", "nom_latin": "Siren Canora", "categorie": "monstres",
     "rarete": "rare", "atk": 84, "def": 82,
     "citation": "Sirenes nautas vocant.", "traduction": "Les Sirènes appellent les marins.",
     "anecdote": "Dans l'Odyssée, ce sont des femmes-oiseaux dont le chant attire les marins sur les "
                 "rochers. Ulysse se fit attacher au mât pour les écouter sans danger.",
     "achat": True,
     "scene": "Une Sirène à la manière antique, femme-oiseau aux ailes dorées et au visage gracieux, "
              "chantant sur un rocher au-dessus de la mer, un navire grec au loin"},
    {"id": "her_cincinnatus", "nom": "Cincinnatus", "nom_latin": "Lucius Quinctius Cincinnatus",
     "categorie": "heros", "rarete": "rare", "atk": 83, "def": 89,
     "citation": "Cincinnatus aratrum relinquit.", "traduction": "Cincinnatus quitte sa charrue.",
     "anecdote": "On vint le chercher à sa charrue pour sauver Rome. Vainqueur, il rendit le pouvoir "
                 "au bout de seize jours et retourna à ses champs.",
     "achat": True,
     "scene": "Cincinnatus, Romain d'âge mûr en simple tunique, laisse sa charrue au milieu d'un champ "
              "pour recevoir la toge que lui tendent des sénateurs venus de Rome"},
    {"id": "mon_pont_gard", "nom": "Le Pont du Gard", "nom_latin": "Aquaeductus Nemausensis",
     "categorie": "monuments", "rarete": "rare", "atk": 76, "def": 94,
     "citation": "Aqua per pontem fluit.", "traduction": "L'eau coule sur le pont.",
     "anecdote": "Ce pont à trois étages d'arches, haut de près de cinquante mètres, faisait passer "
                 "l'aqueduc qui apportait l'eau à Nîmes.",
     "achat": True,
     "scene": "Le Pont du Gard, pont-aqueduc romain à trois rangées d'arches de pierre dorée, "
              "enjambant une rivière verte entre des collines boisées"},
    {"id": "her_thesee", "nom": "Thésée", "nom_latin": "Theseus Atheniensis", "categorie": "heros",
     "rarete": "epique", "atk": 92, "def": 86,
     "citation": "Theseus Minotaurum necat.", "traduction": "Thésée tue le Minotaure.",
     "anecdote": "Héros d'Athènes, il vainquit le Minotaure dans le Labyrinthe et retrouva la sortie "
                 "grâce au fil que lui avait donné Ariane.",
     "achat": True,
     "scene": "Thésée, jeune héros grec en tunique et cape bleue, une épée courte à la main, suit un "
              "fil rouge déroulé dans les couloirs de pierre d'un labyrinthe éclairé par une torche"},
    {"id": "mon_polypheme", "nom": "Polyphème le Cyclope", "nom_latin": "Polyphemus Cyclops",
     "categorie": "monstres", "rarete": "epique", "atk": 96, "def": 82,
     "citation": "Cyclops oculum unum habet.", "traduction": "Le Cyclope a un seul œil.",
     "anecdote": "Géant à l'œil unique, fils de Neptune. Ulysse lui dit s'appeler « Personne » pour "
                 "s'échapper de sa caverne.",
     "achat": True,
     "scene": "Polyphème, géant cyclope à l'œil unique au milieu du front, assis à l'entrée de sa "
              "caverne avec ses moutons, l'air bourru plus que menaçant, la mer en contrebas"},
    {"id": "mon_mur_hadrien", "nom": "Le Mur d'Hadrien", "nom_latin": "Vallum Hadriani",
     "categorie": "monuments", "rarete": "epique", "atk": 80, "def": 98,
     "citation": "Murus Britanniam dividit.", "traduction": "Le mur coupe la Bretagne en deux.",
     "anecdote": "Bâti à partir de 122 sur ordre de l'empereur Hadrien, il barrait le nord de "
                 "l'actuelle Angleterre sur plus de cent kilomètres.",
     "achat": True,
     "scene": "Le Mur d'Hadrien, long rempart de pierre qui serpente sur des collines vertes et "
              "brumeuses, un fortin et des légionnaires en manteau rouge qui montent la garde"},
    {"id": "mon_ladon", "nom": "Le Dragon Ladon", "nom_latin": "Draco Hesperidum", "categorie": "monstres",
     "rarete": "epique", "atk": 91, "def": 93,
     "citation": "Draco poma aurea servat.", "traduction": "Le dragon garde les pommes d'or.",
     "anecdote": "Enroulé autour d'un arbre du jardin des Hespérides, il gardait les pommes d'or "
                 "qu'Hercule devait rapporter pour son onzième travail.",
     "achat": True,
     "scene": "Le dragon Ladon, grand serpent ailé aux écailles vertes et dorées, enroulé autour d'un "
              "arbre chargé de pommes d'or, dans un jardin merveilleux au coucher du soleil"},
    {"id": "div_pluton", "nom": "Pluton", "nom_latin": "Pluto Rex Inferorum", "categorie": "divinites",
     "rarete": "legendaire", "atk": 97, "def": 94,
     "citation": "Pluto umbras regit.", "traduction": "Pluton règne sur les ombres.",
     "anecdote": "Frère de Jupiter, roi des Enfers. Quand son épouse Proserpine descend le rejoindre, "
                 "sa mère Cérès est triste, et c'est l'hiver.",
     "achat": True,
     "scene": "Pluton, dieu majestueux à la barbe sombre, couronne d'or et manteau noir et pourpre, "
              "assis sur un trône sculpté dans une grande salle souterraine éclairée de lueurs "
              "bleutées, le chien Cerbère couché à ses pieds, l'air solennel et non effrayant"},
    {"id": "mon_pompei", "nom": "Pompéi et le Vésuve", "nom_latin": "Pompeii et Vesuvius",
     "categorie": "monuments", "rarete": "legendaire", "atk": 99, "def": 90,
     "citation": "Vesuvius Pompeios delet.", "traduction": "Le Vésuve détruit Pompéi.",
     "anecdote": "En 79, l'éruption du Vésuve ensevelit Pompéi sous les cendres. Pline le Jeune, "
                 "témoin, la raconta dans une lettre célèbre.",
     "achat": True,
     "scene": "La ville de Pompéi avec son forum et ses colonnes, au pied du Vésuve d'où s'élève un "
              "haut panache de fumée en forme de pin parasol, sans personne en danger"},
]

# Les deux adversaires de la Bataille, pour l'écran de choix (illustrations).
ADVERSAIRES = [
    {"id": "crassus", "nom": "Crassus",
     "scene": "Marcus Licinius Crassus, Romain d'âge mûr, rond et jovial, toge blanche bordée de "
              "pourpre, bagues d'or aux doigts, souriant d'un air malicieux, tenant en éventail "
              "cinq cartes dont on ne voit que le dos pourpre et doré, dans l'atrium luxueux d'une "
              "villa avec des coffres de pièces d'or"},
    {"id": "cleopatre", "nom": "Cléopâtre",
     "scene": "Cléopâtre VII, reine d'Égypte, jeune femme au regard vif et rusé, coiffure noire au "
              "carré ornée d'un diadème d'or en forme de cobra, robe blanche et collier large d'or et "
              "de lapis-lazuli, tenant en éventail cinq cartes dont on ne voit que le dos doré, dans "
              "un palais d'Alexandrie aux colonnes peintes, avec le Nil et un phare au loin"},
]
