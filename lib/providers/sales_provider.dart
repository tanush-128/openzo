import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/models/user.dart';

class SalesProvider extends ChangeNotifier {
  SalesProvider();

  User _user = User(
    id: "",
    phone: "",
  );

  List<Sale> _onlineOrders = [];
  List<Sale> get onlineOrders => _onlineOrders;

  List<Sale> get placedOrders => _getPlacedOrders(_onlineOrders);

  List<Sale> _getPlacedOrders(List<Sale> orders) {
    List<Sale> _placedOrders = [];

    for (var order in orders) {
      if (order.status != "not_placed" &&
          order.status != "delivered" &&
          order.status != "rejected" &&
          order.status != "cancelled" &&
          order.status != "completed") {
        _placedOrders.add(order);
      }

      if ((order.status == "rejected" || order.status == "cancelled") &&
          order.orderTime!
              .isAfter(DateTime.now().subtract(const Duration(minutes: 30)))) {
        _placedOrders.add(order);
      }
    }
    return _placedOrders;
  }

  List<Sale> get unplacedOrders =>
      _onlineOrders.where((element) => element.status == "not_placed").toList();

  List<Sale> get completedOrders => _onlineOrders
      .where((element) =>
          element.status == "delivered" ||
          element.status == "cancelled" ||
          element.status == "rejected" ||
          element.status == "completed")
      .toList();

  bool _fetching = true;
  bool get fetching => _fetching;

  Future<void> getOrders() async {
    final orders = await Sale.getSalesByUserID();

    final orderIds = _onlineOrders.map((order) => order.id).toSet();

    for (var element in orders) {
      if (element.orderItems.isEmpty || element.totalAmount <= 0) {
        await Sale.deleteSale(element.id);
      } else {
        if (!orderIds.contains(element.id)) {
          _onlineOrders.add(element);
        } else {
          int index =
              _onlineOrders.indexWhere((order) => order.id == element.id);
          if (index != -1) {
            _onlineOrders[index] = element;
          }
        }
      }
    }

    _fetching = false;
    notifyListeners();
  }

  Future<void> setUser(User user) async {
    _user = user;
    notifyListeners();
  }

  Future<void> sortOnlineOrders() async {
    _onlineOrders.sort((a, b) => a.orderTime!.compareTo(b.orderTime!) * -1);
    notifyListeners();
  }

  Future<void> updateOrderStatus(String id, String orderStatus) async {
    int index = _onlineOrders.indexWhere((element) => element.id == id);
    if (index == -1) {
      return;
    }
    print("Updating at $index");
    _onlineOrders[index].status = orderStatus;

    notifyListeners();
  }

  Future<void> addSale(Sale onlineOrder) async {
    Customer _customer = Customer(
      id: 0,
      phone: _user.phone,
      userDataId: _user.id,
      address: _user.address ?? "",
    );
    onlineOrder.customer = _customer;
    Sale _onlineOrder = await Sale.createSale(onlineOrder);
    _onlineOrders.add(_onlineOrder);

    notifyListeners();
  }

  Future<void> fetchSaleById(String id) async {
    Sale _onlineOrder = await Sale.getSaleByID(id);
    if (_onlineOrders.indexWhere((element) => element.id == id) == -1) {
      _onlineOrders.add(_onlineOrder);
    } else {
      _onlineOrders[_onlineOrders.indexWhere((element) => element.id == id)] =
          _onlineOrder;
    }
    notifyListeners();
  }

  Future<void> updateSale(Sale onlineOrder) async {
    Sale _onlineOrder = await Sale.updateSale(onlineOrder);
    _onlineOrders[_onlineOrders
        .indexWhere((element) => element.id == onlineOrder.id)] = _onlineOrder;
    notifyListeners();
  }

  Future<void> deleteSale(String id) async {
    await Sale.deleteSale(id);
    _onlineOrders.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<void> updateSaleOrderItems(Product product, SizeVariant? sizeVariant,
      ColorVariant? colorVariant, int quantity,
      {bool isService = false}) async {
    if (quantity < 0) {
      return;
    }

    if (_onlineOrders
            .where((element) => element.status == "not_placed")
            .map((e) => e.storeId)
            .contains(product.storeID) ==
        false) {
      await addSale(
        Sale(
          orderItems: [
            OrderItem(
              productId: product.id,
              quantity: quantity,
              colorVariantId: colorVariant?.id,
              sizeVariantId: sizeVariant?.id,
            )
          ],
          totalAmount: product.discountPrice * quantity * 1.0,
          storeId: product.storeID,
          type: isService ? "booking" : "online_order",
        ),
      );
      return;
    }

    Sale _onlineOrder = _onlineOrders
        .where((element) => element.status == "not_placed")
        .firstWhere((element) => element.storeId == product.storeID);

    int prevQuantity = _onlineOrder.orderItems
            .where((element) => element.productId == product.id)
            .firstOrNull
            ?.quantity ??
        0;

    if (_onlineOrder.orderItems
        .any((element) => element.productId == product.id)) {
      if (quantity == 0) {
        _onlineOrder.orderItems
            .removeWhere((element) => element.productId == product.id);
      } else {
        _onlineOrder
            .orderItems[_onlineOrder.orderItems
                .indexWhere((element) => element.productId == product.id)]
            .quantity = quantity;
      }
    } else {
      _onlineOrder.orderItems
          .add(OrderItem(productId: product.id, quantity: quantity));
    }
    _onlineOrder.totalAmount +=
        product.discountPrice * (quantity - prevQuantity) * 1.0;

    await updateSale(_onlineOrder);
    notifyListeners();
  }

  Sale getSaleByStoreId(String storeId) {
    return _onlineOrders.firstWhere(
        (element) => (element.storeId == storeId &&
            element.status != "delivered" &&
            element.status != "cancelled" &&
            element.status != "rejected" &&
            element.status != "completed"),
        orElse: () => Sale(storeId: storeId));
  }

  bool isInCart(String p) {
    return _onlineOrders
        .where((element) => element.status == "not_placed")
        .map((e) => e.orderItems)
        .expand((element) => element)
        .map((e) => e.productId)
        .contains(p);
  }
}
