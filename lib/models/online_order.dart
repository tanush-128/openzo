// type OrderStatus string

// const (
// 	OrderPlaced    OrderStatus = "placed"
// 	OrderAccepted  OrderStatus = "accepted"
// 	OrderRejected  OrderStatus = "rejected"
// 	OrderDelivered OrderStatus = "delivered"
// )

// type OnlineOrder struct {
// 	ID          int         `json:"id"`
// 	OrderItems  []OrderItem `json:"order_items"`
// 	Customer    Customer    `json:"customer"`
// 	OrderTime   string      `json:"order_time"`
// 	OrderDate   string      `json:"order_date"`
// 	OrderStatus OrderStatus `json:"order_status"`
// 	TotalAmount float64     `json:"total_amount"`
// 	StoreID     int         `json:"store_id"`
// }

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/sale.dart';

enum OrderStatus {
  placed,
  accepted,
  rejected,
  delivered,
}

class OnlineOrder {
  final int id;
  final List<OrderItem> orderItems;
  final Customer customer;
  final DateTime orderTime;

  final OrderStatus orderStatus;
  final double totalAmount;
  final int storeId;

  OnlineOrder({
    required this.id,
    required this.orderItems,
    required this.customer,
    required this.orderTime,
    required this.orderStatus,
    required this.totalAmount,
    required this.storeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_items': orderItems.map((e) => e.toJson()).toList(),
      'customer': customer.toJson(),
      'order_time': orderTime.toIso8601String(),
      'order_status': orderStatus.name,
      'total_amount': totalAmount,
      'store_id': storeId,
    };
  }

  static Future<List<OnlineOrder>> getOrders(int storeId) async {
    final response = await http.get(
      Uri.parse('${GlobalConsts.backend_url}/online_orders?store_id=$storeId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)
          .map((e) => OnlineOrder.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  // onlineOrder.GET("/changeStatus/:id", router.ChangeStatus)
  static Future<void> changeStatus(int id, OrderStatus status) async {
    final response = await http.get(
      Uri.parse(
          '${GlobalConsts.backend_url}/online_orders/changeStatus/$id?status=${status.name}'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to change status');
    }
  }

  static Future<OnlineOrder> createOnlineOrder(OnlineOrder onlineOrder) async {
    print(jsonEncode(onlineOrder.toJson()));
    final response = await http.post(
      Uri.parse('${GlobalConsts.backend_url}/online_order/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(onlineOrder.toJson()),
    );

    if (response.statusCode == 200) {
      return OnlineOrder.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create order');
    }
  }

  factory OnlineOrder.fromJson(Map<String, dynamic> json) {
    return OnlineOrder(
      id: json['id'],
      storeId: json['store_id'],
      orderItems: List<OrderItem>.from(
          json['order_items'].map((x) => OrderItem.fromJson(x))),
      customer: Customer.fromJson(json['customer']),
      orderTime: DateTime.parse(json['order_time']),
      orderStatus:
          OrderStatus.values.firstWhere((e) => e.name == json['order_status']),
      totalAmount: json['total_amount'] * 1.0,
    );
  }
}
