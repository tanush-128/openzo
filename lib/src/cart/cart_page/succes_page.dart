import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:intl/intl.dart';

class SuccessPage extends StatefulWidget {
  Sale? sale;
  SuccessPage({
    super.key,
    this.sale,
  });

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      bottomNavigationBar: Container(
        // color: const Color(0xFF1d1fff),
        color: GlobalStyle.primaryColor,
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Image.asset('assets/images/tick.gif', height: 200),
                Lottie.asset('assets/lotties/tick mark animation.json',
                    height: 200),
                const SizedBox(height: 20),
                Text(
                  widget.sale?.type == "booking"
                      ? 'Booking Placed'
                      : 'Order Placed',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (widget.sale != null)
                  Column(
                    children: [
                      Text(
                        '${widget.sale?.type == "booking" ? 'Booking Date: ' : 'Order Date: '}${DateFormat('dd-MM-yyyy').format(widget.sale!.orderTime ?? DateTime.now())}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Amount: ₹${widget.sale!.totalAmount}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                const Text(
                  'Your order has been placed successfully',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
