import 'package:flutter/material.dart';
import '../theme/button_styles.dart';

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
        style: AppButtonStyles.primary,
        child: iconPath != null
            ? AppButtonStyles.buildButtonContent(
                iconPath: iconPath!,
                text: text,
                iconColor: const Color(0xFFFFE333),
                iconSize: iconSize,
              )
            : Text(text, style: AppButtonStyles.buttonTextStyle),
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
        style: AppButtonStyles.secondary,
        child: iconPath != null
            ? AppButtonStyles.buildButtonContent(
                iconPath: iconPath!,
                text: text,
                iconColor: Colors.black,
                iconSize: iconSize,
              )
            : Text(text, style: AppButtonStyles.buttonTextStyle),
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
    final tertiaryTextStyle = AppButtonStyles.buttonTextStyle.copyWith(
      fontSize:
          AppButtonStyles.buttonTextStyle.fontSize! * 0.8, // 24 * 0.8 = 19.2px
    );

    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: AppButtonStyles.tertiary,
        child: iconPath != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    iconPath!,
                    width: iconSize,
                    height: iconSize,
                    color: Colors.black,
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
