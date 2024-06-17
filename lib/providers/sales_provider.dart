import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:provider/provider.dart';

class SalesProvider extends ChangeNotifier {
  SalesProvider();

  List<Sale> _onlineOrders = [];
  List<Sale> get onlineOrders => _onlineOrders;
  List<Sale> get placedOrders => _onlineOrders
      .where((element) =>
          (element.status != "not_placed" && element.status != "delivered"))
      .toList();
  List<Sale> get unplacedOrders =>
      _onlineOrders.where((element) => element.status == "not_placed").toList();
  List<Sale> get deliveredOrders =>
      _onlineOrders.where((element) => element.status == "delivered").toList();
  bool _fetching = true;
  bool get fetching => _fetching;

  Future<void> getOrders() async {
    _onlineOrders = await Sale.getSalesByUserDataID();
    print("Orders: $_onlineOrders");
    _fetching = false;
    notifyListeners();
  }

  Future<void> sortOnlineOrders() async {
    _onlineOrders.sort((a, b) => a.orderTime!.compareTo(b.orderTime!) * -1);
// notifyListeners();
  }

  Future<void> UpdateOrderStatus(String id, String orderStatus) async {
// OrderStatus status = orderStatus == "placed" ? OrderStatus.placed : orderStatus == "accepted" ? OrderStatus.accepted : orderStatus == "out_for_delivery" ? OrderStatus.out_for_delivery : orderStatus == "delivered" ? OrderStatus.delivered : orderStatus == "rejected" ? OrderStatus.rejected : OrderStatus.cancelled;
    int index = _onlineOrders.indexWhere((element) => element.id == id);
    if (index == -1) {
      return;
    }
    print("Updatind at $index");
    _onlineOrders[index].status = orderStatus;

    notifyListeners();
  }

  Future<void> addSale(Sale onlineOrder) async {
    Sale _onlineOrder = await Sale.createSale(onlineOrder);
    _onlineOrders.add(_onlineOrder);

    notifyListeners();
  }

  Future<void> updateSale(Sale onlineOrder) async {
    Sale _onlineOrder = await Sale.updateSale(onlineOrder);
    _onlineOrders[_onlineOrders
        .indexWhere((element) => element.id == onlineOrder.id)] = _onlineOrder;
    notifyListeners();
  }

// Future<void> deleteSale(String id) async {
// await Sale.deleteSale(id);
// _onlineOrders.removeWhere((element) => element.id == id);
// notifyListeners();
// }

  Future<void> updateSaleOrderItems(Product product, SizeVariant? sizeVariant,
      ColorVariant? colorVariant, int quantity) async {
    if (_onlineOrders
            .where((element) => element.status == "not_placed")
            .map((e) => e.storeId)
            .contains(product.storeID) ==
        false) {
      await addSale(Sale(
          orderItems: [
            OrderItem(
              productId: product.id,
              quantity: quantity,
              colorVariantId: colorVariant?.id,
              sizeVariantId: sizeVariant?.id,
            )
          ],
          totalAmount: product.discountPrice * quantity * 1.0,
          storeId: product.storeID));
      return;
    }

    Sale _onlineOrder = _onlineOrders
        .where((element) => element.status == "not_placed")
        .firstWhere((element) => element.storeId == product.storeID);

    if (_onlineOrder.orderItems
        .any((element) => element.productId == product.id)) {
      _onlineOrder
          .orderItems[_onlineOrder.orderItems
              .indexWhere((element) => element.productId == product.id)]
          .quantity = quantity;
    } else {
      _onlineOrder.orderItems
          .add(OrderItem(productId: product.id, quantity: quantity));
    }
    _onlineOrder.totalAmount = _onlineOrder.orderItems.fold(
        0,
        (previousValue, element) =>
            previousValue + element.quantity * product.discountPrice * 1.0);

    await updateSale(_onlineOrder);

    notifyListeners();
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
