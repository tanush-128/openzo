// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:openzo_frontend/constants/constants.dart';
// import 'package:openzo_frontend/models/store_with_products.dart';
// import 'package:openzo_frontend/src/home_page/home_page.dart';
// import 'package:openzo_frontend/src/store_page/product_card.dart';
// import 'package:openzo_frontend/src/store_page/store_page.dart';
// import 'package:openzo_frontend/src/stores_of_category/vertical_product_card.dart';

// class ProductCategoryPage extends StatefulWidget {
//   // ProductCategory productCategory;
//   String productCategoryName;
//   ProductCategoryPage({super.key, required this.productCategoryName});

//   @override
//   State<ProductCategoryPage> createState() => _ProductCategoryPageState();
// }

// class _ProductCategoryPageState extends State<ProductCategoryPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.productCategoryName),
//       ),
//       body: FutureBuilder(
//         future: StoreWithProduct.getStoresAndProductsByPincode(
//             "123456", widget.productCategoryName),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(
//                 child: Column(
//                   children: [
//                     // const AdSpace(),
//                     const SizedBox(height: 16),
//                     const Separator(title: "Stores"),
//                     const SizedBox(height: 16),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: snapshot.data!
//                             .map((e) =>
//                                 StoreWithProductsCard(storeWithProduct: e))
//                             .toList(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class StoreWithProductsCard extends StatelessWidget {
//   StoreWithProduct storeWithProduct;
//   StoreWithProductsCard({super.key, required this.storeWithProduct});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         // Navigator.push(
//         //     context,
//         //     MaterialPageRoute(
//         //         builder: (context) =>
//         //             StorePage(store: storeWithProduct.store)));
//         context.go('/store/${storeWithProduct.store.id}');
//       },
//       child: Container(
//         decoration: const BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey,
//                 spreadRadius: 0.1,
//                 blurRadius: 2,
//                 offset: Offset(0, 1),
//               ),
//               BoxShadow(
//                 color: Colors.grey,
//                 spreadRadius: 0.1,
//                 blurRadius: 2,
//                 offset: Offset(-2, -1),
//               ),
//             ],
//             borderRadius: BorderRadius.all(Radius.circular(10.0)),
//             color: Colors.white),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: MediaQuery.of(context).size.width * 0.9,
//               height: 200,
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(10),
//                     topRight: Radius.circular(10)),
//                 image: DecorationImage(
//                   image: NetworkImage(storeWithProduct.store.image),
//                 ),
//               ),
//             ),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     storeWithProduct.store.name,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               width: MediaQuery.of(context).size.width * 0.9,
//               child: const Center(
//                 child: Text(
//                   "Matching Products",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ),
//             // const Separator(title: "Matching Products"),
//             SizedBox(
//               // height: 205,
//               width: MediaQuery.of(context).size.width * 0.9,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: storeWithProduct.products
//                       .map((e) => Container(
//                             child: VerticalProductCard(
//                               addable: false,
//                               product: e,
//                             ),
//                           ))
//                       .toList(),
//                   // children: [
//                   //   VerticalProductCard(product: storeWithProduct.products[0]),
//                   //   VerticalProductCard(product: storeWithProduct.products[0]),
//                   //   VerticalProductCard(product: storeWithProduct.products[0]),
//                   //   VerticalProductCard(product: storeWithProduct.products[0]),
//                   // ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
