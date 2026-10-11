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

  /// No description provided for @accountSyncDone.
  ///
  /// In fr, this message translates to:
  /// **'⚡ Parchemins synchronisés avec les archives du Tabularium !'**
  String get accountSyncDone;

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

  /// No description provided for @accountTrophiesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Panthéon des Trophées'**
  String get accountTrophiesTitle;

  /// No description provided for @accountTrophiesHint.
  ///
  /// In fr, this message translates to:
  /// **'Touche un piédestal'**
  String get accountTrophiesHint;

  /// No description provided for @accountTrophyFirstStep.
  ///
  /// In fr, this message translates to:
  /// **'Premier Pas'**
  String get accountTrophyFirstStep;

  /// No description provided for @accountTrophyFirstStepCondition.
  ///
  /// In fr, this message translates to:
  /// **'Terminer ta toute première leçon de latin.'**
  String get accountTrophyFirstStepCondition;

  /// No description provided for @accountTrophyCenturion.
  ///
  /// In fr, this message translates to:
  /// **'Centurion'**
  String get accountTrophyCenturion;

  /// No description provided for @accountTrophyCenturionCondition.
  ///
  /// In fr, this message translates to:
  /// **'Valider 5 leçons complètes du Ludus.'**
  String get accountTrophyCenturionCondition;

  /// No description provided for @accountTrophyCharioteer.
  ///
  /// In fr, this message translates to:
  /// **'Aurige'**
  String get accountTrophyCharioteer;

  /// No description provided for @accountTrophyCharioteerCondition.
  ///
  /// In fr, this message translates to:
  /// **'Atteindre une série de 3 jours consécutifs.'**
  String get accountTrophyCharioteerCondition;

  /// No description provided for @accountTrophyBuilder.
  ///
  /// In fr, this message translates to:
  /// **'Bâtisseur'**
  String get accountTrophyBuilder;

  /// No description provided for @accountTrophyBuilderCondition.
  ///
  /// In fr, this message translates to:
  /// **'Restaurer au moins un monument du Forum.'**
  String get accountTrophyBuilderCondition;

  /// No description provided for @accountTesseraTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tessera Hospitalis (Jeton d’Hospitalité)'**
  String get accountTesseraTitle;

  /// No description provided for @accountTesseraDescription.
  ///
  /// In fr, this message translates to:
  /// **'Ce jeton secret permet de transférer immédiatement tous tes progrès vers un smartphone, une tablette ou ton ordinateur en classe.'**
  String get accountTesseraDescription;

  /// No description provided for @accountTesseraCopy.
  ///
  /// In fr, this message translates to:
  /// **'Copier la Tessera'**
  String get accountTesseraCopy;

  /// No description provided for @accountTesseraCopied.
  ///
  /// In fr, this message translates to:
  /// **'Tessera Hospitalis copiée dans le presse-papier !'**
  String get accountTesseraCopied;

  /// No description provided for @accountCloudTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde & Compte Cloud'**
  String get accountCloudTitle;

  /// No description provided for @accountCloudDescription.
  ///
  /// In fr, this message translates to:
  /// **'Associe ton adresse courriel pour sauvegarder ta progression sur les serveurs du Tabularium.'**
  String get accountCloudDescription;

  /// No description provided for @accountEmailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adresse courriel (email)'**
  String get accountEmailLabel;

  /// No description provided for @accountEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'eleve@latin.ac-paris.fr'**
  String get accountEmailHint;

  /// No description provided for @accountSyncing.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisation...'**
  String get accountSyncing;

  /// No description provided for @accountSaveAndSync.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer & Synchroniser'**
  String get accountSaveAndSync;

  /// No description provided for @accountEmailInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez saisir une adresse courriel valide.'**
  String get accountEmailInvalid;

  /// No description provided for @accountLastSync.
  ///
  /// In fr, this message translates to:
  /// **'Dernière synchronisation : {date}'**
  String accountLastSync(String date);

  /// No description provided for @accountSyncDateSeparator.
  ///
  /// In fr, this message translates to:
  /// **' à '**
  String get accountSyncDateSeparator;

  /// No description provided for @accountSyncNever.
  ///
  /// In fr, this message translates to:
  /// **'Jamais'**
  String get accountSyncNever;

  /// No description provided for @accountTrophyUnlocked.
  ///
  /// In fr, this message translates to:
  /// **'Trophée débloqué et exposé au Panthéon !'**
  String get accountTrophyUnlocked;

  /// No description provided for @accountTrophyCondition.
  ///
  /// In fr, this message translates to:
  /// **'Condition : {condition}'**
  String accountTrophyCondition(String condition);

  /// No description provided for @accountTrophyClose.
  ///
  /// In fr, this message translates to:
  /// **'OPTICAS GRACIAS (Fermer)'**
  String get accountTrophyClose;

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
