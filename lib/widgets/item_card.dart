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

  @override
  Widget build(BuildContext context) {
    // Choisir une couleur basée sur le hash du nom de l'item

    return InkWell(
      onTap: onTap,
      splashColor: Colors.black.withOpacity(0.1),
      highlightColor: Colors.black.withOpacity(0.1),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            // Contenu principal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom de l'item (bold et grand, blanc)
                  Text(
                    item.name.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'DelaGothicOne',
                          fontSize: 24,
                          height: 0.9,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Location (plus petit, blanc transparent)
                  Text(
                    item.fullCategory,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Chivo',
                          fontSize: 12,
                        ),
                    maxLines: 2,
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
}
