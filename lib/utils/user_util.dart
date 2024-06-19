import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:openzo_frontend/models/user.dart' as backend_user;
import 'package:openzo_frontend/models/user_data.dart';
import 'package:openzo_frontend/providers/user_data_provider.dart';
import 'package:openzo_frontend/providers/user_provider.dart';
import 'package:openzo_frontend/utils/location_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> handleUserData(String mobileNo, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String fcmToken = prefs.getString('fcmToken')!;
  String? userDataId = prefs.getString('user_data_id');

  backend_user.User user = await handleUserLogin(mobileNo, context);
  log('UserData Id: $userDataId');

  if (userDataId == null) {
    Position? position = await getLocation(context);
    if (position == null) {
      print('Location permission not granted');
      position = await showLocationPermissionBottomSheet(context);
    }
    if (position != null) {
      UserData userData = UserData(
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
        notificationToken: fcmToken,
        userId: user.id,
      );
      userData = await UserData.createUserData(userData);
      Provider.of<UserDataProvider>(context, listen: false)
          .setUserData(userData);
    }
  } else {
    UserData userData = await UserData.getUserData(userDataId);
    if (userData.notificationToken != fcmToken || userData.userId != user.id) {
      userData.notificationToken = fcmToken;
      userData.userId = user.id;
      userData = await UserData.updateUserData(userData);
    }
    Provider.of<UserDataProvider>(context, listen: false).setUserData(userData);
    log('User data already exists');
    return;
  }
}

Future<backend_user.User> handleUserLogin(
    String mobileNo, BuildContext context) async {
  try {
    bool isSignedIn = await backend_user.User.signIn(mobileNo);
    if (isSignedIn) {
      backend_user.User user = await backend_user.User.getUserWithJWT();
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      return user;
    }
    throw Exception('Failed to sign in');
  } catch (e) {
    print(e.toString());
    throw Exception(e.toString());
  }
}
