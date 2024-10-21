import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/repositories/store_repository.dart';

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
          future: StoreRepository.fetchStore(widget.cart.storeId),
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
                  snapshot.data!.image != ""
                      ? Image.network(
                          snapshot.data!.image,
                          width: 82,
                          height: 82,
                          fit: BoxFit.fill,
                        )
                      : Container(
                          width: 82,
                          height: 82,
                          color: Colors.grey[200],
                          child: const Icon(Icons.storefront),
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      OrderStatusBadge(status: widget.cart.status),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: const Text("View"),
                      )
                    ],
                  ),
                  const SizedBox(width: 8)
                ],
              ),
            );
          }),
    );
  }
}

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({Key? key, required this.status}) : super(key: key);

  final String status;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (status) {
      case "placed":
        statusColor = Colors.green;
        statusText = "Placed";
        break;
      case "accepted":
        statusColor = Colors.blue;
        statusText = "Accepted";
        break;
      case "rejected":
        statusColor = Colors.red;
        statusText = "Rejected";
        break;
      case "out_for_delivery":
        statusColor = Colors.orange;
        statusText = "Out for delivery";
        break;
      case "cancelled":
        statusColor = Colors.red;
        statusText = "Cancelled";
        break;
      case "delivered":
        statusColor = Colors.grey;
        statusText = "Delivered";
        break;
      default:
        statusColor = Colors.white;
        statusText = "";
    }

    return statusText != ""
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,

                // fontWeight: FontWeight.bold,
              ),
            ),
          )
        : const SizedBox();
  }
}
