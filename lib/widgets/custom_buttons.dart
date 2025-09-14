import 'package:flutter/material.dart';
import '../theme/unified_theme.dart';

/// Bouton Primary: Fond noir, texte/icône jaunes
class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final String? iconPath;
  final double height;
  final double iconSize;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.iconPath,
    this.height = 75,
    this.iconSize = 45,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: UnifiedTheme.primaryButtonStyle.copyWith(
          minimumSize: WidgetStateProperty.all(Size(double.infinity, height)),
        ),
        child: iconPath != null
            ? UnifiedTheme.buildButtonContent(
                iconPath: iconPath!,
                text: text,
                iconColor: UnifiedTheme.primaryYellow,
                iconSize: iconSize,
              )
            : Text(text, style: UnifiedTheme.buttonTextStyle),
      ),
    );
  }
}

/// Bouton Secondary: Fond jaune, texte/icône/bordure noirs
class SecondaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final String? iconPath;
  final double height;
  final double iconSize;

  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.iconPath,
    this.height = 75,
    this.iconSize = 45,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: UnifiedTheme.secondaryButtonStyle.copyWith(
          minimumSize: WidgetStateProperty.all(Size(double.infinity, height)),
        ),
        child: iconPath != null
            ? UnifiedTheme.buildButtonContent(
                iconPath: iconPath!,
                text: text,
                iconColor: UnifiedTheme.textBlack,
                iconSize: iconSize,
              )
            : Text(text, style: UnifiedTheme.buttonTextStyle),
      ),
    );
  }
}

/// Bouton Tertiary: Fond jaune, texte/icône noirs, sans bordure
class TertiaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final String? iconPath;
  final double height;
  final double iconSize;

  const TertiaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.iconPath,
    this.height = 50,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    // Style spécifique pour les boutons tertiary avec taille réduite de 20%
    final tertiaryTextStyle = UnifiedTheme.buttonTextStyle.copyWith(
      fontSize:
          UnifiedTheme.buttonTextStyle.fontSize! * 0.8, // 24 * 0.8 = 19.2px
    );

    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: UnifiedTheme.tertiaryButtonStyle.copyWith(
          minimumSize: WidgetStateProperty.all(Size(double.infinity, height)),
        ),
        child: iconPath != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    iconPath!,
                    width: iconSize,
                    height: iconSize,
                    color: UnifiedTheme.textBlack,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: tertiaryTextStyle,
                  ),
                ],
              )
            : Text(text, style: tertiaryTextStyle),
      ),
    );
  }
}
