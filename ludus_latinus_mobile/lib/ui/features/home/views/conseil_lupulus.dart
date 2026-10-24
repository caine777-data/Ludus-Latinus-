import '../../../../data/models/profile.dart';
import '../../../../l10n/app_localizations.dart';

/// Ce que dit Lupulus sur l'accueil, selon le moment de l'élève.
///
/// Avant, une seule phrase (« Poursuis ta marche triomphale ! ») revenait à
/// chaque visite, même au tout premier lancement (audit T58). On choisit
/// maintenant selon ce que l'élève vient de vivre, du plus précis au plus
/// général ; à défaut, une maxime qui change chaque jour.
({String message, String emotion}) conseilLupulus(
  AppLocalizations l10n,
  UserProfile profil, {
  DateTime? maintenant,
}) {
  final nom = profil.nomHeros;
  final jour = maintenant ?? DateTime.now();

  if (profil.completedLessons.isEmpty) {
    return (message: l10n.lupulusBienvenue(nom), emotion: 'joie');
  }
  if (profil.objectifAtteintAujourdhui(jour)) {
    return (message: l10n.lupulusObjectifAtteint(nom), emotion: 'triomphe');
  }
  if (profil.aJoueAujourdhui(jour)) {
    return (message: l10n.lupulusEncoreUnEffort(nom), emotion: 'joie');
  }
  // Série en cours mais rien fait aujourd'hui : c'est le moment de la garder.
  final serie = profil.currentStreak(jour);
  if (serie >= 2) {
    return (message: l10n.lupulusGarderSerie(nom, serie), emotion: 'aide');
  }

  // Une maxime par jour : la même toute la journée, une autre le lendemain.
  final maximes = [
    l10n.lupulusMaxime1(nom),
    l10n.lupulusMaxime2(nom),
    l10n.lupulusMaxime3(nom),
    l10n.lupulusMaxime4(nom),
    l10n.lupulusMaxime5(nom),
  ];
  final jourDeLAnnee = jour.difference(DateTime(jour.year)).inDays;
  return (message: maximes[jourDeLAnnee % maximes.length], emotion: 'reflexion');
}
