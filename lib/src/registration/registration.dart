import 'package:flutter/material.dart';
import 'package:openzo_frontend/src/registration/otp_screen.dart';


class ResgistrationPage extends StatefulWidget {
  const ResgistrationPage({super.key});
  static const String routeName = '/registration';
  @override
  State<ResgistrationPage> createState() => _ResgistrationPageState();
}

class _ResgistrationPageState extends State<ResgistrationPage> {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();

  var error = "";

  onContinue() {
    if (nameController.value.text.isEmpty) {
      setState(() {
        error = "Name cannot be empty";
      });
      return;
    } else if (mobileController.value.text.isEmpty) {
      setState(() {
        error = "Mobile cannot be empty";
      });
      return;
    } else if (emailController.value.text.isEmpty) {
      setState(() {
        error = "Email cannot be empty";
      });
      return;
    } else {
      setState(() {
        error = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    error != ""
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              error,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 16),
                            ),
                          )
                        : const SizedBox(
                            height: 0,
                          ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              border: UnderlineInputBorder(),
                              // labelText: 'Mobile Number',
                              hintText: 'Full Name',
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextField(
                            controller: mobileController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.phone_android),
                              border: UnderlineInputBorder(),
                              // labelText: 'Mobile Number',
                              hintText: 'Mobile Number',
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              border: UnderlineInputBorder(),
                              // labelText: 'Mobile Number',
                              hintText: 'Email Address',
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: const ButtonStyle(

                            // backgroundColor: MaterialStateProperty.all(Colors.blue),
                            ),
                        onPressed: () {
                          onContinue();
                          error == ""
                              ? Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                  return OTPScreen(
                                    mobile: mobileController.value.text,
                                    email: emailController.value.text,
                                    name: nameController.value.text,
                                  );
                                }))
                              : null;
                        },
                        child: const Text('Continue'),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text('OR'),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                          elevation: MaterialStateProperty.all(0),
                          side: MaterialStateProperty.all(BorderSide(
                              color: Colors.grey.shade300, width: 1.5)),
                          textStyle: MaterialStateProperty.all(const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                        ),
                        onPressed: () {},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('assets/images/google.png'),
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(
                                width: 12,
                                height: 24,
                                child: VerticalDivider()),
                            Text('Continue with Google'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                          elevation: MaterialStateProperty.all(0),
                          side: MaterialStateProperty.all(BorderSide(
                              color: Colors.grey.shade300, width: 1.5)),
                          textStyle: MaterialStateProperty.all(const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                        ),
                        onPressed: () {},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('assets/images/email.png'),
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(
                                width: 12,
                                height: 24,
                                child: VerticalDivider()),
                            Text('Continue with email'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    //alreafy have an account
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(0)),
                        ),
                        child: const Text('Login'),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
