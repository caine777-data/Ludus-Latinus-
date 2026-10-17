# Play Console : réponses au formulaire « Sécurité des données »

Document interne, à recopier dans la Play Console (Règles et programmes > Contenu de l'application > Sécurité des données). Valable tant que l'application n'a pas d'accès à Internet et pas d'achat intégré.

| Question | Réponse | Raison |
|---|---|---|
| Votre application collecte-t-elle ou partage-t-elle des types de données utilisateur obligatoires ? | **Non** | Aucune donnée ne quitte l'appareil : pas de permission INTERNET dans le build de publication. |
| Les données sont-elles chiffrées en transit ? | sans objet | Aucune transmission. |
| Les utilisateurs peuvent-ils demander la suppression de leurs données ? | sans objet | Rien n'est collecté ; désinstaller l'appli efface tout. |
| URL de la politique de confidentialité | https://icare-et-dedale.netlify.app/ludus-latinus/confidentialite/ | Site Netlify `icare-et-dedale`, source `netlify/`. |

## À revoir si

- **un achat intégré est ajouté** : Google Play Billing traite le paiement. Relire la déclaration « Historique d'achats » : Google indique que les données traitées par sa propre bibliothèque de facturation n'ont pas à être déclarées par le développeur, mais il faut le vérifier dans l'aide de la Play Console au moment de l'ajout ;
- **une fonction en ligne est ajoutée** (synchronisation, classement) : tout le formulaire est à refaire.
