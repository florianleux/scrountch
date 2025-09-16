import 'package:flutter/material.dart';
import '../theme/unified_theme.dart';

/// Calcule la hauteur optimale d'un bouton en fonction du nombre de lignes du texte
class ButtonHeightCalculator {
  static const double baseHeight = 75.0; // Hauteur de base pour une ligne
  static const double lineHeight = 30.0; // Hauteur supplémentaire par ligne
  static const double minHeight = 50.0; // Hauteur minimum
  static const double maxWidth =
      297.0; // Largeur maximum des boutons (depuis UnifiedTheme)

  /// Calcule le nombre de lignes qu'occupera un texte donné
  static int calculateLines(String text, TextStyle textStyle, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
      maxLines: null,
    );
    textPainter.layout(maxWidth: maxWidth - 32); // Padding horizontal

    final lines = (textPainter.height / textPainter.preferredLineHeight).ceil();
    return lines.clamp(
        1, 4); // Maximum 4 lignes pour éviter des boutons trop hauts
  }

  /// Calcule la hauteur optimale du bouton
  static double calculateHeight(String text, TextStyle textStyle,
      {double? customMaxWidth}) {
    final width = customMaxWidth ?? maxWidth;
    final lines = calculateLines(text, textStyle, width);

    if (lines == 1) {
      return baseHeight;
    } else {
      return (baseHeight + ((lines - 1) * lineHeight))
          .clamp(minHeight, baseHeight + (3 * lineHeight));
    }
  }
}

/// Bouton Primary: Fond noir, texte/icône jaunes (style amélioré pour boutons désactivés)
class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final String? iconPath;
  final double? height; // Optionnel, calculé automatiquement si null
  final double iconSize;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.iconPath,
    this.height,
    this.iconSize = 45,
  });

  @override
  Widget build(BuildContext context) {
    // Calculer la hauteur automatiquement si non spécifiée
    final calculatedHeight = height ??
        ButtonHeightCalculator.calculateHeight(
            text, UnifiedTheme.buttonTextStyle);

    return SizedBox(
      height: calculatedHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: UnifiedTheme.primaryButtonStyle.copyWith(
          minimumSize:
              WidgetStateProperty.all(Size(double.infinity, calculatedHeight)),
        ),
        child: iconPath != null
            ? UnifiedTheme.buildButtonContent(
                iconPath: iconPath!,
                text: text,
                iconColor: onPressed == null
                    ? UnifiedTheme.primaryYellow.withOpacity(0.9)
                    : UnifiedTheme.primaryYellow,
                iconSize: iconSize,
              )
            : Text(
                text,
                style: UnifiedTheme.buttonTextStyle,
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );
  }
}

/// Bouton Secondary: Fond jaune, texte/icône/bordure noirs
class SecondaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final String? iconPath;
  final double? height; // Optionnel, calculé automatiquement si null
  final double iconSize;

  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.iconPath,
    this.height,
    this.iconSize = 45,
  });

  @override
  Widget build(BuildContext context) {
    // Calculer la hauteur automatiquement si non spécifiée
    final calculatedHeight = height ??
        ButtonHeightCalculator.calculateHeight(
            text, UnifiedTheme.buttonTextStyle);

    return SizedBox(
      height: calculatedHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: UnifiedTheme.secondaryButtonStyle.copyWith(
          minimumSize:
              WidgetStateProperty.all(Size(double.infinity, calculatedHeight)),
        ),
        child: iconPath != null
            ? UnifiedTheme.buildButtonContent(
                iconPath: iconPath!,
                text: text,
                iconColor: UnifiedTheme.textBlack,
                iconSize: iconSize,
              )
            : Text(
                text,
                style: UnifiedTheme.buttonTextStyle,
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );
  }
}

/// Bouton Tertiary: Fond jaune, texte/icône noirs, sans bordure (style amélioré pour boutons désactivés)
class TertiaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final String? iconPath;
  final double? height; // Optionnel, calculé automatiquement si null
  final double iconSize;

  const TertiaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.iconPath,
    this.height,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    // Style spécifique pour les boutons tertiary avec taille réduite de 20%
    final tertiaryTextStyle = UnifiedTheme.buttonTextStyle.copyWith(
      fontSize:
          UnifiedTheme.buttonTextStyle.fontSize! * 0.8, // 24 * 0.8 = 19.2px
    );

    // Calculer la hauteur automatiquement si non spécifiée
    // Pour les boutons tertiary, on utilise une hauteur de base plus petite (50 au lieu de 75)
    final calculatedHeight = height ??
        (ButtonHeightCalculator.calculateHeight(text, tertiaryTextStyle) * 0.67)
            .clamp(50.0, 135.0);

    return SizedBox(
      height: calculatedHeight,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: UnifiedTheme.tertiaryButtonStyle.copyWith(
          minimumSize:
              WidgetStateProperty.all(Size(double.infinity, calculatedHeight)),
          // Style pour les boutons tertiary désactivés
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return UnifiedTheme.primaryYellow
                  .withOpacity(0.6); // Jaune plus clair
            }
            return UnifiedTheme.primaryYellow; // Jaune normal
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return UnifiedTheme.textBlack
                  .withOpacity(0.7); // Noir légèrement transparent
            }
            return UnifiedTheme.textBlack; // Noir normal
          }),
        ),
        child: iconPath != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    iconPath!,
                    width: iconSize,
                    height: iconSize,
                    color: onPressed == null
                        ? UnifiedTheme.textBlack.withOpacity(0.7)
                        : UnifiedTheme.textBlack,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      text,
                      style: tertiaryTextStyle,
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            : Text(
                text,
                style: tertiaryTextStyle,
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );
  }
}
