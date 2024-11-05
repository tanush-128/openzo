import 'package:flutter/material.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/viewmodels/sales_provider.dart';
import 'package:openzo_frontend/views/product/widgets/add_button.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  final Product product;
  final Sale? cart;
  final bool addable;
  final bool addableToCart;

  const CartItem({
    super.key,
    required this.product,
    this.cart,
    this.addable = true,
    this.addableToCart = true,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  SizeVariant? selectedSize;
  ColorVariant? selectedColor;

  @override
  Widget build(BuildContext context) {
    int quantity = Provider.of<SalesProvider>(context)
            .onlineOrders
            .where((element) => element.id == widget.cart?.id)
            .first
            .orderItems
            .where((element) => element.productId == widget.product.id)
            .firstOrNull
            ?.quantity ??
        0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {},
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
                              AddButton(
                                product: widget.product,
                              ),
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
                      AddButton(
                        product: widget.product,
                        cart: widget.cart,
                        // addableToCart: widget.addable,
                      ),
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
