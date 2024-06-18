import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/models/user_data.dart';
import 'package:openzo_frontend/models/user.dart' as backend_user;
import 'package:openzo_frontend/providers/sales_provider.dart';
import 'package:openzo_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

getLocation() async {
  LocationPermission permission = await _requestLocationPermission();
  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
    // Permission granted, proceed with getting location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    log('Location: $position');

    return position;
  } else {
    // Handle permission denied case (e.g., display a message)
    print('Location permission denied');
  }
}

Future<LocationPermission> _requestLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  return permission;
}

Future<void> handleUserData(String mobileNo, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String fcmToken = prefs.getString('fcmToken')!;

  String? userDataId = prefs.getString('user_data_id');
  backend_user.User user = await handleUserLogin(mobileNo, context);
  print(userDataId);

  if (userDataId == null) {
    Position position = await getLocation();
    UserData userData = UserData(
      latitude: position.latitude.toString(),
      longitude: position.longitude.toString(),
      notificationToken: fcmToken,
      userId: user.id,
    );
    await UserData.createUserData(userData);
  } else {
    UserData userData = await UserData.getUserData(userDataId);
    // print(userData.notificationToken);
    log('User data: $userData');
    if (userData.notificationToken != fcmToken || userData.userId != user.id) {
      userData.notificationToken = fcmToken;
      userData.userId = user.id;
      UserData.updateUserData(userData);
    }

    log('User data already exists');
  }
}

Future<backend_user.User> handleUserLogin(
    String mobileNo, BuildContext context) async {
  try {
    bool isSignedIn = await backend_user.User.signIn(mobileNo);
    if (isSignedIn) {
      backend_user.User user = await backend_user.User.getUserWithJWT();
      Provider.of<UserProvider>(context, listen: false).setUser(user);

      return user;
    }
    throw Exception('Failed to sign in');
  } catch (e) {
    print(e.toString());
    throw Exception(e.toString());
  }
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  String? _verificationId;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91${_phoneController.text}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('The provided phone number is not valid.')),
          );
        }
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
  }

  Future<void> _signInWithPhoneNumber() async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _codeController.text,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully signed in!')),
      );
      // handleUserData();
      // context.go('/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in: ${e.toString()}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        handleUserData(user.phoneNumber!, context).then((value) {
          Provider.of<SalesProvider>(context, listen: false).getOrders();
          context.go('/');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                // border: Border.all(),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,

                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
                // boxShadow: const BoxShadow(
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixText: '+91',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: _verifyPhoneNumber,
              child: const Text('Verify Phone Number'),
            ),
            if (_verificationId != null) ...[
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(
                    labelText: 'Verification Code', prefixText: 'OTP: '),
              ),
              ElevatedButton(
                onPressed: _signInWithPhoneNumber,
                child: const Text('Sign In'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
