import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/models/profile.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import '../../core/avatar_assets.dart';
import '../../core/themes.dart';

/// Choix du héros : fille ou garçon, puis prénom.
///
/// Partagé par l'écran de création (premier lancement) et les Paramètres.
/// Le formulaire ne sauvegarde rien lui-même : il signale chaque changement
/// par [onChanged], et c'est l'écran qui décide quand enregistrer.
class HeroForm extends StatefulWidget {
  final UserProfile profile;
  final String genreInitial;
  final String prenomInitial;
  final void Function(String prenom, String genre) onChanged;

  const HeroForm({
    super.key,
    required this.profile,
    required this.genreInitial,
    required this.prenomInitial,
    required this.onChanged,
  });

  @override
  State<HeroForm> createState() => _HeroFormState();
}

class _HeroFormState extends State<HeroForm> {
  late String _genre = widget.genreInitial == 'fille' ? 'fille' : 'garcon';
  late final TextEditingController _prenom = TextEditingController(text: widget.prenomInitial);

  @override
  void dispose() {
    _prenom.dispose();
    super.dispose();
  }

  void _choisirGenre(String genre) {
    if (genre == _genre) return;
    HapticFeedback.selectionClick();
    AudioService().playCardFlip();
    setState(() => _genre = genre);
    widget.onChanged(_prenom.text.trim(), _genre);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: _carteGenre('garcon', 'Un Romain')),
            const SizedBox(width: 12),
            Expanded(child: _carteGenre('fille', 'Une Romaine')),
          ],
        ),
        const SizedBox(height: 18),
        TextField(
          controller: _prenom,
          maxLength: GameRepository.longueurMaxPrenom,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            labelText: 'Ton prénom',
            hintText: _genre == 'fille' ? 'Julia, Léa, Livia…' : 'Marcus, Lucas, Titus…',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: RomanColors.imperialPurple, width: 2),
            ),
          ),
          onChanged: (v) => widget.onChanged(v.trim(), _genre),
        ),
      ],
    );
  }

  Widget _carteGenre(String genre, String libelle) {
    final choisi = _genre == genre;
    return Semantics(
      button: true,
      selected: choisi,
      label: libelle,
      child: InkWell(
        onTap: () => _choisirGenre(genre),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: choisi ? RomanColors.goldLight : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: choisi ? RomanColors.imperialGold : RomanColors.marbleBorder,
              width: choisi ? 2.5 : 1.2,
            ),
          ),
          child: Column(
            children: [
              ClipOval(
                child: Image.asset(
                  AvatarAssets.pourGenre(widget.profile, genre),
                  width: 92,
                  height: 92,
                  fit: BoxFit.cover,
                  // Hors du choix, l'avatar s'estompe : on voit lequel est retenu.
                  opacity: AlwaysStoppedAnimation(choisi ? 1 : 0.55),
                  errorBuilder: (_, __, ___) => const SizedBox(width: 92, height: 92),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                libelle,
                style: TextStyle(
                  fontWeight: choisi ? FontWeight.bold : FontWeight.w500,
                  color: choisi ? RomanColors.imperialPurple : RomanColors.charcoal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
