import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final double fontSize;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor = Colors.blue,
    this.foregroundColor = Colors.white,
    this.fontSize = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}
