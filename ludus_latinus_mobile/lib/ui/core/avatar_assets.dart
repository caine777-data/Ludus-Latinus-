import '../../data/models/profile.dart';

/// Chemin du médaillon d'avatar correspondant au genre et à la toge équipée.
///
/// Acheter une armure dans la Taberna doit se voir : le héros change de tenue
/// partout dans l'application (accueil, carte, duel, boutique, compte).
class AvatarAssets {
  /// Toges disposant d'une illustration d'avatar dédiée.
  static const _togesIllustrees = {
    'lin_blanc',
    'praetexta',
    'lorica',
    'imperiale',
    'lorica_squamata',
  };

  /// [taille] vaut 140 (médaillon) ou 48 (pion de la carte).
  static String medaillon(UserProfile profile, {int taille = 140}) {
    final genre = profile.genre == 'fille' ? 'fille' : 'garcon';
    final toge = profile.getEquippedGoodie('toge');
    if (_togesIllustrees.contains(toge)) {
      return 'assets/images/avatars/${genre}_${toge}_$taille.png';
    }
    return 'assets/images/avatar_${genre}_medaillon_$taille.png';
  }
}
