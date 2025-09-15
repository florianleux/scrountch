import 'package:flutter/material.dart';
import 'custom_buttons.dart';
import '../theme/unified_theme.dart';

/// Widget réutilisable pour les dialogues de confirmation
/// Suit le style standardisé de l'application
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final String? confirmIconPath;
  final String? cancelIconPath;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    this.confirmIconPath,
    this.cancelIconPath,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: UnifiedTheme.primaryYellow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'DelaGothicOne',
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      content: Text(
        content,
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
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              text: confirmText,
              iconPath: confirmIconPath,
            ),
            const SizedBox(height: 10),
            TertiaryButton(
              onPressed: onCancel ?? () => Navigator.of(context).pop(),
              text: cancelText,
              iconPath: cancelIconPath,
            ),
          ],
        ),
      ],
    );
  }

  /// Helper pour afficher un dialogue de confirmation simple
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required String cancelText,
    String? confirmIconPath,
    String? cancelIconPath,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => ConfirmationDialog(
            title: title,
            content: content,
            confirmText: confirmText,
            cancelText: cancelText,
            confirmIconPath: confirmIconPath,
            cancelIconPath: cancelIconPath,
            onConfirm: () => Navigator.of(context).pop(true),
            onCancel: () => Navigator.of(context).pop(false),
          ),
        ) ??
        false;
  }

  /// Helper spécifique pour la confirmation de suppression
  static Future<void> showDeleteConfirmation({
    required BuildContext context,
    required String itemName,
    required VoidCallback onConfirm,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Confirmer la suppression',
        content: 'Êtes-vous sûr de vouloir supprimer "$itemName" ?',
        confirmText: 'SUPPRIMER',
        cancelText: 'ANNULER',
        confirmIconPath: 'assets/images/trash_icon.png',
        cancelIconPath: 'assets/images/cross_icon.png',
        onConfirm: onConfirm,
      ),
    );
  }
}
