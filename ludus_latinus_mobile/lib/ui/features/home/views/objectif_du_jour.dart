import 'package:flutter/material.dart';
import '../../../../data/repositories/game_repository.dart';
import '../../../../data/services/rappel_service.dart';
import '../../../../l10n/l10n.dart';
import '../../../core/themes.dart';

/// Carte de l'accueil : activités du jour par rapport à l'objectif choisi.
/// Un toucher permet de changer l'objectif (1 à 3 activités).
class CarteObjectifDuJour extends StatelessWidget {
  final GameRepository repo;
  const CarteObjectifDuJour({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final objectif = repo.profile.objectifJour;
    final faites = repo.activitesDuJour.clamp(0, objectif);
    final atteint = repo.objectifAtteint;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => choisirObjectif(context, repo),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        decoration: BoxDecoration(
          color: atteint ? const Color(0xFFEAF3DE) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: atteint ? const Color(0xFF639922) : RomanColors.marbleBorder, width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(atteint ? Icons.check_circle_rounded : Icons.flag_rounded,
                    size: 20, color: atteint ? const Color(0xFF3B6D11) : RomanColors.imperialPurple),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    atteint ? context.l10n.goalDone : context.l10n.goalTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: atteint ? const Color(0xFF27500A) : RomanColors.charcoal,
                    ),
                  ),
                ),
                Text(context.l10n.goalProgress(faites, objectif),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: RomanColors.imperialPurple)),
                const SizedBox(width: 4),
                const Icon(Icons.tune_rounded, size: 18, color: Colors.black38),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: faites / objectif,
                minHeight: 7,
                backgroundColor: const Color(0xFFEFE6D2),
                color: atteint ? const Color(0xFF639922) : RomanColors.imperialGold,
              ),
            ),
            const SizedBox(height: 6),
            Text(context.l10n.goalHint, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

/// Choix de l'objectif du jour : 1, 2 ou 3 activités.
Future<void> choisirObjectif(BuildContext context, GameRepository repo) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(ctx.l10n.goalChoose,
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(ctx.l10n.goalHint, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 12),
            for (final n in const [1, 2, 3])
              ListTile(
                leading: Icon(
                  n == repo.profile.objectifJour ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: RomanColors.imperialPurple,
                ),
                title: Text(ctx.l10n.settingsGoalValue(n)),
                onTap: () {
                  repo.changerObjectif(n);
                  Navigator.of(ctx).pop();
                },
              ),
          ],
        ),
      ),
    ),
  );
}

String _heure(int minutes) => '${minutes ~/ 60} h ${(minutes % 60).toString().padLeft(2, '0')}';

/// Active le rappel : demande d'abord l'autorisation à Android. Renvoie faux
/// si l'élève la refuse (le rappel reste alors désactivé).
Future<bool> activerRappel(BuildContext context, GameRepository repo, {int? minutes}) async {
  final accorde = await (repo.rappels?.demanderAutorisation() ?? Future.value(false));
  if (!accorde) {
    repo.reglerRappel(actif: false);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.settingsReminderDenied)));
    }
    return false;
  }
  repo.reglerRappel(actif: true, minutes: minutes);
  return true;
}

/// Proposition du rappel, faite une seule fois après la toute première leçon.
Future<void> proposerRappel(BuildContext context, GameRepository repo) async {
  repo.marquerRappelPropose();
  final oui = await showDialog<bool>(
    context: context,
    // Proposée une seule fois : un toucher à côté ne doit pas la faire disparaître.
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      icon: Image.asset('assets/images/lupulus/lupulus_joie_180.png', height: 72,
          errorBuilder: (_, __, ___) => const Icon(Icons.notifications_active_rounded, size: 48)),
      title: Text(ctx.l10n.reminderOfferTitle),
      content: Text(ctx.l10n.reminderOfferBody),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(ctx.l10n.reminderOfferNo)),
        FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text(ctx.l10n.reminderOfferYes)),
      ],
    ),
  );
  if (oui == true && context.mounted) await activerRappel(context, repo);
}

/// Bloc des Réglages : objectif du jour, et rappel quotidien sur Android.
class ReglagesRappelEtObjectif extends StatelessWidget {
  final GameRepository repo;
  const ReglagesRappelEtObjectif({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: repo,
      builder: (context, _) {
        final p = repo.profile;
        return Column(
          children: [
            ListTile(
              leading: const Icon(Icons.flag_rounded, color: RomanColors.imperialPurple),
              title: Text(context.l10n.settingsGoal),
              subtitle: Text(context.l10n.settingsGoalValue(p.objectifJour)),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => choisirObjectif(context, repo),
            ),
            if (RappelService.disponible) ...[
              SwitchListTile.adaptive(
                value: p.rappelActif,
                secondary: const Icon(Icons.notifications_active_rounded, color: RomanColors.imperialPurple),
                title: Text(context.l10n.settingsReminder),
                subtitle: Text(p.rappelActif
                    ? context.l10n.settingsReminderAt(_heure(p.rappelMinutes))
                    : context.l10n.settingsReminderOff),
                onChanged: (v) => v ? activerRappel(context, repo) : repo.reglerRappel(actif: false),
              ),
              if (p.rappelActif)
                ListTile(
                  leading: const Icon(Icons.schedule_rounded, color: RomanColors.imperialPurple),
                  title: Text(_heure(p.rappelMinutes)),
                  trailing: const Icon(Icons.edit_rounded, size: 18),
                  onTap: () async {
                    final choix = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: p.rappelMinutes ~/ 60, minute: p.rappelMinutes % 60),
                    );
                    if (choix != null) repo.reglerRappel(minutes: choix.hour * 60 + choix.minute);
                  },
                ),
            ],
          ],
        );
      },
    );
  }
}
