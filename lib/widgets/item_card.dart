import 'package:flutter/material.dart';
import '../models/item.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;

  const ItemCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  // Couleurs jaunes pour les cartes
  static const List<Color> _cardColors = [
    Color(0xFFFFDD00), // Jaune base
    Color(0xFFFFE333), // Jaune clair
    Color(0xFFFFE966), // Jaune moyen
    Color(0xFFFFEF99), // Jaune très clair
    Color(0xFFFFF6CC), // Jaune très pâle
    Color(0xFFFFD700), // Jaune doré
  ];

  @override
  Widget build(BuildContext context) {
    // Choisir une couleur basée sur le hash du nom de l'item
    final colorIndex = item.name.hashCode.abs() % _cardColors.length;
    final backgroundColor = _cardColors[colorIndex];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Contenu principal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom de l'item (bold et grand, blanc)
                  Text(
                    item.name,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Location (plus petit, blanc transparent)
                  Text(
                    item.fullLocation,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Flèche à droite
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.black.withOpacity(0.7),
              ),
          ],
        ),
      ),
    );
  }

  String _getItemEmoji(Item item) {
    // Retourner un emoji basé sur la catégorie ou le nom
    final category = item.mainCategory?.toLowerCase() ?? '';
    final name = item.name.toLowerCase();
    
    if (category.contains('électronique') || name.contains('télé') || name.contains('ordinateur')) {
      return '📱';
    } else if (category.contains('vêtement') || name.contains('chemise') || name.contains('pantalon')) {
      return '👕';
    } else if (category.contains('livre') || name.contains('livre')) {
      return '📚';
    } else if (category.contains('cuisine') || name.contains('couteau') || name.contains('assiette')) {
      return '🍽️';
    } else if (category.contains('sport') || name.contains('ballon')) {
      return '⚽';
    } else if (category.contains('jouet') || name.contains('jouet')) {
      return '🧸';
    } else if (category.contains('outil') || name.contains('marteau') || name.contains('tournevis')) {
      return '🔧';
    } else {
      return '📦';
    }
  }
}
