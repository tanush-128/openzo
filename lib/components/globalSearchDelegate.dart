import 'package:flutter/material.dart';
import 'package:openzo_frontend/components/search_results_page.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/src/home_page/widgets/store_card.dart';
import 'package:openzo_frontend/src/product/widgets/product_card.dart';

class GlobalSearchDelegate extends SearchDelegate {
  String intinialValue;
  GlobalSearchDelegate({this.intinialValue = ''});

  List<Store> stores = [];

  List<Product> products = [];

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
    return products.isNotEmpty || stores.isNotEmpty
        ? SearchResultsPage(stores: stores, products: products)
        : const Center(
            child: Text('No results found'),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query != '' &&
        query.isNotEmpty &&
        query.length > 2 &&
        query.trim().length > 2) {
      Product.searchProducts("576104", query).then((value) => products = value);
      Store.searchStores("576104", query).then((value) => stores = value);
    }

    return products.isNotEmpty || stores.isNotEmpty
        ? Container(
            color: Colors.grey.shade50,
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: products.length + stores.length,
              itemBuilder: (context, index) {
                return index < products.length
                    ? Padding(
                        padding: const EdgeInsets.all(1.5),
                        child: ProductCard(product: products[index]),
                      )
                    : StoreCard(store: stores[index - products.length]);
              },
            ),
          )
        : const Center(
            child: Text('No results found'),
          );
  }
}
