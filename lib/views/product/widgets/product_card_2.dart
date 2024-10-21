import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/views/product/widgets/add_button.dart';

class ProductCard2 extends StatefulWidget {
  final Product product;

  final bool addableToCart;

  const ProductCard2({
    Key? key,
    required this.product,
    this.addableToCart = true,
  }) : super(key: key);

  @override
  State<ProductCard2> createState() => _ProductCard2State();
}

class _ProductCard2State extends State<ProductCard2> {
  int quantity = 0;
  SizeVariant? selectedSize;
  ColorVariant? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        children: [
          _buildProductImage(),
          if (widget.product.type == "food")
            ImageIcon(
              const AssetImage("assets/icons/veg.png"),
              color:
                  widget.product.vegType == "Veg" ? Colors.green : Colors.red,
              size: 20,
            ),
          const SizedBox(height: 8),
          Text(
            widget.product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey.shade900,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: _buildProductPrice()),
                AddButton(
                  product: widget.product,
                  addableToCart: widget.addableToCart,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: MediaQuery.of(context).size.width * 0.33,
      width: MediaQuery.of(context).size.width * 0.33,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        // image: DecorationImage(
      ),
      child: widget.product.images.isNotEmpty
          ? Image.network(
              widget.product.images[0].image,
              fit: BoxFit.contain,
            )
          : SizedBox(
              child: Icon(Icons.image, size: 50, color: Colors.grey.shade500)),
    );
  }

  Widget _buildProductPrice() {
    if (widget.product.mrp == widget.product.discountPrice) {
      return Text(
        '₹ ${widget.product.mrp}',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '₹ ${widget.product.mrp}',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        Text(
          '₹ ${widget.product.discountPrice}',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
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
