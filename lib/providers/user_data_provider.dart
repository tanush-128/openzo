import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/user.dart';
import 'package:openzo_frontend/models/user_data.dart';

class UserDataProvider with ChangeNotifier {
  UserData _userData = UserData(latitude: "", notificationToken: "");

  UserData get userData => _userData;

  void setUserData(UserData userData) {
    _userData = userData;
    notifyListeners();
  }
}
