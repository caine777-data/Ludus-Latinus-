import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../l10n/app_localizations.dart';

/// Rappel quotidien de l'élève (Android seulement, sans réseau).
///
/// Au lieu d'une notification répétée chaque jour, on programme les 7 prochains
/// rappels à chaque changement : chacun porte alors le bon texte (« Ta série de
/// 5 jours t'attend » le premier jour, un rappel simple ensuite, puisque la
/// série est perdue après un jour manqué), et celui du jour disparaît dès que
/// l'élève a atteint son objectif.
class RappelService {
  static const int _premierId = 100;
  static const int _nombreDeJours = 7;

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _pret = false;

  /// Rappels possibles seulement sur Android, et jamais pendant les tests.
  static bool get disponible =>
      !kIsWeb && Platform.isAndroid && !Platform.environment.containsKey('FLUTTER_TEST');

  Future<void> initialiser() async {
    if (!disponible || _pret) return;
    try {
      tz_data.initializeTimeZones();
      await _plugin.initialize(
        settings: const InitializationSettings(android: AndroidInitializationSettings('ic_stat_ludus')),
      );
      _pret = true;
    } catch (e) {
      debugPrint('[RappelService] Initialisation impossible : $e');
    }
  }

  /// Demande à Android l'autorisation d'afficher des notifications (Android 13+).
  /// Vrai si l'élève l'accorde, ou si la version d'Android ne la demande pas.
  Future<bool> demanderAutorisation() async {
    await initialiser();
    if (!_pret) return false;
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? true;
  }

  /// Reprogramme les rappels des 7 prochains jours.
  /// [minutes] : heure du rappel en minutes depuis minuit ; [serie] : série en
  /// cours ; [joueAujourdhui] : leçon ou révision faite aujourd'hui ;
  /// [faitAujourdhui] : objectif du jour déjà atteint (plus de rappel ce soir).
  Future<void> planifier({
    required bool actif,
    required int minutes,
    required String nom,
    required int serie,
    required bool joueAujourdhui,
    required bool faitAujourdhui,
    DateTime? maintenant,
  }) async {
    await initialiser();
    if (!_pret) return;
    try {
      for (var i = 0; i < _nombreDeJours; i++) {
        await _plugin.cancel(id: _premierId + i);
      }
      if (!actif) return;
      final textes = lookupAppLocalizations(const Locale('fr'));
      for (final r in rappelsAProgrammer(
        minutes: minutes,
        serie: serie,
        joueAujourdhui: joueAujourdhui,
        faitAujourdhui: faitAujourdhui,
        maintenant: maintenant ?? DateTime.now(),
      )) {
        final corps = r.serieEnJeu ? textes.reminderStreak(serie, nom) : textes.reminderGeneric(nom);
        await _plugin.zonedSchedule(
          id: _premierId + r.jour,
          title: textes.reminderTitle,
          body: corps,
          // L'instant exact suffit : le fuseau UTC évite une dépendance de plus
          // pour connaître le fuseau du téléphone.
          scheduledDate: tz.TZDateTime.from(r.quand.toUtc(), tz.UTC),
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              'rappel_quotidien',
              textes.reminderChannel,
              channelDescription: textes.reminderChannelDescription,
              importance: Importance.defaultImportance,
              priority: Priority.defaultPriority,
            ),
          ),
          // Rappel approximatif (à quelques minutes près) : pas besoin de
          // l'autorisation des alarmes exactes, que Google contrôle de près.
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    } catch (e) {
      debugPrint('[RappelService] Programmation impossible : $e');
    }
  }
}

/// Un rappel à programmer : son jour (0 = aujourd'hui), son heure, et si la
/// série est encore en jeu ce jour-là.
class RappelPrevu {
  final int jour;
  final DateTime quand;
  final bool serieEnJeu;
  const RappelPrevu(this.jour, this.quand, this.serieEnJeu);
}

/// Calcule les rappels des 7 prochains jours (logique pure, testable).
/// Une série d'au moins 2 jours n'est en jeu que le premier jour où l'élève peut
/// encore la prolonger : aujourd'hui s'il n'a pas encore joué, demain s'il a
/// déjà joué. Le rappel du soir saute seulement quand l'objectif est atteint.
List<RappelPrevu> rappelsAProgrammer({
  required int minutes,
  required int serie,
  required bool joueAujourdhui,
  required bool faitAujourdhui,
  required DateTime maintenant,
}) {
  final rappels = <RappelPrevu>[];
  final jourEnJeu = joueAujourdhui ? 1 : 0;
  for (var i = 0; i < 7; i++) {
    final jour = DateTime(maintenant.year, maintenant.month, maintenant.day + i, minutes ~/ 60, minutes % 60);
    if (i == 0 && (faitAujourdhui || !jour.isAfter(maintenant))) continue;
    rappels.add(RappelPrevu(i, jour, serie >= 2 && i == jourEnJeu));
  }
  return rappels;
}
