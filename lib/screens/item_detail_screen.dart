import 'package:flutter/material.dart';
import '../models/item.dart';
import '../theme/app_theme.dart';
import 'item_form_screen.dart';
import 'home_screen.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;
  final bool isFromCreation;

  const ItemDetailScreen({
    super.key,
    required this.item,
    this.isFromCreation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFDD00), // Fond jaune
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          item.name.toUpperCase(),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          // Edit icon
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemFormScreen(
                    isEditMode: true,
                    existingItem: item,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Informations principales (Card)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informations principales',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Nom', item.name),
                    if (item.owner != null) _buildDetailRow('Propriétaire', item.owner!),
                    if (item.tags != null && item.tags!.isNotEmpty) 
                      _buildDetailRow('Tags', item.tags!.join(', ')),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Section Localisation (Card)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Localisation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Pièce', item.room),
                    if (item.location != null) _buildDetailRow('Location', item.location!),
                    if (item.subLocation != null) _buildDetailRow('Sous-location', item.subLocation!),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Text(
                        'Résumé: ${item.fullLocation}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Section Catégorisation (Card) - si définie
            if (item.mainCategory != null || item.subCategory != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Catégorisation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (item.mainCategory != null) 
                        _buildDetailRow('Catégorie', item.mainCategory!),
                      if (item.subCategory != null) 
                        _buildDetailRow('Sous-catégorie', item.subCategory!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Section Description (Card) - si définie
            if (item.description != null && item.description!.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.description!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Boutons contextuels selon isFromCreation
            if (isFromCreation) ...[
              // Si isFromCreation = true : ElevatedButton "Modifier" + TextButton "Retour Accueil"
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemFormScreen(
                          isEditMode: true,
                          existingItem: item,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Modifier',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text('Retour Accueil', style: TextStyle(fontFamily: 'DelaGothicOne', color: Colors.black, fontSize: 16)),
                ),
              ),
            ] else ...[
              // Si isFromCreation = false : Row[TextButton "Précédent", ElevatedButton "Modifier"] + TextButton "Retour Accueil"
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Précédent', style: TextStyle(fontFamily: 'DelaGothicOne', color: Colors.black, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemFormScreen(
                              isEditMode: true,
                              existingItem: item,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Modifier',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text('Retour Accueil', style: TextStyle(fontFamily: 'DelaGothicOne', color: Colors.black, fontSize: 16)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
