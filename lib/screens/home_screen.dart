import 'package:flutter/material.dart';
import '../services/navigation_service.dart';
import '../theme/unified_theme.dart';
import 'search_screen.dart';
import 'item_form_screen.dart';
import 'csv_import_screen.dart';
import '../widgets/custom_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Constantes de dimensions spécifiques à l'écran d'accueil
  static const double _buttonSpacing = 24;
  static const int _topSpacerFlex = 55;
  static const int _bottomSpacerFlex = 45;

  // État pour afficher/cacher le bouton CSV
  bool _showCsvButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UnifiedTheme.primaryYellow,
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
        child: GestureDetector(
          onDoubleTap: () {
            setState(() {
              _showCsvButton = !_showCsvButton;
            });
            // Feedback visuel pour confirmer l'activation
            ScaffoldMessenger.of(context).showSnackBar(
              UnifiedTheme.successSnackBar(_showCsvButton
                  ? 'Mode administrateur activé !'
                  : 'Mode administrateur désactivé'),
            );
          },
          child: Image.asset(
            'assets/images/logo.png',
            width: 306,
            height: 117,
            fit: BoxFit.contain,
          ),
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
                  ),
                  // Bouton IMPORT CSV (affiché seulement si activé)
                  if (_showCsvButton) ...[
                    const SizedBox(height: _buttonSpacing),
                    SecondaryButton(
                      onPressed: () => _navigateToImportCsv(context),
                      text: 'IMPORT CSV',
                      iconPath: 'assets/images/plus_icon.png',
                    ),
                  ],
                ],
              ),
            ),
            const Spacer(flex: _bottomSpacerFlex),
            // Copyright and version display at bottom
            _buildCopyrightDisplay(),
            const SizedBox(height: 4),
            _buildVersionDisplay(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildCopyrightDisplay() {
    final currentYear = DateTime.now().year;
    return Center(
      child: Text(
        'CRAPOLO STUDIOS - $currentYear',
        style: const TextStyle(
          fontFamily: 'DelaGothicOne',
          fontSize: 13,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildVersionDisplay() {
    return Center(
      child: Text(
        'v3.6.0',
        style: const TextStyle(
          fontFamily: 'Chivo',
          fontSize: 12,
          color: Colors.black54,
          fontWeight: FontWeight.normal,
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
    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        UnifiedTheme.successSnackBar('Import CSV terminé avec succès !'),
      );
    }
  }
}
