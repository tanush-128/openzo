import 'package:flutter/material.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/src/cart/cart_page/components/cart_details.dart';
import 'package:openzo_frontend/src/cart/cart_page/cart_page_view_model.dart.dart';
import 'package:openzo_frontend/src/cart/cart_page/components/kSeparator.dart';
import 'package:openzo_frontend/src/cart/cart_page/styles.dart';

class AddressDetails extends StatelessWidget {
  final CartPageViewModel viewModel;
  AddressDetails({
    super.key,
    required this.viewModel,
  });

  String address = "";
  String phone = "";

  late Sale cart;
  Store? store;
  StoreType? storeType;

  @override
  Widget build(BuildContext context) {
    if (viewModel.cart == null) {
      return const SizedBox();
    }
    cart = viewModel.cart!;
    store = viewModel.store;
    storeType = viewModel.storeType;
    address = viewModel.address;
    phone = viewModel.phone;

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: kBoxDecoration,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (storeType != StoreType.service)
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageIcon(
                      const AssetImage('assets/icons/Home.png'),
                      color: Colors.grey.shade700,
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          viewModel.editAddress(context);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  "Delivery At :",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.grey,
                                  fill: 1,
                                )
                              ],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              address,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const kSeparator(),
              ],
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageIcon(
                const AssetImage('assets/icons/phone.png'),
                color: Colors.grey.shade700,
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () {
                    viewModel.editAddress(context);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "+91 $phone",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Colors.grey,
                            fill: 1,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const kSeparator(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageIcon(
                const AssetImage('assets/icons/bill.png'),
                color: Colors.grey.shade500,
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return CartDetails(
                            cart: cart,
                            deliveryCharge: store?.deliveryCharge ?? 0,
                            packingCharge: store?.packingCharge ?? 0,
                          );
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Text(
                              "Total Bill   ",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "₹${cart.totalAmount + (store?.deliveryCharge ?? 0)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey,
                        fill: 1,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
