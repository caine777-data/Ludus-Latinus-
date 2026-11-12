# Play Console : réponses du tableau de bord

Document interne (12/11/2026), à recopier dans la Play Console, menu « Contenu de l'application ». Les réponses sont vérifiées sur le code au commit `1bdeaef` : le manifeste fusionné de publication n'a pas de permission INTERNET (seulement notifications, démarrage, vibration, état réseau ajouté par une bibliothèque). L'Édition complète n'est pas encore codée : à son arrivée, relire les lignes marquées (Billing).

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
| Drogues, alcool, tabac | Non | Gaius est aubergiste, mais aucune boisson n'est montrée ni nommée. |
| Jeux d'argent simulés | **Non** | La taverne joue aux dés (approcher XXI), mais l'élève ne mise rien et ne perd jamais de sesterces : une victoire en rapporte, une défaite ne coûte rien. Si l'IARC demande une précision, la donner ainsi. |
| Interactions entre utilisateurs, partage de position | Non | Hors ligne. |
| Achats numériques | Non pour l'instant. (Billing) : **Oui** dès l'ajout de l'Édition complète. | |

Classification attendue : PEGI 3 ou 7 (la violence légère donne souvent PEGI 7).

## Fiche principale

Recopier `fiche_store.md` (nom, description courte, description complète) et les visuels de `ludus_latinus_mobile/store/` :
- icône `icone_play_store_512.png` ;
- image de présentation `presentation_1024x500.png` ;
- captures téléphone : les 8 de `captures/`, dans l'ordre des numéros ;
- captures tablette 10 pouces : les 8 de `captures_tablette/`. Les captures 7 pouces ne sont pas obligatoires.

Catégorie : Éducation. Coordonnées : icareetdedale.studio@gmail.com, site https://icareetdedale.fr/.

(Billing) : avant la production, ajouter à la description la phrase sur l'Édition complète, prévue dans `fiche_store.md`, « À revoir avant la mise en production ».
