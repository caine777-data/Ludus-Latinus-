# Intégration des options de QCM et des explications par mauvaise réponse

Date : 08/10/2026. Sources : `options_qcm.md` (avec la « Relecture de l'architecte »), `explications_quiz.md`, `relecture_explications_quiz.md`.

## Chiffres

- Questions réécrites : **43** (leçons `quiz` et questions d'arène). Les 5 corrections de l'architecte sont appliquées (À bientôt devient Bon appétit ; marbre devient En arbres morts ; Saisis le moment présent devient Pense toujours à demain ; La Pax Augusta devient La Concordia ; Quintilien et Hortensius deviennent Pompée et Brutus). Questions et champs `explanation` inchangés.
- Vérification par script : `answer` désigne bien la bonne option cochée ; la bonne réponse garde le même sens (relue paire par paire, ancienne contre nouvelle) ; aucune option n'est identique à une autre de la même question.
- Explications ajoutées : **84** phrases pour les mauvaises options, dans un champ `explications` sur les **28** leçons `quiz` (112 options, 28 chaînes vides sur la bonne réponse). 70 viennent du brouillon (dont **22** remplacées par leur version corrigée de la relecture), **14** ont été écrites par moi (tableau ci-dessous). Trois corrections de la relecture ne servent plus, leur option ayant disparu au point 1 : m11-01 (Porsenna, muraille) et m15-01 (-IS-).
- Vérifié par script : longueur de `explications` égale à celle de `options` ; chaîne vide exactement à l'index `answer` ; aucune phrase de plus de 20 mots, aucun tiret long, aucune phrase ne contient le texte de la bonne option.
- Appariement phrase/option fait par script sur le texte de l'option (sans les « (ex: …) », sans distinguer majuscules et minuscules).

## Phrases écrites par moi (point 2c), à relire

| Leçon | Nouvelle option | Phrase | Mots |
|---|---|---|---|
| m4-01 | Sa place dans la phrase | En latin, on peut déplacer les mots sans changer leur rôle : la place ne décide pas de la fonction. | 20 |
| m4-01 | Sa première lettre | La première lettre d'un mot ne change pas quand sa fonction change : elle ne montre pas son rôle. | 19 |
| m11-01 | Il a pénétré seul dans le camp ennemi pour frapper le roi | C'est l'audace de Mucius Scaevola, qui s'est glissé dans le camp de Porsenna pour tuer le roi. | 17 |
| m11-01 | Il a traversé le fleuve à la nage sous les tirs de flèches | Cette traversée à la nage sous les flèches est surtout l'exploit de Cloélie, l'otage qui s'est échappée du camp. | 19 |
| m11-01 | Il a gardé les portes de la ville pendant la fuite du peuple | Les récits ne parlent d'aucune porte de la ville : ce n'est pas le lieu de l'exploit d'Horatius. | 18 |
| m15-01 | -era- | -era- apparaît au plus-que-parfait (amaveram), un temps du passé différent de l'imparfait. | 12 |
| m15-01 | -re- | -re- termine l'infinitif présent de nombreux verbes, comme amare : ce n'est pas un signe d'imparfait. | 16 |
| m16-01 | -ut | -ut ressemble au petit mot ut (comme, pour que), mais ce n'est pas une désinence verbale du parfait. | 18 |
| m19-01 | -ei | -ei est le génitif de la 5e déclinaison, comme res, rei : ce n'est pas celui de manus. | 18 |
| m23-01 | -mur | -mur est la désinence de la 1re personne du pluriel au passif, comme amamur (nous sommes aimés). | 17 |
| m25-01 | Horace | Horace, poète du temps d'Auguste, a écrit des Odes et des Satires, pas l'Énéide. | 14 |
| m25-01 | Lucrèce | Lucrèce est mort avant le règne d'Auguste et il a écrit De la nature, pas l'Énéide. | 16 |
| m26-01 | L'Accusatif de relation | Le nom est à l'accusatif dans cette construction, alors que la question parle de deux mots à l'ablatif. | 18 |
| m26-01 | Le Datif de possession | Le datif de possession dit à qui appartient une chose, avec le verbe être : il n'utilise pas deux ablatifs. | 20 |

Points à regarder en priorité :
- **m11-01, « Il a traversé le fleuve à la nage sous les tirs de flèches »** : option risquée. Selon Tite-Live, Horatius lui-même s'est jeté dans le Tibre et l'a traversé à la nage sous les traits après la chute du pont. Ma phrase l'attribue « surtout » à Cloélie ; un élève qui connaît l'histoire peut juger l'option juste. Je recommande de la changer.
- **m26-01, « Le Datif de possession »** et **« L'Accusatif de relation »** : phrases un peu techniques pour de la 3e, à lire avec soin.
- **m23-01, « -mur »** : la phrase donne le sens (« nous sommes aimés »), pas la bonne désinence.

## Mots du Thesaurus qui ont changé de monde

L'export rattache un mot au premier monde dont une leçon l'emploie, en cherchant dans tout le JSON de la leçon, donc aussi dans `explications`. Comparaison de la clé `monde` des 224 entrées, avant et après : **2 changements**, tous deux causés par des phrases du brouillon (pas par les options réécrites).

| Mot | Avant | Après | Cause |
|---|---|---|---|
| templum, -i | monde26 | monde20 | phrase de m20-01 pour « quod » (« templum quod stat ») |
| monere (moneo, monui, monitum) | (aucun) | monde16 | phrase de m16-01 pour « -et » (« comme monere ») |

Aucun des deux n'est enseigné à cet endroit : `templum` sera proposé aux exercices de vocabulaire du monde 20 avant le monde 26 où on l'apprend. Correction possible, sans toucher au texte validé : donner un `monde` explicite à ces deux entrées dans `app/thesaurus.py` (hors de mon périmètre), ou reformuler les deux phrases. Les 222 autres sont inchangés. Référence « avant » : export régénéré depuis le contenu non modifié.

## Vérifications

- `python scripts/exporter_dataset_mobile.py` : exécuté, les deux JSON (`assets/data/` et `ludus_latinus_mobile/assets/data/`) sont identiques octet pour octet, 262,7 Ko, `explications` présent sur les 28 quiz.
- `python -m unittest discover -s tests` : `Ran 250 tests in 12.452s` puis `OK`.
- `python -m ruff check .` : `All checks passed!`
- Remarque : AGENTS.md annonce 248 tests, il y en a 250.
- Aucun fichier touché hors de `content/monde*.py`, des deux JSON et de ce rapport. Pas de commit, pas de flutter. Le champ `explications` est nouveau dans le JSON : l'autre agent (`lib/`) doit le lire.
