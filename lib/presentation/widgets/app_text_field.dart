import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.isReadOnly,
    required this.onChanged,
    required this.onSubmitted,
    this.hintText = '',
    this.controller,
    this.focusNode,
  });

  final bool isReadOnly;
  final void Function(String value) onChanged;
  final void Function() onSubmitted;
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: (_) => onSubmitted(),
      readOnly: isReadOnly,
    );
  }
}
