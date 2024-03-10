// package models

// type OrderItem struct {
// 	ID        int `json:"id"`
// 	ProductID int `json:"product_id"`
// 	OrderId   int `json:"order_id"`
// 	Quantity  int `json:"quantity"`
// }

// type Order struct {
// 	ID          int         `json:"id"`
// 	OrderItems  []OrderItem `json:"order_items"`
// 	Customer    Customer    `json:"customer"`
// 	OrderDate   string      `json:"order_date"`
// 	OrderTime   string      `json:"order_time"`
// 	TotalAmount float64     `json:"total_amount"`
// }

// type Customer struct {
// 	ID      int    `json:"id"`
// 	Phone   string `json:"phone"`
// 	OrderId int    `json:"order_id"`
// }

// func (router OrderServiceRouter) Router(r *gin.Engine) {

// 	order := r.Group("/order")
// 	{
// 		order.GET("/", router.GetOrders)
// 		order.GET("/:id", router.GetOrder)

// 		order.Use(JwtMiddleware)
// 		order.POST("/", router.CreateOrder)
// 		order.PUT("/:id", router.UpdateOrder)
// 		order.DELETE("/:id", router.DeleteOrder)

// 	}
// }

// func (router *OrderServiceRouter) GetOrders(c *gin.Context) {
// 	name := c.Query("name")
// 	storeId := c.Query("store_id")
// 	if name != "" {
// 		var orders []models.Order
// 		router.DB.Preload("Images").Find(&orders, "name LIKE ?", "%"+name+"%")
// 		c.JSON(200, orders)
// 		return

// 	} else if storeId != "" {
// 		var orders []models.Order
// 		router.DB.Preload("Images").Find(&orders, "store_id = ?", storeId)
// 		c.JSON(200, orders)
// 		return
// 	} else {
// 		var orders []models.Order
// 		router.DB.Preload("Customer").Preload("OrderItems").Find(&orders)
// 		c.JSON(200, orders)
// 	}
// }

// func (router *OrderServiceRouter) GetOrder(c *gin.Context) {

// 	id := c.Param("id")

// 	var order models.Order
// 	router.DB.Find(&order, id)
// 	c.JSON(200, order)
// }

// func (router *OrderServiceRouter) CreateOrder(c *gin.Context) {

// 	var order models.Order
// 	c.BindJSON(&order)
// 	router.DB.Create(&order)
// 	c.JSON(200, order)
// }

// func (router *OrderServiceRouter) UpdateOrder(c *gin.Context) {

// 	id := c.Param("id")
// 	var order models.Order
// 	router.DB.Find(&order, id)
// 	c.BindJSON(&order)
// 	router.DB.Save(&order)
// 	c.JSON(200, order)
// }

// func (router *OrderServiceRouter) DeleteOrder(c *gin.Context) {

// 	id := c.Param("id")
// 	var order models.Order
// 	router.DB.Find(&order, id)
// 	router.DB.Delete(&order)
// 	c.JSON(200, order)
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openzo_frontend/constants/constants.dart';


class Order {
  final int id;
  final List<OrderItem> orderItems;
  final Customer customer;
  final String orderDate;
  final String orderTime;
  final double totalAmount;
  final int storeId;

  Order({
    required this.id,
    required this.orderItems,
    required this.customer,
    required this.orderDate,
    required this.orderTime,
    required this.totalAmount,
    required this.storeId,
  });

  static Future<List<Order>> getOrders(int storeId) async {
    var response = await http.get(
        Uri.parse('${GlobalConsts.backend_url}/order?store_id=$storeId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': GlobalConsts.token,
        });
    if (response.statusCode == 200) {
      List<Order> orders = [];
      for (var order in jsonDecode(response.body)) {
        orders.add(Order.fromJson(order));
      }

      // jsonDecode(response.body).map((x) => Order.fromJson(x)).toList();
      // print(jsonDecode(response.body));
      return orders;
    } else {
      return [];
    }
  }

  static Future<Order> getOrder(int id) async {
    var response = await http.get(
        Uri.parse('${GlobalConsts.backend_url}/order/$id/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': GlobalConsts.token,
        });
    if (response.statusCode == 200) {
      return Order.fromJson(jsonDecode(response.body));
    } else {
      return Order(
        id: 0,
        storeId: 0,
        orderItems: [],
        customer: Customer(id: 0, phone: '', orderId: 0),
        orderDate: '',
        orderTime: '',
        totalAmount: 0.0,
      );
    }
  }

  static createOrder(Order order) async {
    var response =
        await http.post(Uri.parse('${GlobalConsts.backend_url}/order/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': GlobalConsts.token,
            },
            body: jsonEncode({
              'order_items': order.orderItems.map((e) => e.toJson()).toList(),
              'customer': order.customer.toJson(),
              'order_date': order.orderDate,
              'order_time': order.orderTime,
              'total_amount': order.totalAmount,
              'store_id': order.storeId,
            }));
    if (response.statusCode == 200) {
      return;
      // return Order.fromJson(jsonDecode(response.body));
    } else {
      return Order(
        id: 0,
        orderItems: [],
        customer: Customer(id: 0, phone: '', orderId: 0),
        orderDate: '',
        orderTime: '',
        totalAmount: 0.0,
        storeId: 0,
      );
    }
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      storeId: json['store_id'],
      orderItems: List<OrderItem>.from(
          json['order_items'].map((x) => OrderItem.fromJson(x))),
      customer: Customer.fromJson(json['customer']),
      orderDate: json['order_date'],
      orderTime: json['order_time'],
      totalAmount: json['total_amount'] * 1.0,
    );
  }
}

class Customer {
  final int id;
  final String phone;
  final int orderId;

  Customer({
    required this.id,
    required this.phone,
    required this.orderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'order_id': orderId,
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      phone: json['phone'],
      orderId: json['order_id'],
    );
  }
}

class OrderItem {
  final int id;
  final int productId;
  final int orderId;
  final int quantity;

  OrderItem({
    required this.id,
    required this.productId,
    required this.orderId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'order_id': orderId,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      productId: json['product_id'],
      orderId: json['order_id'],
      quantity: json['quantity'],
    );
  }
}
