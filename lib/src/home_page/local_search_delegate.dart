import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/src/store_page/product_card.dart';

class LocalSearchDelegate extends SearchDelegate {
  final List<String> _data = List.generate(100, (index) => 'Item $index');
  List<Store> stores = [];
  // final List<String> recentSearches = [];
  List<Product> products = [];

  // Store.getStoresWithPincode("123456");

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
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
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: _data.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_data[index]),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Product.searchProducts("123456", query).then((value) => products = value);
    Store.searchStores("123456", query).then((value) => stores = value);
    // Store.getStoresWithPincode("123456")

    // final suggestionList = query.isEmpty
    //     ? stores
    //     : products.where((element) => element.name.startsWith(query)).toList();

    return products.isNotEmpty || stores.isNotEmpty
        ? ListView.builder(
            itemCount: products.length + stores.length,
            itemBuilder: (context, index) {
              return index < products.length
                  ? ProductCard(product: products[index])
                  : ListTile(
                      title: Text(stores[index - products.length].name),
                    );
            },
          )
        : const Center(
            child: Text('No results found'),
          );
  }
}
