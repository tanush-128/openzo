import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/product.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Sale {
  final int id;
  final List<OrderItem> orderItems;
  final Customer customer;
  final DateTime orderDate;
  final String orderTime;
  final double totalAmount;
  final int storeId;

  Sale({
    required this.id,
    required this.orderItems,
    required this.customer,
    required this.orderDate,
    required this.orderTime,
    required this.totalAmount,
    required this.storeId,
  });

  static Future<List<Sale>> getSales(int storeId) async {
    var response = await http.get(
        Uri.parse('${GlobalConsts.backend_url}/sale?store_id=$storeId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      List<Sale> orders = [];
      for (var order in jsonDecode(response.body)) {
        orders.add(Sale.fromJson(order));
      }

      // jsonDecode(response.body).map((x) => Order.fromJson(x)).toList();
      // print(jsonDecode(response.body));
      return orders;
    } else {
      return [];
    }
  }

  static Future<Sale> createSale(Sale order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token not found');
    }
    var response =
        await http.post(Uri.parse('${GlobalConsts.backend_url}/sale/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': token,
            },
            body: jsonEncode({
              'order_items': order.orderItems.map((e) => e.toJson()).toList(),
              'customer': order.customer.toJson(),
              'order_date': order.orderDate.toString(),
              'order_time': order.orderTime,
              'total_amount': order.totalAmount,
              'store_id': order.storeId,
            }));
    if (response.statusCode == 200) {
      return Sale.fromJson(jsonDecode(response.body));
    } else {
      return Sale(
        id: 0,
        orderItems: [],
        customer:
            Customer(id: 0, phone: '', address: '', userDataId: 0, saleId: 0),
        orderDate: DateTime.now(),
        orderTime: '',
        totalAmount: 0.0,
        storeId: 0,
      );
    }
  }

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      storeId: json['store_id'],
      orderItems: List<OrderItem>.from(
          json['order_items'].map((x) => OrderItem.fromJson(x))),
      customer: Customer.fromJson(json['customer']),
      orderDate: DateTime.parse(json['order_date']),
      orderTime: json['order_time'],
      totalAmount: json['total_amount'] * 1.0,
    );
  }

  void add(Sale element) {}
}

// type Customer struct {
// 	ID         int    `json:"id"`
// 	Phone      string `json:"phone"`
// 	Address    string `json:"address"`
// 	UserDataId int    `json:"user_data_id"`
// 	SaleId     int    `json:"sale_id"`
// }

class Customer {
  int id;
  String phone;
  String address;
  int userDataId;
  int saleId;

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
  final int productId;
  final int orderId;
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
