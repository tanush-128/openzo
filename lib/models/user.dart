import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openzo_frontend/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String name;
  String email;
  String phone;
  String id;

  User({
    required this.id,
    required this.phone,
    this.name = "",
    this.email = "",
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'],
      name: json['Name'],
      email: json['Email'],
      phone: json['Phone'],
    );
  }

  static Future<User> getUserWithJWT() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token not found');
    }

    var response = await http.get(
        Uri.parse('${GlobalConsts.backend_url}/users/jwt'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
        });
    if (response.statusCode == 200) {
      User user = User.fromJson(jsonDecode(response.body));
      return user;
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      throw Exception('Failed to load user');
    }
  }

  static Future<bool> signIn(String mobile) async {
    http.Response res =
        await http.post(Uri.parse('${GlobalConsts.backend_url}/users/signin'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'mobile': mobile,
              'otp': '',
            }));
    if (res.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', jsonDecode(res.body)['token']);
      print('JWT Token: ${jsonDecode(res.body)['token']}');

      return true;
    } else {
      try {
        await User.addUser(User(id: '', phone: mobile));

        return signIn(mobile);
      } catch (e) {
        throw Exception(jsonDecode(res.body)['error']);
      }
    }
  }

  static Future<User> addUser(User user) async {
    var res = await http.post(Uri.parse('${GlobalConsts.backend_url}/users/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'name': user.name,
          'email': user.email,
          'phone': user.phone,
        }));
    if (res.statusCode == 201) {
      return User.fromJson(jsonDecode(res.body));
    }

    throw Exception(jsonDecode(res.body)['error']);
  }
}
