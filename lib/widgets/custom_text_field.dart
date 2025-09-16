import 'package:flutter/material.dart';
import '../theme/unified_theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final int? maxLength;
  final int? maxLines;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final bool filled;
  final Color? fillColor;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.maxLength,
    this.maxLines = 1,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
    this.filled = true, // Par défaut true pour utiliser le fond jaune du thème
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: UnifiedTheme.inputHeight,
      child: TextFormField(
        controller: controller,
        style: UnifiedTheme.textFieldStyle,
        maxLength: maxLength,
        maxLines: maxLines,
        validator: validator,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          filled: filled,
          fillColor: fillColor ?? UnifiedTheme.primaryYellow,
          contentPadding: UnifiedTheme.inputContentPadding,
          // Le reste du style vient du thème global inputDecorationTheme
        ),
      ),
    );
  }
}
