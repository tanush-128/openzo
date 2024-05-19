import 'package:accordion/accordion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_fade/image_fade.dart';
import 'package:openzo_frontend/components/skeleton.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/cart.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/providers/carts_provider.dart';
import 'package:openzo_frontend/src/store_page/Reviews.dart';
import 'package:openzo_frontend/src/store_page/custom_search_delegate.dart';
import 'package:openzo_frontend/src/store_page/product_card.dart';
import 'package:openzo_frontend/src/store_page/storeSetailsSkeleton.dart';
import 'package:openzo_frontend/src/stores_of_category/vertical_product_card.dart';
import 'package:provider/provider.dart';
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
  Cart? cart;
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
    cart = Provider.of<CartsProvider>(context, listen: false)
        .carts
        .firstWhere((element) => element.storeId == widget.storeId,
            orElse: () => Cart(
                  id: 0,
                  orderItems: [],
                  storeId: widget.storeId,
                  total: 0,
                  userDataId: 0,
                ));
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: StorePageBottomBar(
          categories: categories,
          cart: cart,
        ),
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
                    200.0, // Adjust according to your UI design
                floating: false,
                pinned: true,

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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start, // mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Skeleton(
                                                        height: 200,
                                                        width: (MediaQuery.of(
                                                                        context)
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
                                      .toList())));
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
                        return ProductsList(
                          categories: categorizedProducts,
                          cart: cart,
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
  });

  final Map<String, List<Product>> categories;
  final Cart? cart;

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
                      // color: Colors.black,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(0.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.5,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categories[e]!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: VerticalProductCard(
                              product: categories[e]![index],
                              cart: cart!,
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

class StorePageBottomBar extends StatelessWidget {
  const StorePageBottomBar({
    super.key,
    required this.categories,
    required this.cart,
  });

  final Map<String, List<Product>> categories;
  final Cart? cart;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: categories.keys
                      .map((e) => CatergoryBadge(category: e))
                      .toList(),
                ),
              ),
            ),
            cart!.total > 0
                ? InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/cart', arguments: cart);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          // width: double.infinity,
                          decoration: const BoxDecoration(
                            color: GlobalStyle.primaryColor,
                            // borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'View Cart',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container()
          ],
        ));
  }
}

class StoreDetails extends StatelessWidget {
  const StoreDetails({
    super.key,
    required this.widget,
    required this.products,
    required this.storeData,
  });

  final StorePage widget;
  final Future<Store> storeData;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // future: Store.fetchStore(widget.storeId),
        future: storeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              // child: CircularProgressIndicator(),
              child: StoreDetailsSkeleton(),
            );
          }
          if (snapshot.hasError) {
            return const Text('Error');
          }
          Store store = snapshot.data as Store;
          return SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.width,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),

                    // image: DecorationImage(
                    //   image: NetworkImage(store.image),
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      ImageFade(
                        image: NetworkImage(store.image),
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.width,
                        placeholder: Container(
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            color: const Color(0xFFCFCDCA),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          alignment: Alignment.center,
                          child: Icon(Icons.photo,
                              color: Colors.grey.shade300, size: 32),
                        ),
                      ),
                      Positioned(
                          bottom: 12,
                          right: 12,
                          child: SizedBox(
                            // width: 175,
                            // height: 100,
                            child: Container(
                              decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 0.1,
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 1,
                                            horizontal: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.amber.shade100,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                '4.5',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '(100 Reviews)',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Image.asset(
                                                'lib/icons/schedule.png',
                                                width: 20,
                                                height: 20),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            '${store.openingTime} - ${store.closingTime}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                Text(
                  store.name,
                  textAlign: TextAlign.center,
                  // overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 5),
                Text(
                  store.storeType.name,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          GlobalStyle.secondaryColor.withOpacity(0.5),
                          Colors.white
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(store.description,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}

class CatergoryBadge extends StatelessWidget {
  String category;
  CatergoryBadge({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(category,
            style: const TextStyle(fontSize: 14, color: Colors.black)));
  }
}
