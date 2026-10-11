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
}
