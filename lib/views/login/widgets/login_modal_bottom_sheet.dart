// import 'package:flutter/material.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:go_router/go_router.dart';
// import 'package:openzo_frontend/constants/styles.dart';
// import 'package:openzo_frontend/models/user.dart';
// import 'package:openzo_frontend/repositories/user_repository.dart';
// import 'package:openzo_frontend/viewmodels/sales_provider.dart';
// import 'package:openzo_frontend/viewmodels/user_provider.dart';
// import 'package:openzo_frontend/src/utils/user_util.dart';
// import 'package:provider/provider.dart';

// class LoginModalBottomSheet extends StatefulWidget {
//   const LoginModalBottomSheet({Key? key}) : super(key: key);

//   @override
//   _LoginModalBottomSheetState createState() => _LoginModalBottomSheetState();
// }

// class _LoginModalBottomSheetState extends State<LoginModalBottomSheet> {
//   final _phoneController = TextEditingController();
//   String? _verificationId;
//   // bool _isLoading = false; // Loading state
//   bool _isLoading = true; // Loading state

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleUserAuthentication() async {
//     setState(() {
//       _isLoading = true; // Show loading indicator
//     });

//     try {
//       await handleUserData(context);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Welcome back!')),
//       );

//       await _fetchOrdersAndNavigate();
//     } catch (error) {
//       print('Error handling user authentication: $error');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to handle user authentication: $error')),
//       );
//     } finally {
//       setState(() {
//         // _isLoading = false; // Hide loading indicator
//       });
//     }
//   }

//   Future<void> _fetchOrdersAndNavigate() async {
//     try {
//       await Provider.of<SalesProvider>(context, listen: false).getOrders();
//       Navigator.of(context).pop();
//       context.go('/');
//     } catch (error) {
//       print('Error fetching orders: $error');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to fetch orders: $error')),
//       );
//     }
//   }

//   Future<void> _sendOTP() async {
//     setState(() {
//       _isLoading = true;
//     });

//     String verificationId = await UserRepository.generateOTP(_phoneController.text);
//     setState(() {
//       _verificationId = verificationId;

//       _isLoading = false;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('OTP sent to ${_phoneController.text}')),
//     );
//   }

//   Future<void> _verifyOTP(String otp) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       await UserRepository.verifyOTP(_phoneController.text, _verificationId!, otp,
//           Provider.of<UserProvider>(context, listen: false).user.id);

//       await _handleUserAuthentication();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Successfully signed in!')),
//       );
//     } catch (error) {
//       print('Error verifying OTP: $error');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('$error')),
//       );
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   String error = '';

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // height: MediaQuery.of(context).size.height * 0.5,
//       constraints: BoxConstraints(
//         maxHeight: MediaQuery.of(context).size.height * 0.5,
//         // maxHeight: MediaQuery.of(context).size.height * 0.8,
//       ),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(30),
//           topRight: Radius.circular(30),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Login',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 10),
//                 error.isEmpty
//                     ? const SizedBox()
//                     : Text(
//                         error,
//                         style: const TextStyle(
//                           color: Colors.red,
//                           fontSize: 16,
//                         ),
//                       ),
//                 const SizedBox(height: 12),
//                 if (_verificationId == null) ...[
//                   TextField(
//                     controller: _phoneController,
//                     keyboardType: TextInputType.phone,
//                     decoration: const InputDecoration(
//                       labelText: 'Phone Number',
//                       hintText: 'Enter your number',
//                       border: OutlineInputBorder(),
//                     ),
//                   )
//                 ] else
//                   const Text("Enter OTP sent to your phone number"),
//                 const SizedBox(height: 16),
//                 _verificationId != null
//                     ? Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: OtpTextField(
//                           borderRadius: BorderRadius.circular(10),
//                           numberOfFields: 6,

//                           textStyle: const TextStyle(
//                             // color: Color(0xFFD9D9D9),
//                             fontSize: 20,
//                             fontFamily: 'Gilroy',
//                             fontWeight: FontWeight.w800,
//                             height: 0.75,
//                           ),
//                           focusedBorderColor: GlobalStyle.primaryColor,
//                           // borderColor

//                           showFieldAsBox: true,
//                           onCodeChanged: (String code) {},
//                           onSubmit: _verifyOTP,
//                         ),
//                       )
//                     : const SizedBox(),
//                 // const SizedBox(height: 16),
//                 _verificationId == null
//                     ? ElevatedButton(
//                         onPressed: () {
//                           if (_phoneController.text.isEmpty) {
//                             setState(() {
//                               error = 'Please enter your phone number';
//                             });
//                             return;
//                           }
//                           _sendOTP();
//                         },
//                         style: ElevatedButton.styleFrom(
//                           // primary: Colors.redAccent,
//                           padding: const EdgeInsets.symmetric(vertical: 16.0),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: const Text('LOGIN'),
//                       )
//                     : ElevatedButton(
//                         onPressed: () {
//                           if (_phoneController.text.isEmpty) {
//                             setState(() {
//                               error = 'Please enter your phone number';
//                             });
//                             return;
//                           }
//                           _verifyOTP(_verificationId!);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           // primary: Colors.redAccent,
//                           padding: const EdgeInsets.symmetric(vertical: 16.0),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: const Text('Verify OTP'),
//                       ),
//                 const SizedBox(height: 12),
//                 const Text(
//                   'OR',
//                   style: TextStyle(color: Colors.black54),
//                   textAlign: TextAlign.center,
//                 ),
//                 // const SizedBox(height: 6),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text('Skip for now'),
//                     TextButton(
//                       onPressed: () async {
//                         await _handleUserAuthentication();
//                       },
//                       child: const Text(
//                         'Continue as guest',
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//             const Text(
//               '© 2024 Openzo. All Rights Reserved.',
//               style: TextStyle(color: Colors.black54),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
