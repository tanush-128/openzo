import 'package:flutter/material.dart';

class GlobalStyle {
  // static const Color primaryColor = Color(0xFF0D47A1);
  static const Color primaryColor = Color(0xFFCD113B);
  static const Color secondaryColor = Color(0xFFFFA900);

  static final inputDec = InputDecoration(
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
      ),
      prefixIconColor: Colors.grey.shade500,
      constraints: const BoxConstraints(maxWidth: 360, maxHeight: 60),
      // contentPadding: const EdgeInsets.all(12),
      hintStyle: TextStyle(
        color: Colors.grey.shade500,
      ),
      labelStyle: TextStyle(
        color: Colors.grey.shade500,
      ));
}
