import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:openzo_frontend/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Review {
  String id;
  String storeId;
  String userId;
  String userName;
  int rating;
  DateTime createdAt;
  String review;

  Review({
    this.id = "",
    required this.storeId,
    this.userId = "",
    this.userName = "",
    required this.rating,
    required this.createdAt,
    required this.review,
  });

  static String endpoint = "${GlobalConsts.backend_url}/stores";

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      storeId: json['store_id'],
      userId: json['user_id'],
      userName: json['user_name'],
      rating: json['rating'],
      createdAt: DateTime.parse(json['created_at']),
      review: json['review'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'review': review,
      'user_id': userId,
      'user_name': userName,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static Future<Review> createReview(Review review) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    var response = await http.post(
      Uri.parse('$endpoint/review'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
      body: jsonEncode(review.toJson()),
    );

    if (response.statusCode == 201) {
      Review review = Review.fromJson(jsonDecode(response.body));
      return review;
    } else {
      throw Exception('Failed to create review');
    }
  }

  static Future<List<Review>> getReviewsByStoreID(String storeID) async {
    final response = await http.get(
      Uri.parse('$endpoint/reviews/$storeID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Review> reviews =
          body.map((dynamic item) => Review.fromJson(item)).toList();
      return reviews;
    } else {
      throw Exception('Failed to get reviews');
    }
  }
}
