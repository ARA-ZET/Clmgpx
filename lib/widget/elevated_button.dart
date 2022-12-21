import 'package:flutter/material.dart';

class ElevatedBtn extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;

  const ElevatedBtn({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 18,
        ),
      ),
    );
  }
}
