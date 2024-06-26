import 'package:flutter/material.dart';
import 'package:openzo_frontend/components/globalSearchBar.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/src/home_page/widgets/ad_carousel.dart';
import 'package:openzo_frontend/src/home_page/widgets/main_categories.dart';
import 'package:openzo_frontend/components/separator.dart';
import 'package:openzo_frontend/src/home_page/widgets/store_card.dart';
import 'package:openzo_frontend/src/home_page/widgets/stores_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _builSliverAppBar(),
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
                  // _buildStoresList(),
                  StoresList(
                    future: Store.getStoresWithPincode("123456"),
                  ),
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

  // FutureBuilder<List<Store>> _buildStoresList() {
  //   return FutureBuilder(
  //     future:
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       }
  //       if (snapshot.hasError) {
  //         return Center(
  //           child: Text(snapshot.error.toString(),
  //               style: const TextStyle(color: Colors.red)),
  //         );
  //       }
  //       if (snapshot.data!.isEmpty) {
  //         return const Center(
  //           child: Text('No stores found'),
  //         );
  //       }
  //       return Column(
  //         children:
  //             snapshot.data!.map((store) => StoreCard(store: store)).toList(),
  //       );
  //     },
  //   );
  // }

  SliverAppBar _builSliverAppBar() {
    return SliverAppBar(
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
      ),
    );
  }
}
