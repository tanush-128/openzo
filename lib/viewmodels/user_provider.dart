import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
    id: "",
    phone: "",
    pincode: "123456",
  );

  User get user => _user;

  void setUser(User user) {
    if (user.pincode == "94043") {
      user.pincode = "123456";
    }
    _user = user;
    notifyListeners();
  }

  bool get loggedIn => _user.id.isNotEmpty;

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
