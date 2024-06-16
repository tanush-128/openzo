// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:openzo_frontend/constants/constants.dart';
// import 'package:openzo_frontend/models/store.dart';
// import 'package:openzo_frontend/src/home_page/ad_carousel.dart';
// import 'package:openzo_frontend/src/home_page/home_page.dart';
// import 'package:openzo_frontend/src/home_page/store_card.dart';
// import 'package:openzo_frontend/src/stores_of_category/product_category_page.dart';

// class StoresOfCategory extends StatefulWidget {
//   // StoreCategory storeCategory;
//   String categoryName;
//   StoresOfCategory({super.key, required this.categoryName});

//   @override
//   State<StoresOfCategory> createState() => _StoresOfCategoryState();
// }

// class _StoresOfCategoryState extends State<StoresOfCategory> {
//   @override
//   Widget build(BuildContext context) {
//     StoreCategory storeCategory = GlobalConsts.StoreCategories.firstWhere(
//         (element) => element.categoryName == widget.categoryName,
//         orElse: () => GlobalConsts.StoreCategories.first);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.categoryName),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Center(
//               child: Column(
//             children: [
//               const AdSpace(),
//               const SizedBox(height: 16),
//               const Separator(title: "Categories"),
//               const SizedBox(height: 16),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: storeCategory.productCategories
//                           .sublist(0,
//                               (storeCategory.productCategories.length + 1) ~/ 2)
//                           .map(
//                             (e) => ProductCategoryTile(
//                               e: e,
//                               widget: widget,
//                             ),
//                           )
//                           .toList(),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: storeCategory.productCategories
//                           .sublist(
//                               (storeCategory.productCategories.length + 1) ~/ 2,
//                               storeCategory.productCategories.length)
//                           .map(
//                             (e) => ProductCategoryTile(
//                               widget: widget,
//                               e: e,
//                             ),
//                           )
//                           .toList(),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Separator(title: "Stores"),
//               FutureBuilder(
//                   future: Store.getStoreByPincodeAndCategory(
//                       "123456", storeCategory.storeType.name),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     }
//                     if (snapshot.hasError) {
//                       return Text("Error: ${snapshot.error}");
//                     }
//                     if (snapshot.data?.isEmpty ?? true) {
//                       return const Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text('Sorry, no stores found in this category!'),
//                             Text(
//                               "We are aggressively working to add more stores",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 16),
//                             )
//                           ],
//                         ),
//                       );
//                     }
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: snapshot.data?.length,
//                       itemBuilder: (context, index) {
//                         return StoreCard(store: snapshot.data![index]);
//                       },
//                     );
//                   }),
//             ],
//           )),
//         ),
//       ),
//     );
//   }
// }

// class ProductCategoryTile extends StatelessWidget {
//   ProductCategory e;
//   ProductCategoryTile({
//     super.key,
//     required this.widget,
//     required this.e,
//   });

//   final StoresOfCategory widget;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         // Navigator.push(
//         //     context,
//         //     MaterialPageRoute(
//         //         builder: (context) => ProductCategoryPage(productCategory: e)));
//         context.go('/product?category=${e.categoryName}');
//       },
//       child: SizedBox(
//         height: 120,
//         width: 108,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               height: 70,
//               width: 70,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     spreadRadius: 0.1,
//                     blurRadius: 2,
//                     offset: const Offset(0, 1),
//                   ),
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     spreadRadius: 0.1,
//                     blurRadius: 2,
//                     offset: const Offset(-2, -1),
//                   ),
//                 ],
//                 // image: DecorationImage(
//                 //   image: AssetImage(
//                 //       "assets/images/${storeCategory.categoryName}/${e.image}.png"),
//                 // ),
//               ),
//               child: Image.asset(
//                 "assets/images/${widget.categoryName}/${e.image}.png",
//                 fit: BoxFit.contain,
//               ),
//             ),
//             Text(
//               e.categoryName
//                   .split(" ")
//                   .map((e) => e[0].toUpperCase() + e.substring(1))
//                   .join(" "),
//               maxLines: 2,
//               style: TextStyle(
//                 fontSize: 12,
//                 // fontWeight: FontWeight.w400,
//                 color: Colors.grey.shade700,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
