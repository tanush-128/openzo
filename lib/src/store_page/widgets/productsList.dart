import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/viewmodels/products_provider.dart';
import 'package:openzo_frontend/src/product/widgets/filter_bar.dart';
import 'package:openzo_frontend/src/product/widgets/product_card.dart';
import 'package:openzo_frontend/src/product/widgets/product_card_2.dart';
import 'package:openzo_frontend/src/product/widgets/service_card.dart';
import 'package:openzo_frontend/src/product/widgets/vertical_product_card.dart';
import 'package:provider/provider.dart';

class ProductsList extends StatefulWidget {
  ProductsList({
    super.key,
    this.storeType,
    this.store,
    this.addableToCart = false,
  });

  StoreType? storeType;
  final Store? store;
  final bool addableToCart;

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  Map<String, List<Product>> categories = {};

  Map<String, GlobalKey> categoryKeys = {};

  Map<String, List<Product>> categorizeProducts(List<Product> products) {
    Map<String, List<Product>> categories = {};
    for (var product in products) {
      if (!categories.containsKey(product.category)) {
        categories[product.category] = [];
        categoryKeys[product.category] =
            GlobalKey(); // Initialize key here if it does not exist
      }
      categories[product.category]!.add(product);
    }
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsProvider>(
      builder: (context, productsProvider, child) {
        final products = productsProvider.filteredProducts;
        categories = categorizeProducts(products);

        return Stack(
          children: [
            Column(
              children: [
                const FilterBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.blueGrey.shade50),
                      child: Accordion(
                        disableScrolling: true,
                        openAndCloseAnimation: false,
                        contentBorderColor: Colors.transparent,
                        headerBorderRadius: 0,
                        headerBackgroundColor: Colors.white,
                        paddingListHorizontal: 0,
                        headerPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        contentVerticalPadding: 0,
                        rightIcon: const Icon(
                          Icons.arrow_drop_down,
                          size: 32,
                        ),
                        maxOpenSections: 10,
                        children: categories.keys.map((category) {
                          return AccordionSection(
                            isOpen: true,
                            header: Text(
                              key: categoryKeys[category],
                              category,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            content: Container(
                              color: Colors.grey.shade50,
                              padding: EdgeInsets.zero,
                              child: _buildContent(category),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: CategoryMenu(
                categoryKeys: categoryKeys,
                categories: categories,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(String categoryKey) {
    var products = categories[categoryKey]!;
    if (widget.store?.subCategory == "Grocery stores") {
      return Container(
        height: 260,
        padding: const EdgeInsets.only(
          bottom: 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: SizedBox(
                // width: 200,
                width: MediaQuery.of(context).size.width * 0.35,

                height: 240,
                child: ProductCard2(
                  product: products[index],
                ),
              ),
            );
          },
        ),
      );
    }
    switch (widget.storeType) {
      case StoreType.food:
        return _buildListView(
            products,
            (product) => ProductCard(
                  product: product,
                  // cart: widget.cart,
                  addableToCart: widget.addableToCart,
                ));
      case StoreType.service:
        return _buildListView(
          products,
          // (product) => ServiceCard(product: product),
          (product) => ServiceCard(
            product: product,
            // addableToCart: false,
          ),
        );
      default:
        return _buildGridView(products);
    }
  }

  Widget _buildListView(
      List<Product> products, Widget Function(Product) cardBuilder) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      children: products
          .map((product) => Padding(
                padding: const EdgeInsets.all(1.5),
                child: cardBuilder(product),
              ))
          .toList(),
    );
  }

  Widget _buildGridView(List<Product> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(0.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.56,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(1.5),
        child: VerticalProductCard(product: products[index]),
      ),
    );
  }
}

class CategoryMenu extends StatefulWidget {
  final Map<String, GlobalKey> categoryKeys;
  final Map<String, List<Product>> categories;
  const CategoryMenu(
      {super.key, required this.categoryKeys, required this.categories});

  @override
  State<CategoryMenu> createState() => _CategoryMenuState();
}

class _CategoryMenuState extends State<CategoryMenu> {
  bool categoryMenuVisible = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(bottom: 48, right: 24, child: _buildCategoryMenu()),
        Align(
          alignment: Alignment.bottomRight,
          child: _buildCatergoryMenuButton(),
        ),
      ],
    );
  }

  Widget _buildCatergoryMenuButton() {
    return InkWell(
      onTap: () {
        setState(() {
          categoryMenuVisible = !categoryMenuVisible;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCategoryMenu() {
    if (!categoryMenuVisible) {
      return const SizedBox();
    }
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      constraints: const BoxConstraints(maxHeight: 400, minHeight: 150),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            ...widget.categories.keys.map((category) {
              return InkWell(
                onTap: () {
                  Scrollable.ensureVisible(
                    widget.categoryKeys[category]!.currentContext!,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Text(
                        category,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget.categories[category]!.length.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
