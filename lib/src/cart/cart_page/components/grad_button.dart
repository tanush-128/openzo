import 'dart:async';
import 'package:flutter/material.dart';
import 'package:openzo_frontend/constants/styles.dart';

class CancellationButton extends StatefulWidget {
  @override
  _CancellationButtonState createState() => _CancellationButtonState();
}

class _CancellationButtonState extends State<CancellationButton> {
  static const int timerDuration = 60; // Duration in seconds
  int remainingTime = timerDuration;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double percentage = (timerDuration - remainingTime) / timerDuration;

    return Center(
      child: GestureDetector(
        onTap: () {
          print("Button Pressed!");
        },
        child: CustomPaint(
          painter: GradientButtonPainter(percentage: percentage),
          child: Container(
            width: 200,
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
