import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/viewmodels/sales_provider.dart';
import 'package:openzo_frontend/viewmodels/cart_page_view_model.dart';

import 'package:openzo_frontend/views/cart/styles.dart';
import 'package:openzo_frontend/views/cart/widgets/k_separator.dart';
import 'package:provider/provider.dart';

class OrderStatus extends StatefulWidget {
  const OrderStatus({
    super.key,
  });

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
    return Consumer<CartPageViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.cart == null) {
          return const SizedBox();
        }
        Sale cart = viewModel.cart!;
        final storeType = viewModel.storeType;

        if (cart.status == "not_placed") {
          return const SizedBox();
        }
        cart = Provider.of<SalesProvider>(context)
            .onlineOrders
            .firstWhere((element) => element.id == cart.id);

        if (cart.status == "rejected" && cart.status == "cancelled") {
          return Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: kBoxDecoration.copyWith(
              color: Colors.red,
            ),
            child: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    storeType != StoreType.service
                        ? 'We are sorry , Store has cancelled the order'
                        : 'We are sorry , Store has rejected the booking',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (cart.status == 'placed') {
          currentStatusIndex = 1;
        } else if (cart.status == 'accepted') {
          currentStatusIndex = 2;
        } else if (cart.status == 'out_for_delivery') {
          currentStatusIndex = 3;
        } else if (cart.status == 'delivered') {
          currentStatusIndex = 4;
        } else if (cart.status == 'completed') {
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
                      storeType == StoreType.service
                          ? 'Booking Status'
                          : 'Order Status',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    if (storeType != StoreType.service)
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
                                orderStatuses.indexOf(status) <
                                        currentStatusIndex
                                    ? const Icon(Icons.check_circle,
                                        color: Colors.green, size: 20)
                                    : const Icon(Icons.radio_button_unchecked,
                                        color: Colors.grey, size: 20),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    if (storeType == StoreType.service)
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
                                bookingStatuses.indexOf(status) <
                                        currentStatusIndex
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
                          storeType == StoreType.service
                              ? 'Booking ID : '
                              : 'Order ID : ',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          cart.id.split("-").first,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Time : ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat('dd MMM, hh:mm a').format(cart.orderTime!),
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
      },
    );
  }
}
