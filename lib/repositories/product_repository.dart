// repositories/product_repository.dart
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:openzo_frontend/models/product.dart';

class ProductRepository {
  static String endpoint = '${GlobalConsts.backend_url}/products';

  static final Map<String, Product> _productCache = {};
  static final Map<String, DateTime> _productCacheTimestamps = {};
  static const Duration cacheDuration = Duration(hours: 1);

  static Future<Product> fetchProduct(String productID) async {
    if (_productCache.containsKey(productID)) {
      final cachedTime = _productCacheTimestamps[productID];
      if (cachedTime != null &&
          DateTime.now().difference(cachedTime) < cacheDuration) {
        return _productCache[productID]!;
      } else {
        _productCache.remove(productID);
        _productCacheTimestamps.remove(productID);
      }
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Authentication token not found');
    }

    final response = await http.get(
      Uri.parse('$endpoint/$productID'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final product = Product.fromJson(data);
      _productCache[productID] = product;
      _productCacheTimestamps[productID] = DateTime.now();
      return product;
    } else {
      throw Exception('Failed to load product: ${response.statusCode}');
    }
  }

  static Future<List<Product>> fetchProductsByStore(String storeID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Authentication token not found');
    }

    final response = await http.get(
      Uri.parse('$endpoint/store/$storeID'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> productsJson = json.decode(response.body);
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<Product>> searchProducts(
      String pincode, String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Authentication token not found');
    }

    final response = await http.get(
      Uri.parse(
          '${GlobalConsts.backend_url}/search/products/$pincode?term=$query'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> productsJson = jsonDecode(response.body);
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search products');
    }
  }

  static Future<List<Post>> fetchPostByPincode(String pincode) async {
    try {
      final response = await http.get(
        Uri.parse('$endpoint/post/pincode/$pincode'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Post> posts = data.map((item) {
          Product product = Product.fromJson(item['product']);
          StoreBasicDetails store = StoreBasicDetails.fromJson(item['store']);
          return Post(post: product, store: store);
        }).toList();

        return posts;
      } else {
        log('Failed to fetch posts by pincode: ${response.statusCode} ${response.reasonPhrase}');
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      log('Error in fetchPostByPincode: $e');
      rethrow;
    }
  }
}
