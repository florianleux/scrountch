import 'package:flutter/material.dart';
import '../theme/unified_theme.dart';

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
    return SizedBox(
      height: UnifiedTheme.inputHeight,
      child: DropdownButtonFormField<T>(
        value: value,
        isExpanded: isExpanded,
        style: TextStyle(
          color: UnifiedTheme.textBlack,
          fontWeight: FontWeight.w500,
          fontSize: fontSize ?? UnifiedTheme.inputUnifiedFontSize,
        ),
        iconEnabledColor: UnifiedTheme.textBlack,
        dropdownColor: UnifiedTheme.primaryYellow,
        decoration: InputDecoration(
          labelText: isRequired ? '$labelText *' : labelText,
          labelStyle: const TextStyle(
            fontSize: UnifiedTheme.inputUnifiedFontSize,
            color: UnifiedTheme.textBlack,
            fontWeight: FontWeight.w500,
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: UnifiedTheme.primaryYellow,
          contentPadding: UnifiedTheme.inputContentPadding,
        ),
        items: items,
        onChanged: onChanged,
        validator: validator,
      ),
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
    return SizedBox(
      height: UnifiedTheme.inputHeight,
      child: DropdownButtonFormField<T>(
        value: value,
        isExpanded: isExpanded,
        style: TextStyle(
          color: UnifiedTheme.textBlack,
          fontWeight: FontWeight.w500,
          fontSize: fontSize ?? UnifiedTheme.inputUnifiedFontSize,
        ),
        iconEnabledColor: UnifiedTheme.textBlack,
        dropdownColor: UnifiedTheme.primaryYellow,
        decoration: InputDecoration(
          labelText: isRequired ? '$labelText *' : labelText,
          labelStyle: const TextStyle(
            fontSize: UnifiedTheme.inputUnifiedFontSize,
            color: UnifiedTheme.textBlack,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: UnifiedTheme.inputContentPadding,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              iconAsset,
              width: UnifiedTheme.inputIconSize,
              height: UnifiedTheme.inputIconSize,
              color: UnifiedTheme.textBlack,
            ),
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: UnifiedTheme.primaryYellow,
        ),
        items: items,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
