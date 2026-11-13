# Play Console : réponses du tableau de bord

**Saisi dans la Play Console le 13/11/2026** (déclarations enregistrées, à envoyer pour examen depuis la « Vue d'ensemble de la publication »). Document interne, rédigé le 12/11/2026, menu « Contenu de l'application ». Les réponses sont vérifiées sur le code. Depuis l'Édition complète (commit `d7b0bb2`, AAB n° 100), la bibliothèque Google Play Billing ajoute les permissions INTERNET et BILLING au build de publication ; l'appli elle-même n'envoie toujours rien. Les lignes marquées (Billing) changent quand l'achat est activé en production.

## Règles et programmes

| Rubrique | Réponse | Raison |
|---|---|---|
| Règles de confidentialité | https://icareetdedale.fr/confidentialite/ | Page en ligne depuis le 19/10, section Ludus Latinus. |
| Accès à l'application | « Toutes les fonctionnalités sont disponibles sans restriction d'accès » | Aucun compte, aucun code. (Billing) : l'achat n'est pas une restriction d'accès au sens de Google, la réponse ne change pas. |
| Annonces | **Non**, l'application ne contient pas d'annonces | Aucune régie, aucune bibliothèque publicitaire. |
| Applications d'actualités | Non | |
| Applications de santé | Non | |
| Fonctionnalités financières | Aucune | Les sesterces sont une monnaie de jeu sans valeur réelle. |
| Applications gouvernementales | Non | |
| Identifiant publicitaire | Non utilisé | Aucune bibliothèque qui le lit. |
| Sécurité des données | Voir `securite_des_donnees.md` : aucune collecte, aucun partage | (Billing) : relire la rubrique « Historique d'achats » à l'ajout de l'achat. |

## Public cible et contenu (programme Familles)

| Question | Réponse | Raison |
|---|---|---|
| Tranches d'âge | **9 à 12 ans** et **13 à 15 ans** | Google n'a pas de tranche 12-15 : un élève de 5e a 11 ou 12 ans, donc la tranche 9-12 doit être cochée. Cocher une tranche sous 13 ans applique les règles Familles, que l'appli respecte déjà. |
| L'appli pourrait-elle attirer involontairement des enfants ? | sans objet | La question ne se pose que si aucune tranche enfant n'est cochée. |
| Exigences Familles | Respectées | Pas de pub, pas de collecte, pas de lien sortant vers un achat hors Play, pas de connexion sociale. |
| Programme « Approuvé par les enseignants » | Accepter d'être évalué | Facultatif, gratuit, utile pour la visibilité auprès des familles. |

## Classification du contenu (questionnaire IARC)

Catégorie : **Éducation** (« Référence, actualités ou éducation » si le questionnaire propose ce libellé ; sinon « Jeu », car l'appli contient des jeux. Prendre Éducation en premier).

| Thème | Réponse | Raison |
|---|---|---|
| Violence | **Oui, légère et non réaliste** : combats stylisés, sans sang | Duels de gladiateurs au vocabulaire, monstres mythologiques (Minotaure, sanglier d'Érymanthe), batailles de cartes. Aucun sang, aucune blessure montrée. |
| Peur | Non | Les créatures sont dessinées pour des collégiens. |
| Sexualité, nudité | Non | Le mot « lupanar » a été retiré du dictionnaire (octobre 2026). |
| Langage grossier | Non | |
| Drogues, alcool, tabac | **Oui : alcool, simple référence, rare** | Le contenu parle du vin : *vinum* au monde 8, Bacchus, Polyphème enivré par Ulysse. Le cacher exposerait à un refus pour déclaration trompeuse. |
| Jeux d'argent simulés | **Non** | La taverne joue aux dés (approcher XXI), mais l'élève ne mise rien et ne perd jamais de sesterces : une victoire en rapporte, une défaite ne coûte rien. Si l'IARC demande une précision, la donner ainsi. |
| Interactions entre utilisateurs, partage de position | Non | Hors ligne. |
| Achats numériques | Non pour l'instant. (Billing) : **Oui** dès l'ajout de l'Édition complète. | |

Catégorie retenue : **Jeu** (l'appli contient des jeux). Violence déclarée : contre des humains (duels) et des créatures, cadre fantastique, style enfantin, réactions irréalistes, violence évoquée et rarement montrée de loin, aucun sang, pas de contexte de guerre réel.

**Classification obtenue (13/11/2026)** : PEGI 3 (Europe), ESRB Tout public (légère violence fictive, mention d'alcool), USK 6, tous publics en Australie, au Brésil et ailleurs ; Corée 15+ et Taïwan 15 à cause de l'alcool (appli non diffusée là-bas).

## Fiche principale

Recopier `fiche_store.md` (nom, description courte, description complète) et les visuels de `ludus_latinus_mobile/store/` :
- icône `icone_play_store_512.png` ;
- image de présentation `presentation_1024x500.png` ;
- captures téléphone : les 8 de `captures/`, dans l'ordre des numéros ;
- captures tablette 10 pouces : les 8 de `captures_tablette/`. Les captures 7 pouces ne sont pas obligatoires.

Catégorie : Enseignement (Éducation). Coordonnées : icareetdedale.studio@gmail.com, site https://icareetdedale.fr/. **Saisi le 13/11/2026**, captures téléphone importées depuis `store/captures_9x16/` (voir `fiche_store.md`).

(Billing) : avant la production, ajouter à la description la phrase sur l'Édition complète, prévue dans `fiche_store.md`, « À revoir avant la mise en production ».

## Autres déclarations saisies le 13/11/2026

- Informations de connexion : « Non », aucune section limitée. **(Billing) : à repasser en « Oui » quand l'achat sera actif** (les produits payants comptent comme restriction) et fournir aux examinateurs un moyen d'accéder aux leçons réservées, car ils ne peuvent pas acheter.
- Programme « Approuvé par les enseignants » : inscrit.
- Sécurité des données : aucune collecte ; mention « S'engage à respecter les règles pour les contenus familiaux de Play » affichée.
- Certification COPPA / RGPD cochée (appli sans collecte).
- Statut de professionnel : « Oui » (EI Icare & Dédale), sans URL de conditions d'utilisation. Vérifier que les coordonnées publiques du compte ne montrent rien de personnel.
