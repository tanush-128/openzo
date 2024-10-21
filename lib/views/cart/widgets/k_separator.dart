import 'package:flutter/material.dart';

class kSeparator extends StatelessWidget {
  const kSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        "-------------------------------------------------------------------------------------",
        maxLines: 1,
        style: TextStyle(
          color: Colors.grey.shade300,
          fontSize: 10,
        ),
      ),
    );
  }
}
