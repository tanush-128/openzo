import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/models/user.dart';
import 'package:openzo_frontend/providers/sales_provider.dart';
import 'package:openzo_frontend/utils/user_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({Key? key}) : super(key: key);

  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final _phoneController = TextEditingController();
  String? _verificationId;
  // bool _isLoading = false; // Loading state
  bool _isLoading = true; // Loading state

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleUserAuthentication(String phoneNumber) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      await handleUserData(phoneNumber, context);
      FirebaseAnalytics.instance.setUserId(id: phoneNumber);
      await FirebaseAnalytics.instance
          .logEvent(name: 'login', parameters: {'phone_number': phoneNumber});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Welcome back!')),
      );
      await _fetchOrdersAndNavigate();
    } catch (error) {
      print('Error handling user authentication: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to handle user authentication: $error')),
      );
    } finally {
      setState(() {
        // _isLoading = false; // Hide loading indicator
      });
    }
  }

  Future<void> _fetchOrdersAndNavigate() async {
    try {
      await Provider.of<SalesProvider>(context, listen: false).getOrders();
      context.go('/');
    } catch (error) {
      print('Error fetching orders: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch orders: $error')),
      );
    }
  }

  Future<void> _sendOTP() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    // Implement your custom OTP sending logic here.
    // For example, send a request to your backend server to send an OTP to the phone number.

    // Simulate OTP sent
    String _verification_id = await User.generateOTP(_phoneController.text);
    setState(() {
      _verificationId = _verification_id;

      _isLoading = false; // Hide loading indicator
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('OTP sent to ${_phoneController.text}')),
    );
  }

  Future<void> _verifyOTP(String otp) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      await User.verifyOTP(_phoneController.text, _verificationId!, otp);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('phone', _phoneController.text);
      await _handleUserAuthentication(_phoneController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully signed in!')),
      );
    } catch (error) {
      print('Error verifying OTP: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$error')),
      );
    }

    setState(() {
      _isLoading = false; // Hide loading indicator
    });
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      String phone = prefs.getString('phone') ?? '';
      if (phone.isNotEmpty) {
        _handleUserAuthentication(phone);
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });

    super.initState();
  }

  String error = '';

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingScreen()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/images/Splash Screen.png'),
                  fit: BoxFit.fill,
                  scale: 1.2,
                )),
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
                                  // color: Colors.white,
                                  borderRadius: BorderRadius.circular(40),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/icons/Openzo User App final.png'),
                                    fit: BoxFit.contain,
                                  )),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                  "Openzo - Super App for your locality",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  error.isEmpty
                                      ? const SizedBox()
                                      : Text(
                                          error,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                          ),
                                        ),
                                  const SizedBox(height: 12),
                                  if (_verificationId == null) ...[
                                    TextField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: const InputDecoration(
                                        labelText: 'Phone Number',
                                        hintText: 'Enter your number',
                                        border: OutlineInputBorder(),
                                      ),
                                    )
                                  ] else
                                    const Text(
                                        "Enter OTP sent to your phone number"),
                                  const SizedBox(height: 16),
                                  _verificationId != null
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: OtpTextField(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            numberOfFields: 6,

                                            textStyle: const TextStyle(
                                              // color: Color(0xFFD9D9D9),
                                              fontSize: 20,
                                              fontFamily: 'Gilroy',
                                              fontWeight: FontWeight.w800,
                                              height: 0.75,
                                            ),
                                            focusedBorderColor:
                                                GlobalStyle.primaryColor,
                                            // borderColor

                                            showFieldAsBox: true,
                                            onCodeChanged: (String code) {},
                                            onSubmit: _verifyOTP,
                                          ),
                                        )
                                      : const SizedBox(),
                                  // const SizedBox(height: 16),
                                  _verificationId == null
                                      ? ElevatedButton(
                                          onPressed: () {
                                            if (_phoneController.text.isEmpty) {
                                              setState(() {
                                                error =
                                                    'Please enter your phone number';
                                              });
                                              return;
                                            }
                                            _sendOTP();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            // primary: Colors.redAccent,
                                            padding: const EdgeInsets.symmetric(
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
                                            if (_phoneController.text.isEmpty) {
                                              setState(() {
                                                error =
                                                    'Please enter your phone number';
                                              });
                                              return;
                                            }
                                            _verifyOTP(_verificationId!);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            // primary: Colors.redAccent,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('Verify OTP'),
                                        ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'OR',
                                    style: TextStyle(color: Colors.black54),
                                    textAlign: TextAlign.center,
                                  ),
                                  // const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('New User?'),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/registration');
                                        },
                                        child: const Text('Register Now'),
                                      ),
                                    ],
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
                )));
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.red,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarDividerColor: Colors.red,
          systemNavigationBarColor: Colors.red,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  image: const DecorationImage(
                    image: AssetImage('assets/icons/Openzo User App final.png'),
                    fit: BoxFit.contain,
                  )),
            ),
            const SizedBox(height: 16),
            const Text(
              "Openzo",
              style: TextStyle(
                color: Colors.white,
                fontSize: 64,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Text(
              "Super App",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 16),
            const Text('Loading...', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
