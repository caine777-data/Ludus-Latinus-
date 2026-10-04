# Audit des jeux (3 octobre 2026), première partie

Par l'architecte, à partir du code des jeux (`lib/ui/features/`). Les
mesures de jeu réel (durées, répétitions, temps morts) viendront de la
tâche T41 de Gemini et compléteront ce rapport : les points marqués
**[à mesurer]** en dépendent.

La question posée : les jeux sont-ils plaisants, et que peut-on améliorer ?
Un jeu éducatif plaît quand il donne un choix qui compte, une difficulté qui
monte, une raison de revenir. Il apprend quand réussir demande d'utiliser le
latin, pas de deviner.

## Vue d'ensemble

| Jeu | Ce qu'on fait | Choix qui compte ? | Fait-il pratiquer le latin ? | Rejouable ? |
|---|---|---|---|---|
| Duel | QCM contre 5 boss | à moitié (postures) | oui, depuis le 2/10 lié à la progression | oui, 3 parties payées par jour |
| Circus | QCM pendant une course | oui (factions, mesuré en T25) | en partie (46 questions sur le cirque) | oui, 3 par jour |
| César | déchiffrer 6 messages | non | peu (traduction finale) | **non : 6 missions, puis plus rien** |
| Marché | chiffres romains, rendu, négociation | non | chiffres romains | **non : 25 situations, payées une fois** |
| Taverne | lancer 4 dés | **non : pur hasard** | **non** | 3 lancers payés par jour |
| Memoria | révision espacée du vocabulaire | non | **oui, c'est le meilleur** | oui, sans fin |
| Panthéon | album de 9 cartes | **non : tout est visible d'office** | non | non |

## Les défauts, du plus grave au moins grave

### 1. La Taverne rapporte plus que les leçons, sans rien apprendre

Quatre dés à six faces : « quatre faces différentes » (Coup de Vénus,
+50 HS) sort une fois sur quatre (27,8 %), un brelan une fois sur dix
(+30 HS), une paire le reste du temps (+15 HS). Un lancer rapporte donc
26 HS en moyenne, soit environ 78 HS par jour pour trois touches d'écran.
Une leçon réussie avec trois étoiles rapporte 10 HS, une mission de César 10,
un duel gagné 15. Un élève qui a compris le calcul joue à la Taverne et
saute les leçons. Le Coup de Vénus promet aussi une « Protection de Série »
qui n'existe nulle part dans le code.

### 2. Trois jeux sur six n'ont plus rien à offrir après quelques séances

César a 6 missions, le Marché 12 articles, 9 clients et 4 négociations, tous
payés une seule fois. Une fois finis, l'élève n'a plus de raison d'y
revenir. Le Panthéon n'a pas d'enjeu du tout : ses 9 cartes se retournent
d'un toucher, sans rien gagner ni débloquer.

### 3. L'économie s'épuise vite

Tout ce qu'on peut acheter coûte environ 3 100 HS (24 objets de boutique
pour 1 695 HS, 6 monuments du Forum pour 1 400 HS). Avec la Taverne, le Duel
et le Circus, un élève gagne de l'ordre de 170 HS par jour sans ouvrir une
leçon : en trois semaines, il n'y a plus rien à désirer. Les sesterces
cessent alors de motiver quoi que ce soit.

### 4. Le Duel se gagne en deux réponses, et une posture domine

Les boss ont 100 PV ; l'attaque lourde inflige 51 dégâts : deux bonnes
réponses suffisent. Elle double aussi la riposte, mais une erreur sur
quatre choix est rare : l'attaque lourde est presque toujours le meilleur
choix, et les deux autres postures ne servent pas. La description de la
parade (« dégâts normaux ») est fausse : le code les réduit de 10 %.
Un combat dure quelques secondes de jeu **[à mesurer]**, l'entrée vidéo du
boss comprise.

### 5. Le Circus parle surtout du cirque

Son paquet compte 70 questions, dont 46 sur le vocabulaire du cirque
(*metae*, *spina*, factions). C'est de la culture amusante, mais un élève de
5e y apprend des mots qui ne reviennent dans aucune leçon. Depuis le 2/10,
24 questions viennent des mondes atteints : c'est mieux, la proportion reste
à l'avantage du cirque.

### 6. Aucun jeu ne monte en difficulté

Le Duel a 5 boss, mais le 5e pose les mêmes questions que le 1er. Le Circus
a la même vitesse à chaque course. Rien ne récompense la maîtrise : ni
record, ni série, ni boss plus dur quand on gagne souvent.

## Ce qui fonctionne

- **Memoria** est le jeu le plus utile : révision espacée, cartes limitées aux
  mondes atteints, gain seulement sur une carte à réviser. C'est le modèle à
  suivre.
- **Le Circus** donne un vrai choix : la faction change la course (T25), et
  depuis T33 on ne gagne plus sans répondre.
- **Les visuels et le son** (vidéos des boss, impacts, pluie de pièces) donnent
  du relief, et le plafond de trois parties payées par jour est compris.

## Propositions, dans l'ordre

> Suivi (04/10/2026) : les propositions 1, 2 et 6 sont faites, validées par
> Cédric. Restent la 3 (Panthéon, après T42), la 4 (Duel) et la 5 (Circus).

1. **Taverne** : faire dépendre le gain d'une compétence. Chaque lancer
   affiche les dés en chiffres romains et demande leur total (en chiffres
   romains) : juste, le gain est versé ; faux, rien. Et rééquilibrer les
   gains : le Coup de Vénus, le plus fréquent après la paire, ne peut pas
   valoir 50. Retirer la « Protection de Série » ou la créer.
2. **César et Marché** : fabriquer les missions au lieu de les écrire.
   César peut chiffrer n'importe quelle phrase latine déjà vue dans les
   leçons, avec une clé tirée au hasard ; le Marché peut tirer prix et
   sommes données au hasard. Les jeux deviennent inépuisables, payés selon
   le même plafond quotidien que le Duel.
3. **Panthéon** : une carte gagnée par monde terminé (état des lieux en T42),
   les autres retournées face cachée. L'album devient l'objectif à long
   terme qui manque.
4. **Duel** : des PV qui montent d'un boss à l'autre (100, 130, 160, 200,
   250), et des questions tirées des mondes les plus récents pour les
   derniers boss. Rendre la parade utile (moins de riposte, assez pour
   compter) et corriger sa description.
5. **Circus** : inverser la proportion (deux tiers de questions des mondes
   atteints, un tiers sur le cirque).
6. **Un record par jeu** (meilleur score au Circus, plus longue série au
   Duel et à Memoria), affiché sur la tuile du jeu. Peu de code, une vraie
   raison de rejouer.

Les points 1 et 4 touchent l'équilibre de jeu : à tester sur l'émulateur
avant de les garder, comme pour T33.
