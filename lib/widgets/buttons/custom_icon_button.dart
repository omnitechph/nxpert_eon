import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Icon? icon;
  final String label;
  final Color backgroundColor;
  final double borderRadius;

  const CustomIconButton({super.key, this.onPressed, this.icon, required this.label, this.backgroundColor = const Color(0xFF0099FC), this.borderRadius = 0});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: backgroundColor, minimumSize: const Size(100, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius))),
      icon: icon,
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 18)),
    );
  }
}
