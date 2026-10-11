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
