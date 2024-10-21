import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StoreCardSkeleton extends StatelessWidget {
  const StoreCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: Colors.grey.shade300,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    height: 20,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 150,
                    height: 15,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    height: 15,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 100,
                    height: 15,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
