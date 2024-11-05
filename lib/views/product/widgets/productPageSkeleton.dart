import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductPageSkeleton extends StatelessWidget {
  const ProductPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 200,
              height: 24,
              color: Colors.grey[300],
            ),
          ),
        ),
        centerTitle: true,
        leadingWidth: 20,
        toolbarHeight: 74,
      ),
      backgroundColor: Colors.grey.shade50,
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(12),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 48,
            color: Colors.grey[300],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Images Carousel
            Container(
              color: Colors.white,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 200,
                  color: Colors.grey[300],
                ),
              ),
            ),
            const SizedBox(height: 4),

            // Product Name
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: 24,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: 16,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 100,
                      height: 18,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),

            // Size Options
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 40,
                      height: 18,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 200,
                      height: 18,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),

            // Color Options
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 40,
                      height: 18,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 200,
                      height: 18,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),

            const SizedBox(height: 4),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 150,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 4),

            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 150,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
