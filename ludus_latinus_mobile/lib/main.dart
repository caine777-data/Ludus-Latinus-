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

/// Application racine multiplateforme Ludus Latinus (Android & Windows).
class LudusLatinusApp extends StatefulWidget {
  final GameRepository repository;

  const LudusLatinusApp({super.key, required this.repository});

  @override
  State<LudusLatinusApp> createState() => _LudusLatinusAppState();
}

class _LudusLatinusAppState extends State<LudusLatinusApp> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
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
            return const Scaffold(
              backgroundColor: RomanColors.travertinWhite,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🏛️', style: TextStyle(fontSize: 64)),
                    SizedBox(height: 20),
                    Text(
                      'LUDUS LATINUS',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: RomanColors.imperialPurple,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Chargement des archives impériales...',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: RomanColors.imperialGold,
                      ),
                    ),
                  ],
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
                        'Erreur de chargement des données',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '',
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