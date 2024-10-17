import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:openzo_frontend/models/user.dart';
import 'package:openzo_frontend/viewmodels/sales_provider.dart';
import 'package:openzo_frontend/viewmodels/user_provider.dart';
import 'package:openzo_frontend/src/utils/location_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> handleUserData(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String fcmToken = prefs.getString('fcmToken') ?? '';
  String? token = prefs.getString('token');

  try {
    if (token == null) {
      // Create a new user
      User newUser = await _createUser(context, null, fcmToken);
      _setUserProviders(context, newUser);
    } else {
      // Fetch existing user and update data
      User existingUser = await User.getUserWithJWT();
      await _updateUserData(context, existingUser, fcmToken);
    }
  } catch (e) {
    log('Error handling user data: $e');
  }
}

// Update existing user data if needed
Future<void> _updateUserData(
    BuildContext context, User user, String fcmToken) async {
  bool needsUpdate = user.notificationToken != fcmToken ||
      user.address == null ||
      user.address!.isEmpty;

  if (needsUpdate) {
    Position? position = await _getUserLocation(context);
    if (position != null) {
      user.latitude = position.latitude.toString();
      user.longitude = position.longitude.toString();
      user.notificationToken = fcmToken;

      // Update the user data on the server
      user = await User.updateUser(user);
      log('User updated with pincode: ${user.pincode ?? "Unknown"}');

      // Subscribe to topic based on the user's pincode
      FirebaseMessaging.instance.subscribeToTopic("pincode_${user.pincode}");
    }
  }
  _setUserProviders(context, user);
}

// Create a new user and register them with location and FCM token
Future<User> _createUser(
    BuildContext context, String? phone, String fcmToken) async {
  Position? position = await _getUserLocation(context);
  if (position == null) {
    throw Exception('Location permission not granted');
  }

  User newUser = User(
    id: '',
    phone: phone ?? '',
    latitude: position.latitude.toString(),
    longitude: position.longitude.toString(),
    notificationToken: fcmToken,
  );

  // Register the new user on the server
  newUser = await User.registerUser(newUser);
  log('New user registered with pincode: ${newUser.pincode ?? "Unknown"}');

  // Subscribe to topic based on the user's pincode
  FirebaseMessaging.instance.subscribeToTopic("pincode_${newUser.pincode}");

  return newUser;
}

// Set the user in the UserProvider and SalesProvider
void _setUserProviders(BuildContext context, User user) {
  Provider.of<UserProvider>(context, listen: false).setUser(user);
  Provider.of<SalesProvider>(context, listen: false).setUser(user);
}

// Get user location and handle permissions
Future<Position?> _getUserLocation(BuildContext context) async {
  Position? position;
  try {
    position = await getLocation(context);
    position ??= await showLocationPermissionBottomSheet(context);
  } catch (e) {
    log('Error getting user location: $e');
  }
  return position;
}
