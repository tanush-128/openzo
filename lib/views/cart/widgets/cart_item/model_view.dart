import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/viewmodels/sales_provider.dart';
import 'package:provider/provider.dart';

class CartItemViewModel with ChangeNotifier {
  final Product product;
  final Sale? cart;

  SizeVariant? selectedSize;
  ColorVariant? selectedColor;

  int get quantity =>
      cart?.orderItems
          .where((element) => element.productId == product.id)
          .firstOrNull
          ?.quantity ??
      0;

  CartItemViewModel({required this.product, this.cart});

  void updateSize(SizeVariant? size) {
    selectedSize = size;
    notifyListeners();
  }

  void updateColor(ColorVariant? color) {
    selectedColor = color;
    notifyListeners();
  }
}
