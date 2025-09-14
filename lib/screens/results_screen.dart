import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/firebase_service.dart';
import '../services/navigation_service.dart';
import '../theme/unified_theme.dart';
import 'no_results_screen.dart';
import 'item_detail_screen.dart';
import 'home_screen.dart';
import '../widgets/item_card.dart';

class ResultsScreen extends StatefulWidget {
  final String searchQuery;

  const ResultsScreen({
    super.key,
    required this.searchQuery,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with TickerProviderStateMixin {
  final FirebaseService _firebaseService = FirebaseService();
  List<Item>? _searchResults;
  bool _isLoading = true;
  String? _errorMessage;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _performSearch();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await _firebaseService.searchItems(widget.searchQuery);

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });

        // Handle navigation logic based on results
        _handleSearchResults(results);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  void _handleSearchResults(List<Item> results) {
    // Logic as specified:
    // - If 0 results → NoResultsScreen
    // - If 1 result → Navigate directly to ItemDetailScreen
    // - If multiple → ListView of results

    if (results.isEmpty) {
      // Navigate to NoResultsScreen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NavigationService.pushReplacement(
          context,
          NoResultsScreen(searchQuery: widget.searchQuery),
        );
      });
    } else if (results.length == 1) {
      // Navigate directly to ItemDetailScreen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NavigationService.pushReplacement(
          context,
          ItemDetailScreen(
            item: results.first,
            isFromCreation: false,
          ),
        );
      });
    }
    // If multiple results, stay on this screen and show ListView
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UnifiedTheme.primaryYellow,
      body: Stack(
        children: [
          // Image de fond par-dessus le fond jaune
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/images/results_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenu principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  // Header avec retour et logo
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
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
                              (route) => false,
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
                  ),

                  const SizedBox(height: 40),
                  // Titre des résultats
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      _isLoading
                          ? 'RECHERCHE...'
                          : '${_searchResults?.length ?? 0} OBJETS',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'DelaGothicOne',
                        fontSize: 34,
                        color: Colors.black,
                        height: 1.1,
                      ),
                    ),
                  ),

                  // Sous-titre avec la requête
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Text(
                      'pour "${widget.searchQuery}"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Chivo',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Contenu principal (résultats)
                  Expanded(
                    child: _buildBody(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 80),
            RotationTransition(
              turns: _rotationController,
              child: Image.asset(
                'assets/images/loading.png',
                width: 300,
                height: 300,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'CHARGEMENT...',
              style: TextStyle(
                fontFamily: 'DelaGothicOne',
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _performSearch,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    final results = _searchResults!;

    // This should only be reached if there are multiple results
    if (results.length > 1) {
      return ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.zero,
            child: ItemCard(
              item: results[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetailScreen(
                      item: results[index],
                      isFromCreation: false,
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    }

    // Fallback - should not reach here due to navigation logic
    return const Center(
      child: Text('Aucun résultat à afficher'),
    );
  }
}
