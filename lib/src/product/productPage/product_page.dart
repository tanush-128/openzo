import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:openzo_frontend/components/globalSearchBar.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/providers/sales_provider.dart';
import 'package:openzo_frontend/src/product/productPage/widgets/carousel.dart';
import 'package:openzo_frontend/src/product/productPage/widgets/more_by_same_selller.dart';
import 'package:openzo_frontend/src/product/productPage/widgets/productPageSkeleton.dart';
import 'package:openzo_frontend/src/product/productPage/widgets/similar_products.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  const ProductPage({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Product product;
  SizeVariant? selectedSize;
  ColorVariant? selectedColor;
  bool isLoading = true;

  Future<void> fetchProduct() async {
    product = await Product.fetchOne(widget.productId);
    selectedSize =
        product.sizeVariants.isNotEmpty ? product.sizeVariants.first : null;
    selectedColor =
        product.colorVariants.isNotEmpty ? product.colorVariants.first : null;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchProduct().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> shareProduct() async {
    try {
      final uri = Uri.parse(product.images.isNotEmpty
          ? product.images[0].image
          : ''); // Default placeholder if no image
      final response = await http.get(uri);
      final imageBytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/${product.id}.png';
      await File(path).writeAsBytes(imageBytes);

      await Share.shareXFiles([XFile(path)], text: _generateProductShareText());
    } catch (e) {
      print('Error sharing product: $e');
    }
  }

  String _generateProductShareText() {
    return '''*${product.name}*
${product.description}
Price: ~₹${product.mrp}~ ₹${product.discountPrice}
https://openzo.in/store/${product.storeID}/product/${product.id}
''';
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? ProductPageSkeleton()
        : Scaffold(
            appBar: AppBar(
              title: const Padding(
                padding: EdgeInsets.all(8.0),
                child: GlobalSearchBar(),
              ),
              centerTitle: false,
              actions: [
                //share
                IconButton(
                  onPressed: () {
                    shareProduct();
                  },
                  icon: const Icon(Icons.share),
                ),
              ],
              leadingWidth: 20,
              toolbarHeight: 74,
            ),
            backgroundColor: Colors.grey.shade50,
            bottomNavigationBar: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: !Provider.of<SalesProvider>(context).isInCart(product.id)
                  ? ElevatedButton(
                      onPressed: () {
                        // Add to cart logic
                        Provider.of<SalesProvider>(context, listen: false)
                            .updateSaleOrderItems(
                                product, selectedSize, selectedColor, 1);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Add to Cart'),
                            SizedBox(width: 32),
                            Icon(Icons.shopping_cart_checkout_sharp),
                          ],
                        ),
                      ),
                    )
                  : //view cart
                  ElevatedButton(
                      onPressed: () {
                        // Add to cart logic
                        context.go(
                            '/cart/${Provider.of<SalesProvider>(context, listen: false).getSaleByStoreId(product.storeID).id}');
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('View Cart'),
                            SizedBox(width: 32),
                            Icon(Icons.shopping_cart_checkout_sharp),
                          ],
                        ),
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
                      child: ProductImagesCarousel(images: product.images)),

                  const SizedBox(height: 4),

                  // Product Name
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 6),

                        // Product Description
                        if (product.description != "") ...[
                          Text(
                            product.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Price
                        product.mrp != product.discountPrice
                            ? Row(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.arrow_downward_rounded,
                                          color: GlobalStyle.primaryColor,
                                          size: 16),
                                      Text(
                                        '${((product.mrp - product.discountPrice) / product.mrp * 100).toStringAsFixed(0)}%',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: GlobalStyle.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '₹ ${product.mrp}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '₹${product.discountPrice}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                '₹ ${product.mrp}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Size Options
                  if (product.sizeVariants.isNotEmpty)
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Text(
                            'Size:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 16),
                          SizeOptions(
                              sizes: product.sizeVariants,
                              selectedSize: selectedSize,
                              onSizeSelected: (size) {
                                setState(() {
                                  selectedSize = size;
                                });
                              })
                        ],
                      ),
                    ),
                  const SizedBox(height: 4),
                  // Color Options
                  if (product.colorVariants.isNotEmpty)
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Text(
                            'Color:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 16),
                          ColorOptions(
                              colors: product.colorVariants,
                              selectedColor: selectedColor,
                              onColorSelected: (color) {
                                setState(() {
                                  selectedColor = color;
                                });
                              }),
                        ],
                      ),
                    ),

                  const Divider(),

                  const SizedBox(height: 4),
                  MoreBySameSeller(product: product),
                  const SizedBox(height: 4),
                  SimilarProducts(product: product),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
  }
}

class SizeOptions extends StatelessWidget {
  final List<SizeVariant> sizes;
  SizeVariant? selectedSize;
  Function(SizeVariant)? onSizeSelected;
  SizeOptions(
      {super.key, required this.sizes, this.selectedSize, this.onSizeSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: sizes.map((size) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: ChoiceChip(
            label: Text(size.size),
            selected: selectedSize == size,
            onSelected: (selected) {
              onSizeSelected!(size);
            },
          ),
        );
      }).toList(),
    );
  }
}

class ColorOptions extends StatelessWidget {
  final List<ColorVariant> colors;
  Function(ColorVariant)? onColorSelected;
  ColorVariant? selectedColor;

  ColorOptions(
      {super.key,
      required this.colors,
      this.onColorSelected,
      this.selectedColor});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: colors.map((color) {
        return ChoiceChip(
          label: Text(color.color),
          selected: selectedColor == color,
          onSelected: (selected) {
            onColorSelected!(color);
          },
        );
      }).toList(),
    );
  }
}
