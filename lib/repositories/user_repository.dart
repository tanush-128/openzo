// repositories/user_repository.dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static String endpoint = '${GlobalConsts.backend_url}/users';
  // static String endpoint = 'https://fxscpgdl-8081.inc1.devtunnels.ms';

  static Future<User> getUserWithJWT() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$endpoint/jwt'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 500) {
      // Only clear token for server errors (500)
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      throw Exception('Server error occurred');
    } else {
      // For other status codes, keep token but throw appropriate error
      final errorMessage =
          jsonDecode(response.body)['error'] ?? 'Failed to load user';
      throw Exception(errorMessage);
    }
  }

  static Future<User> registerUser(User user) async {
    final response = await http.post(
      Uri.parse('$endpoint/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();
      final responseBody = jsonDecode(response.body);
      prefs.setString('token', responseBody['token']);
      return User.fromJson(responseBody['user']);
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  static Future<User> updateUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('$endpoint/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  static Future<String> verifyOTP(
      String mobile, String verificationID, String otp, String userID) async {
    final response = await http.post(
      Uri.parse('$endpoint/otp/verify'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'phone_no': mobile,
        'otp': otp,
        'verification_id': verificationID,
        'user_id': userID,
      }),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', jsonDecode(response.body)['token']);
      return jsonDecode(response.body)['token'];
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  static Future<String> generateOTP(String mobile) async {
    final response = await http.post(
      Uri.parse('$endpoint/otp'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'phone_no': mobile}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['verification_id'];
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }
}
