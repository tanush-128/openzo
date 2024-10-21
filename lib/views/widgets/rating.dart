import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  const Rating({super.key, required this.rating});

// final StoreCard widget;
  final double rating;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(children: [
        const Icon(Icons.star, color: Colors.amber, size: 16),
        const SizedBox(width: 5),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ]),
    );
  }
}
