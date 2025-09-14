import 'package:flutter/material.dart';
import '../theme/unified_theme.dart';

/// Widget pour la gestion des tags avec des chips visuels
/// Permet d'ajouter et supprimer des tags individuellement
class TagInputField extends StatefulWidget {
  final List<String>? initialTags;
  final ValueChanged<List<String>> onTagsChanged;
  final String labelText;
  final int maxTags;
  final int maxTagLength;

  const TagInputField({
    super.key,
    this.initialTags,
    required this.onTagsChanged,
    required this.labelText,
    this.maxTags = 5,
    this.maxTagLength = 20,
  });

  @override
  State<TagInputField> createState() => _TagInputFieldState();
}

class _TagInputFieldState extends State<TagInputField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.initialTags ?? []);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final trimmedTag = tag.trim();
    if (trimmedTag.isEmpty) return;
    if (_tags.contains(trimmedTag)) return;
    if (_tags.length >= widget.maxTags) return;
    if (trimmedTag.length > widget.maxTagLength) return;

    setState(() {
      _tags.add(trimmedTag);
      _controller.clear();
    });
    widget.onTagsChanged(_tags);
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
    widget.onTagsChanged(_tags);
  }

  void _onSubmitted(String value) {
    _addTag(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Champ de saisie
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.left, // Alignement à gauche explicite
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            hintText: _tags.length < widget.maxTags
                ? 'Tapez un tag et appuyez sur Entrée'
                : 'Maximum ${widget.maxTags} tags atteint',
            hintStyle: UnifiedTheme.hintStyle.copyWith(
              fontWeight: FontWeight.w500, // Encore plus en gras
            ),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: Image.asset(
                      'assets/images/plus_icon.png',
                      width: 20,
                      height: 20,
                      color: Colors.black,
                    ),
                    onPressed: () => _addTag(_controller.text),
                  )
                : null,
            filled: true,
            fillColor: const Color(0xFFFFE333),
          ),
          enabled: _tags.length < widget.maxTags,
          onFieldSubmitted: _onSubmitted,
          onChanged: (value) {
            setState(() {}); // Pour mettre à jour l'icône plus
          },
        ),

        // Affichage des tags existants
        if (_tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _tags.map((tag) {
              return Chip(
                label: Text(
                  tag,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                backgroundColor: const Color(0xFFFFE333),
                side: const BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
                deleteIcon: Image.asset(
                  'assets/images/cross_icon.png',
                  width: 16,
                  height: 16,
                  color: Colors.black,
                ),
                onDeleted: () => _removeTag(tag),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }).toList(),
          ),
        ],

        // Informations sur les limites
        if (_tags.isNotEmpty || _controller.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '${_tags.length}/${widget.maxTags} tags • Max ${widget.maxTagLength} caractères par tag',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54, // Même couleur que le compteur global
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}
