import 'package:flutter/material.dart';
import '../services/navigation_service.dart';
import '../screens/home_screen.dart';

/// Reusable header widget with back and home navigation
/// Used across multiple screens for consistent navigation
class AppHeader extends StatelessWidget {
  final bool showBackButton;
  final bool showHomeButton;
  final VoidCallback? onBackPressed;
  final VoidCallback? onHomePressed;

  const AppHeader({
    super.key,
    this.showBackButton = true,
    this.showHomeButton = true,
    this.onBackPressed,
    this.onHomePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          // Back button
          if (showBackButton)
            GestureDetector(
              onTap: onBackPressed ?? () => Navigator.pop(context),
              child: Image.asset(
                'assets/images/back_icon.png',
                width: 50,
                height: 50,
              ),
            )
          else
            const SizedBox(width: 50), // Maintain spacing when hidden

          const Spacer(),

          // Home button
          if (showHomeButton)
            GestureDetector(
              onTap: onHomePressed ?? () => _navigateToHome(context),
              child: Image.asset(
                'assets/images/home_icon.png',
                width: 50,
                height: 50,
              ),
            )
          else
            const SizedBox(width: 50), // Maintain spacing when hidden
        ],
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    NavigationService.pushAndRemoveUntil(
      context,
      const HomeScreen(),
    );
  }
}
