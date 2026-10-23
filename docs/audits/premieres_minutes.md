# Audit : Les dix premières minutes d'un nouvel élève

Audit réalisé le 23 octobre 2026 sur émulateur Android Pixel_Ludus (1080 x 2400, densité 420, Android 16) sur la branche `fix/mobile-publiable-lisible`.
Profil initial sauvegardé avant le test (`scratch/t58_profil_avant.json`) puis intégralement restauré en fin de séance (`scratch/t58_61_restored_home.png`).
L'application a été réinitialisée à zéro via `adb shell pm clear com.luduslatinus.app` pour observer exactement l'expérience d'un collégien de 12 ans (classe de 5e) qui installe Ludus Latinus pour la première fois.

---

## 1. Mesure du sas d'entrée vers le latin

- Nombre de touchers mesuré avant la première question de latin :
  - **6 touchers** au minimum si l'élève regarde les vidéos d'introduction (11 secondes).
    1. Toucher la zone de saisie du prénom.
    2. Valider / fermer le clavier virtuel.
    3. Toucher « Entrer dans Rome ».
    4. Toucher « Avancer sur la route ».
    5. Toucher le jalon I (« L'Alphabet secret des Romains »).
    6. Toucher « À l'exercice ».
  - **8 touchers** si l'élève écourte activement les cinématiques (toucher « Passer » sur la vidéo Icare & Dédale, puis sur la cinématique d'introduction).

---

## 2. Chronologie minute par minute

| Temps | Écran | Action de l'élève | Ressenti et observation (élève de 12 ans) | Capture |
|---|---|---|---|---|
| 00:00 | Écran de démarrage noir puis vidéo Icare & Dédale | Regarde le logo (5 s). | Joli, fait pro, mais un peu long pour un démarrage d'application mobile. | `scratch/t58_01_splash.png` |
| 00:06 | Cinématique d'introduction en dessin animé | Regarde la vidéo (6 s) ou appuie sur « Passer ». | Graphisme soigné, ambiance péplum réussie, bouton « Passer » bien visible en haut à droite. | `scratch/t58_03_now.png` |
| 00:12 | Création du héros | Choisit le garçon, touche le champ nom. | Sympa de pouvoir choisir son avatar. Par contre, le clavier s'ouvre et cache tout le bas de l'écran. | `scratch/t58_04_now.png` |
| 00:25 | Saisie du prénom « Leo » | Tape son prénom au clavier. | **Friction** : Le bouton « Entrer dans Rome » a disparu sous le clavier. L'élève doit appuyer sur la touche retour ou la coche du clavier pour le retrouver. | `scratch/t58_05_keyboard.png`, `scratch/t58_06_name_entered.png` |
| 00:35 | Validation du héros | Appuie sur « Entrer dans Rome ». | Transition fluide vers l'accueil. | `scratch/t58_07_hero_ready.png` |
| 00:38 | Premier écran d'accueil | Observe l'accueil avant d'agir. | **Surcharge cognitive** : Beaucoup d'informations cryptiques d'un coup (« 55 HS », « Tiro », « 0 j », « 0/1 Memoria »). L'icône de boutique ressemble à des sacs cabas en plastique de supermarché. Lupulus dit déjà « Poursuis ta marche triomphale ! » alors qu'aucune leçon n'a été faite. | `scratch/t58_08_first_home.png` |
| 01:10 | Accueil | Appuie sur « Avancer sur la route ». | Le gros bloc bordeaux attire bien le regard et indique clairement la marche à suivre. | `scratch/t58_08_first_home.png` |
| 01:12 | Carte de la Via Appia | Découvre la carte de Rome et le jalon I. | Belle carte illustrée style parchemin. Le jalon I doré est évident. Les jalons suivants avec cadenas montrent la route à suivre. | `scratch/t58_09_map.png` |
| 01:25 | Jalon I | Appuie sur le jalon I. | Ouvre la fiche de cours. | `scratch/t58_09_map.png` |
| 01:28 | Fiche de cours m1-01 | Lit le cours sur la prononciation du C et du V. | Texte un peu dense pour un collégien impatient de jouer, mais les exemples sont clairs (« Kikéron », « Oueni, uidi, uici »). | `scratch/t58_11_after_tap_m1.png` |
| 02:00 | Fiche de cours m1-01 | Appuie sur « À l'exercice ». | Arrive enfin sur la première question de latin (après 2 minutes de configuration/lecture). | `scratch/t58_11_after_tap_m1.png` |
| 02:02 | Leçon m1-01 - Question 1 | Fait une première erreur exprès : choisit « Comme en français... ». | Secousse d'écran, case rouge avec croix. La boîte d'explication pédagogique s'ouvre. | `scratch/t58_12_m1_01_exercise_q1.png`, `scratch/t58_13_m1_01_error1.png` |
| 02:20 | Leçon m1-01 - Question 1 | Lit l'explication et appuie sur « Réessayer ». | Très bonne pédagogie : l'explication indique que le son « ch » est apparu plus tard en italien. L'option fausse est barrée et grisée au réessai, impossible de la reprendre. | `scratch/t58_14_m1_01_error1_scrolled.png`, `scratch/t58_15_m1_01_after_retry.png` |
| 02:35 | Leçon m1-01 - Question 1 | Fait une 2e erreur exprès : choisit « Comme un S... ». | Deuxième explication claire. Deux options barrées sur quatre. | `scratch/t58_16_m1_01_error2.png`, `scratch/t58_17_m1_01_error2_scrolled.png` |
| 02:50 | Leçon m1-01 - Question 1 | Choisit la bonne réponse « Toujours [K] : Kirkous ». | Validation verte, passage à la question 2. | `scratch/t58_20_m1_01_after_retry2.png`, `scratch/t58_21_m1_01_q1_correct.png` |
| 03:05 | Leçon m1-01 - Question 2 | Répond à la question 2 (prononciation du V). | Termine la leçon. | `scratch/t58_22_m1_01_result.png` |
| 03:20 | Bilan de victoire m1-01 | Observe le bilan de fin de leçon. | 1 étoile seulement à cause des 2 erreurs. Récompense : +4 HS au lieu de +10 HS. Légèrement punitif pour un débutant, mais Lupulus reste encourageant. | `scratch/t58_23_m1_01_victory_modal.png` |
| 03:35 | Retour sur la carte | Appuie sur « Continuer ». | L'appli ramène sur la carte : jalon I coché avec 1 étoile, jalon II débloqué, solde à 59 HS. Mais aucun retour automatique vers l'accueil pour voir l'impact sur les séries ou les quêtes. | `scratch/t58_24_after_lesson1.png` |
| 03:45 | Carte vers Accueil | Appuie sur la flèche retour vers l'accueil. | Une boîte de dialogue surgit : « Rappel quotidien d'entraînement ». | `scratch/t58_25_return_home_reminder.png` |
| 03:50 | Proposition de rappel | Valide ou ignore le rappel. | Dialogue système Android surgit immédiatement : « Allow Ludus Latinus to send you notifications? ». L'enchaînement de deux modales coup sur coup brise le rythme. | `scratch/t58_27_permission_dialog.png` |
| 04:05 | Accueil après leçon 1 | Observe l'accueil actualisé. | Bannière verte « Objectif atteint, bravo ! 1/1 ». C'est valorisant. En revanche, les onglets Bibliotheca et Ludi sont accessibles mais aucun indice ne dit à quoi ils servent. | `scratch/t58_28_home_clean.png` |
| 04:30 | Exploration onglet Ludi | Touche l'onglet « Ludi ». | Découvre 8 cases. Circus Maximus est jouable. Colosseum Duellum affiche « Termine 2 leçons pour entrer dans l'Arène » (jauge 1/2). Les autres sont verrouillées à 6, 12, 18 leçons. | `scratch/t58_29_ludi_tab.png` |
| 05:00 | Exploration onglet Bibliotheca | Touche l'onglet « Bibliotheca ». | Tout est à 0 (Memoria 0 mot, Forum 0 édifice, Épigraphie 0). Un collégien quitte vite cet onglet qui ressemble à un dictionnaire austère. | `scratch/t58_30_bibliotheca_tab.png` |
| 05:25 | Carte Via Appia - Leçon 2 | Ouvre le jalon II (« Saluer comme un Romain »). | Fiche de cours claire sur Salve, Salvete, Vale, Amicus. | `scratch/t58_34_map.png`, `scratch/t58_36_m1_02_sheet.png` |
| 05:55 | Leçon m1-02 - Exercice 1 (Syntaxe) | Résout le puzzle « Salve, amice ! ». | Interface de puzzle par mots étiquettes très ludique et intuitive. | `scratch/t58_37_m1_02_q1.png`, `scratch/t58_39_m1_02_after_q1.png` |
| 06:30 | Leçon m1-02 - Exercices 2 et 3 | Répond au QCM puis à la question de vocabulaire « amicus ». | **Friction bloquante** : Sur la question de vocabulaire, l'encadré vert « Optime ! » apparaît en bas et le bouton « Continuer » se retrouve sous le bord de l'écran. L'élève se retrouve coincé s'il ne pense pas à faire défiler manuellement vers le bas. | `scratch/t58_40_m1_02_q1_correct.png`, `scratch/t58_42_m1_02_q4.png`, `scratch/t58_44_scrolled.png` |
| 07:15 | Leçon m1-02 - Fin | Termine les questions 4 et 5 et obtient le bilan. | 2 étoiles, +7 HS. Le jalon II est validé. Total 66 HS. | `scratch/t58_46_m1_02_q5.png`, `scratch/t58_47_m1_02_victory.png`, `scratch/t58_48_map_after_m2.png` |
| 07:40 | Carte Via Appia - Leçon 3 | Ouvre le jalon III (« Se présenter : Comment t'appelles-tu ? »). | Fiche sur Quis es ? et Sum. | `scratch/t58_49_m1_03_sheet.png` |
| 08:00 | Leçon m1-03 - Exercice 1 (Trou) | Doit taper le verbe manquant « Romanus [mot] . ». | **Friction clavier** : En touchant le champ, le clavier virtuel masque complètement le bouton « Valider la terminaison ». L'élève doit deviner qu'il faut valider sur le clavier virtuel ou le replier. De plus, le bouton s'appelle « Valider la terminaison » alors que la consigne demande un mot entier. | `scratch/t58_50_m1_03_q1.png`, `scratch/t58_51_keyboard.png` |
| 08:45 | Leçon m1-03 - Exercices 2 à 5 | Enchaîne les 4 questions suivantes et termine sans faute. | 3 étoiles, +10 HS, mention « Optime ! Réussi du premier coup ». Très gratifiant. | `scratch/t58_52_after_enter.png` à `scratch/t58_57_m1_03_victory.png` |
| 09:15 | Retour accueil après 3 leçons | Revient sur l'écran d'accueil. | Le rang du héros est devenu « Civis Romanus » à la place de « Tiro ». Mais ce changement s'est fait en silence, sans fanfare ni félicitation. Lupulus répète la même phrase en boucle. | `scratch/t58_58_after_lesson3.png`, `scratch/t58_59_home_after_m3.png` |
| 09:45 | Vérification des déblocages | Ouvre l'onglet Ludi. | Colosseum Duellum est désormais débloqué (« Arène tactique des champions »). L'élève ne l'a appris que par hasard en ouvrant l'onglet de lui-même. | `scratch/t58_60_ludi_after_m3.png` |

---

## 3. Les 5 frictions les plus graves (classées par sévérité)

### 1. Le bouton « Continuer » caché sous la ligne de flottaison après chaque question de vocabulaire (Bloquant)
- **Constat** : Dans les leçons contenant des questions de vocabulaire (ex: m1-02 questions 3, 4, 5 et m1-03 questions 3, 4, 5), la validation affiche un encadré explicatif vert (« Optime ! ») tout en bas du conteneur défilant. Le bouton « Continuer » est repoussé sous le bord inférieur de l'écran (hors champ).
- **Impact sur un élève de 12 ans** : L'élève ne voit aucun bouton d'action. L'écran semble figé. S'il n'a pas le réflexe de scroller vers le bas, il reste bloqué ou abandonne l'application en pensant à un bug.

### 2. Le clavier virtuel recouvre complètement les boutons de validation (Majeur)
- **Constat** : À la création du héros (saisie du prénom) et dans les exercices à trou (saisie d'un mot dans m1-03), le clavier Android s'ouvre au-dessus du bouton de validation (« Entrer dans Rome » ou « Valider la terminaison »). L'application n'ajuste pas son défilement automatiquement.
- **Impact sur un élève de 12 ans** : Après avoir tapé son texte, l'élève cherche le bouton pour continuer et ne le voit plus. Il doit chercher comment masquer le clavier ou savoir que la touche Entrée du clavier peut parfois valider.

### 3. Tunnel d'entrée trop long et passif avant la première question de latin (Majeur)
- **Constat** : Il faut compter 6 à 8 touchers et plus de 2 minutes entre le lancement de l'application et la première réelle interaction avec la langue latine (2 vidéos d'introduction, écran de nom, tableau de bord d'accueil, carte de la Via Appia, fiche de cours textuelle, bouton vers l'exercice).
- **Impact sur un élève de 12 ans** : Les enfants testent des applications par l'action immédiate. Ce long sas administratif et passif donne une fausse impression d'austérité scolaire avant même le premier jeu.

### 4. Déblocages majeurs totalement silencieux (Arène Colosseum et rang Civis Romanus) (Moyen)
- **Constat** : À l'issue de la 2e/3e leçon, deux jalons majeurs sont franchis : le premier vrai mini-jeu de combat (Colosseum Duellum) se déverrouille dans l'onglet Ludi, et le rang du joueur passe de « Tiro » à « Civis Romanus ». Aucun pop-up, aucun badge d'alerte, aucune notification visuelle n'en informe l'élève à son retour de leçon.
- **Impact sur un élève de 12 ans** : L'élève continue de croire que l'application ne contient que la carte linéaire. L'effet de récompense et la fierté de monter en grade sont complètement gâchés par ce silence.

### 5. Jargon hermétique, sacs plastiques modernes et réplique statique de Lupulus sur l'accueil (Mineur à Moyen)
- **Constat** :
  - L'écran d'accueil affiche d'emblée des notions inconnues : « 55 HS » (sesterces non expliqués), « Tiro », « 0 j » (série), « 0/1 Une activité = 1 leçon réussie ou 10 cartes Memoria » (notion de Memoria inconnue d'un débutant).
  - L'icône de la boutique romaine représente des sacs cabas en papier/plastique de supermarché moderne aux couleurs criardes rose et vert.
  - Le loup Lupulus accueille le débutant dès son arrivée avec « Poursuis ta marche triomphale ! » alors qu'aucune victoire n'existe encore, et répète mot pour mot cette même phrase après la leçon 1, 2 et 3.
- **Impact sur un élève de 12 ans** : Déconnexion avec l'immersion antique et sensation d'un compagnon robotique qui parle dans le vide.

---

## 4. Les 5 propositions d'amélioration

| N° | Proposition | Gain attendu | Effort | Risque |
|---|---|---|:---:|:---:|
| 1 | **Bouton « Continuer » ancré en bas d'écran (Sticky Bottom Bar) lors du feedback** : Rendre le bouton « Continuer » fixe en bas d'écran ou faire un auto-scroll instantané vers le bas dès l'affichage du bloc « Optime ! ». | Supprime immédiatement le risque d'abandon où l'élève croit l'appli bloquée. | **S** | Nul |
| 2 | **Auto-scroll au focus du champ texte (Keyboard Avoidance)** : Ajouter un défilement automatique qui garde le champ et le bouton de validation bien visibles au-dessus du clavier virtuel. | Saisie fluide du nom et des exercices à trou sans bouton masqué. | **S** | Nul |
| 3 | **Embarquement direct dans la leçon 1 au premier lancement (Fast-Track Onboarding)** : Après la saisie du héros, enchaîner directement sur l'ouverture de la première leçon (« Découvrons ensemble l'alphabet de Rome ! ») plutôt que de le déposer sur un accueil complexe. | Réduit l'accès au premier mot de latin de 6-8 clics à 2 clics. Immersion immédiate. | **M** | Faible |
| 4 | **Pop-up de félicitation et d'invitation lors des déblocages majeurs** : Dès la fin de la 3e leçon, afficher une modale festive : « Félicitations ! Tu es désormais Civis Romanus et l'Arène du Colisée t'ouvre ses portes ! » avec bouton direct « Entrer dans l'Arène ». | Décuple la motivation, récompense l'effort et fait découvrir les modes de jeu au moment idéal. | **S** | Nul |
| 5 | **Remplacement du sac plastique de la boutique et dialogues dynamiques de Lupulus** : Utiliser une icône d'amphore ou de bourse en cuir romaine pour la Taberna, et adapter le message de Lupulus (ex. Bienvenue au début, encouragement après une erreur, félicitation après la première leçon). | Renforce l'immersion antique et donne vie au compagnon d'apprentissage. | **S** | Nul |

---

## 5. Bilan et restauration du profil

- **Profil restauré avec succès** : Profil original de Marcus réinjecté dans `app_flutter/ludus_latinus_save.json` (`scratch/t58_61_restored_home.png`).
- Données restaurées vérifiées : Marcus, rang Aedilis, 59/119 leçons conquises, 1442 HS, équipements et inventaire conformes.
- Paramètres système de l'émulateur vérifiés : `pointer_location` = 0, `show_touches` = 0.
