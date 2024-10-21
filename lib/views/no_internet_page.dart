import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              "No Internet Connection",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
