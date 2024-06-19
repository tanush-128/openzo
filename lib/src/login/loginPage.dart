import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/providers/sales_provider.dart';
import 'package:openzo_frontend/utils/user_util.dart';
import 'package:provider/provider.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart'; // Import package

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({Key? key}) : super(key: key);

  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final _phoneController = TextEditingController();
  String? _verificationId;
  bool _isLoading = false; // Loading state

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleUserAuthentication(User user) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      await handleUserData(user.phoneNumber!, context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Welcome back!')),
      );
      await _fetchOrdersAndNavigate();
    } catch (error) {
      // Handle errors appropriately
      print('Error handling user authentication: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to handle user authentication: $error')),
      );
    } finally {
      // setState(() {
      //   _isLoading = false; // Hide loading indicator
      // });
    }
  }

  Future<void> _fetchOrdersAndNavigate() async {
    try {
      await Provider.of<SalesProvider>(context, listen: false).getOrders();
      context.go('/');
    } catch (error) {
      // Handle errors appropriately
      print('Error fetching orders: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch orders: $error')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // If the user is already authenticated, show a message and navigate
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are already signed in!')),
        );
        _handleUserAuthentication(user);
      } else {
        _isLoading = false; // Hide loading indicator
      }
    });
  }

  Future<void> _verifyPhoneNumber() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91${_phoneController.text}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to verify phone number: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );

    setState(() {
      _isLoading = false; // Hide loading indicator
    });
  }

  Future<void> _signInWithPhoneNumber(String otp) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully signed in!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
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
                          image: AssetImage(
                              'assets/icons/Openzo User App final.png'),
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
                  const Text('Loading...',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Phone Authentication'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixText: '+91',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _verifyPhoneNumber,
                    child: const Text('Verify Phone Number'),
                  ),
                  if (_verificationId != null) ...[
                    const SizedBox(height: 16),
                    const Text('Enter OTP'),
                    const SizedBox(height: 8),
                    OtpTextField(
                      borderRadius: BorderRadius.circular(10),
                      numberOfFields: 6,

                      textStyle: const TextStyle(
                        // color: Color(0xFFD9D9D9),
                        fontSize: 20,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w800,
                        height: 0.75,
                      ),
                      focusedBorderColor: GlobalStyle.primaryColor,
                      borderColor: const Color.fromARGB(255, 38, 120, 179),

                      showFieldAsBox: true,
                      onCodeChanged: (String code) {},
                      onSubmit: _signInWithPhoneNumber, // Handle OTP submission
                    ),
                  ],
                ],
              ),
            ),
          );
  }
}
