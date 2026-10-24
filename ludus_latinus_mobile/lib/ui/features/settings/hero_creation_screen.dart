import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import 'hero_form.dart';
import '../../../l10n/l10n.dart';

/// Premier lancement : l'élève choisit son héros avant d'entrer dans Rome.
///
/// Sans cet écran, tout le monde démarrait sous le nom de « Marcus », en
/// garçon. On ne peut pas le quitter sans avoir donné un prénom.
class HeroCreationScreen extends StatefulWidget {
  final GameRepository repo;

  const HeroCreationScreen({super.key, required this.repo});

  /// Affiche l'écran si le héros n'a pas encore été choisi. Renvoie vrai
  /// quand le héros vient d'être créé.
  static Future<bool> showIfNeeded(BuildContext context, GameRepository repo) async {
    if (repo.profile.heroChoisi) return false;
    await Navigator.of(context).push(
      MaterialPageRoute(fullscreenDialog: true, builder: (_) => HeroCreationScreen(repo: repo)),
    );
    return repo.profile.heroChoisi;
  }

  @override
  State<HeroCreationScreen> createState() => _HeroCreationScreenState();
}

class _HeroCreationScreenState extends State<HeroCreationScreen> {
  late String _genre = widget.repo.profile.genre;
  String _prenom = '';

  bool get _pret => _prenom.isNotEmpty;

  void _valider() {
    if (!_pret) return;
    HapticFeedback.heavyImpact();
    AudioService().playLessonDone();
    widget.repo.chooseHero(_prenom, _genre);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: RomanColors.travertine,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
            children: [
              const Center(child: AnimatedLupulusAvatar(size: 84, mood: LupulusMood.joie)),
              const SizedBox(height: 16),
              Text(
                context.l10n.heroCreationGreeting,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: RomanFonts.imperial,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: RomanColors.imperialPurple,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                context.l10n.heroCreationLupulusIntro,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, height: 1.4, color: RomanColors.charcoal),
              ),
              const SizedBox(height: 26),
              HeroForm(
                profile: widget.repo.profile,
                genreInitial: _genre,
                prenomInitial: '',
                onChanged: (prenom, genre) => setState(() {
                  _prenom = prenom;
                  _genre = genre;
                }),
              ),
              const SizedBox(height: 10),
              Text(
                context.l10n.heroCreationChangeLater,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 22),
              // Bouton grisé tant qu'aucun prénom n'est donné.
              Opacity(
                opacity: _pret ? 1 : 0.45,
                child: RomanButton(
                  text: _pret ? context.l10n.heroCreationEnter : context.l10n.heroCreationWriteName,
                  icon: Icons.arrow_forward_rounded,
                  isLarge: true,
                  onPressed: _pret ? _valider : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
