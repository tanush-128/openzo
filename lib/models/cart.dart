// package models

// type Cart struct {
// 	ID         int         `json:"id"`
// 	OrderItems []OrderItem `json:"order_items"`
// 	UserDataId int         `json:"user_data_id"`
// 	StoreID    int         `json:"store_id"`
// }

import 'package:openzo_frontend/models/sale.dart';

class Cart {
  final int id;
  List<OrderItem> orderItems;
  final int userDataId;
  final String storeId;
  int total;

  Cart({
    required this.id,
    required this.orderItems,
    required this.userDataId,
    required this.storeId,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_items': orderItems.map((e) => e.toJson()).toList(),
      'user_data_id': userDataId,
      'store_id': storeId,
      'total': total,
    };
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      orderItems: List<OrderItem>.from(
          json['order_items'].map((x) => OrderItem.fromJson(x))),
      userDataId: json['user_data_id'],
      storeId: json['store_id'],
      total: json['total'],
    );
  }
}
