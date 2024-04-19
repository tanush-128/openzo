// type UserData struct {
// 	Id                int    `json:"id"`
// 	UserId            int    `json:"user_id"`
// 	Latitude          string `json:"latitude"`
// 	Longitude         string `json:"longitude"`
// 	Address           string `json:"address"`
// 	Pincode           string `json:"pincode"`
// 	City 			string `json:"city"`
// 	State 			string `json:"state"`
// 	Country 			string `json:"country"`
// 	NotificationToken string `json:"notification_token"`
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openzo_frontend/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  int id;
  int userId;
  String latitude;
  String longitude;
  String address;
  String pincode;
  String city;
  String state;
  String country;
  String notificationToken;

  UserData({
    required this.id,
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.pincode,
    required this.city,
    required this.state,
    required this.country,
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
        await http.post(Uri.parse('${GlobalConsts.backend_url}/userData/'),
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

    if (res.statusCode == 200) {
      UserData userData = UserData.fromJson(jsonDecode(res.body));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('user_data_id', userData.id);
      return userData;
    } else {
      return null;
    }
  }

  static Future<UserData> getUserData(
    int userDataId,
  ) async {
    final res = await http.get(
      Uri.parse('${GlobalConsts.backend_url}/userData/$userDataId/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (res.statusCode == 200) {
      return UserData.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to load user data');
    }
  }

  static Future<UserData> UpdateUserData(UserData userData) async {
    final res = await http.put(
      Uri.parse('${GlobalConsts.backend_url}/userData/${userData.id}'),
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
      }),
    );

    if (res.statusCode == 200) {
      return UserData.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to update user data');
    }
  }
}



// func (router *UserDataServiceRouter) CreateUserData(c *gin.Context) {

// 	var userData models.UserData
// 	c.ShouldBindJSON(&userData)
// 	// var location utils.Location
// 	location, err := utils.GetLocation(userData.Latitude, userData.Longitude)
// 	if err != nil {
// 		c.JSON(400, gin.H{"error": "invalid location"})
// 		return
// 	}
// 	userData.City = location.Address.City
// 	userData.State = location.Address.State
// 	userData.Country = location.Address.Country
// 	userData.Address = location.Address.HouseNumber + ", " + location.Address.Road + ", " + location.Address.City + ", " + location.Address.State + ", " + location.Address.Country

// 	router.DB.Create(&userData)
// 	c.JSON(200, userData)
// }

