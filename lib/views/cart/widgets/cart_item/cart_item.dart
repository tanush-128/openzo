import 'package:flutter/material.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/views/cart/widgets/cart_item/model_view.dart';
import 'package:openzo_frontend/views/product/widgets/add_button.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final Product product;
  final Sale? cart;
  bool? addable = true;

  CartItem({
    Key? key,
    required this.product,
    this.cart,
    this.addable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartItemViewModel(product: product, cart: cart),
      child: Consumer<CartItemViewModel>(
        builder: (context, viewModel, _) {
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
                        child: _buildProductDetails(viewModel),
                      ),
                      const SizedBox(width: 12),
                      if (product.type != "food")
                        ProductImageWidget(product: product),
                      if (product.type == "food")
                        FoodProductDetails(viewModel: viewModel),
                    ],
                  ),
                ),
                if (viewModel.quantity > 0) _buildVariantsDropdown(viewModel),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductDetails(CartItemViewModel viewModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (viewModel.product.type == "food")
          ImageIcon(
            const AssetImage("assets/icons/veg.png"),
            color:
                viewModel.product.vegType == "Veg" ? Colors.green : Colors.red,
            size: 18,
          ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewModel.product.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey.shade800,
                ),
              ),
              const SizedBox(height: 4),
              _buildProductPrice(viewModel),
              if (viewModel.product.type != "food") ...[
                Text(
                  viewModel.product.description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                AddButton(
                  product: viewModel.product,
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVariantsDropdown(CartItemViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDropdown<SizeVariant>(
          label: 'Size',
          selectedValue: viewModel.selectedSize,
          items: viewModel.product.sizeVariants,
          onChanged: viewModel.updateSize,
          itemLabel: (SizeVariant value) => value.size,
        ),
        _buildDropdown<ColorVariant>(
          label: 'Color',
          selectedValue: viewModel.selectedColor,
          items: viewModel.product.colorVariants,
          onChanged: viewModel.updateColor,
          itemLabel: (ColorVariant value) => value.color,
        ),
      ],
    );
  }

  Widget _buildProductPrice(CartItemViewModel viewModel) {
    if (viewModel.product.mrp == viewModel.product.discountPrice) {
      return Text(
        '₹ ${viewModel.product.mrp}',
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
              '${((viewModel.product.mrp - viewModel.product.discountPrice) / viewModel.product.mrp * 100).round()}%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: GlobalStyle.primaryColor,
              ),
            ),
          ],
        ),
        Text(
          '₹ ${viewModel.product.mrp}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        Text(
          '₹ ${viewModel.product.discountPrice}',
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

class FoodProductDetails extends StatelessWidget {
  final CartItemViewModel viewModel;

  const FoodProductDetails({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AddButton(
          product: viewModel.product,
          cart: viewModel.cart,
        ),
        const SizedBox(height: 8),
        Text(
          '₹ ${viewModel.product.discountPrice * viewModel.quantity}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}

class ProductImageWidget extends StatelessWidget {
  final Product product;

  const ProductImageWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (product.images.isEmpty) return const SizedBox();

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200, width: 2),
        image: DecorationImage(
          image: NetworkImage(product.images[0].image),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
