import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/sale.dart';
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
              Tab(text: 'completed'),
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

class CartList extends StatefulWidget {
  final String status;

  const CartList({Key? key, required this.status}) : super(key: key);

  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SalesProvider>(builder: (context, salesProvider, child) {
      List<Sale> carts = salesProvider.onlineOrders
          .where((sale) => sale.status == widget.status)
          .toList();

      if (widget.status == 'all') {
        carts = salesProvider.onlineOrders;
      } else if (widget.status == 'placed') {
        carts = salesProvider.placedOrders;
      } else if (widget.status == 'delivered') {
        carts = salesProvider.completedOrders;
      }
      // remove carts having same order id
      carts.sort((a, b) => a.orderTime!.compareTo(b.orderTime!) * -1);
      final List<Sale> uniqueCarts = [];

      for (final cart in carts) {
        if (uniqueCarts.indexWhere((element) => element.id == cart.id) == -1) {
          uniqueCarts.add(cart);
        }
      }

      carts = uniqueCarts;

      if (carts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shopping_cart_outlined,
                size: 100,
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              const Text(
                'No carts found',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // const Icon(Icons.refresh),
                    Text('Refresh'),
                  ],
                ),
              )
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: carts.length,
        itemBuilder: (context, index) {
          final cart = carts[index];
          return CartListTile(cart: cart);
        },
      );
    });
  }
}
