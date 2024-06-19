import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openzo_frontend/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  String id;
  String userId;
  String latitude;
  String longitude;
  String address;
  String pincode;
  String city;
  String state;
  String country;
  String notificationToken;

  UserData({
    this.id = '',
    this.userId = '',
    required this.latitude,
    this.longitude = '',
    this.address = '',
    this.pincode = '',
    this.city = '',
    this.state = '',
    this.country = '',
    required this.notificationToken,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      userId: json['user_id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      pincode: json['pincode'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      notificationToken: json['notification_token'],
    );
  }

  static createUserData(UserData userData) async {
    final res =
        await http.post(Uri.parse('${GlobalConsts.backend_url}/users/userdata'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'user_id': userData.userId,
              'latitude': userData.latitude,
              'longitude': userData.longitude,
              'address': userData.address,
              'pincode': userData.pincode,
              'notification_token': userData.notificationToken,
            }));

    if (res.statusCode == 201) {
      UserData userData = UserData.fromJson(jsonDecode(res.body));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_data_id', userData.id);
      return userData;
    } else {
      return null;
    }
  }

  static Future<UserData> getUserData(
    String userDataId,
  ) async {
    final res = await http.get(
      Uri.parse('${GlobalConsts.backend_url}/users/userdata/$userDataId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (res.statusCode == 200) {
      print(res.body);
      return UserData.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to load user data');
    }
  }

  static Future<UserData> updateUserData(UserData userData) async {
    final res = await http.put(
      Uri.parse('${GlobalConsts.backend_url}/users/userdata'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id': userData.id,
        'user_id': userData.userId,
        'latitude': userData.latitude,
        'longitude': userData.longitude,
        'address': userData.address,
        'pincode': userData.pincode,
        'notification_token': userData.notificationToken,
      }),
    );

    if (res.statusCode == 200) {
      return UserData.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to update user data');
    }
  }
}
