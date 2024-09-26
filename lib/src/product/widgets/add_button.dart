import 'package:flutter/material.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/providers/sales_provider.dart';
import 'package:openzo_frontend/providers/user_provider.dart';
import 'package:openzo_frontend/src/cart/cart_item.dart';
import 'package:provider/provider.dart';

class AddButton extends StatefulWidget {
  final Product product;
  final bool addableToCart;
  Sale? cart;
  AddButton({
    super.key,
    required this.product,
    this.addableToCart = true,
    this.cart,
  });

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  int quantity = 0;
  SizeVariant? selectedSize;
  ColorVariant? selectedColor;
  bool addable = false;

  // @override
  // void initState() {
  //   super.initState();
  //   late Sale cart;

  //   cart = Provider.of<SalesProvider>(context, listen: false)
  //       .getSaleByStoreId(widget.product.storeID);

  //   quantity = cart.orderItems
  //           .firstWhereOrNull((item) => item.productId == widget.product.id)
  //           ?.quantity ??
  //       0;
  //   addable = cart.status == "not_placed";123456
  // }

  void _updateQuantity(int newQuantity) {
    setState(() {
      quantity = newQuantity;
      Provider.of<SalesProvider>(context, listen: false).updateSaleOrderItems(
        widget.product,
        selectedSize,
        selectedColor,
        quantity,
        isService: widget.product.type == "service",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String pincode =
        Provider.of<UserProvider>(context, listen: false).user.pincode ??
            '123456';
    // late Sale cart;
    // if (widget.cart != null && widget.cart!.id.isNotEmpty) {
    //   cart = Provider.of<SalesProvider>(context, listen: false)
    //       .onlineOrders
    //       .where((element) => element.id == widget.cart?.id)
    //       .first;
    // } else {
    //   cart = Provider.of<SalesProvider>(context, listen: false)
    //       .getSaleByStoreId(widget.product.storeID);
    // }

    // quantity = cart.orderItems
    //         .firstWhereOrNull((item) => item.productId == widget.product.id)
    //         ?.quantity ??
    //     0;

    if (!widget.addableToCart) return const SizedBox();
    if (widget.product.outOfStock) {
      return Text(
        "Out of stock",
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey.shade400,
        ),
      );
    }
    return Consumer<SalesProvider>(
      builder: (context, value, child) {
        late Sale cart;
        if (widget.cart != null && widget.cart!.id.isNotEmpty) {
          cart = value.onlineOrders
              .where((element) => element.id == widget.cart?.id)
              .first;
        } else {
          cart = value.getSaleByStoreId(widget.product.storeID);
        }
        quantity = cart.orderItems
                .firstWhereOrNull((item) => item.productId == widget.product.id)
                ?.quantity ??
            0;
        addable = cart.status == "not_placed";
        if (addable) {
          return Row(
            children: [
              (quantity != 0 && widget.product.type == "service")
                  ? TextButton(
                      onPressed: () {
                        _updateQuantity(0);
                      },
                      child: const Text(
                        "Selected",
                        style: TextStyle(color: GlobalStyle.primaryColor),
                      ))
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 2),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: GlobalStyle.primaryColor, width: 0.75),
                        color:
                            const Color.fromARGB(255, 255, 133, 160).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 12),
                                child: Text(
                                  widget.product.type != "service"
                                      ? 'ADD'
                                      : "SELECT",
                                  style: const TextStyle(
                                    color: GlobalStyle.primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
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
      },
    );
  }
}
