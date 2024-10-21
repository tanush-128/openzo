// repositories/review_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openzo_frontend/models/review.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewRepository {
  static String endpoint = "${GlobalConsts.backend_url}/stores";

  static Future<Review> createReview(Review review) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('$endpoint/review'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
      body: jsonEncode(review.toJson()),
    );

    if (response.statusCode == 201) {
      return Review.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create review');
    }
  }

  static Future<List<Review>> getReviewsByStoreID(String storeID) async {
    final response = await http.get(
      Uri.parse('$endpoint/reviews/$storeID'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Review.fromJson(item)).toList();
    } else {
      throw Exception('Failed to get reviews');
    }
  }
}
