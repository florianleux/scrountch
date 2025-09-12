import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs centralisées
  static const Color primaryYellow = Color(0xFFFFDD00);
  static const Color mediumYellow = Color(0xFFFFE966);
  static const Color textBlack = Colors.black;
  
  // Dimensions fixes pour 2400x1080px
  static const double buttonWidth = 297;
  static const double buttonHeight = 75;
  static const double iconSize = 65;
  static const double fontSize = 30;
  static const double borderWidth = 3;
  
  // Styles centralisés
  static const TextStyle buttonTextStyle = TextStyle(
    color: textBlack,
    fontSize: fontSize,
    fontWeight: FontWeight.w700,
  );
  
  static ButtonStyle primaryButtonStyle = OutlinedButton.styleFrom(
    side: const BorderSide(color: textBlack, width: borderWidth),
    backgroundColor: primaryYellow,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}