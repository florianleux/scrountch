import 'package:flutter/material.dart';

/// Thème unifié pour centraliser toutes les couleurs et styles
class UnifiedTheme {
  // =================== COULEURS ===================

  /// Couleur principale jaune utilisée partout
  static const Color primaryYellow = Color(0xFFFFE333);

  /// Couleur de texte principale
  static const Color textBlack = Colors.black;

  /// Couleur de texte secondaire
  static const Color textBlack54 = Colors.black54;

  /// Couleur d'erreur
  static const Color errorRed = Colors.red;

  /// Couleur de succès
  static const Color successGreen = Colors.green;

  // =================== DIMENSIONS ===================

  /// Rayon de bordure standard
  static const double borderRadius = 8.0;

  /// Largeur de bordure standard
  static const double borderWidth = 1.0;

  // =================== HELPERS ===================

  /// Créer un SnackBar de succès
  static SnackBar successSnackBar(String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: successGreen,
      duration: const Duration(seconds: 3),
    );
  }

  /// Créer un SnackBar d'erreur
  static SnackBar errorSnackBar(String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: errorRed,
      duration: const Duration(seconds: 3),
    );
  }
}
