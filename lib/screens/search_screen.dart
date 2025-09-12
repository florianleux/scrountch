import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'results_screen.dart';
import 'home_screen.dart';

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
        const SnackBar(
          content: Text('Veuillez saisir un nom d\'objet'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Navigate to ResultsScreen with search query
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(searchQuery: query),
        ),
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
      backgroundColor: const Color(0xFFFFE333), // Fond jaune clair
      body: Stack(
        children: [
          // Image de fond par-dessus le fond jaune
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/search_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenu principal
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
              child: Column(
                children: [
                  // Header avec retour et logo
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          'assets/images/back_icon.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                            (route) =>
                                false, // Supprime toutes les routes précédentes
                          );
                        },
                        child: Image.asset(
                          'assets/images/home_icon.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 170),
                  // Titre centré
                  Center(
                    child: Text(
                      'TROUVER\nUN OBJET',
                      textAlign: TextAlign.center,
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 38,
                        height: 1.1,
                      ),
                    ),
                  ),
                  SizedBox(height: 80),
                  // Champ de recherche
                  TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Nom de l\'objet',
                      labelText: 'Nom de l\'objet',
                      fillColor: const Color(0xFFFFE333),
                      filled: true,
                    ),
                    style: AppTheme.textFieldStyle,
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (_) => _performSearch(),
                  ),

                  const SizedBox(height: 20),

                  // Bouton de recherche
                  SizedBox(
                    height: 75,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _performSearch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFFFE333)),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/search_icon.png', // ICI votre icône PNG
                                  width: 45, // Taille de l'icône
                                  height: 45,
                                  color: Color(
                                      0xFFFFE333), // Colorier l'icône (optionnel)
                                ),
                                const SizedBox(
                                    width: 8), // Espace entre icône et texte
                                const Text(
                                  'RECHERCHER',
                                  style: TextStyle(color: Color(0xFFFFE333)),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const Spacer(),

                  // Bouton retour à l'accueil
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Retour à l\'accueil',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
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
