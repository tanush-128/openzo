import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/store.dart';

class StoreCard extends StatefulWidget {
  Store store;
  StoreCard({super.key, required this.store});

  @override
  State<StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  bool isFavourite = false;
  StoreType storeType = StoreType.store;
  @override
  void initState() {
    super.initState();
    if (GlobalConsts.categories
        .any((element) => element.name == widget.store.category)) {
      storeType = GlobalConsts.categories
          .firstWhere((element) => element.name == widget.store.category)
          .type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go('/store/${widget.store.id}');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
// boxShadow: [
// BoxShadow(
// color: Colors.grey.withOpacity(0.2),
// spreadRadius: 0.1,
// blurRadius: 2,
// offset: const Offset(0, 1),
// ),
// BoxShadow(
// color: Colors.grey.withOpacity(0.2),
// spreadRadius: 0.1,
// blurRadius: 2,
// offset: const Offset(-2, -1),
// ),
// ],
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1.5,
          ),
        ),
// clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                image: DecorationImage(
                  image: NetworkImage(widget.store.image),
                  fit: BoxFit.cover,
                ),
                color: Colors.grey.shade300,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.s
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(widget.store.subCategory,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ))),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isFavourite = !isFavourite;
                      });
                    },
                    child: isFavourite
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 30,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 30,
                          ),
                  ),
                  const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 30,
                  )
                ],
              ),
            ),
// const SizedBox(height: 10),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            widget.store.name,
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                overflow: TextOverflow.visible,
                              ),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Rating(rating: widget.store.rating),
                            const SizedBox(width: 5),
                            storeType == StoreType.food
                                ? widget.store.pureVeg!
                                    ? const ImageIcon(
                                        AssetImage('assets/icons/veg.png'),
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
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    storeType == StoreType.store
                        ? Row(
                            children: [
                              Text(
// 'Store Description',
                                widget.store.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    storeType == StoreType.food
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
// 'Store Description',
                                "\u2022 ${widget.store.primaryCuisine} \u2022${widget.store.secondaryCuisine} ",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "₹${widget.store.avgPricePerPerson} for one",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    const SizedBox(height: 5),
                    const Row(
                      children: [],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Rating extends StatelessWidget {
  Rating({super.key, required this.rating});

// final StoreCard widget;
  double rating;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(children: [
        const Icon(Icons.star, color: Colors.amber, size: 16),
        const SizedBox(width: 5),
        Text(
// '4.5',
          rating.toStringAsFixed(1),
          style: const TextStyle(
// overflow: TextOverflow.fade,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ]),
    );
  }
}
