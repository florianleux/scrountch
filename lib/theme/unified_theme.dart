import 'package:flutter/material.dart';

class UnifiedTheme {
  // =================== COULEURS ===================
  static const Color primaryYellow = Color(0xFFFFE333);
  static const Color mediumYellow = Color(0xFFFFE966);
  static const Color textBlack = Colors.black;
  static const Color textBlack54 = Colors.black54;
  static const Color errorRed = Colors.red;
  static const Color successGreen = Colors.green;

  // =================== TYPOGRAPHIE ===================
  static const String titleFont = 'DelaGothicOne';
  static const String bodyFont = 'Chivo';

  static const TextStyle headingStyle = TextStyle(
    fontFamily: titleFont,
    color: textBlack,
    fontSize: 36,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontFamily: titleFont,
    color: textBlack,
    fontSize: 21.6,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontFamily: bodyFont,
    color: textBlack,
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle captionStyle = TextStyle(
    fontFamily: bodyFont,
    color: textBlack,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle textFieldStyle = TextStyle(
    fontFamily: bodyFont,
    color: textBlack,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle labelStyle = TextStyle(
    fontFamily: bodyFont,
    color: textBlack,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle hintStyle = TextStyle(
    fontFamily: bodyFont,
    color: textBlack,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle counterStyle = TextStyle(
    fontSize: 12,
    color: textBlack54,
    fontWeight: FontWeight.w700,
  );

  // =================== DIMENSIONS ===================
  static const double buttonWidth = 297;
  static const double buttonHeight = 75;
  static const double iconSize = 55.25;
  static const double buttonSpacing = 24;
  static const double horizontalPadding = 24.0;
  static const double verticalPadding = 24.0;
  static const double borderRadius = 8.0;
  static const double borderWidth = 1.0;

  // =================== STYLES DE BOUTONS ===================
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: textBlack,
        foregroundColor: primaryYellow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 0,
        textStyle: buttonTextStyle,
        minimumSize: const Size(buttonWidth, buttonHeight),
      );

  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: primaryYellow,
        foregroundColor: textBlack,
        side: const BorderSide(color: textBlack, width: borderWidth),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 0,
        textStyle: buttonTextStyle,
        minimumSize: const Size(buttonWidth, buttonHeight),
      );

  static ButtonStyle get tertiaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: primaryYellow,
        foregroundColor: textBlack,
        side: BorderSide.none, // Pas de bordure pour les boutons tertiary
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 0,
        textStyle: buttonTextStyle,
        minimumSize: const Size(buttonWidth, buttonHeight),
      );

  // =================== THÈME D'INPUT ===================
  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        labelStyle: const TextStyle(
          fontFamily: bodyFont,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textBlack,
        ),
        hintStyle: const TextStyle(
          fontFamily: bodyFont,
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: textBlack,
        ),
        floatingLabelStyle: const TextStyle(
          fontFamily: titleFont,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textBlack,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: textBlack, width: borderWidth),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: textBlack, width: borderWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: textBlack, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: errorRed, width: borderWidth),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        fillColor: primaryYellow,
        filled: true,
        prefixIconColor: textBlack,
        suffixIconColor: textBlack,
        counterStyle: counterStyle,
      );

  // =================== SNACKBARS ===================
  static SnackBar successSnackBar(String message) {
    return SnackBar(
      content: Center(
        child: Text(
          message.toUpperCase(),
          style: const TextStyle(
            fontFamily: titleFont,
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: successGreen,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  static SnackBar errorSnackBar(String message) {
    return SnackBar(
      content: Center(
        child: Text(
          message.toUpperCase(),
          style: const TextStyle(
            fontFamily: titleFont,
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: errorRed,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  // =================== THÈME GLOBAL ===================
  static ThemeData get themeData => ThemeData(
        colorScheme: const ColorScheme.light(
          primary: textBlack,
          secondary: primaryYellow,
          surface: primaryYellow,
        ),
        useMaterial3: true,
        fontFamily: bodyFont,
        textTheme: TextTheme(
          displayLarge:
              headingStyle.copyWith(fontSize: 32, fontWeight: FontWeight.w900),
          displayMedium:
              headingStyle.copyWith(fontSize: 28, fontWeight: FontWeight.w800),
          headlineLarge:
              headingStyle.copyWith(fontSize: 24, fontWeight: FontWeight.w500),
          headlineMedium:
              headingStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
          titleLarge:
              headingStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          titleMedium:
              bodyTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
          bodyLarge: bodyTextStyle.copyWith(fontSize: 22),
          bodyMedium: bodyTextStyle.copyWith(fontSize: 22, color: textBlack54),
          labelLarge:
              buttonTextStyle.copyWith(fontSize: 16, color: Colors.white),
          bodySmall: textFieldStyle,
          labelMedium: labelStyle,
          labelSmall: captionStyle,
        ),
        inputDecorationTheme: inputDecorationTheme,
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: bodyTextStyle.copyWith(fontWeight: FontWeight.w500),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        ),
      );

  // =================== HELPERS ===================
  /// Créer un widget avec icône et texte pour les boutons
  static Widget buildButtonContent({
    required String iconPath,
    required String text,
    required Color iconColor,
    double iconSize = UnifiedTheme.iconSize, // Default to theme's iconSize
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          iconPath,
          width: iconSize,
          height: iconSize,
          color: iconColor,
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            text, 
            style: buttonTextStyle.copyWith(color: iconColor),
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
