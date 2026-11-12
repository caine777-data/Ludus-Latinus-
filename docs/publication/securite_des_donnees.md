# Play Console : réponses au formulaire « Sécurité des données »

Document interne, à recopier dans la Play Console (Règles et programmes > Contenu de l'application > Sécurité des données). Valable tant que l'application n'a pas d'accès à Internet et pas d'achat intégré.

| Question | Réponse | Raison |
|---|---|---|
| Votre application collecte-t-elle ou partage-t-elle des types de données utilisateur obligatoires ? | **Non** | Aucune donnée ne quitte l'appareil : pas de permission INTERNET dans le build de publication. |
| Les données sont-elles chiffrées en transit ? | sans objet | Aucune transmission. |
| Les utilisateurs peuvent-ils demander la suppression de leurs données ? | sans objet | Rien n'est collecté ; désinstaller l'appli efface tout. |
| URL de la politique de confidentialité | https://icareetdedale.fr/confidentialite/ | Domaine du studio depuis le 19/10/2026 ; l'ancienne adresse Netlify y redirige. |

## À revoir si

- **Édition complète (codée le 12/11/2026)** : la permission BILLING figure dans tous les builds Android, même quand l'achat est coupé. L'appli n'envoie rien elle-même : le paiement et l'historique d'achats sont traités par Google Play. À la mise en production payante, vérifier dans l'aide de la Play Console si « Historique d'achats » doit être déclaré ;

- **un achat intégré est ajouté** : Google Play Billing traite le paiement. Relire la déclaration « Historique d'achats » : Google indique que les données traitées par sa propre bibliothèque de facturation n'ont pas à être déclarées par le développeur, mais il faut le vérifier dans l'aide de la Play Console au moment de l'ajout ;
- **une fonction en ligne est ajoutée** (synchronisation, classement) : tout le formulaire est à refaire.
