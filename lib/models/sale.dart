class Sale {
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
  DateTime? bookingTime;

  Sale({
    this.id = "",
    this.orderItems = const [],
    this.customer,
    this.orderTime,
    this.totalAmount = 0.0,
    this.undiscountedTotalAmount = 0.0,
    this.amountPaid = 0.0,
    this.paymentMode,
    required this.storeId,
    this.type = "online_order",
    this.status = "not_placed",
    this.tableId,
    this.occupants,
    this.note,
    this.bookingTime,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      orderItems: (json['order_items'] as List)
          .map((x) => OrderItem.fromJson(x))
          .toList(),
      customer:
          json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      orderTime: DateTime.tryParse(json['order_time'] ?? ""),
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
      bookingTime: DateTime.tryParse(json['booking_time'] ?? ""),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_items': orderItems.map((e) => e.toJson()).toList(),
      'customer': customer?.toJson(),
      'order_time': orderTime?.toString() ?? DateTime.now().toString(),
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
      'booking_time': bookingTime?.toIso8601String(),
    };
  }
}

// models/customer.dart
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

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      phone: json['phone'],
      address: json['address'],
      userDataId: json['user_data_id'],
      saleId: json['sale_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'address': address,
      'user_data_id': userDataId,
      'sale_id': saleId,
    };
  }
}

// models/order_item.dart
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
}
