import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/src/product/widgets/vertical_product_card.dart';

class SimilarProducts extends StatefulWidget {
  final Product product;
  const SimilarProducts({
    super.key,
    required this.product,
  });

  @override
  State<SimilarProducts> createState() => _SimilarProductsState();
}

class _SimilarProductsState extends State<SimilarProducts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Similar Products',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width * 0.5 + 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
            ),
            child: FutureBuilder(
                future: Product.searchProducts("576104", widget.product.name),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('An error occurred'),
                    );
                  }
                  List<Product> products = snapshot.data as List<Product>;
                  products.removeWhere(
                    (element) =>
                        element.id == widget.product.id ||
                        element.type == "post",
                  );
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        child: VerticalProductCard(
                          product: products[index],
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
