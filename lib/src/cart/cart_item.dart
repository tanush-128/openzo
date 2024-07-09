import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/providers/sales_provider.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  final Product product;
  final Sale? cart;
  final bool addable;
  final bool addableToCart;

  const CartItem({
    Key? key,
    required this.product,
    this.cart,
    this.addable = true,
    this.addableToCart = true,
  }) : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int quantity = 0;
  SizeVariant? selectedSize;
  ColorVariant? selectedColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeProductData();
  }

  void _initializeProductData() {
    quantity = widget.cart?.orderItems
            .firstWhereOrNull((item) => item.productId == widget.product.id)
            ?.quantity ??
        0;
    selectedSize = _getInitialSizeVariant();
    selectedColor = _getInitialColorVariant();
  }

  SizeVariant? _getInitialSizeVariant() {
    if (widget.product.sizeVariants.isEmpty) return null;
    // return widget.cart?.orderItems
    //         .firstWhereOrNull((item) => item.productId == widget.product.id)
    //         ?.sizeVariantId.let((id) => widget.product.sizeVariants) ??
    //     widget.product.sizeVariants.first;
  }

  ColorVariant? _getInitialColorVariant() {
    if (widget.product.colorVariants.isEmpty) return null;
    // return widget.cart?.orderItems
    //         .firstWhereOrNull((item) => item.productId == widget.product.id)
    //         ?.colorVariantId
    //         .let((id) => widget.product.colorVariants
    //             .firstWhereOrNull((variant) => variant.id == id)) ??
    //     widget.product.colorVariants.first;
  }

  void _updateQuantity(int newQuantity) {
    setState(() {
      quantity = newQuantity;
      Provider.of<SalesProvider>(context, listen: false).updateSaleOrderItems(
        widget.product,
        selectedSize,
        selectedColor,
        quantity,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        // border: Border(
        //   bottom: BorderSide(color: Colors.grey, width: 0.5),
        // ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              // showModalBottomSheet(
              //   backgroundColor: Colors.white,
              //   shape: const RoundedRectangleBorder(
              //     borderRadius: BorderRadius.only(
              //       topLeft: Radius.circular(20),
              //       topRight: Radius.circular(20),
              //     ),
              //   ),
              //   barrierColor: Colors.grey.withOpacity(0.5),
              //   context: context,
              //   builder: (context) {
                  // return Container(); // TODO: Implement the ProductModalBottomView
              //   },
              // );
            },
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.product.type == "food")
                        ImageIcon(
                          const AssetImage("assets/icons/veg.png"),
                          color: widget.product.vegType == "Veg"
                              ? Colors.green
                              : Colors.red,
                          size: 18,
                        ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey.shade800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            _buildProductPrice(),
                            if (widget.product.type != "food")
                              Text(
                                widget.product.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            if (widget.product.type != "food")
                              const SizedBox(height: 8),
                            if (widget.product.type != "food")
                              _buildAddButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (widget.product.type != "food") _buildProductImage(),
                if (widget.product.type == "food")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildAddButton(),
                      const SizedBox(height: 8),
                      Text(
                        '₹ ${widget.product.discountPrice * quantity}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                // else _buildFoodProductDetails(),
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

  Widget _buildAddButton() {
    if (!widget.addableToCart) return const SizedBox();

    if (widget.addable) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            decoration: BoxDecoration(
              border: Border.all(color: GlobalStyle.primaryColor, width: 0.75),
              color: const Color.fromARGB(167, 245, 152, 172).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.0),
              // boxShadow: [
              //   BoxShadow(
              //     color: GlobalStyle.primaryColor.withOpacity(0.2),
              //     spreadRadius: 1,
              //     blurRadius: 2,
              //     offset: const Offset(0, 1),
              //   ),
              // ],
            ),
            child: quantity != 0
                ? Row(
                    children: [
                      InkWell(
                        onTap: () => _updateQuantity(quantity - 1),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              top: 2, bottom: 2, right: 12, left: 2),
                          child: Icon(
                            Icons.remove,
                            color: GlobalStyle.primaryColor,
                            size: 18,
                          ),
                        ),
                      ),
                      Text('$quantity',
                          style: const TextStyle(
                            // color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )),
                      InkWell(
                        onTap: () => _updateQuantity(quantity + 1),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              top: 2, bottom: 2, right: 2, left: 12),
                          child: Icon(
                            Icons.add,
                            color: GlobalStyle.primaryColor,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  )
                : InkWell(
                    onTap: () => _updateQuantity(quantity + 1),
                    child: const Text(
                      'ADD',
                      style: TextStyle(
                        color: GlobalStyle.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ],
      );
    } else {
      return Text(
        "quantity: $quantity",
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey.shade400,
        ),
      );
    }
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
          fontSize: 14,
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
