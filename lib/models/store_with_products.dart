// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:openzo_frontend/constants/constants.dart';
// import 'package:openzo_frontend/models/product.dart';
// import 'package:openzo_frontend/models/store.dart';

// class StoreWithProduct {
//   final Store store;
//   final List<Product> products;

//   StoreWithProduct({
//     required this.store,
//     required this.products,
//   });

//   factory StoreWithProduct.fromJson(Map<String, dynamic> json) {
//     return StoreWithProduct(
//       store: Store.fromJson(json['store']),
//       products: List<Product>.from(
//         json['products'].map((product) => Product.fromJson(product)),
//       ),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'store': store.toJson(),
//       'products': products.map((e) => e.toJson()).toList(),
//     };
//   }

//   static Future<List<StoreWithProduct>> getStoresAndProductsByPincode(
//       String pincode, String category) async {
//     var response = await http.get(
//       Uri.parse(
//           '${GlobalConsts.backend_url}/store/pincode?pincode=$pincode&category=$category'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//     );

//     if (response.statusCode == 200) {
//       List<StoreWithProduct> storesWithProducts = [];
//       // print(response.body);
//       List<dynamic> storesWithProductsJson = jsonDecode(response.body);
//       print(storesWithProductsJson);
//       for (var storeWithProductJson in storesWithProductsJson) {
//         storesWithProducts.add(StoreWithProduct.fromJson(storeWithProductJson));
//       }
//       return storesWithProducts;
//     } else {
//       throw Exception('Failed to load store');
//     }
//   }
// }
