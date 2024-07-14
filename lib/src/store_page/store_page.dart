import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/providers/products_provider.dart';
import 'package:openzo_frontend/providers/sales_provider.dart';
import 'package:openzo_frontend/src/store_page/widgets/Reviews.dart';
import 'package:openzo_frontend/src/store_page/widgets/custom_search_delegate.dart';
import 'package:openzo_frontend/src/store_page/widgets/post/post_list.dart';
import 'package:openzo_frontend/src/store_page/widgets/productsList.dart';
import 'package:openzo_frontend/src/store_page/widgets/productsListSkeleton.dart';
import 'package:openzo_frontend/src/store_page/widgets/storeDetails.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class StorePage extends StatefulWidget {
  final String storeId;

  const StorePage({super.key, required this.storeId});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage>
    with SingleTickerProviderStateMixin {
  late Future<List<Product>> productData;
  late Future<Store> storeData;
  late TabController _tabController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    productData = Product.fetchMany(widget.storeId);
    storeData = Store.fetchStore(widget.storeId);
    storeData.then((value) {
      setState(() {
        store = value;
      });
    });
    _tabController.addListener(() {
      setState(() {
        pageIndex = _tabController.index;
      });
    });
  }

  StoreType storeType = StoreType.store;
  Store? store;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: _buildBottomBar(),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              _buildSliverAppBar(),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Products'),
                      Tab(text: 'Reviews'),
                      Tab(text: 'Posts'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Consumer<SalesProvider>(
      builder: (context, salesProvider, child) {
        final Sale cart = salesProvider.getSaleByStoreId(widget.storeId);

        storeType = GlobalConsts.categories
            .firstWhere(
              (element) => element.name == store?.category,
              orElse: () => GlobalConsts.categories[0],
            )
            .type;
        return pageIndex == 0
            ? storeType == StoreType.service
                ? _buildContactBottmBar(store?.phone ?? "")
                : _buildBottomNavigationBar(cart)
            : pageIndex == 1
                ? AddReviewButton(storeId: widget.storeId)
                : const SizedBox(height: 0);
      },
    );
  }

  Widget _buildBottomNavigationBar(Sale cart) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: cart.id.isNotEmpty
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text('Total: ${cart.totalAmount}'),
                Row(
                  children: [
                    ImageIcon(
                      const AssetImage('assets/icons/bill.png'),
                      color: Colors.grey.shade500,
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Total Bill   ",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "₹${cart.totalAmount + 40}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    context.go('/cart/${cart.id}');
                  },
                  child: Row(
                    children: [
                      Text(
                        cart.status == "not_placed"
                            ? 'View Cart'
                            : "View Order",
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.arrow_forward_outlined),
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildContactBottmBar(String mobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              final Uri url = Uri(
                scheme: 'tel',
                path: mobile,
              );
              launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
            },
            child: const Row(
              children: [
                Icon(Icons.call),
                Text(
                  'Contact Now',
                ),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      expandedHeight: MediaQuery.of(context).size.width +
          40 +
          (store?.description.isNotEmpty ?? true ? 100 : 0),
      floating: false,
      pinned: true,
      title: FutureBuilder(
        future: storeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          } else if (snapshot.hasError) {
            return const SizedBox.shrink();
          } else if (snapshot.hasData) {
            // final store = snapshot.data as Store;
            store = snapshot.data as Store;

            return Text(
              store!.name,
              maxLines: 1,
              style: const TextStyle(),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      centerTitle: false,
      leadingWidth: 32,
      shadowColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: StoreDetails(
          storeData: storeData,
        ),
      ),
      actions: [
        FutureBuilder(
            future: productData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              } else if (snapshot.hasError) {
                return const SizedBox.shrink();
              } else if (snapshot.hasData) {
                final products = snapshot.data!;
                return IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(products),
                    );
                  },
                  icon: const Icon(Icons.search),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
        IconButton(
          onPressed: () {
            launchUrl(
              Uri.parse(store?.location ?? ''),
              mode: LaunchMode.externalApplication,
            );
          },
          icon: const Icon(Icons.location_on_sharp),
        ),
        //share
        IconButton(
          onPressed: () {
            Share.shareUri(Uri.parse("https://openzo.in/store/${store!.id}"));
          },
          icon: const Icon(Icons.share),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return FutureBuilder<List<Product>>(
      future: productData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ProductListSkeleton();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final products = snapshot.data!;
          Provider.of<ProductsProvider>(context, listen: false)
              .setProducts(products);

          return TabBarView(
            controller: _tabController,
            children: [
              // _buildProductsList(cart),
              // Consumer<SalesProvider>(
              //   builder: (context, value, child) {
              //     final cart = value.getSaleByStoreId(widget.storeId);
              //   },
              // ),
               _buildProductsList(),
              ReviewsList(
                storeId: widget.storeId,
                storeData: storeData,
              ),
              PostList(),
            ],
          );
        } else {
          return const Center(child: Text('No products available'));
        }
      },
    );
  }

  Widget _buildProductsList() {
    return ProductsList(
      // categories: categories,
      storeType: storeType,
      store: store,
      // cart: cart,
      addableToCart:
          (store?.selfDeliveryService ?? false),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
