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
  'm17-01', 'm17-02', 'm17-03',
  'm18-01', 'm18-02', 'm18-03',
  'm19-01', 'm19-02', 'm19-03',
  'm20-01', 'm20-02', 'm20-03',
  'm21-01', 'm21-02', 'm21-03',
  'm22-01', 'm22-02', 'm22-03',
  'm23-01', 'm23-02', 'm23-03',
  'm24-01', 'm24-02', 'm24-03',
  'm25-01', 'm25-02', 'm25-03',
  'm26-01', 'm26-02', 'm26-03',
};

/// Chemin de l'illustration propre à la leçon, ou null si elle n'en a pas encore.
String? illustrationDeLecon(String idLecon) =>
    leconsIllustrees.contains(idLecon) ? 'assets/images/lecons/lecon_$idLecon.jpg' : null;
