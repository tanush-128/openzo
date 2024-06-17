import 'package:flutter/material.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/providers/sales_provider.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  Product product;
  Sale? cart;
  bool addable = true;
  ProductCard({
    super.key,
    required this.product,
    this.cart,
    this.addable = true,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 0;
  SizeVariant? selectedSize;
  ColorVariant? selectedColor;
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
                      orderId: "",
                    ))
            .quantity
        : 0;
    if (widget.product.sizeVariants.isNotEmpty) {
      selectedSize = widget.cart != null
          ? widget.product.sizeVariants.firstWhere(
              (element) =>
                  element.id ==
                  widget.cart!.orderItems
                      .firstWhere(
                          (element) => element.productId == widget.product.id,
                          orElse: () => OrderItem(
                                quantity: 0,
                                productId: widget.product.id,
// quantity: 0,
                                id: 0,
                                orderId: "",
                              ))
                      .sizeVariantId,
              orElse: () => widget.product.sizeVariants.first)
          : widget.product.sizeVariants.first;
    }

    if (widget.product.colorVariants.isNotEmpty) {
      selectedColor = widget.cart != null
          ? widget.product.colorVariants.firstWhere(
              (element) =>
                  element.id ==
                  widget.cart!.orderItems
                      .firstWhere(
                          (element) => element.productId == widget.product.id,
                          orElse: () => OrderItem(
                                quantity: 0,
                                productId: widget.product.id,
                                // quantity: 0,
                                id: 0,
                                orderId: "",
                              ))
                      .colorVariantId,
              orElse: () => widget.product.colorVariants.first)
          : widget.product.colorVariants.first;
    }

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget addButton = widget.addable
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: GlobalStyle.primaryColor, width: 0.75),
                  color: GlobalStyle.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: quantity != 0
                    ? Row(children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              quantity--;
                              Provider.of<SalesProvider>(context, listen: false)
                                  .updateSaleOrderItems(widget.product,
                                      selectedSize, selectedColor, quantity);
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
// color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              quantity++;
                              Provider.of<SalesProvider>(context, listen: false)
                                  .updateSaleOrderItems(widget.product,
                                      selectedSize, selectedColor, quantity);
                            });
                          },
                          child: const Icon(
                            Icons.add,
                            color: GlobalStyle.primaryColor,
                          ),
                        ),
                      ])
                    : InkWell(
                        onTap: () {
                          setState(() {
// Provider.of<CartsProvider>(context, listen: false).
                            quantity++;
                            Provider.of<SalesProvider>(context, listen: false)
                                .updateSaleOrderItems(widget.product,
                                    selectedSize, selectedColor, quantity);
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
        : SizedBox(
            child: Text(
              "quantity: $quantity",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
// fontWeight: FontWeight.bold,
              ),
            ),
          );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
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
                    return Container();

//  ProductModalBottomView(
// widget: widget, addButton: addButton);
                  });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              widget.product.type == "food"
                                  ? Container(
                                      child: widget.product.vegType == "Veg"
                                          ? const ImageIcon(
                                              AssetImage(
                                                  "assets/icons/veg.png"),
                                              color: Colors.green,
                                              size: 20,
                                            )
                                          : const ImageIcon(
                                              AssetImage(
                                                  "assets/icons/veg.png"),
                                              color: Colors.red,
                                              size: 20,
                                            ))
                                  : const SizedBox(),

                              Text(
                                widget.product.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueGrey.shade900,
                                ),
                              ),
                              // const SizedBox(height: 4),
                              // const SizedBox(height: 8),
                              widget.product.mrp != widget.product.discountPrice
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.arrow_downward_rounded,
                                              color: GlobalStyle.primaryColor,
                                              size: 20,
                                            ),
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
                                            decoration:
                                                TextDecoration.lineThrough,
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
                                    )
                                  : Text(
                                      '₹ ${widget.product.mrp}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                              // const SizedBox(height: 4),
                              Text(
                                widget.product.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),

                              addButton,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      widget.product.images.isNotEmpty
                          ? SizedBox(
                              // height: MediaQuery.of(context).size.width * 0.25 + 20,
                              child: Stack(
                                children: [
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.width * 0.3,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        // color:
                                        //     GlobalStyle.primaryColor.withOpacity(0.1),
                                        color: Colors.grey.shade200,
                                        width: 2,
                                      ),
                                      image: widget.product.images.isNotEmpty
                                          ? DecorationImage(
                                              // image: AssetImage('assets/images/watch.webp'),
                                              image: NetworkImage(widget
                                                  .product.images[0].image),
                                              fit: BoxFit.contain,
                                            )
                                          : null,
                                    ),
                                  ),
                                  // const SizedBox(height: 10),
                                  // Positioned(right: 0, bottom: 0, left: 0, child: addButton)
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  widget.product.storeName != null
                      ? Text(
                          widget.product.storeName!,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          //dropdown

          quantity > 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.product.sizeVariants.isNotEmpty
                        ? Container(
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                Text(
                                  'Size: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueGrey.shade900,
                                  ),
                                ),
                                DropdownButton<SizeVariant>(
                                  value: selectedSize,
                                  onChanged: (SizeVariant? newValue) {
                                    setState(() {
                                      selectedSize = newValue;
                                    });
                                  },
                                  items: widget.product.sizeVariants
                                      .map<DropdownMenuItem<SizeVariant>>(
                                          (SizeVariant value) {
                                    return DropdownMenuItem<SizeVariant>(
                                      value: value,
                                      child: Text(
                                        value.size,
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
                            ),
                          )
                        : const SizedBox(),
                    widget.product.colorVariants.isNotEmpty
                        ? Container(
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                Text(
                                  'Color: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueGrey.shade900,
                                  ),
                                ),
                                DropdownButton<ColorVariant>(
                                  value: selectedColor,
                                  onChanged: (ColorVariant? newValue) {
                                    setState(() {
                                      selectedColor = newValue;
                                    });
                                  },
                                  items: widget.product.colorVariants
                                      .map<DropdownMenuItem<ColorVariant>>(
                                          (ColorVariant value) {
                                    return DropdownMenuItem<ColorVariant>(
                                      value: value,
                                      child: Text(
                                        value.color,
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
                            ),
                          )
                        : const SizedBox(),
                  ],
                )
              : const SizedBox()

          // const Divider()
        ],
      ),
    );
  }
}
