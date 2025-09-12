import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'item_form_screen.dart';
import 'home_screen.dart';

class NoResultsScreen extends StatelessWidget {
  final String searchQuery;

  const NoResultsScreen({
    super.key,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFDD00), // Fond jaune (comme accueil)
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'AUCUN RÉSULTAT',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(50px)
            const SizedBox(height: 50),
            
            // Icon(Icons.search_off, size: 80, color: grey)
            const Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey,
            ),
            
            // SizedBox(30px)
            const SizedBox(height: 30),
            
            // Text "Aucun objet trouvé" (centré, headline6)
            Text(
              'AUCUN OBJET TROUVÉ',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.center,
            ),
            
            // SizedBox(50px)
            const SizedBox(height: 50),
            
            // OutlinedButton "Changer la recherche" (pleine largeur)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black, width: 2),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'CHANGER LA RECHERCHE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            
            // SizedBox(20px)
            const SizedBox(height: 20),
            
            // OutlinedButton "Créer un nouvel objet" (pleine largeur)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemFormScreen(
                        isEditMode: false,
                        initialName: searchQuery, // Pre-fill with search query
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black, width: 2),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'CRÉER UN NOUVEL OBJET',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            
            // Spacer
            const Spacer(),
            
            // TextButton "Retour à l'accueil"
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
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
