import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:openzo_frontend/models/product.dart';

class ServiceCard extends StatefulWidget {
  final Product product;

  const ServiceCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: const BoxConstraints(
      //   minHeight: 200,

      // ),
      // height: MediaQuery.of(context).size.width * 0.6 + 150,

      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 0.5,
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey,
        //     blurRadius: 5.0,
        //     spreadRadius: 0.0,
        //     offset: Offset(0.0, 0.0),
        //   )
        // ],
      ),
      child: Column(
        children: [
          _buildProductImageForService(),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey.shade900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '₹ ${widget.product.mrp}',
                            style: TextStyle(
                              fontSize: 18,
                              // color: Colors.black87,
                              color: Colors.blueGrey.shade800,

                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'per ${widget.product.quantityUnit}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      Text(
                        widget.product.description,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (widget.product.storeName != null)
            Text(
              widget.product.storeName!,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductImageForService() {
    if (widget.product.images.isEmpty) return const SizedBox();

    return Container(
      // height: MediaQuery.of(context).size.width * 0.6,
      width: double.infinity,
      // margin: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image(image: NetworkImage(widget.product.images[0].image)),
    );
  }
}
