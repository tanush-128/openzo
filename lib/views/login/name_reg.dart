import 'package:flutter/material.dart';
import 'package:openzo_frontend/viewmodels/phone_auth_view_model.dart';
import 'package:openzo_frontend/views/login/loading_screen.dart';
import 'package:provider/provider.dart';

class NameReg extends StatelessWidget {
  final PhoneAuthViewModel viewModel;
  const NameReg({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PhoneAuthViewModel>.value(
      value: viewModel,
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
                                    "Openzo - Super App for your locality",
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
                                        'Your Name',
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
                                      TextField(
                                        controller: viewModel.nameController,
                                        keyboardType: TextInputType.name,
                                        decoration: const InputDecoration(
                                          labelText: 'Name',
                                          hintText: 'Enter your name',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          viewModel.saveName(context);
                                        },
                                        child: const Text("Continue"),
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
