import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/repositories/store_repository.dart';

class CartListTile extends StatefulWidget {
  final Sale cart;
  const CartListTile({super.key, required this.cart});

  @override
  State<CartListTile> createState() => _CartListTileState();
}

class _CartListTileState extends State<CartListTile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: StoreRepository.fetchStore(widget.cart.storeId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            leading: CircularProgressIndicator(),
            title: Text('Loading...'),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading store'));
        }

        final store = snapshot.data as Store;

        return InkWell(
          onTap: () {
            context.go('/cart/${widget.cart.id}');
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Store Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: store.image.isNotEmpty
                          ? Image.network(
                              store.image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[200],
                              child: const Icon(Icons.storefront,
                                  color: Colors.grey),
                            ),
                    ),
                    const SizedBox(width: 16),
                    // Store Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total: ₹${widget.cart.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('hh:mm a · dd MMMM').format(
                                widget.cart.orderTime ?? DateTime.now()),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status Badge
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        OrderStatusBadge(status: widget.cart.status),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "View",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 0.5, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }
}

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status});

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
        statusColor = Colors.green;
        statusText = "Delivered";
        break;
      default:
        statusColor = Colors.grey;
        statusText = "Not placed";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
