import 'package:flutter/material.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/src/cart/cart_page/cart_page.dart';
import 'package:openzo_frontend/src/cart/cart_page/kSeparator.dart';
import 'package:openzo_frontend/src/home_page/widgets/store_card.dart';
import 'package:openzo_frontend/src/product/widgets/product_card.dart';
import 'package:openzo_frontend/src/product/widgets/service_card.dart';
import 'package:openzo_frontend/src/store_page/widgets/post/post_card.dart';

class SearchResultsPage extends StatefulWidget {
  final List<Store> stores;
  final List<Product> products;

  const SearchResultsPage({
    Key? key,
    required this.stores,
    required this.products,
  }) : super(key: key);

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<Store> filteredStores = [];
  List<Product> filteredProducts = [];
  String filterType = '';

  @override
  void initState() {
    super.initState();
    filteredStores = widget.stores;
    filteredProducts = widget.products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChipWidget(
                    label: 'Stores',
                    onPressed: () {
                      setState(() {
                        filteredStores = widget.stores;
                        filteredProducts = [];
                        filterType = 'store';
                      });
                    },
                    isSelected: filterType == 'store',
                  ),
                  FilterChipWidget(
                    label: 'Products',
                    onPressed: () {
                      setState(() {
                        filteredStores = [];
                        filteredProducts = widget.products
                            .where((product) => product.type == 'product')
                            .toList();
                        filterType = 'product';
                      });
                    },
                    isSelected: filterType == 'product',
                  ),
                  FilterChipWidget(
                    label: 'Food',
                    onPressed: () {
                      setState(() {
                        filteredStores = [];
                        filteredProducts = widget.products
                            .where((product) => product.type == 'food')
                            .toList();
                        filterType = 'food';
                      });
                    },
                    isSelected: filterType == 'food',
                  ),
                  FilterChipWidget(
                    label: 'Posts',
                    onPressed: () {
                      setState(() {
                        filteredStores = [];
                        filteredProducts = widget.products
                            .where((product) => product.type == 'post')
                            .toList();
                        filterType = 'post';
                      });
                    },
                    isSelected: filterType == 'post',
                  ),
                  FilterChipWidget(
                    label: 'Services',
                    onPressed: () {
                      setState(() {
                        filteredStores = [];
                        filteredProducts = widget.products
                            .where((product) => product.type == 'service')
                            .toList();
                        filterType = 'service';
                      });
                    },
                    isSelected: filterType == 'service',
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount: filteredProducts.length + filteredStores.length,
                itemBuilder: (context, index) {
                  if (index < filteredProducts.length) {
                    final product = filteredProducts[index];
                    if (product.type == 'post') {
                      return Column(
                        children: [
                          PostCard(product: product),
                          const kSeparator(),
                        ],
                      );
                    } else if (product.type == 'service') {
                      return ServiceCard(product: product);
                    } else {
                      return Column(
                        children: [
                          ProductCard(product: product),
                          const kSeparator(),
                        ],
                      );
                    }
                  } else {
                    final store =
                        filteredStores[index - filteredProducts.length];
                    return StoreCard(store: store);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSelected;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        onSelected: (bool selected) {
          if (selected) {
            onPressed();
          }
        },
        selected: isSelected,
        selectedColor: GlobalStyle.primaryColor,
      ),
    );
  }
}
