# Idées de Jeu Venues d'Ailleurs, Adaptées au Latin (Sans Publicité, Sans Compte, Sans Internet)

**Date** : 24 octobre 2026  
**Auteur** : Assistant de développement Ludus Latinus  
**Cadre** : Tâche T63 du plan qualité `docs/TACHES.md`  
**Périmètre technique** : 100 % hors-ligne, zéro compte, zéro publicité, conforme aux exigences du programme Google Play Familles et aux programmes de Langues et Cultures de l'Antiquité (LCA) du collège (cycle 4 : 5e, 4e, 3e).  
**Documents de référence consultés** :
- `docs/audits/analyse_best_seller.md` (audit architectural du 17/10/2026)
- `docs/audits/inventaire_fonctionnel.md` (inventaire des 113 leçons et 9 jeux existants)
- `docs/audits/semaine_eleve.md` (économie des sesterces et progression de l'élève)

---

## 1. Étude Comparative des 6 Applications de Référence

Pour comprendre ce qui captive et fidélise les collégiens de 11 à 15 ans tout en respectant l'éthique de protection des mineurs, 6 applications éducatives majeures du marché mondial ont été analysées à travers leurs mécaniques, leurs boucles de jeu, et les retours d'utilisateurs (élèves, parents, professeurs).

| N° | Application & Éditeur | Catégorie & Lien officiel | Ce qu'elle fait remarquablement bien (Forces) | Ce que les avis détestent & ce que nous écartons |
| :---: | :--- | :--- | :--- | :--- |
| **1** | **Duolingo**<br>*(Duolingo Inc.)* | Langues vivantes<br>[Fiche Google Play](https://play.google.com/store/apps/details?id=com.duolingo) | **Micro-sessions à friction minimale (3 min)** : leçons découpées en bouchées cognitives. Le sentiment de progression continue avec la flamme de série (*streak*) qui ancre une routine quotidienne sans effort perçu. | **Écarté** : Le système de cœurs/vies punitif qui bloque l'élève lorsqu'il fait des erreurs (ou le force à payer/regarder des pubs) ; les ligues compétitives anxiogènes où les élèves "farment" des leçons bébés le dimanche soir au détriment de l'apprentissage réel ; les notifications culpabilisantes de la mascotte. |
| **2** | **Prodigy Math**<br>*(Prodigy Education)* | Mathématiques / RPG<br>[Fiche Google Play](https://play.google.com/store/apps/details?id=com.prodigygame.prodigy) | **Enrobage RPG immersif** : combats magiques au tour par tour façon *Pokémon* où chaque sort nécessite de résoudre un défi. Personnalisation poussée de l'avatar et collection de familiers qui valorisent le statut social du joueur. | **Écarté** : Ratio temps de jeu / temps d'apprentissage désastreux (80 % de balade dans les menus pour 20 % de travail réel) ; esthétique jugée "bébé" qui lasse dès 12-13 ans ; clic au hasard pour passer le combat ; paywall agressif d'abonnement payant pour obtenir les meilleurs familiers. |
| **3** | **DragonBox**<br>*(Kahoot! / WeWantToKnow)* | Algèbre & Géométrie<br>[Fiche Google Play](https://play.google.com/store/apps/details?id=com.wewanttoknow.Algebra) | **Pédagogie invisible (*stealth learning*)** : les règles mathématiques sont intégrées dans la manipulation physique (plateaux de balance, cartes inverses qui s'annihilent). L'élève découvre les concepts sans jargon intimidant ni peur de l'échec. | **Écarté** : Modèle d'achat coûteux ou lié à l'écosystème d'abonnement Kahoot! ; rejouabilité quasi nulle une fois les niveaux terminés (progression linéaire sans défis quotidiens renouvelables). |
| **4** | **Kahoot!** *(Mode Challenge Solo)*<br>*(Kahoot ASA)* | Quiz interactif<br>[Fiche Google Play](https://play.google.com/store/apps/details?id=no.mobitroll.kahoot.android) | **Adrénaline ludique et défi personnel** : format chrono ultra-rapide (2 min). La possibilité de rejouer immédiatement pour battre son "fantôme" ou son record personnel engendre une relecture spontanée des questions ratées. | **Écarté** : Chronomètre trop oppressant qui favorise le clic réflexe au détriment de la lecture réfléchie ; dépendance impérative à Internet et aux serveurs ; harcèlement promotionnel pour souscrire aux comptes Premium. |
| **5** | **Seterra / GeoGuessr**<br>*(GeoGuessr AB)* | Géographie cartographique<br>[Fiche Google Play](https://play.google.com/store/apps/details?id=com.geoguessr.seterra) | **Simplicité radicale et mémoire spatiale** : pointer directement sur une carte muette. Boucle essai-erreur immédiate non culpabilisante (vert au 1er clic, jaune au 2e, correction automatique clignotante au 3e). Objectif 100 % d'exactitude très gratifiant. | **Écarté** : Manque d'explication textuelle/historique (mémorisation spatiale brute sans contextualisation) ; micro-zones tactiles frustrantes sur petit écran pour les îles ou petites régions ("fat finger"). |
| **6** | **Wordle / Pédantix / SUTOM**<br>*(The New York Times / Communautaire)* | Déduction lexicale quotidienne<br>[Site officiel NYT Wordle](https://www.nytimes.com/games/wordle/index.html) | **Scarcité psychologique et rituel partagé** : une seule énigme par jour, 3 minutes maximum. Tout le monde a la même énigme. Grille de partage sans spoiler (🟩🟨⬛) qui crée une saine émulation familiale et entre pairs sans aucune compétition toxique. | **Écarté** : Frustration si un mot est hors du vocabulaire scolaire sans indice contextuel (nécessite dans notre cas des indices étymologiques pour guider l'élève). |

---

## 2. Mécanismes Toxiques Explicitement Écartés pour les Collégiens

Les collégiens (11 à 15 ans) sont dans une phase de construction identitaire et d'hypersensibilité au regard des pairs et à la frustration. Pour préserver leur santé mentale, leur temps de sommeil et garantir la confiance absolue des parents et des professeurs, les mécanismes suivants sont **formellement bannis** de Ludus Latinus :

1. **Aucun achat intégré ni monnaie réelle convertible** : les sesterces ne s'acquièrent **que** par l'apprentissage du latin (leçons réussies, jeux Ludi, quête quotidienne). Aucun parent ne doit craindre une facture surprise ni voir son enfant frustré par un verrou payant.
2. **Aucune minuterie culpabilisante ni perte de "vies" (système de cœurs)** : dans Duolingo, faire 5 fautes bloque l'utilisateur et l'empêche de s'exercer. En pédagogie, l'erreur est le moteur de l'apprentissage : se tromper en latin (ex. confondre un accusatif et un ablatif) doit générer une explication immédiate, pas une interdiction de jouer.
3. **Aucune ligue sociale à déclassement punitif** : les classements mondiaux hebdomadaires où l'on est rétrogradé le dimanche soir créent une anxiété artificielle et incitent les ados à "tricher" en répétant les exercices les plus basiques pour engranger des points plutôt que d'explorer des notions difficiles.
4. **Aucune publicité ni pistage publicitaire** : aucune interruption vidéo, aucun ciblage publicitaire, aucune donnée personnelle transmise à des tiers. Conforme à 100 % au RGPD et au label Familles Google Play.
5. **Fonctionnement 100 % autonome hors-ligne** : l'élève peut jouer dans le car scolaire, en zone rurale blanche ou sur une tablette de classe sans borne Wi-Fi active.

---

## 3. Les 8 Idées de Jeu Adaptées au Latin

Chacune de ces idées a été conçue pour s'intégrer dans l'architecture existante de *Ludus Latinus*, en réutilisant le dataset (113 leçons, dictionnaire du Thesaurus de 450+ mots, citations du Panthéon) sans dépendance réseau.

Elles sont classées ci-dessous par **ratio décroissant Gain / Effort**.

---

### Idée 1 : "Aenigma Diei" — L'Énigme Quotidienne du Mot Romain
*Inspiré de Wordle, Pédantix et SUTOM*

- **Origine** : Le rituel universel de l'énigme quotidienne de 3 minutes à essais limités (Wordle).
- **À quoi cela ressemble dans Ludus Latinus** :
  - Dans la *Bibliotheca*, une nouvelle tuile dorée : **« Aenigma Diei » (L'Énigme du Jour)**.
  - Chaque jour civil, une énigme unique est tirée du dictionnaire du *Thesaurus* via une fonction pseudo-aléatoire basée sur la date (`DateTime.now().year * 1000 + dayOfYear`), garantissant que **tous les élèves ont exactement le même mot le même jour**, même hors-ligne.
  - L'élève a 6 essais pour deviner un mot latin de 5 à 7 lettres (ex. `TEMPLUM`, `SENATUS`, `GLADIUS`).
  - Après chaque essai, les lettres changent de couleur :
    - 🟩 **Pourpre impérial / Vert laurier** : lettre bien placée.
    - 🟨 **Or antique** : lettre présente dans le mot mais mal placée.
    - ⬛ **Marbre gris** : lettre absente.
  - En cas d'hésitation, un bouton d'indice étymologique révèle un dérivé français (ex. pour `AQUA` : *"A donné en français : aquarium, aquatique"*).
  - À la victoire : +15 HS, ajout du mot au carnet, et possibilité de copier la grille d'émojis dans le presse-papier (`🏛️🟨🟩`) pour la montrer à ses camarades ou à son professeur.
- **Le latin pratiqué** : Orthographe exacte des lemmes latins, distinction des radicaux et des désinences, mémorisation active des racines étymologiques françaises.
- **Évaluation** :
  - **Gain** : **Énorme** (génère un rituel quotidien court et fédérateur en classe de latin, taux de retour quotidien maximal sans aucune anxiété).
  - **Effort** : **Faible** (algorithme Wordle très simple en Dart, s'appuie sur la liste de mots existante du Thesaurus).
  - **Risque** : **Minime** (aucun impact sur la sauvegarde, simple modal ou écran autonome).

---

### Idée 2 : "Tabula Geographica" — La Carte des Conquêtes Méditerranéennes
*Inspiré de Seterra et GeoGuessr*

- **Origine** : Les quiz d'identification spatiale instantanée sur carte muette (Seterra).
- **À quoi cela ressemble dans Ludus Latinus** :
  - Accessible dans l'onglet *Ludi* ou depuis la *Via Appia*.
  - Une carte vectorielle haute définition du monde antique (*Mare Nostrum*) présentant les contours des provinces romaines (*Gallia*, *Hispania*, *Britannia*, *Aegyptus*, *Asia*, *Achaia*, *Sicilia*) et les grandes cités antiques (*Roma*, *Carthago*, *Athenae*, *Alexandria*, *Pompeii*).
  - L'oracle affiche une consigne en latin : *"Ubi est Carthago ?"* ou *"Monstre-moi la Gallia Narbonensis"*.
  - L'élève touche la zone géographique sur la carte :
    - Au 1er clic correct : vert étincelant (+10 HS).
    - Au 2e clic : jaune (+5 HS).
    - Au 3e clic : la bonne zone clignote en rouge bordeaux avec son nom et une brève anecdote culturelle.
  - Sessions de 10 questions en 60 secondes avec score de précision en pourcentage.
- **Le latin pratiqué** : Géographie du monde romain (au cœur des repères historiques et géographiques du programme de 5e/4e/3e de LCA), toponymie latine antique, désinences de l'accusatif de lieu sans préposition (*Romam ire*, *Carthagine vivere*).
- **Évaluation** :
  - **Gain** : **Très Élevé** (extrêmement plébiscité par les professeurs de lettres classiques et d'histoire, comble le manque d'activités visuelles cartographiques dans l'appli).
  - **Effort** : **Faible à Moyen** (carte SVG vectorielle par calques réutilisant l'infrastructure de la Via Appia).
  - **Risque** : **Minime** (doit veiller à la taille des cibles tactiles $\ge 48$ dp sur smartphone pour éviter le "fat finger").

---

### Idée 3 : "Tempus Fugit : Les Paires Éclair" — Défi de Vitesse Lexicale
*Inspiré de Quizlet Match et Duolingo Match Madness*

- **Origine** : Les jeux d'appariement tactile chronométrés où les paires associées s'évaporent de l'écran.
- **À quoi cela ressemble dans Ludus Latinus** :
  - Accessible dans *Memoria Velox* ou *Ludi* comme entraînement d'agilité mentale.
  - L'écran affiche 10 tablettes de cire réparties en deux colonnes : 5 mots latins à gauche, 5 traductions françaises à droite (mélangées aléatoirement, issues des leçons déjà terminées par l'élève).
  - L'élève touche un mot latin puis son sens français :
    - Si la paire est correcte : son cristallin de sesterces, effet de particules dorées, les deux tablettes disparaissent immédiatement et deux nouvelles apparaissent pour les remplacer.
    - Si la paire est fausse : vibration haptique brève et les tablettes rougissent pendant 0,5 seconde sans bloquer le jeu.
  - Défi en 3 manches de 45 secondes : associer 15, 20 puis 25 paires pour gagner la "Palme de Célérité" et 15 HS.
- **Le latin pratiqué** : Automatisation immédiate du vocabulaire usuel du collège (passage de la mémoire lente de décodage à la reconnaissance lexicale instantanée).
- **Évaluation** :
  - **Gain** : **Élevé** (jeu très dynamique, très apprécié des ados avant une interrogation de vocabulaire au collège).
  - **Effort** : **Faible** (logique d'appariement pure en Flutter, pioche directement dans `thesaurus.dictionnaire`).
  - **Risque** : **Minime**.

---

### Idée 4 : "L'Épreuve de l'Ombre" (Umbra) — Le Défi Fantôme Asynchrone
*Inspiré de Kahoot! Challenge Mode et des fantômes de Mario Kart*

- **Origine** : Se mesurer à son propre fantôme ou à un chrono de référence enregistré, sans multijoueur en direct.
- **À quoi cela ressemble dans Ludus Latinus** :
  - Sur chaque monde conquis de la Via Appia, l'élève peut lancer le **« Défi de l'Ombre » (Certamen Umbrae)**.
  - L'écran présente un parcours de 8 questions rapides de révision. En haut de l'écran, une jauge montre deux figurines qui avancent :
    - Le joueur (figurine de légionnaire).
    - L'Ombre (*Umbra*), silhouette translucide qui avance à la vitesse de son meilleur record personnel enregistré sur cet exercice (ou d'un temps standard prédéfini "Miles Romanus" lors du 1er essai).
  - L'élève doit répondre vite et juste pour que son légionnaire franchisse la ligne d'arrivée avant l'Ombre.
  - Battre son Ombre décerne le laurier d'or du monde et enregistre le nouveau temps record dans la sauvegarde locale.
- **Le latin pratiqué** : Révision globale des leçons et des exercices d'un monde entier, réduction du temps de doute grammatical.
- **Évaluation** :
  - **Gain** : **Élevé** (donne une immense valeur de rejouabilité aux 26 mondes déjà terminés, sans inventer de nouveau contenu).
  - **Effort** : **Faible** (réutilise le moteur de questions existant de `lesson_screen.dart` en ajoutant un simple minuteur et un stockage du record en millisecondes).
  - **Risque** : **Minime** (hors-ligne complet, pas de comparaison publique avec d'autres élèves).

---

### Idée 5 : "La Balance de la Phrase" — Puzzles d'Accords Syntaxiques Visuels
*Inspiré de DragonBox Algebra*

- **Origine** : La manipulation visuelle d'équilibre où les règles abstraites deviennent des poids physiques palpables (DragonBox).
- **À quoi cela ressemble dans Ludus Latinus** :
  - Dans *Bibliotheca*, un atelier interactif : **« Libra Grammatica » (La Balance Grammaticale)**.
  - Au centre de l'écran, une balance romaine stylisée avec deux plateaux en bronze.
  - L'élève doit équilibrer la phrase :
    - *Niveau 1 (Accord sujet-verbe)* : Sur le plateau gauche est posé `Discipuli` (Nominatif pluriel, poids = 2). Sur le plateau droit, le verbe proposé `scribit` (singulier, poids = 1) fait pencher la balance vers la gauche. L'élève fait glisser la bonne désinence `-unt` ou le bon verbe `scribunt` pour rétablir l'équilibre horizontal et déclencher le tintement de la cloche romaine.
    - *Niveau 2 (Transitivité et COD)* : Un verbe transitif (`amat`, `videt`) crée un crochet sous le plateau droit qui nécessite d'accrocher un poids Accusatif (`puellam`). Si l'élève accroche un ablatif (`puella`), le crochet glisse et tombe.
- **Le latin pratiqué** : La logique fondamentale des cas et des fonctions grammaticales latines (accord sujet/verbe, fonction COD à l'accusatif, attribut du sujet au nominatif), souvent ressentie comme rébarbative et abstraite par les collégiens.
- **Évaluation** :
  - **Gain** : **Très Élevé** (débloque les élèves fâchés avec la grammaire traditionnelle en leur faisant manipuler concrètement les liens de dépendance).
  - **Effort** : **Moyen** (création d'un widget Flutter d'animation physique 2D avec balance à bascule et glisser-déposer).
  - **Risque** : **Faible** (veiller à ce que les animations restent fluides sur appareils d'entrée de gamme).

---

### Idée 6 : "La Fabrique de Dérivés" — L'Atelier d'Alchimie Étymologique
*Inspiré de Little Alchemy et Infinite Craft*

- **Origine** : Les jeux combinatoires où l'on assemble des briques élémentaires pour créer de nouveaux objets et débloquer une encyclopédie.
- **À quoi cela ressemble dans Ludus Latinus** :
  - Dans l'Atelier de la *Bibliotheca*, une forge romaine : **« Officina Verborum » (La Fabrique des Mots)**.
  - L'élève dispose d'une enclume au centre, d'un tiroir de **radicaux latins** (ex. `DUCERE` = conduire, `PORTARE` = porter, `SCRIBERE` = écrire) et d'un tiroir de **préfixes romains** (`IN-`, `EX-`, `CON-`, `PRO-`, `RE-`, `TRANS-`) et de **suffixes** (`-TOR`, `-TIO`).
  - L'élève fait glisser `CON-` + `DUCERE` sur l'enclume et frappe le marteau : cela forge le verbe latin `CONDUCERE` et révèle ses 3 descendants en français moderne : *conduire*, *conducteur*, *conduite*.
  - En associant `PRO-` + `DUCERE`, il forge `PRODUCERE` $\rightarrow$ *produire*, *producteur*, *production*.
  - Un livre d'or recense les 60 mots français forgés au fil de l'aventure, avec une brève note linguistique illustrée.
- **Le latin et le français pratiqués** : Morphologie lexicale, formation des mots par dérivation préfixale et suffixale, passerelle explicite vers l'orthographe du français (ex. comprendre pourquoi *conduction* prend un `c` et *production* aussi grâce à la racine latine).
- **Évaluation** :
  - **Gain** : **Très Élevé** (démontre immédiatement l'utilité du latin pour réussir en français au brevet des collèges ; très valorisé par les enseignants de lettres).
  - **Effort** : **Moyen** (arbre combinatoire de données à définir dans un fichier JSON, interface d'assemblage visuelle).
  - **Risque** : **Minime**.

---

### Idée 7 : "L'Archéologue d'Herculanum" — Déchiffrement de Papyrus Brûlés
*Inspiré de Heaven's Vault et Return of the Obra Dinn*

- **Origine** : Les jeux d'archéologie et d'enquête textuelle où le joueur déduit le sens d'un récit historique en reconstituant des fragments lacunaires.
- **À quoi cela ressemble dans Ludus Latinus** :
  - Dans le menu *Épigraphie & Monuments*, une section : **« Les Rouleaux d'Herculanum »**.
  - L'écran affiche un rouleau de papyrus antique déroulé, dont certains passages ont été abîmés par les cendres du Vésuve (mots effacés ou déchirés). Le texte relate un événement marquant (ex. la lettre de Pline le Jeune sur l'éruption, le discours de Caton l'Ancien, le mythe de Dédale).
  - Trois témoins ou trois fragments de phrases sont proposés pour chaque lacune. En s'appuyant sur les indices de contexte (qui est le sujet ? à quel temps sont les verbes voisins ? quel est le ton de l'orateur ?), l'élève choisit la proposition exacte pour restaurer le parchemin.
  - Une fois le rouleau restauré, il est lu vocalement en latin classique restitué et la traduction française élégante se débloque.
- **Le latin pratiqué** : Lecture de textes suivis authentiques adaptés, compréhension globale d'un récit au-delà de la phrase isolée, culture littéraire et historique romaine.
- **Évaluation** :
  - **Gain** : **Élevé** (prépare idéalement les élèves de 4e et 3e à la version latine de fin de collège et de lycée).
  - **Effort** : **Moyen à Élevé** (rédaction et découpage de 6 à 8 récits historiques latins courts avec leurs indices contextuels).
  - **Risque** : **Faible** (exige un travail éditorial soigné pour ne pas être trop difficile).

---

### Idée 8 : "Lupulus Domi" — Le Compagnon du Foyer Romain
*Inspiré de Pou, Neko Atsume et des Tamagotchis vertueux sans mort*

- **Origine** : L'attachement affectif à un familier virtuel que l'on fait grandir et que l'on personnalise par ses succès quotidiens.
- **À quoi cela ressemble dans Ludus Latinus** :
  - Dans un coin de l'accueil ou de la boutique, un petit jardin romain (*Hortus*) où vit le louveteau *Lupulus* (la mascotte de Ludus Latinus).
  - **Règle bienveillante absolue** : Lupulus ne peut **jamais** mourir, tomber malade ni disparaître en cas d'absence prolongée de l'élève.
  - Chaque activité réussie (leçon, révision Memoria, jeu Ludi) octroie des "offrandes" symboliques : une grappe de raisin, un morceau de viande, un ruban de laine pourpre, une balle en cuir.
  - L'élève peut nourrir Lupulus et lui apprendre de nouveaux tours en latin en touchant des ordres à l'impératif : `Sede !` (Assis !), `Veni !` (Viens !), `Latra !` (Aboie ! $\rightarrow$ *"Bau ! Bau !"*).
  - Lupulus s'équipe des toges, des couronnes ou des médailles achetées à la Taberna et offre chaque matin une citation latine porte-bonheur.
- **Le latin pratiqué** : Vocabulaire de la vie quotidienne antique (animaux, nourriture, ordres à l'impératif, vêtements de la maison romaine).
- **Évaluation** :
  - **Gain** : **Moyen à Élevé** (très fort levier affectif auprès des élèves de 5e/11 ans, humanise l'application).
  - **Effort** : **Moyen** (assets graphiques 2D de la mascotte dans différentes postures, animations légères).
  - **Risque** : **Faible** (veiller à ce que l'interaction reste un bonus rapide et ne devienne pas une distraction chronophage).

---

## 4. Synthèse Stratégique et Recommandation de Classement

Voici le récapitulatif comparatif des 8 propositions, classées par **rapport Gain / Effort** :

| Rang | Idée de jeu | Source / Inspiration | Latin pratiqué | Gain pédagogique & rétention | Effort de dev | Risque |
| :---: | :--- | :--- | :--- | :---: | :---: | :---: |
| **1** | **Aenigma Diei** *(Mot du jour)* | Wordle / SUTOM | Orthographe, vocabulaire, racines étymologiques | **Énorme** | **Faible** | Minime |
| **2** | **Tabula Geographica** *(Carte)* | Seterra / GeoGuessr | Géographie antique, toponymie, cas de lieu | **Très Élevé** | **Faible/Moyen** | Minime |
| **3** | **Tempus Fugit** *(Paires éclair)* | Quizlet Match / Duolingo | Automatisation du vocabulaire clé | **Élevé** | **Faible** | Minime |
| **4** | **Certamen Umbrae** *(Défi fantôme)* | Kahoot! Challenge Solo | Fluidité de lecture, rejouabilité des 26 mondes | **Élevé** | **Faible** | Minime |
| **5** | **Libra Grammatica** *(Balance)* | DragonBox Algebra | Accords sujet-verbe, cas et transitivité du COD | **Très Élevé** | **Moyen** | Faible |
| **6** | **Officina Verborum** *(Dérivés)* | Little Alchemy | Dérivation préfixale/suffixale, liens avec le français | **Très Élevé** | **Moyen** | Minime |
| **7** | **Lupulus Domi** *(Compagnon)* | Pou / Neko Atsume | Vocabulaire du quotidien, impératifs | **Moyen/Élevé** | **Moyen** | Faible |
| **8** | **Papyrus d'Herculanum** *(Enquête)* | Heaven's Vault / Obra Dinn | Compréhension de textes suivis authentiques | **Élevé** | **Moyen/Élevé** | Faible |

### Recommandation pour l'Architecte et Cédric
- **À court terme (MVP & Déploiement Store)** : Prioriser les idées **1 (Aenigma Diei)** et **3 (Tempus Fugit)**. Elles demandent moins de 2 jours de développement cumulés, s'appuient à 100 % sur les dictionnaires et leçons déjà rédigés, et apportent immédiatement les deux boucles de rétention les plus puissantes du jeu éducatif moderne (l'énigme quotidienne rituelle et le défi éclair de vitesse).
- **À moyen terme (Mise à jour majeure V1.1)** : Implémenter l'idée **2 (Tabula Geographica)** et l'idée **5 (Libra Grammatica)** pour enrichir l'offre didactique avec de la manipulation visuelle de premier ordre.
