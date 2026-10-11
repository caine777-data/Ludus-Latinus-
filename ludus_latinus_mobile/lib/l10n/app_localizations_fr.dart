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
}
