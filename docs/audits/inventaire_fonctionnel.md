# Inventaire fonctionnel de Ludus Latinus (appli Flutter)

Constat factuel, sans jugement ni recommandation. Dépôt `latin_learn`, branche `fix/mobile-publiable-lisible`, commit 37354b7 (2026-10-17). Appli : `ludus_latinus_mobile/` (67 fichiers Dart dans `lib/`, environ 32 300 lignes). Statuts : présent, partiel, absent. Les chemins sont relatifs à `ludus_latinus_mobile/` sauf mention contraire. Les comptes du dataset viennent de `assets/data/ludus_latinus_dataset.json` lu en Python.

## A. Contenu

| Point | Statut | Constat | Preuve |
|---|---|---|---|
| Mondes | présent | 26 mondes : 10 en 5e, 8 en 4e, 8 en 3e. | `assets/data/ludus_latinus_dataset.json` (clé `mondes`, 26 ; `classes[].mondes_ids` : 10/8/8) ; `lib/data/services/data_service.dart:25` |
| Leçons par type | présent | 113 leçons : 29 puzzle, 28 quiz, 26 trou, 26 arene, 4 decodeur. Les 5 types ont un widget d'écran. | dataset (`metadata.total_lecons` = 113) ; `lib/ui/features/lesson/lesson_screen.dart:480-488` ; `lib/ui/features/lesson/widgets/word_puzzle_widget.dart`, `cloze_fill_widget.dart`, `case_decoder_widget.dart`, `arena_challenge_widget.dart` |
| Thesaurus | présent | 224 entrées de dictionnaire, 7 déclinaisons, 5 conjugaisons dans le dataset. Seul le dictionnaire (224) est chargé par le code ; les tables de déclinaisons et conjugaisons de l'écran sont écrites en dur dans le Dart. | dataset (`thesaurus`) ; `lib/data/services/data_service.dart:42-48` ; `lib/ui/features/thesaurus/thesaurus_screen.dart:366-372` |
| Glossaire | partiel | 24 termes dans le dataset, mais aucune lecture dans le code (grep `glossaire` dans `lib/` : aucun résultat hors l10n). | dataset (`glossaire`) ; commande `grep -rniE "glossaire" lib --include=*.dart \| grep -v l10n/` |
| Cartes de collection | partiel | 32 cartes dans le dataset (`cartes_collection`), non lues par `data_service.dart`. Ce que l'appli affiche est le Panthéon : 26 cartes (une par monde) lues dans `assets/data/pantheon.json`. | `lib/data/services/data_service.dart:71` ; `lib/ui/features/pantheon/pantheon_screen.dart:8-10` |
| Succès | partiel | Dataset : 8 succès (correction de l'architecte le 17/10 : l'inventaire initial en annonçait 80 à tort), non lus par le code. L'écran Compte affiche 5 trophées codés en dur (`_buildTrophyItem`). | dataset (`succes`) ; `lib/ui/features/account/account_screen.dart:379,386,393,400` |
| Déblocage des mondes | partiel | Aucun monde n'est verrouillé : la première leçon de chaque monde est toujours ouverte, les suivantes se débloquent une à une dans le monde (leçon précédente validée). Le « précédent monde achevé » ne sert qu'à tracer la route (`entered`). | `lib/ui/features/map/map_screen.dart:375-378` ; `lib/ui/features/map/map_screen.dart:246-249` (paramètre `entered`, utilisé en peinture à `:323`) |
| Déblocage des jeux | présent | Circus et Panthéon ouverts d'emblée ; Duel après 2 leçons, Taverne 6, César 12, Marché de Trajan 18. | `lib/data/models/profile.dart:303-320` |
| Mode d'accès (gratuit/complet) | absent | AGENTS.md décrit une « Édition complète » à 3,99 € (partie gratuite = mondes 1 à 3 plus 1re leçon des autres) ; aucune trace dans le code. | `AGENTS.md:857-866` ; `grep -rniE "Édition complète\|in_app\|3,99" lib --include=*.dart` sans résultat |

## B. Boucle de jeu et rétention

| Point | Statut | Constat | Preuve |
|---|---|---|---|
| XP / niveaux | absent | Pas de points d'expérience. La progression se mesure en leçons, étoiles et sesterces. | `grep -rniE "\bxp\b" lib --include=*.dart` : seul un commentaire dans `lib/ui/core/game_juice.dart:336` |
| Rangs | présent | Cursus Honorum : 7 échelons (Tiro, Civis Romanus, Quaestor, Aedilis, Praetor, Consul, Censor), selon leçons, monuments restaurés et sesterces. | `lib/data/models/cursus_honorum.dart:21-80` ; `lib/data/models/profile.dart:292-296` |
| Série de jours | présent | Série calculée à la date locale (leçon validée ou révision), remise à 0 après un jour manqué, affichée à l'accueil, au Compte, au diplôme, aux fiches. Un trophée dépend d'une série de 3. | `lib/data/models/profile.dart:233-249` ; `lib/data/repositories/game_repository.dart:165,215` ; `lib/ui/features/account/account_screen.dart:393` |
| Quête quotidienne | présent | Un défi par jour parmi 7 jeux (déterministe sur le jour de l'année, limité aux jeux déjà ouverts), 10 sesterces, payé quand l'élève réussit dans le jeu visé. | `lib/data/models/daily_quest.dart:20-81` ; `lib/data/repositories/game_repository.dart:248-264` ; `lib/ui/features/home/home_screen.dart:477-478` |
| Monnaie (sesterces) | présent | Départ à 50. Gain par leçon : 10/7/4 selon 3/2/1 étoile, première réussite seulement, +20 % avec le Temple de Saturne. Gains de jeux : Circus 12, Duel 15, César 10, Marché 5/5/10, Mémoria 2. Plafond de 3 parties payées par jour et par jeu d'arcade, 3 lancers payés par jour à la Taverne. | `lib/data/repositories/game_repository.dart:133,142,155-158,317-322` ; `lib/data/models/profile.dart:236-286` ; `lib/data/services/storage_service.dart:23` |
| Boutique | présent | Taberna Romana : 24 objets en 4 catégories (toges, couronnes, accessoires, compagnons), achetés en sesterces, équipables sur l'avatar. | `lib/data/models/goodie_item.dart:2-7,74` ; `lib/ui/features/boutique/boutique_modal.dart:13-14` |
| Récompenses / monuments | présent | Forum : 6 monuments à restaurer contre des sesterces, avec bonus (ex. Temple de Saturne). Carte du Panthéon gagnée en terminant un monde ; épigraphes à déchiffrer contre sesterces. | `lib/ui/features/forum/forum_screen.dart:240` ; `lib/data/repositories/game_repository.dart:150-190,380-384` |
| Révision espacée (SRS) | présent | Utilisée dans l'interface : écran Memoria Velox, cartes tirées du Thesaurus des mondes vus (clé `th:<mot>`), 5 boîtes de Leitner, intervalles de 1/3/7/14/30 jours, cartes « à réviser » en tête de pile. Les 29 cartes `memoria_srs` du dataset sont chargées mais non utilisées par l'écran. | `lib/data/models/profile.dart:19,50-70` ; `lib/ui/features/memoria/memoria_screen.dart:102-119,203-208` ; `lib/data/repositories/game_repository.dart:60-80` ; `lib/ui/features/home/views/bibliotheca_view.dart:114-129` |
| Notifications / rappels | absent | Aucune dépendance de notification ni permission de rappel. | `grep -niE "notification\|workmanager\|alarm" pubspec.yaml android/app/src/main/AndroidManifest.xml` sans résultat ; `grep -rniE "notification\|workmanager\|rappel\|reminder" lib` : un seul faux positif textuel (`lesson_screen.dart:1066`, commentaire) |
| Objectifs hebdomadaires | absent | Seule la quête quotidienne existe. | `grep -rniE "hebdo\|weekly\|semaine" lib --include=*.dart \| grep -v l10n/` sans résultat |

## C. Mini-jeux

Menu Ludi : six entrées. Mémoria et le Forum sont ouverts depuis la Bibliotheca et le Cursus.

| Jeu | Statut | Écran et principe | Preuve |
|---|---|---|---|
| Circus Maximus | présent | Course de chars : choix d'une faction (bonus de vitesse, de turbo ou de gain), des questions de latin (2/3 des mondes atteints, 1/3 du cirque) arrivent pendant la course, une bonne réponse donne du turbo. | `lib/ui/features/circus/circus_screen.dart:17,42,100,431-442` ; `lib/ui/features/circus/circus_deck.dart:1-12` |
| Colosseum Duellum | présent | Combat contre des boss gladiateurs (Crixus le Rétiaire, etc.), avec vidéos : trois postures (lourde 50 dégâts, vive 35, parade 25) choisies, puis question de vocabulaire. Une mauvaise réponse déclenche la riposte. | `lib/ui/features/duel/duel_screen.dart:15,32-62` ; `lib/ui/features/duel/duel_equilibre.dart:1-14` |
| Taverne des Dés (Ad XXI) | présent | Dés contre Gaius l'aubergiste : on relance et on s'arrête quand on veut, le plus près de XXI gagne ; totaux affichés en chiffres romains. | `lib/ui/features/taverne/taverne_screen.dart:28-31,80` |
| Atelier de César | présent | Trois modes (missions, générateur, décodeur) : chiffre de César, roue de chiffrement, messages codés à déchiffrer pour les légions. | `lib/ui/features/cesar/cesar_screen.dart:11-14,101,1135` |
| Marché de Trajan | présent | Trois modes : achats à l'étal, rendu de monnaie, négociation en latin ; chiffres romains et sesterces. | `lib/ui/features/marche/marche_trajan_screen.dart:340,367-369,844` |
| Panthéon | présent | Album de 26 cartes, une par monde terminé, face cachée sinon. | `lib/ui/features/pantheon/pantheon_screen.dart:8-10` ; `lib/ui/features/home/views/ludi_view.dart:216-218` |
| Memoria Velox | présent | Flashcards 3D à retourner, réponse par choix, révision espacée (voir B). | `lib/ui/features/memoria/memoria_screen.dart:40` |
| Forum Romanum | présent | Restauration de 6 monuments contre des sesterces ; décodage d'épigraphes. | `lib/ui/features/forum/forum_screen.dart:14,240` ; `lib/ui/core/latin_epigraph_modal.dart` |
| Dictionnaire / tables | présent | Thesaurus bilingue et tables de déclinaisons / conjugaisons ; modal de prononciation (restituée ou ecclésiastique) ; export de fiches A4 à imprimer. | `lib/ui/features/thesaurus/thesaurus_screen.dart:93-94` ; `lib/ui/core/latin_pronunciation_modal.dart:9-12` ; `lib/ui/features/home/views/export_fiches_modal.dart:333` |

## D. Personnalisation et social

| Point | Statut | Constat | Preuve |
|---|---|---|---|
| Profil | présent | Prénom du héros et genre (garçon/fille), modifiables dans les réglages ; écran Compte avec statistiques et diplôme. | `lib/ui/features/settings/hero_form.dart` ; `lib/ui/features/settings/settings_screen.dart:36-47` ; `lib/ui/core/roman_diploma_dialog.dart:234` |
| Avatar / héros | présent | Médaillon d'avatar selon genre et toge équipée (20 images d'avatars). Création du héros au premier lancement. | `lib/ui/core/avatar_assets.dart:3-29` ; `lib/ui/features/settings/hero_creation_screen.dart` ; `assets/images/avatars/` (20 fichiers) |
| Plusieurs profils | absent | Un seul profil (`id: 'defaut'`) et un seul fichier de sauvegarde. | `lib/data/services/storage_service.dart:19-21` (profil par défaut) et `:10` (nom du fichier unique) ; `grep -rniE "profils\|switchProfile" lib` sans résultat utile |
| Classement | absent | Aucun classement. | `grep -rniE "classement\|leaderboard" lib --include=*.dart \| grep -v l10n/` sans résultat |
| Défis entre amis | absent | Aucun mécanisme réseau. | `grep -rniE "http\|HttpClient\|Socket\|Uri.parse" lib --include=*.dart \| grep -v l10n/` sans résultat |
| Partage | partiel | Pas de feuille de partage système (aucune dépendance `share_plus`). Seul l'export de fiches copie du HTML dans le presse-papiers pour impression. | `pubspec.yaml:8-22` (dépendances) ; `lib/ui/features/home/views/export_fiches_modal.dart:333` |

## E. Données

| Point | Statut | Constat | Preuve |
|---|---|---|---|
| Sauvegarde de la progression | présent | Un fichier JSON local `ludus_latinus_save.json` dans le dossier Documents de l'appli (`path_provider`), écrit à chaque changement. Ni SharedPreferences, ni Hive, ni base de données. | `lib/data/services/storage_service.dart:10,43-51,68-77` ; `pubspec.yaml:19` |
| Cloud / synchronisation | absent | Le « compte Tabularium Cloud » enregistre un e-mail et une date de synchronisation en local, sans appel réseau. Aucun client HTTP dans `lib/`. | `lib/data/repositories/game_repository.dart:236-241` ; `lib/ui/features/account/account_screen.dart:492,558-575` ; `grep -rnE "http" lib` sans appel réseau ; `pubspec.yaml` sans paquet réseau |
| Export / import | partiel | `exportProfileJson` et `importProfileJson` existent dans le service mais aucun écran ne les appelle. Le « code Tessera » est affiché et copiable ; sa valeur par défaut est fixe (`SPQR-7A2B-9C1D`), aucune fonction d'import par code. | `lib/data/services/storage_service.dart:99-112` ; `grep -rn "exportProfileJson\|importProfileJson" lib \| grep -v storage_service` sans résultat ; `lib/data/models/profile.dart:158,412` |
| Comptes utilisateurs | absent | Pas d'authentification (aucun Firebase ni service de connexion). Le champ e-mail est une simple saisie locale. | `grep -niE "firebase\|auth" pubspec.yaml` sans résultat ; `lib/data/models/profile.dart:117` |

## F. Côté enseignant et parents

| Point | Statut | Constat | Preuve |
|---|---|---|---|
| Tableau de bord enseignant | absent | Aucun écran enseignant. | `grep -rniE "enseignant\|professeur\|tableau de bord" lib --include=*.dart \| grep -v "l10n/\|Tabularium"` : un seul résultat sans rapport (`latin_epigraph.dart:218`, texte culturel) |
| Suivi des progrès | partiel | Pour l'élève seulement : étoiles par leçon, carte de progression, diplôme avec statistiques. | `lib/data/models/profile.dart:116` (`lessonStars`) ; `lib/ui/features/map/map_screen.dart:105-106` ; `lib/ui/core/roman_diploma_dialog.dart:234` |
| Mode classe | absent | Pas de code de classe ni d'espace partagé. | `grep -rniE "classe virtuelle\|code classe\|mode classe" lib` sans résultat |
| Rapport | partiel | Fiches de révision A4 imprimables (déclinaisons, flashcards, palmarès avec la série), copiées en HTML. Pas de rapport de progrès pour un adulte. | `lib/ui/features/home/views/export_fiches_modal.dart:333,670` |
| Contrôle parental | absent | Aucun réglage. | `grep -rniE "parent\|contrôle parental" lib --include=*.dart \| grep -v "l10n/\|parent:"` sans résultat |
| Lien avec les programmes officiels | partiel | Contenu organisé par classe (5e, 4e, 3e, Cycle 4) ; le dataset s'intitule « Cycle 4 ». Aucune référence explicite aux programmes ou aux compétences dans l'appli ; la mention « programme de 5e-3e » figure dans AGENTS.md. | dataset (`metadata.titre`, `classes`) ; `AGENTS.md:917` ; `docs/TACHES.md:3983` |

## G. Accessibilité et confort

| Point | Statut | Constat | Preuve |
|---|---|---|---|
| Taille du texte | partiel | Pas de réglage dans l'appli, aucun forçage de l'échelle système (pas de `textScaler` dans `main.dart`). Deux écrans adaptent des hauteurs à l'échelle du texte. | `lib/ui/features/boutique/boutique_modal.dart:170,513` ; `lib/ui/features/thesaurus/thesaurus_screen.dart:586` ; `grep -n "textScaler" lib/main.dart` sans résultat |
| Mode sombre | partiel | Code présent (`darkTheme`, bascule dans le profil) mais désactivé par `modeSombreDisponible = false` ; l'interrupteur est masqué. | `lib/data/repositories/game_repository.dart:389-391` ; `lib/main.dart:59-60` ; `lib/ui/features/settings/settings_screen.dart:56` |
| Audio activable | présent | Fenêtre de réglage : volume des effets, coupure générale, musique activable avec son volume, vibrations (haptique) activables. 3 musiques et 17 effets. | `lib/ui/core/roman_audio_modal.dart:234,282,300,353` ; `lib/data/services/audio_service.dart:179,216,223` |
| Synthèse vocale | absent | Aucune voix de synthèse ; la prononciation est un moteur de transcription et un rythme de syllabes sans voix. | `grep -niE "flutter_tts\|tts" pubspec.yaml` sans résultat ; `lib/ui/core/latin_pronunciation_modal.dart:9-12` |
| Sous-titres | partiel | Les vidéos (boss, intro) affichent un intitulé en surimpression, pas de sous-titres de dialogue. | `lib/ui/core/cinematic_player.dart:22-56` |
| Daltonisme | absent | Aucun mode ni palette dédiée. | `grep -rniE "daltoni\|colorBlind" lib` sans résultat |
| Lecture d'écran (Semantics) | partiel | Un seul `Semantics(` dans tout `lib/` (formulaire du héros). | `lib/ui/features/settings/hero_form.dart:89` ; `grep -rnE "Semantics\(\|semanticLabel" lib --include=*.dart \| grep -v l10n/` |
| Dyslexie | absent | Pas de police ni d'espacement dédié ; polices Cinzel et PlusJakartaSans seulement. | `pubspec.yaml:55-63` ; `grep -rniE "dyslex\|OpenDyslexic" lib pubspec.yaml` sans résultat |

## H. Langues

| Point | Statut | Constat | Preuve |
|---|---|---|---|
| Langues disponibles | présent | Français seul (un seul fichier `.arb`, 446 clés) ; langue de l'appli forcée à `fr`. | `lib/l10n/app_fr.arb` ; `l10n.yaml:1-2` ; `lib/main.dart:55` |
| Chaînes encore en dur | partiel | Ordre de grandeur : environ 129 lignes `Text('...')` ou `Text("...")` hors l10n (circus 19, cesar 19, marche 15, duel 10, memoria 6, latin_epigraph_modal 6), contre environ 439 usages de `context.l10n.` / `AppLocalizations.of`. Ne compte pas les chaînes multilignes ni les contenus pédagogiques (questions, missions, dialogues) écrits dans le Dart. | `grep -rnE "Text\(\s*['\"]" lib --include=*.dart \| grep -v "lib/l10n/" \| wc -l` = 129 ; `grep -rn "context.l10n\.\|AppLocalizations.of" lib --include=*.dart \| grep -v "lib/l10n/" \| wc -l` = 439 ; `lib/ui/features/circus/circus_screen.dart:106` (banque de questions en dur) |

## I. Monétisation

| Point | Statut | Constat | Preuve |
|---|---|---|---|
| Achats intégrés | absent | Aucune dépendance de facturation ; la décision d'un achat unique est écrite dans AGENTS.md, non implémentée. | `grep -niE "in_app_purchase\|billing\|purchases" pubspec.yaml android/app/build.gradle` sans résultat ; `AGENTS.md:857-866` |
| Publicité | absent | Aucun SDK publicité ; AGENTS.md prévoit « aucune publicité ». | `grep -niE "google_mobile_ads\|admob" pubspec.yaml` sans résultat ; `AGENTS.md:861` |
| Abonnement | absent | Rien de prévu dans le code. | `grep -rniE "abonnement\|subscription" lib --include=*.dart \| grep -v l10n/` sans résultat |
| Version payante | absent | Aucune distinction gratuit/payant dans le code (voir A). | `lib/data/models/profile.dart:303-320` (déblocages par leçons seulement) |

## J. Mesure et qualité

| Point | Statut | Constat | Preuve |
|---|---|---|---|
| Analytics | absent | Aucun SDK de mesure. | `grep -niE "firebase\|analytics\|amplitude" pubspec.yaml` sans résultat |
| Crash reporting | absent | Aucun Crashlytics ni Sentry. | `grep -niE "crashlytics\|sentry" pubspec.yaml` sans résultat |
| Retours utilisateurs | absent | Aucun formulaire ni lien de retour dans l'appli. | `grep -rniE "feedback\|retour utilisateur\|mailto" lib --include=*.dart \| grep -v l10n/` sans résultat |
| Tests Flutter | présent | 28 fichiers dans `test/`, environ 125 cas (`test(` et `testWidgets(`). | `test/*.dart` ; `grep -rhoE "^\s*(test\|testWidgets)\(" test \| wc -l` = 125 |
| Tests du dépôt (Python) | présent | 36 fichiers `tests/test_*.py`, environ 255 méthodes `def test_`. Ils portent surtout sur l'appli bureau Python et le dataset. | `tests/` ; `tests/test_dataset_mobile.py` |
| CI GitHub Actions | présent | Un workflow `appli.yml` : tests Python et ruff, puis Android (analyze, `flutter test`, APK et AAB), puis Windows. Lancé à chaque push hors `main` et hors documentation. | `.github/workflows/appli.yml:22-36,63-64,96-100,126-133,183` |

## K. Publication Play Store

| Point | Statut | Constat | Preuve |
|---|---|---|---|
| applicationId | présent | `com.luduslatinus.app` (namespace identique). | `android/app/build.gradle:31,45` |
| Version | présent | `1.0.0+1` dans `pubspec.yaml` ; en local `flutter.versionName=1.0.0`, `versionCode=1` ; la CI remplace le code par le numéro d'exécution du workflow. | `pubspec.yaml:4` ; `android/local.properties` ; `PUBLICATION.md:55` ; `.github/workflows/appli.yml:128` |
| Signature | partiel | Mécanisme prévu (`key.properties`, secrets GitHub). Aucun `key.properties` ni `.jks` dans le dépôt : le release local est signé avec la clé de debug. | `android/app/build.gradle:15-24,66-82` ; `PUBLICATION.md:27-39,58-77` ; `ls android/key.properties` : absent |
| Politique de confidentialité | absent | Exigée dans PUBLICATION.md ; aucune page ni URL dans le dépôt (seule mention dans les tutos). | `PUBLICATION.md:93-96` ; `grep -rnil "confidentialit" docs PUBLICATION.md` : tutos seulement, pas de texte de politique |
| Public cible enfants (Familles) | partiel | Prévu : public 12-15 ans, programme Familles (AGENTS.md) ; PUBLICATION.md cite les tranches 9-12 ans et/ou 13-15 ans. À déclarer dans la Play Console, non fait dans le dépôt. | `AGENTS.md:863` ; `PUBLICATION.md:91-93` |
| Fiche Store (captures, texte) | partiel | Seule l'icône 512 existe dans `store/`. Aucune capture, aucun texte de fiche. | `store/icone_play_store_512.png` (`find store -type f` : 1 fichier) |
| Permissions | présent | Une seule : `INTERNET` (sans usage réseau constaté dans `lib/`). | `android/app/src/main/AndroidManifest.xml:2` |
| Build local | partiel | Aucun `.aab` local. APK release (daté du 2026-09-24, antérieur au commit audité) : arm64-v8a 56 330 141 octets, armeabi-v7a 53 919 079, x86_64 57 813 916 ; APK debug 234 044 509 (2026-10-15). | `build/app/outputs/flutter-apk/` et `build/app/outputs/apk/release/` ; `find build -name "*.aab"` sans résultat |
| Test fermé | absent | Prévu (12 testeurs, 14 jours) ; aucune trace d'exécution dans le dépôt. | `PUBLICATION.md:99-100` ; `AGENTS.md:863-864` |

## L. Médias

Mesures sur `assets/` (`du -sh assets` = 78 M).

| Point | Statut | Constat | Preuve |
|---|---|---|---|
| Images | présent | 202 fichiers : 100 png, 52 jpg, 50 webp (50 M dans `assets/images`). Plus gros dossiers : pantheon 26, mondes 26, lupulus 23, boutique 20, avatars 20, lecons 17. | `find assets -iname "*.png"` etc. ; `du -sh assets/images` ; `pubspec.yaml:29-45` |
| Sons (effets) | présent | 17 fichiers : 13 wav, 4 mp3. | `assets/audio/` ; `lib/data/services/audio_service.dart:468-472` |
| Musiques | présent | 3 fichiers ogg : accueil, arène, leçon. | `assets/audio/musique_accueil.ogg`, `musique_arene.ogg`, `musique_lecon.ogg` |
| Vidéos | présent | 12 mp4 (20 M) : 5 boss, intro, départ du cirque, triomphe, 3 entrées de niveau, Icare et Dédale. | `assets/cinematics/` ; `lib/ui/core/cinematic_player.dart:37-56` |
| Animations Lottie | présent | 4 fichiers json (chest_open, laurel_wreath, stars_glitter, sword_clash), 84 Ko. | `assets/animations/` ; `lib/ui/core/lottie_effects.dart` |
| Polices | présent | 2 fichiers ttf (300 Ko). | `pubspec.yaml:55-63` |
| Poids total | présent | `assets` = 78 M (images 50 M, vidéos 20 M, audio 7,8 M, données 344 Ko, polices 300 Ko, animations 84 Ko). | `du -sh assets assets/*` |
