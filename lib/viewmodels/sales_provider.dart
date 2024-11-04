import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/models/user.dart';
import 'package:openzo_frontend/repositories/sale_repository.dart';
import 'package:openzo_frontend/viewmodels/user_provider.dart';

class SalesProvider extends ChangeNotifier {
  final UserProvider _userProvider;
  SalesProvider(
    this._userProvider,
  ) {
    _userProvider.addListener(() {
      if (_userProvider.user != null) {
        getOrders();
      }
    });
  }

  User _user = User(
    id: "",
    phone: "",
  );

  final List<Sale> _onlineOrders = [];
  List<Sale> get onlineOrders => _onlineOrders;

  List<Sale> get placedOrders => _getPlacedOrders(_onlineOrders);

  List<Sale> _getPlacedOrders(List<Sale> orders) {
    List<Sale> placedOrders = [];

    for (var order in orders) {
      if (order.status != "not_placed" &&
          order.status != "delivered" &&
          order.status != "rejected" &&
          order.status != "cancelled" &&
          order.status != "completed") {
        placedOrders.add(order);
      }

      if ((order.status == "rejected" || order.status == "cancelled") &&
          order.orderTime!
              .isAfter(DateTime.now().subtract(const Duration(minutes: 30)))) {
        placedOrders.add(order);
      }
    }
    return placedOrders;
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
    final orders = await SaleRepository.getSalesByUserID();

    final orderIds = _onlineOrders.map((order) => order.id).toSet();

    for (var element in orders) {
      if (element.orderItems.isEmpty || element.totalAmount <= 0) {
        await SaleRepository.deleteSale(element.id);
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
    Customer customer = Customer(
      id: 0,
      phone: _user.phone,
      userDataId: _user.id,
      address: _user.address ?? "",
    );
    onlineOrder.customer = customer;
    Sale onlineOrder0 = await SaleRepository.createSale(onlineOrder);
    _onlineOrders.add(onlineOrder0);

    notifyListeners();
  }

  Future<void> fetchSaleById(String id) async {
    Sale onlineOrder = await SaleRepository.getSaleByID(id);
    if (_onlineOrders.indexWhere((element) => element.id == id) == -1) {
      _onlineOrders.add(onlineOrder);
    } else {
      _onlineOrders[_onlineOrders.indexWhere((element) => element.id == id)] =
          onlineOrder;
    }
    notifyListeners();
  }

  Future<void> updateSale(Sale onlineOrder) async {
    Sale onlineOrder0 = await SaleRepository.updateSale(onlineOrder);
    _onlineOrders[_onlineOrders
        .indexWhere((element) => element.id == onlineOrder.id)] = onlineOrder0;
    notifyListeners();
  }

  Future<void> deleteSale(String id) async {
    await SaleRepository.deleteSale(id);
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

    Sale onlineOrder = _onlineOrders
        .where((element) => element.status == "not_placed")
        .firstWhere((element) => element.storeId == product.storeID);

    int prevQuantity = onlineOrder.orderItems
            .where((element) => element.productId == product.id)
            .firstOrNull
            ?.quantity ??
        0;

    if (onlineOrder.orderItems
        .any((element) => element.productId == product.id)) {
      if (quantity == 0) {
        onlineOrder.orderItems
            .removeWhere((element) => element.productId == product.id);
      } else {
        onlineOrder
            .orderItems[onlineOrder.orderItems
                .indexWhere((element) => element.productId == product.id)]
            .quantity = quantity;
      }
    } else {
      onlineOrder.orderItems
          .add(OrderItem(productId: product.id, quantity: quantity));
    }
    onlineOrder.totalAmount +=
        product.discountPrice * (quantity - prevQuantity) * 1.0;

    await updateSale(onlineOrder);
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
