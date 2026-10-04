# Brouillon des explications par mauvaise réponse (QCM)

> **Statut** : Proposition préparée pour relecture par l'architecte et validation par Cédric (T43).
> **Objectif** : Remplacer l'explication unique actuelle par une explication ciblée de 20 mots au plus par mauvaise option, explicitant l'erreur ou la confusion sans révéler la bonne réponse.

---

## 1. Tableau des 28 leçons de type Quiz

### Quiz #1 — [m1-01] L'Alphabet secret des Romains
- **Monde** : `monde1` — 1 · Salve ! Premiers pas à Rome 🏛️
- **Source** : `content/monde1_salve.py:12`
- **Question** : *Comment les Romains prononçaient-ils la lettre C dans le mot 'Circus' ?*
- **Explication actuelle (commune)** : « Exactement ! En latin classique, le C claque toujours comme un [K] ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **Toujours [K] : 'Kirkous'** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| Toujours [S] : 'Sirsus' | **FAUSSE** | Confusion avec le français moderne : en latin classique, le son [S] n'existe pas pour cette consonne. | 17 |
| Comme un [CH] : 'Chirchus' | **FAUSSE** | C'est la prononciation de l'italien moderne ou du latin ecclésiastique, pas celle des Romains de l'Antiquité. | 16 |
| Elle était muette | **FAUSSE** | En latin, toutes les lettres écrites se prononcent distinctement : aucune consonne n'est muette. | 14 |

### Quiz #2 — [m1-04] Les Chiffres Romains Mystérieux
- **Monde** : `monde1` — 1 · Salve ! Premiers pas à Rome 🏛️
- **Source** : `content/monde1_salve.py:74`
- **Question** : *Combien vaut le nombre romain XIV ?*
- **Explication actuelle (commune)** : « Bravo ! X vaut 10 et IV vaut 4 (5 - 1), donc 10 + 4 = 14 ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| 16 | **FAUSSE** | Tu as additionné V et I (VI = 6), or le I placé avant le V se soustrait. | 18 |
| **14** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| 24 | **FAUSSE** | Tu as compté deux dizaines (XX), mais il n'y a qu'un seul chiffre dix. | 14 |
| 11 | **FAUSSE** | Tu as oublié la valeur du V (cinq) en ne comptant que le X et un bâton. | 17 |

### Quiz #3 — [m2-01] La Famille Romaine (Familia)
- **Monde** : `monde2` — 2 · Dans la Maison Romaine 🏠
- **Source** : `content/monde2_domus.py:12`
- **Question** : *Quel mot latin désigne le fils dans la famille romaine ?*
- **Explication actuelle (commune)** : « Filius est le fils (qui a donné 'filial' en français) ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **Filius** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| Frater | **FAUSSE** | Ce mot désigne le frère dans la famille, qui a donné fraternité en français. | 14 |
| Pater | **FAUSSE** | Ce mot désigne le père et chef de famille, comme dans paternel ou patriarche. | 14 |
| Servus | **FAUSSE** | Ce mot désigne l'esclave ou le serviteur, pas un membre libre de la famille. | 14 |

### Quiz #4 — [m2-04] Visite de la Domus : L'Atrium et le Péristyle
- **Monde** : `monde2` — 2 · Dans la Maison Romaine 🏠
- **Source** : `content/monde2_domus.py:78`
- **Question** : *Comment s'appelle le grand salon central avec ouverture sur le toit d'une domus ?*
- **Explication actuelle (commune)** : « C'est bien l'atrium, la pièce maîtresse et lumineuse de la maison ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **L'atrium** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| Le triclinium | **FAUSSE** | C'est la salle à manger romaine où les convives mangeaient allongés sur trois lits. | 14 |
| L'insula | **FAUSSE** | C'est un immeuble collectif de plusieurs étages pour le peuple, pas une pièce d'habitation privée. | 15 |
| Le forum | **FAUSSE** | C'est la grande place publique de la cité, située à l'extérieur des habitations privées. | 14 |

### Quiz #5 — [m3-01] Le Panthéon Romain : Les Maîtres du Ciel et des Mers
- **Monde** : `monde3` — 3 · Les Dieux de l'Olympe & Légendes ⚡
- **Source** : `content/monde3_dieux.py:12`
- **Question** : *Quel dieu romain brandit le trident et commande aux océans ?*
- **Explication actuelle (commune)** : « C'est Neptune, dieu des mers et des séismes avec son trident ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| Jupiter | **FAUSSE** | Ce souverain des dieux commande au ciel et lance la foudre depuis le mont Capitole. | 15 |
| **Neptune** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| Mars | **FAUSSE** | Ce protecteur des légions porte le casque et la lance : il règne sur la guerre. | 16 |
| Vulcain | **FAUSSE** | Ce forgeron divin travaille le métal dans le feu des volcans avec son marteau. | 14 |

### Quiz #6 — [m3-04] Méduse la Gorgone et le bouclier miroir
- **Monde** : `monde3` — 3 · Les Dieux de l'Olympe & Légendes ⚡
- **Source** : `content/monde3_dieux.py:71`
- **Question** : *Quelle était l'arme secrète de Persée pour vaincre Méduse sans croiser ses yeux ?*
- **Explication actuelle (commune)** : « Exactement ! Son bouclier servait de miroir magique pour voir le monstre sans être pétrifié. »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| Un bandeau sur les yeux | **FAUSSE** | Aveuglé de la sorte, le héros n'aurait pas pu porter un coup d'épée précis au monstre. | 16 |
| **Un bouclier miroir poli** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| Une cape d'invisibilité | **FAUSSE** | Être invisible n'empêche pas d'être pétrifié si l'on croise par mégarde son regard dans l'affrontement. | 15 |
| Une flèche empoisonnée | **FAUSSE** | Les flèches empoisonnées sont l'arme légendaire d'Hercule contre l'Hydre, pas celle employée dans ce mythe. | 15 |

### Quiz #7 — [m4-01] Le Grand Mystère : Pourquoi le Latin change la fin des mots ?
- **Monde** : `monde4` — 4 · Les Cas & Travaux d'Hercule 🦁
- **Source** : `content/monde4_cas.py:12`
- **Question** : *En latin, qu'est-ce qui indique le rôle d'un mot dans la phrase ?*
- **Explication actuelle (commune)** : « C'est la terminaison (le cas) qui indique si un mot est Sujet ou COD ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| Sa position au tout début de la phrase | **FAUSSE** | En latin, l'ordre des mots est très libre : le début d'une phrase n'impose aucun rôle grammatical fixe. | 18 |
| **Sa terminaison (son cas)** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| Sa longueur en lettres | **FAUSSE** | Le nombre de lettres d'un mot n'a aucun lien avec sa fonction grammaticale dans la phrase. | 16 |
| La ponctuation | **FAUSSE** | Les Romains de l'Antiquité n'utilisaient ni virgules ni points modernes dans leurs textes manuscrits. | 14 |

### Quiz #8 — [m6-01] Les Rois de l'Arène : Rétiaires et Mirmillons
- **Monde** : `monde6` — 6 · Les Gladiateurs & le Colisée 🛡️
- **Source** : `content/monde6_colisee.py:12`
- **Question** : *Quelle arme redoutable caractérise le gladiateur Rétiaire ?*
- **Explication actuelle (commune)** : « Le Rétiaire combat avec son filet (rete) et son trident ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| Un arc géant | **FAUSSE** | Les gladiateurs s'affrontaient au corps à corps dans l'arène : aucun combattant n'utilisait d'arc de tir. | 16 |
| **Un filet et un trident** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| Une massue de fer | **FAUSSE** | La massue n'était pas l'armement réglementaire de cette catégorie de combattant marin. | 12 |
| Deux longues haches | **FAUSSE** | Les combattants de l'arène maniaient le glaive court, jamais de doubles haches barbares. | 13 |

### Quiz #9 — [m7-01] Les Trésors Cachés : D'où viennent nos mots ?
- **Monde** : `monde7` — 7 · Détective des Mots & Devises 📜
- **Source** : `content/monde7_etymologie.py:12`
- **Question** : *Quel mot latin a donné en français 'aquarium' et 'aquatique' ?*
- **Explication actuelle (commune)** : « Aqua signifie l'eau en latin ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **Aqua (l'eau)** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| Avis (l'oiseau) | **FAUSSE** | Ce mot a donné en français aviation et avicole, qui se rapportent aux oiseaux et au vol. | 17 |
| Ager (le champ) | **FAUSSE** | Ce mot a donné en français agriculture et agraire, désignant la terre cultivée et les campagnes. | 16 |
| Arbor (l'arbre) | **FAUSSE** | Ce mot a donné en français arbre et arboriculture, liés aux végétaux et aux forêts. | 15 |

### Quiz #10 — [m8-01] Le Grand Marché du Forum (Mercatus)
- **Monde** : `monde8` — 8 · La Cité de Rome, Marchés & Vie Quotidienne 🍇
- **Source** : `content/monde8_marche.py:12`
- **Question** : *Que signifie le mot latin 'panis' qui a donné notre mot 'panier' ?*
- **Explication actuelle (commune)** : « Bravo ! 'Panis' est le pain, la nourriture essentielle du citoyen romain ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **Le pain** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| La pomme | **FAUSSE** | Ce fruit se disait malum en latin, racine que l'on retrouve dans certains dialectes anciens. | 15 |
| Le panier | **FAUSSE** | Piège étymologique : ce mot français désignait à l'origine la corbeille servant à transporter cette nourriture. | 16 |
| Le poisson | **FAUSSE** | Cet animal aquatique se disait piscis en latin, qui a donné piscine et pisciculture en français. | 16 |

### Quiz #11 — [m9-01] L'Armement du Légionnaire (Miles)
- **Monde** : `monde9` — 9 · L'Armée Romaine & les Légions 🦅
- **Source** : `content/monde9_legion.py:12`
- **Question** : *Comment s'appelle le grand bouclier rectangulaire du soldat romain ?*
- **Explication actuelle (commune)** : « C'est bien le Scutum, qui protégeait presque tout le corps du légionnaire ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **Le Scutum** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| Le Pilum | **FAUSSE** | C'est le javelot lourd lancé par le soldat romain avant de charger au corps à corps. | 16 |
| Le Gladius | **FAUSSE** | C'est l'épée courte à double tranchant servant à frapper dans les rangs serrés. | 13 |
| La Galea | **FAUSSE** | C'est le casque de bronze ou de fer qui protégeait la tête du soldat. | 14 |

### Quiz #12 — [m10-01] Pégase le Cheval Ailé (Pegasus)
- **Monde** : `monde10` — 10 · Monstres Fabuleux & Métamorphoses 🐉
- **Source** : `content/monde10_monstres.py:12`
- **Question** : *Quel monstre crachant le feu le héros Bellérophon a-t-il terrassé grâce à Pégase ?*
- **Explication actuelle (commune)** : « Exactement ! La Chimère fut vaincue d'en haut par les flèches de Bellérophon ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **La Chimère** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| Le Minotaure | **FAUSSE** | Cet homme à corps de taureau a été vaincu par Thésée au fond du labyrinthe crétois. | 16 |
| Le Sphinx | **FAUSSE** | Cette créature posant des énigmes aux voyageurs a été défiée par Œdipe près de Thèbes. | 15 |
| L'Hydre | **FAUSSE** | Ce monstre aquatique dont les têtes repoussaient a été combattu par Hercule à Lerne. | 14 |

### Quiz #13 — [m11-01] Horatius Coclès seul sur le pont
- **Monde** : `monde11` — 11 · Les Héros de la République 🛡️
- **Source** : `content/monde11_heros.py:13`
- **Question** : *Quel acte héroïque a accompli Horatius Coclès pour sauver Rome ?*
- **Explication actuelle (commune)** : « Coclès est resté seul face à toute l'armée ennemie sur le pont Sublicius ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **Il a retenu seul l'armée ennemie sur un pont pendant que ses compagnons le coupaient** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| Il a tué le roi Porsenna dans sa tente | **FAUSSE** | C'est l'exploit de Mucius Scaevola, qui a ensuite brûlé sa main droite devant l'ennemi. | 14 |
| Il a franchi les Alpes avec des éléphants | **FAUSSE** | C'est le général carthaginois Hannibal Barca qui a traversé les montagnes avec ses bêtes. | 14 |
| Il a construit la muraille de Rome en une seule nuit | **FAUSSE** | Confusion : la muraille primitive remonte à Romulus et aux rois au fil des siècles. | 15 |

### Quiz #14 — [m12-01] La 3ème Déclinaison : Les Rois et les Consuls
- **Monde** : `monde12` — 12 · Le Sénat et le Peuple (SPQR) 🏛️
- **Source** : `content/monde12_spqr.py:13`
- **Question** : *À quelle terminaison du génitif singulier reconnaît-on un nom de la 3ème déclinaison ?*
- **Explication actuelle (commune)** : « Exactement ! Le génitif singulier en -is est la signature absolue de la 3e déclinaison ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **En -IS (ex: regis, ducis)** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| En -AE (ex: rosae) | **FAUSSE** | Cette terminaison au deuxième cas caractérise les noms féminins de la première déclinaison. | 13 |
| En -I (ex: domini) | **FAUSSE** | Cette désinence caractérise les noms masculins et neutres de la deuxième déclinaison. | 12 |
| En -UM (ex: templi) | **FAUSSE** | Cette finale marque le sujet neutre ou le complément d'objet, pas ce deuxième cas singulier. | 15 |

### Quiz #15 — [m13-01] Les Noms en -I : Civis et Navis
- **Monde** : `monde13` — 13 · Mare Nostrum & Les Conquêtes ⛵
- **Source** : `content/monde13_marenostrum.py:13`
- **Question** : *Quel est le génitif pluriel de 'navis, navis' (le navire) ?*
- **Explication actuelle (commune)** : « Les thèmes en -i font leur génitif pluriel en -ium ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **Navium (des navires)** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| Navum | **FAUSSE** | Tu as oublié la voyelle du radical : ce nom parisyllabique conserve son i caractéristique. | 15 |
| Navibus | **FAUSSE** | Cette finale en -ibus sert au troisième et au sixième cas pluriels, pas à la possession. | 16 |
| Navarum | **FAUSSE** | Cette terminaison appartient exclusivement aux noms de la première déclinaison comme rosa. | 12 |

### Quiz #16 — [m14-01] Les Adjectifs de 2ème Classe : Fortis et Ingens
- **Monde** : `monde14` — 14 · Les Légions en Marche 🦅
- **Source** : `content/monde14_legions.py:14`
- **Question** : *Comment s'accorde l'adjectif 'fortis' avec 'miles' (soldat, masculin singulier) ?*
- **Explication actuelle (commune)** : « Au masculin singulier nominatif, l'adjectif est 'fortis' : miles fortis ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **Miles fortis** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| Miles fortus | **FAUSSE** | Cette finale inventée n'existe pas : les adjectifs de cette classe ne se terminent pas en -us. | 17 |
| Miles fortum | **FAUSSE** | Cette désinence en -um marquerait le complément d'objet singulier ou le genre neutre. | 13 |
| Miles forte | **FAUSSE** | Cette terminaison en -e est réservée au genre neutre (comme mare), or ce nom est masculin. | 16 |

### Quiz #17 — [m15-01] Le Suffixe Magique de l'Imparfait : -BA-
- **Monde** : `monde15` — 15 · Récits d'Autrefois : L'Imparfait 📜
- **Source** : `content/monde15_imparfait.py:14`
- **Question** : *Quel son caractéristique s'intercale dans TOUS les verbes réguliers à l'imparfait latin ?*
- **Explication actuelle (commune)** : « Le suffixe -ba- est la marque universelle de l'imparfait régulier latin ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **-BA- (ex: amabam, legebat)** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| -VI- | **FAUSSE** | Cet élément apparaît souvent dans le radical du temps de l'action achevée, comme dans amavit. | 15 |
| -IS- | **FAUSSE** | Ce groupe de lettres sert à former le plus-que-parfait ou des désinences nominales, pas ce temps. | 16 |
| -UR- | **FAUSSE** | Cette syllabe sert à marquer la voix passive ou le futur des participes, pas ce temps. | 16 |

### Quiz #18 — [m16-01] Le Parfait : L'Action Accomplie
- **Monde** : `monde16` — 16 · Veni, Vidi, Vici : Le Parfait ⚡
- **Source** : `content/monde16_parfait.py:15`
- **Question** : *Quelle est la désinence de la 3e personne du singulier au parfait (il/elle a fait) ?*
- **Explication actuelle (commune)** : « La 3e personne du singulier du parfait se termine toujours par -IT ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **-IT (ex: amavit, vicit)** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| -AT | **FAUSSE** | Cette finale est la marque de la troisième personne du présent pour le premier groupe verbal. | 16 |
| -ET | **FAUSSE** | Cette désinence correspond au présent pour les verbes du deuxième groupe comme monere. | 13 |
| -BA | **FAUSSE** | Ce suffixe tronqué marque le temps de la description dans le passé, pas l'action accomplie. | 15 |

### Quiz #19 — [m17-01] Le Futur de l'Indicatif : Amabo & Legam
- **Monde** : `monde17` — 17 · César et la Guerre des Gaules 🏹
- **Source** : `content/monde17_cesar.py:14`
- **Question** : *Que signifie la forme 'amabit' au futur ?*
- **Explication actuelle (commune)** : « Le suffixe -bi- avec le -t de 3e personne singulier indique le futur : il aimera ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **Il aimera** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| Il aimait | **FAUSSE** | Cette traduction correspond au temps de la description (amabat), reconnaissable à son suffixe en -ba-. | 15 |
| Il aima | **FAUSSE** | Cette traduction correspond au temps de l'action achevée (amavit), pas à ce temps à venir. | 15 |
| Qu'il aime | **FAUSSE** | Cette traduction exprime un souhait ou un ordre au subjonctif (amet), pas une certitude future. | 15 |

### Quiz #20 — [m18-01] La Fin de la République et les Ides de Mars
- **Monde** : `monde18` — 18 · Le Grand Triomphe de la République 👑
- **Source** : `content/monde18_triomphe_rep.py:14`
- **Question** : *Que signifient les derniers mots attribués à César : 'Tu quoque, mi fili' ?*
- **Explication actuelle (commune)** : « Tu = toi, quoque = aussi, mi fili = mon fils (au vocatif) ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **Toi aussi, mon fils !** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| Tue-les tous, mon fils ! | **FAUSSE** | Faux ami phonétique entre le pronom personnel latin signifiant toi et le verbe français. | 14 |
| Adieu, peuple de Rome ! | **FAUSSE** | Cette apostrophe finale s'adresse directement à Brutus, pas à l'ensemble des citoyens de la cité. | 15 |
| La République est sauvée ! | **FAUSSE** | C'est le cri des républicains conjurés après l'attentat, pas la parole du dictateur blessé. | 14 |

### Quiz #21 — [m19-01] La 4ème Déclinaison : Manus & Exercitus
- **Monde** : `monde19` — 19 · La Paix d'Auguste (Pax Romana) 🏛️
- **Source** : `content/monde19_auguste.py:13`
- **Question** : *Quelle est la désinence du génitif singulier de la 4ème déclinaison (ex: manus, exercitus) ?*
- **Explication actuelle (commune)** : « La 4e déclinaison se caractérise par son génitif singulier en -US ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **-US (ex: manus, exercitus)** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| -IS | **FAUSSE** | Cette désinence de possession au singulier caractérise les noms de la troisième déclinaison. | 13 |
| -AE | **FAUSSE** | Cette voyelle double indique le complément du nom singulier pour la première déclinaison. | 13 |
| -I | **FAUSSE** | Cette finale marque la possession au singulier pour la deuxième déclinaison comme dominus. | 13 |

### Quiz #22 — [m20-01] Le Pronom Relatif : Qui, Quae, Quod
- **Monde** : `monde20` — 20 · Les Chemins de l'Empire 🛣️
- **Source** : `content/monde20_chemins.py:13`
- **Question** : *Quel pronom relatif masculin singulier utilise-t-on pour le sujet 'le soldat qui combat' (miles ...) ?*
- **Explication actuelle (commune)** : « Pour un nom masculin singulier sujet, on emploie 'qui' : miles qui pugnat ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **QUI (miles qui pugnat)** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| QUAE | **FAUSSE** | Cette forme est le pronom relatif au genre féminin, comme dans femina quae cantat. | 14 |
| QUOD | **FAUSSE** | Cette forme est réservée au genre neutre singulier, par exemple templum quod stat. | 13 |
| QUEM | **FAUSSE** | Cette forme masculine est au cas complément d'objet direct : elle ne peut pas être sujet. | 16 |

### Quiz #23 — [m21-01] Le Participe Parfait Passif (PPP)
- **Monde** : `monde21` — 21 · Sous la Cendre du Vésuve 🌋
- **Source** : `content/monde21_pompei.py:14`
- **Question** : *Que signifie le participe parfait passif 'urbs capta' (urbs = la ville) ?*
- **Explication actuelle (commune)** : « Capta est le PPP féminin s'accordant avec urbs : la ville ayant été prise / capturée. »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **La ville capturée / prise** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| La ville qui capture | **FAUSSE** | Le sens serait actif, or ce participe passif exprime que la cité subit l'assaut. | 14 |
| Capturer la ville | **FAUSSE** | Cette tournure utilise un infinitif, alors que ce participe s'accorde comme un adjectif avec la cité. | 16 |
| La ville libre | **FAUSSE** | Ce mot vient du verbe prendre ou saisir : il indique une conquête militaire, pas l'affranchissement. | 16 |

### Quiz #24 — [m22-01] Qu'est-ce que l'Ablatif Absolu ?
- **Monde** : `monde22` — 22 · Le Secret de l'Ablatif Absolu 📜
- **Source** : `content/monde22_ablatif_absolu.py:13`
- **Question** : *De quoi est composé un ablatif absolu classique ?*
- **Explication actuelle (commune)** : « Nom à l'ablatif + participe à l'ablatif forme la proposition absolue ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **D'un nom à l'ablatif et d'un participe à l'ablatif** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| D'un verbe à l'infinitif et d'un adjectif au nominatif | **FAUSSE** | L'infinitif s'emploie après un verbe déclaratif, pas dans cette proposition circonstancielle autonome. | 12 |
| D'un nom au génitif avec une préposition | **FAUSSE** | Cette tournure autonome est détachée de la phrase principale et n'emploie jamais de préposition introductive. | 15 |
| D'un verbe au futur et d'un adverbe | **FAUSSE** | Cette structure subordonnée utilise un participe en accord, jamais un verbe conjugué au futur. | 14 |

### Quiz #25 — [m23-01] La Voix Passive : Quand le Sujet Subit l'Action
- **Monde** : `monde23` — 23 · Les Échos du Forum : La Voix Passive 🏛️
- **Source** : `content/monde23_passif.py:14`
- **Question** : *Quelle est la désinence de 3e personne du singulier au passif (ex: 'il est aimé') ?*
- **Explication actuelle (commune)** : « La terminaison -tur indique la 3e personne singulier passive : amatur = il est aimé. »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **-TUR (ex: amatur, laudatur)** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| -T | **FAUSSE** | Cette consonne seule marque la voix active où le sujet accomplit lui-même l'action. | 13 |
| -NTUR | **FAUSSE** | Cette terminaison indique un sujet pluriel (ils ou elles), pas un sujet singulier. | 13 |
| -RIS | **FAUSSE** | Cette finale s'emploie pour la deuxième personne du singulier (tu es félicité). | 12 |

### Quiz #26 — [m24-01] Le Mystère du « QUE » Disparu !
- **Monde** : `monde24` — 24 · La Proposition Infinitive 🗣️
- **Source** : `content/monde24_infinitive.py:13`
- **Question** : *Comment se construisent le sujet et le verbe d'une proposition infinitive en latin ?*
- **Explication actuelle (commune)** : « C'est la règle d'or : Sujet à l'Accusatif + Verbe à l'Infinitif ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **Sujet à l'Accusatif + Verbe à l'Infinitif** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| Sujet au Nominatif + Verbe au Passif | **FAUSSE** | Dans cette subordonnée, le sujet ne reste pas au cas sujet habituel de la principale. | 15 |
| Sujet à l'Ablatif + Verbe au Présent | **FAUSSE** | Le verbe de cette construction subordonnée doit être au mode impersonnel, pas conjugué au présent. | 15 |
| Sujet au Génitif + Verbe au Futur | **FAUSSE** | Le cas du complément du nom ne peut jamais introduire le sujet d'une telle proposition. | 15 |

### Quiz #27 — [m25-01] L'Énéide de Virgile : Le Chant des Armes et du Héros
- **Monde** : `monde25` — 25 · L'Or des Poètes : Virgile & Ovide 📜
- **Source** : `content/monde25_poetes.py:15`
- **Question** : *Quel poète romain a composé l'Énéide sous le règne d'Auguste ?*
- **Explication actuelle (commune)** : « C'est le poète Virgile qui a écrit les 12 chants de l'Énéide ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **Virgile (Publius Vergilius Maro)** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| Ovide | **FAUSSE** | Cet auteur a composé les Métamorphoses et L'Art d'aimer, pas cette grande épopée nationale. | 14 |
| Homère | **FAUSSE** | Cet auteur légendaire a écrit en grec l'Iliade et l'Odyssée bien avant la fondation impériale. | 15 |
| Cicéron | **FAUSSE** | Ce grand personnage républicain était orateur et philosophe, mais pas ce grand poète. | 13 |

### Quiz #28 — [m26-01] La Grande Synthèse du Cycle 4
- **Monde** : `monde26` — 26 · Le Grand Triomphe du Collège 👑
- **Source** : `content/monde26_triomphe_cycle4.py:14`
- **Question** : *Quelle construction réunit un nom et un participe tous deux au cas ablatif sans mot de liaison ?*
- **Explication actuelle (commune)** : « C'est l'Ablatif Absolu, véritable marque de fabrique du latin classique ! »

| Option | Statut | Explication proposée pour l'élève | Mots |
|---|---|---|:---:|
| **L'Ablatif Absolu (ex: Caesare duce, urbe capta)** | **JUSTE (Bonne réponse)** | *(Explication actuelle ou message de félicitations)* | — |
| La Proposition Infinitive | **FAUSSE** | Cette construction déclarative associe un sujet au cas complément et un verbe à l'infinitif. | 14 |
| Le Comparatif de supériorité | **FAUSSE** | Cette forme grammaticale sert à graduer un adjectif avec le suffixe -ior, pas un participe détaché. | 16 |
| Le Vocatif d'apostrophe | **FAUSSE** | Ce cas sert uniquement à interpeller ou appeler une personne dans le dialogue. | 13 |

---

## 2. Options signalées comme absurdes ou peu plausibles

Ces options ne correspondent à aucune confusion pédagogique vraisemblable chez un collégien et méritent d'être remplacées par l'architecte :

### • [m4-01] Quiz #7 : « Sa longueur en lettres »
- **Monde** : `monde4`
- **Diagnostic** : Absurde : la longueur d'un mot n'a jamais déterminé une fonction grammaticale dans aucune langue humaine. Aucun collégien ne fait une telle hypothèse.
- **Proposition de remplacement** : « La préposition placée devant » (confusion naturelle avec le français où la fonction est souvent marquée par une préposition : à, de, par...) ou « Le genre masculin ou féminin ».

### • [m6-01] Quiz #8 : « Un arc géant »
- **Monde** : `monde6`
- **Diagnostic** : Peu plausible / fantaisiste : les gladiateurs combattaient au corps à corps dans l'arène. Il n'existait aucune classe de gladiateur archer au Colisée.
- **Proposition de remplacement** : « Le glaive court (gladius) et le grand bouclier » (armement du mirmillon/secutor opposé au rétiaire) ou « Le casque fermé sans filet ».

### • [m6-01] Quiz #8 : « Deux longues haches »
- **Monde** : `monde6`
- **Diagnostic** : Fantaisiste / cliché barbare : aucun type de gladiateur romain ne combattait avec deux haches de guerre.
- **Proposition de remplacement** : « Le poignard courbe (sica) et le petit bouclier » (armement du thrace) ou « Une lance et un bouclier rond » (hoplomaque).

### • [m11-01] Quiz #13 : « Il a construit la muraille de Rome en une seule nuit »
- **Monde** : `monde11`
- **Diagnostic** : Cliché de conte merveilleux sans lien avec l'histoire républicaine. Le monde 11 enseigne justement Coclès (m11-01), Scaevola (m11-02) et Cloélie (m11-03).
- **Proposition de remplacement** : « Il a traversé le Tibre à la nage avec les jeunes otages » (exploit héroïque de Cloélie dans ce même monde) ou « Il a négocié un traité de paix avec Porsenna ».

---

## 3. Rapport de validation automatique du script

Le script de contrôle `scratch/verify_quiz_propositions.py` a vérifié l'intégralité des 84 mauvaises options :

```text
=== VERIFICATION DES PROPOSITIONS ===
Total mauvaises options testees: 84
Total erreurs detectees: 0
SUCCESS: TOUTES LES VERIFICATIONS SONT VALIDEES !
   1. 84 mauvaises options couvertes (3 par quiz * 28 quiz).
   2. Chaque phrase fait strictement <= 20 mots.
   3. Aucune phrase ne contient le texte de la bonne reponse.
```

Toutes les contraintes pédagogiques et techniques sont rigoureusement satisfaites.