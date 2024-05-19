import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/product.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Sale {
  //no final fields

  String id;
  List<OrderItem> orderItems;
  Customer customer;
  DateTime orderTime;
  double totalAmount;
  double amountPaid;
  String paymentMode;
  String storeId;

  Sale({
    required this.id,
    required this.orderItems,
    required this.customer,
    required this.orderTime,
    required this.totalAmount,
    required this.amountPaid,
    required this.paymentMode,
    required this.storeId,
  });
}

// type Customer struct {
// 	ID         int    `json:"id"`
// 	Phone      string `json:"phone"`
// 	Address    string `json:"address"`
// 	UserDataId int    `json:"user_data_id"`
// 	SaleId     int    `json:"sale_id"`
// }

class Customer {
  final int id;
  final String phone;
  final String address;
  int userDataId;
  final String saleId;

  Customer({
    required this.id,
    required this.phone,
    required this.address,
    required this.userDataId,
    required this.saleId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'address': address,
      'user_data_id': userDataId,
      'sale_id': saleId,
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      phone: json['phone'],
      address: json['address'],
      userDataId: json['user_data_id'],
      saleId: json['sale_id'],
    );
  }
}

class OrderItemWithProduct {
  OrderItem order;
  Product product;

  OrderItemWithProduct(this.order, this.product);
}

class OrderItem {
  final int id;
  final String productId;
  final String orderId;
  int quantity = 0;

  OrderItem({
    required this.id,
    required this.productId,
    required this.orderId,
    this.quantity = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'sale_id': orderId,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      productId: json['product_id'],
      orderId: json['sale_id'],
      quantity: json['quantity'],
    );
  }
}
