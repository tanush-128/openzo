import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/components/globalSearchBar.dart';
import 'package:openzo_frontend/components/separator.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/models/user.dart';

import 'package:openzo_frontend/providers/user_provider.dart';
import 'package:openzo_frontend/src/home_page/widgets/ad_carousel.dart';
import 'package:openzo_frontend/src/home_page/widgets/main_categories.dart';
import 'package:openzo_frontend/src/home_page/widgets/stores_list.dart';
import 'package:openzo_frontend/src/login/login_modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _builSliverAppBar(context),
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

  SliverAppBar _builSliverAppBar(BuildContext context) {
    return SliverAppBar(
      leadingWidth: 0,
      expandedHeight: 200,
      pinned: true,
      centerTitle: true,
      collapsedHeight: 80,
      // actions: [
      //   IconButton(
      //     onPressed: () {},
      //     icon: const Icon(
      //       Icons.account_circle_outlined,
      //       color: Colors.white,
      //       size: 48,
      //     ),
      //   )
      // ],

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
              image: AssetImage("assets/images/Splash Screen.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    User user = userProvider.user;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Explore your locality",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          if (user.pincode != null &&
                              user.city != null &&
                              user.state != null)
                            Text(
                              "${user.pincode}-${user.city}, ${user.state}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )
                        ],
                      ),
                    );
                  },
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    if (Provider.of<UserProvider>(context, listen: false)
                        .user
                        .isVerified) {
                      context.go("/account");
                    } else {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return const LoginModalBottomSheet();
                        },
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.account_circle_outlined,
                    color: Colors.white,
                    size: 54,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
