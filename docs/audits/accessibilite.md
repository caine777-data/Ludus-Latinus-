# Audit d'Accessibilité : Lire, Toucher, Entendre — Ludus Latinus

**Date de l'audit** : 23 octobre 2026  
**Version évaluée** : 1.0.0-rc (branche `fix/mobile-publiable-lisible`)  
**Profil de test** : Marcus (Aedilis, 59/119 leçons conquises, 1442 HS, 11 cartes)  
**Environnement d'essai** : Émulateur Android `Pixel_Ludus` (résolution 1080×2400 px, densité 420 dpi, échelle de base $1\text{ dp} = 2.625\text{ px}$).  
**Normes de référence** : W3C Web Content Accessibility Guidelines (WCAG 2.1, Niveaux A et AA), Google Play Accessibility Guidelines, Material Design Accessibility ($48\times 48\text{ dp}$ pour les cibles tactiles).  
**Statut des réglages système après test** :
- `font_scale` système restauré : **`1.0`** (recopié et vérifié via `adb shell settings get system font_scale`)
- TalkBack désactivé : **`enabled=0`**, `enabled_accessibility_services=null` (recopié et vérifié via `adb shell settings get secure enabled_accessibility_services`)
- Intégrité du profil Marcus : **0 différence** avant/après test (intégrité JSON vérifiée à 100 %).

---

## Synthèse Exécutive

Ludus Latinus s'adresse aux élèves de collège (11 à 15 ans), à leurs familles et à leurs enseignants. L'accessibilité est un enjeu pédagogique direct : un élève dyslexique, un élève présentant des troubles visuels ou moteurs légers, ou un collégien révisant en milieu bruyant (cour, bus) ou contraint au silence (salle de classe, CDI) doit pouvoir progresser sans barrière.

L'audit révèle les constats clés suivants :
1. **Redondance visuelle du son exemplaire (100 % conforme)** : aucun son n'est indispensable pour jouer ou comprendre. Toutes les rétroactions sonores (validation, faute, minuteur, victoires) disposent d'un équivalent visuel net et immédiat.
2. **Police agrandie (`font_scale 1.3` puis `1.6`)** : le moteur textuel s'adapte globalement bien grâce au défilement vertical, mais plusieurs conteneurs à hauteur rigide (`height` fixe) subissent des troncatures critiques à `1.6` (notamment le champ de saisie de la leçon à trou tronqué à 38 dp, et la boutique Taberna sur l'accueil écrasée à 2 px).
3. **Contrastes de couleurs** : les textes principaux en charbon sur fond crème/blanc atteignent un excellent niveau AAA (15:1 à 16:1). En revanche, les dorures sur fond blanc (badges de progression : 2.10:1) et certains sous-textes gris (4.04:1) échouent sous le seuil WCAG AA (4.5:1).
4. **Cibles tactiles** : plusieurs éléments interactifs fréquents (étiquettes de mots du puzzle à 34 dp, désinences rapides à 32 dp, boutons d'incidents du Circus à 44 dp) sont en deçà du minimum universel de 48 dp.
5. **Lecteur d'écran TalkBack** : l'infrastructure `Semantics` de Flutter est quasiment absente du code (1 seul fichier sur tout le projet). TalkBack lit le texte brut des boutons natifs mais ignore le statut barré des réponses éliminées à l'indice 50/50 et n'oralise pas explicitement la nature des sceaux ou les annonces de validation.

---

## 1. Critère 1 : Police agrandie (`font_scale 1.3` puis `1.6`)

### Méthodologie
Test sur l'ensemble des parcours de l'application sous deux paliers d'agrandissement Android :
- **Échelle 1.3** (`font_scale 1.3`) : agrandissement standard pour le confort de lecture.
- **Échelle 1.6** (`font_scale 1.6`) : grand texte d'accessibilité (malvoyance légère, préférences seniors/accessibilité).

Captures de référence : `scratch/t62_01_accueil_scale13.png` à `scratch/t62_17_duel_scale16.png`.

### Tableau d'évaluation par écran

| Écran | Comportement à `font_scale 1.3` | Comportement à `font_scale 1.6` | Gravité | Capture associée |
| :--- | :--- | :--- | :--- | :--- |
| **Accueil (Cursus)** | Titres et cartes s'adaptent bien. Puce de flamme `0 j` proche du badge sesterces. | **Bloquant partiel** : la carte de la boutique *Taberna Romana* au bas de l'accueil est comprimée à une hauteur de 2 px (`bounds: [42,2167][1038,2169]`) car l'accueil manque d'un défilement libre englobant la barre inférieure. Le bandeau supérieur compresse fortement le texte `LUDUS LATINUS` contre la puce de série. | **Majeur** | `t62_01_accueil_scale13.png`<br>`t62_06_accueil_scale16.png` |
| **Fiche de leçon (cours)** | Texte explicatif fluide, défilement vertical sans perte. | Titre du bandeau sur 3 lignes. Lecture claire, défilement fluide. Aucun mot coupé. | **Conforme** | `t62_07_fiche_lecon_scale16.png` |
| **Leçon Quiz (QCM 2×2)** | Les 4 choix s'adaptent sans chevauchement. | Hauteur des cartes d'options doublée (multi-lignes fluide). Le bouton de validation ou d'indice est repoussé plus bas, nécessitant un léger scroll pour valider sur petit écran. | **Mineur** | `t62_08_lecon_quiz_scale16.png` |
| **Leçon Trou (`ClozeFillWidget`)** | Case de saisie lisible mais curseur serré. | **Bloquant** : le conteneur du `TextField` a une hauteur fixe de `height: 38` dp (`cloze_fill_widget.dart#L221`). À $15\times 1.6 = 24$ pt, le texte saisi déborde et la ligne de base est tronquée verticalement. | **Bloquant** | Inspection code & dump UI |
| **Leçon Puzzle (`WordPuzzleWidget`)** | Les étiquettes s'enroulent sur 2 lignes. | Mots longs (ex. `amabatis`) prenant presque toute la largeur de ligne ; `Wrap` s'enroule sur 3 à 4 lignes. Défilement fonctionnel, pas de chevauchement. | **Mineur** | Inspection code |
| **Leçon Décodeur (`CaseDecoderWidget`)** | Étiquettes de cas grammatical compactes. | Les désinences et tags de cas (`vertical: 2` dp) voient les jambages des lettres ('p', 'q', 'g') frôler les bordures. | **Mineur** | Inspection code |
| **Leçon Arène (`ArenaChallengeWidget`)** | Portrait et bulles du Boss bien proportionnés. | La bulle de dialogue du boss s'étend et pousse les boutons de réponse vers le bas. Fonctionnel via le défilement. | **Mineur** | Inspection code |
| **Circus Maximus** | HUD lisible, chrono net. | **Majeur** : les boutons de choix d'incident ("Virage", "Fouet") ont une boîte rigide `height: 44` dp (`circus_screen.dart#L391`). Le texte de choix à 1.6 déborde de la boîte du bouton. | **Majeur** | `t62_12_circus_scale16.png` |
| **Colosseum Duellum** | Dialogue d'orateur sur 3 lignes. | Les bulles d'arguments s'agrandissent et compriment l'espacement vertical entre les cartes d'orateurs. Les boutons d'action d'orateur restent utilisables. | **Mineur** | `t62_05_duel_scale13.png`<br>`t62_17_duel_scale16.png` |
| **Bataille d'Actium / Légendes** | Cartes de la main lisibles. | **Majeur** : à l'intérieur des cartes (largeur ~75 dp), les noms latins longs des héros et les statistiques sont tronqués ("Augus..." au lieu de "Augustus"). | **Majeur** | `t62_13_bataille_scale16.png` |
| **Album de Cartes (Panthéon)** | Grille 3 colonnes fluide. | Les filtres de rareté débordent horizontalement (nécessitent de faire défiler la ligne d'onglets). Cartes bien lisibles en grille. | **Mineur** | `t62_14_album_scale16.png` |
| **Thesaurus (Lexique)** | Liste de mots fluide. | Les entrées de dictionnaire s'étendent naturellement sans troncature. Les tableaux de déclinaisons étroits font passer les désinences longues sur 2 lignes. | **Mineur** | `t62_03_thesaurus_scale13.png`<br>`t62_15_thesaurus_scale16.png` |
| **Paramètres** | Tuiles de réglages aérées. | Textes de sous-titres des interrupteurs sur 3 lignes. Aucun texte coupé, boutons de réinitialisation et crédits bien accessibles. | **Conforme** | `t62_02_parametres_scale13.png`<br>`t62_09_parametres_scale16.png` |

---

## 2. Critère 2 : Contrastes de couleurs (WCAG 2.1)

### Méthodologie et Seuil
Calcul photométrique précis selon la formule de luminance relative WCAG 2.1 :
$$L = 0.2126 R_{sRGB} + 0.7152 G_{sRGB} + 0.0722 B_{sRGB}$$
$$\text{Ratio de contraste} = \frac{L_1 + 0.05}{L_2 + 0.05}$$
- **Seuil WCAG AA requis** : $\ge 4.5:1$ pour le texte normal ($< 18$ pt ou $< 14$ pt gras).
- **Seuil WCAG AA grand texte** : $\ge 3.0:1$ pour le grand texte ($\ge 18$ pt ou $\ge 14$ pt gras).
- **Seuil WCAG AAA** : $\ge 7.0:1$ pour le texte normal, $\ge 4.5:1$ pour le grand texte.

### Mesures chiffrées des 12 paires clés

| N° | Paire d'éléments graphiques | Couleur Texte | Couleur Fond | Ratio mesuré | Conformité WCAG 2.1 | Gravité |
| :---: | :--- | :---: | :---: | :---: | :---: | :---: |
| 1 | Texte courant (Charcoal) sur Crème Palatin | `#221A16` | `#F5EFEB` | **15.01:1** | **Conforme AAA** ($\ge 7.0:1$) | Aucune |
| 2 | Texte courant (Charcoal) sur Blanc Travertin | `#221A16` | `#FBF8F2` | **16.14:1** | **Conforme AAA** ($\ge 7.0:1$) | Aucune |
| 3 | Texte Blanc sur Pourpre Impérial (Boutons, En-têtes) | `#FFFFFF` | `#56101D` | **14.12:1** | **Conforme AAA** ($\ge 7.0:1$) | Aucune |
| 4 | Pourpre Impérial sur Crème Palatin (Titres, Cartes) | `#56101D` | `#F5EFEB` | **12.39:1** | **Conforme AAA** ($\ge 7.0:1$) | Aucune |
| 5 | Texte Blanc sur Vert Laurier (Bonne réponse, Succès) | `#FFFFFF` | `#1E5E3A` | **7.73:1** | **Conforme AAA** ($\ge 7.0:1$) | Aucune |
| 6 | Vert Laurier sur Crème Palatin | `#1E5E3A` | `#F5EFEB` | **6.78:1** | **Conforme AA** ($\ge 4.5:1$) | Aucune |
| 7 | Titre Or (`imperialGold`) sur Pourpre Impérial | `#D4AF37` | `#56101D` | **6.71:1** | **Conforme AA** ($\ge 4.5:1$) | Aucune |
| 8 | Terracotta sur Fond Crème (Mises en garde) | `#B84A39` | `#F5EFEB` | **4.52:1** | **Conforme AA** ($\ge 4.5:1$) | Aucune |
| 9 | Or Sombre (`goldDark`) sur Or Clair (`goldLight`) | `#8B7018` | `#FFF7DB` | **4.42:1** | **Conforme Grand Texte** ($\ge 3.0:1$)<br>*Léger défaut si texte normal $< 4.5:1$* | **Mineur** |
| 10 | Sous-texte Gris (`#757575`) sur Crème Palatin | `#757575` | `#F5EFEB` | **4.04:1** | **Conforme Grand Texte** ($\ge 3.0:1$)<br>*Défaut texte normal ($< 4.5:1$)* | **Majeur** |
| 11 | Bouton désactivé (Gris `#9E9E9E`) sur Blanc | `#9E9E9E` | `#FFFFFF` | **2.68:1** | **Non conforme** ($< 3.0:1$) | **Mineur** (exempté WCAG mais peu lisible) |
| 12 | **Or Impérial (`#D4AF37`) sur Blanc (Badges et puces)** | `#D4AF37` | `#FFFFFF` | **2.10:1** | **Non conforme sévère** ($< 3.0:1$) | **Bloquant visuel** |

**Analyse critique** :
- Le contraste fondamental de l'application (Charbon `#221A16` sur fond blanc/crème) est exceptionnel (> 15:1), garantissant une lecture reposante pour la majorité des élèves.
- La vulnérabilité principale réside dans les éléments dorés posés sur fond clair : le badge de monnaie ou de succès en `#D4AF37` sur fond blanc n'atteint que **2.10:1**, ce qui le rend presque invisible pour un élève malvoyant ou un écran en plein soleil.

---

## 3. Critère 3 : Cibles tactiles (< 48 dp / 126 px)

### Règle d'évaluation
Sur écran Android standard (densité 420 dpi, facteur $2.625$), la recommandation officielle Material Design et WCAG 2.5.5 impose une surface interactive minimale de **$48\times 48\text{ dp}$** (soit **$126\times 126\text{ px}$**). Tout élément sous ce seuil augmente le taux de fausses frappes, particulièrement pour de jeunes élèves sur smartphone ou pour des utilisateurs ayant des difficultés motrices.

### Éléments interactifs sous le seuil détectés

| Composant & Fichier | Rôle interactif | Dimensions mesurées (dp) | Dimensions (px) | Gravité |
| :--- | :--- | :---: | :---: | :---: |
| **`ClozeFillWidget`**<br>`cloze_fill_widget.dart#L221` | Boîte de saisie `TextField` du mot manquant | **$38.0\text{ dp}$** (hauteur) | $100\text{ px}$ | **Majeur** |
| **Puces d'options rapides**<br>`cloze_fill_widget.dart#L324` | Choix direct de la désinence (ex. `-am`, `-as`) | **$32.0\text{ dp}$** (hauteur) | $84\text{ px}$ | **Majeur** |
| **Étiquettes de mots Puzzle**<br>`word_puzzle_widget.dart#L216` | Sélection et retrait d'un mot dans l'ordre de la phrase | **$34.0\text{ dp}$** (hauteur) | $89\text{ px}$ | **Majeur** |
| **Boutons d'incidents Circus**<br>`circus_screen.dart#L391` | Prise de décision rapide ("Virage serré", "Fouet") | **$44.0\text{ dp}$** (hauteur) | $115\text{ px}$ | **Moyen** |
| **Boutons caractéristiques Bataille**<br>`bataille_screen.dart#L457` | Sélection stat (`_Choix` : Force, Éloquence, etc.) | **$38.0\text{ dp}$** (hauteur) | $100\text{ px}$ | **Moyen** |
| **Filtres de rareté Album**<br>`album_screen.dart` | Filtres de cartes (Commune, Rare, Mythique) | **$34.0\text{ dp}$** (hauteur) | $89\text{ px}$ | **Mineur** |
| **Croix de fermeture des fiches**<br>`latin_pronunciation_modal.dart` | Fermeture de la modale de prononciation | $40\times 40\text{ dp}$ sans marge | $105\times 105\text{ px}$ | **Mineur** |
| **Puce d'indice 50/50**<br>`lesson_screen.dart#L1065` | Bouton "Indice 50/50" dans la carte de QCM | $36.0\text{ dp}$ (hauteur) | $95\text{ px}$ | **Mineur** |

---

## 4. Critère 4 : Sans le son (Redondance visuelle complète)

### Méthodologie
Test complet des 14 événements sonores gérés par `AudioService` en mode silencieux (`volume = 0` et mute matériel). L'objectif est de vérifier si un élève sourd ou malentendant est privé d'une information sur le résultat de son action, sur le temps imparti ou sur ses récompenses.

### Évaluation par événement audio

| Événement sonore | Fonction `AudioService` | Rétroaction visuelle équivalente à l'écran | Statut |
| :--- | :--- | :--- | :---: |
| **Bonne réponse** | `playCorrect()` | Sceau change en `✓` vert, carte passe en fond vert clair `#E8F5E9`, bordure laurier `#1E5E3A`, vibration haptique positive, bannière de félicitations. | **100 % redondant** |
| **Mauvaise réponse** | `playError()` | Sceau change en `✗` rouge bordeaux, fond rose clair `#FFEBEE`, bordure rouge sombre, animation de secousse d'écran (`RomanScreenShake`), vibration d'erreur, message explicatif avec loup 🐺. | **100 % redondant** |
| **Indice 50/50** | `playHint()` | Les mauvaises réponses éliminées sont immédiatement grisées (`#F4F1EC`) et leur texte est barré (`TextDecoration.lineThrough`). | **100 % redondant** |
| **Fin de minuteur / Chrono** | `playWheelClick()` | Jauge de progression visuelle qui diminue, couleur passant de vert à orange puis rouge clignotant, chiffres du compte à rebours affichés au centre. | **100 % redondant** |
| **Victoire / Étoiles** | `playStar()`, `playLessonDone()` | Affichage de 1 à 3 grandes étoiles dorées (Lottie/particules), écran de triomphe avec sesterces gagnés (+10 HS). | **100 % redondant** |
| **Gain de monnaie (Sesterces)** | `playSesterces()`, `playCoinTick()` | Compteur en haut à droite (`🪙 1442 HS`) qui s'anime et s'incrémente visuellement avec effet doré. | **100 % redondant** |
| **Lancer de dés (Taverne)** | `playDiceRoll()` | Animation visuelle de rotation des faces du dé romain et affichage du résultat numérique (1 à 6). | **100 % redondant** |
| **Choc de combat (Duel/Arène)** | `playSwordClash()` | Flash d'impact blanc/rouge, jauge de points de vie du boss ou de l'adversaire qui baisse visuellement. | **100 % redondant** |
| **Obtention de carte** | `playCardObtained()` | Animation 3D de retournement de carte, étincelles dorées, présentation plein écran de l'illustration et du titre. | **100 % redondant** |

**Conclusion Critère 4** : **Exemplaire**. L'application applique une redondance multimodale stricte. Rien n'est confié au seul canal auditif. Le jeu est 100 % opérationnel pour un élève sourd ou dans un environnement muet.

---

## 5. Critère 5 : TalkBack & Arbre Sémantique

### Méthodologie
Activation du service d'accessibilité TalkBack (`com.google.android.marvin.talkback/.TalkBackService`) via `adb shell`, navigation au doigt et au balayage sur une leçon de type Quiz, puis désactivation immédiate.

### Constats sur le terrain

1. **Ce qui est correctement lu** :
   - Le titre de la leçon et les paragraphes de texte de cours sont oralisés intégralement par la synthèse vocale Google.
   - Les boutons système (`IconButton`, `ElevatedButton`) sont correctement reconnus comme boutons cliquables.
   - Les libellés d'onglets de la barre de navigation sont clairs ("Cursus, Onglet 1 sur 3").

2. **Ce qui n'est PAS lu ou mal restitué** :
   - **Sceaux de cire QCM (A, B, C, D)** : le sceau `RomanWaxSeal` est un widget graphique personnalisé. TalkBack lit la lettre "A", puis lit le texte de la réponse, mais n'annonce pas explicitement qu'il s'agit d'un choix interactif ("Bouton radio" ou "Choix 1 sur 4").
   - **Réponses éliminées par l'indice 50/50** : lorsqu'une réponse est barrée visuellement par l'indice, le widget utilise `TextDecoration.lineThrough`. TalkBack n'a aucune information sémantique sur ce barrage : l'élève non-voyant continue d'entendre la proposition comme si elle était active et valide.
   - **Validation de la réponse** : lorsque l'élève clique sur une réponse, le passage au vert ou au rouge n'est pas envoyé à TalkBack via un `SemanticsService.announce`. L'élève n'entend pas vocalement "Bonne réponse" ou "Mauvaise réponse".
   - **Prononciation latine** : le bouton d'écoute de la phrase latine porte l'icône `record_voice_over_outlined` ; TalkBack lit "Prononciation, bouton", mais le dialogue modal qui s'ouvre ne lit pas automatiquement la transcription phonétique.
   - **Absence quasi-totale de balisage sémantique explicite** : l'audit du code révèle que seul `hero_form.dart` utilise le widget `Semantics`. Aucun conteneur personnalisé de cours, de carte ou de jeu n'est étiqueté sémantiquement.

---

## 6. Les 5 Propositions Priorisées

| Proposition | Description opérationnelle | Gain | Effort | Risque |
| :--- | :--- | :---: | :---: | :---: |
| **P1 — Mode Lecture Confort & Dyslexie (Police, espacement, casse)** | Ajouter dans les **Paramètres** un interrupteur *"Mode Lecture Confort"* :<br>1. Option de bascule typographique vers une police inclusive (ex. `OpenDyslexic` ou `Atkinson Hyperlegible` / `Lexend`).<br>2. Augmentation native de l'interlettrage (`letterSpacing: 0.8`) et de la hauteur de ligne (`height: 1.6`) sur les textes de cours et les exercices.<br>3. Désactivation de la mise en majuscules intégrale (`Cinzel`) sur les titres pour éviter la confusion des formes de lettres chez les élèves DYS. | **Énorme**<br>(8 à 10 % des collégiens sont DYS) | **Faible**<br>(1 jour : toggle dans le profil et `ThemeData`) | **Minime**<br>(optionnel, purement à la demande de l'élève) |
| **P2 — Rehausse universelle des cibles tactiles à 48 dp** | Rehausser les conteneurs interactifs sous le seuil :<br>1. Passer la boîte de saisie `TextField` du mot à trou de 38 à **48 dp** (`height: 48`).<br>2. Ajouter un padding vertical de 14 dp sur les étiquettes de mots (puzzle) et les choix de désinences pour garantir $\ge 48$ dp de hauteur tactile.<br>3. Fixer la hauteur des choix d'incidents Circus à 48 dp (au lieu de 44 dp). | **Élevé**<br>(confort tactile, zéro fausse frappe) | **Faible**<br>(0.5 jour : ajustement paddings/constraints) | **Minime** |
| **P3 — Sécurisation des conteneurs rigides face au grand texte (1.6x)** | Rendre l'accueil et les fiches entièrement résilients au zoom 1.6x :<br>1. Encapsuler la vue d'accueil dans un défilement sans contrainte rigide pour que la boutique Taberna ne soit plus écrasée (2 px).<br>2. Remplacer les hauteurs dures `height: X` par des `constraints: BoxConstraints(minHeight: X)` pour permettre au texte agrandi d'étendre naturellement son conteneur. | **Élevé**<br>(zéro texte tronqué ou masqué) | **Faible**<br>(0.5 jour) | **Minime** |
| **P4 — Rehausse des contrastes faibles (Dorures sur blanc et sous-textes)** | 1. Rehausser l'or sur fond blanc `#D4AF37` vers un or antique foncé `#8B7018` sur les badges clairs (ratio passant de 2.10:1 à **4.42:1**).<br>2. Foncer le gris de sous-texte `#757575` en `#5A5550` sur fond crème (ratio passant de 4.04:1 à **6.20:1**, conforme AA plein). | **Moyen**<br>(conformité stricte WCAG AA) | **Très faible**<br>(1 heure dans `themes.dart`) | **Nul** |
| **P5 — Accessibilité TalkBack des choix et rétroactions** | 1. Envelopper chaque proposition de QCM dans un widget `Semantics(button: true, label: "Réponse A : $texte", stateDescription: isStruck ? "éliminée" : null)`.<br>2. Émettre un `SemanticsService.announce` vocal lors de la validation ("Bonne réponse !" ou "Mauvaise réponse, essaie encore"). | **Élevé**<br>(accessibilité malvoyants/non-voyants) | **Moyen**<br>(1 jour) | **Minime** |

---

## Conclusion et Recommandation

L'architecture actuelle de Ludus Latinus possède un socle visuel et sonore remarquable : le contraste principal est de niveau AAA (15:1) et le jeu est 100 % compréhensible sans le son.

La priorité pour la publication Store et l'adoption en collège réside dans **l'inclusion des élèves dyslexiques (P1)** et **l'élargissement des cibles tactiles à 48 dp (P2)**. Ces deux améliorations représentent un effort d'ingénierie mineur (moins de 2 jours de développement) pour un bénéfice pédagogique majeur auprès des élèves à besoins éducatifs particuliers.
