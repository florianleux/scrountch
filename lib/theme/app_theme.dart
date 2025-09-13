import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs centralisées
  static const Color primaryYellow = Color(0xFFFFE333);
  static const Color mediumYellow = Color(0xFFFFE966);
  static const Color textBlack = Colors.black;

  // Dimensions fixes pour 2400x1080px
  static const double buttonWidth = 297;
  static const double buttonHeight = 75;
  static const double iconSize = 65 * 0.85; // Réduit de 15% (65 * 0.85 = 55.25)
  static const double fontSize = 30;
  static const double borderWidth = 3;

  // Styles centralisés
  static const TextStyle buttonTextStyle = TextStyle(
    fontFamily: 'DelaGothicOne',
    color: textBlack,
    fontSize: fontSize * 0.8, // Réduit de 20% (30 * 0.8 = 24)
    fontWeight: FontWeight.normal, // Dela Gothic One est déjà bold par nature
  );

  // Styles de texte supplémentaires avec police locale
  static const TextStyle headingStyle = TextStyle(
    fontFamily: 'DelaGothicOne',
    color: textBlack,
    fontSize: 36,
    fontWeight: FontWeight.normal, // Dela Gothic One est déjà bold par nature
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontFamily: 'Chivo',
    color: textBlack,
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle captionStyle = TextStyle(
    fontFamily: 'Chivo',
    color: textBlack,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // Style pour les champs de texte
  static const TextStyle textFieldStyle = TextStyle(
    fontFamily: 'Chivo',
    color: textBlack,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  // Style pour les labels
  static const TextStyle labelStyle = TextStyle(
    fontFamily: 'Chivo',
    color: textBlack,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  // Style pour les hints
  static const TextStyle hintStyle = TextStyle(
    fontFamily: 'Chivo',
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static ButtonStyle primaryButtonStyle = OutlinedButton.styleFrom(
    side: const BorderSide(color: textBlack, width: borderWidth),
    backgroundColor: primaryYellow,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // Thème global pour tous les inputs
  static const InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(
      vertical: 16, // Padding vertical pour TOUS les inputs
      horizontal: 12, // Padding horizontal pour TOUS les inputs
    ),
  );

  // ThemeData complet pour l'application
  static ThemeData get themeData => ThemeData(
        primaryColor: primaryYellow,
        scaffoldBackgroundColor: primaryYellow,
        fontFamily: 'Chivo',
        inputDecorationTheme: inputDecorationTheme,
        textTheme: const TextTheme(
          headlineLarge: headingStyle,
          bodyLarge: bodyTextStyle,
          bodyMedium: captionStyle,
        ),
      );
}
