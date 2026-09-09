import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'data/repositories/game_repository.dart';
import 'data/services/data_service.dart';
import 'data/services/storage_service.dart';
import 'ui/core/themes.dart';
import 'ui/features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dataService = DataService();
  final storageService = StorageService();
  final repository = GameRepository(
    dataService: dataService,
    storageService: storageService,
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
  final List<String> _latinQuotes = [
    '« Festina lente » • Hâte-toi lentement',
    '« Per aspera ad astra » • Par des chemins ardus vers les étoiles',
    '« Veni, vidi, vici » • Je suis venu, j\'ai vu, j\'ai vaincu',
    '« Repetitio est mater studiorum » • La répétition est la mère des études',
  ];
  late String _randomQuote;

  @override
  void initState() {
    super.initState();
    _randomQuote = _latinQuotes[math.Random().nextInt(_latinQuotes.length)];
    _initFuture = widget.repository.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ludus Latinus',
      debugShowCheckedModeBanner: false,
      theme: RomanTheme.lightTheme,
      darkTheme: RomanTheme.darkTheme,
      themeMode: ThemeMode.light,
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
                        _randomQuote,
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
                      const Text(
                        'Erreur de chargement des parchemins',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

          return HomeScreen(repo: widget.repository);
        },
      ),
    );
  }
}