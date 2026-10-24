# Fiche Play Store de Ludus Latinus

Brouillon de l'architecte (17/10/2026), à valider par Cédric avant toute saisie dans la Play Console. Les limites de longueur sont celles de Google Play.

## Nom de l'application (30 caractères max.)

Ludus Latinus : latin 5e à 3e

## Description courte (80 caractères max.)

Le latin du collège, de la 5e à la 3e, en leçons courtes et en jeux romains.

## Description complète (4 000 caractères max.)

Ludus Latinus fait voyager l'élève dans la Rome antique pour apprendre le latin du collège, de la 5e à la 3e.

LE PROGRAMME DU COLLÈGE
26 mondes suivent les trois années de latin :
• 5e : les origines de Rome, la maison romaine, les dieux, les gladiateurs, les premiers cas et le présent ;
• 4e : la République, les conquêtes, l'imparfait, le parfait, César et la guerre des Gaules ;
• 3e : l'Empire, Pompéi, l'ablatif absolu, la voix passive, la proposition infinitive, le subjonctif, Virgile et Ovide.

119 leçons courtes : quiz, phrases à reconstituer, mots à compléter, décodeur des cas pour repérer le sujet et le complément d'objet. Chaque monde se termine par une arène qui reprend ce qu'il a enseigné.

DES JEUX POUR S'ENTRAÎNER
• Circus Maximus : une course de chars où chaque bonne réponse donne de la vitesse.
• Paires éclair : relier mots latins et traductions contre la montre, avec Lupulus en messager des dieux.
• Le Mot du jour : un mot latin à deviner en six essais, tiré des mondes déjà vus, avec les mots français qui en viennent pour indice.
• Colosseum Duellum : des duels de gladiateurs gagnés au vocabulaire.
• Alea Iacta Est : les dés de la taverne, comptés en chiffres romains.
• L'Atelier de César : messages secrets à chiffrer et à déchiffrer.
• Le Marché de Trajan : acheter, rendre la monnaie et marchander en sesterces.
• Le Panthéon : une carte à collectionner pour chaque monde terminé.
• Héros et Créatures : un album de 32 cartes, une carte gagnée à chaque succès.
• La Bataille des Légendes : un jeu de cartes contre Crassus, où chaque manche se joue sur une question de latin.

RÉVISER SANS OUBLIER
• Memoria : des cartes de vocabulaire qui reviennent au bon moment, selon ce que l'élève retient.
• Le Thesaurus : 224 mots latins avec leur sens et les mots français qui en viennent, les tableaux de déclinaisons et de conjugaisons, un glossaire.
• Des fiches de révision à imprimer.

ROME COMME TERRAIN DE JEU
L'élève crée son héros, gagne des sesterces, restaure les monuments du Forum, gravit les rangs du Cursus Honorum et garde sa série de jours. Lupulus, un louveteau romain, l'accompagne et l'encourage.

PENSÉ POUR LES FAMILLES ET LES PROFESSEURS
• Les jeux récompensent le travail : chaque leçon du jour ouvre des parties payées en sesterces. Sans leçon, on joue pour la gloire.
• Aucune publicité.
• Aucune donnée collectée, aucun compte à créer.
• Fonctionne sans connexion Internet.
• Un mode lecture confort, pour les élèves dyslexiques ou qui lisent avec peine : police très lisible, lettres et lignes plus espacées.
• Progression exportable dans un fichier, pour changer d'appareil.
• Une page pour les professeurs : ce que chaque monde travaille du programme officiel de latin du collège.

Ludus Latinus est édité par Icare & Dédale.

## Catégorie et public

- Catégorie : Éducation.
- Public cible : 12 à 15 ans (programme Familles). À confirmer dans la Play Console : le questionnaire propose des tranches d'âge fixes.
- Coordonnées : icareetdedale.studio@gmail.com.
- Politique de confidentialité : https://icareetdedale.fr/confidentialite/ (domaine en ligne depuis le 19/10/2026 ; l'ancienne adresse Netlify redirige ici, section Ludus Latinus).

## Visuels

| Élément | Exigence de Google | État |
|---|---|---|
| Icône | 512 × 512, PNG | prête : `store/icone_play_store_512.png` |
| Image de présentation | 1024 × 500, JPG ou PNG | projet à valider : `store/presentation_1024x500.png` (illustration m21-03, script `scripts/assets/presentation_store.py`) |
| Captures téléphone | 2 à 8, côté long au plus 2 fois le court | 8 captures 1200 × 2400 dans `store/captures/`, prises sur une sauvegarde de démonstration : leçon, Via Appia, duel, album, Bataille, exercice, page des professeurs, accueil (refaites le 18/10/2026, script `scripts/assets/captures_store.py`) |
| Captures tablette | facultatives, 16:9 | 8 captures 2560 × 1440 (tablette 10 pouces, paysage) dans `store/captures_tablette/` : leçon, Via Appia, duel, Ludi, album, Bataille, page des professeurs, accueil (refaites le 18/10/2026 : capture 2560 × 1600 recadrée, barre d'état et barre de gestes retirées) |

## À revoir avant la mise en production

- Si l'Édition complète est vendue, l'indiquer dans la description, conformément au modèle décidé (voir `AGENTS.md`, « Décisions de Cédric ») : « Les mondes 1 à 3 et la première leçon de chaque monde sont gratuits. L'Édition complète débloque tout le reste, en un seul achat, sans abonnement. » Google exige que les achats intégrés soient signalés. Recompter alors la partie gratuite sur le dataset du moment (119 leçons au 18/10, et non plus 113).
- Compte développeur créé le 22/10/2026 (compte personnel, nom public Icare & Dédale, nom légal affiché par Google : Cédric Monna, France). La fiche ne peut être créée qu'après la validation d'identité par Google.
- Les chiffres (26 mondes, 119 leçons, 224 mots) sont ceux du dataset du 18/10/2026.
- Captures à refaire (téléphone et tablette) une fois les icônes sesterce, flamme et bourse intégrées (audit E4, E8), pour montrer Paires éclair, le Mot du jour et la Taverne illustrée.
