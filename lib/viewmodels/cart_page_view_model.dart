import 'package:flutter/material.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/models/user.dart';
import 'package:openzo_frontend/repositories/product_repository.dart';
import 'package:openzo_frontend/repositories/store_repository.dart';
import 'package:openzo_frontend/viewmodels/sales_provider.dart';
import 'package:openzo_frontend/viewmodels/user_provider.dart';
import 'package:openzo_frontend/views/cart/widgets/address_bottom_sheet.dart';
import 'package:provider/provider.dart';

class CartPageViewModel extends ChangeNotifier {
  Sale? cart;
  List<Product> products = [];
  Store? store;
  bool notPlaced = true;
  String address = "";
  String phone = "";
  StoreType? storeType;
  int deliveryCharge = 0;
  bool addressConfirmed = false;
  TextEditingController noteController = TextEditingController();

  BuildContext context;

  // Add a reference to the listener
  late VoidCallback _salesProviderListener;

  CartPageViewModel(this.context, String cartId) {
    _initialize(context, cartId);
  }
  late final SalesProvider saleProvider;
  Future<void> _initialize(BuildContext context, String cartId) async {
    saleProvider = Provider.of<SalesProvider>(context, listen: false);

    // Define the listener separately
    _salesProviderListener = () {
      // Update the cart when SalesProvider changes
      // cart = saleProvider.onlineOrders.firstWhere(
      //   (element) => element.id == cartId,
      // );
      if (saleProvider.onlineOrders.map((e) => e.id).contains(cartId)) {
        cart = saleProvider.onlineOrders.firstWhere(
          (element) => element.id == cartId,
        );
      }
      _updateCartData();
    };

    // Listen for changes in the SalesProvider
    saleProvider.addListener(_salesProviderListener);

    cart = saleProvider.onlineOrders.firstWhere(
      (element) => element.id == cartId,
    );

    noteController.text = cart?.note ?? "";
    notPlaced = cart?.status == 'not_placed';

    store = await StoreRepository.fetchStore(cart?.storeId ?? "");
    storeType = GlobalConsts.categories
        .where((element) => element.name == store?.category)
        .firstOrNull
        ?.type;

    final fetchedProducts =
        await ProductRepository.fetchProductsByStore(cart?.storeId ?? "");
    products = fetchedProducts
        .where((element) =>
            cart?.orderItems.map((e) => e.productId).contains(element.id) ??
            false)
        .toList();

    if (cart?.customer?.address == "") {
      final User user = Provider.of<UserProvider>(context, listen: false).user!;
      phone = user.phone;
    } else {
      address = cart?.customer?.address ?? "";
      phone = cart?.customer?.phone ?? "";
    }

    notifyListeners();
  }

  void _updateCartData() {
    // This method updates other values related to the cart
    notPlaced = cart?.status == 'not_placed';
    noteController.text = cart?.note ?? "";
    notifyListeners();
  }

  void editAddress(BuildContext context,
      {bool setAddressConfirmation = false}) {
    showAddressBottomSheet(context, address, phone, cart!).then((value) {
      if (value == null) return;
      address = value.building +
          ", " +
          value.area +
          ", " +
          value.city +
          ", " +
          value.state +
          ", " +
          value.pincode;
      phone = value.phoneNo;
      // address = value['address'];
      // phone = value['phone'];
      cart?.customer!.address = address;
      cart?.customer!.phone = phone;
      Provider.of<SalesProvider>(context, listen: false).updateSale(cart!);
      if (address != "" &&
          phone.length >= 10 &&
          setAddressConfirmation == true) {
        addressConfirmed = true;
        notifyListeners();
      }
    });
  }

  void updateNote(String note) {
    cart?.note = note;
    notifyListeners();
  }

  void updateCartStatus(String status) {
    cart?.status = status;

    if (cart?.status == "placed") {
      // orderTime = cart?.orderTime;
      cart?.orderTime = DateTime.now();
      Provider.of<SalesProvider>(context, listen: false).updateSale(cart!);
    }
    notifyListeners();
  }

  // Override the dispose method
  @override
  void dispose() {
    // Remove the listener from SalesProvider

    saleProvider.removeListener(_salesProviderListener);

    // Dispose of the TextEditingController
    noteController.dispose();

    super.dispose();
  }
}
