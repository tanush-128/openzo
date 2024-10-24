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
  const OrderStatus({super.key});

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  // Status Mapping for the UI display
  final List<String> statusShortTexts = [
    "Confirmed",   // Order has been received by the store
    "On the way",  // Order has been accepted
    "Arrived"      // Order has been delivered/completed
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

        cart = Provider.of<SalesProvider>(context)
            .onlineOrders
            .firstWhere((element) => element.id == cart.id);
        if (cart.status == "rejected" || cart.status == "cancelled") {
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
                        ? 'We are sorry, the store has cancelled the order'
                        : 'We are sorry, the store has rejected the booking',
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

        // Update Status Index based on backend status
        if (cart.status == 'placed') {
          currentStatusIndex = 1; // Confirmed (Order received by the store)
        } else if (cart.status == 'accepted') {
          currentStatusIndex = 2; // On the way (Order has been accepted)
        } else if (cart.status == 'delivered' || cart.status == 'completed') {
          currentStatusIndex = 3; // Arrived (Order delivered/completed)
        }

        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.deepOrangeAccent, Colors.amber],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            children: [
              // Header: Order/Booking Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Status',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildStatusRow(),
                ],
              ),
              const Divider(height: 24, color: Colors.white),
              // Order ID Section (without time)
              _buildOrderInfo(cart),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < statusShortTexts.length; i++) ...[
          // Status Icon + Text
          Column(
            children: [
              // Status Icon (Smaller Loading for current, green filled for completed)
              if (i == currentStatusIndex)
                SizedBox(
                  height: 20,
                  width: 20,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else
                Icon(
                  i < currentStatusIndex
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: i < currentStatusIndex
                      ? Colors.greenAccent
                      : Colors.white70,
                  size: 24,
                ),
              const SizedBox(height: 8),
              // Status Text
              Text(
                statusShortTexts[i],
                style: TextStyle(
                  fontSize: 16,
                  color: i <= currentStatusIndex
                      ? Colors.white
                      : Colors.white70,
                  fontWeight: i <= currentStatusIndex
                      ? FontWeight.bold
                      : FontWeight.w500,
                ),
              ),
            ],
          ),
          // Add a dash between the items (except after the last one)
          if (i < statusShortTexts.length - 1)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  color: Colors.white,
                  thickness: 2,
                  height: 24,
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildOrderInfo(Sale cart) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Order ID: ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              cart.id.split("-").first,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text(
              'Booking Time : ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              DateFormat('dd MMM, hh:mm a')
                  .format(cart.orderTime!),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
