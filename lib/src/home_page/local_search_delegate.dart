import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/src/product/product_card.dart';

class LocalSearchDelegate extends SearchDelegate {
  String intinialValue;
  LocalSearchDelegate({this.intinialValue = ''});

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

  @override
  Widget buildSuggestions(BuildContext context) {
    Product.searchProducts("123456", query).then((value) => products = value);
    Store.searchStores("123456", query).then((value) => stores = value);
    

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
