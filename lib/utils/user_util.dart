import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:openzo_frontend/models/user.dart';
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
  print("mobileNo: $mobileNo");
  if (mobileNo == "") {
    if (userDataId == null) {
      await _createNewUserData(context, null, fcmToken);
    } else {
      log('UserData Id: $userDataId');
      UserData userData = await UserData.getUserData(userDataId);
      await _updateUserData(context, userData, null, fcmToken);
    }
  } else {
    User user = await handleUserLogin(mobileNo, context);

    try {
      UserData userData = await UserData.getUserDataByUserID(user.id);
      await _updateUserData(context, userData, user, fcmToken);
      log('User data already exists');
      return;
    } catch (e) {
      print(e.toString());
      await _createNewUserData(context, user, fcmToken);
    }
  }
}

Future<void> _updateUserData(BuildContext context, UserData userData,
    User? user, String fcmToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setString('user_data_id', userData.id);
  if (userData.notificationToken != fcmToken || userData.userId != user?.id) {
    userData.notificationToken = fcmToken;
    userData.userId = user?.id ?? "";
    userData = await UserData.updateUserData(userData);
  }
  Provider.of<UserDataProvider>(context, listen: false).setUserData(userData);
}

Future<void> _createNewUserData(
    BuildContext context, User? user, String fcmToken) async {
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
      userId: user?.id ?? "",
    );
    userData = await UserData.createUserData(userData);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('user_data_id', userData.id);
    Provider.of<UserDataProvider>(context, listen: false).setUserData(userData);
  }
}

Future<User> handleUserLogin(String mobileNo, BuildContext context) async {
  try {
    bool isSignedIn = await User.signIn(mobileNo);
    if (isSignedIn) {
      User user = await User.getUserWithJWT();
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      return user;
    }
    throw Exception('Failed to sign in');
  } catch (e) {
    print(e.toString());
    throw Exception(e.toString());
  }
}
