import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/views/product/widgets/add_button.dart';

class ServiceCard extends StatefulWidget {
  final Product product;
  final bool addableToCart;

  const ServiceCard({
    super.key,
    required this.product,
    this.addableToCart = true,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  int quantity = 0;
  SizeVariant? selectedSize;
  ColorVariant? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (widget.product.type == "product") {
                // Navigator.of(context).pushNamed('/product', arguments: widget.product);
                GoRouter.of(context).go(
                    '/store/${widget.product.storeID}/product/${widget.product.id}');
              } else {}
            },
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.product.type == "food")
                          ImageIcon(
                            const AssetImage("assets/icons/veg.png"),
                            color: widget.product.vegType == "Veg"
                                ? Colors.green
                                : Colors.red,
                            size: 20,
                          ),
                        Text(
                          widget.product.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildProductPrice(),
                        Text(
                          widget.product.description,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // _buildAddButton(),
                        AddButton(
                          product: widget.product,
                          addableToCart: widget.addableToCart,
                        ),
                      ],
                    ),
                  ),
                ),
                _buildProductImage(),
              ],
            ),
          ),
          if (widget.product.storeName != null)
            InkWell(
              onTap: () {
                GoRouter.of(context).go('/store/${widget.product.storeID}');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product.storeName!,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border:
                          Border.all(color: Colors.grey.shade200, width: 1.5),
                    ),
                    child: const Text("View"),
                  )
                ],
              ),
            ),
          if (quantity > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDropdown<SizeVariant>(
                  label: 'Size',
                  selectedValue: selectedSize,
                  items: widget.product.sizeVariants,
                  onChanged: (SizeVariant? newValue) {
                    setState(() {
                      selectedSize = newValue;
                    });
                  },
                  itemLabel: (SizeVariant value) => value.size,
                ),
                _buildDropdown<ColorVariant>(
                  label: 'Color',
                  selectedValue: selectedColor,
                  items: widget.product.colorVariants,
                  onChanged: (ColorVariant? newValue) {
                    setState(() {
                      selectedColor = newValue;
                    });
                  },
                  itemLabel: (ColorVariant value) => value.color,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    if (widget.product.images.isEmpty) return const SizedBox();

    return Container(
      height: MediaQuery.of(context).size.width * 0.3,
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200, width: 2),
        image: DecorationImage(
          image: NetworkImage(widget.product.images[0].image),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildProductPrice() {
    if (widget.product.mrp == widget.product.discountPrice) {
      return Text(
        '₹ ${widget.product.mrp}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.arrow_downward_rounded,
                color: GlobalStyle.primaryColor, size: 20),
            Text(
              '${((widget.product.mrp - widget.product.discountPrice) / widget.product.mrp * 100).round()}%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: GlobalStyle.primaryColor,
              ),
            ),
          ],
        ),
        Text(
          '₹ ${widget.product.mrp}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        Text(
          '₹ ${widget.product.discountPrice}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? selectedValue,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String Function(T) itemLabel,
  }) {
    if (items.isEmpty) return const SizedBox();

    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade900,
          ),
        ),
        DropdownButton<T>(
          value: selectedValue,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<T>>((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Text(
                itemLabel(value),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension Let<T> on T {
  R? let<R>(R Function(T) op) => op(this);
}

// import 'package:flutter/material.dart';
// import 'package:openzo_frontend/models/product.dart';

// class ServiceCard extends StatefulWidget {
//   final Product product;

//   const ServiceCard({
//     Key? key,
//     required this.product,
//   }) : super(key: key);

//   @override
//   State<ServiceCard> createState() => _ServiceCardState();
// }

// class _ServiceCardState extends State<ServiceCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.all(Radius.circular(12.0)),
//         border: Border.all(
//           color: Colors.grey[200]!,
//           width: 0.5,
//         ),
//       ),
//       child: Column(
//         children: [
//           _buildProductImageForService(),
//           Row(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.product.name,
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.blueGrey.shade900,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Text(
//                             '₹ ${widget.product.mrp}',
//                             style: TextStyle(
//                               fontSize: 18,
//                               // color: Colors.black87,
//                               color: Colors.blueGrey.shade800,

//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             'per ${widget.product.quantityUnit}',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.grey,
//                             ),
//                           )
//                         ],
//                       ),
//                       Text(
//                         widget.product.description,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           if (widget.product.storeName != null)
//             Text(
//               widget.product.storeName!,
//               style: const TextStyle(
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductImageForService() {
//     if (widget.product.images.isEmpty) return const SizedBox();

//     return Container(
//       // height: MediaQuery.of(context).size.width * 0.75,
//       width: double.infinity,
//       constraints: BoxConstraints(
//         maxHeight: MediaQuery.of(context).size.width * 0.75,
//       ),
//       // margin: const EdgeInsets.only(top: 16),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(12.0),
//           topRight: Radius.circular(12.0),
//         ),
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: Image(image: NetworkImage(widget.product.images[0].image)),
//     );
//   }
// }
