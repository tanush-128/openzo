// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:openzo_frontend/models/cart.dart';
// import 'package:openzo_frontend/models/store.dart';
// import 'package:openzo_frontend/providers/sales_provider.dart';
// import 'package:openzo_frontend/src/cart/cart_page.dart';
// import 'package:provider/provider.dart';

// class CartListTile extends StatefulWidget {
//   Cart cart;
//   CartListTile({super.key, required this.cart});

//   @override
//   State<CartListTile> createState() => _CartListTileState();
// }

// class _CartListTileState extends State<CartListTile> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: Store.fetchStore(widget.cart.storeId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Container(
//               child: const ListTile(
//                 leading: CircularProgressIndicator(),
//                 title: Text('Loading...'),
//               ),
//             );
//           }
//           if (snapshot.hasError) {
//             return const Text('Error');
//           }
//           return InkWell(
//             onTap: () {
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //     builder: (context) => CartPage(store: snapshot.data!),
//               //   ),
//               // );
//               context.go('/cart/${widget.cart.storeId}');
//             },
//             child: ListTile(
//               leading: Image.network(
//                 snapshot.data!.image,
//                 width: 50,
//                 height: 50,
//                 fit: BoxFit.cover,
//               ),
//               title: Text(snapshot.data!.name),
//               subtitle: Text('Total: ${widget.cart.total}'),
//               trailing: IconButton(
//                 icon: const Icon(Icons.delete),
//                 onPressed: () {
//                   Provider.of<CartsProvider>(context, listen: false)
//                       .removeCart(widget.cart);
//                 },
//               ),
//             ),
//           );
//         });
//   }
// }
