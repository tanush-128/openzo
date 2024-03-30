import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/cart.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/providers/carts_provider.dart';
import 'package:openzo_frontend/src/store_page/custom_search_delegate.dart';
import 'package:openzo_frontend/src/store_page/product_card.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class StorePage extends StatefulWidget {
  //
  final int storeId;
  const StorePage({super.key, required this.storeId});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  Cart? cart;

  List<Product> products = [];
  Map<String, List<Product>> categories = {};
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

  @override


  @override
  Widget build(BuildContext context) {
    // Store store

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

    return FutureBuilder(
      future: Product.fetchMany(widget.storeId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          products = snapshot.data as List<Product>;
          categories = categorizeProducts(products);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              actions: [
                IconButton(
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(products));
                    },
                    icon: const Icon(Icons.search)),
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
                          Uri.parse(
                              "https://maps.app.goo.gl/Wa1EP6fwMdep2vYn7"),
                          mode: LaunchMode.externalApplication);
                    },
                    icon: const Icon(Icons.location_on_sharp)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
              ],
            ),
            bottomNavigationBar: SizedBox(
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
                              Navigator.pushNamed(context, '/cart',
                                  arguments: cart);
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
                )),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                      future: Store.fetchStore(widget.storeId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 1,
                                      horizontal: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade100,
                                      borderRadius: BorderRadius.circular(5.0),
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
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 12,
                                ),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                        GlobalStyle.secondaryColor
                                            .withOpacity(0.5),
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
                      }),
                  Container(
                      decoration: BoxDecoration(color: Colors.blueGrey.shade50),
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
                                    // padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: categories[e]!.length,
                                      itemBuilder: (context, index) {
                                        return ProductCard(
                                          product: categories[e]![index],
                                          cart: cart!,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              )
                              .toList()))
                ],
              ),
            ),
          );
        }
      },
    );
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
