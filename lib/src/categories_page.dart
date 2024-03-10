import 'package:flutter/material.dart';
import 'package:openzo_frontend/src/home_page/store_category.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Categories'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                // crossAxisSpacing: 10,
                // mainAxisSpacing: 10,
              ),
              children: [
                StoreCategory(
                  imageName: "Grocery stores.png",
                  categoryName: "Grocery",
                ),
                StoreCategory(
                  imageName: "All in one stores.png",
                  categoryName: "All in one",
                ),
                StoreCategory(
                  imageName: "Electronic stores.png",
                  categoryName: "Electronics",
                ),
                StoreCategory(
                  imageName: "Fashion stores.png",
                  categoryName: "Fashion",
                ),
                StoreCategory(
                  imageName: "Accessory store.png",
                  categoryName: "Accessories",
                ),
                StoreCategory(
                  imageName: "Fashion stores.png",
                  categoryName: "Fashion",
                ),
                StoreCategory(
                  imageName: "Foods and snacks.png",
                  categoryName: "Food & Snacks",
                ),
                StoreCategory(
                  imageName: "Internet and technology stores.png",
                  categoryName: "Internet & Technology",
                ),
                StoreCategory(
                  imageName: "Rental stores.png",
                  categoryName: "Rental",
                ),
                StoreCategory(
                  imageName: "Stationary store.png",
                  categoryName: "Stationary",
                ),
              ],
            ),
          ),
        ));
  }
}
