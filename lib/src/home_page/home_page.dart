import 'package:flutter/material.dart';
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 0.1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 0.1,
                    blurRadius: 2,
                    offset: const Offset(-2, -1),
                  )
                ],
              ),
              child: TextField(
                onTap: () {
                  showSearch(context: context, delegate: LocalSearchDelegate());
                },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: GlobalStyle.primaryColor,
                  ),
                  suffixIcon: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VerticalDivider(
                        color: Color.fromARGB(255, 0, 0, 0),
                        width: 1,
                        thickness: 1,
                      ),
                      Icon(
                        Icons.mic,
                        color: GlobalStyle.primaryColor,
                      )
                    ],
                  ),
                  hintText: 'Search',
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const AdSpace(),
              const SizedBox(height: 20),
              const MainCategories(),
              const SizedBox(height: 20),
              const Separator(title: "EXPLORE"),
              const SizedBox(height: 10),
            
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: GlobalConsts.StoreCategories.sublist(0, 5)
                              .map((e) => StoreCategoryTile(storeCategory: e))
                              .toList(),
                        ),
                        Row(
                          children: GlobalConsts.StoreCategories.sublist(5, 10)
                              .map((e) => StoreCategoryTile(storeCategory: e))
                              .toList(),
                        ),
                      ])),
              const SizedBox(height: 20),
              const Separator(title: "RECOMMENDED CATEGORIES"),
              const SizedBox(height: 10),
              const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      Row(
                        children: [],
                      ),
                    ],
                  )),
              const SizedBox(height: 20),
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
    return Container(
      child: GridView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 15,
        ),
        children: [
          MainCategoryTile(
            title: "Order food",
          ),
          MainCategoryTile(title: "Ride Hail"),
          MainCategoryTile(
            title: "Services",
          ),
          MainCategoryTile(
            title: "Stores",
          ),
          MainCategoryTile(
            title: "Rentals",
          ),
          MainCategoryTile(
            title: "Products",
          ),
          MainCategoryTile(title: "Resell"),
          MainCategoryTile(title: "Local events"),
          MainCategoryTile(title: "Hot deals"),
        ],
      ),
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
    return SizedBox(
      height: 80,
      width: 100,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage('assets/images/top/$title.png'),
              //   fit: BoxFit.cover,
              // ),
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0.1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0.1,
                  blurRadius: 2,
                  offset: const Offset(-2, -1),
                ),
              ],
            ),
            child: Image.asset('assets/images/top/$title.png'),
          ),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
