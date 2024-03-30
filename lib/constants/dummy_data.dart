// import 'dart:math';

// import 'package:openzo_frontend/models/product.dart';
// import 'package:openzo_frontend/models/store.dart';

// List<String> storeNames = [
//   'Green Mart',
//   'Health Haven',
//   'Tasty Bites',
//   'Gadget Galaxy',
//   'Fashion House',
// ];

// List<String> locations = [
//   'Downtown',
//   'Suburbia',
//   'City Center',
//   'Tech Park',
//   'Mall District',
// ];

// List<String> categories = [
//   'Fruits & Vegetables',
//   'Medicines',
//   'Fast Food',
//   'Electronics',
//   'Clothing',
// ];

// List<Store> generateStores() {
//   List<Store> stores = [];

//   for (int i = 1; i <= storeNames.length; i++) {
//     stores.add(
//       Store(
//         name: storeNames[i - 1],
//         description: 'Description for ${storeNames[i - 1]}',
//         userEmail: 'user$i@example.com',
//         image: 'store_image_$i.jpg',
//         location: locations[i - 1],
//         onlineDiscovery: Random().nextBool(),
//         selfDeliveryService: Random().nextBool(),
//         pincode: 'PIN${1000 + i}',
//         phone: '123-456-789$i',
//         address: 'Address $i, ${locations[i - 1]}',
//         openingTime: '09:00 AM',
//         closingTime: '06:00 PM',
//         id: i,
//         storeType: StoreType.values[i % StoreType.values.length],
//       ),
//     );
//   }

//   return stores;
// }

// List<Product> generateProducts(List<Store> stores) {
//   List<Product> products = [];
//   int productId = 1;

//   for (Store store in stores) {
//     for (int i = 1; i <= categories.length; i++) {
//       products.add(
//         Product(
//           id: productId,
//           name: 'Product $i for ${store.name}',
//           description: 'Description for Product $i',
//           mrp: (Random().nextDouble() * 100).toInt(),
//           quantity: Random().nextInt(50) + 1,
//           images: [], // Add images if needed
//           category: categories[i - 1],
//           storeID: store.id,
//           barcode: 'Barcode${1000 + i}',
//         ),
//       );
//       productId++;
//     }
//   }

//   return products;
// }

// List<Store> stores = generateStores();
// List<Product> products = generateProducts(stores);

// class DummyData {
//   static List<Store> getStores() {
//     return stores;
//   }

//   static List<Product> getProducts() {
//     return products;
//   }
// }
