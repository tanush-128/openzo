import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/cart.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/sale.dart';

class CartsProvider extends ChangeNotifier {
  CartsProvider();

  // final List<Cart> _carts = [];

  final Map<Cart, List<Product>> _cartsWithProducts = {};
  Map<Cart, List<Product>> get cartsWithProducts => _cartsWithProducts;

  List<Cart> get carts => _cartsWithProducts.keys.toList();

  void addCart(Cart cart) {
    _cartsWithProducts[cart] = [];
    notifyListeners();
  }

  void removeCart(Cart cart) {
    _cartsWithProducts.remove(cart);
    notifyListeners();
  }

  void clearCarts() {
    _cartsWithProducts.clear();
    notifyListeners();
  }

  void updateCart(Cart cart) {
    _cartsWithProducts[cart] = [];
    notifyListeners();
  }

  void updateCartOrderItems(Product product, int quantity) {
    bool found = false;
    _cartsWithProducts.forEach((cart, products) {
      if (cart.storeId == product.storeID) {
        found = true;
        if (products.contains(product)) {
          for (var orderItem in cart.orderItems) {
            if (orderItem.productId == product.id) {
              orderItem.quantity = quantity;
            }
          }
        } else {
          products.add(product);
          cart.orderItems.add(OrderItem(
            id: 0,
            orderId: "",
            productId: product.id,
            quantity: quantity,
          ));
        }
        cart.total = products.fold(
            0,
            (previousValue, element) =>
                previousValue + element.discountPrice * quantity);
      }
    });

    if (!found) {
      Cart cart = Cart(
        id: 0,
        storeId: product.storeID,
        userDataId: 0,
        total: 0,
        orderItems: [
          OrderItem(
            id: 0,
            orderId: "",
            productId: product.id,
            quantity: quantity,
          )
        ],
      );

      cart.total = product.discountPrice * quantity;

      _cartsWithProducts[cart] = [product];
    }
    notifyListeners();
  }
}
