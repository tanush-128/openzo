import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openzo_frontend/components/skeleton.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/src/store_page/Reviews.dart';
import 'package:openzo_frontend/src/store_page/custom_search_delegate.dart';
import 'package:openzo_frontend/src/product/product_card.dart';
import 'package:openzo_frontend/src/product/verticalProductCard.dart';
import 'package:openzo_frontend/src/store_page/storeDetails.dart';
import 'package:url_launcher/url_launcher.dart';

class StorePage extends StatefulWidget {
  //
  final String storeId;
  const StorePage({super.key, required this.storeId});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage>
    with SingleTickerProviderStateMixin {
  List<Product> products = [];
  Map<String, List<Product>> categories = {};
  final ScrollController _scrollController = ScrollController();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchProducts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchProducts() async {
    try {
      final List<Product> fetchedProducts =
          await Product.fetchMany(widget.storeId);
      setState(() {
        products = fetchedProducts;
        categories = categorizeProducts(products);
      });
    } catch (e) {
      // Handle error
      print('Error fetching products: $e');
    }
  }

  Map<String, List<Product>> categorizeProducts(List<Product> products) {
    Map<String, List<Product>> categories = {};
    for (var product in products) {
      if (categories.containsKey(product.category)) {
        categories[product.category]!.add(product);
      } else {
        categories[product.category] = [product];
      }
    }
    return categories;
  }

  int pageIndex = 0;
  late final productData = Future.value(Product.fetchMany(widget.storeId));
  late final storeData = Future.value(Store.fetchStore(widget.storeId));

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                // shadowColor: Colors.grey.shade100,
                surfaceTintColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.black),
                expandedHeight: MediaQuery.of(context).size.width +
                    140.0, // Adjust according to your UI design
                floating: false,
                pinned: true,
                shadowColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  // title: Text(
                  //     widget.storeName),
                  // Adjust according to your UI design
                  background: StoreDetails(
                      storeData: storeData, widget: widget, products: products),
                  // according to your UI design
                ),
                // flexibleSpace: StoreDetails(widget: widget, products: products),
                actions: [
                  IconButton(
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(products),
                      );
                    },
                    icon: const Icon(Icons.search),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      launchUrl(
                        Uri.parse("https://maps.app.goo.gl/Wa1EP6fwMdep2vYn7"),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    icon: const Icon(Icons.location_on_sharp),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),

              // StoreDetails(widget: widget, products: products),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    onTap: (index) {
                      print(index);
                      setState(() {
                        pageIndex = index;
                      });
                    },
                    tabs: const [
                      Tab(
                        text: 'Products',
                      ),
                      Tab(
                        text: 'Reviews',
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<List<Product>>(
                  // future: Product.fetchMany(widget.storeId),
                  future: productData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Container(
                          decoration:
                              BoxDecoration(color: Colors.blueGrey.shade50),
                          child: Accordion(
                            disableScrolling: true,
                            openAndCloseAnimation: false,
                            contentBorderColor: Colors.transparent,
                            headerBorderRadius: 0,
                            headerBackgroundColor: Colors.white,
                            paddingListHorizontal: 0,
                            headerPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            contentVerticalPadding: 0,
                            rightIcon: const Icon(
                              Icons.arrow_drop_down,
                              size: 32,
                            ),
                            maxOpenSections: 10,
                            children: [1, 2, 3, 4, 5]
                                .map(
                                  (e) => AccordionSection(
                                    isOpen: true,
                                    header: Skeleton(
                                      width: 100,
                                      height: 20,
                                    ),
                                    // content:  ListView(
                                    //   shrinkWrap: true,
                                    //   children: [
                                    //     ...products
                                    //         .map((e) => ProductCard(product: e))
                                    //   ],
                                    // ),
                                    content: GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.5,
                                      ),
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: 2,
                                      itemBuilder: (context, index) {
                                        // return VerticalProductCard(
                                        //   product: categories[e]![index],
                                        //   cart: cart!,
                                        // );
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start, // mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Skeleton(
                                                  height: 200,
                                                  width: (MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.5)
                                                      .toInt()),
                                              const SizedBox(height: 5),
                                              Skeleton(
                                                width: 100,
                                                height: 20,
                                              ),
                                              const SizedBox(height: 5),
                                              Skeleton(
                                                width: 100,
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      products = snapshot.data!;
                      final List<Product> fetchedProducts = snapshot.data!;
                      categories = categorizeProducts(fetchedProducts);
                      final Map<String, List<Product>> categorizedProducts =
                          categorizeProducts(fetchedProducts);
                      if (pageIndex == 0) {
                        return FutureBuilder(
                          future: storeData,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ProductsList(
                                categories: categorizedProducts,
                                storeType: GlobalConsts.categories
                                    .firstWhere((element) =>
                                        element.name == snapshot.data!.category)
                                    .type,
                                cart: null,
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                      } else {
                        return Container(
                          child: const Column(
                            children: [
                              Review(),
                              Text('Reviews'),
                            ],
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

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

class ProductsList extends StatelessWidget {
  const ProductsList({
    super.key,
    required this.categories,
    required this.cart,
    this.storeType,
  });

  final Map<String, List<Product>> categories;
  final Sale? cart;
  final StoreType? storeType;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.blueGrey.shade50),
        child: Accordion(
            disableScrolling: true,
            openAndCloseAnimation: false,
            contentBorderColor: Colors.transparent,
            headerBorderRadius: 0,
            headerBackgroundColor: Colors.white,
            paddingListHorizontal: 0,
            headerPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            contentVerticalPadding: 0,
            rightIcon: const Icon(
              Icons.arrow_drop_down,
              size: 32,
            ),
            maxOpenSections: 10,
            children: categories.keys
                .map(
                  (e) => AccordionSection(
                    isOpen: true,
                    header: Text(
                      e,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    content: Container(
                      color: Colors.grey.shade50,
                      // color: Colors.red,
                      padding: EdgeInsets.zero,
                      // color: Colors.black,
                      child: storeType != StoreType.store
                          ? ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                ...categories[e]!.map((e) => Padding(
                                      padding: const EdgeInsets.all(1.5),
                                      child: ProductCard(product: e),
                                    ))
                              ],
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.all(0.0),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.56,
                              ),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: categories[e]!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(1.5),
                                  child: VerticalProductCard(
                                    product: categories[e]![index],
                                    // cart: cart!,
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                )
                .toList()));
  }
}
