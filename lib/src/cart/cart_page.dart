import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  static const String routeName = '/cart';
  // static const String routeNameWithArgs = '/cart/:id';
  String id;
  CartPage({super.key, required this.id});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: const Center(
        child: Text('cart page'),
      ),
    );
  }
}
