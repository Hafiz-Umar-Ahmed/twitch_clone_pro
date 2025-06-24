import 'package:flutter/material.dart';
import 'package:twitch_clone_pro/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.customController});
  final TextEditingController customController;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: customController,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: buttonColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: secondaryBackgroundColor, width: 2),
        ),
      ),
    );
  }
}
