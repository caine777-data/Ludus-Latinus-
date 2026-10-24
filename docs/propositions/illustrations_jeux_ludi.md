# Illustrations pour habiller les jeux du Ludi

Proposition de l'architecte (24/10/2026), d'après l'inventaire des visuels de
chaque jeu. Rien n'est appliqué avant la validation de Cédric.

## Ce que montre l'inventaire

| Jeu | Visuels actuels | Manque |
|---|---|---|
| Circus | chars, piste, Lupulus en victoire | défaite : un simple emoji 🏁 |
| Colisée (duel) | 5 boss animés, décor du Colisée, cinématiques | défaite : emoji ☠️ |
| Taverne | **aucune image** ; la tuile montre Mercure, qui est maintenant l'hôte de Paires éclair | Gaius, le tavernier, et le décor |
| Atelier de César | Lupulus empereur | victoire de mission : emoji 🦅 |
| Marché de Trajan | Lupulus savant ; clients et articles en emojis | les clients (voir « Plus tard ») |
| Panthéon, Bataille | cartes illustrées | rien |
| Mot du jour | Lupulus philosophe, fond uni | un fond |

## Animations déjà dans le projet, à réutiliser

L'inventaire des animations (`assets/images/animated/`) montre trois
boucles prêtes, rien à générer :

- `lupulus_encouragement.webp` (Lupulus en toge qui encourage, fond
  transparent) : il sert aujourd'hui à une seule leçon. Il remplacerait le
  🏁 du Circus, le ☠️ du Colisée et la pose fixe des défaites de Paires
  éclair et du Mot du jour. **L'image 3 ci-dessous devient inutile.**
- `dice_roll_3d.webp` (dés qui roulent) : présent mais jamais affiché. Il
  irait dans la Taverne, le temps du lancer.
- `pieces_or.webp` (pluie de pièces) : déjà utilisé pour les gains ; on
  l'ajouterait aux victoires payées de Paires éclair et du Mot du jour.

## Animations à créer (2, en boucle courte)

Même méthode que les boss du Colisée : une vidéo de quelques secondes,
convertie par l'architecte en animation WebP en boucle, sans son, qui joue
sur place sans retarder la partie.

1. **Gaius en boucle** : il secoue son gobelet de dés et rit. Il vit à
   l'écran pendant la partie de Taverne, comme les boss au Colisée.
   Générer d'abord l'image 1 (Gaius), puis l'animer en partant d'elle.
2. **Lupulus Mercure en vol**, en boucle, pour la bannière de Paires
   éclair (facultatif : la bannière fixe fonctionne déjà).

Toujours pas de cinématique (vidéo plein écran) : ces jeux se rejouent
souvent. Les cinématiques restent pour les moments uniques (entrée d'un
niveau, boss, arrivée du Circus).

## Les images proposées

1. **Gaius, le tavernier** : il devient la tuile de la Taverne et apparaît
   face au joueur pendant la partie. Il libère Mercure pour Paires éclair.
2. **Le décor de la taverne**, très pâle, derrière les dés.
3. ~~Lupulus qui console~~ : remplacé par l'animation existante
   `lupulus_encouragement.webp`, rien à générer.
4. **Le fond du Mot du jour** : une bibliothèque romaine très pâle.
5. **Le sceau de César** pour la victoire d'une mission, à la place du 🦅.

Plus tard, si le jeu en vaut la peine : les 8 clients du Marché en portraits
(soldat, sénateur, vestale, paysan…), aujourd'hui des emojis.

Pas de vidéo : ces jeux se rejouent souvent, une cinématique ralentirait
chaque partie.

## Consignes de génération

- Les 4 images se génèrent sans image de référence (l'ancienne image 3,
  la seule qui en demandait une, est abandonnée).
- Les 2 animations partent d'une image : Gaius (image 1, à générer d'abord)
  et la bannière de Paires éclair, déjà dans « gemini ludus »
  (`banniere_mercure.webp`).
- Aucun texte, lettre ou chiffre dans les images.
- Déposer dans « gemini ludus » sans renommer : l'architecte les convertit en
  WebP et les détoure si besoin.

### 1. Gaius, le tavernier

Fichier : `assets/images/taverne/gaius.webp`, format carré 1:1.

```
Portrait en buste d'un tavernier romain jovial d'une cinquantaine d'années, rond et moustachu, crâne dégarni, joues rouges, tunique brune et tablier de cuir, un gobelet de dés en terre cuite dans une main, un sourire malicieux de joueur qui se croit invincible. Derrière lui, flou, le comptoir d'une taverne romaine avec des amphores. Illustration 3D douce et chaleureuse, façon film d'animation, couleurs chaudes ocre et brun, lumière de lampe à huile. Format carré 1:1, personnage centré, cadré des épaules à la tête. Aucun texte, aucune lettre, aucun chiffre dans l'image.
```

### 2. Décor de la taverne

Fichier : `assets/images/taverne/fond_taverne.webp`, format 9:16.

```
Décor vertical très clair et très doux de l'intérieur d'une taverne romaine : murs crème, amphores et lampes à huile sur les côtés, une table en bois en bas de l'image, le tout à peine esquissé et très flou. Le centre de l'image est presque vide et uniforme, de couleur crème chaude, pour qu'on puisse poser du texte par-dessus. Aucun personnage. Contraste très faible, tons pastel crème, ocre pâle et brun clair. Illustration douce, façon film d'animation. Format portrait 9:16. Aucun texte, aucune lettre, aucun chiffre dans l'image.
```

### 4. Fond du Mot du jour

Fichier : `assets/images/mot_du_jour/fond_bibliotheque.webp`, format 9:16.

```
Décor vertical très clair et très doux d'une bibliothèque romaine : niches de bois remplies de rouleaux de papyrus sur les côtés, une colonne, des tablettes de cire, le tout à peine esquissé et très flou. Le centre de l'image est presque vide et uniforme, de couleur crème claire, pour qu'on puisse poser une grille de lettres par-dessus. Aucun personnage. Contraste très faible, tons pastel crème, bois clair et or pâle. Illustration douce, façon film d'animation. Format portrait 9:16. Aucun texte, aucune lettre, aucun chiffre dans l'image.
```

### 5. Le sceau de César

Fichier : `assets/images/cesar/sceau_victoire.webp`, format carré 1:1.

```
Un sceau de cire rouge sombre posé sur un parchemin enroulé, frappé d'un aigle romain aux ailes déployées, entouré d'une couronne de laurier dorée, avec un ruban pourpre. Lumière chaude qui fait briller la cire. Fond crème uni et clair. Illustration 3D douce et chaleureuse, façon film d'animation, couleurs pourpres, rouges et dorées. Format carré 1:1, objet centré. Aucun texte, aucune lettre, aucun chiffre dans l'image, pas même sur le sceau.
```

## Prompts des animations

À générer en vidéo (Gemini / Veo), **en partant de l'image fixe** comme
première image, 4 à 6 secondes, plan fixe, caméra immobile, sans son :
l'architecte découpe une boucle et la convertit en WebP animé.

### A. Gaius en boucle

Fichier : `assets/images/taverne/gaius_anime.webp`. Image de départ :
`gaius.webp` (image 1).

```
Le tavernier romain de l'image secoue joyeusement son gobelet de dés en terre cuite à hauteur de poitrine, puis éclate d'un petit rire en plissant les yeux, et revient à sa pose de départ. Mouvements amples mais lents, faciles à boucler. Caméra totalement fixe, cadrage identique du début à la fin, décor immobile. Pas de texte, pas de son.
```

### B. Lupulus Mercure en vol (facultatif)

Fichier : `assets/images/paires/banniere_mercure_anime.webp`. Image de
départ : `banniere_mercure.webp`.

```
Le louveteau ailé de l'image vole sur place au-dessus de Rome : ses ailes battent doucement, il ondule légèrement de haut en bas, la traînée d'étincelles dorées scintille derrière lui. La ville en contrebas reste immobile. Caméra totalement fixe, cadrage identique du début à la fin, pour une boucle parfaite. Pas de texte, pas de son.
```
