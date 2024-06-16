import 'package:flutter/material.dart';

class MarketplacePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          MarketplaceCard(
            title: 'Buy and Sell products in your locality',
            description:
                'List products and connect with buyers\nConnect with individuals selling products',
            image: AssetImage(
                'assets/images/buy_sell products.png'), // Replace with actual asset path
          ),
          SizedBox(height: 16.0),
          MarketplaceCard(
            title: 'Search for Properties for Rent in your locality',
            description:
                'Access the Rooms, Flats and other properties listed for rent\nList properties for rent for free',
            image: AssetImage(
                'assets/images/Rentals.png'), // Replace with actual asset path
          ),
          SizedBox(height: 16.0),
          MarketplaceCard(
            title: 'Search properties for sale in your locality',
            description:
                'Connect with all kinds of property sellers in your locality\nList properties for sale for free',
            image: AssetImage(
                'assets/images/Real Estate.png'), // Replace with actual asset path
          ),
        ],
      ),
    );
  }
}

class MarketplaceCard extends StatelessWidget {
  final String title;
  final String description;
  final ImageProvider image;

  const MarketplaceCard({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            Image(
              image: image,
              width: 60,
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
