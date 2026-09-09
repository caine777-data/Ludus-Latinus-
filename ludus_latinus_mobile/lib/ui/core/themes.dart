import 'package:flutter/material.dart';

/// Palette chromatique authentique de la Rome Antique pour Ludus Latinus Mobile.
class RomanColors {
  // Couleurs majeures
  static const Color imperialPurple = Color(0xFF8B2500);
  static const Color imperialGold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF3E5AB);
  static const Color laurelGreen = Color(0xFF2E6F40);
  static const Color marbleTravertine = Color(0xFFF8F5EE);
  static const Color cardLight = Color(0xFFFFFDF9);

  // Thème sombre (Nox Romana)
  static const Color nightDark = Color(0xFF16120E);
  static const Color nightCard = Color(0xFF241D16);
  static const Color nightAccent = Color(0xFFE5A759);

  // Cas grammaticaux (Harmonisés avec le Décrypteur Visuel)
  static const Color caseNominatif = Color(0xFF1E5AA0); // Bleu royal
  static const Color caseVocatif = Color(0xFF008B8B);   // Cyan
  static const Color caseAccusatif = Color(0xFFA82020); // Rouge vermillon
  static const Color caseGenitif = Color(0xFF2E7D32);   // Émeraude
  static const Color caseDatif = Color(0xFFC59B27);     // Or ambré
  static const Color caseAblatif = Color(0xFF7B1FA2);   // Pourpre
}

/// Thème visuel complet pour l'application Flutter Ludus Latinus.
class RomanTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: RomanColors.imperialPurple,
      scaffoldBackgroundColor: RomanColors.marbleTravertine,
      colorScheme: const ColorScheme.light(
        primary: RomanColors.imperialPurple,
        secondary: RomanColors.imperialGold,
        surface: RomanColors.cardLight,
        background: RomanColors.marbleTravertine,
        onPrimary: Colors.white,
        onSecondary: Color(0xFF1A1409),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: RomanColors.marbleTravertine,
        foregroundColor: RomanColors.imperialPurple,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: RomanColors.imperialPurple,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardTheme(
        color: RomanColors.cardLight,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE2D6C0), width: 1),
        ),
      ),
      fontFamily: 'Georgia',
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: RomanColors.nightAccent,
      scaffoldBackgroundColor: RomanColors.nightDark,
      colorScheme: const ColorScheme.dark(
        primary: RomanColors.nightAccent,
        secondary: RomanColors.imperialGold,
        surface: RomanColors.nightCard,
        background: RomanColors.nightDark,
        onPrimary: Colors.black,
        onSecondary: Color(0xFF1A1409),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: RomanColors.nightDark,
        foregroundColor: RomanColors.nightAccent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: RomanColors.nightAccent,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardTheme(
        color: RomanColors.nightCard,
        elevation: 2,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF3D3024), width: 1),
        ),
      ),
      fontFamily: 'Georgia',
    );
  }
}
