import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:openzo_frontend/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String id;
  String? email;
  String? name;
  String phone;
  String? latitude;
  String? longitude;
  String? address;
  String? pincode;
  String? city;
  String? state;
  String? country;
  String? notificationToken;
  bool isVerified;

  User({
    required this.id,
    this.email,
    this.name,
    required this.phone,
    this.latitude,
    this.longitude,
    this.address,
    this.pincode,
    this.city,
    this.state,
    this.country,
    this.notificationToken,
    this.isVerified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      pincode: json['pincode'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      notificationToken: json['notification_token'],
      isVerified: json['is_verified'],
    );
  }

  static String endpoint = '${GlobalConsts.backend_url}/users';
  // static String endpoint = 'https://lnn7jf70-8080.inc1.devtunnels.ms';

  static Future<User> getUserWithJWT() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token not found');
    }

    var response =
        await http.get(Uri.parse('$endpoint/jwt'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': token,
    });
    if (response.statusCode == 200) {
      User user = User.fromJson(jsonDecode(response.body));
      print('User: ${user.pincode} ${user.city} ${user.state}');
      return user;
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      throw Exception('Failed to load user');
    }
  }

  static Future<User> registerUser(User user) async {
    var res = await http.post(Uri.parse('$endpoint/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          user.toJson(),
        ));
    if (res.statusCode == 201) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(jsonDecode(res.body));

      prefs.setString('token', jsonDecode(res.body)['token']);
      print('JWT Token: ${jsonDecode(res.body)['token']}');
      return User.fromJson(jsonDecode(res.body)['user']);
    }

    throw Exception(jsonDecode(res.body)['error']);
  }

  static Future<User> updateUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token not found');
    }

    var res = await http.put(Uri.parse('$endpoint/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
        },
        body: jsonEncode(user.toJson()));
    if (res.statusCode == 200) {
      return User.fromJson(jsonDecode(res.body));
    }

    throw Exception(jsonDecode(res.body)['error']);
  }

  static Future<String> verifyOTP(
      String mobile, String verificationID, String otp, String userID) async {
    http.Response res = await http.post(Uri.parse('$endpoint/otp/verify'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'phone_no': mobile,
          'otp': otp,
          'verification_id': verificationID,
          'user_id': userID,
        }));
    if (res.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', jsonDecode(res.body)['token']);
      print('JWT Token: ${jsonDecode(res.body)['token']}');

      return jsonDecode(res.body)['token'];
    } else {
      throw Exception(jsonDecode(res.body)['error']);
    }
  }

  static Future<String> generateOTP(String mobile) async {
    http.Response res = await http.post(Uri.parse('$endpoint/otp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'phone_no': mobile,
        }));
    if (res.statusCode == 200) {
      return jsonDecode(res.body)['verification_id'];
    } else {
      throw Exception(jsonDecode(res.body)['error']);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'pincode': pincode,
      'city': city,
      'state': state,
      'country': country,
      'notification_token': notificationToken,
      'is_verified': isVerified,
      'password': '',
    };
  }
}
