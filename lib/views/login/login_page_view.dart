import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/services/location_service.dart';
import 'package:openzo_frontend/services/user_service.dart';
import 'package:openzo_frontend/viewmodels/phone_auth_view_model.dart';
import 'package:openzo_frontend/views/login/loading_screen.dart';
import 'package:provider/provider.dart';

import 'package:openzo_frontend/repositories/user_repository.dart';
import 'package:openzo_frontend/viewmodels/user_provider.dart';
import 'package:openzo_frontend/viewmodels/sales_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PhoneAuthPage extends StatelessWidget {
  const PhoneAuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PhoneAuthViewModel>(
      create: (_) => PhoneAuthViewModel(
        userService: Provider.of<UserService>(context, listen: false),
      ),
      child: Consumer<PhoneAuthViewModel>(
        builder: (context, viewModel, child) {
          return viewModel.isLoading
              ? const LoadingScreen()
              : Scaffold(
                  backgroundColor: Colors.white,
                  body: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/Splash Screen.png'),
                        fit: BoxFit.fill,
                        scale: 1.2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: const EdgeInsets.only(top: 75),
                            child: Column(
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/icons/Openzo User App final.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Openzo - Super App for your locality (beta)",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      viewModel.error.isEmpty
                                          ? const SizedBox()
                                          : Text(
                                              viewModel.error,
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                              ),
                                            ),
                                      const SizedBox(height: 12),
                                      if (viewModel.verificationId == null) ...[
                                        TextField(
                                          controller: viewModel.phoneController,
                                          keyboardType: TextInputType.phone,
                                          decoration: const InputDecoration(
                                            prefix: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              child: Text('+91'),
                                            ),
                                            labelText: 'Phone Number',
                                            hintText: 'Enter your number',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ] else
                                        Text(
                                          "Enter OTP sent to +91 ${viewModel.phoneController.text}",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      const SizedBox(height: 16),
                                      viewModel.verificationId != null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: OtpTextField(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                numberOfFields: 4,
                                                textStyle: const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Gilroy',
                                                  fontWeight: FontWeight.w800,
                                                  height: 0.75,
                                                ),
                                                focusedBorderColor:
                                                    GlobalStyle.primaryColor,
                                                showFieldAsBox: true,
                                                onCodeChanged: (String code) {},
                                                onSubmit: (String otp) {
                                                  viewModel.verifyOTP(
                                                      context, otp);
                                                },
                                              ),
                                            )
                                          : const SizedBox(),
                                      viewModel.verificationId == null
                                          ? ElevatedButton(
                                              onPressed: () {
                                                if (viewModel.phoneController
                                                    .text.isEmpty) {
                                                  viewModel.error =
                                                      'Please enter your phone number';
                                                  viewModel.notifyListeners();
                                                  return;
                                                }
                                                viewModel.sendOTP(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16.0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('LOGIN'),
                                            )
                                          : ElevatedButton(
                                              onPressed: () {
                                                // This button is optional since OTP submission is handled in the OtpTextField
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16.0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Verify OTP'),
                                            ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                  const Text(
                                    '© 2024 Openzo. All Rights Reserved.',
                                    style: TextStyle(color: Colors.black54),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
