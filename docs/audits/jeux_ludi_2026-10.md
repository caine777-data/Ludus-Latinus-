# Audit des 8 jeux Ludi (23 octobre 2026) : Plaisir, difficulté et pratique du latin

Audit réalisé le 23 octobre 2026 sur l'émulateur Android **Pixel_Ludus** sur la branche `fix/mobile-publiable-lisible`.  
L'audit précédent du 3 octobre 2026 (`docs/audits/audit_jeux_2026-10-03.md`) datait d'avant la refonte de la Taverne, l'arrivée de la Bataille des Légendes, la refonte des points de vie du Colosseum, l'Album de 32 cartes, le verrouillage progressif du Panthéon et les animations du Circus Maximus.  
Cet audit complet réévalue **l'intégralité des 8 jeux de la section Ludi**, manette en main, à travers **24 parties jouées et mesurées** (3 parties par jeu : une en jouant bien, une en jouant mal, une au hasard).

---

## 1. Méthode, profil et protocole de mesure

- **Profil de test** : Profil de l'élève « Marcus », rang *Aedilis*, 59 leçons terminées sur 119 (Mondes 1 à 13 débloqués), 11 cartes d'album possédées, 1442 HS.
- **Sauvegarde** : Profil initial exporté dans `scratch/t60_profil_avant.json` et restauré à l'identique à la fin des tests.
- **Protocole des 3 parties par jeu** :
  1. *Partie « Bien jouée »* : Réponses correctes rapides, choix de faction/posture/cartes réfléchis, exploitation des règles.
  2. *Partie « Mal jouée »* : Erreurs intentionnelles, mauvaises postures, dépassement de règles.
  3. *Partie « Au hasard »* : Clics aveugles et immédiats sans lecture préalable des consignes ni des questions.
- **Captures d'écran associées** : 16 captures archivées dans `scratch/t60_*` couvrant chaque jeu en action et ses écrans de fin.

---

## 2. Tableau comparatif : Mesures des 24 parties (8 jeux × 3 modes)

| Jeu | Mode de jeu | Durée réelle | Questions de latin | Décisions hors questions | Sesterces gagnés | Peut-on gagner sans latin ? |
|---|---|---|---|---|---|---|
| **Circus Maximus** | Bien joué | 72 s | 6 questions (4 cours, 2 cirque) | 2 (Faction Prasini + Virage corde) | 13 HS (10 × 1.3) | **Non** (Vitesse rivale trop forte) |
| | Mal joué | 86 s | 5 questions | 2 (Faction + Virage heurté) | 0 HS (Défaite) | **Non** |
| | Au hasard | 80 s | 6 questions (~1 bonne par chance) | 2 | 0 HS (Défaite) | **Non** |
| **Colosseum Duellum** | Bien joué | 38 s | 4 questions (voc. récent) | 4 choix de posture (Impetus) | 15 HS (+ série) | **Non** (Boss 200 à 500 PV) |
| | Mal joué | 14 s | 2 questions (2 erreurs) | 2 choix de posture | 0 HS (K.O. en 2 coups) | **Non** |
| | Au hasard | 22 s | 3 questions (1 bonne, 2 erreurs) | 3 choix de posture | 0 HS (K.O.) | **Non** |
| **Alea Iacta Est** | Bien joué | 18 s | 3 calculs en chiffres romains | 2 (Lancer un dé / S'arrêter à XIX) | 15 HS | **Difficilement** (Lecture requise) |
| | Mal joué | 11 s | 0 (Calculs ignorés) | 3 lancers (Dépassement XXIV) | 0 HS (Défaite) | **Non** |
| | Au hasard | 14 s | 0 | 2 clics aléatoires | 0 HS (Gaius gagne) | **Rarement** (~30% hasard pur) |
| **Atelier de César** | Bien joué | 28 s | 1 traduction complète (3 choix) | 1 (Curseur clé rotative) | 10 HS | **Non** (Traduction exigée) |
| | Mal joué | 34 s | 1 question (erreur traduction) | 1 (Curseur clé) | 5 HS (Pénalité) | **Non** |
| | Au hasard | 8 s | 1 question | 1 | 0 HS (Clé fausse) | **Non** (1,3% chance combinée) |
| **Marché de Trajan** | Bien joué | 24 s | 1 calcul de panier (chiffres romains) | 4 dépôts de jetons sur l'étal | 10 HS | **Non** (Monnaies et chiffres) |
| | Mal joué | 19 s | 1 problème | 3 jetons erronés | 0 HS (Client mécontent) | **Non** |
| | Au hasard | 10 s | 1 problème | 3 jetons au hasard | 0 HS (Somme fausse) | **Impossible** |
| **Le Panthéon** | Consultation débloquée | 35 s | 3 devises / épithètes latines lues | 3 choix de cartes (Jupiter, Neptune) | 0 HS (Collection) | *N/A (Encyclopédie)* |
| | Carte verrouillée | 12 s | 1 exigence de monde lue | 1 consultation (Pluton verrouillé) | 0 HS | *N/A* |
| | Au hasard | 8 s | 0 | 1 défilement rapide | 0 HS | *N/A* |
| **Héros & Créatures** | Héros possédé | 42 s | 1 notice mythologique latine | 3 zooms (Romulus, Persée) | 0 HS (Album) | *N/A (Collection)* |
| | Succès en cours | 15 s | 1 condition de succès lue | 1 consultation (Méduse) | 0 HS | *N/A* |
| | Au hasard | 10 s | 0 | 1 balayage | 0 HS | *N/A* |
| **Bataille des Légendes** | Bien joué | 78 s | 4 questions (devises de cartes) | 8 (4 choix cartes + 4 caractéristiques) | 15 HS (+ série) | **Non** (Initiative liée au latin) |
| | Mal joué | 46 s | 3 questions (3 erreurs) | 3 choix de cartes | 0 HS (Défaite 0-3) | **Non** |
| | Au hasard | 52 s | 4 questions (1 bonne au hasard) | 7 | 0 HS (Défaite 1-3) | **Quasiment impossible** |

---

## 3. Revue point par point des 6 défauts de l'audit du 3 octobre 2026

### Défaut 1 : « La Taverne rapporte plus que les leçons, sans rien apprendre »
- **Statut** : **TOTALEMENT CORRIGÉ**.
- **Vérification** : L'ancien système passif de 4 dés avec le « Coup de Vénus » (+50 HS sans effort) a été totalement supprimé. Il a été remplacé par le jeu **« Ad XXI »** (Blackjack antique). Les dés et les totaux s'affichent **exclusivement en chiffres romains** (VII, XIII, XIX...), le gain est aligné sur les autres jeux (10-15 HS, plafonné à 3 parties/jour), et il est indispensable de savoir additionner en chiffres romains pour savoir s'arrêter avant de brûler.

### Défaut 2 : « Trois jeux sur six n'ont plus rien à offrir après quelques séances » (César, Marché, Panthéon)
- **Statut** : **TOTALEMENT CORRIGÉ**.
- **Vérification** :
  - **Atelier de César** : Après les 6 missions scénarisées, un générateur infini de « Messages libres » pioche des phrases en latin authentique directement issues des leçons terminées par l'élève.
  - **Marché de Trajan** : Après les étals de base, un générateur procédural de clients et d'articles génère des paniers d'achats infinis payés comme une partie quotidienne.
  - **Le Panthéon** : Les cartes ne sont plus toutes visibles d'office ! Une seule carte est attribuée par monde terminé sur la Via Appia ; les autres restent mystérieuses et face cachée, fournissant un puissant moteur de progression à long terme.

### Défaut 3 : « L'économie s'épuise vite »
- **Statut** : **FORTEMENT AMÉLIORÉ**.
- **Vérification** : L'introduction de l'Album de 32 cartes, du Panthéon de 26 divinités, des 6 monuments du Forum et de la boutique étendue (24 articles) a relevé le plafond d'achat à plus de 4 500 HS. De plus, `GameRepository` plafonne strictement les récompenses à 3 parties payées par jour par jeu, empêchant tout gavage artificiel.

### Défaut 4 : « Le Duel se gagne en deux réponses, et une posture domine »
- **Statut** : **TOTALEMENT CORRIGÉ**.
- **Vérification** : Les boss n'ont plus 100 PV uniformes. Leurs points de vie s'échelonnent désormais de **200 PV** (Spartacus) à **500 PV** (Secutor). Une attaque lourde infligeant 51 dégâts, il faut désormais 4 à 5 bonnes réponses consécutives pour triompher. La posture de parade au Scutum réduit la riposte de 50%, devenant une vraie option stratégique de sauvegarde.

### Défaut 5 : « Le Circus parle surtout du cirque »
- **Statut** : **CORRIGÉ**.
- **Vérification** : Le générateur `CircusDeck` implémente rigoureusement le ratio **2/3 de questions issues des mondes de cours atteints** et seulement 1/3 sur la culture du cirque.

### Défaut 6 : « Aucun jeu ne monte en difficulté »
- **Statut** : **CORRIGÉ**.
- **Vérification** :
  - Colosseum Duellum : Les PV des boss montent de 200 à 500, et les derniers boss puisent leurs questions dans les leçons les plus avancées du joueur.
  - Records et séries : Le record de points au Cirque, les séries de victoires consécutives au Duel et à la Bataille des Légendes sont désormais enregistrés et fièrement arborés sur les cartes du Hub Ludi.

---

## 4. Analyse jeu par jeu : Plaisir, lassitude et courbe d'engagement

### 1. Circus Maximus
- **Ce qui plaît** : L'ambiance sonore, les quadriges qui galopent, le choix de faction impériale (Prasini pour le gain, Veneti pour la vitesse), le coup de fouet des turbos sur bonne réponse.
- **Ce qui lasse** : La course dure toujours 3 tours complets (~75 secondes), ce qui peut sembler un peu long lorsqu'on veut juste enchaîner quelques révisions.
- **À quelle partie on s'ennuie** : Vers la 4e ou 5e partie consécutive, car le tracé de la piste ovale ne varie pas.

### 2. Colosseum Duellum
- **Ce qui plaît** : La tension dramatique du face-à-face, la montée en puissance des boss, le choix crucial de la posture (attaquer lourdement au risque de mourir ou parer prudemment).
- **Ce qui lasse** : Les répliques des boss qui reviennent à l'identique au début de chaque combat.
- **À quelle partie on s'ennuie** : Très bonne rejouabilité, la lassitude n'apparaît qu'après 7-8 combats lorsque l'on maîtrise parfaitement la parade.

### 3. Alea Iacta Est (Taverne)
- **Ce qui plaît** : Le frisson du Blackjack antique, l'immersion dans la taverne romaine avec le bruit des dés qui roulent, la fierté de calculer instantanément en chiffres romains.
- **Ce qui lasse** : La simplicité du choix binaire (« Lancer un dé » ou « S'arrêter »).
- **À quelle partie on s'ennuie** : Dès la 3e partie quotidienne (le plafond de 3 parties payées est exactement calibré pour ce jeu).

### 4. Atelier de César
- **Ce qui plaît** : Le plaisir intellectuel du décryptage, voir les lettres se transformer sous nos yeux et faire émerger une phrase latine qui a du sens.
- **Ce qui lasse** : La manipulation du curseur de décalage sur mobile, qui demande de la précision et peut être un peu rigide.
- **À quelle partie on s'ennuie** : Après 2 ou 3 messages décryptés d'affilée.

### 5. Marché de Trajan
- **Ce qui plaît** : Manipuler des sesterces et des deniers réels, calculer la monnaie exacte, l'atmosphère commerçante très vivante.
- **Ce qui lasse** : Devoir glisser les pièces une par une sur le comptoir si la somme comporte beaucoup de petits sesterces.
- **À quelle partie on s'ennuie** : Vers la 4e transaction.

### 6. Le Panthéon
- **Ce qui plaît** : La beauté majestueuse des illustrations divines, la fierté de voir les statues de marbre s'illuminer à mesure que l'on avance sur la Via Appia.
- **Ce qui lasse** : L'absence d'interactivité une fois la carte retournée (pas de mini-défi associé).
- **À quelle partie on s'ennuie** : Ce n'est pas un jeu d'action mais un sanctuaire de contemplation : on y passe 30 secondes pour admirer ses trophées.

### 7. Héros et Créatures (Album)
- **Ce qui plaît** : La richesse mythologique, les statistiques des héros façon cartes à collectionner, la clarté des objectifs pour débloquer les cartes manquantes.
- **Ce qui lasse** : L'impossibilité d'échanger des cartes ou de les faire monter de niveau.
- **À quelle partie on s'ennuie** : Très stimulant, donne envie de réussir des exploits en cours pour obtenir la carte suivante.

### 8. Bataille des Légendes
- **Ce qui plaît** : Le jeu le plus abouti et le plus stratégique ! Choisir sa carte, répondre à la question de latin pour rafler l'initiative, puis porter l'estocade avec sa meilleure caractéristique face à Crassus.
- **Ce qui lasse** : L'absence d'effets spéciaux animés lors de l'affrontement direct des deux cartes.
- **À quelle partie on s'ennuie** : Excellente rétention, on peut jouer 5 ou 6 parties sans voir le temps passer pour faire monter sa série de victoires.

---

## 5. Classement des 8 jeux (du plus au moins réussi)

1. **Bataille des Légendes** — *L'apogée ludique de l'application, mariant tactique de deck, culture des devises et questions de latin à chaque manche.*
2. **Colosseum Duellum** — *Combat intense et valorisant où chaque erreur se paie cher et où le latin est la seule arme pour survivre.*
3. **Circus Maximus** — *Sensations d'arcade spectaculaires avec des choix de factions qui comptent et une vraie révision des leçons de cours.*
4. **Héros et Créatures (Album)** — *Moteur de collection irremplaçable qui récompense l'excellence académique par des fiches mythologiques captivantes.*
5. **Le Panthéon** — *Tableau d'honneur divin qui donne une irrésistible envie de terminer chaque monde de la Via Appia jusqu'au bout.*
6. **Marché de Trajan** — *Mise en pratique concrète et vivante du calcul romain et de la vie quotidienne des citoyens de l'Empire.*
7. **Alea Iacta Est (Taverne)** — *Mini-jeu de pause récréative bien calibré pour 3 minutes par jour, ancrant solidement la lecture des chiffres romains.*
8. **Atelier de César** — *Concept cryptographique brillant et formateur mais pénalisé par une ergonomie de manipulation un peu austère.*

---

## 6. Deux propositions d'amélioration par jeu (au moins une axée sur le latin)

### 1. Circus Maximus
- **P1 (Latin)** : Ajouter des « cris d'encouragement de la foule » en latin (*« Celerius ! »*, *« Cave metam ! »*, *« Verbera equos ! »*) nécessitant une réaction rapide pour déclencher un super-turbo. *(Gain : Élevé / Effort : Faible / Risque : Nul)*
- **P2 (Gameplay)** : Introduire un mode « Grand Prix » en 3 courses avec météo variable (piste boueuse sous la pluie). *(Gain : Moyen / Effort : Moyen / Risque : Faible)*

### 2. Colosseum Duellum
- **P1 (Latin)** : Permettre de proclamer une provocation latine (*« Audaces fortuna iuvat ! »*, *« Morituri te salutant »*) en début de round pour infliger un coup critique si la traduction choisie est exacte. *(Gain : Élevé / Effort : Faible / Risque : Nul)*
- **P2 (Gameplay)** : Ajouter des cris de foule réactifs (huées sur erreur, clameurs sur parade réussie). *(Gain : Moyen / Effort : Très faible / Risque : Nul)*

### 3. Alea Iacta Est
- **P1 (Latin)** : Ajouter une phase de pari initial sur un proverbe de chance latin (*« Alea iacta est »*, *« Fortuna favet fortibus »*) pour doubler les sesterces en jeu. *(Gain : Moyen / Effort : Faible / Risque : Nul)*
- **P2 (Gameplay)** : Proposer une variante « Ad XXX » avec 3 dés pour manipuler des chiffres romains supérieurs à 20 (XXV, XXVIII...). *(Gain : Moyen / Effort : Faible / Risque : Nul)*

### 4. Atelier de César
- **P1 (Latin)** : Proposer des messages codés où l'indice de décalage est lui-même une énigme grammaticale latine (ex: *« Le nombre de déclinaisons régulières donne la clé »* -> Clé 5). *(Gain : Élevé / Effort : Faible / Risque : Nul)*
- **P2 (Gameplay)** : Remplacer le slider horizontal par un double disque rotatif en bronze façon machine d'Alberti. *(Gain : Élevé / Effort : Moyen / Risque : Faible)*

### 5. Marché de Trajan
- **P1 (Latin)** : Rédiger les demandes des clients en phrases latines simples (*« Volo duas amphoras vini et unum panem »*) au lieu d'une liste de courses en français. *(Gain : Très élevé / Effort : Faible / Risque : Nul)*
- **P2 (Gameplay)** : Permettre de toucher directement une coupelle « Rendu automatique » pour les clients pressés. *(Gain : Faible / Effort : Faible / Risque : Nul)*

### 6. Le Panthéon
- **P1 (Latin)** : Ajouter sur chaque divinité un défi « Épithète Sacrée » (ex: *« Pourquoi Minerve est-elle appelée Glaucopis ? »*) rapportant 2 HS. *(Gain : Élevé / Effort : Faible / Risque : Nul)*
- **P2 (Gameplay)** : Intégrer un bouton de partage ou d'export de la carte du dieu pour fond d'écran. *(Gain : Faible / Effort : Faible / Risque : Nul)*

### 7. Héros et Créatures (Album)
- **P1 (Latin)** : Intégrer un bouton audio pour écouter la prononciation classique restituée de la devise latine du héros. *(Gain : Élevé / Effort : Faible / Risque : Nul)*
- **P2 (Gameplay)** : Ajouter un effet de brillance dorée animée sur les cartes de rareté Légendaire. *(Gain : Moyen / Effort : Très faible / Risque : Nul)*

### 8. Bataille des Légendes
- **P1 (Latin)** : Ajouter des « Cartes Sortilège » rédigées en latin (*« Ira Deorum »*, *« Pax Romana »*, *« Veni Vidi Vici »*) tirées au sort en cours de match pour bouleverser les valeurs des caractéristiques. *(Gain : Très élevé / Effort : Moyen / Risque : Faible)*
- **P2 (Gameplay)** : Débloquer un deuxième rival après 5 victoires contre Crassus (ex: *Pompée le Grand* ou *Vercingétorix*). *(Gain : Élevé / Effort : Moyen / Risque : Faible)*
