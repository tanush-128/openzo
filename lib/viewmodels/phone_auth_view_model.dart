import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/models/user.dart';
import 'package:openzo_frontend/repositories/user_repository.dart';
import 'package:openzo_frontend/services/user_service.dart';
import 'package:openzo_frontend/viewmodels/user_provider.dart';
import 'package:provider/provider.dart';

class PhoneAuthViewModel extends ChangeNotifier {
  // Existing variables
  final TextEditingController phoneController = TextEditingController();
  String? verificationId;
  bool isLoading = false;
  String error = '';

  // New variable for name registration
  final TextEditingController nameController = TextEditingController();

  // Injected services
  final UserService userService;

  // Constructor
  PhoneAuthViewModel({required this.userService});

  // Existing methods...

  Future<void> sendOTP(BuildContext context) async {
    isLoading = true;
    error = '';
    notifyListeners();

    try {
      String _verificationId =
          await UserRepository.generateOTP(phoneController.text);
      verificationId = _verificationId;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP sent to ${phoneController.text}')),
      );
    } catch (e) {
      error = 'Failed to send OTP: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOTP(BuildContext context, String otp) async {
    isLoading = true;
    error = '';
    notifyListeners();
    try {
      await UserRepository.verifyOTP(
          phoneController.text, verificationId!, otp, "");
      try {
        await userService.handleUserAuthentication(
          onPermissionDenied: () => _showLocationPermissionDialog(context),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully signed in!')),
        );
        // Navigate to home page
        context.go('/');
      } catch (e) {
        // Handle error
      }
      // await _handleUserAuthentication();
    } catch (err) {
      error = 'Error verifying OTP: $err';
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error verifying OTP')),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // New method to save name
  Future<void> saveName(BuildContext context) async {
    if (nameController.text.length < 5) {
      error = "Name is too short";
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      error = '';
      notifyListeners();

      User user = Provider.of<UserProvider>(context, listen: false).user!;
      user = user.copyWith(name: nameController.text);

      user = await UserRepository.updateUser(user);
      Provider.of<UserProvider>(context, listen: false).setUser(user);

      context.go('/');
    } catch (e) {
      error = 'Error saving name: $e';
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Method to show location permission dialog
  Future<void> _showLocationPermissionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'This app needs location access to function properly. Please grant location permission.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Geolocator.requestPermission();
            },
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
