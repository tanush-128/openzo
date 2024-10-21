import 'package:flutter/material.dart';
import 'package:openzo_frontend/src/utils/phonepe.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PayOnline extends StatefulWidget {
  const PayOnline({super.key});

  @override
  State<PayOnline> createState() => _PayOnlineState();
}

class _PayOnlineState extends State<PayOnline> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        PhonePePaymentService().startTransaction(
            context: context, mobileNumber: "9679689833", amount: 20.0);
      },
      child: const Text("Pay now"),
    );
  }
}
