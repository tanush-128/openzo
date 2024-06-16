import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/components/globalSearchBar.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/src/home_page/ad_carousel.dart';
import 'package:openzo_frontend/src/home_page/local_search_delegate.dart';
import 'package:openzo_frontend/src/home_page/store_card.dart';
import 'package:openzo_frontend/src/home_page/store_category.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: GlobalSearchBar(),
            )),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              const Separator(title: "EXPLORE"),
              const MainCategories(),
              const SizedBox(height: 20),
              const AdSpace(),
              const SizedBox(height: 10),
              // SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //     child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             children: GlobalConsts.StoreCategories.sublist(0, 5)
              //                 .map((e) => StoreCategoryTile(storeCategory: e))
              //                 .toList(),
              //           ),
              //           Row(
              //             children: GlobalConsts.StoreCategories.sublist(5, 10)
              //                 .map((e) => StoreCategoryTile(storeCategory: e))
              //                 .toList(),
              //           ),
              //         ])),
              // const SizedBox(height: 20),
              // const Separator(title: "RECOMMENDED CATEGORIES"),
              // const SizedBox(height: 10),
              // const SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //     child: Column(
              //       children: [
              //         Row(
              //           children: [],
              //         ),
              //       ],
              //     )),
              // const SizedBox(height: 20),
              const Separator(title: "RECOMMENDED STORES"),
              const SizedBox(height: 20),
              FutureBuilder(
                  future: Store.getStoresWithPincode("123456"),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString(),
                            style: const TextStyle(color: Colors.red)),
                      );
                    }
                    if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No stores found'),
                      );
                    }
                    return Column(
                      children: snapshot.data!
                          .map((store) => StoreCard(store: store))
                          .toList(),
                    );
                  }),
              const SizedBox(height: 20),
              const Separator(title: "END OF HOME"),
            ],
          ),
        ),
      ),
    );
  }
}

class MainCategories extends StatelessWidget {
  const MainCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, mainAxisSpacing: 15),
      children: [
        MainCategoryTile(title: 'Food delivery'),
        MainCategoryTile(title: 'Services'),
        MainCategoryTile(title: 'Stores'),
        MainCategoryTile(title: 'Grocery delivery'),
        MainCategoryTile(title: 'Service stores'),
        MainCategoryTile(title: 'Hotel rooms'),
        MainCategoryTile(title: 'Ride hire'),
        InkWell(
          onTap: () {
            context.go('/categories');
          },
          child: Column(
            children: [
              Container(
                width: 70,
                height: 70,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Colors.white,
                ),
                child: const Icon(Icons.arrow_right_alt_rounded),
              ),
              const Text("More", style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}

class Separator extends StatelessWidget {
  final String title;
  const Separator({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade700,
                letterSpacing: 1.5),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class MainCategoryTile extends StatelessWidget {
  String title;
  MainCategoryTile({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.white,
            ),
            child: Image.asset('assets/images/home page icons/${title}.png'),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
