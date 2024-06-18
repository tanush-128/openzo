import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/components/globalSearchBar.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/providers/sales_provider.dart';
import 'package:provider/provider.dart';

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
    // TODO: implement initState
    super.initState();
    fetchProduct().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: const Padding(
                padding: EdgeInsets.all(8.0),
                child: GlobalSearchBar(),
              ),
              centerTitle: true,
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
                        Text(
                          product.description,
                          style: const TextStyle(fontSize: 16),
                        ),

                        const SizedBox(height: 16),

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
                            sizes: product.sizeVariants
                                .map((e) => e.size)
                                .toList()),
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
                        const Text(
                          'Color:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 16),
                        ColorOptions(
                            colors: product.colorVariants
                                .map((e) => e.color)
                                .toList()),
                      ],
                    ),
                  ),

                  const Divider(),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
  }
}

class ProductImagesCarousel extends StatelessWidget {
  final List<ProductImage> images;

  ProductImagesCarousel({required this.images});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: images.map((image) {
        return Image.network(image.image,
            fit: BoxFit.contain, width: MediaQuery.of(context).size.width,
            errorBuilder: (context, error, stackTrace) {
          return const Image(
            image: AssetImage('assets/images/placeholder.png'),
            fit: BoxFit.contain,
            width: 400,
            height: 400,
          );
        });
      }).toList(),
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 1,
        viewportFraction: 1,
        // enlargeCenterPage: true,
        // enlargeStrategy: CenterPageEnlargeStrategy.height,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class SizeOptions extends StatelessWidget {
  final List<String> sizes;

  SizeOptions({required this.sizes});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: sizes.map((size) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: ChoiceChip(
            label: Text(size),
            selected: false,
            onSelected: (selected) {
              // Handle size selection
            },
          ),
        );
      }).toList(),
    );
  }
}

class ColorOptions extends StatelessWidget {
  final List<String> colors;

  ColorOptions({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: colors.map((color) {
        return ChoiceChip(
          label: Text(color),
          selected: false,
          onSelected: (selected) {
            // Handle color selection
          },
        );
      }).toList(),
    );
  }
}
