import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/src/cart/cart_page/kSeparator.dart';
import 'package:openzo_frontend/src/cart/cart_page/styles.dart';

class OrderStatus extends StatefulWidget {
  final Sale cart;
  final Store? store;
  StoreType? storeType;
  OrderStatus({super.key, required this.cart, this.store, this.storeType});

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  final List<String> orderStatuses = [
    "Order has been received by the store",
    "Order has been accepted",
    "Order is out for delivery",
    "Order has been delivered",
  ];

  final List<String> bookingStatuses = [
    "Booking has been received by the store",
    "Booking has been accepted",
    "Booking is completed",
  ];

  int currentStatusIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (!(widget.cart.status != "not_placed" &&
        widget.cart.status != "cancelled" &&
        widget.cart.status != "rejected")) {
      return const SizedBox();
    }

    if (widget.cart.status == 'placed') {
      currentStatusIndex = 1;
    } else if (widget.cart.status == 'accepted') {
      currentStatusIndex = 2;
    } else if (widget.cart.status == 'out_for_delivery') {
      currentStatusIndex = 3;
    } else if (widget.cart.status == 'delivered') {
      currentStatusIndex = 4;
    } else if (widget.cart.status == 'completed') {
      currentStatusIndex = 3;
    }

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: kBoxDecoration,
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.storeType == StoreType.service
                      ? 'Booking Status'
                      : 'Order Status',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                if (widget.storeType != StoreType.service)
                  Column(
                    children: orderStatuses.map((status) {
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
                            orderStatuses.indexOf(status) < currentStatusIndex
                                ? const Icon(Icons.check_circle,
                                    color: Colors.green, size: 20)
                                : const Icon(Icons.radio_button_unchecked,
                                    color: Colors.grey, size: 20),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                if (widget.storeType == StoreType.service)
                  Column(
                    children: bookingStatuses.map((status) {
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
                            bookingStatuses.indexOf(status) < currentStatusIndex
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
                    Text(
                      widget.storeType == StoreType.service
                          ? 'Booking ID : '
                          : 'Order ID : ',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.cart.id.split("-").first,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Time : ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
