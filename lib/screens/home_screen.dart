import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'manage_screen.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Constantes de dimensions spécifiques à l'écran d'accueil
  static const double _buttonHeight = AppTheme.buttonHeight;
  static const double _iconSize = AppTheme.iconSize;
  static const double _logoTop = 30;
  static const double _buttonSpacing = 24;
  static const int _topSpacerFlex = 55;
  static const int _bottomSpacerFlex = 45;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryYellow,
      body: Stack(
        children: [
          _buildBackground(),
          _buildLogo(),
          _buildButtonsSection(context),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/home_bg.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildLogo() {
    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 306,
          height: 117,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildButtonsSection(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          children: [
            const Spacer(flex: _topSpacerFlex),
            Center(
              child: Column(
                children: [
                  // Bouton TROUVER
                  SizedBox(
                    height: _buttonHeight,
                    child: ElevatedButton(
                      onPressed: () =>
                          _navigateToScreen(context, const SearchScreen()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/search_icon.png',
                            width: _iconSize,
                            height: _iconSize,
                            color: AppTheme.primaryYellow, // Couleur jaune
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'TROUVER',
                            style: AppTheme.buttonTextStyle.copyWith(
                              color: AppTheme.primaryYellow, // Couleur jaune
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: _buttonSpacing),
                  // Bouton RANGER
                  SizedBox(
                    height: _buttonHeight,
                    child: ElevatedButton(
                      onPressed: () =>
                          _navigateToScreen(context, const ManageScreen()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/store_icon.png',
                            width: _iconSize,
                            height: _iconSize,
                            color: AppTheme.primaryYellow, // Couleur jaune
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'RANGER',
                            style: AppTheme.buttonTextStyle.copyWith(
                              color: AppTheme.primaryYellow, // Couleur jaune
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: _bottomSpacerFlex),
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
