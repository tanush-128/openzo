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

import 'package:http/http.dart' as http;
import 'package:openzo_frontend/constants/constants.dart';

enum StoreType {
  grocery,
  pharmacy,
  restaurant,
  electronics,
  clothing,
  book,
  convenience;
}

class Store {
  final String name;
  final String userEmail;
  final String image;
  final String location;
  final bool onlineDiscovery;
  final bool selfDeliveryService;
  final String pincode;
  final String phone;
  final String address;
  final String openingTime;
  final String closingTime;
  final int id;
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
    required this.closingTime,
    required this.image,
    required this.onlineDiscovery,
    required this.selfDeliveryService,
    required this.storeType,
  });

  static addStore(Store store) {
    http.post(Uri.parse('${GlobalConsts.backend_url}/store'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': GlobalConsts.token,
        },
        body: jsonEncode({
          'name': store.name,
          'user_email': store.userEmail,
          'image': store.image,
          'location': store.location,
          'online_discovery': store.onlineDiscovery,
          'self_delivery_service': store.selfDeliveryService,
          'pincode': store.pincode,
          'phone': store.phone,
          'address': store.address,
          'opening_time': store.openingTime,
          'closing_time': store.closingTime,
          'store_type': store.storeType.toString().split('.').last,
        }));
  }

  static getStoreWithUserEmail(String userEmail) async {
    var response = await http.get(
        Uri.parse('${GlobalConsts.backend_url}/store?user_email=$userEmail'),
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

  static Future<List<Store>> getStoresWithPincode(String pincode) async {
    var response = await http.get(
        Uri.parse('${GlobalConsts.backend_url}/store?pincode=$pincode'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': GlobalConsts.token,
        });
    if (response.statusCode == 200) {
      List<Store> stores = [];
      for (var store in jsonDecode(response.body)) {
        stores.add(Store.fromJson(store));
      }
      return stores;
    } else {
      return [];
    }
  }


  // static Future<List<Product>> searchProducts(
  //     String pincode, String nameContains) async {
  //   List<Product> products = [];
  //   http.Response res = await http.get(
  //     Uri.parse(
  //         '${GlobalConsts.backend_url}/product?pincode=$pincode&name_contains=$nameContains'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'Authorization': GlobalConsts.token,
  //     },
  //   );
  //   print(res.body);
  //   if (res.statusCode == 200) {
  //     for (var product in jsonDecode(res.body)) {
  //       products.add(Product.fromJson(product));
  //     }
  //     return products;
  //   } else {
  //     return [];
  //   }
  // }

  static Future<List<Store>>  searchStores(String pincode, String nameContains) async {
    List<Store> stores = [];
    http.Response res = await http.get(
      Uri.parse(
          '${GlobalConsts.backend_url}/store?pincode=$pincode&name_contains=$nameContains'),
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
      id: json['ID'],
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
      storeType: StoreType.values
          .firstWhere((e) => e.toString() == 'StoreType.' + json['store_type']),
    );
  }
}
