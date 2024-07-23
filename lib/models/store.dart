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
  final String openingTime;
  final String closingTime;
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

  double rating;
  int reviewCount;

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
  });

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

  static Future<Store> fetchStore(String storeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    var response = await http
        .get(Uri.parse('$endpoint/$storeId'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': '',
    });
    if (response.statusCode == 200) {
      log(Store.fromJson(jsonDecode(response.body)).name);
      return Store.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load store');
    }
  }

  static Future<List<Store>> getStoresWithPincode(String pincode) async {
    var response = await http
        .get(Uri.parse('$endpoint/pincode/123456'), headers: <String, String>{
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
  // router.GET("/pincode/:pincode/subcategory/:sub_category", handler.GetStoresByPincodeAndSubCategory)

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
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
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
    );
  }
}
