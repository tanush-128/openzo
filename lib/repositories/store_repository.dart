// repositories/store_repository.dart
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:openzo_frontend/models/store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:openzo_frontend/constants/constants.dart';

class StoreRepository {
  static String endpoint = '${GlobalConsts.backend_url}/stores';

  static final Map<String, Store> _storeCache = {};
  static final Map<String, DateTime> _storeCacheTimestamps = {};
  static final Map<String, Future<Store>> _storeFutures = {};

  static const Duration cacheDuration = Duration(hours: 1);

  static Future<Store> fetchStore(String storeId) async {
    if (_storeCache.containsKey(storeId)) {
      final cachedTime = _storeCacheTimestamps[storeId];
      if (cachedTime != null &&
          DateTime.now().difference(cachedTime) < cacheDuration) {
        return Future.value(_storeCache[storeId]!);
      } else {
        _storeCache.remove(storeId);
        _storeCacheTimestamps.remove(storeId);
      }
    }

    if (_storeFutures.containsKey(storeId)) {
      return _storeFutures[storeId]!;
    }

    final future = _fetchStoreFromApi(storeId).then((store) {
      _storeCache[storeId] = store;
      _storeCacheTimestamps[storeId] = DateTime.now();
      _storeFutures.remove(storeId);
      return store;
    }).catchError((error) {
      _storeFutures.remove(storeId);
      throw error;
    });

    _storeFutures[storeId] = future;

    return future;
  }

  static Future<Store> _fetchStoreFromApi(String storeId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('$endpoint/$storeId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Store.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token');
      } else if (response.statusCode == 404) {
        throw Exception('Store not found');
      } else {
        throw Exception('Failed to load store: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching store: $e');
      rethrow;
    }
  }

  static Future<List<Store>> getStoresWithPincode(String pincode) async {
    try {
      final response = await http.get(
        Uri.parse('$endpoint/pincode/$pincode'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> storesJson = jsonDecode(response.body);
        return storesJson.map((json) => Store.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load stores');
      }
    } catch (e) {
      log('Error fetching stores by pincode: $e');
      rethrow;
    }
  }

  static Future<List<Store>> getStoreByPincodeAndCategory(
      String pincode, String category) async {
    try {
      final response = await http.get(
        Uri.parse('$endpoint/pincode/$pincode/category/$category'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> storesJson = jsonDecode(response.body);
        return storesJson.map((json) => Store.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load stores by category');
      }
    } catch (e) {
      log('Error fetching stores by category: $e');
      rethrow;
    }
  }

  static Future<List<Store>> searchStores(
      String pincode, String nameContains) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${GlobalConsts.backend_url}/search/stores/$pincode?term=$nameContains'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> storesJson = jsonDecode(response.body);
        return storesJson.map((json) => Store.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search stores');
      }
    } catch (e) {
      log('Error searching stores: $e');
      rethrow;
    }
  }

  static Future<List<Store>> getStoreByPincodeAndSubCategory(
      String pincode, String subCategory) async {
    http.Request req = http.Request('GET',
        Uri.parse('$endpoint/pincode/$pincode/subcategory/$subCategory'));

    http.StreamedResponse response = await req.send();
    if (response.statusCode == 200) {
      List<Store> stores = [];
      var body = await response.stream.bytesToString();
      for (var store in jsonDecode(body)) {
        stores.add(Store.fromJson(store));
      }
      return stores;
    } else {
      return [];
    }
  }

  static void clearCache() {
    _storeCache.clear();
    _storeCacheTimestamps.clear();
    _storeFutures.clear();
  }
}
