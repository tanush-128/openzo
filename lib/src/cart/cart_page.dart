import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/models/user.dart';
import 'package:openzo_frontend/providers/sales_provider.dart';
import 'package:openzo_frontend/providers/user_provider.dart';
import 'package:openzo_frontend/src/cart/cart_item.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  static const String routeName = '/cart';
  // static const String routeNameWithArgs = '/cart/:id';
  String id;
  CartPage({super.key, required this.id});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Product> products = [];
  Store? store;
  bool notPlaced = true;

  @override
  void initState() {
    super.initState();
    final cart = Provider.of<SalesProvider>(context, listen: false)
        .onlineOrders
        .firstWhere((element) => element.id == widget.id);
    notPlaced = cart.status == 'not_placed';
    Store.fetchStore(cart.storeId).then((value) {
      setState(() {
        store = value;
      });
    });

    print(cart.customer!.address);
    print(cart.customer!.phone);
    print(cart.customer!.userDataId);

    if (cart.customer!.address == "") {
      final User user = Provider.of<UserProvider>(context, listen: false).user;
      address = user.address ?? "";
      phone = user.phone;
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

    var boxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          blurRadius: 5.0,
          spreadRadius: 0.0,
          offset: const Offset(0.0, 2.0),
        ),
      ],
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(store?.name ?? ""),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar: cart.status == "not_placed"
          ? Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // TextButton(
                  //   onPressed: () {},
                  //   child: const Text('Cancel Order'),
                  // ),
                  Row(
                    children: [
                      ImageIcon(
                        const AssetImage('assets/icons/bill.png'),
                        color: Colors.grey.shade500,
                        size: 18,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Total Bill   ",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "₹${cart.totalAmount + 40}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  if (store != null && store!.selfDeliveryService)
                    ElevatedButton(
                      onPressed: () {
                        if (phone == "" || address == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please enter your phone number and address'),
                            ),
                          );
                          return;
                        }

                        cart.status = 'placed';

                        cart.customer = Customer(
                          phone: phone,
                          address: address,
                          userDataId: cart.customer!.userDataId,
                        );
                        Provider.of<SalesProvider>(context, listen: false)
                            .updateSale(cart);

                        setState(() {
                          notPlaced = false;
                        });
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
            const SizedBox(height: 10),
            (cart.status != "not_placed" &&
                    cart.status != "cancelled" &&
                    cart.status != "rejected")
                ? Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: boxDecoration,
                    child: OrderStatus(
                      cart: cart,
                    ),
                  )
                : const SizedBox(),
            if (cart.status == "rejected" || cart.status == "cancelled")
              Container(
                margin: const EdgeInsets.all(8),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: boxDecoration.copyWith(
                  color: Colors.red,
                ),
                child: const Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.error, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'We are sorry , Store has cancelled the order',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              decoration: boxDecoration,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(store?.name ?? "",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          )),
                      // const Text("Add More"),
                      TextButton(
                        onPressed: () {
                          context.go('/store/${store?.id}');
                        },
                        child: Text(notPlaced ? "Add More" : "View More"),
                      )
                    ],
                  ),
                  //contact details
                  if (store != null &&
                      store?.phone != null &&
                      store?.phone != "" &&
                      notPlaced == false)
                    Column(
                      children: [
                        // kSeparator(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              ImageIcon(
                                const AssetImage('assets/icons/phone.png'),
                                color: Colors.grey.shade700,
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "+91 ${store!.phone}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: boxDecoration,
              clipBehavior: Clip.antiAlias,
              child: ListView.builder(
                itemCount: products.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return CartItem(
                    product: products[index],
                    cart: cart,
                    addable: cart.status == 'not_placed',
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: boxDecoration,
              clipBehavior: Clip.antiAlias,
              child: _buildAddressDetails(cart, context),
            ),
            if (store != null && store!.selfDeliveryService == false)
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: boxDecoration,
                child: const Center(
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This store does not provide delivery service',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (cart.status == "not_placed")
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          context.go("/");
                          Provider.of<SalesProvider>(context, listen: false)
                              .deleteSale(cart.id)
                              .then((value) {});
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text("Delete Cart")),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Container _buildAddressDetails(Sale cart, BuildContext context) {
    editAddress() {
      if (!notPlaced) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text('You cannot edit details after placing the order'),
          ),
        );
        return;
      }
      showAddressBottomSheet(context, address, phone, cart).then((value) {
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
          Provider.of<SalesProvider>(context, listen: false).updateSale(cart);
        }
      });
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageIcon(
                const AssetImage('assets/icons/Home.png'),
                color: Colors.grey.shade700,
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () {
                    editAddress();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        // crossAxisAlignment: CrossAxisAlignment.start
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "Delivery At :",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          // Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Colors.grey,
                            fill: 1,
                          )
                        ],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        address,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const kSeparator(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageIcon(
                const AssetImage('assets/icons/phone.png'),
                color: Colors.grey.shade700,
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: editAddress,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "+91 $phone",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Colors.grey,
                            fill: 1,
                          )
                        ],
                      ),
                      // const SizedBox(width: 8),
                      // Text(
                      //   phone,
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.w500,
                      //     fontSize: 16,
                      //     color: Colors.grey.shade600,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const kSeparator(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon(Icons.blinds_close),
              ImageIcon(
                const AssetImage('assets/icons/bill.png'),
                color: Colors.grey.shade500,
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return CartDetails(cart: cart);
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Text(
                              "Total Bill   ",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "₹${cart.totalAmount + 40}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey,
                        fill: 1,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class kSeparator extends StatelessWidget {
  const kSeparator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        "-------------------------------------------------------------------------------------",
        maxLines: 1,
        style: TextStyle(
          color: Colors.grey.shade300,
          fontSize: 10,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon(Icons.blinds_close),
          ImageIcon(
            const AssetImage('assets/icons/bill.png'),
            color: Colors.grey.shade700,
            size: 18,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Price Details",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total MRP",
                        style: TextStyle(fontSize: 15, color: Colors.grey)),
                    Text(
                      "₹${widget.cart.totalAmount}",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Delivery Charge",
                        style: TextStyle(fontSize: 15, color: Colors.grey)),
                    Text(
                      "₹40",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.grey,
                  thickness: 1.5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Amount",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
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
          ),
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
      return NewWidget(
          addressController: addressController,
          phoneController: phoneController);
    },
  );
}

class NewWidget extends StatefulWidget {
  const NewWidget({
    super.key,
    required this.addressController,
    required this.phoneController,
  });

  final TextEditingController addressController;
  final TextEditingController phoneController;

  @override
  State<NewWidget> createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  var inputDecorationTheme = InputDecorationTheme(
    errorStyle: TextStyle(
      color: Colors.red.shade700,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black87, width: 1.75),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.red.shade700, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.red.shade700, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    prefixIconColor: Colors.grey.shade500,
    constraints: const BoxConstraints(maxWidth: 360),
    hintStyle: GoogleFonts.poppins(
      color: Colors.grey.shade300,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    floatingLabelStyle: GoogleFonts.poppins(
      color: Colors.black87,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    labelStyle: GoogleFonts.poppins(
      color: Colors.grey.shade300,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    filled: true,
    fillColor: Colors.white,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    alignLabelWithHint: false,
  );
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: inputDecorationTheme,
      ),
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Delivery Address',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: widget.phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          labelText: 'Recipient\'s Phone Number *',
                          hintText: 'Recipient\'s Phone Number *'
                          // hintText: 'Enter your phone number',
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                // margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Adjust size to content
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Save address as *",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: widget.addressController,
                      decoration: const InputDecoration(
                        labelText: 'Flat / House No / Floor / Building *',
                        hintText: 'Enter your address *',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const TextField(
                      // controller: widget.addressController,
                      decoration: InputDecoration(
                        labelText: 'Nearby Landmark',
                        hintText: 'Enter nearby landmark',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'address': widget.addressController.text,
                    'phone': widget.phoneController.text,
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Confirm Address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order Status',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Column(
                children: statuses.map((status) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            status,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        const SizedBox(width: 8),
                        statuses.indexOf(status) < currentStatusIndex
                            ? const Icon(Icons.check_circle,
                                color: Colors.green, size: 20)
                            : const Icon(Icons.radio_button_unchecked,
                                color: Colors.grey, size: 20),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const kSeparator(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Order ID : ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.cart.id.split("-").first,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              // const SizedBox(height: 6),
              //timing
              Row(
                children: [
                  const Text(
                    'Time : ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat('dd MMM, hh:mm a')
                        .format(widget.cart.orderTime!),
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
