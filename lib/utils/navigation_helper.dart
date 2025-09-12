import 'package:flutter/material.dart';

class NavigationHelper {
  // Navigation centralisée avec animations
  static Future<T?> pushScreen<T>(BuildContext context, Widget screen) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
  
  // Navigation avec remplacement
  static Future<T?> pushReplacementScreen<T>(BuildContext context, Widget screen) {
    return Navigator.pushReplacement<T, void>(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
  
  // Retour avec données
  static void popWithResult<T>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }
}
