import 'package:flutter/material.dart';

class ColorButton extends StatelessWidget {
  const ColorButton({super.key, required this.color, required this.onPressed});

  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(onTap: onPressed, borderRadius: BorderRadius.circular(16)),
    );
  }
}
