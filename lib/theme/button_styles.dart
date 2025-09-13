import 'package:flutter/material.dart';

class AppButtonStyles {
  // Couleurs communes
  static const Color _primaryYellow = Color(0xFFFFE333);
  static const Color _primaryBlack = Colors.black;

  // Forme commune
  static final RoundedRectangleBorder _buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  );

  /// Primary Button: Fond noir, texte/icône jaunes
  /// Usage: Boutons d'action principale (RECHERCHER, ENREGISTRER, MODIFIER)
  static ButtonStyle get primary => ElevatedButton.styleFrom(
        backgroundColor: _primaryBlack,
        foregroundColor: _primaryYellow,
        shape: _buttonShape,
        elevation: 0,
      );

  /// Secondary Button: Fond jaune, texte/icône/bordure noirs
  /// Usage: Boutons d'action secondaire (RANGER, SUPPRIMER, ANNULER)
  static ButtonStyle get secondary => ElevatedButton.styleFrom(
        backgroundColor: _primaryYellow,
        foregroundColor: _primaryBlack,
        side: const BorderSide(color: _primaryBlack, width: 1),
        shape: _buttonShape,
        elevation: 0,
      );

  /// Tertiary Button: Fond jaune, texte/icône noirs, sans bordure
  /// Usage: Boutons dans les dialogues de confirmation
  static ButtonStyle get tertiary => ElevatedButton.styleFrom(
        backgroundColor: _primaryYellow,
        foregroundColor: _primaryBlack,
        shape: _buttonShape,
        elevation: 0,
      );

  /// Style pour les textes des boutons
  static const TextStyle buttonTextStyle = TextStyle(
    fontFamily: 'DelaGothicOne',
    fontSize: 24, // Uniformisé avec AppTheme (30 * 0.8 = 24)
    fontWeight: FontWeight.normal,
  );

  /// Widget helper pour créer un bouton avec icône et texte
  static Widget buildButtonContent({
    required String iconPath,
    required String text,
    required Color iconColor,
    double iconSize = 45,
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
        const SizedBox(width: 8),
        Text(
          text,
          style: buttonTextStyle,
        ),
      ],
    );
  }
}
