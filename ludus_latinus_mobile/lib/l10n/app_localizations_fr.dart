// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get settingsTitle => 'PARAMÈTRES';

  @override
  String get settingsSectionHero => 'Ton héros';

  @override
  String get settingsSectionSound => 'Son et musique';

  @override
  String get settingsSoundTitle => 'Musique, bruitages et volume';

  @override
  String get settingsSoundMuted => 'Le son est coupé';

  @override
  String get settingsSoundOn => 'Le son est activé';

  @override
  String get settingsSectionDisplay => 'Affichage';

  @override
  String get settingsNightMode => 'Mode nuit';

  @override
  String get settingsSectionVideo => 'Vidéo';

  @override
  String get settingsReplayIntro => 'Revoir l\'introduction';

  @override
  String get settingsReplayIntroHint => 'Elle se joue aussi à chaque démarrage';

  @override
  String get heroCreationGreeting => 'SALVE !';

  @override
  String get heroCreationLupulusIntro =>
      'Je suis Lupulus, ton guide dans Rome.\nQui es-tu, jeune citoyen ?';

  @override
  String get heroCreationChangeLater =>
      'Tu pourras changer ton héros plus tard dans les Paramètres.';

  @override
  String get heroCreationEnter => 'ENTRER DANS ROME';

  @override
  String get heroCreationWriteName => 'ÉCRIS TON PRÉNOM';

  @override
  String get heroFormRoman => 'Un Romain';

  @override
  String get heroFormRomanFemale => 'Une Romaine';

  @override
  String get heroFormFirstName => 'Ton prénom';

  @override
  String get heroFormNameHintFemale => 'Julia, Léa, Livia…';

  @override
  String get heroFormNameHintMale => 'Marcus, Lucas, Titus…';

  @override
  String get appLoadError => 'Erreur de chargement des parchemins';

  @override
  String get loadingQuote1 => '« Festina lente » • Hâte-toi lentement';

  @override
  String get loadingQuote2 =>
      '« Per aspera ad astra » • Par des chemins ardus vers les étoiles';

  @override
  String get loadingQuote3 =>
      '« Veni, vidi, vici » • Je suis venu, j\'ai vu, j\'ai vaincu';

  @override
  String get loadingQuote4 =>
      '« Repetitio est mater studiorum » • La répétition est la mère des études';

  @override
  String get accountSyncDone =>
      '⚡ Parchemins synchronisés avec les archives du Tabularium !';

  @override
  String accountProfileUpdated(String name) {
    return 'Profil mis à jour : Salve, $name !';
  }

  @override
  String get accountTitle => 'TABULARIUM';

  @override
  String get accountTooltipDayMode => 'Mode Lux Romana (Jour)';

  @override
  String get accountTooltipNightMode => 'Mode Noctis Romana (Nuit)';

  @override
  String get accountTooltipShop => 'Taberna Romana (Boutique de Goodies)';

  @override
  String get accountTooltipAudio =>
      'Harmonia Antiqua (Réglages Audio & Bruitages)';

  @override
  String get accountCitizenName => 'Nom du citoyen';

  @override
  String get accountStudentFemaleHint =>
      'Élève Julia • Touche l\'avatar pour changer';

  @override
  String get accountStudentMaleHint =>
      'Élève Marcus • Touche l\'avatar pour changer';

  @override
  String get accountStatLessons => 'Leçons';

  @override
  String get accountStatSesterces => 'Sesterces';

  @override
  String get accountStatStreak => 'Série';

  @override
  String get accountStatMonuments => 'Monuments';

  @override
  String accountSesterceAmount(int amount) {
    return '$amount HS';
  }

  @override
  String accountDaysShort(int days) {
    return '$days j';
  }

  @override
  String get accountDiplomaButton => 'DIPLÔME DU SÉNAT • TESTIMONIVM (SPQR)';

  @override
  String get accountWardrobeTitle => 'Taberna & Vestiaire Impérial';

  @override
  String accountTogeLine(String toge, int amount) {
    return 'Toge : $toge • $amount HS';
  }

  @override
  String get accountWardrobeButton => 'Vestiaire';

  @override
  String get accountTrophiesTitle => 'Panthéon des Trophées';

  @override
  String get accountTrophiesHint => 'Touche un piédestal';

  @override
  String get accountTrophyFirstStep => 'Premier Pas';

  @override
  String get accountTrophyFirstStepCondition =>
      'Terminer ta toute première leçon de latin.';

  @override
  String get accountTrophyCenturion => 'Centurion';

  @override
  String get accountTrophyCenturionCondition =>
      'Valider 5 leçons complètes du Ludus.';

  @override
  String get accountTrophyCharioteer => 'Aurige';

  @override
  String get accountTrophyCharioteerCondition =>
      'Atteindre une série de 3 jours consécutifs.';

  @override
  String get accountTrophyBuilder => 'Bâtisseur';

  @override
  String get accountTrophyBuilderCondition =>
      'Restaurer au moins un monument du Forum.';

  @override
  String get accountTesseraTitle => 'Tessera Hospitalis (Jeton d’Hospitalité)';

  @override
  String get accountTesseraDescription =>
      'Ce jeton secret permet de transférer immédiatement tous tes progrès vers un smartphone, une tablette ou ton ordinateur en classe.';

  @override
  String get accountTesseraCopy => 'Copier la Tessera';

  @override
  String get accountTesseraCopied =>
      'Tessera Hospitalis copiée dans le presse-papier !';

  @override
  String get accountCloudTitle => 'Sauvegarde & Compte Cloud';

  @override
  String get accountCloudDescription =>
      'Associe ton adresse courriel pour sauvegarder ta progression sur les serveurs du Tabularium.';

  @override
  String get accountEmailLabel => 'Adresse courriel (email)';

  @override
  String get accountEmailHint => 'eleve@latin.ac-paris.fr';

  @override
  String get accountSyncing => 'Synchronisation...';

  @override
  String get accountSaveAndSync => 'Enregistrer & Synchroniser';

  @override
  String get accountEmailInvalid =>
      'Veuillez saisir une adresse courriel valide.';

  @override
  String accountLastSync(String date) {
    return 'Dernière synchronisation : $date';
  }

  @override
  String get accountSyncDateSeparator => ' à ';

  @override
  String get accountSyncNever => 'Jamais';

  @override
  String get accountTrophyUnlocked =>
      'Trophée débloqué et exposé au Panthéon !';

  @override
  String accountTrophyCondition(String condition) {
    return 'Condition : $condition';
  }

  @override
  String get accountTrophyClose => 'OPTICAS GRACIAS (Fermer)';

  @override
  String shopNotEnough(int missing) {
    return '🪙 Sesterces insuffisants ! Il te manque $missing HS. Réussis des leçons pour en amasser !';
  }

  @override
  String shopBought(String name, String latinName) {
    return 'Acquis & Équipé : $name ($latinName) !';
  }

  @override
  String shopEquipped(String name) {
    return 'Tenue modifiée : $name équipé !';
  }

  @override
  String get shopWhyHs => 'Pourquoi « HS » ?';

  @override
  String get shopTitle => 'TABERNA ROMANA';

  @override
  String get shopSubtitle => 'Boutique & Penderie Impériale • Équipe ton Héros';

  @override
  String get commonClose => 'Fermer';

  @override
  String get shopWorn => 'Porté';

  @override
  String get shopEquip => 'Équiper';

  @override
  String shopPrice(int price) {
    return '$price HS';
  }

  @override
  String get shopWhyHsOk => 'Optime !';

  @override
  String get shopWhyHsBody =>
      'Le sesterce (sestertius) était une pièce romaine qui valait deux as et demi.\n\nLes Romains l\'écrivaient IIS : II pour « deux », et S pour semis, « demi ». Pour ne pas le confondre avec un nombre, ils barraient les deux I… et le signe a fini par ressembler à un H : HS.\n\nSous l\'empereur Auguste, un légionnaire gagnait environ 900 sesterces par an.';

  @override
  String get grammarExerciseTitle => 'Exercice de grammaire';

  @override
  String get grammarTryAgain => 'Pas tout à fait… Réessaie.';

  @override
  String get vocabCorrectTitle => 'Optime !';

  @override
  String get vocabRememberHint =>
      'Retiens bien : la question reviendra à la fin.';

  @override
  String vocabEntryLine(String latin, String french) {
    return '$latin : $french';
  }

  @override
  String vocabExampleLine(String example, String translation) {
    return '« $example » $translation';
  }

  @override
  String vocabEtymology(String etymology) {
    return 'En français : $etymology';
  }

  @override
  String get commonContinueUpper => 'CONTINUER';

  @override
  String get puzzleEmptyWarning =>
      'Touche des mots pour composer ta phrase avant de valider !';

  @override
  String get puzzleWrongOrder =>
      '« Ce n\'est pas tout à fait le bon ordre des mots. Réessaie ! »';

  @override
  String get puzzleWrongWords =>
      '« Les mots ne sont pas tous les bons. Regarde les terminaisons du latin ! »';

  @override
  String get puzzleTitle => 'PUZZLE DE SYNTAXE ROMAINE';

  @override
  String puzzleInstruction(String phrase) {
    return 'Traduis ou réordonne : « $phrase »';
  }

  @override
  String get puzzleReset => 'Réinitialiser les mots';

  @override
  String get puzzleTapWords =>
      'Touche les mots ci-dessous pour assembler la phrase dans le bon ordre ✍️';

  @override
  String get puzzleAvailableWords => 'MOTS DISPONIBLES :';

  @override
  String get puzzleCheck => 'VÉRIFIER LA PHRASE ▶';

  @override
  String get clozeEmptyWarning => 'Complète la case vide avant de vérifier !';

  @override
  String get clozeWrongEnding =>
      '« Ce n\'est pas tout à fait cette terminaison. Observe bien le rôle du mot ! »';

  @override
  String get clozeInstruction =>
      'Complète la phrase latine avec la bonne forme :';

  @override
  String get clozeWriteEndingOnly => '✂️ Écris seulement la fin du mot';

  @override
  String get clozeWriteWholeWord => '✍️ Écris le mot entier';

  @override
  String get clozeAvailableOptions =>
      'OPTIONS DISPONIBLES (CLIQUE POUR SÉLECTIONNER) :';

  @override
  String get clozeCheck => 'VALIDER LA TERMINAISON ▶';

  @override
  String get decoderRoleSubject => 'Sujet (Nominatif)';

  @override
  String get decoderRoleObject => 'COD (Accusatif)';

  @override
  String get decoderRoleGenitive => 'Compl. du nom (Génitif)';

  @override
  String get decoderRoleVerb => 'Verbe d\'action';

  @override
  String get decoderRoleQuestion => 'Rôle ?';

  @override
  String get decoderUnknown => 'Inconnu';

  @override
  String get decoderIncompleteWarning =>
      'Attribue une fonction grammaticale à chaque mot avant de vérifier !';

  @override
  String get decoderWrongRole =>
      '« Une des fonctions grammaticales n\'est pas attribuée au bon mot. Observe bien les désinences ! »';

  @override
  String get decoderTitle => 'LE DÉCODEUR DE CAS GRAMMATICAUX';

  @override
  String get decoderInstruction =>
      'Sélectionne chaque mot et attribue-lui sa fonction dans la phrase.';

  @override
  String get decoderFunctionQuestion => 'Fonction ?';

  @override
  String decoderSuccess(String translation) {
    return '✅ Bien décodé ! Traduction : « $translation »';
  }

  @override
  String decoderAssignToWord(String word) {
    return 'ATTRIBUER AU MOT SÉLECTIONNÉ (« $word ») :';
  }

  @override
  String get decoderCheck => 'VÉRIFIER LE DÉCODAGE ▶';

  @override
  String get arenaChampion => 'Champion de l\'Arène';

  @override
  String get arenaAnswerProvocation => 'Réponds à la provocation du Boss :';

  @override
  String get arenaBossHp => 'Points de Vie : ';

  @override
  String get arenaYourLives => 'Tes vies : ';

  @override
  String arenaBossRepelled(String boss) {
    return '$boss t\'a repoussé !';
  }

  @override
  String get arenaNoLivesLeft =>
      'Tu n\'as plus de vie. Relis le cours du monde si besoin, puis retente ta chance : les réponses auront changé de place.';

  @override
  String get arenaRetry => 'Retenter l\'arène';

  @override
  String arenaHitWithExplanation(String explanation) {
    return 'Touché ! $explanation';
  }

  @override
  String get arenaHit => 'Touché !';

  @override
  String get arenaFinalBlow => 'Porter le coup final';

  @override
  String get arenaContinueFight => 'Continuer le combat';

  @override
  String arenaMissed(int lives) {
    String _temp0 = intl.Intl.pluralLogic(
      lives,
      locale: localeName,
      other: 'vies',
      one: 'vie',
    );
    return 'Raté ! Il te reste $lives $_temp0. Essaie une autre réponse.';
  }

  @override
  String lessonWorldCompleteNamed(String world) {
    return 'Monde terminé : $world';
  }

  @override
  String get lessonWorldComplete => 'Monde terminé !';

  @override
  String get lessonWorldCompleteUpper => 'MONDE TERMINÉ !';

  @override
  String get lessonWorldAllValidated =>
      'Toutes les leçons de ce monde sont validées.';

  @override
  String get lessonResultPerfect => 'Optime !';

  @override
  String get lessonResultPerfectHint => 'Réussi du premier coup.';

  @override
  String get lessonResultGood => 'Bene !';

  @override
  String get lessonResultGoodHint =>
      'Réussi avec une aide. Refais la leçon plus tard pour décrocher 3 étoiles.';

  @override
  String get lessonResultPassed => 'Leçon réussie';

  @override
  String get lessonResultPassedHint =>
      'Il a fallu plusieurs essais : relis la leçon et retente-la bientôt.';

  @override
  String lessonNewCard(String name) {
    return 'Nouvelle carte au Panthéon : $name';
  }

  @override
  String lessonNewRecord(int stars) {
    return 'Nouveau record : $stars ★';
  }

  @override
  String lessonAlreadyDoneRecord(int stars) {
    return 'Leçon déjà validée (record : $stars ★)';
  }

  @override
  String get lessonAlreadyDoneNoReward =>
      'Leçon déjà validée : pas de nouveaux sesterces';

  @override
  String get lessonCursusProgress => 'Progression du Cursus';

  @override
  String lessonCursusCount(int done, int total) {
    return '$done / $total leçons';
  }

  @override
  String get lessonContinue => 'CONTINUER ▶';

  @override
  String get lessonTypeQuiz => 'QCM Grammaire & Vocabulaire';

  @override
  String get lessonTypePuzzle => 'Syntaxe & Ordre des Mots';

  @override
  String get lessonTypeCloze => 'Déclinaisons & Cas Latins';

  @override
  String get lessonTypeArena => 'Épreuve d\'Arène / Combat';

  @override
  String get lessonTypeDecoder => 'Épigraphie & Décodage';

  @override
  String get lessonTypeDefault => 'Leçon & Exercice';

  @override
  String get lupulusGreetingGladiator =>
      '« Salve pugnator ! Dans l\'arène, la précision du mot frappe aussi fort que le glaive ! »';

  @override
  String get lupulusGreetingLegion =>
      '« Salve legionarie ! La discipline grammaticale est le bouclier des légions ! »';

  @override
  String get lupulusGreetingMyth =>
      '« Salve discipule ! Que Minerve et Apollon inspirent ta mémoire mythologique ! »';

  @override
  String get lupulusGreetingDefault =>
      '« Salve discipule ! Observe bien les racines latines, elles éclairent la langue française ! »';

  @override
  String get lessonLabel => 'LEÇON';

  @override
  String get lessonLatinPronunciation => 'Prononciation latine';

  @override
  String get lessonToExercise => 'À L\'EXERCICE ↓';

  @override
  String lessonValidatedStars(String filled, String empty) {
    return '✓ Validée $filled$empty';
  }

  @override
  String lessonUpToReward(int amount) {
    return 'Jusqu\'à +$amount HS';
  }

  @override
  String get lessonPronunciation => 'Prononciation';

  @override
  String get lessonReviewCourse => 'Revoir le cours';

  @override
  String get lessonBackToExercise => 'Retour à l\'exercice';

  @override
  String lessonProgressGrammar(int total) {
    return 'EXERCICE 2 / $total • GRAMMAIRE';
  }

  @override
  String lessonProgressVocab(int current, int total) {
    return 'EXERCICE $current / $total • VOCABULAIRE';
  }

  @override
  String lessonProgressFirst(int total) {
    return 'EXERCICE 1 / $total';
  }

  @override
  String get lessonChooseAnswer => 'Choisis la bonne réponse :';

  @override
  String get lessonHintButton => 'Indice : barrer une mauvaise réponse (−1 ★)';

  @override
  String get lessonSelectedAnswer => 'Réponse sélectionnée';

  @override
  String get lessonAdviceReread =>
      'Relis le passage de la leçon juste au-dessus : la réponse s\'y trouve.';

  @override
  String get lessonAdviceCases =>
      'Vérifie qui fait l\'action (nominatif) et qui la subit (accusatif), puis réessaie.';

  @override
  String get lessonAdviceNumber =>
      'Observe la terminaison du mot : c\'est elle qui indique le singulier ou le pluriel.';

  @override
  String get lessonNotQuite => 'Pas tout à fait…';

  @override
  String get lessonYouChose => 'Tu as choisi : ';

  @override
  String lessonChosenQuote(String text) {
    return '« $text »';
  }

  @override
  String get lessonRetry => 'Réessayer';

  @override
  String get lessonRetryWithHint => 'Réessayer avec un indice';

  @override
  String lessonRewardFloat(int amount) {
    return '+$amount HS';
  }

  @override
  String get homeClass5 => '5ème • Origines';

  @override
  String get homeClass4 => '4ème • République';

  @override
  String get homeClass3 => '3ème • Empire';

  @override
  String get homeBarLibrary => 'BIBLIOTHECA';

  @override
  String get homeBarGames => 'LUDI';

  @override
  String get homeBarTitle => 'LUDUS LATINUS';

  @override
  String get homeSettingsTooltip => 'Paramètres';

  @override
  String get homeTabCursus => 'Cursus';

  @override
  String get homeTabLibrary => 'Bibliotheca';

  @override
  String get homeTabGames => 'Ludi';

  @override
  String homeLessonsConquered(int done, int total) {
    return '$done / $total leçons conquises';
  }

  @override
  String homeLupulusSalve(String name) {
    return '« Salve $name ! Rome ne s’est pas faite en un jour. Poursuis ta marche triomphale ! »';
  }

  @override
  String get homeLupulusSalute =>
      '🐺 Lupulus t\'adresse son salut légionnaire : \"Per aspera ad astra !\"';

  @override
  String get homeViaAppia => 'LA VIA APPIA';

  @override
  String get homeViaAppiaSubtitle => '26 mondes du collège, de la 5e à la 3e';

  @override
  String get homeAdvanceOnRoad => '▶ AVANCER SUR LA ROUTE';

  @override
  String get homeShopTitle => 'Taberna Romana : la boutique';

  @override
  String homeShopHint(int amount) {
    return 'Dépense tes $amount sesterces : toges, couronnes, compagnons…';
  }

  @override
  String get homeQuestDone =>
      'Défi accompli ! Reviens demain pour une nouvelle quête.';

  @override
  String homeQuestPlay(int amount) {
    return 'JOUER · +$amount HS';
  }

  @override
  String get homeLessonTypeArena => 'Épreuve d\'Arène';

  @override
  String homeOfficialLessons(String className) {
    return 'LEÇONS OFFICIELLES • $className';
  }

  @override
  String get homeCurriculum =>
      'Programme du collège : grammaire, textes et exercices';

  @override
  String homeLessonsDone(int done, int total) {
    return '$done / $total leçons terminées';
  }

  @override
  String homeValidated(String stars) {
    return '✓ VALIDÉE $stars';
  }

  @override
  String get homeNextLesson => '▶ LEÇON SUIVANTE';

  @override
  String get homeInteractiveExercise => 'Exercice interactif du collège.';

  @override
  String get homeReviseLesson => 'RÉVISER LA LEÇON';

  @override
  String get homeStartLesson => 'COMMENCER LA LEÇON ▶';

  @override
  String get homeViaAppiaName => 'Via Appia';

  @override
  String get homeAllLessonsOfLevel => 'Toutes les leçons de ce niveau :';

  @override
  String homeLessonCount(int count) {
    return '$count leçons';
  }

  @override
  String get homeHere => '📍 ICI';

  @override
  String get homeDone => 'Validée';

  @override
  String get homeExplore => 'Explorer';

  @override
  String get cursusTitle => 'CURSUS HONORUM';

  @override
  String get cursusSubtitle => 'Carrière des Honneurs Romains';

  @override
  String cursusCurrentRank(String rank) {
    return 'TON RANG ACTUEL : $rank';
  }

  @override
  String cursusNextRank(
      String rank, int lessons, int monuments, int sesterces) {
    return 'Prochain rang : $rank ($lessons leçons, $monuments édifice(s), $sesterces HS)';
  }

  @override
  String get cursusTop => '👑 Tu as atteint le sommet du Cursus Honorum !';

  @override
  String get cursusYou => 'TOI';

  @override
  String cursusRequired(int lessons, int monuments, int sesterces) {
    return 'Requis : $lessons leçons • $monuments édifice(s) • $sesterces HS';
  }

  @override
  String get ludiTitle => 'LUDI & ARÈNES DE L\'EMPIRE';

  @override
  String get ludiSubtitle =>
      '« Panem et circenses » • Du pain et des jeux !\nDéfis chronométrés, courses épiques et tavernes antiques.';

  @override
  String ludiRecordPoints(int points) {
    return 'Record : $points pts';
  }

  @override
  String get ludiCircusSubtitle => 'Course de chars & turbo';

  @override
  String get ludiCircusTag => 'COURSE';

  @override
  String ludiRecordStreak(int count) {
    return 'Record : $count d\'affilée';
  }

  @override
  String get ludiDuelSubtitle => 'Arène tactique des champions';

  @override
  String get ludiDuelTag => 'ARÈNE';

  @override
  String get ludiTavernSubtitle => 'Taverne & dés romains';

  @override
  String get ludiTavernTag => 'DÉS';

  @override
  String get ludiCaesarSubtitle => 'Cryptographie militaire';

  @override
  String get ludiCaesarTag => 'ÉNIGME';

  @override
  String get ludiMarketSubtitle => 'Chiffres romains & étal';

  @override
  String get ludiMarketTag => 'COMMERCE';

  @override
  String get ludiPantheonSubtitle => 'Une carte par monde terminé';

  @override
  String get ludiPantheonTag => 'CARTES';

  @override
  String get ludiDidYouKnow => 'Le Saviez-vous ?';

  @override
  String ludiDidYouKnowBody(int count) {
    return 'Chaque nouvelle ville conquise sur la Via Appia déverrouille de nouveaux quartiers de loisirs. Avance dans tes leçons pour tout débloquer ! ($count leçons terminées).';
  }

  @override
  String get libraryTitle => 'BIBLIOTHECA ROMANA';

  @override
  String get librarySubtitle =>
      '« Littera scripta manet » • Les écrits restent.\nOutils de référence, mémoire espacée et trésors épigraphiques.';

  @override
  String libraryMemoriaRecord(int count, int record) {
    return '$count mot(s) ancré(s) · record $record';
  }

  @override
  String libraryMemoriaCount(int count) {
    return '$count mot(s) ancré(s) en mémoire';
  }

  @override
  String get libraryMemoriaTag => 'RÉVISION SRS';

  @override
  String get libraryThesaurusSubtitle => 'Lexique thématique & déclinaisons';

  @override
  String get libraryThesaurusTag => 'DICTIONNAIRE';

  @override
  String libraryForumCount(int count) {
    return '$count / 6 édifice(s) restauré(s)';
  }

  @override
  String get libraryForumTag => 'PATRIMOINE';

  @override
  String get libraryEpigraphyTitle => 'Épigraphie';

  @override
  String libraryEpigraphyCount(int count) {
    return '$count inscription(s) décodée(s)';
  }

  @override
  String get libraryEpigraphyTag => 'STÈLES';

  @override
  String get libraryExportTitle => 'TABULAE MEMORIALES (FICHES A4)';

  @override
  String get libraryExportBody =>
      'Exporte la table des 5 déclinaisons et tes flashcards au format papier A4 pour réviser hors-écran.';

  @override
  String get libraryTipTitle => 'Conseil Didactique de Lupulus';

  @override
  String get libraryTipBody =>
      'Réviser 5 minutes par jour avec Memoria Velox est 3 fois plus efficace qu\'une heure le week-end. Active la répétition espacée !';

  @override
  String get exportCopied =>
      'Fiche A4 copiée au format HTML ! Ouvre ton navigateur et imprime (Ctrl+P / Imprimer en PDF).';

  @override
  String get exportTitle => 'Tabulae Memoriales';

  @override
  String get exportSubtitle => 'Fiches de Révision & Flashcards A4 Imprimables';

  @override
  String get exportTabDeclensions => '📖 Déclinaisons';

  @override
  String get exportTabFlashcards => '✂️ Flashcards';

  @override
  String get exportTabRecords => '📜 Palmarès';

  @override
  String get exportCopyButton => 'COPIER LA FICHE A4 (HTML / PDF)';

  @override
  String get exportColumnCase => 'Cas';

  @override
  String get exportColumnSingular => 'Singulier';

  @override
  String get exportColumnPlural => 'Pluriel';

  @override
  String get exportFlashcardsIntro =>
      'Planche de révision découpable prête à l\'impression :';

  @override
  String exportRankTitle(String title) {
    return 'Titre républicain : $title';
  }

  @override
  String get exportTreasure => '🪙 Trésor accumulé';

  @override
  String get exportMonuments => '🏛️ Monuments restaurés';

  @override
  String exportMonumentsCount(int count) {
    return '$count / 6 édifices';
  }

  @override
  String get exportEpigraphs => '🔍 Stèles lapidaires décodées';

  @override
  String exportEpigraphsCount(int count) {
    return '$count inscriptions';
  }

  @override
  String get exportCards => '🃏 Cartes ancrées en mémoire SRS';

  @override
  String exportCardsCount(int count) {
    return '$count fiches';
  }

  @override
  String get exportStreak => '🔥 Série d\'assiduité quotidienne';

  @override
  String exportStreakCount(int count) {
    return '$count jour(s) consécutif(s)';
  }

  @override
  String get lupulusAdviceTitle => 'Lupulus te conseille';

  @override
  String get diplomaStatLessons => '📖 Leçons';

  @override
  String get diplomaStatForum => '🏛️ Forum';

  @override
  String get diplomaStatTreasure => '🪙 Trésor';

  @override
  String get diplomaStatStreak => '🔥 Ferveur';

  @override
  String get diplomaCopy => 'Copier l\'Eloge';

  @override
  String diplomaCopiedText(
      String name, String rank, int lessons, int monuments, String date) {
    return '🏛️ DIPLÔME DU SÉNAT ROMAIN (SPQR)\nProclamé pour : $name\nRang du Cursus Honorum : $rank\nAccomplissements : $lessons leçons maîtrisées, $monuments monuments restaurés au Forum.\n$date';
  }

  @override
  String get diplomaCopied => '📜 Éloge impérial copié dans le presse-papier !';

  @override
  String get diplomaRecognition => 'Reconnaissance';

  @override
  String get audioTab => 'SON';

  @override
  String get audioTitle => 'HARMONIA ANTIQUA';

  @override
  String get audioSubtitle => 'Sons & Résonances de l\'Empire';

  @override
  String get audioSoundsTitle => 'Sonorités de Rome';

  @override
  String get audioMuted => 'Sourdine activée (silence du temple)';

  @override
  String get audioSoundsOn => 'Bruitages authentiques actifs';

  @override
  String get audioMasterVolume => 'Volume Maître';

  @override
  String get audioMusic => 'Musique';

  @override
  String get audioMusicOn => 'Ambiance de lyre et de flûte';

  @override
  String get audioMusicOff => 'Musique coupée';

  @override
  String get audioHaptics => 'Retours Haptiques';

  @override
  String get audioHapticsOn => 'Vibrations du glaive & des victoires';

  @override
  String get audioHapticsOff => 'Vibrations désactivées';

  @override
  String get audioTestBench => 'BANC D\'ESSAI ACOUSTIQUE';

  @override
  String get audioSfxCoins => 'Sesterces d\'Or';

  @override
  String get audioSfxCoinsDesc => 'Tintement de pièces impériales';

  @override
  String get audioSfxDice => 'Alea & Fritillus';

  @override
  String get audioSfxDiceDesc => 'Roulement des osselets et dés';

  @override
  String get audioSfxTriumph => 'Fanfare de Triomphe';

  @override
  String get audioSfxTriumphDesc => 'Tubae & buccinae de victoire';

  @override
  String get audioSfxColosseum => 'Colosseum';

  @override
  String get audioSfxColosseumDesc => 'Clameur de la plèbe romaine';

  @override
  String get audioSfxSword => 'Glaive & Scutum';

  @override
  String get audioSfxSwordDesc => 'Choc métallique d\'acier et bronze';

  @override
  String get audioSfxCaesar => 'Roue de César';

  @override
  String get audioSfxCaesarDesc => 'Engrenage mécanique chiffré';

  @override
  String get audioSfxParchment => 'Parchemin & Carte';

  @override
  String get audioSfxParchmentDesc => 'Froissement velouté du vélin';

  @override
  String get questCompleteTitle => 'DÉFI DU JOUR ACCOMPLI !';

  @override
  String questCompleteReward(int amount) {
    return '+$amount SESTERCES';
  }

  @override
  String get questCollect => 'RÉCOLTER LE TRÉSOR';

  @override
  String get mapTitle => 'VIA APPIA';

  @override
  String get audioTooltip => 'Harmonia Antiqua (Audio)';

  @override
  String mapEpic(int done, int total) {
    return 'Épopée Romaine : $done / $total leçons';
  }

  @override
  String get mapAllCycle => 'Tout le Cycle 4';

  @override
  String get mapLegendQuiz => 'Quiz Grammaire';

  @override
  String get mapLegendSyntax => 'Syntaxe';

  @override
  String get mapLegendDeclensions => 'Déclinaisons';

  @override
  String get mapLegendBoss => 'Boss Arène';

  @override
  String get mapNoStep => 'Aucune étape trouvée pour ce cursus.';

  @override
  String mapWorldSalute(String number) {
    return '« Monde $number : que ta marche soit triomphale ! »';
  }

  @override
  String get mapLocked =>
      '🔒 Complète l\'étape précédente pour débloquer cette borne !';

  @override
  String get mapToPlay => '▶ À JOUER';

  @override
  String get mapTypeQuiz => 'Quiz';

  @override
  String get mapTypeEpigraphy => 'Épigraphie';

  @override
  String get mapTypeLesson => 'Leçon';

  @override
  String mapWorldBanner(String number) {
    return 'S • P • Q • R  •  MONDE $number';
  }

  @override
  String memoriaCorrect(String box, int days, String bonus) {
    return 'Exact ! Arca $box : prochaine révision dans $days j$bonus';
  }

  @override
  String memoriaGainBonus(int gain) {
    return ' (+$gain HS)';
  }

  @override
  String memoriaWrong(String answer) {
    return 'C\'était « $answer ». Retour en Arca I : tu la reverras bientôt.';
  }

  @override
  String get memoriaTriumph => 'TRIOMPHE DE LA MÉMOIRE';

  @override
  String memoriaFinished(int earnings, String streakLine) {
    return 'Session de révision achevée avec brio !\nTu as remporté +$earnings Sesterces (HS) !$streakLine';
  }

  @override
  String memoriaMaxStreakLine(int streak) {
    return '\n🔥 Furor Latinus Max : $streak d\'affilée !';
  }

  @override
  String get memoriaBackToForum => 'Retour au Forum';

  @override
  String get memoriaTitle => 'MEMORIA VELOX';

  @override
  String get memoriaEmpty =>
      'Ta Memoria est encore vide.\n\nTermine une leçon de la Via Appia : ses mots viendront s\'y réviser.';

  @override
  String memoriaEmptyLevel(String level) {
    return 'Aucun mot de $level pour l\'instant : termine une leçon de ce niveau.';
  }

  @override
  String memoriaEarnings(int amount) {
    return '+$amount HS';
  }

  @override
  String get memoriaFurorMax => 'FUROR LATINUS MAXIMUS !';

  @override
  String get memoriaFuror => 'FUROR LATINUS !';

  @override
  String memoriaStreakParen(int streak) {
    return '($streak d\'affilée)';
  }

  @override
  String memoriaCardCounter(int index, int total) {
    return 'Carte $index / $total';
  }

  @override
  String memoriaDue(int count) {
    return '$count à réviser';
  }

  @override
  String get memoriaCheer1 => '« Incredibile ! Le feu de Rome brûle en toi ! »';

  @override
  String get memoriaCheer2 =>
      '« Macte animo ! Continue sur cette belle lancée ! »';

  @override
  String get memoriaCheer3 => '« Repetitio est mater studiorum ! »';

  @override
  String get memoriaNextCard => 'CARTE SUIVANTE';

  @override
  String get memoriaFinish => 'TERMINER';

  @override
  String get memoriaPronunciation => 'Prononciation & API';

  @override
  String get memoriaChooseTranslation => 'Choisis sa traduction ci-dessous';

  @override
  String get memoriaFrenchTranslation => 'TRADUCTION FRANÇAISE';

  @override
  String commonQuoted(String text) {
    return '« $text »';
  }

  @override
  String get memoriaListenSentence => 'Écouter la phrase';

  @override
  String memoriaTranslationLine(String text) {
    return '= $text';
  }

  @override
  String get pantheonTitle => 'Le Panthéon';

  @override
  String get pantheonAlbum => 'ALBUM DES CARTES';

  @override
  String get pantheonHint => 'Termine un monde pour retourner sa carte.';

  @override
  String pantheonCount(int won, int total) {
    return '$won / $total cartes';
  }

  @override
  String pantheonWorld(int number) {
    return 'Monde $number';
  }

  @override
  String get pantheonHiddenCard => 'Carte cachée';

  @override
  String get tavernTitle => 'TAVERNE DES DÉS';

  @override
  String tavernPurse(int amount) {
    return '🪙 $amount HS';
  }

  @override
  String get tavernGaius => 'Gaius l\'aubergiste';

  @override
  String get tavernGaiusWaits => 'Gaius attend que tu t\'arrêtes…';

  @override
  String get tavernBust =>
      'Tu as dépassé XXI : Gaius n\'a pas besoin de jouer.';

  @override
  String get tavernYou => 'Toi';

  @override
  String tavernRewardsLeft(int left, int gain) {
    return 'Victoires payées aujourd\'hui : encore $left sur 3 (+$gain HS chacune)';
  }

  @override
  String get tavernRewardsDone =>
      'Tes 3 victoires payées du jour sont faites : tu peux jouer pour la gloire.';

  @override
  String get tavernRulesTitle =>
      '🎲 AD XXI : approche-toi de 21 sans le dépasser';

  @override
  String get tavernRule1 =>
      'Ajoute des dés un par un. Ton total s\'écrit en chiffres romains.';

  @override
  String get tavernRule2 =>
      'Arrête-toi quand tu veux. Au-dessus de XXI, tu as perdu.';

  @override
  String get tavernRule3 =>
      'Gaius joue ensuite : il relance tant qu\'il a moins de XVII. Le plus près de XXI gagne ; à égalité, personne ne gagne.';

  @override
  String get tavernHelp =>
      'Aide : I = 1 · V = 5 · X = 10 · IV = 4 · IX = 9 · XXI = 21';

  @override
  String tavernTotal(String total) {
    return 'Total : $total';
  }

  @override
  String get tavernRollAgain => '🎲 Encore un dé';

  @override
  String get tavernStop => '✋ Je m\'arrête';

  @override
  String get tavernGaiusRolls => 'Gaius lance ses dés…';

  @override
  String get tavernYouWin => '🏆 Tu bats Gaius !';

  @override
  String tavernGaiusBust(String roman, int value) {
    return 'Gaius a dépassé XXI avec $roman ($value).';
  }

  @override
  String tavernYouBeat(
      String yourRoman, int yourValue, String hisRoman, int hisValue) {
    return 'Ton $yourRoman ($yourValue) bat son $hisRoman ($hisValue).';
  }

  @override
  String get tavernTooFar => '💥 Trop loin !';

  @override
  String get tavernGaiusWins => 'Gaius l\'emporte';

  @override
  String tavernYouBust(String roman, int value) {
    return '$roman ($value) dépasse XXI (21).';
  }

  @override
  String tavernHeBeats(
      String hisRoman, int hisValue, String yourRoman, int yourValue) {
    return 'Son $hisRoman ($hisValue) bat ton $yourRoman ($yourValue).';
  }

  @override
  String get tavernTie => '⚖️ Égalité';

  @override
  String tavernTieBody(String roman, int value) {
    return 'Vous avez tous les deux $roman ($value).';
  }

  @override
  String tavernWinBonus(int amount) {
    return '+$amount HS pour la victoire';
  }

  @override
  String tavernQuestBonus(int amount) {
    return '+$amount HS pour le défi du jour';
  }

  @override
  String get tavernNewRound => '🎲 NOUVELLE MANCHE';

  @override
  String get forumTitle => 'FORUM IMPERIALE';

  @override
  String forumBuildingsCount(int done, int total) {
    return '$done / $total Édifices';
  }

  @override
  String get forumIntro =>
      'Restaure les chefs-d’œuvre de la Ville Éternelle grâce à tes sesterces de quête. Chaque monument restauré débloque un bonus permanent pour ton épopée !';

  @override
  String get forumEpigraphyTitle => 'Atelier d\'Épigraphie Lapidaire';

  @override
  String forumEpigraphyCount(int done, int total) {
    return '$done / $total Déchiffrées';
  }

  @override
  String get forumEpigraphyIntro =>
      'Restaure les stèles de travertin et de marbre de Rome. Déchiffre les abréviations impériales au marteau lapidaire pour obtenir la sagesse antique et des sesterces !';

  @override
  String get forumOpenEpigraphy =>
      'OUVRIR LA RESTAURATION DES 6 STÈLES ANTIQUES';

  @override
  String forumRestored(String name, String bonus) {
    return '$name restauré avec gloire ! Bonus actif : $bonus';
  }

  @override
  String get forumRestoredTag => 'RESTAURÉ';

  @override
  String forumCost(int amount) {
    return '$amount HS';
  }

  @override
  String forumPermanentBonus(String bonus) {
    return 'Bonus permanent : $bonus';
  }

  @override
  String get forumEpigraphDecoded => 'Épigraphe Déchiffrée (Revoir la Pierre)';

  @override
  String get forumEpigraphDecode => 'Déchiffrer l\'Épigraphe Gravée (+15 HS)';

  @override
  String get forumRebuild => 'Reconstruire ce monument';

  @override
  String get forumNotEnough => 'Fonds insuffisants';

  @override
  String get thesaurusTitle => 'THESAURUS';

  @override
  String get thesaurusTabDictionary => 'Dictionnaire';

  @override
  String get thesaurusTabDeclensions => 'Déclinaisons';

  @override
  String get thesaurusTabConjugations => 'Conjugaisons';

  @override
  String get thesaurusSearchHint => 'Rechercher en latin ou français...';

  @override
  String thesaurusTermsFound(int count) {
    return '$count terme(s) trouvé(s)';
  }

  @override
  String get thesaurusVocabCycle => 'Vocabulaire Cycle 4';

  @override
  String thesaurusNoWord(String query) {
    return 'Aucun mot trouvé pour « $query »';
  }

  @override
  String get thesaurusCertifiedPronunciation =>
      'Prononciation latine certifiée';

  @override
  String get thesaurusSixCases => 'LES SIX CAS';

  @override
  String pantheonUnlock(int number) {
    return 'Termine le monde $number pour la débloquer';
  }

  @override
  String pantheonUnlockNamed(int number, String title) {
    return 'Termine le monde $number : $title pour la débloquer';
  }

  @override
  String get memoriaLevelAll => 'Tous';

  @override
  String get memoriaLevel5 => '5ème';

  @override
  String get memoriaLevel4 => '4ème';

  @override
  String get memoriaLevel3 => '3ème';

  @override
  String get thesaurusCatAll => 'Tous';

  @override
  String get thesaurusCatNoun => 'Nom';

  @override
  String get thesaurusCatVerb => 'Verbe';

  @override
  String get thesaurusCatAdjective => 'Adjectif';

  @override
  String get thesaurusCatPronoun => 'Pronom';

  @override
  String get thesaurusCatInvariable => 'Invariable';

  @override
  String get settingsSectionApp => 'Application';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsAboutHint => 'Version et éditeur';

  @override
  String get aboutTitle => 'À PROPOS';

  @override
  String aboutVersion(String version, String build) {
    return 'Version $version ($build)';
  }

  @override
  String get aboutVersionLoading => 'Version …';

  @override
  String get aboutPublisher => 'Édité par Icare & Dédale';

  @override
  String get aboutRights => '© 2026 Icare & Dédale. Tous droits réservés.';

  @override
  String get aboutReplayStudio => 'Revoir l\'animation du studio';
}
