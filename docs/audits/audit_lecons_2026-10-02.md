# Audit des leçons (2 octobre 2026)

Par l'architecte, à partir du contenu source (`content/monde*.py`).
Lu en entier : la 5e et la 4e (mondes 1 à 18), tous les trous et puzzles de
3e, tous les quiz de 3e. Les arènes de 3e n'ont été relues que par les
mesures automatiques ci-dessous.

## Ce qui fonctionne

- Les cours sont courts (100 mots en moyenne) et racontent quelque chose :
  Midas, Icare, Coclès, Cloélie, Alésia. Un élève a envie de lire la suite.
- Le lien avec le français est partout (aqua, aquarium ; pater, paternel).
- Depuis la réécriture, le schéma « Exemple traduit, puis À toi » est le même
  de la 5e à la 3e, et aucun exercice ne redonne sa réponse.
- Les pièges des puzzles sont grammaticaux (singulier ou pluriel, présent ou
  passé) : il faut lire la terminaison latine pour réussir.

## Les défauts, du plus grave au moins grave

### 1. La 5e annonce des acquis qu'elle n'enseigne pas

`m12-01` dit : « Tu connais déjà la 1re déclinaison (rosa) et la 2e
(dominus) ». `m14-01` dit : « En 5e, tu as appris les adjectifs de 1re
classe (bonus, bona, bonum) ». Or la 5e ne montre que le nominatif et
l'accusatif singulier, sur trois exemples (`m4-02`, `m4-03`). Ni génitif, ni
datif, ni ablatif, ni pluriel des noms, ni adjectif. L'élève arrive en 4e
devant le tableau complet de la 3e déclinaison sans avoir jamais vu un
tableau.

### 2. La grammaire s'arrête au monde 5

Mondes 6 à 10 : presque uniquement de la culture. Les trois trous de
`m8-03`, `m9-03` et `m10-03` demandent de choisir un mot français de culture
parmi quatre (« Caldarium » contre « Aqueduc » et « Amphithéâtre ») : aucun
latin à manipuler. Pendant la moitié de l'année de 5e, l'élève ne pratique
plus ce qu'il a appris aux mondes 4 et 5.

### 3. Une règle, un seul exercice

Chaque leçon a un cours, un exercice de grammaire, puis des questions de
vocabulaire. Une règle est donc appliquée une fois, sur une phrase, puis
plus jamais sauf hasard d'une arène. La 4e et la 3e enchaînent une notion
lourde par leçon (3e déclinaison, neutres, comparatif, imparfait, parfait,
futur, relatif, participe, ablatif absolu, passif, infinitive, subjonctif)
sans leçon de reprise.

### 4. Le Décodeur se résout sans lire

Les cinq décodeurs ont la même phrase type, dans le même ordre : mot 1
sujet, mot 2 COD, mot 3 verbe. Il suffit de retenir l'ordre. C'est le
contraire de ce qu'enseigne `m4-01` (« l'ordre des mots est libre »).

### 5. Les QCM trahissent leur réponse par la forme

Sur 110 questions de quiz et d'arène :
- dans 42, la bonne réponse est nettement la plus longue (11 sur 45 en 5e,
  14 sur 32 en 4e, 17 sur 33 en 3e) ;
- dans 26, elle est la seule à porter une précision entre parenthèses, par
  exemple « -TUR (ex: amatur, laudatur) » contre « -T », « -NTUR », « -RIS ».
Un élève malin répond sans connaître la règle, surtout en 3e.

### 6. Des mauvaises réponses qui ne trompent personne

« Mange des carpes tous les jours » (Carpe diem), « Astérix », « Des
ardoises magiques », « Elle était muette ». Elles amusent, mais elles
réduisent la question à deux choix. Les puzzles de découverte `m1-02` et
`m1-05` ont le même défaut (« Le lion chasse au bois »).

### 7. Des arènes qui interrogent sur ce qui n'a pas été vu

`m7-04` demande « Carpe diem », « Alea jacta est » et « Mens sana in corpore
sano » : aucune des trois n'est dans les leçons du monde 7. `m9-05` demande
l'aigle des légions, absent du monde 9.

## Corrigé le jour même

- `m2-05` : la réponse proposée « Maison close » est remplacée par « Chien à
  vendre ».
- Décodeurs : le cours annonçait des couleurs différentes d'une leçon à
  l'autre (sujet bleu au monde 4, vert aux mondes 8 à 10) et jamais celles
  de l'écran. Tous annoncent maintenant les vraies : sujet bleu, COD rouge,
  verbe doré.

## Ce que je propose, dans l'ordre

> Suivi : le point 1 est fait (validé par Cédric le 02/10/2026) dans `m8-03`,
> `m9-03` et `m10-03`. Le défaut 2 est donc réduit, pas supprimé.

1. **Enseigner les deux premières déclinaisons en 5e** (défaut 1). Trois
   leçons nouvelles ou réécrites dans les mondes 6 à 10, à la place des
   trois trous de culture (défaut 2) : le génitif (« la maison du père »),
   le pluriel (rosae, rosas, domini, dominos), l'adjectif bonus, bona,
   bonum. Contenu à valider par Cédric.
2. **Varier les décodeurs** (défaut 4) : changer l'ordre des mots dans trois
   d'entre eux (« Agnum lupus videt »), et ajouter un complément du nom dans
   le dernier.
3. **Égaliser la forme des réponses** (défaut 5) : mettre un exemple à
   chaque option ou à aucune. Travail de réécriture sans nouveau contenu.
4. **Remplacer les mauvaises réponses absurdes** par des confusions
   plausibles (défaut 6), en même temps que les explications par mauvaise
   réponse (tâche T43).
5. **Arènes** (défaut 7) : ne garder que des questions vues dans le monde,
   et y mettre au moins une question de grammaire par arène.
6. **Un deuxième exercice de grammaire par leçon** (défaut 3) : c'est le
   plus gros chantier. À décider après les points 1 à 5.
