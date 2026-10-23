# Audit T59 : Cohérence visuelle et harmonie graphique de tous les écrans

Audit réalisé le 23 octobre 2026 sur l'émulateur Android **Pixel_Ludus** sur la branche `fix/mobile-publiable-lisible`.  
L'application a grandi par couches successives au cours des développements (leçons de base, révision Memoria, boutique Taberna, album de cartes, mini-jeux du Cirque et de l'Arène, espace professeurs, objectif quotidien). Cet audit a pour objectif de vérifier si l'application conserve une identité visuelle unifiée et forte, respectant les codes de la direction artistique romaine, ou si des écrans détonnent par rapport à l'expérience globale.

---

## 1. Méthodologie, environnement et intégrité des données

- **Appareil de référence (Téléphone)** : Émulateur Android `Pixel_Ludus` — Résolution physique **1080 × 2400**, densité **420 dpi**, Android 16, mise à l'échelle de police `font_scale 1.0`.
- **Appareil de test (Tablette)** : Configuration `adb shell wm size 2560x1600`, `adb shell wm density 320`, `adb shell settings put system font_scale 1.3`. Remis à l'état d'origine dès la fin des captures.
- **Profil utilisateur audité** : Profil existant de l'élève « Marcus », rang *Aedilis*, 59 leçons conquises sur 119 (permettant d'accéder directement à tous les mondes, tous les types d'exercices et tous les jeux débloqués).
- **Intégrité de la sauvegarde** : Sauvegarde exportée avant l'audit dans `scratch/t59_profil_avant.json` et comparée après la session (`scratch/t59_profil_apres.json`). Aucun écart détecté (`Number of diffs: 0`).
- **Validation technique** : Suite de tests automatisés Flutter exécutée en fin de tournée : **211/211 tests réussis à 100%** (`All tests passed!`).

---

## 2. Inventaire des captures d'écran réalisées (39 captures)

Toutes les captures ont été extraites du rendu direct de l'application et sont archivées dans le dossier `latin_learn/scratch/` :

### Écrans sur Téléphone (1080 × 2400)
| Réf. Capture | Écran / Composant | Éléments visuels majeurs observés |
|---|---|---|
| `t59_00_splash.png` | Splash Screen | Aigle impérial doré SPQR, citation de Sénèque, fond pourpre nuit. |
| `t59_01_accueil_haut.png` | Accueil (Haut) | Carte de héros Marcus, insigne Aedilis, conseil de Lupulus, objectif du jour. |
| `t59_02_accueil_bas.png` | Accueil (Bas) | Bannière Via Appia dorée, raccourci Taberna Romana et Circus Maximus. |
| `t59_03_cursus_honorum.png` | Cursus Honorum | Modal des 6 rangs civiques romains avec sceaux et conditions d'accès. |
| `t59_04_tabularium_compte.png` | Tabularium (Compte) | Bilan de progression, statistiques civiques, équipement du héros. |
| `t59_05_boutique.png` | Taberna Romana | Rayonnage des toges, couronnes, compagnons, solde en sesterces. |
| `t59_06_parametres.png` | Paramètres (Haut) | Choix de l'avatar héroïque (Marcus / Julia), rappels et notifications. |
| `t59_06_parametres_bas.png` | Paramètres (Bas) | Réglages sonores, vidéo d'introduction, espace profs, à propos. |
| `t59_07_a_propos.png` | À Propos | Mentions légales, éditeur Icare & Dédale, version de l'application. |
| `t59_08_profs.png` | Espace Professeurs | Référentiel pédagogique LCA Cycle 4 de l'Éducation Nationale. |
| `t59_09_carte_via_appia.png` | Carte Via Appia | Route romaine serpentine, bornes milliaires, décors antiques (pins, aqueducs). |
| `t59_10_lecon_fiche.png` | Fiche de leçon | Encadrement parchemin, coins en bronze, texte explicatif, bouton d'action or. |
| `t59_11_lecon_quiz.png` | Leçon - Quiz | QCM avec boutons wax seals (A, B, C, D) et indice pédagogique. |
| `t59_12_lecon_trou.png` | Leçon - Trou | Phrase à trou avec zone d'insertion interactive et clavier virtuel latin. |
| `t59_13_lecon_puzzle.png` | Leçon - Puzzle | Blocs de mots à ordonner selon la syntaxe latine, bouton valider doré. |
| `t59_14_lecon_decodeur.png` | Leçon - Décodeur | Analyseur de cas avec pastilles chromatiques (nominatif, accusatif...). |
| `t59_15_lecon_arene.png` | Leçon - Arène (Boss) | Combat de boss (Dragon Ladon), barre de vie rouge dorée et points d'honneur. |
| `t59_16_lecon_bilan.png` | Bilan de Victoire | Couronne de laurier, attribution d'étoiles, sesterces gagnés et fanfare. |
| `t59_17_bibliotheca_accueil.png` | Hub Bibliotheca | 5 tuiles d'outils d'étude (Memoria, Thesaurus, Forum, Épigraphie, Tabulae). |
| `t59_18_thesaurus.png` | Thesaurus | Dictionnaire thématique latin-français avec déclinaisons complètes. |
| `t59_19_memoria.png` | Memoria Velox | Système de répétition espacée Leitner (boîtes 1 à 5) et flashcards. |
| `t59_20_fiches_grammaire.png` | Tabulae Memoriales | Fiches de synthèse A4 prêtes à l'impression / révision hors écran. |
| `t59_21_epigraphie.png` | Épigraphie | Décryptage de stèles et inscriptions lapidaires réelles de l'Antiquité. |
| `t59_21b_forum_imperiale.png` | Forum Imperiale | Vue du forum avec monuments restaurés grâce aux leçons réussies. |
| `t59_22_ludi_accueil.png` | Hub Ludi | Grille des 8 jeux et arènes avec records et badges thématiques. |
| `t59_23_circus_maximus.png` | Circus Maximus | Course de chars chronométrée, animation des chevaux et questions rapides. |
| `t59_24_colosseum_duellum.png` | Colosseum Duellum | Duel en arène contre des gladiateurs avec série de victoires. |
| `t59_25_alea_iacta_est.png` | Alea Iacta Est | Mini-jeu de taverne romaine avec dés d'osselets en bois/ivoire. |
| `t59_26_atelier_cesar.png` | Atelier de César | Machine de déchiffrement de messages secrets chiffrés par décalage. |
| `t59_27_marche_trajan.png` | Marché de Trajan | Calculs marchands en chiffres romains et étal de denrées antiques. |
| `t59_28_pantheon.png` | Le Panthéon | Galerie de cartes illustrées des divinités romaines débloquées par monde. |
| `t59_29_album_cartes.png` | Héros & Créatures | Album de cartes à collectionner célébrant les grands mythes et succès. |
| `t59_30_bataille_legendes.png` | Bataille des Légendes | Jeu de cartes tactique contre Crassus sur plateau de feutre pourpre. |

### Écrans sur Tablette (2560 × 1600, densité 320, font_scale 1.3)
| Réf. Capture | Écran audité | Comportement responsive observé |
|---|---|---|
| `t59_tab_01_accueil.png` | Accueil Tablette | Carte de héros et bannières centrées dans un conteneur contraint en largeur. |
| `t59_tab_02_carte.png` | Carte Via Appia Tablette | Vue panoramique de la route sans étirement disgracieux des illustrations. |
| `t59_tab_03_lecon_fiche.png` | Fiche de leçon Tablette | Grand parchemin lisible, typographie agrandie sans chevauchement. |
| `t59_tab_04_lecon_exercice.png` | Exercice Tablette | Tuiles de syntaxe larges adaptées à la manipulation tactile sur grand écran. |
| `t59_tab_05_bibliotheca.png` | Bibliotheca Tablette | Grille 2 colonnes parfaitement symétrique et aérée. |
| `t59_tab_06_ludi.png` | Hub Ludi Tablette | Présentation en 2 colonnes équilibrées des 8 cartes de jeux. |

---

## 3. Évaluation des 8 Piliers de la Direction Artistique Romaine

### 1. Palette Chromatique
- **Règle** : Les teintes fondamentales doivent être le **Pourpre impérial** (`#651C32` / `#5C1D2C`), l'**Or impérial** (`#DDAA33` / `#E5A93C`), le **Crème / Palatin** (`#F9F6F0`), le **Vert laurier** (`#3A7D44`) et le **Bleu marin** (`#1B3B6F`).
- **Constat** : Le respect de cette gamme est exceptionnel sur 90% de l'application. La dominante pourpre et or structure immédiatement la perception impériale dès le Splash screen jusqu'au bilan de victoire.
- **Anomalie repérée** : L'écran de l'**Atelier de César** (`t59_26_atelier_cesar.png`) utilise un fond ardoise/gris très sombre et des accents cyan/électriques qui évoquent davantage une salle de contrôle moderne qu'un atelier de campagne légionnaire.

### 2. Typographie
- **Règle** : Police avec empattements monumentale (Cinzel / Roman serif) pour les en-têtes et majuscules romaines ; police sans-serif moderne, haute lisibilité et espacement équilibré pour les consignes et le latin.
- **Constat** : Les titres majeurs de la barre supérieure (`LUDUS LATINUS`, `BIBLIOTHECA`, `LUDI`, `VIA APPIA`) utilisent tous une police à empattements très distinguée avec un crénage large qui évoque la gravure lapidaire. Les textes de cours sont faciles à lire même pour un élève dyslexique.

### 3. Frises et Méandres
- **Règle** : Frises géométriques grecques/romaines (méandres) en séparation des zones d'illustration et des corps de texte.
- **Constat** : Présents sur les bannières d'accueil, la carte de la Via Appia et la fiche de leçon (`t59_10_lecon_fiche.png`). Cependant, ils sont totalement absents des pages utilitaires (Paramètres, À propos) et des fenêtres de dialogue simples.

### 4. Bannières SPQR et Vexillum
- **Règle** : Rubans pourpres festonnés, encadrements à queue d'aronde ou pointes d'aigle.
- **Constat** : Très réussis sur l'accueil (`t59_01_accueil_haut.png`) pour le badge de rang *AEDILIS*, sur le bouton « LA VIA APPIA », ainsi que sur le bilan de fin de leçon (`t59_16_lecon_bilan.png`).

### 5. Boutons et Call-to-Action (CTA)
- **Règle** : Boutons proéminents, fond doré chaud ou pourpre impérial avec bordure fine or, rayon de courbure harmonieux (12-16px) et ombre portée douce.
- **Constat** : Les boutons d'action majeure (« AVANCER SUR LA ROUTE », « À L'EXERCICE ↓ ») sont remarquables d'impact et d'ergonomie. En revanche, certains boutons secondaires oscillent entre des boutons pilules fins et des boutons plats sans relief.

### 6. Médaillons, Sceaux et Cire
- **Règle** : Sceaux ronds de cire rouge ou dorée pour les options de QCM et les niveaux d'accomplissement.
- **Constat** : Le QCM (`t59_11_lecon_quiz.png`) est un modèle d'intégration : chaque lettre (A, B, C, D) est logée dans un sceau de cire rouge antique en relief, donnant une authenticité ludique immédiate.

### 7. Feedback Visuel
- **Règle** : Vert laurier éclatant pour la réussite, pourpre profond pour l'erreur, animations fluides sans agressivité.
- **Constat** : Les félicitations et corrections dans les 5 types de leçons s'affichent avec une excellente clarté sans décourager l'élève.

### 8. Responsive & Grille
- **Règle** : Adaptation sans faille sur petit smartphone comme sur grande tablette 10 pouces, sans débordement de texte ni étirement de conteneurs.
- **Constat** : Les tests en 2560 × 1600 démontrent une remarquable maîtrise : les contenus sont encapsulés dans des conteneurs centrés à largeur maximale, évitant l'effet "carte étirée sur toute la largeur".

---

## 4. Tableau des variantes par famille d'éléments

| Famille d'éléments | Variantes repérées dans l'application | Variante proposée comme référence | Justification pédagogique & esthétique |
|---|---|---|---|
| **Boutons principaux (CTA)** | 1. Grand bouton or dégradé avec ombre portée chaude et texte pourpre majuscule.<br>2. Bouton pourpre bordé d'un filet or.<br>3. Bouton plat sombre sans relief.<br>4. Petit bouton pilule fin arrondi (filtres). | **Variante 1 pour l'action principale**, **Variante 2 pour l'action secondaire**. | La variante 1 (« AVANCER SUR LA ROUTE », « À L'EXERCICE ») offre le contraste le plus puissant et incite naturellement au clic. |
| **Titres d'écrans** | 1. AppBar avec titre doré centré en Cinzel majuscule + dorures latérales.<br>2. Grand en-tête illustré avec devise latine en italique.<br>3. Titre simple aligné à gauche type Material Design standard. | **Variante 1 pour la navigation principale** couplée à la **Variante 2 en tête de hub**. | La devise latine (« Littera scripta manet » / « Panem et circenses ») renforce la culture antique et l'élégance de l'accueil. |
| **Cartes & Encadrés** | 1. Carte marbre/crème avec liseré or et méandre discret (radius 16).<br>2. Parchemin avec clous/coins en bronze (leçons).<br>3. Carte Material standard sans bordure ni texture. | **Variante 1 (Marbre/Or) pour les hubs**, **Variante 2 (Parchemin) pour les cours**. | Permet de distinguer visuellement le « monde civique/public » (marbre impérial) du « bureau d'étude/scriptorium » (parchemin). |
| **Pastilles & Badges** | 1. Sceau de cire rouge circulaire (QCM).<br>2. Ruban festonné pourpre doré (Rangs civiques).<br>3. Chip ovale grisâtre standard.<br>4. Étiquettes de cas grammaticaux colorées. | **Variante 1 pour les choix interactifs**, **Variante 2 pour les récompenses/statuts**. | Élimine les chips neutres qui font penser à un formulaire d'administration. |
| **Barres de progression** | 1. Barre fine fond sombre avec progression or et vert laurier (Carte).<br>2. Jauge de boss rouge avec ornement or (Arène).<br>3. Segments d'étapes en pointillés en haut d'exercice. | **Conserver les 3 selon le contexte**, mais standardiser l'épaisseur et les arrondis d'extrémités. | Chaque jauge a une utilité distincte : voyage global, tension dramatique du combat, et micro-progression dans la leçon. |

---

## 5. Relevé des icônes et émojis

- **Mélange observé** :
  L'application combine actuellement deux systèmes visuels pour son iconographie :
  1. Des illustrations et gravures sur mesure au trait et à la peinture numérique (splendides portraits de dieux, monstres, décors de la Via Appia, sceaux de cire).
  2. Une utilisation massive d'**émojis système Unicode** : 🔥 (flamme de série), 🪙 (sesterces), 🏛️ (Bibliotheca), ⚔️ (Ludi), 💡 (conseil de Lupulus), 🖨️ (fiches imprimables), 📜 (quiz), 🧩 (puzzle syntaxe), ✏️ (déclinaisons), 🏺 (anecdotes culturelles).
- **Conséquences visuelles** :
  - Sur Android (Google Noto Color Emoji), ces émojis s'affichent avec un rendu brillant, cartoon et saturé qui tranche avec l'ambiance sobre, patinée et monumentale du reste du jeu.
  - Selon le modèle de téléphone ou l'OS (Samsung, Xiaomi, Apple), le rendu des émojis n'est pas sous le contrôle de l'application et peut introduire des décalages d'alignement ou des couleurs discordantes.

---

## 6. Analyse du comportement sur Tablette (2560 × 1600, font_scale 1.3)

Six écrans majeurs ont été passés au banc d'essai sous contraintes extrêmes (écran 10 pouces haute densité avec police agrandie à 130%) :

1. **Accueil (`t59_tab_01_accueil.png`)** :
   - *Alignement & marges* : Parfait. La carte d'en-tête de Marcus et les bannières sont contraintes à 800-900 points de large et centrées avec d'élégantes marges latérales.
   - *Lisibilité des textes agrandis* : La citation de Lupulus et les statistiques restent parfaitement lisibles sans tronquage.
2. **Carte Via Appia (`t59_tab_02_carte.png`)** :
   - *Comportement de la route* : La serpentine s'affiche harmonieusement. Les filtres par classe (5e, 4e, 3e) tiennent sur une seule ligne aérée au lieu de se replier.
   - *Interactivité* : Les jalons de cours sont très faciles à cibler au doigt sans risque de toucher un jalon voisin.
3. **Fiche de leçon (`t59_tab_03_lecon_fiche.png`)** :
   - *Mise en page* : Le parchemin remplit majestueusement l'espace sans paraître étiré. Le bouton « À L'EXERCICE ↓ » reste solidement ancré en bas d'écran.
4. **Exercice de leçon (`t59_tab_04_lecon_exercice.png`)** :
   - *Ergonomie tactile* : Les tuiles de mots à déplacer sont grandes et spacieuses. L'exercice est particulièrement agréable à manipuler à deux mains.
5. **Bibliotheca (`t59_tab_05_bibliotheca.png`)** :
   - *Grille* : Passage automatique et fluide en **grille 2 colonnes** (`[420, 1268]` et `[1292, 2140]`). Aucune impression de vide géant grâce à l'aération équilibrée.
6. **Ludi & Arènes (`t59_tab_06_ludi.png`)** :
   - *Affichage des 8 jeux* : Les 8 cartes s'affichent sous forme de catalogue impérial en deux colonnes majestueuses avec leurs badges de records.

**Conclusion Responsive** : Aucun débordement de pixels (« yellow/black overflow bars »), aucun texte écrasé, et une excellente adaptation de l'espace.

---

## 7. Liste des écrans qui détonnent (classés du plus au moins visible)

1. **Paramètres & À propos (`t59_06_parametres.png`, `t59_07_a_propos.png`)** :
   - *Diagnostic* : C'est la zone la plus "brute" de l'application. Elle utilise des `ListTile` grises standards de Flutter sur fond uni sans aucun encadrement romain, sans texture de marbre ni méandre. Elle donne l'impression de sortir temporairement de l'univers du jeu pour entrer dans les réglages système d'Android.
2. **Atelier de César (`t59_26_atelier_cesar.png`)** :
   - *Diagnostic* : L'ambiance visuelle est très sombre, presque "science-fiction / console informatique", avec des cadrans monochromes et des curseurs qui tranchent avec les parchemins et boiseries antiques de la taverne et du cirque.
3. **Espace Professeurs (`t59_08_profs.png`)** :
   - *Diagnostic* : Extrêmement dense en texte noir/blanc austère. Même s'il s'agit d'un contenu institutionnel destiné aux enseignants, l'intégration d'un bandeau à colonnes ou d'une texture parchemin adoucirait grandement la lecture.
4. **Boutique Taberna Romana (`t59_05_boutique.png`)** :
   - *Diagnostic* : Les cartes d'articles sont très réussies individuellement, mais les boutons « Acheter » ne sont pas strictement alignés sur une même ligne horizontale lorsque le nom de l'objet tient sur deux lignes au lieu d'une.
5. **Bataille des Légendes & Album (`t59_29_album_cartes.png`, `t59_30_bataille_legendes.png`)** :
   - *Diagnostic* : Sur écran de téléphone vertical (1080 × 2400), les textes d'effets sur les cartes de combat sont imprimés en très petite taille pour tenir dans le gabarit de la carte.

---

## 8. Les 5 propositions d'harmonisation (Priorisées par Gain / Effort / Risque)

### P1. Harmoniser le widget de bouton primaire (`RomanButton`)
- **Action** : Généraliser l'utilisation du bouton doré dégradé avec ombre chaude et typographie Cinzel pour 100% des validations et actions majeures, en remplaçant les quelques `ElevatedButton` résiduels.
- **Gain** : **Élevé** (Sentiment immédiat de finition haut de gamme sur chaque écran).
- **Effort** : **Faible** (Remplacement de quelques widgets isolés).
- **Risque** : **Nul**.

### P2. Remplacer les émojis système par des glyphes vectoriels romains (SVG)
- **Action** : Créer un jeu d'icônes vectorielles dédiées pour les 6 symboles clés : Sesterce en or gravé, Flamme de Vesta, Couronne de laurier, Glaive romain, Stèle de pierre, et Papyrus.
- **Gain** : **Élevé** (Immersion totale, élimination du look "smartphone moderne cartoon").
- **Effort** : **Moyen** (Ajout des SVG et composant `RomanIcon`).
- **Risque** : **Très faible**.

### P3. Romaniser l'écran des Paramètres et de l'À Propos
- **Action** : Appliquer un fond marbre léger, des séparateurs dorés et un en-tête à méandre aux sections des paramètres pour les intégrer au style du Tabularium.
- **Gain** : **Moyen** (Suppression de la seule rupture de ton graphique de l'application).
- **Effort** : **Faible**.
- **Risque** : **Nul**.

### P4. Aligner la grille des articles de la Boutique (Taberna)
- **Action** : Fixer la hauteur du conteneur de titre dans les tuiles d'objets pour garantir un alignement horizontal parfait des prix et des boutons d'achat.
- **Gain** : **Moyen** (Rigueur visuelle dans l'écran de récompense le plus visité).
- **Effort** : **Très faible** (Propriété `maxLines: 2` et `height` fixe).
- **Risque** : **Nul**.

### P5. Ajouter une loupe / aperçu modal sur les cartes de la Bataille des Légendes
- **Action** : Permettre à l'élève d'effectuer un appui long sur une carte en jeu pour l'afficher en grand format au centre de l'écran avec ses statistiques et sa notice mythologique bien lisibles.
- **Gain** : **Élevé pour l'accessibilité** et la jouabilité sur petit smartphone.
- **Effort** : **Moyen**.
- **Risque** : **Très faible**.

---

## 9. Conclusion et synthèse

L'application **Ludus Latinus** possède une identité graphique forte, cohérente et très immersive qui rivalise avec les meilleures productions ludo-éducatives. Les 8 piliers de la direction artistique romaine sont solidement ancrés dans le parcours de l'élève, et l'adaptation aux tablettes est d'ores et déjà exemplaire. Les anomalies relevées sont mineures et relèvent d'un polissage final avant publication officielle.
