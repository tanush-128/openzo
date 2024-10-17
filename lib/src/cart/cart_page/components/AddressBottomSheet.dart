import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openzo_frontend/models/sale.dart';

Future<dynamic> showAddressBottomSheet(
    BuildContext context, String address, String phone, Sale cart) {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  addressController.text = address;
  phoneController.text = phone;

  return showModalBottomSheet<dynamic>(
    context: context,
    isDismissible: false,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (context) {
      return NewWidget(
          addressController: addressController,
          phoneController: phoneController,
          cart: cart);
    },
  );
}

class NewWidget extends StatefulWidget {
  NewWidget({
    super.key,
    required this.addressController,
    required this.phoneController,
    required this.cart,
  });
  Sale cart;
  final TextEditingController addressController;
  final TextEditingController phoneController;

  @override
  State<NewWidget> createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  var inputDecorationTheme = InputDecorationTheme(
    errorStyle: TextStyle(
      color: Colors.red.shade700,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black87, width: 1.75),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.red.shade700, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.red.shade700, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    prefixIconColor: Colors.grey.shade500,
    constraints: const BoxConstraints(maxWidth: 360),
    hintStyle: GoogleFonts.poppins(
      color: Colors.grey.shade300,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    floatingLabelStyle: GoogleFonts.poppins(
      color: Colors.black87,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    labelStyle: GoogleFonts.poppins(
      color: Colors.grey.shade300,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    filled: true,
    fillColor: Colors.white,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    alignLabelWithHint: false,
  );

  @override
  Widget build(BuildContext context) {
    bool editable = widget.cart.status == "not_placed";
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: inputDecorationTheme,
      ),
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Delivery Address',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: widget.phoneController,
                      // enabled: editable,
                      enabled: false,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          labelText: 'Recipient\'s Phone Number *',
                          hintText: 'Recipient\'s Phone Number *'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Save address as *",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: widget.addressController,
                      enabled: editable,
                      decoration: const InputDecoration(
                        labelText: 'Flat / House No / Floor / Building *',
                        hintText: 'Enter your address *',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Nearby Landmark',
                        hintText: 'Enter nearby landmark',
                      ),
                      enabled: editable,
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'address': widget.addressController.text,
                    'phone': widget.phoneController.text,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: !editable
                      ? Colors.grey.shade300
                      : Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Confirm Address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
