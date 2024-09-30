import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:openzo_frontend/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreBasicDetails {
  final String id;
  final String name;
  final String image;
  final String address;
  final String category;
  final String subCategory;
  final String description;
  final double rating;
  final int reviewCount;

  StoreBasicDetails({
    required this.id,
    required this.name,
    required this.image,
    required this.address,
    required this.category,
    required this.subCategory,
    required this.description,
    required this.rating,
    required this.reviewCount,
  });

  factory StoreBasicDetails.fromJson(Map<String, dynamic> json) {
    return StoreBasicDetails(
      id: json['store_id'],
      name: json['store_name'],
      image: json['store_image'],
      address: json['store_address'],
      category: json['store_category'],
      subCategory: json['store_sub_category'],
      description: json['store_description'],
      rating: double.parse(json['store_rating'].toString()),
      reviewCount: int.parse(json['store_review_count'].toString()),
    );
  }
}

class Store {
  final String id;
  final String name;
  final String image;
  final String location;
// bool onlineDiscovery;
  final bool selfDeliveryService;

  final String pincode;
  final String phone;
  final String description;
  final String address;
  final DateTime openingTime;
  final DateTime closingTime;
// String userId = "";
  bool detailsComplete = false;

  String category = "";
  String subCategory = "";

//Restuarant specific fields so all optional

  String? primaryCuisine;
  String? secondaryCuisine;
  int? avgPricePerPerson;
  bool? pureVeg;
  bool? alcohol;
  int? tableCount;
  int? seatingCapacity;
  bool? reserveTableOnline;
  int deliveryCharge;
  double rating;
  int reviewCount;
  bool busy;
  int packingCharge = 0;

  Store({
    required this.id,
    required this.name,
// required this.phone,
    required this.pincode,
    required this.address,
    required this.location,
    required this.openingTime,
    required this.description,
    required this.closingTime,
    required this.image,
    required this.phone,
// required this.onlineDiscovery,
    required this.selfDeliveryService,
    this.category = "",
    this.subCategory = "",
    this.detailsComplete = false,
    this.busy = false,

//Restuarant specific fields
    this.primaryCuisine,
    this.secondaryCuisine,
    this.avgPricePerPerson,
    this.pureVeg,
    this.alcohol,
    this.tableCount,
    this.seatingCapacity,
    this.reserveTableOnline,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.deliveryCharge = 0,
    this.packingCharge = 0,
  });

  // getter bool closed based on current time of dat and opening and closing time
  bool get closed {
    DateTime now = DateTime.now();
    // comapare only time not date
    DateTime opening = DateTime(
        now.year, now.month, now.day, openingTime.hour, openingTime.minute);
    DateTime closing = DateTime(
        now.year, now.month, now.day, closingTime.hour, closingTime.minute);
    return now.isBefore(opening) || now.isAfter(closing);
  }

  // Static in-memory cache
  static final Map<String, Store> _storeCache = {};

  // Static map to keep track of ongoing fetch requests
  static final Map<String, Future<Store>> _storeFutures = {};

  // Optional: Cache timestamps for invalidation
  static final Map<String, DateTime> _storeCacheTimestamps = {};

  // Define cache duration
  static final Duration cacheDuration = const Duration(hours: 1);
  StoreType get storeType {
    return GlobalConsts.categories
            .where((element) => element.name == category)
            .firstOrNull
            ?.type ??
        StoreType.service;
  }

  bool get campusDeliveryService {
    return primaryCuisine == 'MIT Campus Only' ||
        secondaryCuisine == 'MIT Campus Only';
  }

  static String endpoint = '${GlobalConsts.backend_url}/stores';
  // static String endpoint = 'https://lnn7jf70-8080.inc1.devtunnels.ms';

  /// Fetch a single store by its ID with caching
  static Future<Store> fetchStore(String storeId) async {
    // Check if the store is already in the cache and not expired
    if (_storeCache.containsKey(storeId)) {
      final cachedTime = _storeCacheTimestamps[storeId];
      if (cachedTime != null &&
          DateTime.now().difference(cachedTime) < cacheDuration) {
        return Future.value(_storeCache[storeId]!);
      } else {
        // Cache expired, remove it
        _storeCache.remove(storeId);
        _storeCacheTimestamps.remove(storeId);
      }
    }

    // If a fetch is already in progress for this storeId, return the existing Future
    if (_storeFutures.containsKey(storeId)) {
      return _storeFutures[storeId]!;
    }

    // Initiate a new fetch and store the Future in _storeFutures
    final future = _fetchStoreFromApi(storeId).then((store) {
      _storeCache[storeId] = store; // Store in cache
      _storeCacheTimestamps[storeId] = DateTime.now(); // Update cache timestamp
      _storeFutures.remove(storeId); // Remove from ongoing fetches
      return store;
    }).catchError((error) {
      _storeFutures.remove(storeId); // Remove from ongoing fetches on error
      throw error;
    });

    _storeFutures[storeId] = future;

    return future;
  }

  /// Internal method to fetch store data from the API
  static Future<Store> _fetchStoreFromApi(String storeId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('$endpoint/$storeId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token, // Correctly include the token
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final store = Store.fromJson(data);
        log('Fetched Store: ${store.name}');
        return store;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token');
      } else if (response.statusCode == 404) {
        throw Exception('Store not found');
      } else {
        throw Exception(
            'Failed to load store: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      log('Error fetching store: $e');
      rethrow;
    }
  }

  /// Optional: Method to clear the cache (useful for testing or refreshing data)
  static void clearCache() {
    _storeCache.clear();
    _storeCacheTimestamps.clear();
    _storeFutures.clear();
  }

  static Future<List<Store>> getStoresWithPincode(String pincode) async {
    var response = await http
        .get(Uri.parse('$endpoint/pincode/$pincode'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
// 'Authorization': GlobalConsts.token,
    if (response.statusCode == 200) {
      List<Store> stores = [];

      for (var store in jsonDecode(response.body)) {
        stores.add(Store.fromJson(store));
      }

      return stores;
    } else {
      print(response.body);
      return [];
    }
  }

  static Future<List<Store>> getStoreByPincodeAndCategory(
      String pincode, String category) async {
    log('pincode: $pincode, category: $category');
    http.Request req = http.Request(
        'GET', Uri.parse('$endpoint/pincode/$pincode/category/$category'));

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

  static Future<List<Store>> searchStores(
      String pincode, String nameContains) async {
    List<Store> stores = [];
    http.Response res = await http.get(
      Uri.parse(
          '${GlobalConsts.backend_url}/search/stores/$pincode?term=$nameContains'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': GlobalConsts.token,
      },
    );

    if (res.statusCode == 200) {
      for (var store in jsonDecode(res.body)) {
        stores.add(Store.fromJson(store));
      }
      return stores;
    } else {
      return [];
    }
  }

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      address: json['address'],
      pincode: json['pincode'],
      name: json['name'],
      phone: json['phone'] ?? "",
      image: json['image'],
      location: json['location'],
      openingTime: DateTime.tryParse(json['opening_time']) ?? DateTime.now(),
      closingTime: DateTime.tryParse(json['closing_time']) ??
          DateTime.now().add(Duration(hours: 1)),
      selfDeliveryService: json['self_delivery_service'],
      description: json['description'],
      detailsComplete: json['details_complete'] ?? false,
      category: json['category'] ?? "",
      subCategory: json['sub_category'] ?? "",
      primaryCuisine: json['primary_cuisine'],
      secondaryCuisine: json['secondary_cuisine'],
      avgPricePerPerson: json['avg_price_per_person'],
      pureVeg: json['pure_veg'] ?? false,
      alcohol: json['alcohol'],
      tableCount: json['table_count'],
      seatingCapacity: json['seating_capacity'],
      reserveTableOnline: json['reserve_table_online'],
      rating: double.parse(json['rating'].toString()),
      reviewCount: int.parse(json['review_count'].toString()),
      deliveryCharge: json['delivery_charge'] ?? 0,
      busy: json['busy'] ?? false,
      packingCharge: json['packaging_charge'] ?? 0,
    );
  }
}
