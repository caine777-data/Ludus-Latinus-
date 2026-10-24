# Synthèse des audits T58 à T63 (Gemini, 23 et 24 octobre 2026)

Relecture de l'architecte, 24/10/2026. Les six rapports sont dans `docs/audits/` :
`premieres_minutes.md`, `coherence_visuelle.md`, `jeux_ludi_2026-10.md`,
`semaine_eleve.md`, `accessibilite.md`, `idees_venues_d_ailleurs.md`.

## Fiabilité

- Gemini n'a touché qu'aux documents ; profils et réglages de l'émulateur remis.
- Les chiffres tirés du code sont justes (vérifiés : PV des boss 200 à 500,
  gains des jeux, case du texte à trou de 38 dp, message libre de César, un
  seul `Semantics` dans tout le code).
- Des noms sont inventés ou faux : « Spartacus », « Secutor », « Bataille
  d'Actium », « textes d'effets » sur les cartes, factions et « virages » du
  Circus mal décrits. Les mesures de T60 (24 parties pour 16 captures) sont
  à prendre avec prudence.
- T59 : rapport écrit en trois exemplaires (doublons supprimés), et les
  planches par famille demandées n'ont pas été faites.

## 1. Défauts à corriger (pas de décision de conception)

| N° | Défaut | Source | Vérifié | Effort |
|---|---|---|---|---|
| D1 | Après une bonne réponse en vocabulaire, « Optime ! » s'affiche en bas et le bouton « Continuer » sort de l'écran : rien n'avance sans faire défiler | T58 | **oui, à l'émulateur** (m10-04, exercice 3) | S |
| D2 | Le clavier cache le bouton de validation : création du héros, texte à trou ; le bouton du texte à trou s'appelle « Valider la terminaison » même quand on tape un mot entier | T58 | non | S |
| D3 | Case du texte à trou à hauteur fixe (38 dp) : texte coupé en police 1,6 | T62 | oui, dans le code | S |
| D4 | Zones à toucher de moins de 48 dp : mots du puzzle (34), désinences rapides (32), choix de caractéristique de la Bataille | T62 | non | S |
| D5 | Lecteur d'écran : réponses barrées par l'indice annoncées comme actives, aucune annonce « bonne / mauvaise réponse » | T62 | oui (un seul `Semantics`) | M |

## 2. Décisions pour Cédric (ergonomie, visuel, ton)

| N° | Proposition | Source | Effort |
|---|---|---|---|
| E1 | Premier lancement : enchaîner sur la leçon 1 juste après la création du héros, au lieu de l'accueil (6 à 8 touchers et 2 minutes avant la première question aujourd'hui) | T58 | M |
| E2 | Annoncer les déblocages : nouveau rang (Tiro → Civis), Colisée ouvert, avec un bouton pour y aller | T58 | S |
| E3 | Lupulus : phrases selon le moment (bienvenue, après une erreur, après une leçon) au lieu de « Poursuis ta marche triomphale ! » en boucle | T58 | S |
| E4 | Icône de la boutique (sacs de magasin) remplacée par une bourse ou une amphore | T58 | S + image |
| E5 | Contrastes : or sur blanc (2,1 pour 1) et gris des sous-textes (4,0) à foncer | T62 | S |
| E6 | Mode lecture confort : police plus lisible pour les élèves dyslexiques, interlignes plus grands, titres sans capitales | T62 | M |
| E7 | Paramètres et À propos dans le style du reste de l'appli (ce sont les écrans les plus « Android ») | T59 | S |
| E8 | Émojis système remplacés par des icônes dessinées (sesterce, flamme, laurier...) | T59 | M + images |
| E9 | Appui long sur une carte de la Bataille pour la voir en grand | T59 | M |

## 3. Économie et rythme (T61)

- Constat chiffré : un élève qui ne fait que les jeux gagne environ 105 HS
  par jour, deux fois plus qu'un élève qui fait sa leçon quotidienne
  (environ 50 HS). La boutique entière (1 695 HS) se vide en 16 jours sans
  ouvrir une leçon.
- Pistes : jeux moins payés tant que l'objectif du jour n'est pas atteint ;
  bonus de l'objectif qui monte avec la série (5 à 10 HS) ; coffre de la
  semaine pour l'élève qui joue un seul jour (5 activités dans la semaine) ;
  un palier de récompense entre les mondes 3 et 5.

## 4. Nouveaux jeux et améliorations de jeux

Retenues comme les plus solides (font pratiquer le latin, hors ligne) :
- **Mot du jour** (façon Wordle) : un mot latin par jour, le même pour tous,
  indice par un mot français dérivé. Effort S à M. (T63)
- **Paires éclair** : relier mots latins et traductions contre la montre,
  avec le vocabulaire des leçons faites. Effort S. (T63)
- **Marché de Trajan** : les clients demandent en latin (« Volo duas
  amphoras... »). Effort S, contenu à écrire. (T60)
- **Défi de l'ombre** : rejouer un monde terminé contre son meilleur temps. Effort M. (T63)
- **Carte du monde romain** : « Ubi est Carthago ? », toucher la province. Effort M, carte à dessiner. (T63)
- **Bataille** : deuxième adversaire après 5 victoires contre Crassus. Effort M. (T60)

## Ordre proposé

1. D1 à D4 tout de suite (défauts, environ une demi-journée).
2. E1, E2, E3, E5 si Cédric les valide (gain fort pour les premières minutes).
3. Une décision sur l'économie (section 3).
4. Un nouveau jeu : Mot du jour ou Paires éclair.
