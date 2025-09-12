import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'manage_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Constantes de couleurs et dimensions
  static const Color _primaryYellow = Color(0xFFFFDD00);
  static const double _buttonWidth = 297;
  static const double _buttonHeight = 75;
  static const double _iconSize = 65;
  static const double _fontSize = 30;
  static const double _borderWidth = 3;
  static const double _logoTop = 30;
  static const double _logoHeight = 200;
  static const double _buttonSpacing = 24;
  static const int _topSpacerFlex = 55;
  static const int _bottomSpacerFlex = 45;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryYellow,
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
      top: _logoTop,
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
      child: Column(
        children: [
          const Spacer(flex: _topSpacerFlex),
          Center(
            child: Column(
              children: [
                _buildButton(
                  label: 'TROUVER',
                  iconPath: 'assets/images/search_icon.png',
                  onPressed: () => _navigateToScreen(context, const SearchScreen()),
                ),
                const SizedBox(height: _buttonSpacing),
                _buildButton(
                  label: 'RANGER',
                  iconPath: 'assets/images/store_icon.png',
                  onPressed: () => _navigateToScreen(context, const ManageScreen()),
                ),
              ],
            ),
          ),
          const Spacer(flex: _bottomSpacerFlex),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required String iconPath,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: _buttonWidth,
      height: _buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.black, width: _borderWidth),
          backgroundColor: _primaryYellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              width: _iconSize,
              height: _iconSize,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: _fontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
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