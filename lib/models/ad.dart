
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openzo_frontend/constants/constants.dart';

class Ad {
  final int id;
  final int storeID;
  final String name;
  final String url;
  final String image;
  final DateTime expiresAt;

  Ad({
    required this.id,
    required this.storeID,
    required this.name,
    required this.url,
    required this.image,
    required this.expiresAt,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['ID'],
      storeID: json['store_id'],
      name: json['name'],
      url: json['url'],
      image: json['image'],
      expiresAt: DateTime.parse(json['expires_at']),
    );
  }

  static Future<List<Ad>> fetchMany(String pincode) async {
    List<Ad> ads = [];
    // fetch ads from the server
    http.Request req = http.Request(
        'GET', Uri.parse('${GlobalConsts.backend_url}/ad/?pincode=$pincode'));
    http.StreamedResponse res = await req.send();

    if (res.statusCode == 200) {
      String body = await res.stream.bytesToString();
      List<dynamic> data = jsonDecode(body);
      for (var ad in data) {
        ads.add(Ad.fromJson(ad));
      }
    }

    return ads;
  }
}
