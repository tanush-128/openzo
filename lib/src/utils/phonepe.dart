import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PhonePePaymentService {
  final String environmentValue = 'SANDBOX'; // Change to PROD for production
  // final String environmentValue = 'PRODUCTION'; // Change to PROD for production`
  final String appId = ""; // Use a valid app ID
  final String packageName =
      "in.openzo.openzo"; // Replace with actual package name
  final String merchantId =
      //  "PGTESTPAYUAT"; // Merchant ID for testing
      "PGTESTPAYUAT86";
  // final String merchantId = "M22EFQG31408Z"; // Merchant ID for production
  final bool enableLog = true;
  final String callbackUrl =
      "https://webhook.site/1d03b5ab-b5fa-42d4-a360-051fc5ec3b99"; // Replace with actual production URL
  Object? result;

  // Initialize the PhonePe SDK
  void phonepeInit() async {
    try {
      result = await PhonePePaymentSdk.init(
          environmentValue, appId, merchantId, enableLog);
      debugPrint('PhonePe SDK Initialized - $result');
    } catch (error) {
      debugPrint('PhonePe Initialization failed: $error');
    }
  }

  // Start the transaction process with dynamic parameters
  Future<void> startTransaction({
    required BuildContext context,
    required String mobileNumber,
    required double amount, // Use double for precise amount handling
  }) async {
    // Make sure the SDK is initialized
    phonepeInit();

    // Securely generate transaction data
    final transactionId = "MT${getRandomNumber()}";
    final userId = "MU${getRandomNumber()}";

    final data = {
      "merchantId": merchantId,
      "merchantTransactionId": "MT7850590068188104",
      "merchantUserId": "MUID123",
      "amount": 10000,
      "callbackUrl": callbackUrl,
      "mobileNumber": "9679689833",
      "paymentInstrument": {"type": "PAY_PAGE"}
    };

    //  {
    //   "merchantId": merchantId,
    //   "merchantTransactionId": transactionId,
    //   "merchantUserId": userId,
    //   "amount": (amount * 100)
    //       .toInt(), // Amount in smallest currency unit (e.g., 100 paisa = 1 INR)
    //   "callbackUrl": callbackUrl,
    //   "mobileNumber": mobileNumber,
    //   "paymentInstrument": {
    //     "type": "PAY_PAGE",
    //   }
    // };

    // Convert data to JSON string
    String jsonString = jsonEncode(data);
    const String saltkey =
        // "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399"; // Move to backend or environment variable
        "96434309-7796-489d-8924-ab5698506076";
    const String apiEndPoint = "/pg/v1/pay";
    const String saltIndex = "1";

    try {
      // Generate base64 and hash
      String base64Data = jsonString.toBase64;
      String dataToHash = base64Data + apiEndPoint + saltkey;
      String sHA256 = generateSha256Hash(dataToHash).toString();

      // Generate the body and checksum
      String body = base64Data;
      String checksum = "$sHA256###$saltIndex";

      // Log debug info (should be removed in production)
      debugPrint("Body: $body");
      debugPrint("Checksum: $checksum");

      // Start the PhonePe transaction
      final response = await PhonePePaymentSdk.startTransaction(
          body, callbackUrl, checksum, packageName);

      // Handle response
      if (response != null) {
        String status = response['status']?.toString() ?? 'UNKNOWN';
        String error = response['error']?.toString() ?? 'No error provided';

        if (status == 'SUCCESS') {
          result = "Payment Successful!";
          // Navigate to success page or handle payment success
          // Navigator.popAndPushNamed(context, Routes.paymentSuccessful);
        } else {
          result = "Payment Failed - Status: $status, Error: $error";
          // Handle payment failure
          // Navigator.popAndPushNamed(context, Routes.paymentFailed);
        }
      } else {
        result = "Transaction Failed - No Response Received";
      }
      print('Transaction Result: $result');
    } catch (error) {
      debugPrint("Transaction Error: $error");
      result = "Transaction Failed - Error: $error";
    }
  }

  // Generates a random 15-digit merchant or user ID
  String getRandomNumber() {
    Random random = Random();
    String randomNumber =
        List.generate(15, (_) => random.nextInt(10).toString()).join();
    debugPrint("Generated Random Number: $randomNumber");
    return randomNumber;
  }
}

// Function to generate SHA-256 hash
String generateSha256Hash(String input) {
  return sha256.convert(utf8.encode(input)).toString();
}

extension EncodingExtensions on String {
  String get toBase64 => base64.encode(utf8.encode(this));
}
