import 'package:flutter/material.dart';
import '../services/navigation_service.dart';
import 'search_screen.dart';
import 'item_form_screen.dart';
import 'csv_import_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_buttons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Constantes de dimensions spécifiques à l'écran d'accueil
  static const double _buttonHeight = AppTheme.buttonHeight;
  static const double _iconSize = AppTheme.iconSize;
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
                  PrimaryButton(
                    onPressed: () =>
                        _navigateToScreen(context, const SearchScreen()),
                    text: 'TROUVER',
                    iconPath: 'assets/images/search_icon.png',
                    height: _buttonHeight,
                    iconSize: _iconSize,
                  ),
                  const SizedBox(height: _buttonSpacing),
                  // Bouton RANGER
                  SecondaryButton(
                    onPressed: () => _navigateToScreen(
                        context,
                        const ItemFormScreen(
                          isEditMode: false,
                        )),
                    text: 'RANGER',
                    iconPath: 'assets/images/store_icon.png',
                    height: _buttonHeight,
                    iconSize: _iconSize,
                  ),
                  const SizedBox(height: _buttonSpacing),
                  // Bouton IMPORT CSV
                  SecondaryButton(
                    onPressed: () => _navigateToImportCsv(context),
                    text: 'IMPORT CSV',
                    iconPath: 'assets/images/plus_icon.png',
                    height: _buttonHeight,
                    iconSize: _iconSize,
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
    NavigationService.push(context, screen);
  }

  void _navigateToImportCsv(BuildContext context) async {
    final result = await NavigationService.push(
      context,
      const CsvImportScreen(),
    );

    // Si l'import a réussi, on pourrait rafraîchir l'écran ou afficher un message
    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Import CSV terminé avec succès !'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
