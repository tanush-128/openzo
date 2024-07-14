import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/product.dart';

class VerticalProductCard extends StatefulWidget {
  final Product product;

  const VerticalProductCard({
    super.key,
    required this.product,
  });

  @override
  State<VerticalProductCard> createState() => _VerticalProductCardState();
}

class _VerticalProductCardState extends State<VerticalProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              context.go('/');

              Future.delayed(const Duration(milliseconds: 1), () {
                context.go(
                    '/store/${widget.product.storeID}/product/${widget.product.id}');
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.5,
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                      image: widget.product.images.isNotEmpty
                          ? DecorationImage(
                              image:
                                  NetworkImage(widget.product.images[0].image),
                              fit: BoxFit.contain,
                            )
                          : const DecorationImage(
                              image:
                                  AssetImage('assets/images/placeholder.png'),
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade900,
                          ),
                        ),
                        Text(
                          widget.product.description,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                        widget.product.mrp != widget.product.discountPrice
                            ? FittedBox(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.arrow_downward_rounded,
                                            color: GlobalStyle.primaryColor,
                                            size: 16),
                                        Text(
                                          '${((widget.product.mrp - widget.product.discountPrice) / widget.product.mrp * 100).toStringAsFixed(0)}%',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: GlobalStyle.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '₹ ${widget.product.mrp}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '₹${widget.product.discountPrice}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Text(
                                '₹ ${widget.product.mrp}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
