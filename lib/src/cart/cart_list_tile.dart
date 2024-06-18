import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:intl/intl.dart';

class CartListTile extends StatefulWidget {
  Sale cart;
  CartListTile({super.key, required this.cart});

  @override
  State<CartListTile> createState() => _CartListTileState();
}

class _CartListTileState extends State<CartListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: FutureBuilder(
          future: Store.fetchStore(widget.cart.storeId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ListTile(
                leading: CircularProgressIndicator(),
                title: Text('Loading...'),
              );
            }
            if (snapshot.hasError) {
              return const Text('Error');
            }
            return InkWell(
              onTap: () {
    
                context.go('/cart/${widget.cart.id}');
              },
              child: Row(
                children: [
                  Image.network(
                    snapshot.data!.image,
                    width: 82,
                    height: 82,
                    fit: BoxFit.cover,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            snapshot.data!.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                              'Total:  ₹${widget.cart.totalAmount.toStringAsFixed(2)}'),
                          Text(
                              DateFormat('hh:mm a   dd-MMMM').format(
                                  widget.cart.orderTime ?? DateTime.now()),
                              style: const TextStyle(
                                color: Colors.grey,
                              )),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_rounded,
                      color: GlobalStyle.primaryColor,
                    ),
                    onPressed: () {
                      // Provider.of<SalesProvider>(context, listen: false)
                    },
                  ),
                ],
              ),

              // ListTile(
              //   leading: Image.network(
              //     snapshot.data!.image,
              //     width: 50,
              //     height: 50,
              //     fit: BoxFit.cover,
              //   ),
              //   title: Text(
              //     snapshot.data!.name,
              //     style: const TextStyle(
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              //   subtitle: Text(
              //       'Total: ${widget.cart.totalAmount.toStringAsFixed(2)}'),
              //   trailing: IconButton(
              //     icon: const Icon(Icons.delete),
              //     onPressed: () {
              //       // Provider.of<SalesProvider>(context, listen: false)
              //     },
              //   ),
              // ),
            );
          }),
    );
  }
}
