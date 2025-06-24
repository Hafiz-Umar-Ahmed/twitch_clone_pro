import 'package:flutter/material.dart';

class custombutton extends StatelessWidget {
  const custombutton({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
    required this.textColor,
  });
  final String text;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(0),
        ),
      ),
      onPressed: onTap,
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }
}
