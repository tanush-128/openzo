import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:openzo_frontend/src/registration/set_password.dart';


class OTPScreen extends StatefulWidget {
  String mobile;
  String email;
  String name;
  static const String routeName = '/otp';
  OTPScreen(
      {super.key,
      required this.mobile,
      required this.email,
      required this.name});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('OTP Verification'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Enter the OTP sent to your mobile number',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
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
                  focusedBorderColor: const Color.fromARGB(255, 38, 120, 179),
                  borderColor: const Color.fromARGB(255, 38, 120, 179),

                  showFieldAsBox: true,

                  onCodeChanged: (String code) {},

                  onSubmit: (String verificationCode) {
                    // if (verificationCode == otp) {
                    //   setState(() {
                    //     message = "OTP is correct";
                    //     messagecolor = Colors.green;
                    //   });
                    //   Navigator.pushNamedAndRemoveUntil(
                    //     context,
                    //     InterestPage.routeName,
                    //     (route) => false,
                    //   );
                    // } else {
                    //   setState(() {
                    //     message = "Incorrect OTP";
                    //     messagecolor = Colors.red;
                    //   });
                    // }
                  }, // end onSubmit
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SetPasswordScreen(
                                  mobile: widget.mobile,
                                  email: widget.email,
                                  name: widget.name)));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Verify'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
