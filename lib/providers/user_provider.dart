import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/user.dart';

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
}
