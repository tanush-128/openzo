import 'package:flutter/material.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/models/user.dart';
import 'package:openzo_frontend/models/user_data.dart';
import 'package:openzo_frontend/providers/sales_provider.dart';
import 'package:openzo_frontend/providers/user_data_provider.dart';
import 'package:openzo_frontend/providers/user_provider.dart';
import 'package:openzo_frontend/src/product/product_card.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  static const String routeName = '/cart';
  // static const String routeNameWithArgs = '/cart/:id';
  String id;
  CartPage({super.key, required this.id});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // final ProductData = Future.value(Product.fetchMany(cart.storeId));
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    final cart = Provider.of<SalesProvider>(context, listen: false)
        .onlineOrders
        .firstWhere((element) => element.id == widget.id);
    print(cart.customer!.address);
    print(cart.customer!.phone);
    print(cart.customer!.userDataId);

    if (cart.customer!.address == "" || cart.customer!.phone == "") {
      final UserData userData =
          Provider.of<UserDataProvider>(context, listen: false).userData;
      final User user = Provider.of<UserProvider>(context, listen: false).user;
      address = userData.address;
      phone = user.phone!;
    } else {
      address = cart.customer!.address;
      phone = cart.customer!.phone;
    }
    Product.fetchMany(cart.storeId).then((value) {
      setState(() {
        products = value
            .where((element) =>
                cart.orderItems.map((e) => e.productId).contains(element.id))
            .toList();
      });
    });
  }

  String address = "";
  String phone = "";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<SalesProvider>(context)
        .onlineOrders
        .firstWhere((element) => element.id == widget.id);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      bottomNavigationBar: cart.status == "not_placed"
          ? Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Cancel Order'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      cart.status = 'placed';
                      cart.customer = Customer(
                          phone: phone,
                          address: address,
                          userDataId: cart.customer!.userDataId);
                      Provider.of<SalesProvider>(context, listen: false)
                          .updateSale(cart);
                    },
                    child: const Row(
                      children: [
                        Text('Place Order'),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ],
              ))
          : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Delivery To :",
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              address.length > 25
                                  ? "${address.substring(0, 25)}..."
                                  : address,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Contact No:",
                                style: TextStyle(color: Colors.grey)),
                            const SizedBox(width: 8),
                            Text(phone,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  cart.status == "not_placed"
                      ? TextButton(
                          onPressed: () {
                            showAddressBottomSheet(
                                    context, address, phone, cart)
                                .then((value) {
                              if (value != null) {
                                setState(() {
                                  address = value['address'];
                                  phone = value['phone'];
                                });
                                cart.customer = Customer(
                                    phone: phone,
                                    address: address,
                                    userDataId: cart.customer!.userDataId,
                                    id: cart.customer!.id,
                                    saleId: cart.id);
                                Provider.of<SalesProvider>(context,
                                        listen: false)
                                    .updateSale(cart);
                              }
                            });
                          },
                          child: const Text('Change'),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            const SizedBox(height: 10),
            OrderStatus(
              cart: cart,
            ),
            Container(
              color: Colors.grey.shade50,
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: products.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(1.5),
                    child: ProductCard(
                      product: products[index],
                      cart: cart,
                      addable: cart.status == 'not_placed',
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            CartDetails(cart: cart),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class CartDetails extends StatefulWidget {
  Sale cart;
  CartDetails({super.key, required this.cart});

  @override
  State<CartDetails> createState() => _CartDetailsState();
}

class _CartDetailsState extends State<CartDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Price Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total MRP",
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              Text(
                "₹${widget.cart.totalAmount}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Delivery Charge",
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              Text(
                "₹40",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(
            color: Colors.grey,
            thickness: 1.5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Amount",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  "₹${widget.cart.totalAmount + 40}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1.5,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

Future<dynamic> showAddressBottomSheet(
    BuildContext context, String address, String phone, Sale cart) {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  addressController.text = address;
  phoneController.text = phone;

  return showModalBottomSheet<dynamic>(
    context: context,
    isDismissible: false,
    useSafeArea: true,
    isScrollControlled: true, // Allows the modal to expand to fit content
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ), // Padding to avoid keyboard overlay
        child: Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Adjust size to content
              children: [
                const Text(
                  'Enter Delivery Address',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    hintText: 'Enter your address',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'address': addressController.text,
                      'phone': phoneController.text,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    textStyle: const TextStyle(fontSize: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Save Address'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class OrderStatus extends StatefulWidget {
  Sale cart;
  OrderStatus({super.key, required this.cart});
  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  final List<String> statuses = [
    "Order has been received by the store",
    "Order has been accepted",
    // "Order is being prepared",
    "Order is out for delivery",
    "Order has been delivered",
  ];
  int currentStatusIndex = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.cart.status == 'placed') {
      currentStatusIndex = 1;
    } else if (widget.cart.status == 'accepted') {
      currentStatusIndex = 2;
    } else if (widget.cart.status == 'out_for_delivery') {
      currentStatusIndex = 3;
    } else if (widget.cart.status == 'delivered') {
      currentStatusIndex = 4;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Status',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Column(
            children: statuses.map((status) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    statuses.indexOf(status) < currentStatusIndex
                        ? const Icon(Icons.check_circle,
                            color: GlobalStyle.primaryColor)
                        : const Icon(Icons.radio_button_unchecked,
                            color: GlobalStyle.primaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        status,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
