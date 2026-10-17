# Bruitages à régénérer sous ElevenLabs

Audit du 17/10/2026 sur les 17 bruitages de `ludus_latinus_mobile/assets/audio/`.

## Mesures

« Aigus » = part de l'énergie au-dessus de 4 kHz. Au-delà de 60 %, le son est perçu comme strident ou synthétique. Un bruitage chaleureux reste sous 30 %.

| Fichier | Moment du jeu | Durée | Aigus > 4 kHz | Verdict |
|---|---|---|---|---|
| `lecon_validee.wav` | leçon réussie pour la première fois | 1,0 s | 99 % | 🔴 strident |
| `indice.wav` | indice demandé | 1,0 s | 99 % | 🔴 strident |
| `achat.wav` | achat à la Taberna | 2,0 s | 97 % | 🔴 strident |
| `carte_obtenue.wav` | carte de collection obtenue | 0,8 s | 70 % | 🔴 strident |
| `dice_roll.wav` | osselets de la Taverne | 0,6 s | 70 % | 🟠 sec, métallique |
| `sesterces_clink.wav` | gain de sesterces | 0,45 s | 50 % | 🟠 à réécouter |
| `sword_clash.wav` | coup au Duel | 0,7 s | 38 % | 🟠 à réécouter |
| `card_flip.wav` | retournement de carte | 0,2 s | 32 % | 🟢 correct |
| `etoile.wav` | étoile obtenue | 1,1 s | 25 % | 🟢 correct |
| `bonne_reponse.wav` | bonne réponse | 1,2 s | 12 % | 🟢 correct |
| `page.wav` | page tournée | 0,7 s | 8 % | 🟢 correct |
| `monde_termine.wav` | monde terminé | 2,2 s | 7 % | 🟢 correct |
| `bouton.wav` | bouton | 0,5 s | 4 % | 🟢 correct |
| `wheel_click.wav` | cran de la roue de César | 0,1 s | 3 % | 🟢 correct |
| `crowd_cheer.wav` | foule du Colisée | 2,6 s | 1 % | 🟢 correct |
| `erreur.wav` | mauvaise réponse | 0,6 s | 0 % | 🟢 correct |
| `triumph_fanfare.wav` | victoire | 1,35 s | 0 % | 🟢 correct, mais fort |

Les mesures ne disent pas tout : un son peut être « pas terrible » sans être aigu. Réécoutez les 🟢 et signalez ceux qui vous gênent.

## Réglages ElevenLabs

1. Ouvrez **Sound Effects**.
2. Collez le prompt en anglais : ElevenLabs le comprend mieux qu'en français.
3. Réglez la durée indiquée. Un son court évite la cacophonie quand le joueur enchaîne les réponses.
4. Réglez **Prompt influence** vers 60 % : assez pour suivre le prompt, pas assez pour un son raide.
5. Générez plusieurs variantes, gardez la plus douce.
6. Déposez le fichier dans `gemini ludus` sous le **nom du tableau**, sans le convertir. L'extension (`.mp3` ou `.wav`) n'a pas d'importance : je modifie le chemin dans le code.

## Prompts, par ordre de priorité

### 🔴 lecon_validee (1,5 s)

Warm wooden marimba ascending three-note arpeggio, soft and rounded, gentle reverb, cheerful success chime for a children's educational game, no high-pitched sparkle

### 🔴 indice (0,8 s)

Soft low wooden tap followed by a gentle airy whoosh, like a scroll being unrolled, calm and discreet hint sound, no bell, no high frequencies

### 🔴 achat (1,2 s)

A few bronze coins dropped on a wooden counter, then one small soft brass bell ding, warm ancient market shop, muffled and pleasant, not shrill

### 🔴 carte_obtenue (1,2 s)

Thick parchment card slid out of a leather pouch, followed by a soft warm harp glissando, rewarding collectible found, mellow tone

### 🟠 dice_roll (0,8 s)

Small bone knucklebones shaken in a leather cup and tossed on a wooden table, short roll then stop, dry and natural, ancient Roman tavern

### 🟠 sesterces_clink (0,5 s)

Two or three small bronze coins clinking together softly in a hand, warm metallic tone, short and light, no ringing tail

### 🟠 sword_clash (0,6 s)

Short iron sword hitting a wooden shield reinforced with bronze, solid thud with a brief metallic ring, punchy but not piercing

### 🟢 triumph_fanfare (1,5 s), seulement si vous la trouvez trop forte

Short ancient Roman brass horn fanfare, two bold rising notes, warm and round, triumphant but not blaring

## Livraison du 17/10/2026

Intégrés tels quels (MP3 copiés sans conversion, anciens WAV retirés) :

| Fichier | Aigus > 4 kHz avant | après |
|---|---|---|
| `lecon_validee.mp3` | 99 % | 0 % |
| `carte_obtenue.mp3` | 70 % | 9 % |
| `dice_roll.mp3` | 70 % | 61 %, mais nettement moins de très aigus (55 % > 8 kHz avant, 16 % après) |
| `triumph_fanfare.mp3` | 0 % | 0 %, volume identique |

À refaire :

| Fichier | Mesure | Problème |
|---|---|---|
| `achat.mp3` | 92 % d'aigus | encore strident : la clochette domine |
| `indice.mp3` | 95 % d'aigus, crête à -11 dB | strident et faible, 0,14 s de silence au début |
| `sesterces_clink.mp3` | 99,8 % d'aigus | plus strident que l'ancien (50 %) |
| `sword_clash.mp3` | crête à -26 dB | presque inaudible ; le code ne peut pas monter le volume au-dessus de l'original |

### Prompts, second essai

Ces prompts excluent explicitement les cloches et les brillances, qui produisaient les aigus.

**achat (1,2 s)**

Handful of bronze coins poured onto a thick wooden counter, dull warm clinks, muffled, low and mid frequencies, no bell, no shimmer, no sparkle

**indice (0,8 s)**

Single soft wooden knock followed by a low breathy whoosh, muffled, low frequencies only, starts immediately, no chime, no bell, no sparkle, no hiss

**sesterces_clink (0,5 s)**

Two heavy bronze coins tapping together inside a closed hand, dull muffled clink, low-mid tone, very short, no ringing, no sparkle

**sword_clash (0,6 s)**

Loud close-up impact of an iron sword striking a wooden shield, heavy thud and a short metallic clang, punchy and loud, starts immediately

## Après dépôt

Je remplace les fichiers un par un, sans les recompresser, et j'ajuste le volume dans le code si un son ressort trop par rapport aux autres.
