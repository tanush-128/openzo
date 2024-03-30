import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/cart.dart';
import 'package:openzo_frontend/providers/carts_provider.dart';
import 'package:openzo_frontend/src/cart/cart_list_tile.dart';
import 'package:provider/provider.dart';

class CartsPage extends StatefulWidget {
  const CartsPage({super.key});

  @override
  State<CartsPage> createState() => _CartsPageState();
}

class _CartsPageState extends State<CartsPage> {


  @override
  Widget build(BuildContext context) {
    

    return Consumer<CartsProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Carts'),
          ),
          body: Center(
              child: ListView.builder(
                  itemCount: value.carts.length,
                  itemBuilder: (context, index) {
                    return CartListTile(cart: value.carts[index]);
                  })),
        );
      },
    );
  }
}
