import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'PARAMÈTRES'**
  String get settingsTitle;

  /// No description provided for @settingsSectionHero.
  ///
  /// In fr, this message translates to:
  /// **'Ton héros'**
  String get settingsSectionHero;

  /// No description provided for @settingsSectionSound.
  ///
  /// In fr, this message translates to:
  /// **'Son et musique'**
  String get settingsSectionSound;

  /// No description provided for @settingsSoundTitle.
  ///
  /// In fr, this message translates to:
  /// **'Musique, bruitages et volume'**
  String get settingsSoundTitle;

  /// No description provided for @settingsSoundMuted.
  ///
  /// In fr, this message translates to:
  /// **'Le son est coupé'**
  String get settingsSoundMuted;

  /// No description provided for @settingsSoundOn.
  ///
  /// In fr, this message translates to:
  /// **'Le son est activé'**
  String get settingsSoundOn;

  /// No description provided for @settingsSectionDisplay.
  ///
  /// In fr, this message translates to:
  /// **'Affichage'**
  String get settingsSectionDisplay;

  /// No description provided for @settingsNightMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode nuit'**
  String get settingsNightMode;

  /// No description provided for @settingsSectionVideo.
  ///
  /// In fr, this message translates to:
  /// **'Vidéo'**
  String get settingsSectionVideo;

  /// No description provided for @settingsReplayIntro.
  ///
  /// In fr, this message translates to:
  /// **'Revoir l\'introduction'**
  String get settingsReplayIntro;

  /// No description provided for @settingsReplayIntroHint.
  ///
  /// In fr, this message translates to:
  /// **'Elle se joue aussi à chaque démarrage'**
  String get settingsReplayIntroHint;

  /// No description provided for @heroCreationGreeting.
  ///
  /// In fr, this message translates to:
  /// **'SALVE !'**
  String get heroCreationGreeting;

  /// No description provided for @heroCreationLupulusIntro.
  ///
  /// In fr, this message translates to:
  /// **'Je suis Lupulus, ton guide dans Rome.\nQui es-tu, jeune citoyen ?'**
  String get heroCreationLupulusIntro;

  /// No description provided for @heroCreationChangeLater.
  ///
  /// In fr, this message translates to:
  /// **'Tu pourras changer ton héros plus tard dans les Paramètres.'**
  String get heroCreationChangeLater;

  /// No description provided for @heroCreationEnter.
  ///
  /// In fr, this message translates to:
  /// **'ENTRER DANS ROME'**
  String get heroCreationEnter;

  /// No description provided for @heroCreationWriteName.
  ///
  /// In fr, this message translates to:
  /// **'ÉCRIS TON PRÉNOM'**
  String get heroCreationWriteName;

  /// No description provided for @heroFormRoman.
  ///
  /// In fr, this message translates to:
  /// **'Un Romain'**
  String get heroFormRoman;

  /// No description provided for @heroFormRomanFemale.
  ///
  /// In fr, this message translates to:
  /// **'Une Romaine'**
  String get heroFormRomanFemale;

  /// No description provided for @heroFormFirstName.
  ///
  /// In fr, this message translates to:
  /// **'Ton prénom'**
  String get heroFormFirstName;

  /// No description provided for @heroFormNameHintFemale.
  ///
  /// In fr, this message translates to:
  /// **'Julia, Léa, Livia…'**
  String get heroFormNameHintFemale;

  /// No description provided for @heroFormNameHintMale.
  ///
  /// In fr, this message translates to:
  /// **'Marcus, Lucas, Titus…'**
  String get heroFormNameHintMale;

  /// No description provided for @appLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de chargement des parchemins'**
  String get appLoadError;

  /// No description provided for @loadingQuote1.
  ///
  /// In fr, this message translates to:
  /// **'« Festina lente » • Hâte-toi lentement'**
  String get loadingQuote1;

  /// No description provided for @loadingQuote2.
  ///
  /// In fr, this message translates to:
  /// **'« Per aspera ad astra » • Par des chemins ardus vers les étoiles'**
  String get loadingQuote2;

  /// No description provided for @loadingQuote3.
  ///
  /// In fr, this message translates to:
  /// **'« Veni, vidi, vici » • Je suis venu, j\'ai vu, j\'ai vaincu'**
  String get loadingQuote3;

  /// No description provided for @loadingQuote4.
  ///
  /// In fr, this message translates to:
  /// **'« Repetitio est mater studiorum » • La répétition est la mère des études'**
  String get loadingQuote4;

  /// No description provided for @accountProfileUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Profil mis à jour : Salve, {name} !'**
  String accountProfileUpdated(String name);

  /// No description provided for @accountTitle.
  ///
  /// In fr, this message translates to:
  /// **'TABULARIUM'**
  String get accountTitle;

  /// No description provided for @accountTooltipDayMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode Lux Romana (Jour)'**
  String get accountTooltipDayMode;

  /// No description provided for @accountTooltipNightMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode Noctis Romana (Nuit)'**
  String get accountTooltipNightMode;

  /// No description provided for @accountTooltipShop.
  ///
  /// In fr, this message translates to:
  /// **'Taberna Romana (Boutique de Goodies)'**
  String get accountTooltipShop;

  /// No description provided for @accountTooltipAudio.
  ///
  /// In fr, this message translates to:
  /// **'Harmonia Antiqua (Réglages Audio & Bruitages)'**
  String get accountTooltipAudio;

  /// No description provided for @accountCitizenName.
  ///
  /// In fr, this message translates to:
  /// **'Nom du citoyen'**
  String get accountCitizenName;

  /// No description provided for @accountStudentFemaleHint.
  ///
  /// In fr, this message translates to:
  /// **'Élève Julia • Touche l\'avatar pour changer'**
  String get accountStudentFemaleHint;

  /// No description provided for @accountStudentMaleHint.
  ///
  /// In fr, this message translates to:
  /// **'Élève Marcus • Touche l\'avatar pour changer'**
  String get accountStudentMaleHint;

  /// No description provided for @accountStatLessons.
  ///
  /// In fr, this message translates to:
  /// **'Leçons'**
  String get accountStatLessons;

  /// No description provided for @accountStatSesterces.
  ///
  /// In fr, this message translates to:
  /// **'Sesterces'**
  String get accountStatSesterces;

  /// No description provided for @accountStatStreak.
  ///
  /// In fr, this message translates to:
  /// **'Série'**
  String get accountStatStreak;

  /// No description provided for @accountStatMonuments.
  ///
  /// In fr, this message translates to:
  /// **'Monuments'**
  String get accountStatMonuments;

  /// No description provided for @accountSesterceAmount.
  ///
  /// In fr, this message translates to:
  /// **'{amount} HS'**
  String accountSesterceAmount(int amount);

  /// No description provided for @accountDaysShort.
  ///
  /// In fr, this message translates to:
  /// **'{days} j'**
  String accountDaysShort(int days);

  /// No description provided for @accountDiplomaButton.
  ///
  /// In fr, this message translates to:
  /// **'DIPLÔME DU SÉNAT • TESTIMONIVM (SPQR)'**
  String get accountDiplomaButton;

  /// No description provided for @accountWardrobeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Taberna & Vestiaire Impérial'**
  String get accountWardrobeTitle;

  /// No description provided for @accountTogeLine.
  ///
  /// In fr, this message translates to:
  /// **'Toge : {toge} • {amount} HS'**
  String accountTogeLine(String toge, int amount);

  /// No description provided for @accountWardrobeButton.
  ///
  /// In fr, this message translates to:
  /// **'Vestiaire'**
  String get accountWardrobeButton;

  /// No description provided for @accountBackupTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde de ta progression'**
  String get accountBackupTitle;

  /// No description provided for @accountBackupDescription.
  ///
  /// In fr, this message translates to:
  /// **'Ta progression est enregistrée sur cet appareil. Pour la retrouver sur un autre appareil, exporte-la dans un fichier, puis importe ce fichier sur le nouvel appareil.'**
  String get accountBackupDescription;

  /// No description provided for @accountBackupExport.
  ///
  /// In fr, this message translates to:
  /// **'Exporter dans un fichier'**
  String get accountBackupExport;

  /// No description provided for @accountBackupImport.
  ///
  /// In fr, this message translates to:
  /// **'Importer un fichier'**
  String get accountBackupImport;

  /// No description provided for @accountBackupExported.
  ///
  /// In fr, this message translates to:
  /// **'Progression exportée.'**
  String get accountBackupExported;

  /// No description provided for @accountBackupImportConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Remplacer ta progression ?'**
  String get accountBackupImportConfirmTitle;

  /// No description provided for @accountBackupImportConfirmBody.
  ///
  /// In fr, this message translates to:
  /// **'La progression de ce fichier remplacera celle de cet appareil. Cette action ne peut pas être annulée.'**
  String get accountBackupImportConfirmBody;

  /// No description provided for @accountBackupCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get accountBackupCancel;

  /// No description provided for @accountBackupImportConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Remplacer'**
  String get accountBackupImportConfirm;

  /// No description provided for @accountBackupImported.
  ///
  /// In fr, this message translates to:
  /// **'Progression importée.'**
  String get accountBackupImported;

  /// No description provided for @accountBackupExportFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'enregistrer le fichier. Choisis un autre dossier.'**
  String get accountBackupExportFailed;

  /// No description provided for @accountBackupInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Ce fichier n\'est pas une sauvegarde de Ludus Latinus.'**
  String get accountBackupInvalid;

  /// No description provided for @shopNotEnough.
  ///
  /// In fr, this message translates to:
  /// **'🪙 Sesterces insuffisants ! Il te manque {missing} HS. Réussis des leçons pour en amasser !'**
  String shopNotEnough(int missing);

  /// No description provided for @shopBought.
  ///
  /// In fr, this message translates to:
  /// **'Acquis & Équipé : {name} ({latinName}) !'**
  String shopBought(String name, String latinName);

  /// No description provided for @shopEquipped.
  ///
  /// In fr, this message translates to:
  /// **'Tenue modifiée : {name} équipé !'**
  String shopEquipped(String name);

  /// No description provided for @shopWhyHs.
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi « HS » ?'**
  String get shopWhyHs;

  /// No description provided for @shopTitle.
  ///
  /// In fr, this message translates to:
  /// **'TABERNA ROMANA'**
  String get shopTitle;

  /// No description provided for @shopSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Boutique & Penderie Impériale • Équipe ton Héros'**
  String get shopSubtitle;

  /// No description provided for @commonClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get commonClose;

  /// No description provided for @shopWorn.
  ///
  /// In fr, this message translates to:
  /// **'Porté'**
  String get shopWorn;

  /// No description provided for @shopEquip.
  ///
  /// In fr, this message translates to:
  /// **'Équiper'**
  String get shopEquip;

  /// No description provided for @shopPrice.
  ///
  /// In fr, this message translates to:
  /// **'{price} HS'**
  String shopPrice(int price);

  /// No description provided for @shopWhyHsOk.
  ///
  /// In fr, this message translates to:
  /// **'Optime !'**
  String get shopWhyHsOk;

  /// No description provided for @shopWhyHsBody.
  ///
  /// In fr, this message translates to:
  /// **'Le sesterce (sestertius) était une pièce romaine qui valait deux as et demi.\n\nLes Romains l\'écrivaient IIS : II pour « deux », et S pour semis, « demi ». Pour ne pas le confondre avec un nombre, ils barraient les deux I… et le signe a fini par ressembler à un H : HS.\n\nSous l\'empereur Auguste, un légionnaire gagnait environ 900 sesterces par an.'**
  String get shopWhyHsBody;

  /// No description provided for @grammarExerciseTitle.
  ///
  /// In fr, this message translates to:
  /// **'Exercice de grammaire'**
  String get grammarExerciseTitle;

  /// No description provided for @grammarTryAgain.
  ///
  /// In fr, this message translates to:
  /// **'Pas tout à fait… Réessaie.'**
  String get grammarTryAgain;

  /// No description provided for @vocabCorrectTitle.
  ///
  /// In fr, this message translates to:
  /// **'Optime !'**
  String get vocabCorrectTitle;

  /// No description provided for @vocabRememberHint.
  ///
  /// In fr, this message translates to:
  /// **'Retiens bien : la question reviendra à la fin.'**
  String get vocabRememberHint;

  /// No description provided for @vocabEntryLine.
  ///
  /// In fr, this message translates to:
  /// **'{latin} : {french}'**
  String vocabEntryLine(String latin, String french);

  /// No description provided for @vocabExampleLine.
  ///
  /// In fr, this message translates to:
  /// **'« {example} » {translation}'**
  String vocabExampleLine(String example, String translation);

  /// No description provided for @vocabEtymology.
  ///
  /// In fr, this message translates to:
  /// **'En français : {etymology}'**
  String vocabEtymology(String etymology);

  /// No description provided for @commonContinueUpper.
  ///
  /// In fr, this message translates to:
  /// **'CONTINUER'**
  String get commonContinueUpper;

  /// No description provided for @puzzleEmptyWarning.
  ///
  /// In fr, this message translates to:
  /// **'Touche des mots pour composer ta phrase avant de valider !'**
  String get puzzleEmptyWarning;

  /// No description provided for @puzzleWrongOrder.
  ///
  /// In fr, this message translates to:
  /// **'« Ce n\'est pas tout à fait le bon ordre des mots. Réessaie ! »'**
  String get puzzleWrongOrder;

  /// No description provided for @puzzleWrongWords.
  ///
  /// In fr, this message translates to:
  /// **'« Les mots ne sont pas tous les bons. Regarde les terminaisons du latin ! »'**
  String get puzzleWrongWords;

  /// No description provided for @puzzleTitle.
  ///
  /// In fr, this message translates to:
  /// **'PUZZLE DE SYNTAXE ROMAINE'**
  String get puzzleTitle;

  /// No description provided for @puzzleInstruction.
  ///
  /// In fr, this message translates to:
  /// **'Traduis ou réordonne : « {phrase} »'**
  String puzzleInstruction(String phrase);

  /// No description provided for @puzzleReset.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser les mots'**
  String get puzzleReset;

  /// No description provided for @puzzleTapWords.
  ///
  /// In fr, this message translates to:
  /// **'Touche les mots ci-dessous pour assembler la phrase dans le bon ordre ✍️'**
  String get puzzleTapWords;

  /// No description provided for @puzzleAvailableWords.
  ///
  /// In fr, this message translates to:
  /// **'MOTS DISPONIBLES :'**
  String get puzzleAvailableWords;

  /// No description provided for @puzzleCheck.
  ///
  /// In fr, this message translates to:
  /// **'VÉRIFIER LA PHRASE ▶'**
  String get puzzleCheck;

  /// No description provided for @clozeEmptyWarning.
  ///
  /// In fr, this message translates to:
  /// **'Complète la case vide avant de vérifier !'**
  String get clozeEmptyWarning;

  /// No description provided for @clozeWrongEnding.
  ///
  /// In fr, this message translates to:
  /// **'« Ce n\'est pas tout à fait cette terminaison. Observe bien le rôle du mot ! »'**
  String get clozeWrongEnding;

  /// No description provided for @clozeInstruction.
  ///
  /// In fr, this message translates to:
  /// **'Complète la phrase latine avec la bonne forme :'**
  String get clozeInstruction;

  /// No description provided for @clozeWriteEndingOnly.
  ///
  /// In fr, this message translates to:
  /// **'✂️ Écris seulement la fin du mot'**
  String get clozeWriteEndingOnly;

  /// No description provided for @clozeWriteWholeWord.
  ///
  /// In fr, this message translates to:
  /// **'✍️ Écris le mot entier'**
  String get clozeWriteWholeWord;

  /// No description provided for @clozeAvailableOptions.
  ///
  /// In fr, this message translates to:
  /// **'OPTIONS DISPONIBLES (CLIQUE POUR SÉLECTIONNER) :'**
  String get clozeAvailableOptions;

  /// No description provided for @clozeCheck.
  ///
  /// In fr, this message translates to:
  /// **'VALIDER LA TERMINAISON ▶'**
  String get clozeCheck;

  /// No description provided for @decoderRoleSubject.
  ///
  /// In fr, this message translates to:
  /// **'Sujet (Nominatif)'**
  String get decoderRoleSubject;

  /// No description provided for @decoderRoleObject.
  ///
  /// In fr, this message translates to:
  /// **'COD (Accusatif)'**
  String get decoderRoleObject;

  /// No description provided for @decoderRoleGenitive.
  ///
  /// In fr, this message translates to:
  /// **'Compl. du nom (Génitif)'**
  String get decoderRoleGenitive;

  /// No description provided for @decoderRoleVerb.
  ///
  /// In fr, this message translates to:
  /// **'Verbe d\'action'**
  String get decoderRoleVerb;

  /// No description provided for @decoderRoleQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Rôle ?'**
  String get decoderRoleQuestion;

  /// No description provided for @decoderUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Inconnu'**
  String get decoderUnknown;

  /// No description provided for @decoderIncompleteWarning.
  ///
  /// In fr, this message translates to:
  /// **'Attribue une fonction grammaticale à chaque mot avant de vérifier !'**
  String get decoderIncompleteWarning;

  /// No description provided for @decoderWrongRole.
  ///
  /// In fr, this message translates to:
  /// **'« Une des fonctions grammaticales n\'est pas attribuée au bon mot. Observe bien les désinences ! »'**
  String get decoderWrongRole;

  /// No description provided for @decoderTitle.
  ///
  /// In fr, this message translates to:
  /// **'LE DÉCODEUR DE CAS GRAMMATICAUX'**
  String get decoderTitle;

  /// No description provided for @decoderInstruction.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionne chaque mot et attribue-lui sa fonction dans la phrase.'**
  String get decoderInstruction;

  /// No description provided for @decoderFunctionQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Fonction ?'**
  String get decoderFunctionQuestion;

  /// No description provided for @decoderSuccess.
  ///
  /// In fr, this message translates to:
  /// **'✅ Bien décodé ! Traduction : « {translation} »'**
  String decoderSuccess(String translation);

  /// No description provided for @decoderAssignToWord.
  ///
  /// In fr, this message translates to:
  /// **'ATTRIBUER AU MOT SÉLECTIONNÉ (« {word} ») :'**
  String decoderAssignToWord(String word);

  /// No description provided for @decoderCheck.
  ///
  /// In fr, this message translates to:
  /// **'VÉRIFIER LE DÉCODAGE ▶'**
  String get decoderCheck;

  /// No description provided for @arenaChampion.
  ///
  /// In fr, this message translates to:
  /// **'Champion de l\'Arène'**
  String get arenaChampion;

  /// No description provided for @arenaAnswerProvocation.
  ///
  /// In fr, this message translates to:
  /// **'Réponds à la provocation du Boss :'**
  String get arenaAnswerProvocation;

  /// No description provided for @arenaBossHp.
  ///
  /// In fr, this message translates to:
  /// **'Points de Vie : '**
  String get arenaBossHp;

  /// No description provided for @arenaYourLives.
  ///
  /// In fr, this message translates to:
  /// **'Tes vies : '**
  String get arenaYourLives;

  /// No description provided for @arenaBossRepelled.
  ///
  /// In fr, this message translates to:
  /// **'{boss} t\'a repoussé !'**
  String arenaBossRepelled(String boss);

  /// No description provided for @arenaNoLivesLeft.
  ///
  /// In fr, this message translates to:
  /// **'Tu n\'as plus de vie. Relis le cours du monde si besoin, puis retente ta chance : les réponses auront changé de place.'**
  String get arenaNoLivesLeft;

  /// No description provided for @arenaRetry.
  ///
  /// In fr, this message translates to:
  /// **'Retenter l\'arène'**
  String get arenaRetry;

  /// No description provided for @arenaHitWithExplanation.
  ///
  /// In fr, this message translates to:
  /// **'Touché ! {explanation}'**
  String arenaHitWithExplanation(String explanation);

  /// No description provided for @arenaHit.
  ///
  /// In fr, this message translates to:
  /// **'Touché !'**
  String get arenaHit;

  /// No description provided for @arenaFinalBlow.
  ///
  /// In fr, this message translates to:
  /// **'Porter le coup final'**
  String get arenaFinalBlow;

  /// No description provided for @arenaContinueFight.
  ///
  /// In fr, this message translates to:
  /// **'Continuer le combat'**
  String get arenaContinueFight;

  /// No description provided for @arenaMissed.
  ///
  /// In fr, this message translates to:
  /// **'Raté ! Il te reste {lives} {lives, plural, one{vie} other{vies}}. Essaie une autre réponse.'**
  String arenaMissed(int lives);

  /// No description provided for @lessonWorldCompleteNamed.
  ///
  /// In fr, this message translates to:
  /// **'Monde terminé : {world}'**
  String lessonWorldCompleteNamed(String world);

  /// No description provided for @lessonWorldComplete.
  ///
  /// In fr, this message translates to:
  /// **'Monde terminé !'**
  String get lessonWorldComplete;

  /// No description provided for @lessonWorldCompleteUpper.
  ///
  /// In fr, this message translates to:
  /// **'MONDE TERMINÉ !'**
  String get lessonWorldCompleteUpper;

  /// No description provided for @lessonWorldAllValidated.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les leçons de ce monde sont validées.'**
  String get lessonWorldAllValidated;

  /// No description provided for @lessonResultPerfect.
  ///
  /// In fr, this message translates to:
  /// **'Optime !'**
  String get lessonResultPerfect;

  /// No description provided for @lessonResultPerfectHint.
  ///
  /// In fr, this message translates to:
  /// **'Réussi du premier coup.'**
  String get lessonResultPerfectHint;

  /// No description provided for @lessonResultGood.
  ///
  /// In fr, this message translates to:
  /// **'Bene !'**
  String get lessonResultGood;

  /// No description provided for @lessonResultGoodHint.
  ///
  /// In fr, this message translates to:
  /// **'Réussi avec une aide. Refais la leçon plus tard pour décrocher 3 étoiles.'**
  String get lessonResultGoodHint;

  /// No description provided for @lessonResultPassed.
  ///
  /// In fr, this message translates to:
  /// **'Leçon réussie'**
  String get lessonResultPassed;

  /// No description provided for @lessonResultPassedHint.
  ///
  /// In fr, this message translates to:
  /// **'Il a fallu plusieurs essais : relis la leçon et retente-la bientôt.'**
  String get lessonResultPassedHint;

  /// No description provided for @lessonNewCard.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle carte au Panthéon : {name}'**
  String lessonNewCard(String name);

  /// No description provided for @lessonNewRecord.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau record : {stars} ★'**
  String lessonNewRecord(int stars);

  /// No description provided for @lessonAlreadyDoneRecord.
  ///
  /// In fr, this message translates to:
  /// **'Leçon déjà validée (record : {stars} ★)'**
  String lessonAlreadyDoneRecord(int stars);

  /// No description provided for @lessonAlreadyDoneNoReward.
  ///
  /// In fr, this message translates to:
  /// **'Leçon déjà validée : pas de nouveaux sesterces'**
  String get lessonAlreadyDoneNoReward;

  /// No description provided for @lessonCursusProgress.
  ///
  /// In fr, this message translates to:
  /// **'Progression du Cursus'**
  String get lessonCursusProgress;

  /// No description provided for @lessonCursusCount.
  ///
  /// In fr, this message translates to:
  /// **'{done} / {total} leçons'**
  String lessonCursusCount(int done, int total);

  /// No description provided for @lessonContinue.
  ///
  /// In fr, this message translates to:
  /// **'CONTINUER ▶'**
  String get lessonContinue;

  /// No description provided for @lessonTypeQuiz.
  ///
  /// In fr, this message translates to:
  /// **'QCM Grammaire & Vocabulaire'**
  String get lessonTypeQuiz;

  /// No description provided for @lessonTypePuzzle.
  ///
  /// In fr, this message translates to:
  /// **'Syntaxe & Ordre des Mots'**
  String get lessonTypePuzzle;

  /// No description provided for @lessonTypeCloze.
  ///
  /// In fr, this message translates to:
  /// **'Déclinaisons & Cas Latins'**
  String get lessonTypeCloze;

  /// No description provided for @lessonTypeArena.
  ///
  /// In fr, this message translates to:
  /// **'Épreuve d\'Arène / Combat'**
  String get lessonTypeArena;

  /// No description provided for @lessonTypeDecoder.
  ///
  /// In fr, this message translates to:
  /// **'Épigraphie & Décodage'**
  String get lessonTypeDecoder;

  /// No description provided for @lessonTypeDefault.
  ///
  /// In fr, this message translates to:
  /// **'Leçon & Exercice'**
  String get lessonTypeDefault;

  /// No description provided for @lupulusGreetingGladiator.
  ///
  /// In fr, this message translates to:
  /// **'« Salve pugnator ! Dans l\'arène, la précision du mot frappe aussi fort que le glaive ! »'**
  String get lupulusGreetingGladiator;

  /// No description provided for @lupulusGreetingLegion.
  ///
  /// In fr, this message translates to:
  /// **'« Salve legionarie ! La discipline grammaticale est le bouclier des légions ! »'**
  String get lupulusGreetingLegion;

  /// No description provided for @lupulusGreetingMyth.
  ///
  /// In fr, this message translates to:
  /// **'« Salve discipule ! Que Minerve et Apollon inspirent ta mémoire mythologique ! »'**
  String get lupulusGreetingMyth;

  /// No description provided for @lupulusGreetingDefault.
  ///
  /// In fr, this message translates to:
  /// **'« Salve discipule ! Observe bien les racines latines, elles éclairent la langue française ! »'**
  String get lupulusGreetingDefault;

  /// No description provided for @lessonLabel.
  ///
  /// In fr, this message translates to:
  /// **'LEÇON'**
  String get lessonLabel;

  /// No description provided for @lessonLatinPronunciation.
  ///
  /// In fr, this message translates to:
  /// **'Prononciation latine'**
  String get lessonLatinPronunciation;

  /// No description provided for @lessonToExercise.
  ///
  /// In fr, this message translates to:
  /// **'À L\'EXERCICE ↓'**
  String get lessonToExercise;

  /// No description provided for @lessonValidatedStars.
  ///
  /// In fr, this message translates to:
  /// **'✓ Validée {filled}{empty}'**
  String lessonValidatedStars(String filled, String empty);

  /// No description provided for @lessonUpToReward.
  ///
  /// In fr, this message translates to:
  /// **'Jusqu\'à +{amount} HS'**
  String lessonUpToReward(int amount);

  /// No description provided for @lessonPronunciation.
  ///
  /// In fr, this message translates to:
  /// **'Prononciation'**
  String get lessonPronunciation;

  /// No description provided for @lessonReviewCourse.
  ///
  /// In fr, this message translates to:
  /// **'Revoir le cours'**
  String get lessonReviewCourse;

  /// No description provided for @lessonBackToExercise.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'exercice'**
  String get lessonBackToExercise;

  /// No description provided for @lessonProgressGrammar.
  ///
  /// In fr, this message translates to:
  /// **'EXERCICE 2 / {total} • GRAMMAIRE'**
  String lessonProgressGrammar(int total);

  /// No description provided for @lessonProgressVocab.
  ///
  /// In fr, this message translates to:
  /// **'EXERCICE {current} / {total} • VOCABULAIRE'**
  String lessonProgressVocab(int current, int total);

  /// No description provided for @lessonProgressFirst.
  ///
  /// In fr, this message translates to:
  /// **'EXERCICE 1 / {total}'**
  String lessonProgressFirst(int total);

  /// No description provided for @lessonChooseAnswer.
  ///
  /// In fr, this message translates to:
  /// **'Choisis la bonne réponse :'**
  String get lessonChooseAnswer;

  /// No description provided for @lessonHintButton.
  ///
  /// In fr, this message translates to:
  /// **'Indice : barrer une mauvaise réponse (−1 ★)'**
  String get lessonHintButton;

  /// No description provided for @lessonSelectedAnswer.
  ///
  /// In fr, this message translates to:
  /// **'Réponse sélectionnée'**
  String get lessonSelectedAnswer;

  /// No description provided for @lessonAdviceReread.
  ///
  /// In fr, this message translates to:
  /// **'Relis le passage de la leçon juste au-dessus : la réponse s\'y trouve.'**
  String get lessonAdviceReread;

  /// No description provided for @lessonAdviceCases.
  ///
  /// In fr, this message translates to:
  /// **'Vérifie qui fait l\'action (nominatif) et qui la subit (accusatif), puis réessaie.'**
  String get lessonAdviceCases;

  /// No description provided for @lessonAdviceNumber.
  ///
  /// In fr, this message translates to:
  /// **'Observe la terminaison du mot : c\'est elle qui indique le singulier ou le pluriel.'**
  String get lessonAdviceNumber;

  /// No description provided for @lessonNotQuite.
  ///
  /// In fr, this message translates to:
  /// **'Pas tout à fait…'**
  String get lessonNotQuite;

  /// No description provided for @lessonYouChose.
  ///
  /// In fr, this message translates to:
  /// **'Tu as choisi : '**
  String get lessonYouChose;

  /// No description provided for @lessonChosenQuote.
  ///
  /// In fr, this message translates to:
  /// **'« {text} »'**
  String lessonChosenQuote(String text);

  /// No description provided for @lessonRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get lessonRetry;

  /// No description provided for @lessonRetryWithHint.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer avec un indice'**
  String get lessonRetryWithHint;

  /// No description provided for @lessonRewardFloat.
  ///
  /// In fr, this message translates to:
  /// **'+{amount} HS'**
  String lessonRewardFloat(int amount);

  /// No description provided for @homeClass5.
  ///
  /// In fr, this message translates to:
  /// **'5ème • Origines'**
  String get homeClass5;

  /// No description provided for @homeClass4.
  ///
  /// In fr, this message translates to:
  /// **'4ème • République'**
  String get homeClass4;

  /// No description provided for @homeClass3.
  ///
  /// In fr, this message translates to:
  /// **'3ème • Empire'**
  String get homeClass3;

  /// No description provided for @homeBarLibrary.
  ///
  /// In fr, this message translates to:
  /// **'BIBLIOTHECA'**
  String get homeBarLibrary;

  /// No description provided for @homeBarGames.
  ///
  /// In fr, this message translates to:
  /// **'LUDI'**
  String get homeBarGames;

  /// No description provided for @homeBarTitle.
  ///
  /// In fr, this message translates to:
  /// **'LUDUS LATINUS'**
  String get homeBarTitle;

  /// No description provided for @homeSettingsTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get homeSettingsTooltip;

  /// No description provided for @homeTabCursus.
  ///
  /// In fr, this message translates to:
  /// **'Cursus'**
  String get homeTabCursus;

  /// No description provided for @homeTabLibrary.
  ///
  /// In fr, this message translates to:
  /// **'Bibliotheca'**
  String get homeTabLibrary;

  /// No description provided for @homeTabGames.
  ///
  /// In fr, this message translates to:
  /// **'Ludi'**
  String get homeTabGames;

  /// No description provided for @homeLessonsConquered.
  ///
  /// In fr, this message translates to:
  /// **'{done} / {total} leçons conquises'**
  String homeLessonsConquered(int done, int total);

  /// No description provided for @homeLupulusSalve.
  ///
  /// In fr, this message translates to:
  /// **'« Salve {name} ! Rome ne s’est pas faite en un jour. Poursuis ta marche triomphale ! »'**
  String homeLupulusSalve(String name);

  /// No description provided for @homeLupulusSalute.
  ///
  /// In fr, this message translates to:
  /// **'🐺 Lupulus t\'adresse son salut légionnaire : \"Per aspera ad astra !\"'**
  String get homeLupulusSalute;

  /// No description provided for @homeViaAppia.
  ///
  /// In fr, this message translates to:
  /// **'LA VIA APPIA'**
  String get homeViaAppia;

  /// No description provided for @homeViaAppiaSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'26 mondes du collège, de la 5e à la 3e'**
  String get homeViaAppiaSubtitle;

  /// No description provided for @homeAdvanceOnRoad.
  ///
  /// In fr, this message translates to:
  /// **'▶ AVANCER SUR LA ROUTE'**
  String get homeAdvanceOnRoad;

  /// No description provided for @homeShopTitle.
  ///
  /// In fr, this message translates to:
  /// **'Taberna Romana : la boutique'**
  String get homeShopTitle;

  /// No description provided for @homeShopHint.
  ///
  /// In fr, this message translates to:
  /// **'Dépense tes {amount} sesterces : toges, couronnes, compagnons…'**
  String homeShopHint(int amount);

  /// No description provided for @homeQuestDone.
  ///
  /// In fr, this message translates to:
  /// **'Défi accompli ! Reviens demain pour une nouvelle quête.'**
  String get homeQuestDone;

  /// No description provided for @homeQuestPlay.
  ///
  /// In fr, this message translates to:
  /// **'JOUER · +{amount} HS'**
  String homeQuestPlay(int amount);

  /// No description provided for @homeLessonTypeArena.
  ///
  /// In fr, this message translates to:
  /// **'Épreuve d\'Arène'**
  String get homeLessonTypeArena;

  /// No description provided for @homeOfficialLessons.
  ///
  /// In fr, this message translates to:
  /// **'LEÇONS OFFICIELLES • {className}'**
  String homeOfficialLessons(String className);

  /// No description provided for @homeCurriculum.
  ///
  /// In fr, this message translates to:
  /// **'Programme du collège : grammaire, textes et exercices'**
  String get homeCurriculum;

  /// No description provided for @homeLessonsDone.
  ///
  /// In fr, this message translates to:
  /// **'{done} / {total} leçons terminées'**
  String homeLessonsDone(int done, int total);

  /// No description provided for @homeValidated.
  ///
  /// In fr, this message translates to:
  /// **'✓ VALIDÉE {stars}'**
  String homeValidated(String stars);

  /// No description provided for @homeNextLesson.
  ///
  /// In fr, this message translates to:
  /// **'▶ LEÇON SUIVANTE'**
  String get homeNextLesson;

  /// No description provided for @homeInteractiveExercise.
  ///
  /// In fr, this message translates to:
  /// **'Exercice interactif du collège.'**
  String get homeInteractiveExercise;

  /// No description provided for @homeReviseLesson.
  ///
  /// In fr, this message translates to:
  /// **'RÉVISER LA LEÇON'**
  String get homeReviseLesson;

  /// No description provided for @homeStartLesson.
  ///
  /// In fr, this message translates to:
  /// **'COMMENCER LA LEÇON ▶'**
  String get homeStartLesson;

  /// No description provided for @homeViaAppiaName.
  ///
  /// In fr, this message translates to:
  /// **'Via Appia'**
  String get homeViaAppiaName;

  /// No description provided for @homeAllLessonsOfLevel.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les leçons de ce niveau :'**
  String get homeAllLessonsOfLevel;

  /// No description provided for @homeLessonCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} leçons'**
  String homeLessonCount(int count);

  /// No description provided for @homeHere.
  ///
  /// In fr, this message translates to:
  /// **'📍 ICI'**
  String get homeHere;

  /// No description provided for @homeDone.
  ///
  /// In fr, this message translates to:
  /// **'Validée'**
  String get homeDone;

  /// No description provided for @homeExplore.
  ///
  /// In fr, this message translates to:
  /// **'Explorer'**
  String get homeExplore;

  /// No description provided for @cursusTitle.
  ///
  /// In fr, this message translates to:
  /// **'CURSUS HONORUM'**
  String get cursusTitle;

  /// No description provided for @cursusSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Carrière des Honneurs Romains'**
  String get cursusSubtitle;

  /// No description provided for @cursusCurrentRank.
  ///
  /// In fr, this message translates to:
  /// **'TON RANG ACTUEL : {rank}'**
  String cursusCurrentRank(String rank);

  /// No description provided for @cursusNextRank.
  ///
  /// In fr, this message translates to:
  /// **'Prochain rang : {rank} ({lessons} leçons, {monuments} édifice(s), {sesterces} HS)'**
  String cursusNextRank(String rank, int lessons, int monuments, int sesterces);

  /// No description provided for @cursusTop.
  ///
  /// In fr, this message translates to:
  /// **'👑 Tu as atteint le sommet du Cursus Honorum !'**
  String get cursusTop;

  /// No description provided for @cursusYou.
  ///
  /// In fr, this message translates to:
  /// **'TOI'**
  String get cursusYou;

  /// No description provided for @cursusRequired.
  ///
  /// In fr, this message translates to:
  /// **'Requis : {lessons} leçons • {monuments} édifice(s) • {sesterces} HS'**
  String cursusRequired(int lessons, int monuments, int sesterces);

  /// No description provided for @ludiTitle.
  ///
  /// In fr, this message translates to:
  /// **'LUDI & ARÈNES DE L\'EMPIRE'**
  String get ludiTitle;

  /// No description provided for @ludiSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'« Panem et circenses » • Du pain et des jeux !\nDéfis chronométrés, courses épiques et tavernes antiques.'**
  String get ludiSubtitle;

  /// No description provided for @ludiRecordPoints.
  ///
  /// In fr, this message translates to:
  /// **'Record : {points} pts'**
  String ludiRecordPoints(int points);

  /// No description provided for @ludiCircusSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Course de chars & turbo'**
  String get ludiCircusSubtitle;

  /// No description provided for @ludiCircusTag.
  ///
  /// In fr, this message translates to:
  /// **'COURSE'**
  String get ludiCircusTag;

  /// No description provided for @ludiRecordStreak.
  ///
  /// In fr, this message translates to:
  /// **'Record : {count} d\'affilée'**
  String ludiRecordStreak(int count);

  /// No description provided for @ludiDuelSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Arène tactique des champions'**
  String get ludiDuelSubtitle;

  /// No description provided for @ludiDuelTag.
  ///
  /// In fr, this message translates to:
  /// **'ARÈNE'**
  String get ludiDuelTag;

  /// No description provided for @ludiTavernSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Taverne & dés romains'**
  String get ludiTavernSubtitle;

  /// No description provided for @ludiTavernTag.
  ///
  /// In fr, this message translates to:
  /// **'DÉS'**
  String get ludiTavernTag;

  /// No description provided for @ludiCaesarSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Cryptographie militaire'**
  String get ludiCaesarSubtitle;

  /// No description provided for @ludiCaesarTag.
  ///
  /// In fr, this message translates to:
  /// **'ÉNIGME'**
  String get ludiCaesarTag;

  /// No description provided for @ludiMarketSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Chiffres romains & étal'**
  String get ludiMarketSubtitle;

  /// No description provided for @ludiMarketTag.
  ///
  /// In fr, this message translates to:
  /// **'COMMERCE'**
  String get ludiMarketTag;

  /// No description provided for @ludiPantheonSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Une carte par monde terminé'**
  String get ludiPantheonSubtitle;

  /// No description provided for @ludiPantheonTag.
  ///
  /// In fr, this message translates to:
  /// **'CARTES'**
  String get ludiPantheonTag;

  /// No description provided for @ludiDidYouKnow.
  ///
  /// In fr, this message translates to:
  /// **'Le Saviez-vous ?'**
  String get ludiDidYouKnow;

  /// No description provided for @ludiDidYouKnowBody.
  ///
  /// In fr, this message translates to:
  /// **'Chaque nouvelle ville conquise sur la Via Appia déverrouille de nouveaux quartiers de loisirs. Avance dans tes leçons pour tout débloquer ! ({count} leçons terminées).'**
  String ludiDidYouKnowBody(int count);

  /// No description provided for @libraryTitle.
  ///
  /// In fr, this message translates to:
  /// **'BIBLIOTHECA ROMANA'**
  String get libraryTitle;

  /// No description provided for @librarySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'« Littera scripta manet » • Les écrits restent.\nOutils de référence, mémoire espacée et trésors épigraphiques.'**
  String get librarySubtitle;

  /// No description provided for @libraryMemoriaRecord.
  ///
  /// In fr, this message translates to:
  /// **'{count} mot(s) ancré(s) · record {record}'**
  String libraryMemoriaRecord(int count, int record);

  /// No description provided for @libraryMemoriaCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} mot(s) ancré(s) en mémoire'**
  String libraryMemoriaCount(int count);

  /// No description provided for @libraryMemoriaTag.
  ///
  /// In fr, this message translates to:
  /// **'RÉVISION SRS'**
  String get libraryMemoriaTag;

  /// No description provided for @libraryThesaurusSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Lexique thématique & déclinaisons'**
  String get libraryThesaurusSubtitle;

  /// No description provided for @libraryThesaurusTag.
  ///
  /// In fr, this message translates to:
  /// **'DICTIONNAIRE'**
  String get libraryThesaurusTag;

  /// No description provided for @libraryForumCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} / 6 édifice(s) restauré(s)'**
  String libraryForumCount(int count);

  /// No description provided for @libraryForumTag.
  ///
  /// In fr, this message translates to:
  /// **'PATRIMOINE'**
  String get libraryForumTag;

  /// No description provided for @libraryEpigraphyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Épigraphie'**
  String get libraryEpigraphyTitle;

  /// No description provided for @libraryEpigraphyCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} inscription(s) décodée(s)'**
  String libraryEpigraphyCount(int count);

  /// No description provided for @libraryEpigraphyTag.
  ///
  /// In fr, this message translates to:
  /// **'STÈLES'**
  String get libraryEpigraphyTag;

  /// No description provided for @libraryExportTitle.
  ///
  /// In fr, this message translates to:
  /// **'TABULAE MEMORIALES (FICHES A4)'**
  String get libraryExportTitle;

  /// No description provided for @libraryExportBody.
  ///
  /// In fr, this message translates to:
  /// **'Exporte la table des 5 déclinaisons et tes flashcards au format papier A4 pour réviser hors-écran.'**
  String get libraryExportBody;

  /// No description provided for @libraryTipTitle.
  ///
  /// In fr, this message translates to:
  /// **'Conseil Didactique de Lupulus'**
  String get libraryTipTitle;

  /// No description provided for @libraryTipBody.
  ///
  /// In fr, this message translates to:
  /// **'Réviser 5 minutes par jour avec Memoria Velox est 3 fois plus efficace qu\'une heure le week-end. Active la répétition espacée !'**
  String get libraryTipBody;

  /// No description provided for @exportCopied.
  ///
  /// In fr, this message translates to:
  /// **'Fiche A4 copiée au format HTML ! Ouvre ton navigateur et imprime (Ctrl+P / Imprimer en PDF).'**
  String get exportCopied;

  /// No description provided for @exportTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tabulae Memoriales'**
  String get exportTitle;

  /// No description provided for @exportSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Fiches de Révision & Flashcards A4 Imprimables'**
  String get exportSubtitle;

  /// No description provided for @exportTabDeclensions.
  ///
  /// In fr, this message translates to:
  /// **'📖 Déclinaisons'**
  String get exportTabDeclensions;

  /// No description provided for @exportTabFlashcards.
  ///
  /// In fr, this message translates to:
  /// **'✂️ Flashcards'**
  String get exportTabFlashcards;

  /// No description provided for @exportTabRecords.
  ///
  /// In fr, this message translates to:
  /// **'📜 Palmarès'**
  String get exportTabRecords;

  /// No description provided for @exportCopyButton.
  ///
  /// In fr, this message translates to:
  /// **'COPIER LA FICHE A4 (HTML / PDF)'**
  String get exportCopyButton;

  /// No description provided for @exportColumnCase.
  ///
  /// In fr, this message translates to:
  /// **'Cas'**
  String get exportColumnCase;

  /// No description provided for @exportColumnSingular.
  ///
  /// In fr, this message translates to:
  /// **'Singulier'**
  String get exportColumnSingular;

  /// No description provided for @exportColumnPlural.
  ///
  /// In fr, this message translates to:
  /// **'Pluriel'**
  String get exportColumnPlural;

  /// No description provided for @exportFlashcardsIntro.
  ///
  /// In fr, this message translates to:
  /// **'Planche de révision découpable prête à l\'impression :'**
  String get exportFlashcardsIntro;

  /// No description provided for @exportRankTitle.
  ///
  /// In fr, this message translates to:
  /// **'Titre républicain : {title}'**
  String exportRankTitle(String title);

  /// No description provided for @exportTreasure.
  ///
  /// In fr, this message translates to:
  /// **'🪙 Trésor accumulé'**
  String get exportTreasure;

  /// No description provided for @exportMonuments.
  ///
  /// In fr, this message translates to:
  /// **'🏛️ Monuments restaurés'**
  String get exportMonuments;

  /// No description provided for @exportMonumentsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} / 6 édifices'**
  String exportMonumentsCount(int count);

  /// No description provided for @exportEpigraphs.
  ///
  /// In fr, this message translates to:
  /// **'🔍 Stèles lapidaires décodées'**
  String get exportEpigraphs;

  /// No description provided for @exportEpigraphsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} inscriptions'**
  String exportEpigraphsCount(int count);

  /// No description provided for @exportCards.
  ///
  /// In fr, this message translates to:
  /// **'🃏 Cartes ancrées en mémoire SRS'**
  String get exportCards;

  /// No description provided for @exportCardsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} fiches'**
  String exportCardsCount(int count);

  /// No description provided for @exportStreak.
  ///
  /// In fr, this message translates to:
  /// **'🔥 Série d\'assiduité quotidienne'**
  String get exportStreak;

  /// No description provided for @exportStreakCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} jour(s) consécutif(s)'**
  String exportStreakCount(int count);

  /// No description provided for @lupulusAdviceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Lupulus te conseille'**
  String get lupulusAdviceTitle;

  /// No description provided for @diplomaStatLessons.
  ///
  /// In fr, this message translates to:
  /// **'📖 Leçons'**
  String get diplomaStatLessons;

  /// No description provided for @diplomaStatForum.
  ///
  /// In fr, this message translates to:
  /// **'🏛️ Forum'**
  String get diplomaStatForum;

  /// No description provided for @diplomaStatTreasure.
  ///
  /// In fr, this message translates to:
  /// **'🪙 Trésor'**
  String get diplomaStatTreasure;

  /// No description provided for @diplomaStatStreak.
  ///
  /// In fr, this message translates to:
  /// **'🔥 Ferveur'**
  String get diplomaStatStreak;

  /// No description provided for @diplomaCopy.
  ///
  /// In fr, this message translates to:
  /// **'Copier l\'Eloge'**
  String get diplomaCopy;

  /// No description provided for @diplomaCopiedText.
  ///
  /// In fr, this message translates to:
  /// **'🏛️ DIPLÔME DU SÉNAT ROMAIN (SPQR)\nProclamé pour : {name}\nRang du Cursus Honorum : {rank}\nAccomplissements : {lessons} leçons maîtrisées, {monuments} monuments restaurés au Forum.\n{date}'**
  String diplomaCopiedText(
      String name, String rank, int lessons, int monuments, String date);

  /// No description provided for @diplomaCopied.
  ///
  /// In fr, this message translates to:
  /// **'📜 Éloge impérial copié dans le presse-papier !'**
  String get diplomaCopied;

  /// No description provided for @diplomaRecognition.
  ///
  /// In fr, this message translates to:
  /// **'Reconnaissance'**
  String get diplomaRecognition;

  /// No description provided for @audioTab.
  ///
  /// In fr, this message translates to:
  /// **'SON'**
  String get audioTab;

  /// No description provided for @audioTitle.
  ///
  /// In fr, this message translates to:
  /// **'HARMONIA ANTIQUA'**
  String get audioTitle;

  /// No description provided for @audioSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Sons & Résonances de l\'Empire'**
  String get audioSubtitle;

  /// No description provided for @audioSoundsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sonorités de Rome'**
  String get audioSoundsTitle;

  /// No description provided for @audioMuted.
  ///
  /// In fr, this message translates to:
  /// **'Sourdine activée (silence du temple)'**
  String get audioMuted;

  /// No description provided for @audioSoundsOn.
  ///
  /// In fr, this message translates to:
  /// **'Bruitages authentiques actifs'**
  String get audioSoundsOn;

  /// No description provided for @audioMasterVolume.
  ///
  /// In fr, this message translates to:
  /// **'Volume Maître'**
  String get audioMasterVolume;

  /// No description provided for @audioMusic.
  ///
  /// In fr, this message translates to:
  /// **'Musique'**
  String get audioMusic;

  /// No description provided for @audioMusicOn.
  ///
  /// In fr, this message translates to:
  /// **'Ambiance de lyre et de flûte'**
  String get audioMusicOn;

  /// No description provided for @audioMusicOff.
  ///
  /// In fr, this message translates to:
  /// **'Musique coupée'**
  String get audioMusicOff;

  /// No description provided for @audioHaptics.
  ///
  /// In fr, this message translates to:
  /// **'Retours Haptiques'**
  String get audioHaptics;

  /// No description provided for @audioHapticsOn.
  ///
  /// In fr, this message translates to:
  /// **'Vibrations du glaive & des victoires'**
  String get audioHapticsOn;

  /// No description provided for @audioHapticsOff.
  ///
  /// In fr, this message translates to:
  /// **'Vibrations désactivées'**
  String get audioHapticsOff;

  /// No description provided for @audioTestBench.
  ///
  /// In fr, this message translates to:
  /// **'BANC D\'ESSAI ACOUSTIQUE'**
  String get audioTestBench;

  /// No description provided for @audioSfxCoins.
  ///
  /// In fr, this message translates to:
  /// **'Sesterces d\'Or'**
  String get audioSfxCoins;

  /// No description provided for @audioSfxCoinsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Tintement de pièces impériales'**
  String get audioSfxCoinsDesc;

  /// No description provided for @audioSfxDice.
  ///
  /// In fr, this message translates to:
  /// **'Alea & Fritillus'**
  String get audioSfxDice;

  /// No description provided for @audioSfxDiceDesc.
  ///
  /// In fr, this message translates to:
  /// **'Roulement des osselets et dés'**
  String get audioSfxDiceDesc;

  /// No description provided for @audioSfxTriumph.
  ///
  /// In fr, this message translates to:
  /// **'Fanfare de Triomphe'**
  String get audioSfxTriumph;

  /// No description provided for @audioSfxTriumphDesc.
  ///
  /// In fr, this message translates to:
  /// **'Tubae & buccinae de victoire'**
  String get audioSfxTriumphDesc;

  /// No description provided for @audioSfxColosseum.
  ///
  /// In fr, this message translates to:
  /// **'Colosseum'**
  String get audioSfxColosseum;

  /// No description provided for @audioSfxColosseumDesc.
  ///
  /// In fr, this message translates to:
  /// **'Clameur de la plèbe romaine'**
  String get audioSfxColosseumDesc;

  /// No description provided for @audioSfxSword.
  ///
  /// In fr, this message translates to:
  /// **'Glaive & Scutum'**
  String get audioSfxSword;

  /// No description provided for @audioSfxSwordDesc.
  ///
  /// In fr, this message translates to:
  /// **'Choc métallique d\'acier et bronze'**
  String get audioSfxSwordDesc;

  /// No description provided for @audioSfxCaesar.
  ///
  /// In fr, this message translates to:
  /// **'Roue de César'**
  String get audioSfxCaesar;

  /// No description provided for @audioSfxCaesarDesc.
  ///
  /// In fr, this message translates to:
  /// **'Engrenage mécanique chiffré'**
  String get audioSfxCaesarDesc;

  /// No description provided for @audioSfxParchment.
  ///
  /// In fr, this message translates to:
  /// **'Parchemin & Carte'**
  String get audioSfxParchment;

  /// No description provided for @audioSfxParchmentDesc.
  ///
  /// In fr, this message translates to:
  /// **'Froissement velouté du vélin'**
  String get audioSfxParchmentDesc;

  /// No description provided for @questCompleteTitle.
  ///
  /// In fr, this message translates to:
  /// **'DÉFI DU JOUR ACCOMPLI !'**
  String get questCompleteTitle;

  /// No description provided for @questCompleteReward.
  ///
  /// In fr, this message translates to:
  /// **'+{amount} SESTERCES'**
  String questCompleteReward(int amount);

  /// No description provided for @questCollect.
  ///
  /// In fr, this message translates to:
  /// **'RÉCOLTER LE TRÉSOR'**
  String get questCollect;

  /// No description provided for @mapTitle.
  ///
  /// In fr, this message translates to:
  /// **'VIA APPIA'**
  String get mapTitle;

  /// No description provided for @audioTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Harmonia Antiqua (Audio)'**
  String get audioTooltip;

  /// No description provided for @mapEpic.
  ///
  /// In fr, this message translates to:
  /// **'Épopée Romaine : {done} / {total} leçons'**
  String mapEpic(int done, int total);

  /// No description provided for @mapAllCycle.
  ///
  /// In fr, this message translates to:
  /// **'Tout le Cycle 4'**
  String get mapAllCycle;

  /// No description provided for @mapLegendQuiz.
  ///
  /// In fr, this message translates to:
  /// **'Quiz Grammaire'**
  String get mapLegendQuiz;

  /// No description provided for @mapLegendSyntax.
  ///
  /// In fr, this message translates to:
  /// **'Syntaxe'**
  String get mapLegendSyntax;

  /// No description provided for @mapLegendDeclensions.
  ///
  /// In fr, this message translates to:
  /// **'Déclinaisons'**
  String get mapLegendDeclensions;

  /// No description provided for @mapLegendBoss.
  ///
  /// In fr, this message translates to:
  /// **'Boss Arène'**
  String get mapLegendBoss;

  /// No description provided for @mapNoStep.
  ///
  /// In fr, this message translates to:
  /// **'Aucune étape trouvée pour ce cursus.'**
  String get mapNoStep;

  /// No description provided for @mapWorldSalute.
  ///
  /// In fr, this message translates to:
  /// **'« Monde {number} : que ta marche soit triomphale ! »'**
  String mapWorldSalute(String number);

  /// No description provided for @mapLocked.
  ///
  /// In fr, this message translates to:
  /// **'🔒 Complète l\'étape précédente pour débloquer cette borne !'**
  String get mapLocked;

  /// No description provided for @mapToPlay.
  ///
  /// In fr, this message translates to:
  /// **'▶ À JOUER'**
  String get mapToPlay;

  /// No description provided for @mapTypeQuiz.
  ///
  /// In fr, this message translates to:
  /// **'Quiz'**
  String get mapTypeQuiz;

  /// No description provided for @mapTypeEpigraphy.
  ///
  /// In fr, this message translates to:
  /// **'Épigraphie'**
  String get mapTypeEpigraphy;

  /// No description provided for @mapTypeLesson.
  ///
  /// In fr, this message translates to:
  /// **'Leçon'**
  String get mapTypeLesson;

  /// No description provided for @mapWorldBanner.
  ///
  /// In fr, this message translates to:
  /// **'S • P • Q • R  •  MONDE {number}'**
  String mapWorldBanner(String number);

  /// No description provided for @memoriaCorrect.
  ///
  /// In fr, this message translates to:
  /// **'Exact ! Arca {box} : prochaine révision dans {days} j{bonus}'**
  String memoriaCorrect(String box, int days, String bonus);

  /// No description provided for @memoriaGainBonus.
  ///
  /// In fr, this message translates to:
  /// **' (+{gain} HS)'**
  String memoriaGainBonus(int gain);

  /// No description provided for @memoriaWrong.
  ///
  /// In fr, this message translates to:
  /// **'C\'était « {answer} ». Retour en Arca I : tu la reverras bientôt.'**
  String memoriaWrong(String answer);

  /// No description provided for @memoriaTriumph.
  ///
  /// In fr, this message translates to:
  /// **'TRIOMPHE DE LA MÉMOIRE'**
  String get memoriaTriumph;

  /// No description provided for @memoriaFinished.
  ///
  /// In fr, this message translates to:
  /// **'Session de révision achevée avec brio !\nTu as remporté +{earnings} Sesterces (HS) !{streakLine}'**
  String memoriaFinished(int earnings, String streakLine);

  /// No description provided for @memoriaMaxStreakLine.
  ///
  /// In fr, this message translates to:
  /// **'\n🔥 Furor Latinus Max : {streak} d\'affilée !'**
  String memoriaMaxStreakLine(int streak);

  /// No description provided for @memoriaBackToForum.
  ///
  /// In fr, this message translates to:
  /// **'Retour au Forum'**
  String get memoriaBackToForum;

  /// No description provided for @memoriaTitle.
  ///
  /// In fr, this message translates to:
  /// **'MEMORIA VELOX'**
  String get memoriaTitle;

  /// No description provided for @memoriaEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Ta Memoria est encore vide.\n\nTermine une leçon de la Via Appia : ses mots viendront s\'y réviser.'**
  String get memoriaEmpty;

  /// No description provided for @memoriaEmptyLevel.
  ///
  /// In fr, this message translates to:
  /// **'Aucun mot de {level} pour l\'instant : termine une leçon de ce niveau.'**
  String memoriaEmptyLevel(String level);

  /// No description provided for @memoriaEarnings.
  ///
  /// In fr, this message translates to:
  /// **'+{amount} HS'**
  String memoriaEarnings(int amount);

  /// No description provided for @memoriaFurorMax.
  ///
  /// In fr, this message translates to:
  /// **'FUROR LATINUS MAXIMUS !'**
  String get memoriaFurorMax;

  /// No description provided for @memoriaFuror.
  ///
  /// In fr, this message translates to:
  /// **'FUROR LATINUS !'**
  String get memoriaFuror;

  /// No description provided for @memoriaStreakParen.
  ///
  /// In fr, this message translates to:
  /// **'({streak} d\'affilée)'**
  String memoriaStreakParen(int streak);

  /// No description provided for @memoriaCardCounter.
  ///
  /// In fr, this message translates to:
  /// **'Carte {index} / {total}'**
  String memoriaCardCounter(int index, int total);

  /// No description provided for @memoriaDue.
  ///
  /// In fr, this message translates to:
  /// **'{count} à réviser'**
  String memoriaDue(int count);

  /// No description provided for @memoriaCheer1.
  ///
  /// In fr, this message translates to:
  /// **'« Incredibile ! Le feu de Rome brûle en toi ! »'**
  String get memoriaCheer1;

  /// No description provided for @memoriaCheer2.
  ///
  /// In fr, this message translates to:
  /// **'« Macte animo ! Continue sur cette belle lancée ! »'**
  String get memoriaCheer2;

  /// No description provided for @memoriaCheer3.
  ///
  /// In fr, this message translates to:
  /// **'« Repetitio est mater studiorum ! »'**
  String get memoriaCheer3;

  /// No description provided for @memoriaNextCard.
  ///
  /// In fr, this message translates to:
  /// **'CARTE SUIVANTE'**
  String get memoriaNextCard;

  /// No description provided for @memoriaFinish.
  ///
  /// In fr, this message translates to:
  /// **'TERMINER'**
  String get memoriaFinish;

  /// No description provided for @memoriaPronunciation.
  ///
  /// In fr, this message translates to:
  /// **'Prononciation & API'**
  String get memoriaPronunciation;

  /// No description provided for @memoriaChooseTranslation.
  ///
  /// In fr, this message translates to:
  /// **'Choisis sa traduction ci-dessous'**
  String get memoriaChooseTranslation;

  /// No description provided for @memoriaFrenchTranslation.
  ///
  /// In fr, this message translates to:
  /// **'TRADUCTION FRANÇAISE'**
  String get memoriaFrenchTranslation;

  /// No description provided for @commonQuoted.
  ///
  /// In fr, this message translates to:
  /// **'« {text} »'**
  String commonQuoted(String text);

  /// No description provided for @memoriaListenSentence.
  ///
  /// In fr, this message translates to:
  /// **'Écouter la phrase'**
  String get memoriaListenSentence;

  /// No description provided for @memoriaTranslationLine.
  ///
  /// In fr, this message translates to:
  /// **'= {text}'**
  String memoriaTranslationLine(String text);

  /// No description provided for @pantheonTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le Panthéon'**
  String get pantheonTitle;

  /// No description provided for @pantheonAlbum.
  ///
  /// In fr, this message translates to:
  /// **'ALBUM DES CARTES'**
  String get pantheonAlbum;

  /// No description provided for @pantheonHint.
  ///
  /// In fr, this message translates to:
  /// **'Termine un monde pour retourner sa carte.'**
  String get pantheonHint;

  /// No description provided for @pantheonCount.
  ///
  /// In fr, this message translates to:
  /// **'{won} / {total} cartes'**
  String pantheonCount(int won, int total);

  /// No description provided for @pantheonWorld.
  ///
  /// In fr, this message translates to:
  /// **'Monde {number}'**
  String pantheonWorld(int number);

  /// No description provided for @pantheonHiddenCard.
  ///
  /// In fr, this message translates to:
  /// **'Carte cachée'**
  String get pantheonHiddenCard;

  /// No description provided for @tavernTitle.
  ///
  /// In fr, this message translates to:
  /// **'TAVERNE DES DÉS'**
  String get tavernTitle;

  /// No description provided for @tavernPurse.
  ///
  /// In fr, this message translates to:
  /// **'🪙 {amount} HS'**
  String tavernPurse(int amount);

  /// No description provided for @tavernGaius.
  ///
  /// In fr, this message translates to:
  /// **'Gaius l\'aubergiste'**
  String get tavernGaius;

  /// No description provided for @tavernGaiusWaits.
  ///
  /// In fr, this message translates to:
  /// **'Gaius attend que tu t\'arrêtes…'**
  String get tavernGaiusWaits;

  /// No description provided for @tavernBust.
  ///
  /// In fr, this message translates to:
  /// **'Tu as dépassé XXI : Gaius n\'a pas besoin de jouer.'**
  String get tavernBust;

  /// No description provided for @tavernYou.
  ///
  /// In fr, this message translates to:
  /// **'Toi'**
  String get tavernYou;

  /// No description provided for @tavernRewardsLeft.
  ///
  /// In fr, this message translates to:
  /// **'Victoires payées aujourd\'hui : encore {left} sur 3 (+{gain} HS chacune)'**
  String tavernRewardsLeft(int left, int gain);

  /// No description provided for @tavernRewardsDone.
  ///
  /// In fr, this message translates to:
  /// **'Tes 3 victoires payées du jour sont faites : tu peux jouer pour la gloire.'**
  String get tavernRewardsDone;

  /// No description provided for @tavernRulesTitle.
  ///
  /// In fr, this message translates to:
  /// **'🎲 AD XXI : approche-toi de 21 sans le dépasser'**
  String get tavernRulesTitle;

  /// No description provided for @tavernRule1.
  ///
  /// In fr, this message translates to:
  /// **'Ajoute des dés un par un. Ton total s\'écrit en chiffres romains.'**
  String get tavernRule1;

  /// No description provided for @tavernRule2.
  ///
  /// In fr, this message translates to:
  /// **'Arrête-toi quand tu veux. Au-dessus de XXI, tu as perdu.'**
  String get tavernRule2;

  /// No description provided for @tavernRule3.
  ///
  /// In fr, this message translates to:
  /// **'Gaius joue ensuite : il relance tant qu\'il a moins de XVII. Le plus près de XXI gagne ; à égalité, personne ne gagne.'**
  String get tavernRule3;

  /// No description provided for @tavernHelp.
  ///
  /// In fr, this message translates to:
  /// **'Aide : I = 1 · V = 5 · X = 10 · IV = 4 · IX = 9 · XXI = 21'**
  String get tavernHelp;

  /// No description provided for @tavernTotal.
  ///
  /// In fr, this message translates to:
  /// **'Total : {total}'**
  String tavernTotal(String total);

  /// No description provided for @tavernRollAgain.
  ///
  /// In fr, this message translates to:
  /// **'🎲 Encore un dé'**
  String get tavernRollAgain;

  /// No description provided for @tavernStop.
  ///
  /// In fr, this message translates to:
  /// **'✋ Je m\'arrête'**
  String get tavernStop;

  /// No description provided for @tavernGaiusRolls.
  ///
  /// In fr, this message translates to:
  /// **'Gaius lance ses dés…'**
  String get tavernGaiusRolls;

  /// No description provided for @tavernYouWin.
  ///
  /// In fr, this message translates to:
  /// **'🏆 Tu bats Gaius !'**
  String get tavernYouWin;

  /// No description provided for @tavernGaiusBust.
  ///
  /// In fr, this message translates to:
  /// **'Gaius a dépassé XXI avec {roman} ({value}).'**
  String tavernGaiusBust(String roman, int value);

  /// No description provided for @tavernYouBeat.
  ///
  /// In fr, this message translates to:
  /// **'Ton {yourRoman} ({yourValue}) bat son {hisRoman} ({hisValue}).'**
  String tavernYouBeat(
      String yourRoman, int yourValue, String hisRoman, int hisValue);

  /// No description provided for @tavernTooFar.
  ///
  /// In fr, this message translates to:
  /// **'💥 Trop loin !'**
  String get tavernTooFar;

  /// No description provided for @tavernGaiusWins.
  ///
  /// In fr, this message translates to:
  /// **'Gaius l\'emporte'**
  String get tavernGaiusWins;

  /// No description provided for @tavernYouBust.
  ///
  /// In fr, this message translates to:
  /// **'{roman} ({value}) dépasse XXI (21).'**
  String tavernYouBust(String roman, int value);

  /// No description provided for @tavernHeBeats.
  ///
  /// In fr, this message translates to:
  /// **'Son {hisRoman} ({hisValue}) bat ton {yourRoman} ({yourValue}).'**
  String tavernHeBeats(
      String hisRoman, int hisValue, String yourRoman, int yourValue);

  /// No description provided for @tavernTie.
  ///
  /// In fr, this message translates to:
  /// **'⚖️ Égalité'**
  String get tavernTie;

  /// No description provided for @tavernTieBody.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez tous les deux {roman} ({value}).'**
  String tavernTieBody(String roman, int value);

  /// No description provided for @tavernWinBonus.
  ///
  /// In fr, this message translates to:
  /// **'+{amount} HS pour la victoire'**
  String tavernWinBonus(int amount);

  /// No description provided for @tavernQuestBonus.
  ///
  /// In fr, this message translates to:
  /// **'+{amount} HS pour le défi du jour'**
  String tavernQuestBonus(int amount);

  /// No description provided for @tavernNewRound.
  ///
  /// In fr, this message translates to:
  /// **'🎲 NOUVELLE MANCHE'**
  String get tavernNewRound;

  /// No description provided for @forumTitle.
  ///
  /// In fr, this message translates to:
  /// **'FORUM IMPERIALE'**
  String get forumTitle;

  /// No description provided for @forumBuildingsCount.
  ///
  /// In fr, this message translates to:
  /// **'{done} / {total} Édifices'**
  String forumBuildingsCount(int done, int total);

  /// No description provided for @forumIntro.
  ///
  /// In fr, this message translates to:
  /// **'Restaure les chefs-d’œuvre de la Ville Éternelle grâce à tes sesterces de quête. Chaque monument restauré débloque un bonus permanent pour ton épopée !'**
  String get forumIntro;

  /// No description provided for @forumEpigraphyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Atelier d\'Épigraphie Lapidaire'**
  String get forumEpigraphyTitle;

  /// No description provided for @forumEpigraphyCount.
  ///
  /// In fr, this message translates to:
  /// **'{done} / {total} Déchiffrées'**
  String forumEpigraphyCount(int done, int total);

  /// No description provided for @forumEpigraphyIntro.
  ///
  /// In fr, this message translates to:
  /// **'Restaure les stèles de travertin et de marbre de Rome. Déchiffre les abréviations impériales au marteau lapidaire pour obtenir la sagesse antique et des sesterces !'**
  String get forumEpigraphyIntro;

  /// No description provided for @forumOpenEpigraphy.
  ///
  /// In fr, this message translates to:
  /// **'OUVRIR LA RESTAURATION DES 6 STÈLES ANTIQUES'**
  String get forumOpenEpigraphy;

  /// No description provided for @forumRestored.
  ///
  /// In fr, this message translates to:
  /// **'{name} restauré avec gloire ! Bonus actif : {bonus}'**
  String forumRestored(String name, String bonus);

  /// No description provided for @forumRestoredTag.
  ///
  /// In fr, this message translates to:
  /// **'RESTAURÉ'**
  String get forumRestoredTag;

  /// No description provided for @forumCost.
  ///
  /// In fr, this message translates to:
  /// **'{amount} HS'**
  String forumCost(int amount);

  /// No description provided for @forumPermanentBonus.
  ///
  /// In fr, this message translates to:
  /// **'Bonus permanent : {bonus}'**
  String forumPermanentBonus(String bonus);

  /// No description provided for @forumEpigraphDecoded.
  ///
  /// In fr, this message translates to:
  /// **'Épigraphe Déchiffrée (Revoir la Pierre)'**
  String get forumEpigraphDecoded;

  /// No description provided for @forumEpigraphDecode.
  ///
  /// In fr, this message translates to:
  /// **'Déchiffrer l\'Épigraphe Gravée (+15 HS)'**
  String get forumEpigraphDecode;

  /// No description provided for @forumRebuild.
  ///
  /// In fr, this message translates to:
  /// **'Reconstruire ce monument'**
  String get forumRebuild;

  /// No description provided for @forumNotEnough.
  ///
  /// In fr, this message translates to:
  /// **'Fonds insuffisants'**
  String get forumNotEnough;

  /// No description provided for @thesaurusTitle.
  ///
  /// In fr, this message translates to:
  /// **'THESAURUS'**
  String get thesaurusTitle;

  /// No description provided for @thesaurusTabDictionary.
  ///
  /// In fr, this message translates to:
  /// **'Dictionnaire'**
  String get thesaurusTabDictionary;

  /// No description provided for @thesaurusTabDeclensions.
  ///
  /// In fr, this message translates to:
  /// **'Déclinaisons'**
  String get thesaurusTabDeclensions;

  /// No description provided for @thesaurusTabConjugations.
  ///
  /// In fr, this message translates to:
  /// **'Conjugaisons'**
  String get thesaurusTabConjugations;

  /// No description provided for @thesaurusTabGlossary.
  ///
  /// In fr, this message translates to:
  /// **'Glossaire'**
  String get thesaurusTabGlossary;

  /// No description provided for @thesaurusSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher en latin ou français...'**
  String get thesaurusSearchHint;

  /// No description provided for @thesaurusTermsFound.
  ///
  /// In fr, this message translates to:
  /// **'{count} terme(s) trouvé(s)'**
  String thesaurusTermsFound(int count);

  /// No description provided for @thesaurusVocabCycle.
  ///
  /// In fr, this message translates to:
  /// **'Vocabulaire Cycle 4'**
  String get thesaurusVocabCycle;

  /// No description provided for @thesaurusNoWord.
  ///
  /// In fr, this message translates to:
  /// **'Aucun mot trouvé pour « {query} »'**
  String thesaurusNoWord(String query);

  /// No description provided for @thesaurusCertifiedPronunciation.
  ///
  /// In fr, this message translates to:
  /// **'Prononciation latine certifiée'**
  String get thesaurusCertifiedPronunciation;

  /// No description provided for @thesaurusSixCases.
  ///
  /// In fr, this message translates to:
  /// **'LES SIX CAS'**
  String get thesaurusSixCases;

  /// No description provided for @pantheonUnlock.
  ///
  /// In fr, this message translates to:
  /// **'Termine le monde {number} pour la débloquer'**
  String pantheonUnlock(int number);

  /// No description provided for @pantheonUnlockNamed.
  ///
  /// In fr, this message translates to:
  /// **'Termine le monde {number} : {title} pour la débloquer'**
  String pantheonUnlockNamed(int number, String title);

  /// No description provided for @memoriaLevelAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get memoriaLevelAll;

  /// No description provided for @memoriaLevel5.
  ///
  /// In fr, this message translates to:
  /// **'5ème'**
  String get memoriaLevel5;

  /// No description provided for @memoriaLevel4.
  ///
  /// In fr, this message translates to:
  /// **'4ème'**
  String get memoriaLevel4;

  /// No description provided for @memoriaLevel3.
  ///
  /// In fr, this message translates to:
  /// **'3ème'**
  String get memoriaLevel3;

  /// No description provided for @thesaurusCatAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get thesaurusCatAll;

  /// No description provided for @thesaurusCatNoun.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get thesaurusCatNoun;

  /// No description provided for @thesaurusCatVerb.
  ///
  /// In fr, this message translates to:
  /// **'Verbe'**
  String get thesaurusCatVerb;

  /// No description provided for @thesaurusCatAdjective.
  ///
  /// In fr, this message translates to:
  /// **'Adjectif'**
  String get thesaurusCatAdjective;

  /// No description provided for @thesaurusCatPronoun.
  ///
  /// In fr, this message translates to:
  /// **'Pronom'**
  String get thesaurusCatPronoun;

  /// No description provided for @thesaurusCatInvariable.
  ///
  /// In fr, this message translates to:
  /// **'Invariable'**
  String get thesaurusCatInvariable;

  /// No description provided for @settingsSectionApp.
  ///
  /// In fr, this message translates to:
  /// **'Application'**
  String get settingsSectionApp;

  /// No description provided for @settingsAbout.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get settingsAbout;

  /// No description provided for @settingsAboutHint.
  ///
  /// In fr, this message translates to:
  /// **'Version et éditeur'**
  String get settingsAboutHint;

  /// No description provided for @aboutTitle.
  ///
  /// In fr, this message translates to:
  /// **'À PROPOS'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In fr, this message translates to:
  /// **'Version {version} ({build})'**
  String aboutVersion(String version, String build);

  /// No description provided for @aboutVersionLoading.
  ///
  /// In fr, this message translates to:
  /// **'Version …'**
  String get aboutVersionLoading;

  /// No description provided for @aboutPublisher.
  ///
  /// In fr, this message translates to:
  /// **'Édité par Icare & Dédale'**
  String get aboutPublisher;

  /// No description provided for @aboutRights.
  ///
  /// In fr, this message translates to:
  /// **'© 2026 Icare & Dédale. Tous droits réservés.'**
  String get aboutRights;

  /// No description provided for @aboutReplayStudio.
  ///
  /// In fr, this message translates to:
  /// **'Revoir l\'animation du studio'**
  String get aboutReplayStudio;

  /// No description provided for @albumTitle.
  ///
  /// In fr, this message translates to:
  /// **'Héros et Créatures'**
  String get albumTitle;

  /// No description provided for @albumHeaderLabel.
  ///
  /// In fr, this message translates to:
  /// **'ALBUM DES SUCCÈS'**
  String get albumHeaderLabel;

  /// No description provided for @albumHeaderHint.
  ///
  /// In fr, this message translates to:
  /// **'Chaque succès te donne une carte.'**
  String get albumHeaderHint;

  /// No description provided for @albumFamilyHeroes.
  ///
  /// In fr, this message translates to:
  /// **'Héros'**
  String get albumFamilyHeroes;

  /// No description provided for @albumFamilyGods.
  ///
  /// In fr, this message translates to:
  /// **'Dieux'**
  String get albumFamilyGods;

  /// No description provided for @albumFamilyCreatures.
  ///
  /// In fr, this message translates to:
  /// **'Créatures'**
  String get albumFamilyCreatures;

  /// No description provided for @albumFamilyMonuments.
  ///
  /// In fr, this message translates to:
  /// **'Monuments'**
  String get albumFamilyMonuments;

  /// No description provided for @albumRarityCommon.
  ///
  /// In fr, this message translates to:
  /// **'Commune'**
  String get albumRarityCommon;

  /// No description provided for @albumRarityRare.
  ///
  /// In fr, this message translates to:
  /// **'Rare'**
  String get albumRarityRare;

  /// No description provided for @albumRarityEpic.
  ///
  /// In fr, this message translates to:
  /// **'Épique'**
  String get albumRarityEpic;

  /// No description provided for @albumRarityLegendary.
  ///
  /// In fr, this message translates to:
  /// **'Légendaire'**
  String get albumRarityLegendary;

  /// No description provided for @albumAttack.
  ///
  /// In fr, this message translates to:
  /// **'Attaque'**
  String get albumAttack;

  /// No description provided for @albumDefense.
  ///
  /// In fr, this message translates to:
  /// **'Défense'**
  String get albumDefense;

  /// No description provided for @albumClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get albumClose;

  /// No description provided for @albumNewCard.
  ///
  /// In fr, this message translates to:
  /// **'NOUVELLE CARTE'**
  String get albumNewCard;

  /// No description provided for @albumOpen.
  ///
  /// In fr, this message translates to:
  /// **'Voir l\'album'**
  String get albumOpen;

  /// No description provided for @albumContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get albumContinue;

  /// No description provided for @albumEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune carte pour l\'instant. Termine le monde 1 pour gagner Romulus.'**
  String get albumEmpty;

  /// No description provided for @ludiAlbumSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Une carte par succès'**
  String get ludiAlbumSubtitle;

  /// No description provided for @ludiAlbumTag.
  ///
  /// In fr, this message translates to:
  /// **'SUCCÈS'**
  String get ludiAlbumTag;

  /// No description provided for @albumCount.
  ///
  /// In fr, this message translates to:
  /// **'{obtenues} / {total} cartes'**
  String albumCount(int obtenues, int total);

  /// No description provided for @albumEarned.
  ///
  /// In fr, this message translates to:
  /// **'+ {sesterces} sesterces gagnés'**
  String albumEarned(int sesterces);

  /// No description provided for @albumNewCards.
  ///
  /// In fr, this message translates to:
  /// **'{nombre} NOUVELLES CARTES'**
  String albumNewCards(int nombre);

  /// No description provided for @albumAchievement.
  ///
  /// In fr, this message translates to:
  /// **'Succès : {texte}'**
  String albumAchievement(String texte);

  /// No description provided for @albumReward.
  ///
  /// In fr, this message translates to:
  /// **'+ {sesterces} sesterces'**
  String albumReward(int sesterces);

  /// No description provided for @reminderTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ludus Latinus'**
  String get reminderTitle;

  /// No description provided for @reminderChannel.
  ///
  /// In fr, this message translates to:
  /// **'Rappel quotidien'**
  String get reminderChannel;

  /// No description provided for @reminderChannelDescription.
  ///
  /// In fr, this message translates to:
  /// **'Un rappel par jour pour ta leçon de latin.'**
  String get reminderChannelDescription;

  /// No description provided for @goalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Objectif du jour'**
  String get goalTitle;

  /// No description provided for @goalDone.
  ///
  /// In fr, this message translates to:
  /// **'Objectif atteint, bravo !'**
  String get goalDone;

  /// No description provided for @goalHint.
  ///
  /// In fr, this message translates to:
  /// **'Une activité = une leçon réussie ou 10 cartes Memoria.'**
  String get goalHint;

  /// No description provided for @goalChoose.
  ///
  /// In fr, this message translates to:
  /// **'Combien d\'activités par jour ?'**
  String get goalChoose;

  /// No description provided for @reminderOfferTitle.
  ///
  /// In fr, this message translates to:
  /// **'Un rappel chaque jour ?'**
  String get reminderOfferTitle;

  /// No description provided for @reminderOfferBody.
  ///
  /// In fr, this message translates to:
  /// **'Veux-tu que je te rappelle ta leçon chaque jour ? Je t\'enverrai un seul message, à 17 h 30. Tu pourras changer l\'heure ou l\'arrêter dans les Réglages.'**
  String get reminderOfferBody;

  /// No description provided for @reminderOfferYes.
  ///
  /// In fr, this message translates to:
  /// **'Oui, rappelle-moi'**
  String get reminderOfferYes;

  /// No description provided for @reminderOfferNo.
  ///
  /// In fr, this message translates to:
  /// **'Plus tard'**
  String get reminderOfferNo;

  /// No description provided for @settingsReminderSection.
  ///
  /// In fr, this message translates to:
  /// **'Rappel et objectif'**
  String get settingsReminderSection;

  /// No description provided for @settingsReminder.
  ///
  /// In fr, this message translates to:
  /// **'Rappel quotidien'**
  String get settingsReminder;

  /// No description provided for @settingsReminderOff.
  ///
  /// In fr, this message translates to:
  /// **'Désactivé'**
  String get settingsReminderOff;

  /// No description provided for @settingsReminderDenied.
  ///
  /// In fr, this message translates to:
  /// **'Android n\'autorise pas les notifications pour Ludus Latinus. Active-les dans les réglages du téléphone.'**
  String get settingsReminderDenied;

  /// No description provided for @settingsGoal.
  ///
  /// In fr, this message translates to:
  /// **'Objectif du jour'**
  String get settingsGoal;

  /// No description provided for @reminderStreak.
  ///
  /// In fr, this message translates to:
  /// **'Ta série de {serie} jours t\'attend, {nom} !'**
  String reminderStreak(int serie, String nom);

  /// No description provided for @reminderGeneric.
  ///
  /// In fr, this message translates to:
  /// **'Lupulus t\'attend pour une leçon de cinq minutes, {nom}.'**
  String reminderGeneric(String nom);

  /// No description provided for @goalProgress.
  ///
  /// In fr, this message translates to:
  /// **'{faites} / {objectif}'**
  String goalProgress(int faites, int objectif);

  /// No description provided for @goalReward.
  ///
  /// In fr, this message translates to:
  /// **'Objectif du jour atteint : + {sesterces} sesterces'**
  String goalReward(int sesterces);

  /// No description provided for @settingsReminderAt.
  ///
  /// In fr, this message translates to:
  /// **'Chaque jour à {heure}'**
  String settingsReminderAt(String heure);

  /// No description provided for @settingsGoalValue.
  ///
  /// In fr, this message translates to:
  /// **'{nombre, plural, =1{1 activité par jour} other{{nombre} activités par jour}}'**
  String settingsGoalValue(int nombre);

  /// No description provided for @bataTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bataille des Légendes'**
  String get bataTitle;

  /// No description provided for @bataSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Tes cartes contre Crassus'**
  String get bataSubtitle;

  /// No description provided for @bataTag.
  ///
  /// In fr, this message translates to:
  /// **'CARTES'**
  String get bataTag;

  /// No description provided for @bataIntro.
  ///
  /// In fr, this message translates to:
  /// **'Crassus le collectionneur, l\'homme le plus riche de Rome, te défie avec ses propres cartes.'**
  String get bataIntro;

  /// No description provided for @bataRules.
  ///
  /// In fr, this message translates to:
  /// **'À chaque manche, pose une carte et réponds à la question. Bonne réponse : tu choisis l\'attaque ou la défense. Mauvaise réponse : Crassus choisit. Le premier à 3 manches gagne.'**
  String get bataRules;

  /// No description provided for @bataChooseHand.
  ///
  /// In fr, this message translates to:
  /// **'Choisis les 5 cartes de ta main'**
  String get bataChooseHand;

  /// No description provided for @bataLoanInfo.
  ///
  /// In fr, this message translates to:
  /// **'Tu n\'as pas encore 5 cartes : Crassus te prête les autres. Gagne des succès pour jouer avec les tiennes.'**
  String get bataLoanInfo;

  /// No description provided for @bataLoan.
  ///
  /// In fr, this message translates to:
  /// **'PRÊT'**
  String get bataLoan;

  /// No description provided for @bataStart.
  ///
  /// In fr, this message translates to:
  /// **'Combattre'**
  String get bataStart;

  /// No description provided for @bataYou.
  ///
  /// In fr, this message translates to:
  /// **'Toi'**
  String get bataYou;

  /// No description provided for @bataCrassus.
  ///
  /// In fr, this message translates to:
  /// **'Crassus'**
  String get bataCrassus;

  /// No description provided for @bataHidden.
  ///
  /// In fr, this message translates to:
  /// **'face cachée'**
  String get bataHidden;

  /// No description provided for @bataPlayCard.
  ///
  /// In fr, this message translates to:
  /// **'Pose une carte de ta main.'**
  String get bataPlayCard;

  /// No description provided for @bataChooseStat.
  ///
  /// In fr, this message translates to:
  /// **'Bonne réponse ! Choisis la caractéristique.'**
  String get bataChooseStat;

  /// No description provided for @bataRoundWon.
  ///
  /// In fr, this message translates to:
  /// **'Manche gagnée !'**
  String get bataRoundWon;

  /// No description provided for @bataRoundLost.
  ///
  /// In fr, this message translates to:
  /// **'Manche perdue.'**
  String get bataRoundLost;

  /// No description provided for @bataRoundTie.
  ///
  /// In fr, this message translates to:
  /// **'Égalité : personne ne marque.'**
  String get bataRoundTie;

  /// No description provided for @bataNext.
  ///
  /// In fr, this message translates to:
  /// **'Manche suivante'**
  String get bataNext;

  /// No description provided for @bataSeeResult.
  ///
  /// In fr, this message translates to:
  /// **'Voir le résultat'**
  String get bataSeeResult;

  /// No description provided for @bataVictory.
  ///
  /// In fr, this message translates to:
  /// **'Victoire ! Crassus s\'incline.'**
  String get bataVictory;

  /// No description provided for @bataDefeat.
  ///
  /// In fr, this message translates to:
  /// **'Crassus l\'emporte cette fois.'**
  String get bataDefeat;

  /// No description provided for @bataDraw.
  ///
  /// In fr, this message translates to:
  /// **'Match nul.'**
  String get bataDraw;

  /// No description provided for @bataNoReward.
  ///
  /// In fr, this message translates to:
  /// **'Pour la gloire : 3 victoires payées par jour.'**
  String get bataNoReward;

  /// No description provided for @bataAgain.
  ///
  /// In fr, this message translates to:
  /// **'Rejouer'**
  String get bataAgain;

  /// No description provided for @bataBack.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get bataBack;

  /// No description provided for @bataHand.
  ///
  /// In fr, this message translates to:
  /// **'Ta main'**
  String get bataHand;

  /// No description provided for @bataChosen.
  ///
  /// In fr, this message translates to:
  /// **'{nombre} / 5 cartes'**
  String bataChosen(int nombre);

  /// No description provided for @bataRound.
  ///
  /// In fr, this message translates to:
  /// **'Manche {manche} · premier à 3'**
  String bataRound(int manche);

  /// No description provided for @bataScore.
  ///
  /// In fr, this message translates to:
  /// **'{points}'**
  String bataScore(int points);

  /// No description provided for @bataQuestionMotto.
  ///
  /// In fr, this message translates to:
  /// **'Que veut dire « {latin} » ?'**
  String bataQuestionMotto(String latin);

  /// No description provided for @bataQuestionWord.
  ///
  /// In fr, this message translates to:
  /// **'Que signifie « {latin} » ?'**
  String bataQuestionWord(String latin);

  /// No description provided for @bataWrong.
  ///
  /// In fr, this message translates to:
  /// **'Mauvaise réponse : la bonne était « {reponse} ». Crassus choisit.'**
  String bataWrong(String reponse);

  /// No description provided for @bataDuel.
  ///
  /// In fr, this message translates to:
  /// **'{stat} : {joueur} contre {crassus}'**
  String bataDuel(String stat, int joueur, int crassus);

  /// No description provided for @bataReward.
  ///
  /// In fr, this message translates to:
  /// **'+ {gain} sesterces'**
  String bataReward(int gain);

  /// No description provided for @bataFinalScore.
  ///
  /// In fr, this message translates to:
  /// **'{joueur, plural, =0{0 manche} =1{1 manche} other{{joueur} manches}} à {crassus}'**
  String bataFinalScore(int joueur, int crassus);

  /// No description provided for @mapProgramme.
  ///
  /// In fr, this message translates to:
  /// **'Au programme'**
  String get mapProgramme;

  /// No description provided for @mapProgrammeTitre.
  ///
  /// In fr, this message translates to:
  /// **'Au programme du monde {numero}'**
  String mapProgrammeTitre(String numero);

  /// No description provided for @programmeLangue.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get programmeLangue;

  /// No description provided for @programmeCulture.
  ///
  /// In fr, this message translates to:
  /// **'Culture'**
  String get programmeCulture;

  /// No description provided for @programmeSource.
  ///
  /// In fr, this message translates to:
  /// **'Programme de latin du collège (BO du 17 mars 2016)'**
  String get programmeSource;

  /// No description provided for @settingsTeachers.
  ///
  /// In fr, this message translates to:
  /// **'Pour les professeurs'**
  String get settingsTeachers;

  /// No description provided for @settingsTeachersHint.
  ///
  /// In fr, this message translates to:
  /// **'Le programme officiel, monde par monde'**
  String get settingsTeachersHint;

  /// No description provided for @teachersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pour les professeurs'**
  String get teachersTitle;

  /// No description provided for @teachersReference.
  ///
  /// In fr, this message translates to:
  /// **'Référence'**
  String get teachersReference;

  /// No description provided for @teachersGaps.
  ///
  /// In fr, this message translates to:
  /// **'Écarts avec le programme'**
  String get teachersGaps;

  /// No description provided for @teachersContact.
  ///
  /// In fr, this message translates to:
  /// **'Contact'**
  String get teachersContact;

  /// No description provided for @clozeCheckWord.
  ///
  /// In fr, this message translates to:
  /// **'VALIDER LE MOT ▶'**
  String get clozeCheckWord;

  /// No description provided for @clozeWrongWord.
  ///
  /// In fr, this message translates to:
  /// **'« Ce n\'est pas tout à fait ce mot. Relis la phrase et observe le rôle du mot ! »'**
  String get clozeWrongWord;

  /// No description provided for @a11yAnswer.
  ///
  /// In fr, this message translates to:
  /// **'Réponse {lettre} : {texte}'**
  String a11yAnswer(String lettre, String texte);

  /// No description provided for @a11yStruck.
  ///
  /// In fr, this message translates to:
  /// **'éliminée'**
  String get a11yStruck;

  /// No description provided for @a11yCorrect.
  ///
  /// In fr, this message translates to:
  /// **'Bonne réponse'**
  String get a11yCorrect;

  /// No description provided for @a11yWrong.
  ///
  /// In fr, this message translates to:
  /// **'Mauvaise réponse'**
  String get a11yWrong;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
