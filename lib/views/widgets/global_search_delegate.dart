import 'dart:async';
import 'package:flutter/material.dart';
import 'package:openzo_frontend/repositories/product_repository.dart';
import 'package:openzo_frontend/repositories/store_repository.dart';
import 'package:openzo_frontend/views/widgets/search_results_page.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/viewmodels/user_provider.dart';
import 'package:openzo_frontend/views/home_page/widgets/store_card.dart';
import 'package:openzo_frontend/views/product/widgets/product_card.dart';
import 'package:provider/provider.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  dispose() {
    _timer?.cancel();
  }
}

class GlobalSearchDelegate extends SearchDelegate {
  String initialValue;
  GlobalSearchDelegate({this.initialValue = ''})
      : super(
          searchFieldLabel: 'Search for products, stores...',
        );

  final Debouncer _debouncer = Debouncer(milliseconds: 300);
  List<Store> stores = [];
  List<Product> products = [];

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        color: Colors.white, // Background color of the app bar
        elevation: 0, // Remove the shadow under the app bar
        iconTheme: IconThemeData(
          color: Colors.black, // Color of the leading icon (arrow back)
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Colors.grey.shade600, // Hint text color
        ),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0), // Padding inside the text field
        border: InputBorder.none, // No border around the search field
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
          color: Colors.black, // Clear icon color
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
      color: Colors.black, // Leading icon color
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return products.isNotEmpty || stores.isNotEmpty
        ? SearchResultsPage(stores: stores, products: products)
        : const Center(
            child: Text('No results found'),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty || query.trim().length < 3) {
      return const Center(child: Text('Type at least 3 characters to search'));
    }

    String pincode =
        Provider.of<UserProvider>(context, listen: false).user?.pincode ??
            '123456';

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        ProductRepository.searchProducts(pincode, query),
        StoreRepository.searchStores(pincode, query),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching suggestions'));
        } else {
          products = snapshot.data?[0] ?? [];
          stores = snapshot.data?[1] ?? [];

          if (products.isEmpty && stores.isEmpty) {
            return const Center(child: Text('No results found'));
          }

          return ListView(
            children: [
              if (products.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Products',
                      style: Theme.of(context).textTheme.headline6),
                ),
                ...products.map((product) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: ProductCard(product: product),
                    )),
              ],
              if (stores.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Stores',
                      style: Theme.of(context).textTheme.headline6),
                ),
                ...stores.map((store) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: StoreCard(store: store),
                    )),
              ],
            ],
          );
        }
      },
    );
  }

  Widget buildSearchField(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: query),
      autofocus: true,
      onChanged: (value) {
        // Optionally handle onChanged if needed
      },
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        hintText: 'Search for products, stores...',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w100,
        ),
        filled: true,
        fillColor: const Color(0xffffffff),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.all(8.0),
          child: ImageIcon(
            AssetImage('assets/icons/search.png'),
            size: 24,
            color: Colors.black,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minHeight: 24,
          minWidth: 24,
        ),
      ),
    );
  }
}
