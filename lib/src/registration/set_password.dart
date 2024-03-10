import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/user.dart';

class SetPasswordScreen extends StatefulWidget {
  String mobile;
  String email;
  String name;

  SetPasswordScreen(
      {super.key,
      required this.mobile,
      required this.email,
      required this.name});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  @override
  void initState() {
    // TODO: implement initState
    print(widget.mobile);
    super.initState();
  }

  String error = "";
  final passwordController1 = TextEditingController();
  final passwordController2 = TextEditingController();
  bool passwordVisible = false;

  onNext() {
    if (passwordController1.value.text.isEmpty) {
      setState(() {
        error = "Password cannot be empty";
      });
      return;
    } else if (passwordController2.value.text.isEmpty) {
      setState(() {
        error = "Confirm Password cannot be empty";
      });
      return;
    } else if (passwordController1.value.text !=
        passwordController2.value.text) {
      setState(() {
        error = "Passwords do not match";
      });
      return;
    }
    User user = User(
      userName: widget.name,
      email: widget.email,
      password: passwordController1.value.text,
      phone: widget.mobile,
      id: 0,
    );
    User.addUser(user);
    Navigator.pushNamed(context, '/addStore');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Set Password',
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    'Set a password for your account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  error.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            error,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
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
                          controller: passwordController1,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            suffix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: passwordVisible
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off)),
                            prefixIcon: const Icon(Icons.lock),
                            border: const UnderlineInputBorder(),
                            hintText: 'Password',
                          ),
                          obscureText: passwordVisible,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextField(
                          controller: passwordController2,
                          obscureText: passwordVisible,
                          obscuringCharacter: '*',
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            border: UnderlineInputBorder(),
                            // labelText: 'Mobile Number',
                            hintText: 'Confirm Password',
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            onNext();
                            // Navigator.pushNamed(context, '/addStore');
                          },
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
