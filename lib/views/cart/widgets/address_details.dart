import 'package:flutter/material.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/views/cart/widgets/cart_details.dart';
import 'package:openzo_frontend/viewmodels/cart_page_view_model.dart';
import 'package:openzo_frontend/views/cart/styles.dart';
import 'package:openzo_frontend/views/cart/widgets/k_separator.dart';

class AddressDetails extends StatefulWidget {
  final CartPageViewModel viewModel;

  const AddressDetails({
    super.key,
    required this.viewModel,
  });

  @override
  _AddressDetailsState createState() => _AddressDetailsState();
}

class _AddressDetailsState extends State<AddressDetails> {
  bool _isExpanded = false; // Track the expansion state

  @override
  Widget build(BuildContext context) {
    if (widget.viewModel.cart == null) {
      return const SizedBox();
    }

    Sale cart = widget.viewModel.cart!;
    Store? store = widget.viewModel.store;
    String address = widget.viewModel.address;
    String phone = widget.viewModel.phone;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          decoration: kBoxDecoration,
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address Section
              _buildAddressSection(address, context),
              const kSeparator(),
              // Phone Section
              _buildPhoneSection(phone, context),
              // Total Bill Section as an ExpansionTile

            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          decoration: kBoxDecoration,
          clipBehavior: Clip.antiAlias,
          child: _buildTotalBillSection(cart, store),
        )
      ],
    );
  }

  Widget _buildAddressSection(String address, BuildContext context) {
    return Row(
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
              widget.viewModel.editAddress(context); // Trigger address editing
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
    );
  }

  Widget _buildPhoneSection(String phone, BuildContext context) {
    return Row(
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
    );
  }

  Widget _buildTotalBillSection(Sale cart, Store? store) {
    final totalAmount = cart.totalAmount + (store?.deliveryCharge ?? 0);

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded; // Toggle expansion state
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Row(
          //       children: [
          //         ImageIcon(
          //           const AssetImage('assets/icons/bill.png'),
          //           color: Colors.grey.shade700,
          //           size: 18,
          //         ),
          //         const SizedBox(width: 8),
          //         const Text(
          //           "Total Bill",
          //           style: TextStyle(fontWeight: FontWeight.bold),
          //         ),
          //         const SizedBox(width: 150),
          //         Text(
          //           "₹$totalAmount", // Show total amount here
          //           style: const TextStyle(fontWeight: FontWeight.bold),
          //         ),
          //       ],
          //     ),
          //     Icon(
          //       _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          //       color: Colors.grey,
          //     ),
          //   ],
          // ),
          if (_isExpanded) // Show details if expanded
            CartDetails(
              cart: cart,
              deliveryCharge: store?.deliveryCharge ?? 0,
              packingCharge: store?.packingCharge ?? 0,
            ),
          const SizedBox(height: 10), // Add some spacing after the section
        ],
      ),
    );
  }
}
