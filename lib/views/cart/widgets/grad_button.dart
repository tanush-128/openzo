import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/viewmodels/cart_page_view_model.dart';

class CancellationButton extends StatefulWidget {
  final CartPageViewModel viewModel;

  const CancellationButton({super.key, required this.viewModel});

  @override
  _CancellationButtonState createState() => _CancellationButtonState();
}

class _CancellationButtonState extends State<CancellationButton> {
  static const int timerDuration = 60; // Duration in seconds
  int remainingTime = timerDuration;
  Timer? _timer;
  late VoidCallback listener;

  @override
  void initState() {
    super.initState();
    listener = _cartStatusListener;
    widget.viewModel.addListener(listener);

    if (widget.viewModel.cart?.orderTime != null) {
      remainingTime = timerDuration -
          DateTime.now()
              .difference(widget.viewModel.cart!.orderTime!)
              .inSeconds;

      if (remainingTime > 0) {
        startTimer();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.viewModel
        .removeListener(listener); // Remove the listener to avoid memory leaks
    super.dispose();
  }

  void _cartStatusListener() {
    if (widget.viewModel.cart?.status == "not_placed") {
      _timer?.cancel();
      setState(() {}); // Trigger rebuild to hide the button
    } else {
      if (widget.viewModel.cart?.orderTime != null) {
        remainingTime = timerDuration -
            DateTime.now()
                .difference(widget.viewModel.cart!.orderTime!)
                .inSeconds;

        log("Remaining Time: $remainingTime");

        if (remainingTime > 0) {
          startTimer();
        } else {
          setState(() {}); // Update UI if the time has already elapsed
        }
      }
    }
  }

  void startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        _timer?.cancel();
        setState(() {}); // Update UI when time is up
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String cartStatus = widget.viewModel.cart?.status ?? "not_placed";
    if (cartStatus == "not_placed" || remainingTime <= 0) {
      return const SizedBox.shrink();
    }

    double percentage = (timerDuration - remainingTime) / timerDuration;

    return SizedBox(
      height: 56,
      child: Center(
        child: GestureDetector(
          onTap: () {
            print("Button Pressed!");
          },
          child: CustomPaint(
            painter: GradientButtonPainter(percentage: percentage),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: 52,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.timer, color: Colors.white, size: 20),
                      Text(
                        remainingTime > 0 ? "$remainingTime s" : "Time's up!",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "Cancel Order",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GradientButtonPainter extends CustomPainter {
  final double percentage;

  GradientButtonPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          GlobalStyle.primaryColor.withOpacity(0.7),
          GlobalStyle.primaryColor,
        ],
        stops: [percentage, percentage + 0.01], // Create the gradient effect
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(12),
    );

    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint every frame for animation
  }
}
