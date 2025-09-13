import 'package:flutter/material.dart';

/// Widget dropdown avec recherche/autocomplétion intégrée
/// Utilise le widget Autocomplete natif de Flutter
class SearchableDropdown extends StatelessWidget {
  /// Supprime les accents d'une chaîne de caractères
  static String _removeAccents(String input) {
    const accents = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëÇçÌÍÎÏìíîïÙÚÛÜùúûüÿÑñ';
    const withoutAccents =
        'AAAAAAaaaaaaOOOOOOooooooEEEEeeeeCcIIIIiiiiUUUUuuuuyNn';

    String result = input;
    for (int i = 0; i < accents.length; i++) {
      result = result.replaceAll(accents[i], withoutAccents[i]);
    }
    return result;
  }

  final String? value;
  final List<String> items;
  final String labelText;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final bool canReset;

  const SearchableDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.labelText,
    required this.onChanged,
    this.validator,
    this.prefixIcon,
    this.canReset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: value != null ? TextEditingValue(text: value!) : null,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return items;
        }

        // Normalise le texte de recherche (minuscules + sans accents)
        final searchText = _removeAccents(textEditingValue.text.toLowerCase());

        return items.where((option) {
          // Normalise l'option (minuscules + sans accents)
          final normalizedOption = _removeAccents(option.toLowerCase());
          return normalizedOption.contains(searchText);
        });
      },
      onSelected: (String selection) {
        onChanged(selection);
      },
      fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
        // Synchroniser le controller avec la valeur sélectionnée
        if (value != null && controller.text != value) {
          controller.text = value!;
        } else if (value == null && controller.text.isNotEmpty) {
          controller.clear();
        }

        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          style: Theme.of(context).textTheme.bodySmall,
          autovalidateMode: AutovalidateMode
              .onUserInteraction, // Valide quand l'utilisateur interagit
          onTap: () {
            // Sélectionner tout le texte quand on clique dans le champ
            controller.selection = TextSelection(
              baseOffset: 0,
              extentOffset: controller.text.length,
            );
          },
          validator: (value) {
            // D'abord appliquer le validator personnalisé s'il existe
            if (validator != null) {
              final customValidation = validator!(value);
              if (customValidation != null) return customValidation;
            }

            // Ensuite vérifier que la valeur est dans la liste des options
            if (value != null && value.isNotEmpty && !items.contains(value)) {
              return 'Veuillez sélectionner une option valide dans la liste';
            }

            return null;
          },
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            // Padding très réduit si il y a une icône pour compenser la hauteur
            contentPadding: prefixIcon != null
                ? const EdgeInsets.symmetric(vertical: 2, horizontal: 16)
                : null, // Utilise le thème global si pas d'icône
            prefixIcon: prefixIcon,
            suffixIcon: canReset && value != null
                ? IconButton(
                    icon: Image.asset(
                      'assets/images/cross_icon.png',
                      width: 20,
                      height: 20,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      controller.clear();
                      onChanged(null);
                    },
                  )
                : null,
            filled: true,
            fillColor: const Color(0xFFFFE333),
            // Utilise les bordures du thème global pour la cohérence
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        final ScrollController scrollController = ScrollController();

        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: const Color(0xFFFFE333),
            borderRadius: BorderRadius.circular(8),
            elevation: 4,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight:
                    320, // Augmenté de 200 à 320 pour afficher plus de résultats
                maxWidth: 300,
              ),
              child: Scrollbar(
                controller:
                    scrollController, // Controller explicite pour la scrollbar
                thumbVisibility: true, // Scrollbar toujours visible
                thickness: 4.0,
                radius: const Radius.circular(2),
                child: ListView.builder(
                  controller:
                      scrollController, // Même controller pour le ListView
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics:
                      const AlwaysScrollableScrollPhysics(), // Toujours scrollable
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options.elementAt(index);
                    return InkWell(
                      onTap: () => onSelected(option),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
