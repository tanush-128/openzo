import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
    id: "",
    phone: "",
  );

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<void> logout() async {
    _user = User(
      id: "",
      phone: "",
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }
}
