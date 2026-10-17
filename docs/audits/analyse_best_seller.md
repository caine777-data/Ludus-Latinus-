# Ce qui manque à Ludus Latinus pour devenir une référence du Play Store

Analyse de l'architecte (17/10/2026), fondée sur l'inventaire `docs/audits/inventaire_fonctionnel.md` (commit 37354b7). Chaque piste est une proposition : rien n'est appliqué sans l'accord de Cédric.

## Le constat en une phrase

Le contenu et le jeu sont déjà au niveau d'un bon titre (113 leçons, 9 jeux, cinématiques, révision espacée, série de jours, aucune publicité). Ce qui manque est autour : la confiance (données, promesses tenues), la raison de revenir chaque jour, et le professeur de latin, qui est le vrai prescripteur.

## Points forts à garder en avant

- Un contenu aligné sur le collège (5e, 4e, 3e), rare sur le Store.
- Un univers cohérent : Rome, Lupulus, Panthéon, Via Appia, cinématiques.
- Hors ligne, sans publicité, sans achat de monnaie : argument fort auprès des parents.
- Déjà en place : révision espacée (Memoria), série de jours, quête quotidienne, rangs du Cursus Honorum, fiches A4 à imprimer.

## Priorité 1 : ce qui bloque ou fait chuter la note

Ces points ne rendent pas l'appli meilleure, mais leur absence vaut des refus de Google ou des avis à une étoile.

| Manque | Pourquoi c'est grave | Proposition | Effort |
|---|---|---|---|
| Faux « compte Tabularium Cloud » | Il fait saisir l'e-mail d'un enfant et affiche une synchronisation qui n'existe pas. Pour le programme Familles, c'est une donnée personnelle collectée et une promesse trompeuse. | Retirer le champ e-mail et la date de synchronisation, ou renommer en « sauvegarde » réelle (voir ligne suivante). | faible |
| Faux « code Tessera » | Valeur fixe `SPQR-7A2B-9C1D`, sans import possible : promesse non tenue. | Le brancher sur l'export/import déjà codé (`exportProfileJson`, `importProfileJson`), ou le retirer. | faible |
| Progression perdue au changement d'appareil | Premier motif d'avis négatif sur les applis à progression. | La sauvegarde Android automatique couvre déjà le fichier si l'utilisateur l'a activée (pas de `allowBackup="false"`). Ajouter en plus un export/import de fichier visible dans les réglages. | faible |
| Permission `INTERNET` inutilisée | Google la signale aux familles, et elle fait douter. | La retirer du manifeste de release (garder celle du debug). | très faible |
| Politique de confidentialité | Obligatoire pour une appli destinée aux enfants. | Une page simple : aucune donnée collectée, aucun réseau. Hébergée sur une adresse neutre (pas GitHub au nom réel). | faible |
| Fiche Store vide | Sans captures ni texte, aucun téléchargement. | 8 captures téléphone et tablette, image de présentation 1024 × 500, description courte et longue. | moyen |
| Contenus prêts mais muets | 8 succès (et non 80, corrigé le 17/10), 24 termes de glossaire et 32 cartes de collection dorment dans le dataset. | Remplacer les succès par un catalogue de 32, un par carte (voir priorité 2) ; trancher pour le reste : brancher ou retirer du dataset. | moyen |

## Priorité 2 : la raison de revenir chaque jour

Les applis ludo-éducatives qui dominent le Store reposent sur la même boucle : un rappel, une petite séance, une récompense visible, une série à ne pas casser. Ludus Latinus a la série et la récompense, il lui manque le rappel et l'objectif.

| Manque | Proposition | Effort |
|---|---|---|
| Aucun rappel | Notification locale quotidienne, sans réseau, à l'heure choisie par l'élève, dans la voix de Lupulus (« Ta série de 5 jours t'attend »). Désactivable, désactivée par défaut si le programme Familles l'exige. | moyen |
| Succès invisibles | Catalogue de 32 succès, un par carte du second album, avec un écran d'album et une annonce à l'obtention : `docs/propositions/succes_et_cartes.md`. | moyen |
| Pas d'objectif de séance | « Objectif du jour : 1 leçon ou 10 cartes Memoria », barre qui se remplit à l'accueil. | faible |
| Collection limitée au Panthéon | Second album « Héros et Créatures » : les 32 cartes de `content/cartes_data.py` (rareté, citation, anecdote), chacune gagnée par un succès. 32 illustrations à générer dans le style du Panthéon. Retenu par Cédric le 17/10/2026. | moyen |
| Aucun jeu ne se sert de la collection | Bataille de cartes dans Ludi, contre un adversaire romain : le joueur ne joue que les cartes de son second album ; à chaque manche, une question de latin des mondes vus active sa carte. Bonne réponse : il choisit de comparer l'attaque ou la défense ; mauvaise réponse : l'adversaire choisit. Victoire en sesterces, jeu ajouté au tirage de la quête quotidienne. Dépend du second album et des succès. Retenu par Cédric le 17/10/2026. | moyen |
| Série fragile | Un « bouclier de série » (un jour manqué pardonné par semaine), gagné en sesterces. Évite le découragement après une absence. | faible |
| Pas de bilan de semaine | Écran du lundi : leçons faites, mots révisés, série. Sert aussi aux parents. | faible |

## Priorité 3 : le professeur, prescripteur n° 1

Un élève ne cherche pas « latin » sur le Store : son professeur ou ses parents le lui recommandent. Un professeur de latin qui adopte l'appli la prescrit à toutes ses classes, chaque année.

| Manque | Proposition | Effort |
|---|---|---|
| Aucun lien explicite avec le programme | Afficher pour chaque monde la notion du programme de LCA (Langues et cultures de l'Antiquité, cycle 4) qu'il couvre. Une page « Pour les professeurs » dans l'appli. | faible |
| Aucun suivi pour l'adulte | Un « bulletin » imprimable ou en PDF : leçons faites, étoiles, notions acquises, série. Sans serveur, l'élève le montre ou l'envoie lui-même. | moyen |
| Un seul profil par appareil | Plusieurs profils (fratrie, tablette de classe). Le stockage actuel (un seul fichier) s'y prête : un fichier par profil. | moyen |
| Pas de mode classe | Version légère sans serveur : le professeur choisit un monde, l'appli propose un « code de séance » qui ouvre les leçons visées. Une vraie classe en ligne demanderait un serveur, des comptes et une déclaration de données : à écarter pour l'instant. | moyen |

## Priorité 4 : la qualité perçue

| Manque | Proposition | Effort |
|---|---|---|
| Pas de voix latine | Enregistrer les phrases clés (devises du Panthéon d'abord, puis exemples des leçons) en prononciation restituée. C'est ce que les professeurs demandent le plus pour une langue ancienne. | élevé (enregistrements) |
| Accessibilité faible | Option police adaptée à la dyslexie, réglage de taille du texte, libellés pour lecteur d'écran sur les boutons principaux. Compte dans l'évaluation par les enseignants. | moyen |
| Aucune mesure des plantages | Les « Android vitals » de la Play Console suffisent au départ, sans SDK ni collecte. Pas d'analytics dans une appli pour enfants. | nul |
| Poids de l'appli | 56 Mo par architecture aujourd'hui, environ 65 Mo d'images de leçon à venir. Au-delà de 150 Mo, beaucoup de parents renoncent sur un téléphone plein. À décider : rester en JPG d'origine, ou accepter un passage en WebP pour les seules illustrations de leçon. | à trancher |

## Ce qui ne ferait pas un best-seller

- **La traduction seule.** Le latin y est enseigné à travers la grammaire française (« COD », « sujet », phrases traduites en français). Traduire l'interface ne suffit pas : il faudrait réécrire les leçons pour chaque pays et son programme (Italie, Espagne, Royaume-Uni). Le premier marché est la France, où l'appli peut devenir la référence du latin au collège.
- **Le multijoueur en ligne et les classements.** Ils demandent serveur, comptes et modération, et compliquent le programme Familles pour un gain faible.
- **L'achat de monnaie ou la publicité.** Ils sont déjà exclus par décision de Cédric, à juste titre : c'est un argument de vente.

## Le badge à viser

Google Play attribue le badge « Approuvé par les enseignants » à des applis du programme Familles, évaluées par des enseignants sur l'intérêt pédagogique, le plaisir, la conception et l'adéquation à l'âge. Les priorités 1 à 3 visent exactement ces critères. Une fois l'appli publiée dans le programme Familles, elle peut être évaluée.

## Ordre proposé

1. **Avant le test fermé** : priorité 1 (sauf la fiche Store, qui peut suivre).
2. **Pendant le test fermé** : rappel quotidien, succès, objectif du jour. Les retours des 12 testeurs diront si la boucle tient.
3. **Avant la production** : fiche Store, page professeurs, bulletin imprimable.
4. **Après la sortie** : plusieurs profils, voix latine, accessibilité, code de séance.
