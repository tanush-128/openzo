import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sale {
//no final fields

  String id;
  List<OrderItem> orderItems;
  Customer? customer;
  DateTime? orderTime;
  double totalAmount;
  double undiscountedTotalAmount;
  double amountPaid;
  String? paymentMode;
  String storeId;

  String type;
  String status;

// Restaurant specific fields
  String? tableId;
  int? occupants;
  String? note;

  Sale({
    this.id = "",
    this.orderItems = const [],
    this.customer,
    this.orderTime,
    this.totalAmount = 0.0,
    this.amountPaid = 0.0,
    this.paymentMode,
    required this.storeId,
    this.type = "online_order",
    this.status = "not_placed",
    this.undiscountedTotalAmount = 0.0,
    this.tableId,
    this.occupants,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_items': orderItems.map((e) => e.toJson()).toList(),
      'customer': customer?.toJson(),
      'order_time':
          orderTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'total_amount': totalAmount,
      'undiscounted_amount': undiscountedTotalAmount,
      'amount_paid': amountPaid,
      'payment_mode': paymentMode,
      'store_id': storeId,
      'type': type,
      'status': status,
      'table_id': tableId,
      'occupants': occupants,
      'note': note,
    };
  }

  static String endpoint = '${GlobalConsts.backend_url}/sales';
  // static String endpoint = 'https://lnn7jf70-8082.inc1.devtunnels.ms';

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      orderItems: List<OrderItem>.from(
          json['order_items'].map((x) => OrderItem.fromJson(x))),
      customer: Customer.fromJson(json['customer']),
      orderTime: DateTime.tryParse(json['order_time']),
      totalAmount: double.parse(json['total_amount'].toString()),
      undiscountedTotalAmount:
          double.parse(json['undiscounted_amount'].toString()),
      amountPaid: double.parse(json['amount_paid'].toString()),
      paymentMode: json['payment_mode'],
      storeId: json['store_id'],
      type: json['type'],
      status: json['status'],
      tableId: json['table_id'],
      occupants: json['occupants'],
      note: json['note'],
    );
  }

  static Future<Sale> createSale(Sale sale) async {
    // sale.customer = Customer(
    //   userDataId: userDataId ?? "",
    //   phone: "",
    //   address: "",
    //   saleId: "",
    // );
    final response = await http.post(
      Uri.parse('$endpoint/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(sale.toJson()),
    );

    if (response.statusCode == 201) {
      return Sale.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create sale');
    }
  }

  static Future<Sale> getSaleByID(String id) async {
    final response = await http.get(
      Uri.parse('$endpoint/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Sale.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get sale');
    }
  }

  static Future<List<Sale>> getSalesByStoreID(String storeID) async {
    final response = await http.get(
      Uri.parse('$endpoint/store/$storeID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Sale> sales =
          body.map((dynamic item) => Sale.fromJson(item)).toList();
      return sales;
    } else {
      throw Exception('Failed to get sales');
    }
  }

  static Future<List<Sale>> getSalesByUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // String? userDataId = prefs.getString('user_data_id');
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$endpoint/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      log(response.body);
      List<dynamic> body = jsonDecode(response.body);
      // log()[0].toString());
      body.map((e) => e['customer']).forEach((element) {
        print("Customer: $element");
      });
      List<Sale> sales =
          body.map((dynamic item) => Sale.fromJson(item)).toList();
      // print("Sales customer: ${sales[0].customer?.toJson()}");
      return sales;
    } else {
      throw Exception('Failed to get sales');
    }
  }

  static Future<Sale> changeSaleStatus(String id, String status) async {
    final response = await http.put(
      Uri.parse('$endpoint/$id/status/$status'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Sale.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to change sale status');
    }
  }

  static Future<Sale> updateSale(Sale sale) async {
    final response = await http.put(
      Uri.parse('$endpoint/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(sale.toJson()),
    );

    if (response.statusCode == 200) {
      print("Updated sale: ${response.body}");
      return Sale.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update sale');
    }
  }
}

class Customer {
  int id;
  String phone;
  String address;
  String userDataId;
  String saleId;

  Customer({
    this.id = 0,
    required this.phone,
    required this.address,
    this.userDataId = "",
    this.saleId = "",
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
  int id;
  String productId;
  String orderId;
  int quantity;
  int? sizeVariantId;
  int? colorVariantId;
  OrderItem({
    this.id = 0,
    required this.productId,
    this.orderId = "",
    this.quantity = 0,
    this.sizeVariantId,
    this.colorVariantId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'sale_id': orderId,
      'quantity': quantity,
      'size_variant_id': sizeVariantId,
      'color_variant_id': colorVariantId,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      productId: json['product_id'],
      orderId: json['sale_id'],
      quantity: json['quantity'],
      sizeVariantId: json['size_variant_id'],
      colorVariantId: json['color_variant_id'],
    );
  }
}
