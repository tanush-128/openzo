import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/sale.dart';

class CartDetails extends StatefulWidget {
  final Sale cart;
  final int deliveryCharge;
  final int packingCharge;

  const CartDetails({
    super.key,
    required this.cart,
    required this.deliveryCharge,
    required this.packingCharge,
  });

  @override
  State<CartDetails> createState() => _CartDetailsState();
}

class _CartDetailsState extends State<CartDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long,
                color: Colors.deepOrange,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                "Price Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade300, thickness: 1),
          const SizedBox(height: 12),
          _buildDetailRow("MRP", widget.cart.totalAmount),
          const SizedBox(height: 10),
          _buildDetailRow("Delivery Charge", widget.deliveryCharge ),
          const SizedBox(height: 10),
          _buildDetailRow("Packing Charge", widget.packingCharge),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade300, thickness: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "₹${widget.cart.totalAmount + widget.deliveryCharge + widget.packingCharge}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
        ),
        Text(
          "₹$amount",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
