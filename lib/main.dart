import 'package:flutter/material.dart';
import 'package:openzo_frontend/providers/carts_provider.dart';
import 'package:openzo_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => CartsProvider()),
    ],
    child: MyApp(),
  ));
}
