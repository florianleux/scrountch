import 'package:flutter/material.dart';
import '../services/navigation_service.dart';
import '../theme/unified_theme.dart';
import 'results_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/app_header.dart';
import '../widgets/background_image.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'VEUILLEZ SAISIR UN NOM D\'OBJET',
              style: const TextStyle(
                fontFamily: 'DelaGothicOne',
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Navigate to ResultsScreen with search query
      await NavigationService.push(
        context,
        ResultsScreen(searchQuery: query),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UnifiedTheme.primaryYellow,
      body: Stack(
        children: [
          // Image de fond par-dessus le fond jaune
          const BackgroundImage(
            imagePath: 'assets/images/search_bg.png',
            opacity: 0.2,
          ),
          // Contenu principal
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                children: [
                  // Header avec retour et logo
                  const AppHeader(),

                  SizedBox(height: 140),
                  // Titre centré
                  Center(
                    child: Text(
                      'TROUVER\nUN OBJET',
                      textAlign: TextAlign.center,
                      style: UnifiedTheme.headingStyle.copyWith(
                        fontSize: 38,
                        height: 1.1,
                      ),
                    ),
                  ),
                  SizedBox(height: 80),
                  // Champ de recherche
                  CustomTextField(
                    controller: _searchController,
                    hintText: 'Nom de l\'objet',
                    labelText: 'Nom de l\'objet',
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (_) => _performSearch(),
                  ),

                  const SizedBox(height: 20),

                  // Bouton de recherche
                  PrimaryButton(
                    onPressed: _isLoading ? null : _performSearch,
                    text: _isLoading ? 'RECHERCHE...' : 'RECHERCHER',
                    iconPath:
                        _isLoading ? null : 'assets/images/search_icon.png',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
