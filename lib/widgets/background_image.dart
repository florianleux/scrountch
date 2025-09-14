import 'package:flutter/material.dart';

/// Reusable background image widget
/// Used across multiple screens for consistent background styling
class BackgroundImage extends StatelessWidget {
  final String imagePath;
  final double opacity;

  const BackgroundImage({
    super.key,
    required this.imagePath,
    this.opacity = 0.2,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Opacity(
        opacity: opacity,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
