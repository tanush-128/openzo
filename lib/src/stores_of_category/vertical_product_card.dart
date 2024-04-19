import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/cart.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/providers/carts_provider.dart';
import 'package:openzo_frontend/utils/capitalize.dart';
import 'package:provider/provider.dart';

class VerticalProductCard extends StatefulWidget {
  Product product;
  Cart? cart;
  bool addable = true;
  VerticalProductCard({
    super.key,
    required this.product,
    this.cart,
    this.addable = true,
  });

  @override
  State<VerticalProductCard> createState() => _VerticalProductCardState();
}

class _VerticalProductCardState extends State<VerticalProductCard> {
  int quantity = 0;

  @override
  void didChangeDependencies() {
    quantity = widget.cart != null
        ? widget.cart!.orderItems
            .firstWhere((element) => element.productId == widget.product.id,
                orElse: () => OrderItem(
                      quantity: 0,
                      productId: widget.product.id,
                      // quantity: 0,
                      id: 0,
                      orderId: 0,
                    ))
            .quantity
        : 0;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Widget addButton = widget.addable
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: GlobalStyle.secondaryColor),
                  color: GlobalStyle.secondaryColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: quantity != 0
                    ? Row(children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              quantity--;
                              Provider.of<CartsProvider>(context, listen: false)
                                  .updateCartOrderItems(
                                      widget.product, quantity);
                            });
                          },
                          child: const Icon(
                            Icons.remove,
                            color: GlobalStyle.primaryColor,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('$quantity',
                            style: const TextStyle(
                                color: GlobalStyle.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              quantity++;
                              Provider.of<CartsProvider>(context, listen: false)
                                  .updateCartOrderItems(
                                      widget.product, quantity);
                            });
                          },
                          child: const Icon(Icons.add,
                              color: GlobalStyle.primaryColor),
                        ),
                      ])
                    : InkWell(
                        onTap: () {
                          setState(() {
                            // Provider.of<CartsProvider>(context, listen: false).
                            quantity++;
                            Provider.of<CartsProvider>(context, listen: false)
                                .updateCartOrderItems(widget.product, quantity);
                          });
                        },
                        child: const Text(
                          'ADD',
                          style: TextStyle(
                            color: GlobalStyle.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
              ),
            ],
          )
        : const SizedBox();
    return SizedBox(
      // height: 205,
      // width: 320,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  backgroundColor: Colors.white,
                  // showDragHandle: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  barrierColor: Colors.grey.withOpacity(0.5),
                  context: context,
                  builder: (context) {
                    return Container(
                      // height: double.,
                      padding: const EdgeInsets.only(top: 24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              enableInfiniteScroll: false,
                              height: 200.0,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              pauseAutoPlayOnTouch: true,
                              aspectRatio: 2.0,
                              onPageChanged: (index, reason) {
                                // setState(() {
                                //   _current = index;
                                // });
                              },
                            ),
                            items: widget.product.images
                                .map((e) => e.image)
                                .map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 200,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                          image: NetworkImage(i),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      // child: Image.asset(
                                      //   i,
                                      //   fit: BoxFit.cover,
                                      // ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.product.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey.shade900,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '₹ ${widget.product.mrp}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 24),
                              addButton,
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.product.description,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // height: MediaQuery.of(context).size.width * 0.25,
                    // width: MediaQuery.of(context).size.width * 0.25,
                    height: 200,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.circular(10.0),
                        image: widget.product.images.isNotEmpty
                            ? DecorationImage(
                                // image: AssetImage('assets/images/watch.webp'),
                                image: NetworkImage(
                                    widget.product.images[0].image),
                                fit: BoxFit.cover,
                              )
                            : const DecorationImage(
                                image: AssetImage('assets/images/watch.webp'))),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // widget.product.name.length > 20
                          //     ? '${widget.product.name.substring(0, 20)}...'
                          //     : widget.product.name,
                          capitalize(widget.product.name),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey.shade900,
                            fontStyle: GoogleFonts.montserrat().fontStyle,
                          ),
                        ),
                        widget.product.mrp != widget.product.discountPrice
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  widget.product.mrp !=
                                          widget.product.discountPrice
                                      ? Text(
                                          ' ${(((widget.product.mrp - widget.product.discountPrice) / widget.product.mrp) * 100).toInt()}%',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.green,
                                          ))
                                      : const Text(""),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${widget.product.mrp}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '₹${widget.product.discountPrice}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      // color: Colors.,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                '₹ ${widget.product.mrp}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        // Text(
                        //   widget.product.description,
                        //   style: const TextStyle(
                        //     fontSize: 14,
                        //     fontWeight: FontWeight.w400,
                        //     color: Colors.grey,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  addButton,
                ],
              ),
            ),
          ),
          // addButton,
        ],
      ),
    );
  }
}
