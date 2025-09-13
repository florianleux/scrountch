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
      backgroundColor: const Color(0xFFFFE333), // Fond jaune uniforme
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

                  // Titre formaté comme les autres pages
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'AUCUN RÉSULTAT',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'DelaGothicOne',
                        fontSize: 38,
                        color: Colors.black,
                        height: 1.1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Contenu principal
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon de chargement
                          Image.asset(
                            'assets/images/loading.png',
                            width: 300,
                            height: 300,
                          ),

                          const SizedBox(height: 30),

                          // Message
                          Text(
                            'AUCUN OBJET TROUVÉ',
                            style: const TextStyle(
                              fontFamily: 'DelaGothicOne',
                              fontSize: 24,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 60),

                          // Bouton CHANGER LA RECHERCHE
                          SizedBox(
                            height: 75,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SearchScreen(),
                                  ),
                                );
                              },
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
                                    width: 45,
                                    height: 45,
                                    color: const Color(0xFFFFE333),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'CHANGER LA RECHERCHE',
                                    style: TextStyle(
                                      fontFamily: 'DelaGothicOne',
                                      color: Color(0xFFFFE333),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Bouton RANGER CET OBJET
                          SizedBox(
                            height: 75,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemFormScreen(
                                      isEditMode: false,
                                      initialName: searchQuery,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFE333),
                                side: const BorderSide(
                                    color: Colors.black, width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/plus_icon.png',
                                    width: 45,
                                    height: 45,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'RANGER CET OBJET',
                                    style: TextStyle(
                                      fontFamily: 'DelaGothicOne',
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
