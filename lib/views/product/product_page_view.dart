import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/views/product/widgets/carousel.dart';
import 'package:openzo_frontend/views/product/widgets/more_by_same_selller.dart';
import 'package:openzo_frontend/views/product/widgets/productPageSkeleton.dart';
import 'package:openzo_frontend/views/product/widgets/similar_products.dart';
import 'package:openzo_frontend/views/widgets/global_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:openzo_frontend/viewmodels/product_page_view_model.dart';

import 'package:openzo_frontend/viewmodels/sales_provider.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  const ProductPage({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          ProductPageViewModel()..fetchProduct(widget.productId),
      child: Consumer<ProductPageViewModel>(
        builder: (context, viewModel, child) {
          return viewModel.isLoading
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
                        onPressed: viewModel.shareProduct,
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
                    child: !Provider.of<SalesProvider>(context)
                            .isInCart(viewModel.product.id)
                        ? ElevatedButton(
                            onPressed: () {
                              Provider.of<SalesProvider>(context, listen: false)
                                  .updateSaleOrderItems(
                                      viewModel.product,
                                      viewModel.selectedSize,
                                      viewModel.selectedColor,
                                      1);
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
                        : ElevatedButton(
                            onPressed: () {
                              context.go(
                                  '/cart/${Provider.of<SalesProvider>(context, listen: false).getSaleByStoreId(viewModel.product.storeID).id}');
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
                            child: ProductImagesCarousel(
                                images: viewModel.product.images)),

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
                                viewModel.product.name.toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),

                              // Product Description
                              if (viewModel.product.description != "")
                                Text(
                                  viewModel.product.description,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              const SizedBox(height: 16),

                              // Price
                              viewModel.product.mrp !=
                                      viewModel.product.discountPrice
                                  ? Row(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                                Icons.arrow_downward_rounded,
                                                color: GlobalStyle.primaryColor,
                                                size: 16),
                                            Text(
                                              '${((viewModel.product.mrp - viewModel.product.discountPrice) / viewModel.product.mrp * 100).toStringAsFixed(0)}%',
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
                                          '₹ ${viewModel.product.mrp}',
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '₹${viewModel.product.discountPrice}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      '₹ ${viewModel.product.mrp}',
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
                        if (viewModel.product.sizeVariants.isNotEmpty)
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                const Text(
                                  'Size:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 16),
                                SizeOptions(
                                    sizes: viewModel.product.sizeVariants,
                                    selectedSize: viewModel.selectedSize,
                                    onSizeSelected: viewModel.selectSize),
                              ],
                            ),
                          ),
                        const SizedBox(height: 4),

                        // Color Options
                        if (viewModel.product.colorVariants.isNotEmpty)
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                const Text(
                                  'Color:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 16),
                                ColorOptions(
                                    colors: viewModel.product.colorVariants,
                                    selectedColor: viewModel.selectedColor,
                                    onColorSelected: viewModel.selectColor),
                              ],
                            ),
                          ),
                        const Divider(),
                        const SizedBox(height: 4),
                        MoreBySameSeller(product: viewModel.product),
                        const SizedBox(height: 4),
                        SimilarProducts(product: viewModel.product),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
        },
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
