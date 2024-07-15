import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:openzo_frontend/models/user.dart';
import 'package:openzo_frontend/providers/sales_provider.dart';
import 'package:openzo_frontend/providers/user_provider.dart';
import 'package:openzo_frontend/utils/location_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> handleUserData(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String fcmToken = prefs.getString('fcmToken') ?? '';
  String? token = prefs.getString('token');

  late User user;
  if (token == null) {
    user = await _createUser(context, null, fcmToken);
    Provider.of<UserProvider>(context, listen: false).setUser(user);
    Provider.of<SalesProvider>(context, listen: false).setUser(user);
  } else {
    user = await User.getUserWithJWT();
    _updateUserData(context, user, fcmToken);
  }
}

_updateUserData(BuildContext context, User user, String fcmToken) async {
  if (user.notificationToken != fcmToken ||
      user.address == null ||
      user.address == '') {
    Position? position = await getLocation(context);
    if (position == null) {
      print('Location permission not granted');
      position = await showLocationPermissionBottomSheet(context);
    }

    user.notificationToken = fcmToken;

    if (position != null) {
      user.latitude = position.latitude.toString();
      user.longitude = position.longitude.toString();
      user = await User.updateUser(user);
    }
  }
  Provider.of<UserProvider>(context, listen: false).setUser(user);
  Provider.of<SalesProvider>(context, listen: false).setUser(user);
}

Future<User> _createUser(
    BuildContext context, String? phone, String fcmToken) async {
  Position? position = await getLocation(context);
  if (position == null) {
    print('Location permission not granted');
    position = await showLocationPermissionBottomSheet(context);
  }
  if (position != null) {
    User user = User(
      id: '',
      phone: phone ?? '',
      latitude: position.latitude.toString(),
      longitude: position.longitude.toString(),
      notificationToken: fcmToken,
    );
    user = await User.registerUser(user);

    return user;
  }

  throw Exception('Location permission not granted');
}
