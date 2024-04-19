import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/cart.dart';
import 'package:openzo_frontend/models/online_order.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/providers/carts_provider.dart';
import 'package:openzo_frontend/src/store_page/product_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  static const String routeName = '/cart';
  // static const String routeNameWithArgs = '/cart/:id';
  int id = 0;
  CartPage({super.key, required this.id});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Cart? cart;
  List<Product> products = [];
  @override
  void didChangeDependencies() {
    // int storeID = ModalRoute.of(context)!.settings.arguments as int;
    Provider.of<CartsProvider>(context, listen: false)
        .cartsWithProducts
        .forEach((key, value) {
      if (key.storeId == widget.id) {
        cart = key;
        products = value;
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(0),
        color: Colors.white,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Total: ${cart!.total}'),
              ElevatedButton(
                onPressed: () {
                  // Provider.of<CartsProvider>(context, listen: false)
                  //     .removeCart(cart!);
                  // Navigator.pop(context);
                  showModalBottomSheet(
                      context: context,
                      // constraints: const BoxConstraints(
                      //   maxHeight: 400,
                      // ),
                      // isScrollControlled: true,
                      useSafeArea: true,
                      builder: (context) {
                        TextEditingController phoneController =
                            TextEditingController();
                        TextEditingController addressController =
                            TextEditingController();

                        OnlineOrder onlineOrder = OnlineOrder(
                          id: 0,
                          storeId: cart!.storeId,
                          customer: Customer(
                              id: 0,
                              phone: phoneController.text,
                              address: addressController.text,
                              userDataId: 1,
                              saleId: 0),
                          orderStatus: OrderStatus.placed,
                          totalAmount: cart!.total.toDouble(),
                          orderTime: DateTime.now(),
                          orderItems: cart!.orderItems,
                        );
                        return Container(
                          padding: const EdgeInsets.all(20),
                          // padding: MediaQuery.of(context).viewInsets,
                          child: Column(
                            children: [
                              const Text('Enter your phone number and address'),
                              const TextField(
                                decoration: InputDecoration(
                                  labelText: 'Phone',
                                ),
                              ),
                              const TextField(
                                decoration: InputDecoration(
                                  labelText: 'Address',
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  int userDataId =
                                      prefs.getInt('user_data_id')!;
                                  onlineOrder.customer.userDataId = userDataId;
                                  await OnlineOrder.createOnlineOrder(
                                      onlineOrder);

                                  // Navigator.pop(context);
                                },
                                child: const Text('Order Now'),
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: const Row(
                  children: [
                    Text('Order Now'),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Cart Page'),
            ListView(
              shrinkWrap: true,
              children: products
                  .map((e) => ProductCard(
                        product: e,
                        cart: cart,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
