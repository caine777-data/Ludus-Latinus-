/// Leçons qui ont leur propre illustration dans `assets/images/lecons/`.
/// Liste tenue à la main : on l'allonge à chaque livraison d'images, et un test
/// vérifie qu'elle correspond exactement aux fichiers présents.
const Set<String> leconsIllustrees = {
  'm11-01', 'm11-02', 'm11-03',
  'm12-01', 'm12-02', 'm12-03',
  'm13-01', 'm13-02', 'm13-03',
  'm14-01', 'm14-02',
  'm15-01', 'm15-02', 'm15-03',
  'm16-01', 'm16-02', 'm16-03',
};

/// Chemin de l'illustration propre à la leçon, ou null si elle n'en a pas encore.
String? illustrationDeLecon(String idLecon) =>
    leconsIllustrees.contains(idLecon) ? 'assets/images/lecons/lecon_$idLecon.jpg' : null;
