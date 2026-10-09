# Les quatre décodeurs : phrases nouvelles, ordre varié, génitif

Proposition de l'architecte (09/10/2026), point 2 de l'audit des leçons
(`docs/audits/audit_lecons_2026-10-02.md`, défaut 4). Validée par Cédric le
09/10/2026, avec la version simple pour `m9-04` ; intégrée le même jour.

## Ce qui ne va pas aujourd'hui

1. **Deux décodeurs sur quatre ne s'affichent pas.** `m8-04` et `m9-04`
   rangent leurs mots dans `phrase_latine` et `mots_francais`, mais l'appli
   ne lit que `mots`. Résultat : l'élève voit le cours et aucun exercice.
2. **Les quatre phrases ont le même ordre** : sujet, COD, verbe. L'élève
   peut répondre « premier mot = sujet » sans lire une seule terminaison,
   alors que le monde 4 enseigne justement que l'ordre est libre.
3. **Le cours donne la réponse.** En `m4-04` et `m5-04`, le cours analyse
   mot par mot la phrase que l'élève doit ensuite décoder.
4. **Le verbe a deux couleurs** : le cours annonce 🟡 doré, le bouton de
   l'appli affiche 🟢. Le vert est la couleur du génitif dans les cartes
   des cas : il faut donc garder 🟡 pour le verbe.

## La règle suivie

Le cours garde une phrase modèle analysée. L'exercice décode une **autre**
phrase, avec un ordre des mots différent du modèle. Tous les mots viennent
du vocabulaire déjà vu dans le monde ou avant (vérifié dans le Thesaurus).

## Les quatre décodeurs proposés

### m4-04, monde 4 (les cas)

- **Modèle du cours (inchangé)** : *Lupus agnum videt.* Le cours explique
  *-us* pour le sujet, *-m* pour le COD, *-t* pour le verbe.
- **Ajout au cours** : « À toi ! Voici une nouvelle phrase. Attention,
  l'ordre a changé : ne regarde pas la place des mots, regarde leur fin. »
- **Phrase à décoder** : *Puellam lupus videt.* (Le loup voit la jeune fille.)
- **Ordre** : COD, sujet, verbe.
- **Ce que l'élève doit voir** : *puellam* est en premier mais porte le
  *-m* du COD (vu en `m4-03`).

### m5-04, monde 5 (les verbes)

- **Modèle du cours (inchangé)** : *Miles gladium capit.* (Le soldat prend
  son glaive.)
- **Phrase à décoder** : *Agricola amat equum.* (Le paysan aime le cheval.)
- **Ordre** : sujet, verbe, COD.
- **Ce que l'élève doit voir** : *agricola* finit en *-a* et c'est bien un
  sujet (pas de *-m*) ; le verbe est au milieu, reconnu à son *-t*.

### m8-04, monde 8 (le génitif) : avec un complément du nom

- **Modèle du cours (nouveau)** : *Servus aquam domini portat.* (L'esclave
  porte l'eau du maître.) Le cours analyse les quatre mots, avec le nouveau
  rôle 🟢 **Complément du nom (Génitif)** : *domini*, terminaison *-i*.
- **Phrase à décoder** : *Mercator vinum domini vendit.* (Le marchand vend
  le vin du maître.)
- **Ordre** : sujet, COD, génitif, verbe.
- **Ce que l'élève doit voir** : *vinum* est le COD (*-um*), *domini* le
  complément du nom (*-i*, vu en `m8-03`).

### m9-04, monde 9 (le pluriel)

- **Modèle du cours (nouveau)** : *Legionarii galeas portant.* (Les
  légionnaires portent les casques.) Le cours rappelle *-i* sujet pluriel,
  *-as* COD pluriel et *-nt* verbe pluriel.
- **Phrase à décoder** : *Equos servi vident.* (Les esclaves voient les
  chevaux.)
- **Ordre** : COD, sujet, verbe.
- **Ce que l'élève doit voir** : *equos* est un COD pluriel (*-os*, vu en
  `m9-03`), *servi* le sujet pluriel (*-i*), *vident* le verbe pluriel
  (*-nt*).

## Ce qu'il faut changer dans le code

1. `m8-04` et `m9-04` : un champ `mots` avec les mots latins, comme `m4-04`
   et `m5-04`.
2. Le décodeur propose le bouton 🟢 « Complément du nom (Génitif) »
   **seulement** quand la phrase en contient un (`m8-04`). Les mondes 4 et 5
   ne le voient donc pas.
3. Le bouton du verbe passe de 🟢 à 🟡.
4. Après la réussite, l'appli affiche la traduction de la phrase décodée
   (nouveau champ `traduction`), pour que l'élève vérifie le sens.
5. Un test vérifie que chaque décodeur a des `mots` et que l'ordre des
   rôles n'est pas sujet, COD, verbe partout.

## Décision de Cédric

Version simple retenue pour `m9-04` : *Equos servi vident*, plutôt que le
piège *Equos agricolae vident* (sujet qui ressemble à un génitif).
