import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/firebase_service.dart';
import 'home_screen.dart';
import 'item_form_screen.dart';
import '../widgets/custom_buttons.dart';

class ItemDetailScreen extends StatefulWidget {
  final Item item;
  final bool isFromCreation;

  const ItemDetailScreen({
    super.key,
    required this.item,
    this.isFromCreation = false,
  });

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE333), // Fond jaune clair
      body: Stack(
        children: [
          // Image de fond par-dessus le fond jaune
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/images/detail_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenu principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: SingleChildScrollView(
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
                    const SizedBox(height: 20),

                    // Titre de l'objet
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.item.name.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'DelaGothicOne',
                            fontSize: 30,
                            color: Colors.black,
                            height: 1.1,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'SE TROUVE DANS',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Chivo',
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    // Localisation de l'objet
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.item.fullLocation,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Chivo',
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    if (widget.item.description != null &&
                        widget.item.description!.isNotEmpty) ...[
                      const SizedBox(height: 64),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'DESCRIPTION',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'DelaGothicOne',
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.item.description!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Chivo',
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            maxLines: 20,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],

                    if (widget.item.tags != null &&
                        widget.item.tags!.isNotEmpty) ...[
                      const SizedBox(height: 64),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'TAGS',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'DelaGothicOne',
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: widget.item.tags!
                              .map((tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 6.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFE333),
                                      border: Border.all(
                                          color: Colors.black, width: 1.0),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Text(
                                      tag,
                                      style: const TextStyle(
                                        fontFamily: 'Chivo',
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],

                    const SizedBox(height: 64),

                    // Boutons d'action
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          // Bouton MODIFIER
                          PrimaryButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemFormScreen(
                                    isEditMode: true,
                                    existingItem: widget.item,
                                  ),
                                ),
                              );
                            },
                            text: 'MODIFIER',
                            iconPath: 'assets/images/pen_icon.png',
                          ),

                          const SizedBox(height: 16),

                          // Bouton SUPPRIMER
                          SecondaryButton(
                            onPressed: () => _showDeleteConfirmation(context),
                            text: 'SUPPRIMER',
                            iconPath: 'assets/images/trash_icon.png',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFE333),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          title: const Text(
            'Confirmer la suppression',
            style: TextStyle(
              fontFamily: 'DelaGothicOne',
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer "${widget.item.name}" ?',
            style: const TextStyle(
              fontFamily: 'Chivo',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          actions: [
            Column(
              children: [
                TertiaryButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _deleteItem();
                  },
                  text: 'SUPPRIMER',
                  iconPath: 'assets/images/trash_icon.png',
                ),
                const SizedBox(height: 10),
                TertiaryButton(
                  onPressed: () => Navigator.of(context).pop(),
                  text: 'ANNULER',
                  iconPath: 'assets/images/cross_icon.png',
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteItem() async {
    try {
      await _firebaseService.deleteItem(widget.item.id);
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la suppression: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
