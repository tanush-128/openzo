import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/src/product/widgets/vertical_product_card.dart';

class MoreBySameSeller extends StatefulWidget {
  final Product product;
  const MoreBySameSeller({
    super.key,
    required this.product,
  });

  @override
  State<MoreBySameSeller> createState() => _MoreBySameSellerState();
}

class _MoreBySameSellerState extends State<MoreBySameSeller> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'More by Same Seller',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 355,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
            ),
            child: FutureBuilder(
                future: Product.fetchMany(widget.product.storeID),
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
                  final products = snapshot.data as List<Product>;
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
