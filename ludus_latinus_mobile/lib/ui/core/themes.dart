import 'package:flutter/material.dart';

/// Palette impériale et esthétique géométrique épurée inspirée de Monument Valley.
class RomanColors {
  // Fonds architecturaux
  static const Color travertinWhite = Color(0xFFFBF8F2);
  static const Color travertine = travertinWhite;
  static const Color palatinCream = Color(0xFFF5EFEB);
  static const Color cardSurface = Color(0xFFFFFFFF);

  // Couleurs majeures de Rome
  static const Color imperialPurple = Color(0xFF56101D);
  static const Color imperialPurpleLight = Color(0xFF7A1B2D);
  static const Color imperialGold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFFFF7DB);
  static const Color goldDark = Color(0xFF8B7018);

  // Couleurs de triomphe & nature
  static const Color laurelGreen = Color(0xFF1E5E3A);
  static const Color laurelLight = Color(0xFFE8F5EE);
  static const Color skyMediterranean = Color(0xFF7BAFD4);
  static const Color skySoft = Color(0xFFE8F1F8);

  // Typographie & contrastes
  static const Color charcoal = Color(0xFF221A16);
  static const Color terracotta = Color(0xFFB84A39);
  static const Color marbleBorder = Color(0xFFE5DCCF);

  // Mode sombre impérial
  static const Color darkBackground = Color(0xFF161214);
  static const Color darkSurface = Color(0xFF221C20);
  static const Color darkCard = Color(0xFF2C242A);
}

/// Couleurs officielles des cas de déclinaisons latines (Anatomia Sententiae)
class CaseColors {
  static const Color nominative = Color(0xFF1E88E5); // Bleu Sujet
  static const Color vocative = Color(0xFF00ACC1);   // Cyan Appel
  static const Color accusative = Color(0xFFE53935); // Rouge COD
  static const Color genitive = Color(0xFF43A047);   // Vert Complément du Nom
  static const Color dative = Color(0xFFFB8C00);     // Orange Attribution / COI
  static const Color ablative = Color(0xFF8E24AA);   // Pourpre Circonstanciel
}

class RomanTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: RomanColors.travertinWhite,
      primaryColor: RomanColors.imperialPurple,
      cardColor: RomanColors.cardSurface,
      colorScheme: const ColorScheme.light(
        primary: RomanColors.imperialPurple,
        secondary: RomanColors.imperialGold,
        surface: RomanColors.travertinWhite,
        background: RomanColors.travertinWhite,
        onPrimary: Colors.white,
        onSecondary: Color(0xFF1A1409),
        onSurface: RomanColors.charcoal,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: RomanColors.travertinWhite,
        foregroundColor: RomanColors.imperialPurple,
        elevation: 0,
        scrolledUnderElevation: 1.5,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: RomanColors.imperialPurple,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          fontFamily: 'serif',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: RomanColors.imperialGold,
          foregroundColor: const Color(0xFF1A1409),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: RomanColors.darkBackground,
      primaryColor: RomanColors.imperialGold,
      cardColor: RomanColors.darkCard,
      colorScheme: const ColorScheme.dark(
        primary: RomanColors.imperialGold,
        secondary: RomanColors.terracotta,
        surface: RomanColors.darkSurface,
        background: RomanColors.darkBackground,
        onPrimary: Color(0xFF1A1409),
        onSecondary: Colors.white,
        onSurface: Colors.white70,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: RomanColors.darkBackground,
        foregroundColor: RomanColors.imperialGold,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: RomanColors.imperialGold,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          fontFamily: 'serif',
        ),
      ),
    );
  }
}