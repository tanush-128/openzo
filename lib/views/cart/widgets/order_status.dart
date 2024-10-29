import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/viewmodels/sales_provider.dart';
import 'package:openzo_frontend/viewmodels/cart_page_view_model.dart';
import 'package:openzo_frontend/views/cart/styles.dart';
import 'package:provider/provider.dart';

class OrderStatus extends StatefulWidget {
  const OrderStatus({super.key});

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> with TickerProviderStateMixin {
  final List<String> statusShortTexts = [
    "Confirmed",   // Order has been received by the store
    "On the way",  // Order has been accepted
    "Arrived"      // Order has been delivered/completed
  ];

  int currentStatusIndex = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(); // Repeat the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          print("Status3");
        }
        print(currentStatusIndex);

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 53, 16, 16),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      'Order Status',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildStatusRow(),
                ],
              ),
              const Divider(height: 24, color: Colors.white),
              _buildOrderInfo(cart),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusRow() {
    return Column(
      children: [
        if(currentStatusIndex<3)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(right: 30),
                child: SizedBox(
                  width: 30,
                  height: 40,
                  child: SpinKitPouringHourGlassRefined(
                    color: Colors.white,
                    size: 60.0,
                    controller: _controller, // Use the AnimationController
                  ),
                ),
              ),
            ],
          ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            for (int i = 0; i < statusShortTexts.length; i++) ...[
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color:currentStatusIndex==3? Colors.greenAccent : i < currentStatusIndex-1
                        ? Colors.greenAccent
                        : i == currentStatusIndex-1
                        ? Colors.white
                        : Colors.white60,
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    statusShortTexts[i],
                    style: TextStyle(
                      fontSize: 14,
                      color: currentStatusIndex==3? Colors.greenAccent : i < currentStatusIndex-1
                          ? Colors.greenAccent
                          : i == currentStatusIndex-1
                          ? Colors.white
                          : Colors.white70,
                      fontWeight: i <= currentStatusIndex-1
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),

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
        ),
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
              DateFormat('dd MMM, hh:mm a').format(cart.orderTime!),
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
