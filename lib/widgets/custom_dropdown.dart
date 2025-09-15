import 'package:flutter/material.dart';

/// Widget dropdown personnalisé sans icône
class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final String labelText;
  final bool isRequired;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool isExpanded;
  final double? fontSize;
  final Widget? suffixIcon;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.labelText,
    required this.items,
    required this.onChanged,
    this.isRequired = false,
    this.validator,
    this.isExpanded = false,
    this.fontSize,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: isExpanded,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: fontSize,
      ),
      iconEnabledColor: Colors.black,
      dropdownColor: UnifiedTheme.primaryYellow, // Couleur de fond du dropdown
      decoration: InputDecoration(
        labelText: isRequired ? '$labelText *' : labelText,
        labelStyle: const TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: UnifiedTheme.primaryYellow, // Couleur de fond du champ
        // Le contentPadding vient du thème global
      ),
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }
}

/// Widget dropdown personnalisé avec icône
class CustomIconDropdown<T> extends StatelessWidget {
  final T? value;
  final String labelText;
  final bool isRequired;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final String iconAsset;
  final bool isExpanded;
  final double? fontSize;
  final Widget? suffixIcon;

  const CustomIconDropdown({
    super.key,
    required this.value,
    required this.labelText,
    required this.items,
    required this.onChanged,
    required this.iconAsset,
    this.isRequired = false,
    this.validator,
    this.isExpanded = false,
    this.fontSize,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: isExpanded,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: fontSize,
      ),
      iconEnabledColor: Colors.black,
      dropdownColor: UnifiedTheme.primaryYellow, // Couleur de fond du dropdown
      decoration: InputDecoration(
        labelText: isRequired ? '$labelText *' : labelText,
        labelStyle: const TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 12,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(
              2.0), // Réduit pour uniformiser la hauteur avec les autres champs
          child: Image.asset(
            iconAsset,
            width: 32,
            height: 32,
            color: Colors.black, // Couleur de l'icône
          ),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: UnifiedTheme.primaryYellow, // Couleur de fond du champ
      ),
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
