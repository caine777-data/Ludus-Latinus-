import 'dart:math' as math;
import 'dart:ui' show PlatformDispatcher;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/repositories/game_repository.dart';
import 'data/services/data_service.dart';
import 'data/services/storage_service.dart';
import 'data/services/rappel_service.dart';
import 'data/services/audio_service.dart';
import 'l10n/l10n.dart';
import 'ui/core/themes.dart';
import 'ui/features/home/home_screen.dart';

/// Un écran dont le petit côté fait moins de 600 points est un téléphone.
bool estUnTelephone(Size tailleEnPoints) => tailleEnPoints.shortestSide < 600;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Téléphone : portrait seulement. En paysage, il ne reste qu'environ 400 points
  // de haut et les jeux (Circus, Duel) ne tiennent plus. Les tablettes tournent
  // librement ; sous Windows, la consigne est sans effet.
  final vue = PlatformDispatcher.instance.views.first;
  if (estUnTelephone(vue.physicalSize / vue.devicePixelRatio)) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
  await AudioService().init();

  final dataService = DataService();
  final storageService = StorageService();
  final repository = GameRepository(
    dataService: dataService,
    storageService: storageService,
    rappels: RappelService(),
  );

  runApp(LudusLatinusApp(repository: repository));
}

/// Application racine multiplateforme Ludus Latinus (Android & Windows) au style Monument Valley.
class LudusLatinusApp extends StatefulWidget {
  final GameRepository repository;

  const LudusLatinusApp({super.key, required this.repository});

  @override
  State<LudusLatinusApp> createState() => _LudusLatinusAppState();
}

class _LudusLatinusAppState extends State<LudusLatinusApp> {
  late Future<void> _initFuture;
  late int _quoteIndex;

  @override
  void initState() {
    super.initState();
    _quoteIndex = math.Random().nextInt(4);
    _initFuture = widget.repository.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.repository,
      builder: (context, _) {
        return MaterialApp(
          title: 'Ludus Latinus',
          debugShowCheckedModeBanner: false,
          // Interface en français pour l'instant ; les autres langues viendront.
          locale: const Locale('fr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: RomanTheme.lightTheme,
          darkTheme: RomanTheme.darkTheme,
          themeMode: widget.repository.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: RomanColors.travertinWhite,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: RomanColors.palatinCream,
                          border: Border.all(color: RomanColors.imperialGold, width: 2.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x223D1A10),
                              offset: Offset(0, 6),
                              blurRadius: 14,
                            )
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo_centurion_120.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Text('🏛️', style: TextStyle(fontSize: 48)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'LUDUS LATINUS',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          color: RomanColors.imperialPurple,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'S • P • Q • R',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 6,
                          color: RomanColors.imperialGold,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        [
                          context.l10n.loadingQuote1,
                          context.l10n.loadingQuote2,
                          context.l10n.loadingQuote3,
                          context.l10n.loadingQuote4,
                        ][_quoteIndex],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const SizedBox(
                        width: 140,
                        child: LinearProgressIndicator(
                          minHeight: 4,
                          backgroundColor: Color(0xFFEADBCE),
                          valueColor: AlwaysStoppedAnimation<Color>(RomanColors.imperialGold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('⚠️', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      Text(
                        context.l10n.appLoadError,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Pas de cinématique d'ouverture : l'élève arrive directement sur
          // l'accueil (l'ancienne vidéo, en basse définition, affichait du
          // texte anglais et des caractères manquants).
          return HomeScreen(repo: widget.repository);
        },
      ),
    );
      },
    );
  }
}