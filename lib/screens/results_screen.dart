import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/firebase_service.dart';
import '../constants/app_constants.dart';
import 'no_results_screen.dart';
import 'item_detail_screen.dart';
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

class _ResultsScreenState extends State<ResultsScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Item>? _searchResults;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _performSearch();
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NoResultsScreen(searchQuery: widget.searchQuery),
          ),
        );
      });
    } else if (results.length == 1) {
      // Navigate directly to ItemDetailScreen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailScreen(
              item: results.first,
              isFromCreation: false,
            ),
          ),
        );
      });
    }
    // If multiple results, stay on this screen and show ListView
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6CC), // Fond jaune très pâle
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _isLoading 
              ? 'RECHERCHE...' 
              : 'RÉSULTATS (${_searchResults?.length ?? 0} OBJETS)',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Chargement...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
        ),
      );
    }

    final results = _searchResults!;
    
    // This should only be reached if there are multiple results
    if (results.length > 1) {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: results.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
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
