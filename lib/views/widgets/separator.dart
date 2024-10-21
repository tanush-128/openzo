import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  final String title;
  final EdgeInsets? padding;
  const Separator({
    super.key,
    required this.title,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: padding ?? const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade700,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
