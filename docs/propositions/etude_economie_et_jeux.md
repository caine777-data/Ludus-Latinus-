# Étude : économie des sesterces et nouveaux jeux

Octobre 2026. Chiffres relevés dans le code et le dataset actuels (119 leçons,
26 mondes). Rien n'est appliqué : chaque choix attend la décision de Cédric.

## 1. Économie : ce que dit le code

### Gains uniques (une seule fois dans toute la scolarité)

| Source | Montant |
|---|---|
| 119 leçons, première réussite (10 HS à 3 étoiles, 7 à 2, 4 à 1) | 1 190 HS, environ 1 400 avec le bonus du Temple de Saturne (+20 %) |
| Album : 32 cartes (8 communes à 10, 9 rares à 20, 11 épiques à 40, 4 légendaires à 80) | 1 020 HS |
| 6 épigraphes du Forum (15 chacune) | 90 HS |
| Missions de César, étals du Marché | quelques centaines |
| **Total** | **environ 2 500 à 2 800 HS** |

### Gains de chaque jour (renouvelés tous les jours)

| Source | Maximum par jour |
|---|---|
| Circus : 3 courses payées à 12 | 36 |
| Bataille : 3 victoires payées à 12 | 36 |
| Colisée (duel) : 3 victoires payées à 15 | 45 |
| Taverne : 3 victoires payées à 8 | 24 |
| Défi du jour (dans un jeu) | 10 |
| Objectif du jour | 5 |
| Memoria : 2 par carte à réviser bien répondue | quelques HS |
| **Total jeux seuls** | **environ 150 HS** |

Une journée « une leçon » rapporte 10 + 5 = 15 HS.

### Dépenses possibles

| Poste | Coût total |
|---|---|
| 6 monuments du Forum (50 à 500) | 1 400 HS |
| Boutique : 24 objets | 1 695 HS |
| **Total** | **3 095 HS** |

### Les deux défauts

1. **Le jeu paie plus que la leçon.** Une course de Circus dure environ une
   minute et rapporte 12 HS ; une leçon dure environ cinq minutes et rapporte
   10 HS. Par minute, le jeu paie à peu près six fois plus. Un élève qui ne
   fait que jouer vide la boutique en deux à trois semaines sans ouvrir une
   leçon.
2. **Il n'y a plus rien à acheter très tôt.** Les gains uniques couvrent déjà
   80 % des dépenses ; cinq jours de jeux comblent le reste. Le profil de
   démonstration (59 leçons) a 1 442 HS en poche. Les 3e n'ont rien à
   dépenser.

## 2. Pistes pour l'économie

### A. Les leçons ouvrent les parties payées (recommandée)

Chaque leçon réussie dans la journée (nouvelle ou révisée) donne 2 parties
payées, à jouer dans le jeu de son choix, au plus 6 par jour. Sans leçon,
les jeux restent ouverts « pour la gloire » (records, défi du jour).

- Élève qui ne fait que jouer : 10 à 15 HS par jour au lieu de 150.
- Élève qui fait une leçon : 15 + 2 parties (environ 25) = 40 HS.
- Élève qui fait trois leçons : 45 + 6 parties (environ 75) = 120 HS.

Le jeu devient la récompense de la leçon, sans être retiré. Les montants des
jeux ne changent pas.

Travail : un compteur de parties gagnées par les leçons à la place des quotas
« 3 par jeu » (profil, `payerPartie`, Taverne), les phrases d'interface qui
parlent de « victoires payées » à réécrire (à valider), les tests. Effort S.

### B. Baisser les gains des jeux de moitié

Circus et Bataille à 6, Colisée à 8, Taverne à 4. Simple (quatre constantes),
mais l'élève qui joue sans faire de leçon reste mieux payé que celui qui fait
sa leçon, et la baisse se voit. Déconseillée seule.

### C. Prime de l'objectif qui monte avec la série (complément)

5 HS le premier jour, puis +1 par jour de série jusqu'à 10. Récompense la
régularité plutôt que la quantité. Effort S. Se combine avec A.

### D. De nouvelles dépenses pour les 4e et les 3e (plus tard)

Trois monuments de plus, débloqués par les mondes de 4e et de 3e (par exemple
la Bibliothèque d'Auguste, le Théâtre de Pompée, le Panthéon d'Hadrien), à 600,
800 et 1 000 HS. Demande trois illustrations et trois épigraphes à relire.
Effort M. À décider après A.

**Recommandation : A + C maintenant, D plus tard.**

## 3. Nouveaux jeux

Le dictionnaire du dataset compte 224 mots, 214 rattachés à un monde, tous
avec un mot français dérivé (`etym`). C'est la matière des deux premiers jeux,
sans contenu à écrire.

| Rang | Jeu | Ce qu'il fait travailler | Contenu | Effort |
|---|---|---|---|---|
| 1 | **Paires éclair** | sens des mots | aucun : mots des mondes déjà faits | S |
| 2 | **Mot du jour** | orthographe, dérivation | aucun : 110 mots de 4 à 6 lettres, indice par le mot dérivé | S à M |
| 3 | Marché, clients en latin | phrases simples, nombres | phrases latines à écrire et à faire relire | S de code, contenu à prévoir |
| 4 | Défi de l'ombre | révision d'un monde | aucun | M |
| 5 | Carte du monde romain | géographie, civilisation | une carte à dessiner | M |

### Paires éclair (recommandée en premier)

Cinq mots latins à gauche, leurs traductions mélangées à droite, relier les
paires contre la montre, trois manches. Mots tirés des mondes que l'élève a
terminés, en priorité ceux de Memoria à réviser. Payée par les parties
gagnées en leçon (piste A). Un écran neuf d'environ 300 lignes et un test.

### Mot du jour

Un mot latin de 4 à 6 lettres à trouver en six essais, lettres bien placées
en vert, mal placées en doré. Indice après trois essais : le mot français
dérivé (« amical » pour AMICA). Le mot est tiré des mondes déjà faits, donc
propre à chaque élève : on perd le « même mot pour toute la classe », on
gagne la révision. Payé une fois par jour (10 HS). Clavier à l'écran à créer.
Environ 110 mots possibles, soit quatre mois sans répétition.

**Recommandation : Paires éclair d'abord, Mot du jour ensuite.**

## 4. Décisions attendues

1. Économie : A + C, ou une autre combinaison ?
2. Premier nouveau jeu : Paires éclair ?
3. Mot du jour : mot propre à chaque élève (révision) ou même mot pour toute
   la classe (on en parle en cours) ?
