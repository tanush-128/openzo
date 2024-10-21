import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/src/utils/phonepe.dart';
import 'package:openzo_frontend/viewmodels/cart_page_view_model.dart';
import 'package:openzo_frontend/viewmodels/sales_provider.dart';
import 'package:openzo_frontend/views/cart/styles.dart';
import 'package:openzo_frontend/views/cart/succes_page.dart';
import 'package:openzo_frontend/views/cart/widgets/address_details.dart';
import 'package:openzo_frontend/views/cart/widgets/cart_item/cart_item.dart';
import 'package:openzo_frontend/views/cart/widgets/grad_button.dart';
import 'package:openzo_frontend/views/cart/widgets/order_status.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CartPage extends StatelessWidget {
  final String id;

  const CartPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartPageViewModel(context, id),
      child: Consumer<CartPageViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.cart == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Order Details'),
              ),
              body: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(height: 10),
                    Text('Order not found'),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.grey.shade50,
            appBar: AppBar(
              title: Text(viewModel.store?.name ?? ""),
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            bottomNavigationBar: _buildBottomBar(context, viewModel),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const OrderStatus(),
                  _buildPaymentReminder(viewModel.cart!),
                  _buildStoreDetails(viewModel),
                  _buildOrderItems(viewModel),
                  AddressDetails(viewModel: viewModel),
                  _buildAddNote(context, viewModel),
                  _buildDeleteButton(context, viewModel),
                  // PayOnline(),
                  ElevatedButton(
                    onPressed: () async {
                      await PhonePePaymentService().startTransaction(
                          context: context,
                          mobileNumber: "+919679689833",
                          amount: 20.0);
                    },
                    child: const Text("Pay now"),
                  ),

                  CancellationButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentReminder(Sale cart) {
    if (cart.status == "not_placed" ||
        cart.status == "delivered" ||
        cart.status == "cancelled" ||
        cart.status == "rejected") {
      return const SizedBox();
    }
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.payment),
          SizedBox(width: 8),
          Expanded(
              child: Text(
            "Pay at delivery through Cash/UPI",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ))
        ],
      ),
    );
  }

  Widget _buildStoreDetails(CartPageViewModel viewModel) {
    if (viewModel.store == null) return const SizedBox();
    Store store = viewModel.store!;
    const Color phoneColor = Color.fromARGB(255, 33, 89, 243);
    return Container(
      decoration: kBoxDecoration,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(store.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  )),
            ],
          ),
          if (store.phone != "")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Row(
                    children: [
                      const ImageIcon(
                        AssetImage('assets/icons/phone.png'),
                        color: phoneColor,
                        size: 18,
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          launchUrl(
                              Uri(scheme: 'tel', path: "+91 ${store.phone}"));
                        },
                        child: Text(
                          "+91 ${store.phone}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: phoneColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: phoneColor,
                      )
                    ],
                  ),
                ),
                // if (cart.status != "not_placed")
                //   Text("To Modify (or) Cancel Order contact the store",
                //       style: TextStyle(
                //         fontWeight: FontWeight.w500,
                //         fontSize: 14,
                //         color: Colors.grey.shade500,
                //       )),
              ],
            )
        ],
      ),
    );
  }

  Widget _buildOrderItems(CartPageViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          ListView.builder(
            itemCount: viewModel.products.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return CartItem(
                product: viewModel.products[index],
                cart: viewModel.cart!,
                addable: viewModel.notPlaced,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context, CartPageViewModel viewModel) {
    if (viewModel.cart == null) {
      return Container();
    }
    Sale cart = viewModel.cart!;

    if (cart.status != "not_placed") {
      return Container();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Delete Cart"),
                    content: const Text(
                        "Are you sure you want to delete this cart?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<SalesProvider>(context, listen: false)
                              .deleteSale(cart.id)
                              .then((value) {});
                          context.go("/");
                          // Navigator.pop(context);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete),
            label: const Text("Delete Cart")),
      ],
    );
  }

  Widget _buildAddNote(BuildContext context, CartPageViewModel viewModel) {
    if (viewModel.cart!.status == "delivered" ||
        viewModel.cart!.status == "cancelled" ||
        viewModel.cart!.status == "rejected") {
      return const SizedBox();
    }
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: kBoxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Note',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            minLines: 3,
            controller: viewModel.noteController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Add a note to your order',
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              viewModel.updateNote(viewModel.noteController.text);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  Widget? _buildBottomBar(BuildContext context, CartPageViewModel viewModel) {
    if (viewModel.cart!.status != "not_placed") return null;

    askForOrderConfirmation() {
      showDialog(
        context: context,
        builder: (context2) {
          return AlertDialog(
            title: const Text('Order Confirmation'),
            content: const Text('Are you sure you want to place this order?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context2);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  viewModel.updateCartStatus('placed');
                  Navigator.pop(context2);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SuccessPage();
                  }));
                },
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt),
              const SizedBox(width: 12),
              const Text("Total Bill   "),
              Text(
                  "₹${viewModel.cart!.totalAmount + (viewModel.store?.deliveryCharge ?? 0)}"),
            ],
          ),
          viewModel.addressConfirmed
              ? ElevatedButton(
                  onPressed: () {
                    if (viewModel.phone.isEmpty || viewModel.address.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please enter your phone number and address'),
                        ),
                      );
                      return;
                    }
                    askForOrderConfirmation();
                  },
                  child: const Row(
                    children: [
                      Text('Place Order'),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                )
              : ElevatedButton(
                  onPressed: () {
                    if (viewModel.phone.isEmpty || viewModel.address.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please enter your phone number and address'),
                        ),
                      );
                      return;
                    }

                    viewModel.editAddress(context,
                        setAddressConfirmation: true);
                  },
                  child: const Row(
                    children: [
                      Text('Confirm Address'),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
