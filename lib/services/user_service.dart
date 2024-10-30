import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:openzo_frontend/models/user.dart';
import 'package:openzo_frontend/repositories/user_repository.dart';
import 'package:openzo_frontend/services/location_service.dart';

import 'package:openzo_frontend/viewmodels/sales_provider.dart';
import 'package:openzo_frontend/viewmodels/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

typedef PermissionRequestCallback = Future<void> Function();

class UserService {
  final UserProvider userProvider;
  final SalesProvider salesProvider;
  final SharedPreferences sharedPreferences;
  final FirebaseMessaging firebaseMessaging;
  final LocationService locationService;

  UserService({
    required this.userProvider,
    required this.salesProvider,
    required this.sharedPreferences,
    required this.firebaseMessaging,
    required this.locationService,
  });

  // Check if the user is authenticated and has valid token
  Future<bool> isUserAuthenticated() async {
    String? token = sharedPreferences.getString('token');
    if (token == null) {
      log('No token found');
      return false;
    }
    
    try {
      // Verify token validity by fetching user data
      User user = await UserRepository.getUserWithJWT();
      if (user.id.isEmpty) {
        log('Invalid user data received');
        return false;
      }
      
      _setUserProviders(user);
      userProvider.setLoggedIn(true);
      return true;
    } catch (e) {
      log('Token validation failed: $e');
      // Only clear auth data if it's a server error (500)
      if (e.toString().contains('Server error occurred')) {
        await _clearAuthData();
      }
      return false;
    }
  }

  // Handle new user registration
  Future<User> registerNewUser({
    required String phone,
    required PermissionRequestCallback onPermissionDenied,
  }) async {
    // Location is mandatory for new users
    Position? position = await locationService.getCurrentLocation(
      onPermissionDenied: onPermissionDenied,
    );
    if (position == null) {
      throw Exception('Location permission is required for registration');
    }

    String fcmToken = await _getFCMToken();
    
    User newUser = User(
      id: '',
      phone: phone,
      latitude: position.latitude.toString(),
      longitude: position.longitude.toString(),
      notificationToken: fcmToken,
    );

    // Register user and subscribe to notifications
    newUser = await UserRepository.registerUser(newUser);
    await _subscribeToNotifications(newUser);
    _setUserProviders(newUser);
    userProvider.setLoggedIn(true);
    
    return newUser;
  }

  // Handle existing user login
  Future<User> loginExistingUser({
    required String phone,
  }) async {
    try {
      String fcmToken = await _getFCMToken();
      User user = await UserRepository.getUserWithJWT();
      
      // Validate user data
      if (user.id.isEmpty || user.phone != phone) {
        throw Exception('Invalid user data received');
      }
      
      // Update FCM token if needed
      if (user.notificationToken != fcmToken) {
        user = user.copyWith(notificationToken: fcmToken);
        user = await UserRepository.updateUser(user);
        await _subscribeToNotifications(user);
      }

      _setUserProviders(user);
      userProvider.setLoggedIn(true);
      
      return user;
    } catch (e) {
      log('Error during login: $e');
      // Only clear auth data if it's a server error (500)
      if (e.toString().contains('Server error occurred')) {
        await _clearAuthData();
      }
      rethrow;
    }
  }

  // Helper method to get FCM token
  Future<String> _getFCMToken() async {
    String fcmToken = await firebaseMessaging.getToken() ?? '';
    await sharedPreferences.setString('fcmToken', fcmToken);
    return fcmToken;
  }

  // Helper method to subscribe to notifications
  Future<void> _subscribeToNotifications(User user) async {
    if (user.pincode != null) {
      await firebaseMessaging.subscribeToTopic("pincode_${user.pincode}");
    }
  }

  // Handle authentication error
  Future<void> handleAuthenticationError(dynamic error) async {
    log('Error handling user authentication: $error');
    // Only clear auth data if it's a server error (500)
    if (error.toString().contains('Server error occurred')) {
      await _clearAuthData();
    }
    userProvider.setLoggedIn(false);
  }

  /// Handles user data by checking if the user is new or existing.
  /// [onPermissionDenied] is a callback to handle location permission requests.
  Future<void> handleUserData({
    required PermissionRequestCallback onPermissionDenied,
  }) async {
    String fcmToken = sharedPreferences.getString('fcmToken') ?? '';
    String? token = sharedPreferences.getString('token');

    try {
      if (token == null) {
        // Create a new user
        User newUser = await _createUser(fcmToken, onPermissionDenied);
        _setUserProviders(newUser);
      } else {
        // Fetch existing user and update data
        User existingUser = await UserRepository.getUserWithJWT();
        log('Existing user: ${existingUser.id}');
        await _updateUserData(existingUser, fcmToken, onPermissionDenied);
      }
    } catch (e) {
      log('Error handling user data: $e');
      rethrow; // Re-throw the exception after logging
    }
  }

  /// Updates existing user data if necessary.
  Future<void> _updateUserData(
    User user,
    String fcmToken,
    PermissionRequestCallback onPermissionDenied,
  ) async {
    bool needsUpdate = user.notificationToken != fcmToken ||
        user.address == null ||
        user.address!.isEmpty;

    if (needsUpdate) {
      Position? position = await locationService.getCurrentLocation(
        onPermissionDenied: onPermissionDenied,
      );
      if (position != null) {
        user = user.copyWith(
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString(),
          notificationToken: fcmToken,
        );

        // Update the user data on the server
        user = await UserRepository.updateUser(user);
        log('User updated with pincode: ${user.pincode ?? "Unknown"}');

        // Subscribe to topic based on the user's pincode
        await firebaseMessaging.subscribeToTopic("pincode_${user.pincode}");
      } else {
        throw Exception('Location permission not granted');
      }
    }
    _setUserProviders(user);
  }

  /// Creates a new user with location and FCM token.
  Future<User> _createUser(
    String fcmToken,
    PermissionRequestCallback onPermissionDenied,
  ) async {
    Position? position = await locationService.getCurrentLocation(
      onPermissionDenied: onPermissionDenied,
    );
    if (position == null) {
      throw Exception('Location permission not granted');
    }

    User newUser = User(
      id: '',
      phone: '',
      latitude: position.latitude.toString(),
      longitude: position.longitude.toString(),
      notificationToken: fcmToken,
    );

    // Register the new user on the server
    newUser = await UserRepository.registerUser(newUser);
    log('New user registered with pincode: ${newUser.pincode ?? "Unknown"}');

    // Subscribe to topic based on the user's pincode
    await firebaseMessaging.subscribeToTopic("pincode_${newUser.pincode}");

    return newUser;
  }

  /// Sets the user in the UserProvider and SalesProvider.
  void _setUserProviders(User user) {
    log('User set: ${user.id}');
    userProvider.setUser(user);
    salesProvider.setUser(user);
  }

  // Helper method to clear authentication data
  Future<void> _clearAuthData() async {
    await sharedPreferences.remove('token');
    await sharedPreferences.remove('fcmToken');
    userProvider.clearUser();
    userProvider.setLoggedIn(false);
  }
}
