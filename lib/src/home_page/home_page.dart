import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/components/globalSearchBar.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/src/home_page/ad_carousel.dart';
import 'package:openzo_frontend/src/home_page/store_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              leadingWidth: 0,
              expandedHeight: 200,
              pinned: true,
              centerTitle: true,
              collapsedHeight: 80,
              flexibleSpace: FlexibleSpaceBar(
                title: const GlobalSearchBar(),
                centerTitle: true,
                titlePadding: const EdgeInsets.all(12),
                expandedTitleScale: 1,
                background: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    image: DecorationImage(
                        image: AssetImage("assets/images/openzo1.png"),
                        fit: BoxFit.cover),
                  ),
                ),
              )),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const Separator(title: "EXPLORE"),
                  const MainCategories(),
                  const SizedBox(height: 20),
                  const Separator(title: "ADS"),
                  const AdSpace(),
                  const SizedBox(height: 10),
                  const Separator(title: "RECOMMENDED STORES"),
                  const SizedBox(height: 20),
                  FutureBuilder(
                      future: Store.getStoresWithPincode("123456"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
        ],
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
            context.go('/category');
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
            height: 54,
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
