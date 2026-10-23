# Audit T61 : Une semaine d'élève — Progression, économie et rétention

Audit réalisé le 23 octobre 2026 sur la branche `fix/mobile-publiable-lisible` à partir du code source du jeu (`lib/data/repositories/game_repository.dart`, `lib/data/models/profile.dart`, `lib/data/models/goodie_item.dart`, `content/album_mobile.py`, `assets/data/ludus_latinus_dataset.json`) et de vérifications en direct sur l'émulateur Android **Pixel_Ludus**.

---

## 1. Tableau de référence des gains et des prix

Chaque montant mentionné ci-dessous est sourcé directement dans le code du projet avec son fichier et son numéro de ligne exact.

### A. Tous les gains de sesterces (HS)

| Action / Source de gain | Montant | Plafond / Conditions d'attribution | Fichier source et ligne |
|---|---|---|---|
| **Leçon de cours (3 étoiles)** | **+10 HS** | Première réussite uniquement (`firstTime`) | [`game_repository.dart:352`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/repositories/game_repository.dart#L352) |
| **Leçon de cours (2 étoiles)** | **+7 HS** | Première réussite uniquement | [`game_repository.dart:352`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/repositories/game_repository.dart#L352) |
| **Leçon de cours (1 étoile)** | **+4 HS** | Première réussite uniquement | [`game_repository.dart:352`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/repositories/game_repository.dart#L352) |
| **Bonus Temple de Saturne** | **+20%** | Appliqué sur le gain de leçon si le monument est restauré | [`game_repository.dart:367`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/repositories/game_repository.dart#L367) |
| **Objectif du jour atteint** | **+5 HS** | 1 fois par jour dès 1 à 3 activités (leçon réussie ou 10 flashcards) | [`game_repository.dart:59`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/repositories/game_repository.dart#L59) & [`profile.dart:293`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/models/profile.dart#L293) |
| **Révision Memoria Velox** | **+2 HS** | Par bonne réponse sur une carte prête pour révision espacée | [`game_repository.dart:341`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/repositories/game_repository.dart#L341) |
| **Circus Maximus (Course)** | **+12 HS** | 3 victoires payées par jour max (+30% soit 15 HS si faction Prasini) | [`game_repository.dart:542`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/repositories/game_repository.dart#L542) & [`profile.dart:344`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/models/profile.dart#L344) |
| **Colosseum Duellum (Duel)** | **+15 HS** | 3 victoires payées par jour max | [`game_repository.dart:544`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/repositories/game_repository.dart#L544) & [`profile.dart:344`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/models/profile.dart#L344) |
| **Alea Iacta Est (Taverne Ad XXI)** | **+8 HS** | 3 victoires payées par jour max (approche de XXI sans brûler) | [`taverne_screen.dart:92`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/ui/features/taverne/taverne_screen.dart#L92) & [`profile.dart:344`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/models/profile.dart#L344) |
| **Atelier de César (Message)** | **+10 HS** | 3 missions payées par jour max (ou 5 HS si erreur de traduction) | [`game_repository.dart:545`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/repositories/game_repository.dart#L545) & [`profile.dart:344`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/models/profile.dart#L344) |
| **Marché de Trajan (Étal)** | **+5 HS** | 3 étals payés par jour max (panier en chiffres romains) | [`game_repository.dart:546`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/repositories/game_repository.dart#L546) & [`profile.dart:344`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/models/profile.dart#L344) |
| **Marché de Trajan (Rendu)** | **+5 HS** | 3 rendus payés par jour max | [`game_repository.dart:547`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/repositories/game_repository.dart#L547) & [`profile.dart:344`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/models/profile.dart#L344) |
| **Marché de Trajan (Négociation)** | **+10 HS** | 3 négociations payées par jour max | [`game_repository.dart:548`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/repositories/game_repository.dart#L548) & [`profile.dart:344`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/models/profile.dart#L344) |
| **Bataille des Légendes** | **+12 HS** | 3 victoires payées par jour max contre Crassus | [`game_repository.dart:543`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/repositories/game_repository.dart#L543) & [`profile.dart:344`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/models/profile.dart#L344) |
| **Inscription Épigraphique** | **+15 à 30 HS** | Unique (attribué 1 seule fois lors du décryptage de la stèle) | [`game_repository.dart:608-610`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/repositories/game_repository.dart#L608-L610) |
| **Carte Album (Commune)** | **+10 HS** | Unique lors du premier déblocage du succès associé | [`album_mobile.py:12`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/content/album_mobile.py#L12) & [`game_repository.dart:201`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/repositories/game_repository.dart#L201) |
| **Carte Album (Rare)** | **+20 HS** | Unique lors du premier déblocage | [`album_mobile.py:12`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/content/album_mobile.py#L12) & [`game_repository.dart:201`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/repositories/game_repository.dart#L201) |
| **Carte Album (Épique)** | **+40 HS** | Unique lors du premier déblocage | [`album_mobile.py:12`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/content/album_mobile.py#L12) & [`game_repository.dart:201`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/repositories/game_repository.dart#L201) |
| **Carte Album (Légendaire)** | **+80 HS** | Unique lors du premier déblocage | [`album_mobile.py:12`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/content/album_mobile.py#L12) & [`game_repository.dart:201`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/repositories/game_repository.dart#L201) |

---

### B. Toutes les dépenses de sesterces (Prix)

| Catégorie de dépense | Articles / Monuments | Prix unitaire | Coût cumulé de la catégorie | Fichier source et ligne |
|---|---|---|---|---|
| **Toges & Armures (5)** | Lin blanc (0), Praetexta (35), Lorica Segmentata (70), Lorica Squamata (95), Picta impériale (120) | 0 à 120 HS | **320 HS** | [`goodie_item.dart:76-120`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/models/goodie_item.dart#L76-L120) |
| **Couronnes & Casques (6)** | Tête nue (0), Lauriers bronze (25), Galea centurion (60), Lauriers or (85), Diadème (110), Obsidionale (140) | 0 à 140 HS | **420 HS** | [`goodie_item.dart:123-176`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/models/goodie_item.dart#L123-L176) |
| **Insignes & Armes (6)** | Stylet (0), Volumen papyrus (20), Gladius (45), Scutum (75), Vexillum SPQR (95), Fasces de licteur (130) | 0 à 130 HS | **365 HS** | [`goodie_item.dart:179-232`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/models/goodie_item.dart#L179-L232) |
| **Compagnons sacrés (7)** | Seul (0), Lupulus Jr (40), Chouette Noctua (65), Aquila (90), Cerbère chiot (110), Cheval (125), Pégase doré (160) | 0 à 160 HS | **590 HS** | [`goodie_item.dart:235-295`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/models/goodie_item.dart#L235-L295) |
| **Total Boutique Taberna** | **24 articles personnalisables** | — | **1 695 HS** | [`goodie_item.dart:76-295`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/models/goodie_item.dart#L76-L295) |
| **Monuments du Forum (6)** | Lacus Iuturnae (50), Templum Saturni (100), Curia Iulia (150), Arcus Titi (250), Aedes Minervae (350), Rostra Augusta (500) | 50 à 500 HS | **1 400 HS** | [`ludus_latinus_dataset.json:forum_monuments`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/assets/data/ludus_latinus_dataset.json) |
| **Total Absolu Dépenses** | **Tous les achats possibles du jeu (Boutique + Forum)** | — | **3 095 HS** | — |

---

## 2. Simulation de trois profils d'élèves sur 7 jours

### Profil A : « 10 minutes par jour » (L'élève régulier exemplaire)
- **Comportement quotidien** : 1 leçon de cours par jour (10 HS), 10 cartes de révision Memoria Velox (20 HS), validation de l'Objectif du Jour (+5 HS), 1 course au Cirque ou 1 duel (12 à 15 HS).
- **Temps consacré** : ~10 minutes chaque jour, à heure fixe (17h30, avec rappel automatique).

| Jour | Activités réalisées | Gains du jour (détail) | Solde fin de journée | Achats et déblocages notables | Série (Streak) |
|---|---|---|---|---|---|
| **Lundi (J1)** | m1-01 (10 HS) + 10 Memoria (20 HS) + Obj (5 HS) + Circus (12 HS) | **+47 HS** | 47 HS | Achat : *Lauriers de bronze* (25 HS). Reste 22 HS. | 1 jour |
| **Mardi (J2)** | m1-02 (10 HS) + 10 Memoria (20 HS) + Obj (5 HS) + Duel (15 HS) | **+50 HS** | 72 HS | Achat : *Toge Praetexta* (35 HS). Reste 37 HS. | 2 jours |
| **Mercredi (J3)** | m1-03 (10 HS) + 10 Memoria (20 HS) + Obj (5 HS) + Taverne (8 HS) + Carte Succès Série 3j (20 HS) | **+63 HS** | 100 HS | Restauration Forum : *Lacus Iuturnae* (50 HS). Carte Romulus. | 3 jours |
| **Jeudi (J4)** | m1-04 (10 HS) + 10 Memoria (20 HS) + Obj (5 HS) + Bataille (12 HS) | **+47 HS** | 97 HS | Achat : *Chouette Noctua* (65 HS). Reste 32 HS. | 4 jours |
| **Vendredi (J5)** | m1-05 (10 HS) + 10 Memoria (20 HS) + Obj (5 HS) + Circus (15 HS) | **+50 HS** | 82 HS | Épigraphie Fontaine (+15 HS). Reste 97 HS. | 5 jours |
| **Samedi (J6)** | m1-06 (Boss Ladon, 10 HS) + 10 Memoria (20 HS) + Obj (5 HS) + Duel (15 HS) + Carte Monde 1 terminé (10 HS) | **+60 HS** | 157 HS | Restauration Forum : *Templum Saturni* (100 HS, débloque +20% bonus). | 6 jours |
| **Dimanche (J7)** | m2-01 (10 + 2 bonus = 12 HS) + 10 Memoria (20 HS) + Obj (5 HS) + Taverne (8 HS) + Carte Succès Série 7j (40 HS) | **+85 HS** | 142 HS | Achat : *Gladius Honoris* (45 HS). Solde final : **97 HS**. | **7 jours** |

**Bilan fin de semaine du Profil A** :
- **Total sesterces accumulés** : **402 HS**.
- **Dépenses effectuées** : 320 HS (2 monuments restaurés, 4 objets de boutique équipés).
- **Progression** : Monde 1 terminé à 100% (6 leçons), Monde 2 entamé, 3 cartes d'album gagnées, Panthéon : 1ère divinité révélée (Jupiter).
- **Ressenti** : Expérience extrêmement valorisante, progression fluide, récompenses équilibrées chaque jour.

---

### Profil B : « Une grosse séance le mercredi » (L'élève massifié du mercredi)
- **Comportement** : Ne touche pas à l'application lundi, mardi, jeudi, vendredi, samedi, dimanche. Le mercredi après-midi, fait 1h30 de jeu intensif.
- **Séance du Mercredi** : Enchaîne 6 leçons du Monde 1 (60 HS) + 20 cartes Memoria (40 HS) + 1 Objectif du jour (+5 HS) + plafonds de tous les jeux Ludi (3 Circus = 36 HS, 3 Duels = 45 HS, 3 Tavernes = 24 HS, 3 Batailles = 36 HS) = 246 HS.

| Jour | Activités réalisées | Gains du jour | Solde fin de journée | Déblocages et écueils | Série (Streak) |
|---|---|---|---|---|---|
| **Lundi** | Aucune connexion | 0 HS | 0 HS | — | 0 jour |
| **Mardi** | Aucune connexion | 0 HS | 0 HS | — | 0 jour |
| **Mercredi** | 6 leçons (60) + 20 Memoria (40) + Obj (5) + Plafonds 4 jeux (141) + Romulus (10) | **+256 HS** | 256 HS | Achats : Toge Praetexta (35) + Galea (60) + Lacus (50) + Saturne (100). | **1 jour** |
| **Jeudi** | Aucune connexion | 0 HS | 11 HS | La série retombe à zéro. | 0 jour |
| **Vendredi** | Aucune connexion | 0 HS | 11 HS | — | 0 jour |
| **Samedi** | Aucune connexion | 0 HS | 11 HS | — | 0 jour |
| **Dimanche** | Aucune connexion | 0 HS | 11 HS | — | 0 jour |

**Bilan fin de semaine du Profil B** :
- **Total sesterces accumulés** : **256 HS** (146 HS de moins que le profil régulier A !).
- **Causes du manque à gagner** :
  - A perdu **30 HS** d'objectifs quotidiens (6 jours non réclamés car non rétroactifs).
  - A perdu les cartes d'album liées aux séries (Série 3 jours et Série 7 jours = **60 HS perdus**).
  - A buté contre le plafond de 3 parties payées par jeu d'arcade : après 45 minutes, tous ses jeux ne rapportaient plus aucun sesterce.
- **Ressenti** : Sentiment de blocage en fin de séance du mercredi (« les jeux ne paient plus rien ») et démotivation face à la série toujours remise à zéro.

---

### Profil C : « Joue surtout aux jeux » (L'arcadeur réfractaire aux leçons)
- **Comportement** : Se connecte chaque jour pendant 10 minutes, mais va directement dans l'onglet Ludi sans ouvrir aucune leçon de cours ni réviser Memoria.
- **Chaque jour** : Fait ses 3 parties de Taverne (24 HS) + 3 courses Circus (36 HS) + 3 duels (45 HS) = **105 HS par jour**.

| Jour | Activités réalisées | Gains du jour | Solde cumulé | Frustrations et blocages rencontrés | Série (Streak) |
|---|---|---|---|---|---|
| **J1** | 3 Tavernes (24) + 3 Cirques (36) + 3 Duels (45) | **+105 HS** | 105 HS | Achat : Cuirasse Lorica (70 HS). | 1 jour |
| **J2** | 3 Tavernes (24) + 3 Cirques (36) + 3 Duels (45) | **+105 HS** | 140 HS | Achat : Toge Picta dorée (120 HS). | 2 jours |
| **J3** | 3 Tavernes (24) + 3 Cirques (36) + 3 Duels (45) | **+105 HS** | 125 HS | Bloqué : *Bataille des Légendes verrouillée* (exige 3 cartes d'album). | 3 jours |
| **J4** | 3 Tavernes (24) + 3 Cirques (36) + 3 Duels (45) | **+105 HS** | 230 HS | Achat : Pégase doré (160 HS). | 4 jours |
| **J5** | 3 Tavernes (24) + 3 Cirques (36) + 3 Duels (45) | **+105 HS** | 175 HS | Les questions du Cirque tournent en boucle (seulement 9 questions de base). | 5 jours |
| **J6** | 3 Tavernes (24) + 3 Cirques (36) + 3 Duels (45) | **+105 HS** | 280 HS | Panthéon : 0 divinité révélée (toutes cadenassées car 0 monde terminé). | 6 jours |
| **J7** | 3 Tavernes (24) + 3 Cirques (36) + 3 Duels (45) | **+105 HS** | 385 HS | Cursus Honorum : bloqué au rang d'Apprenti (exige des leçons réussies). | 7 jours |

**Bilan fin de semaine du Profil C** :
- **Total sesterces accumulés** : **735 HS** ! (Énorme magot, presque le double du profil modèle).
- **Blocages majeurs rencontrés** :
  1. **Objectif du jour jamais validé** : L'objectif quotidien exige explicitement une leçon ou 10 flashcards de cours. 0 HS d'objectif en 7 jours.
  2. **Bataille des Légendes fermée** : Le meilleur jeu de cartes reste inaccessible car il faut 3 cartes d'album débloquées.
  3. **Panthéon 100% désert** : Aucune statue de dieu débloquée.
  4. **Lassitude rapide** : Les questions du Circus et du Duel tournent en boucle car la pioche refuse d'introduire des mots de mondes non encore atteints.
- **Ressenti** : Richesse artificielle en sesterces, mais le joueur réalise qu'il passe à côté des 3/4 du jeu sans les leçons.

---

## 3. Vérifications en direct sur l'émulateur Android (avec captures)

Deux points clés de la dynamique économique ont été testés en conditions réelles sur l'émulateur Pixel_Ludus :

### Vérification 1 : Le plafond quotidien de 3 parties payées
- **Observation sur écran** : Dans l'écran de la Taverne Ad XXI, la jauge affiche explicitement :  
  *« Victoires payées aujourd'hui : encore 3 sur 3 (+8 HS chacune) »* (visible sur la capture [`t61_taverne_ceiling.png`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/scratch/t61_taverne_ceiling.png)).
- **Comportement après 3 parties** : Une fois les 3 victoires atteintes, le message passe à :  
  *« Tes 3 victoires payées du jour sont faites : tu peux jouer pour la gloire. »*
- **Impact** : Aucun sesterce n'est versé pour les parties suivantes. Cela confirme rigoureusement la présence du garde-fou anti-farm codé dans `profile.dart:344` (`recompensesJeuParJour = 3`).

### Vérification 2 : La complétion et récompense de l'Objectif du Jour
- **Observation avant** : Sur l'accueil, l'encadré d'activité affiche :  
  *« Objectif du jour 0 / 1 : Une activité = une leçon réussie ou 10 cartes Memoria »* et solde de 1442 HS (capture [`t61_01_objectif_du_jour_avant.png`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/scratch/t61_01_objectif_du_jour_avant.png)).
- **Après réalisation d'une activité** : Dès la validation d'une leçon ou de 10 révisions, la fonction `validerObjectif()` ([`profile.dart:293`](file:///c:/Users/caine/Downloads/LATIN_LEARN/latin_learn/ludus_latinus_mobile/lib/data/models/profile.dart#L293)) crédite exactement **+5 HS**, bascule la jauge à 1/1 avec le statut *« Atteint ! »*, et désactive le rappel du soir devenu inutile.

---

## 4. Diagnostic d'équilibre : Ce qui va trop vite, ce qui est trop lent

1. **Ce qui s'obtient trop vite** :
   - Les premiers cosmétiques de base (Lauriers de bronze à 25 HS, Toge Praetexta à 35 HS) s'achètent dès le premier ou deuxième jour. C'est un excellent déclencheur psychologique pour accrocher l'élève dès le début.
   - Les sesterces en farmant les mini-jeux d'arcade (105 HS/jour) montent très vite par rapport au coût total de la boutique (1 695 HS) : en 16 jours sans cours, un élève peut tout vider.
2. **Ce qui reste trop longtemps hors d'atteinte** :
   - Les 3 derniers monuments du Forum (Arc de Titus à 250 HS, Temple de Minerve à 350 HS, Rostres à 500 HS) demandent de grosses réserves. Un élève studieux régulier (profil A) mettra plus de 3 semaines de cours assidus pour rénover les Rostres.
   - Les cartes légendaires de l'album (Persée, Achille, Énée) exigent des exploits ardus (vaincre les boss sans aucune faute).
3. **Les « temps morts » sans nouveauté** :
   - Entre le Monde 3 et le Monde 5 (leçons 15 à 25), l'élève gagne des sesterces et des étoiles, mais aucun nouveau mini-jeu ne se débloque. Le Cursus Honorum marque un palier entre le rang de *Civis* (3 leçons) et le rang de *Quaestor* (15 leçons).

---

## 5. Cinq propositions d'optimisation économique et de rétention

### P1. Conditionner une partie des gains des jeux à la réalisation de l'Objectif du Jour
- **Constat** : L'élève C gagne 105 HS/jour sans jamais ouvrir une leçon de latin.
- **Proposition** : Bloquer le versement des sesterces des jeux d'arcade au 3e lancer si l'Objectif du Jour n'a pas été validé au préalable (ou réduire les gains des jeux de 50% tant que la leçon du jour n'est pas faite).
- **Gain** : **Très élevé pour la pédagogie** (remet le cours au centre de la routine).
- **Effort** : **Faible** (condition simple dans `game_repository.dart:payerPartie`).
- **Risque** : **Nul**.

### P2. Introduire un bonus d'intérêt hebdomadaire au Tabularium
- **Constat** : L'élève B (mercredi uniquement) est trop sévèrement pénalisé par la perte de série quotidienne.
- **Proposition** : Ajouter un « Coffre de la Semaine » (fisc romain) : si l'élève réalise au moins 5 activités dans la semaine, il reçoit un bonus de 30 HS le dimanche soir.
- **Gain** : **Élevé** pour les élèves dont le temps d'écran est restreint en semaine par les parents.
- **Effort** : **Faible**.
- **Risque** : **Nul**.

### P3. Palier intermédiaire de déblocage entre Monde 3 et 5
- **Constat** : Creux d'engagement perçu entre la leçon 12 et la leçon 25.
- **Proposition** : Débloquer une « Arène d'entraînement » ou une récompense intermédiaire à 10 leçons réussies (ex: une toge spéciale offerte).
- **Gain** : **Moyen**.
- **Effort** : **Très faible**.
- **Risque** : **Nul**.

### P4. Augmenter le coût des objets de prestige (Boutique de luxe)
- **Constat** : 1 695 HS pour vider toute la boutique est atteignable en un mois par un élève acharné.
- **Proposition** : Ajouter 3 objets de très grand prestige pour les latinistes avancés (ex: *Couronne radiée de l'Empereur* à 350 HS, *Quadrige d'or* à 500 HS).
- **Gain** : **Moyen** (donne un objectif à long terme pour la fin de 3e).
- **Effort** : **Très faible** (3 entrées dans `goodie_item.dart`).
- **Risque** : **Nul**.

### P5. Bonus de sesterces croissant avec la série (Streak Multiplier)
- **Constat** : Une série de 15 jours rapporte exactement la même chose qu'une série de 2 jours (+5 HS pour l'objectif).
- **Proposition** : Ajouter +1 HS au gain de l'objectif par tranche de 5 jours de série (5 HS à J1, 6 HS à J5, 7 HS à J10, plafonné à 10 HS).
- **Gain** : **Énorme pour la rétention quotidienne**.
- **Effort** : **Très faible** (1 ligne de calcul dans `validerObjectif`).
- **Risque** : **Nul**.
