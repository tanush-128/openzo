// type Store struct {
// 	gorm.Model
// 	Name                string `json:"name"`
// 	UserEmail           string `json:"user_email"`
// 	Image               string `json:"image"`
// 	Address             string `json:"address"`
// 	Phone               string `json:"phone"`
// 	Pincode             string `json:"pincode"`
// 	Location            string `json:"location"`
// 	OpeningTime         string    `json:"opening_time"`
// ClosingTime         string    `json:"closing_time"`
// 	OnlineDiscovery     bool   `json:"online_discovery" gorm:"default:true"`
// 	SelfDeliveryService bool   `json:"self_delivery_service" gorm:"default:false"`
// StoreType           StoreType `json:"store_type"`

// }

// type StoreType string

// const (
// 	// StoreTypeGrocery represents a grocery store
// 	StoreTypeGrocery StoreType = "grocery"

// 	// StoreTypePharmacy represents a pharmacy store
// 	StoreTypePharmacy StoreType = "pharmacy"

// 	// StoreTypeRestaurant represents a restaurant
// 	StoreTypeRestaurant StoreType = "restaurant"

// 	// StoreTypeElectronics represents an electronics store
// 	StoreTypeElectronics StoreType = "electronics"

// 	// StoreTypeClothing represents a clothing store
// 	StoreTypeClothing StoreType = "clothing"

// 	// StoreTypeBook represents a book store
// 	StoreTypeBook StoreType = "book"

// 	// StoreTypeConvenience represents a convenience store
// 	StoreTypeConvenience StoreType = "convenience"
// )

import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:openzo_frontend/constants/constants.dart';
// 1.General Stores:

// a) Household essentials

// b) Cleaning supplies

// c) Snacks and beverages

// d) Personal care products

// e) Pet care items

// f) Office supplies

// g) Toys and games

// h) Kitchenware

// i) Seasonal items

// j) Health and wellness products

// 2.Stationery Store:

// a) Writing instruments

// b) Notebooks and pads

// c) Art supplies

// d) Desk accessories

// e) Calendars and planners

// f) Filing and organization

// g) Crafting materials

// h) School supplies

// i) Presentation tools

// j) Office furniture

// 3.Electronic Stores:

// a) Smartphones and accessories

// b) Laptops and computers

// c) Audio devices

// d) Cameras and photography equipment

// e) Home appliances

// f) Gaming consoles and accessories

// g) Wearable technology

// h) Cables and connectors

// i) Batteries and chargers

// j) Virtual reality products

// 4.	Fashion Stores:

// a) Men’s clothing

// b) Women’s clothing

// c) Kids’ clothing

// d) Shoes and footwear

// e) Accessories (hats, scarves, etc.)

// f) Jewelery

// g) Handbags and purses

// h) Sunglasses

// i) Watches

// j) Formal wear

// 1. Footwear Stores:

// a) Men’s shoes

// b) Women’s shoes

// c) Athletic footwear

// d) Casual shoes

// e) Boots and booties

// f) Sandals

// g) Slippers

// h) Kids’ shoes

// i) Work and safety shoes

// j) Specialty footwear (dance, hiking, etc.)

// 6.	Accessory Stores:

// a) Handbags and clutches

// b) Jewelry

// c) Hats and caps

// d) Scarves and wraps

// e) Sunglasses

// f) Watches

// g) Belts

// h) Gloves and mittens

// i) Hair accessories

// j) Tech accessories

// 7.	Rental Stores:

// a) Event equipment

// b) Tools and machinery

// c) Party supplies

// d) Formal attire rentals

// e) Outdoor gear

// f) Furniture rentals

// g) Home appliance rentals

// h) Vehicle rentals

// i) Audio-visual equipment

// j) Recreational equipment

// 8.	Grocery Stores:

// a) Fresh produce

// b) Dairy and eggs

// c) Meat and seafood

// d) Canned and packaged goods

// e) Bakery items

// f) Frozen foods

// g) Beverages

// h) Snacks and sweets

// i) Organic and natural products

// j) International foods

// 9.	Beauty and Products Stores:

// a) Skincare

// b) Makeup

// c) Haircare

// d) Fragrances

// e) Bath and body products

// f) Nail care

// g) Men’s grooming products

// h) Beauty tools and accessories

// i) Wellness products

// j) Specialty beauty items

// 10.	Sports Stores:

// a) Athletic apparel

// b) Footwear for sports

// c) Exercise equipment

// d) Team sports gear

// e) Outdoor and adventure gear

// f) Yoga and fitness accessories

// g) Swimwear

// h) Sports nutrition

// i) Recovery and injury prevention

// j) Camping and hiking equipment
enum StoreType {
  general_store,
  stationery,
  electronics,
  fashion,
  footwear,
  accessories,
  rental,
  grocery,
  beauty,
  sports,
}

class Store {
  final String name;
  final String userEmail;
  final String image;
  final String location;
  bool onlineDiscovery;
  final bool selfDeliveryService;
  final String pincode;
  final String phone;
  final String description;
  final String address;
  final String openingTime;
  final String closingTime;
  final String id;
  final StoreType storeType;

  Store({
    required this.id,
    required this.name,
    required this.phone,
    required this.userEmail,
    required this.pincode,
    required this.address,
    required this.location,
    required this.openingTime,
    required this.description,
    required this.closingTime,
    required this.image,
    required this.onlineDiscovery,
    required this.selfDeliveryService,
    required this.storeType,
  });

  static getStoreWithUserEmail(String userEmail) async {
    var response = await http.get(
        Uri.parse('${GlobalConsts.backend_url}/store/?user_email=$userEmail'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': GlobalConsts.token,
        });
    if (response.statusCode == 200) {
      print(response.body);
      return Store.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  static Future<Store> fetchStore(String storeId) async {
    var response = await http.get(
        Uri.parse('${GlobalConsts.backend_url}/stores/$storeId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'Authorization': GlobalConsts.token,
        });
    if (response.statusCode == 200) {
      print(Store.fromJson(jsonDecode(response.body)).name);
      return Store.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load store');
    }
  }

  static Future<List<Store>> getStoresWithPincode(String pincode) async {
    var response = await http.get(
        Uri.parse('${GlobalConsts.backend_url}/stores/pincode/123456'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    // 'Authorization': GlobalConsts.token,
    if (response.statusCode == 200) {
      List<Store> stores = [];
      for (var store in jsonDecode(response.body)) {
        stores.add(Store.fromJson(store));
      }
      log(stores.toString());
      return stores;
    } else {
      print(response.body);
      return [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'user_email': userEmail,
      'pincode': pincode,
      'address': address,
      'location': location,
      'opening_time': openingTime,
      'closing_time': closingTime,
      'description': description,
      'image': image,
      'online_discovery': onlineDiscovery,
      'self_delivery_service': selfDeliveryService,
      'store_type': storeType.toString().split('.').last,
    };
  }

  static Future<List<Store>> getStoreByPincodeAndCategory(
      String pincode, String category) async {
    // var response = await http.get(
    //     Uri.parse(
    //         '${GlobalConsts.backend_url}/store?pincode=$pincode&store_type=$category'),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //       'Authorization': GlobalConsts.token,
    //     });
    http.Request req = http.Request(
        'GET',
        Uri.parse(
            '${GlobalConsts.backend_url}/store/?pincode=$pincode&store_type=$category'));

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
          '${GlobalConsts.backend_url}/store/?pincode=$pincode&name_contains=$nameContains'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': GlobalConsts.token,
      },
    );
    print(res.body);
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
      phone: json['phone'],
      pincode: json['pincode'],
      name: json['name'],
      userEmail: json['user_email'],
      image: json['image'],
      location: json['location'],
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      onlineDiscovery: json['online_discovery'],
      selfDeliveryService: json['self_delivery_service'],
      description: json['description'],
      storeType: StoreType.values
          .firstWhere((e) => e.toString() == 'StoreType.${json['store_type']}'),
    );
  }
}
