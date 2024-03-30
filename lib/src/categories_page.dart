import 'package:flutter/material.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/store.dart';
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
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.95,
                // crossAxisSpacing: 10,
                // mainAxisSpacing: 10,
              ),
              children: GlobalConsts.StoreCategories.map(
                  (e) => StoreCategoryTile(storeCategory: e)).toList(),
            ),
          ),
        ));
  }
}
