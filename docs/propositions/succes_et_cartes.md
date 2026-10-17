# Succès et album « Héros et Créatures »

Proposition de l'architecte (17/10/2026), à valider par Cédric. Un succès = une carte : les 32 cartes de `content/cartes_data.py` deviennent les 32 récompenses.

## Constat

- Le dataset ne contient que **8 succès**, pas 80 (l'inventaire du 17/10 s'était trompé). Deux sont périmés : « Polyglotte » promet une prononciation vocale qui n'existe pas, « Grand Collectionneur » renvoie à un album absent.
- L'écran Compte affiche 5 trophées écrits en dur.
- Les 32 cartes ont un nom, un nom latin, une rareté, une attaque, une défense, une citation et une anecdote, mais pas d'image propre.

## Principe

- Chaque succès débloque une carte et quelques sesterces : commune 10, rare 20, épique 40, légendaire 80.
- Le thème de la carte rejoint celui du succès (Ulysse pour le monde du Cyclope, Mercure pour le marché).
- La rareté suit la difficulté. Quand le thème l'impose, la rareté d'origine change (colonne « Rareté »).
- Les 8 succès actuels et les 5 trophées en dur sont remplacés par ce catalogue.

## Catalogue proposé

### Héros : la progression dans les leçons (13)

| Carte | Rareté | Succès |
|---|---|---|
| Romulus | commune (était épique) | Terminer le monde 1 |
| Julia la Vestale | commune | Terminer le monde 2 (la maison romaine) |
| Hercule | rare (était légendaire) | Terminer le monde 4 (les travaux d'Hercule) |
| Ulysse | rare | Terminer le monde 10 (Polyphème) |
| Horace | rare | Réussir 50 leçons |
| Achille | rare | Réussir 30 leçons avec 3 étoiles |
| Énée le Troyen | épique | Terminer toute la 5e |
| Scipion l'Africain | épique (inchangé) | Terminer le monde 13 (Carthage) |
| Vercingétorix | épique | Terminer le monde 17 (la guerre des Gaules) |
| Pline l'Ancien | épique (était rare) | Terminer le monde 21 (le Vésuve) |
| Cicéron | épique | Terminer le monde 23 (le discours au Sénat) |
| Virgile | épique (était rare) | Terminer le monde 25 (les poètes) |
| Hannibal Barca | légendaire | Terminer toute la 4e |

### Dieux : la régularité (6)

| Carte | Rareté | Succès |
|---|---|---|
| Apollon | rare | Série de 3 jours |
| Mercure | rare | 10 opérations réussies au Marché de Trajan (dieu du commerce) |
| Neptune | rare | 10 quêtes du jour accomplies |
| Mars Ultor | épique | Vaincre les 5 gladiateurs du Duel |
| Minerve | épique | 20 mots maîtrisés dans Memoria (dernière boîte) |
| Jupiter | légendaire | Série de 30 jours |

### Créatures : les jeux (6)

| Carte | Rareté | Succès |
|---|---|---|
| Pégase | commune | Finir une première course au Circus |
| Le Sphinx | commune | Résoudre une première énigme de l'Atelier de César |
| Le Lion de Némée | rare | Vaincre Crixus, le premier gladiateur |
| Le Minotaure | rare | Déchiffrer 3 inscriptions (épigraphes) |
| Méduse la Gorgone | épique | Gagner un duel sans aucune faute |
| Cerbère | épique | Gagner 10 parties à la Taverne |

### Monuments : Rome et ses richesses (7)

| Carte | Rareté | Succès |
|---|---|---|
| La Via Appia | commune | Réussir 5 leçons |
| Le Scutum et le Gladius | commune | Acheter un premier objet à la Taberna |
| L'Aqueduc romain | commune | Restaurer un premier monument du Forum |
| Le Circus Maximus | rare | Gagner 5 courses au Circus |
| Le Colisée | épique | Gagner 10 duels |
| Jules César | légendaire | Réussir toutes les missions de l'Atelier de César |
| Auguste | légendaire | Terminer les 26 mondes (« une Rome de marbre ») |

## Ce que l'appli doit compter en plus

Déjà suivis dans le profil : leçons réussies, étoiles, série, sesterces, monuments restaurés, épigraphes, missions de César, objets achetés, cartes Memoria et leur boîte.

À ajouter : gladiateurs vaincus (liste), duels gagnés, duels sans faute, courses finies et gagnées au Circus, parties gagnées à la Taverne, opérations réussies au Marché, quêtes du jour accomplies. Les élèves qui ont déjà joué partent de zéro pour ces compteurs ; les succès fondés sur les leçons et la série se débloquent tout de suite à la première ouverture.

## Écrans

- **Album « Héros et Créatures »**, dans Ludi à côté du Panthéon : progression globale, filtres par famille, cartes obtenues en couleur avec leur rareté, cartes verrouillées avec leur succès et une barre de progression.
- **Annonce d'une carte gagnée**, en fin de leçon ou de partie : la carte se retourne, le succès et les sesterces sont rappelés, boutons « Voir l'album » et « Continuer ».
- **Écran Compte** : les 5 trophées en dur deviennent « 9 / 32 cartes » et les trois dernières obtenues.
- En touchant une carte obtenue : grande carte avec citation latine, traduction et anecdote.

## Images

32 illustrations à générer, une par carte, dans le style du Panthéon (format portrait, comme les cartes du Panthéon). Les prompts suivront la validation de ce catalogue. En attendant les images, une carte obtenue affiche une icône sur fond de couleur, comme sur la maquette.
