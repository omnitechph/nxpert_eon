import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool? showPassword;
  final VoidCallback? onToggle;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final double radius;
  final Icon? prefixIcon;

  const CustomTextField({super.key, required this.controller, required this.hintText, required this.obscureText, this.showPassword, this.onToggle, this.onSubmitted, this.focusNode, this.keyboardType, this.radius=6, this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText && !(showPassword ?? false),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18.0),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: const BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: Colors.grey.shade400)),
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
        prefixIcon: prefixIcon,
        suffixIcon: obscureText ? IconButton(padding: const EdgeInsets.symmetric(horizontal: 16.0), icon: Icon(showPassword! ? Icons.visibility : Icons.visibility_off), onPressed: onToggle) : null,
      ),
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      keyboardType: keyboardType,
    );
  }
}
