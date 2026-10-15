# Google Play Console

Créer un compte développeur et mettre Ludus Latinus en test interne

---

## Le principe

Le compte développeur Google Play permet de publier une application sur le Play Store. Il coûte 25 dollars, payés une seule fois. Google vérifie votre identité avant d'ouvrir le compte : comptez quelques jours.

Le compte permet de :

- installer l'application sur un téléphone par le Play Store, en test, même sous Family Link ;
- recevoir les mises à jour automatiquement sur les appareils des testeurs ;
- publier ensuite l'application pour tout le monde.

> **À faire AVANT de créer un nouveau compte**
>
> Retrouvez le courriel de Google qui annonçait la désactivation de l'ancien compte.
>
> Désactivation pour inactivité ou pour identité non vérifiée : vous pouvez créer un nouveau compte.
>
> ⚠ Résiliation pour non-respect du règlement : n'en créez pas d'autre. Google ferme les nouveaux comptes liés à un compte résilié, sans rembourser les 25 dollars. Faites plutôt appel depuis l'ancien compte : un seul appel est possible.

> **À préparer**
>
> Être majeur.
>
> Un compte Google réservé à vos applications (conseillé), avec son adresse courriel et un numéro de téléphone.
>
> Votre nom légal et votre adresse, exactement comme sur votre pièce d'identité.
>
> Une pièce d'identité en cours de validité (carte d'identité ou passeport) et une carte bancaire.
>
> Un téléphone ou une tablette Android à vous ou à un proche, pour la vérification de l'appareil.

## Étape 1. Choisir le type de compte

1. Ouvrez **play.google.com/console** et connectez-vous avec le compte Google choisi.
2. Choisissez le type de compte : **personnel** ou **organisation**.

> **Personnel ou organisation**
>
> Personnel : pour vous en tant que particulier. Pas de numéro D-U-N-S. Avant la première publication publique, Google impose un test fermé (voir l'étape 6).
>
> Organisation : seulement pour une structure déclarée (entreprise, micro-entreprise, association) avec un numéro D-U-N-S. Le test fermé n'est pas exigé.
>
> Icare & Dédale n'est pas encore une structure déclarée : choisissez **personnel**.

## Étape 2. Renseigner le compte

1. Saisissez votre nom légal et votre adresse, comme sur votre pièce d'identité.
2. Saisissez le nom de développeur public : **Icare & Dédale**. C'est le nom affiché sous l'application dans le Play Store.
3. Saisissez l'adresse courriel et le numéro de téléphone de contact, puis validez chacun avec le code reçu.
4. Acceptez le contrat de distribution pour les développeurs, puis payez les 25 dollars.

> **Ce qui devient public**
>
> Le nom de développeur et l'adresse courriel de contact s'affichent sur la fiche de l'application.
>
> Pour une application gratuite, sans publicité ni achat intégré, votre adresse postale n'est pas affichée. Si l'application devient payante, le droit européen (règlement sur les services numériques) impose d'afficher les coordonnées du vendeur : Google vous demandera alors de les déclarer.
>
> Utilisez une adresse courriel dédiée aux applications plutôt que votre adresse personnelle.

## Étape 3. Faire vérifier votre identité

1. Dans la Play Console, ouvrez la demande de vérification d'identité.
2. Envoyez une photo nette de votre pièce d'identité, recto et verso.
3. Patientez : la vérification prend en général quelques jours. Google vous prévient par courriel.

> **Si la vérification échoue**
>
> La cause la plus fréquente est un écart entre le nom ou l'adresse saisis et ceux de la pièce d'identité ou du profil de paiement. Corrigez l'écart, puis renvoyez la demande.

## Étape 4. Vérifier un appareil Android

1. Sur le téléphone ou la tablette Android, installez l'application **Google Play Console** depuis le Play Store.
2. Connectez-vous avec le même compte Google que celui du compte développeur.
3. Suivez la demande de vérification de l'appareil.

L'appareil ne sert qu'à cette vérification : il peut être emprunté.

## Étape 5. Créer l'application et l'envoyer en test interne

1. Dans la Play Console, créez une application : nom **Ludus Latinus**, langue par défaut français, application gratuite, jeu.
2. Avant d'envoyer l'application, ajoutez les 4 secrets de signature dans GitHub : la marche à suivre est dans `ludus_latinus_mobile/PUBLICATION.md`, sections 1 et 2.

> **⚠ La clé de signature ne se remplace pas**
>
> Sans les secrets, le fichier est signé avec une clé de test : le Play Store le refuse.
>
> Gardez une copie du fichier `.jks` et de ses mots de passe hors du PC (NAS, clé USB). Sans eux, vous ne pourrez plus envoyer de mise à jour avec la même clé.

3. Sur GitHub, ouvrez l'onglet **Actions**, puis la dernière compilation réussie.
4. En bas de la page, téléchargez l'archive **LudusLatinus-PlayStore**, puis décompressez-la : elle contient le fichier `LudusLatinus-PlayStore.aab`.
5. Dans la Play Console, ouvrez les tests internes, créez une version et déposez le fichier `.aab`.
6. Dans la liste des testeurs, ajoutez l'adresse Gmail de Clovis et la vôtre.
7. Copiez le lien d'inscription au test.
8. Sur l'appareil de Clovis, connecté à son compte, ouvrez le lien, acceptez l'invitation, puis installez l'application depuis le Play Store.

Family Link vous envoie alors une demande d'autorisation : validez-la sur votre téléphone.

> **Si le compte de Clovis ne peut pas rejoindre le test**
>
> Un compte d'enfant sous Family Link peut être bloqué pour les programmes de test. Installez alors l'application sur la tablette avec votre propre compte, inscrit comme testeur.

> **Avant le premier envoi**
>
> Pour une application destinée aux enfants, la Play Console demande de remplir le public cible, la classification du contenu et les règles de confidentialité. La liste est dans `PUBLICATION.md`, section 4.

## Étape 6. Préparer la publication publique

Un compte personnel récent ne peut pas publier tout de suite pour tout le monde.

1. Créez un test fermé et invitez au moins 12 testeurs.
2. Vérifiez que chacun accepte l'invitation par le lien : une adresse ajoutée sans acceptation ne compte pas.
3. Gardez les 12 testeurs inscrits pendant 14 jours de suite.
4. Au bout des 14 jours, demandez l'accès à la production. Google pose quelques questions sur le test : comment vous avez trouvé les testeurs, quels retours vous avez reçus, ce que vous avez corrigé.

> **Prévoir de la marge**
>
> Si le nombre de testeurs descend sous 12, le délai peut repartir de zéro. Invitez 15 à 20 testeurs : une classe, des familles volontaires, des collègues.
>
> Notez les retours des testeurs au fil des 14 jours : ils servent à répondre aux questions de Google.

> **⚠ Rien de public sans votre accord**
>
> Le passage en production rend l'application visible par tous dans le Play Store. Il ne se fait qu'à votre demande, après le test fermé.

## Aide et support

Les intitulés de la Play Console changent souvent : si un écran diffère de ce tuto, suivez l'aide officielle de Google, **support.google.com/googleplay/android-developer**.
