
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openzo_frontend/constants/constants.dart';

class NotificationByte {
  final int id;
  final int storeID;
  final String title;
  final String message;
  final String image;
  final String pincode;
  // final DateTime scheduledAt;

  NotificationByte({
    required this.id,
    required this.storeID,
    required this.title,
    required this.message,
    required this.image,
    required this.pincode,
    // required this.scheduledAt,
  });

  factory NotificationByte.fromJson(Map<String, dynamic> json) {
    return NotificationByte(
      id: json['ID'],
      storeID: json['store_id'],
      title: json['title'],
      message: json['message'],
      image: json['image'],
      pincode: json['pincode'],
      // scheduledAt: DateTime.parse(json['scheduled_at']),
    );
  }

  static Future<List<NotificationByte>> fetchMany(String pincode) async {
    List<NotificationByte> notifications = [];
    // fetch notifications from the server
    http.Request req = http.Request(
        'GET',
        Uri.parse(
            '${GlobalConsts.backend_url}/notification/?pincode=$pincode'));
    http.StreamedResponse res = await req.send();

    if (res.statusCode == 200) {
      String body = await res.stream.bytesToString();
      List<dynamic> data = jsonDecode(body);
      for (var notification in data) {
        notifications.add(NotificationByte.fromJson(notification));
      }
    }

    return notifications;
  }
}
