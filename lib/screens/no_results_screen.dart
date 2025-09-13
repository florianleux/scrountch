import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'item_form_screen.dart';
import 'home_screen.dart';
import '../widgets/custom_buttons.dart';

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
                          PrimaryButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SearchScreen(),
                                ),
                              );
                            },
                            text: 'CHANGER LA RECHERCHE',
                            iconPath: 'assets/images/search_icon.png',
                          ),

                          const SizedBox(height: 10),

                          // Bouton RANGER CET OBJET
                          SecondaryButton(
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
                            text: 'RANGER CET OBJET',
                            iconPath: 'assets/images/plus_icon.png',
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
