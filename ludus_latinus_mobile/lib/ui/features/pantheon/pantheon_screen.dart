import 'package:flutter/material.dart';
import '../../../data/models/carte_pantheon.dart';
import '../../../data/repositories/game_repository.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';

/// Le Panthéon est un album : une carte par monde. Terminer un monde (toutes
/// ses leçons validées) retourne sa carte ; les autres restent face cachée.
/// Les 26 cartes viennent de `assets/data/pantheon.json`.
class PantheonScreen extends StatelessWidget {
  final GameRepository repo;

  const PantheonScreen({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: repo,
      builder: (context, _) {
        final cartes = repo.cartesPantheon;
        final termines = repo.mondesTermines;
        final gagnees = cartes.where((c) => termines.contains(c.mondeId)).length;

        return Scaffold(
          appBar: AppBar(title: const Text('Le Panthéon')),
          body: RomanOculusBackdrop(
            child: SafeArea(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: cartes.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0) return _EnTete(gagnees: gagnees, total: cartes.length);
                  final carte = cartes[i - 1];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CartePantheonTile(
                      carte: carte,
                      gagnee: termines.contains(carte.mondeId),
                      titreMonde: _titreDuMonde(carte),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  String _titreDuMonde(CartePantheon carte) {
    for (final w in repo.worlds) {
      if (w.id == carte.mondeId) return w.title;
    }
    return '';
  }
}

class _EnTete extends StatelessWidget {
  final int gagnees;
  final int total;

  const _EnTete({required this.gagnees, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RomanMeanderDivider(height: 12, color: RomanColors.imperialGold),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF421019), Color(0xFF1F060B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: RomanColors.imperialGold, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ALBUM DES CARTES',
                  style: TextStyle(
                    color: RomanColors.imperialGold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Termine un monde pour retourner sa carte.',
                  style: TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
                ),
                const SizedBox(height: 8),
                Text(
                  '$gagnees / $total cartes',
                  style: const TextStyle(
                    color: RomanColors.imperialGold,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Une carte de l'album : face visible si le monde est terminé, face cachée sinon.
class CartePantheonTile extends StatelessWidget {
  final CartePantheon carte;
  final bool gagnee;
  final String titreMonde;

  const CartePantheonTile({
    super.key,
    required this.carte,
    required this.gagnee,
    required this.titreMonde,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: gagnee ? Colors.white : RomanColors.palatinCream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: gagnee ? RomanColors.imperialGold : RomanColors.marbleBorder,
          width: gagnee ? 1.8 : 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 96,
            height: 128,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: gagnee ? CarteImage(carte: carte) : const _DosDeCarte(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: gagnee ? _Recto(carte: carte) : _Verso(carte: carte, titreMonde: titreMonde)),
        ],
      ),
    );
  }
}

class _Recto extends StatelessWidget {
  final CartePantheon carte;

  const _Recto({required this.carte});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monde ${carte.monde}',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: RomanColors.goldDark),
        ),
        const SizedBox(height: 2),
        Text(
          carte.nom,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: RomanColors.charcoal,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          carte.devise,
          style: const TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: RomanColors.imperialPurple,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          carte.traduction,
          style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.3),
        ),
      ],
    );
  }
}

class _Verso extends StatelessWidget {
  final CartePantheon carte;
  final String titreMonde;

  const _Verso({required this.carte, required this.titreMonde});

  @override
  Widget build(BuildContext context) {
    final monde = titreMonde.isEmpty ? '' : ' : $titreMonde';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Carte cachée',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: RomanColors.charcoal),
        ),
        const SizedBox(height: 6),
        Text(
          'Termine le monde ${carte.monde}$monde pour la débloquer',
          style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.3),
        ),
      ],
    );
  }
}

class _DosDeCarte extends StatelessWidget {
  const _DosDeCarte();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/dos_carte_collector.png',
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const ColoredBox(
        color: Color(0xFF421019),
        child: Center(child: Icon(Icons.lock_outline, color: RomanColors.imperialGold)),
      ),
    );
  }
}

/// Illustration d'une carte : `carte_mondeNN.png` si elle existe, sinon l'image
/// du monde, sinon une icône. Déposer les PNG dans `assets/images/pantheon/`
/// suffit : aucun code à changer.
class CarteImage extends StatelessWidget {
  final CartePantheon carte;

  const CarteImage({super.key, required this.carte});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      carte.image,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        carte.imageRepli,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const ColoredBox(
          color: RomanColors.goldLight,
          child: Center(child: Icon(Icons.account_balance, color: RomanColors.goldDark)),
        ),
      ),
    );
  }
}
