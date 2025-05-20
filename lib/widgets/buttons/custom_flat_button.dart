import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Size minimumSize;
  final String label;

  const CustomFlatButton({super.key, required this.onPressed, required this.minimumSize, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        side: const BorderSide(color: Color(0xFFDDDDDD)),
        minimumSize: minimumSize,
        padding: EdgeInsets.zero,
      ),
      child: Text(label),
    );
  }
}
