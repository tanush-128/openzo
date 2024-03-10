import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/ad.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/src/home_page/local_search_delegate.dart';
import 'package:openzo_frontend/src/home_page/store_card.dart';
import 'package:openzo_frontend/src/home_page/store_category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
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
                child: InkWell(
                  onTap: () {
                    showSearch(
                        context: context, delegate: LocalSearchDelegate());
                  },
                  child: TextField(
                    onChanged: (value) {
                      showSearch(
                          context: context, delegate: LocalSearchDelegate());
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
              const SizedBox(height: 20),
              FutureBuilder(
                future: Ad.fetchMany("123456"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No ads found'),
                    );
                  }
                  return CarouselSlider(
                    options: CarouselOptions(
                        height: 200.0,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 1600),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        pauseAutoPlayOnTouch: true,
                        aspectRatio: 3,
                        // padEnds: true,
                        viewportFraction: 1,
                        // enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal),
                    items: snapshot.data?.map((ad) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 0.1,
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                  image: DecorationImage(
                                      image: NetworkImage(ad.image),
                                      fit: BoxFit.cover),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16))),
                              child: Center(
                                child: Text(
                                  ad.name,
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "EXPLORE",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade700,
                          letterSpacing: 1.5),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      Row(
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
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
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
                      )
                    ],
                  )),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "RECOMMENDED FOR YOU",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade700,
                          letterSpacing: 1.5),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),
              FutureBuilder(
                  future: Store.getStoresWithPincode("123456"),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Store>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
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
                  })
            ],
          ),
        ),
      ),
    );
  }
}
