import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_fade/image_fade.dart';
import 'package:openzo_frontend/components/rating.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/src/store_page/widgets/storeSetailsSkeleton.dart';

class StoreDetails extends StatelessWidget {
  const StoreDetails({
    super.key,
    required this.storeData,
  });

  final Future<Store> storeData;

  @override
  Widget build(BuildContext context) {
    StoreType storeType = StoreType.store;
    return FutureBuilder(
        future: storeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: StoreDetailsSkeleton(),
            );
          }
          if (snapshot.hasError) {
            return const Text('Error');
          }
          Store store = snapshot.data as Store;
          storeType = GlobalConsts.categories
              .firstWhere(
                (element) => element.name == store.category,
                orElse: () => GlobalConsts.categories[0],
              )
              .type;
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
                                        Rating(rating: store.rating),
                                        const SizedBox(width: 5),
                                        Text(
                                          '(${store.reviewCount} Reviews)',
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
                                          Image.asset('lib/icons/schedule.png',
                                              width: 20, height: 20),
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
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: storeType == StoreType.food
                        ? Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    child: Text(
                                      store.name,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    store.subCategory,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  storeType == StoreType.food
                                      ? store.pureVeg!
                                          ? const ImageIcon(
                                              AssetImage(
                                                  'assets/icons/veg.png'),
                                              color: Colors.green,
                                            )
                                          : const Row(
                                              children: [
                                                ImageIcon(
                                                  AssetImage(
                                                    'assets/icons/veg.png',
                                                  ),
                                                  color: Colors.green,
                                                ),
                                                ImageIcon(
                                                  AssetImage(
                                                    'assets/icons/veg.png',
                                                  ),
                                                  color: Colors.red,
                                                ),
                                              ],
                                            )
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "\u2022 ${store.primaryCuisine} \u2022${store.secondaryCuisine} ",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "₹${store.avgPricePerPerson} for one",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                child: Text(
                                  store.name,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                store.subCategory,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )),
                const SizedBox(height: 5),
                if (store.description != "")
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 90,
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
                              textAlign: TextAlign.center,
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
