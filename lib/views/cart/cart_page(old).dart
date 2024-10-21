// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:openzo_frontend/constants/constants.dart';
// import 'package:openzo_frontend/constants/styles.dart';
// import 'package:openzo_frontend/models/product.dart';
// import 'package:openzo_frontend/models/sale.dart';
// import 'package:openzo_frontend/models/store.dart';
// import 'package:openzo_frontend/models/user.dart';
// import 'package:openzo_frontend/viewmodels/sales_provider.dart';
// import 'package:openzo_frontend/viewmodels/user_provider.dart';
// import 'package:openzo_frontend/src/cart/cart_page/components/cart_item/cart_item.dart';
// import 'package:openzo_frontend/src/cart/cart_page/components/AddressBottomSheet.dart';
// import 'package:openzo_frontend/src/cart/cart_page/components/order_status.dart';
// import 'package:openzo_frontend/src/cart/cart_page/components/address_details.dart';

// import 'package:openzo_frontend/src/cart/cart_page/components/grad_button.dart';
// import 'package:openzo_frontend/src/cart/cart_page/styles.dart';
// import 'package:openzo_frontend/src/cart/cart_page/components/succes_page.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// class CartPage extends StatefulWidget {
//   static const String routeName = '/cart';
//   final String id;

//   const CartPage({super.key, required this.id});

//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   List<Product> products = [];
//   Store? store;
//   bool notPlaced = true;
//   String address = "";
//   String phone = "";

//   StoreType? storeType;
//   int deliveryCharge = 0;
//   TextEditingController noteController = TextEditingController();
//   bool addressConfirmed = false;

//   @override
//   void initState() {
//     super.initState();
//     final cart = Provider.of<SalesProvider>(context, listen: false)
//         .onlineOrders
//         .where((element) => element.id == widget.id)
//         .first;

//     noteController.text = cart.note ?? "";

//     notPlaced = cart.status == 'not_placed';
//     Store.fetchStore(cart.storeId).then((value) {
//       setState(() {
//         store = value;

//         storeType = GlobalConsts.categories
//             .where((element) => element.name == store?.category)
//             .firstOrNull
//             ?.type;
//       });
//     });

//     if (cart.customer!.address == "") {
//       final User user = Provider.of<UserProvider>(context, listen: false).user;
//       // address = user.address ?? "";
//       phone = user.phone;
//     } else {
//       address = cart.customer!.address;
//       phone = cart.customer!.phone;
//     }
//     Product.fetchMany(cart.storeId).then((value) {
//       setState(() {
//         products = value
//             .where((element) =>
//                 cart.orderItems.map((e) => e.productId).contains(element.id))
//             .toList();
//       });
//     });
//   }

//   void editAddress(Sale cart, {bool setAddressConfirmation = false}) {
//     showAddressBottomSheet(context, address, phone, cart).then((value) {
//       if (value == null) return;
//       address = value['address'];
//       phone = value['phone'];
//       cart.customer!.address = address;
//       cart.customer!.phone = phone;
//       Provider.of<SalesProvider>(context, listen: false).updateSale(cart);
//       if (address != "" &&
//           phone.length >= 10 &&
//           setAddressConfirmation == true) {
//         setState(() {
//           addressConfirmed = true;
//         });
//       }
//     });
//   }

//   late Sale cart;

//   @override
//   Widget build(BuildContext context) {
//     cart = Provider.of<SalesProvider>(context)
//         .onlineOrders
//         .where((element) => element.id == widget.id)
//         .first;
//     if (cart == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Order Details'),
//         ),
//         body: const Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.error, color: Colors.red),
//               SizedBox(height: 10),
//               Text('Order not found'),
//             ],
//           ),
//         ),
//       );
//     }
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: Text(store?.name ?? ""),
//         centerTitle: false,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       bottomNavigationBar: _buildBottomBar(context, cart, notPlaced, store),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             // OrderStatus(cart: cart, storeType: storeType),
//             _buildPaymentReminder(cart),

//             _buildStoreDetails(context),
//             _cancellationReminder(),

//             _buildOrderItems(cart),
//             const SizedBox(height: 10),
//             // _buildAddressDetails(cart, context),
//             // if (store != null)
//             //   AddressDetails(
//             //     cart: cart,
//             //     store: store!,
//             //     onAddressConfirmed: () {
//             //       setState(() {
//             //         addressConfirmed = true;
//             //         log("address confirmed");
//             //       });
//             //     },
//             //   ),
//             _buildAddNote(context, cart),
//             // CancellationButton(),
//             if (store != null && store!.selfDeliveryService == false)
//               Container(
//                 margin: const EdgeInsets.all(8),
//                 padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//                 decoration: kBoxDecoration,
//                 child: const Center(
//                   child: Row(
//                     children: [
//                       Icon(Icons.error, color: Colors.red),
//                       SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           'This store does not provide delivery service',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.red,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             if (store != null && (store!.busy || store!.closed))
//               Container(
//                 margin: const EdgeInsets.all(8),
//                 padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//                 decoration: kBoxDecoration,
//                 child: Center(
//                   child: Row(
//                     children: [
//                       const Icon(Icons.error, color: Colors.red),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           store!.busy
//                               ? 'This store is currently busy, please try again later'
//                               : 'This store is currently closed, please try again later',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.red,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             _buildDeleteButton(context, cart),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _cancellationReminder() {
//     if (cart.status == "placed" || cart.status == "accepted") {
//       Container(
//         decoration: kBoxDecoration,
//         margin: const EdgeInsets.all(8),
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
//         child: Row(
//           children: [
//             const Icon(Icons.timer, color: GlobalStyle.primaryColor),
//             const SizedBox(width: 10),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Cancel Order in 2 minutes",
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.red,
//                       )),
//                   Text(
//                     "If you want to cancel the order, please do it now",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade600,
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       );
//     }
//     return const SizedBox();
//   }

//   // Like pay at the delivery
//   Widget _buildPaymentReminder(Sale cart) {
//     if (cart.status == "not_placed" ||
//         cart.status == "delivered" ||
//         cart.status == "cancelled" ||
//         cart.status == "rejected") {
//       return const SizedBox();
//     }
//     return Container(
//       margin: const EdgeInsets.all(8),
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//       decoration: kBoxDecoration,
//       child: const Row(
//         children: [
//           Icon(Icons.payment),
//           SizedBox(width: 8),
//           Expanded(
//               child: Text(
//             "Pay at delivery through Cash/UPI",
//             style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//           ))
//         ],
//       ),
//     );
//   }

//   Widget _buildAddNote(BuildContext context, Sale cart) {
//     if (cart.status == "delivered" ||
//         cart.status == "cancelled" ||
//         cart.status == "rejected") {
//       return const SizedBox();
//     }
//     return Container(
//       margin: const EdgeInsets.all(8),
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//       decoration: kBoxDecoration,
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Add Note',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           // SizedBox(height: 6),
//           TextField(
//             minLines: 3,
//             controller: noteController,
//             maxLines: 5,
//             decoration: const InputDecoration(
//               hintText: 'Add a note to your order',
//               border: OutlineInputBorder(
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),

//           const SizedBox(height: 10),
//           TextButton(
//             onPressed: () {
//               cart.note = noteController.text;
//               Provider.of<SalesProvider>(context, listen: false)
//                   .updateSale(cart);
//             },
//             child: const Text("Save"),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildDeleteButton(BuildContext context, Sale cart) {
//     if (cart.status != "not_placed") {
//       return Container();
//     }
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         TextButton.icon(
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     title: const Text("Delete Cart"),
//                     content: const Text(
//                         "Are you sure you want to delete this cart?"),
//                     actions: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: const Text('Cancel'),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Provider.of<SalesProvider>(context, listen: false)
//                               .deleteSale(cart.id)
//                               .then((value) {
//                             context.go("/");
//                           });
//                           // Navigator.pop(context);
//                         },
//                         child: const Text('Delete'),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//             icon: const Icon(Icons.delete),
//             label: const Text("Delete Cart")),
//       ],
//     );
//   }

//   Container _buildOrderItems(Sale cart) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       decoration: kBoxDecoration,
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         children: [
//           ListView.builder(
//             itemCount: products.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               return CartItem(
//                 product: products[index],
//                 cart: cart,
//                 addable: cart.status == "not_placed",
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Container _buildStoreDetails(BuildContext context) {
//     return Container(
//       decoration: kBoxDecoration,
//       margin: const EdgeInsets.all(8),
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(store?.name ?? "",
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   )),
//               // TextButton(
//               //   onPressed: () {
//               //     context.go('/store/${store?.id}');
//               //   },
//               //   child: Text(notPlaced ? "Add More" : "View More"),
//               // )
//             ],
//           ),
//           if (store != null && store?.phone != null && store?.phone != "")
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 0),
//                   child: Row(
//                     children: [
//                       ImageIcon(
//                         const AssetImage('assets/icons/phone.png'),
//                         // color: Colors.grey.shade900,
//                         color: Colors.blue.shade400,

//                         size: 18,
//                       ),
//                       const SizedBox(width: 12),
//                       InkWell(
//                         onTap: () {
//                           launchUrl(
//                               Uri(scheme: 'tel', path: "+91 ${store!.phone}"));
//                         },
//                         child: Text(
//                           "+91 ${store!.phone}",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16,
//                             // color: Colors.blue,
//                             color: Colors.blue.shade400,

//                             // color: GlobalStyle.primaryColor,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 8,
//                       ),
//                       Icon(
//                         Icons.arrow_forward,
//                         size: 18,
//                         // color: Colors.grey,
//                         color: Colors.blue.shade800,

//                         fill: 1,
//                       )
//                     ],
//                   ),
//                 ),
//                 // if (cart.status != "not_placed")
//                 //   Text("To Modify (or) Cancel Order contact the store",
//                 //       style: TextStyle(
//                 //         fontWeight: FontWeight.w500,
//                 //         fontSize: 14,
//                 //         color: Colors.grey.shade500,
//                 //       )),
//               ],
//             )
//         ],
//       ),
//     );
//   }

//   Widget? _buildBottomBar(
//       BuildContext context, Sale cart, bool notPlaced, Store? store) {
//     if (cart.status == "placed") {
//       return Container(
//         height: 75,
//         color: Colors.white,
//         padding: const EdgeInsets.all(10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 ImageIcon(
//                   const AssetImage('assets/icons/bill.png'),
//                   color: Colors.grey.shade500,
//                   size: 18,
//                 ),
//                 const SizedBox(width: 12),
//                 const Text(
//                   "Total Bill   ",
//                   style: TextStyle(
//                     color: Colors.grey,
//                   ),
//                 ),
//                 Text(
//                   "₹${cart.totalAmount + (store?.deliveryCharge ?? 0)}",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(width: 10),
//             CancellationButton(),
//           ],
//         ),
//       );
//     }
//     if (cart.status != "not_placed") return null;

//     askForConfirmation() {
//       showDialog(
//         context: context,
//         builder: (context2) {
//           // for order or booking confirmation
//           return AlertDialog(
//             title: Text(storeType != StoreType.service
//                 ? 'Order Confirmation'
//                 : 'Booking Confirmation'),
//             content: Text(storeType != StoreType.service
//                 ? 'Are you sure you want to place this order?'
//                 : 'Are you sure you want to book this service?'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context2);
//                 },
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   cart.status = 'placed';

//                   Provider.of<SalesProvider>(context, listen: false)
//                       .updateSale(cart);

//                   setState(() {
//                     notPlaced = false;
//                   });
//                   Navigator.pop(context2);
//                   Navigator.push(context, MaterialPageRoute(builder: (context) {
//                     return SuccessPage(sale: cart);
//                   }));

//                   setState(() {
//                     notPlaced = false;
//                   });
//                 },
//                 child: const Text('Confirm'),
//               ),
//             ],
//           );
//         },
//       );
//     }

//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.all(10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               ImageIcon(
//                 const AssetImage('assets/icons/bill.png'),
//                 color: Colors.grey.shade500,
//                 size: 18,
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 "Total Bill   ",
//                 style: TextStyle(
//                   color: Colors.grey,
//                 ),
//               ),
//               Text(
//                 "₹${cart.totalAmount + (store?.deliveryCharge ?? 0)}",
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 15,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(width: 10),
//           if (store != null && store.selfDeliveryService && store.busy == false)
//             storeType != StoreType.service
//                 ? addressConfirmed
//                     ? ElevatedButton(
//                         onPressed: () {
//                           if (phone == "" || address == "") {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text(
//                                     'Please enter your phone number and address'),
//                               ),
//                             );
//                             return;
//                           }

//                           askForConfirmation();
//                         },
//                         child: const Row(
//                           children: [
//                             Text('Place Order'),
//                             SizedBox(width: 10),
//                             Icon(Icons.arrow_forward),
//                           ],
//                         ),
//                       )
//                     : ElevatedButton(
//                         onPressed: () {
//                           if (phone == "" || address == "") {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text(
//                                     'Please enter your phone number and address'),
//                               ),
//                             );
//                             return;
//                           }

//                           // askForConfirmation();
//                           editAddress(cart, setAddressConfirmation: true);
//                         },
//                         child: const Row(
//                           children: [
//                             Text('Confirm Address'),
//                             // SizedBox(width: 10),
//                             // Icon(Icons.arrow_forward),
//                           ],
//                         ),
//                       )
//                 : ElevatedButton(
//                     onPressed: () {
//                       if (phone == "") {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Please enter your phone number '),
//                           ),
//                         );
//                         return;
//                       }

//                       askForConfirmation();
//                     },
//                     style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.all(12)),
//                     child: const Row(
//                       children: [
//                         Text('Request Booking'),
//                       ],
//                     ),
//                   ),
//         ],
//       ),
//     );
//   }
// }
