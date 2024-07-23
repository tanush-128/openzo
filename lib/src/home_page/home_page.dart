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
      resizeToAvoidBottomInset: true,
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

  SliverAppBar _builSliverAppBar(BuildContext context) {
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
              image: AssetImage("assets/images/Splash Screen.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      User user = userProvider.user;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: const FittedBox(
                                child: Text(
                                  "Explore your locality",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
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
                ),
                IconButton(
                  onPressed: () {
                    if (Provider.of<UserProvider>(context, listen: false)
                        .user
                        .isVerified) {
                      context.go("/account");
                    } else {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
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
