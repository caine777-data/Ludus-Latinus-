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

## Les 5 images proposées

1. **Gaius, le tavernier** : il devient la tuile de la Taverne et apparaît
   face au joueur pendant la partie. Il libère Mercure pour Paires éclair.
2. **Le décor de la taverne**, très pâle, derrière les dés.
3. **Lupulus qui console** : une seule image pour toutes les défaites
   (Circus, Colisée, Taverne, Paires éclair, Mot du jour), à la place du 🏁
   et du ☠️. Un message d'encouragement plutôt qu'une tête de mort.
4. **Le fond du Mot du jour** : une bibliothèque romaine très pâle.
5. **Le sceau de César** pour la victoire d'une mission, à la place du 🦅.

Plus tard, si le jeu en vaut la peine : les 8 clients du Marché en portraits
(soldat, sénateur, vestale, paysan…), aujourd'hui des emojis.

Pas de vidéo : ces jeux se rejouent souvent, une cinématique ralentirait
chaque partie.

## Consignes de génération

- Pour l'image 3, joindre `assets/images/lupulus/lupulus_mercure.png` comme
  référence, pour que Lupulus garde son allure.
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

### 3. Lupulus qui console

Fichier : `assets/images/lupulus/lupulus_courage.webp`, format carré 1:1.

```
Le louveteau Lupulus de l'image de référence, sans casque ni ailes, en toge blanche simple, assis sur une marche de marbre, sourit avec douceur et tend la patte en avant comme pour dire « ce n'est pas grave, on recommence ». Attitude bienveillante et encourageante, pas triste. Fond crème uni et clair, sans décor. Illustration 3D douce et chaleureuse, façon film d'animation, couleurs dorées et pourpres. Format carré 1:1, personnage entier et centré. Aucun texte, aucune lettre, aucun chiffre dans l'image.
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
