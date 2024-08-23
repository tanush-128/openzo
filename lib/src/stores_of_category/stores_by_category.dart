import 'package:flutter/material.dart';
import 'package:openzo_frontend/components/globalSearchBar.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/src/home_page/widgets/store_card.dart';
import 'package:openzo_frontend/src/home_page/widgets/store_card_skeleton.dart';

class StoresByCategory extends StatefulWidget {
  Category category;
  SubCategory? subCategory;
  bool showSubCategories = true;
  bool deliveryOnly = false;
  bool delivery = false;
  bool campusOnly = false;
  StoresByCategory({
    super.key,
    required this.category,
    this.subCategory,
    this.showSubCategories = true,
    this.deliveryOnly = false,
    this.delivery = false,
    this.campusOnly = false,
  });

  @override
  State<StoresByCategory> createState() => _StoresByCategoryState();
}

class _StoresByCategoryState extends State<StoresByCategory> {
  SubCategory? subCategory;
  late final subCategories = widget.category.subCategories;

  setSubCategory(SubCategory subCategory) {
    setState(() {
      this.subCategory = subCategory;
    });
  }

  @override
  void initState() {
    if (widget.subCategory != null) {
      subCategory = widget.subCategory;
      subCategories.remove(subCategory);
      subCategories.insert(0, subCategory!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const GlobalSearchBar(),
              leadingWidth: 20,
              pinned: !widget.showSubCategories,
            ),
            widget.showSubCategories
                ? SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 8),
                        height: 120,
                        decoration: BoxDecoration(
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
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: subCategories
                              .map((e) => SubcategoryListTile(
                                  e: e,
                                  category: widget.category,
                                  active: e == subCategory,
                                  setSelectedCategory: setSubCategory))
                              .toList(),
                        ),
                      ),
                    ),
                  )
                : SliverToBoxAdapter(
                    child: Container(
                      height: 0,
                    ),
                  ),
            SliverToBoxAdapter(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder<List<Store>>(
                    future: subCategory != null
                        ? Store.getStoreByPincodeAndSubCategory(
                            '576104', subCategory!.name)
                        : Store.getStoreByPincodeAndCategory(
                            '576104', widget.category.name),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 5, // Number of skeleton cards
                          itemBuilder: (context, index) =>
                              const StoreCardSkeleton(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString(),
                              style: const TextStyle(color: Colors.red)),
                        );
                      }
                      if (snapshot.data == null || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No stores found'),
                        );
                      }

                      List<Store> stores = snapshot.data!;

                      if (widget.deliveryOnly) {
                        stores = stores
                            .where((element) => element.selfDeliveryService)
                            .toList();
                      }
                      if (widget.campusOnly) {
                        stores = stores
                            .where((element) => element.campusDeliveryService)
                            .toList();
                      } else {
                        stores = stores
                            .where((element) =>
                                element.campusDeliveryService == false)
                            .toList();
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: stores.length,
                        itemBuilder: (context, index) {
                          return StoreCard(store: stores[index]);
                        },
                      );
                    },
                  )
                  //  StoresList(
                  //   future: subCategory != null
                  //       ? Store.getStoreByPincodeAndSubCategory(
                  //           '576104', subCategory!.name)
                  //       : Store.getStoreByPincodeAndCategory(
                  //           '576104', widget.category.name),
                  // ),
                  ),
            )
          ],
        ),
      ),
    );
  }
}

class SubcategoryListTile extends StatelessWidget {
  SubcategoryListTile({
    super.key,
    required this.e,
    required this.category,
    this.active = false,
    this.setSelectedCategory,
  });
  bool active = false;
  SubCategory e;
  Category category = GlobalConsts.categories[0];
  Function(SubCategory)? setSelectedCategory;
  // final StoresByCategory widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setSelectedCategory!(e);
      },
      child: Container(
        constraints: const BoxConstraints(minWidth: 80, maxWidth: 100),
        child: Stack(
          children: [
            active
                ? Positioned(
                    bottom: -1,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: 80,
                      height: 5,
                      decoration: BoxDecoration(
                        color: GlobalStyle.primaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ))
                : Container(),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: const Color(0xffe5f3f3)),
                  child: Image.asset(
                    "assets/images/Categories page/${category.name}/${e.name}.png",
                    width: 42,
                    height: 42,
                  ),
                ),
                Center(
                  child: Text(
                    e.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  _SliverAppBarDelegate({
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
