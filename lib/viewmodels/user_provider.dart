import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/address.dart';
import 'package:openzo_frontend/models/user.dart';
import 'package:openzo_frontend/repositories/address_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  List<Address> _addresses = [];
  bool _isLoggedIn = false;

  User? get user => _user;
  List<Address> get addresses => _addresses;
  bool get isLoggedIn => _isLoggedIn;

  void setUser(User user) {
    if (user.pincode == "94043") {
      user.pincode = "123456";
    }
    _user = user;

    AddressRepository.getAddressesByUserId(user.id).then((value) {
      _addresses = value;
      notifyListeners();
    });

    notifyListeners();
  }

  void setAddresses(List<Address> addresses) {
    _addresses = addresses;
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

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }
}
