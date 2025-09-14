import 'package:flutter/material.dart';

/// Service de navigation centralisé pour éviter la duplication
class NavigationService {
  
  /// Navigation simple vers un nouvel écran
  static Future<T?> push<T>(BuildContext context, Widget screen) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
  
  /// Navigation avec remplacement de l'écran actuel
  static Future<T?> pushReplacement<T>(BuildContext context, Widget screen) {
    return Navigator.pushReplacement<T, void>(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
  
  /// Navigation qui supprime toutes les routes précédentes
  static Future<T?> pushAndRemoveUntil<T>(
    BuildContext context, 
    Widget screen, {
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.pushAndRemoveUntil<T>(
      context,
      MaterialPageRoute(builder: (context) => screen),
      predicate ?? (route) => false,
    );
  }
  
  /// Retour simple
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }
}
