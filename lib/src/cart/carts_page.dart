import 'package:flutter/material.dart';
import 'package:openzo_frontend/providers/sales_provider.dart';
import 'package:openzo_frontend/src/cart/cart_list_tile.dart';
import 'package:provider/provider.dart';

class CartsPage extends StatelessWidget {
  const CartsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Carts'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'pending'),
              Tab(text: 'placed'),
              Tab(text: 'delivered'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CartList(status: 'not_placed'),
            CartList(status: 'placed'),
            CartList(status: 'delivered'),
          ],
        ),
      ),
    );
  }
}

class CartList extends StatelessWidget {
  final String status;

  const CartList({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final salesProvider = Provider.of<SalesProvider>(context);
    final carts = salesProvider.onlineOrders
        .where((sale) => sale.status == status)
        .toList();

    return ListView.builder(
      itemCount: carts.length,
      itemBuilder: (context, index) {
        final cart = carts[index];
        return CartListTile(cart: cart);
      },
    );
  }
}




