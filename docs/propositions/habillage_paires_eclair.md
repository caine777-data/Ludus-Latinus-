# Habillage de Paires éclair

Proposition de l'architecte (24/10/2026). Rien n'est appliqué avant la
validation de Cédric.

## Le thème : les messages de Mercure

Mercure est le messager des dieux, le plus rapide de l'Olympe. Lupulus
existe déjà en costume de Mercure (`lupulus_mercure.png`, ailes, casque
ailé, caducée) : il devient l'hôte du jeu. L'élève l'aide à porter les
messages : chaque paire reliée est un message livré, chaque manche une
tournée.

## Ce qui change à l'écran

| Moment | Aujourd'hui | Proposé | Image |
|---|---|---|---|
| Tuile du Ludi | Lupulus joyeux (provisoire) | Lupulus Mercure | existe déjà |
| Écran de règle | icône éclair sur fond uni | bannière : Lupulus Mercure en vol au-dessus de Rome, des tablettes sous le bras | **à générer (1)** |
| Pendant le jeu | fond crème uni | fond très clair : ciel doré et colonnes floues, assez pâle pour que les cartes restent lisibles | **à générer (2)** |
| Cartes latines | blanches, bord beige | aspect tablette de cire : cadre bois, cire miel | dessinées en code |
| Cartes françaises | blanches | aspect papyrus clair | dessinées en code |
| Bonne paire | les deux cartes passent au vert | même chose, plus une petite gerbe d'étincelles dorées | effet existant |
| Changement de manche | rien | éclair blanc bref et « Manche 2 sur 3 » au centre | dessiné en code |
| Trois paires justes d'affilée | rien | « Celeriter ! » (vite !) en doré, une seconde | dessiné en code |
| Dix dernières secondes | barre rouge | barre rouge qui pulse | dessiné en code |
| Victoire | trophée | Lupulus triomphant (`lupulus_triomphe`) | existe déjà |
| Défaite | sablier | Lupulus pensif (`lupulus_reflexion`) | existe déjà |
| Fin de partie | rien | rappel des 15 paires jouées, celles ratées en premier, pour réviser | dessiné en code |

Pas de vidéo : la partie dure une minute et se rejoue souvent ; une
cinématique ralentirait chaque relance.

## Images à générer

- Joindre `assets/images/lupulus/lupulus_mercure.png` comme image de
  référence, pour que Lupulus garde exactement son allure.
- Aucun texte, lettre ou chiffre dans les images.
- Télécharger dans l'ordre, sans renommer : l'architecte les convertit en
  WebP.

### 1. Bannière de l'écran de règle

Fichier : `assets/images/paires/banniere_mercure.webp`, format 16:9.

```
Le louveteau Lupulus de l'image de référence, en costume de Mercure (casque ailé doré, petites ailes dans le dos, sandales ailées, tunique bleu ciel, caducée), vole joyeusement au-dessus des toits de la Rome antique, des tablettes de cire et des rouleaux de papyrus sous le bras, laissant derrière lui une traînée d'étincelles dorées comme un petit éclair. En contrebas, le Forum et ses temples dans une lumière de fin d'après-midi. Illustration 3D douce et chaleureuse, façon film d'animation, couleurs dorées, bleu ciel et pourpres. Format paysage 16:9, personnage centré, décor légèrement flou. Aucun texte, aucune lettre, aucun chiffre dans l'image.
```

### 2. Fond de l'écran de jeu

Fichier : `assets/images/paires/fond_olympe.webp`, format 9:16.

```
Décor vertical très clair et très doux : un ciel doré pâle avec des nuages crème, et sur les côtés des colonnes de marbre blanc d'un temple antique, à peine esquissées et très floues. Le centre de l'image est presque vide et uniforme, de couleur crème claire, pour qu'on puisse poser du texte par-dessus. Aucun personnage. Contraste très faible, tons pastel crème, or pâle et bleu ciel. Illustration douce, façon film d'animation. Format portrait 9:16. Aucun texte, aucune lettre, aucun chiffre dans l'image.
```

## Textes à valider

- « Celeriter ! » après trois paires justes d'affilée.
- Le reste des textes du jeu est déjà en place (règle, manches, victoire,
  défaite) et visible à l'écran.
