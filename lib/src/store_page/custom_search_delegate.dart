import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/src/product/product_card.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Product> _list;
  CustomSearchDelegate(this._list);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Product> searchList = _list
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: searchList.length,
      itemBuilder: (context, index) {
        return ProductCard(product: searchList[index]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Product> searchList = _list
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: searchList.length,
      itemBuilder: (context, index) {
        return ProductCard(product: searchList[index]);
      },
    );
  }
}
