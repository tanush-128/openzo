import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/main.dart';
import 'package:openzo_frontend/models/user_data.dart';
import 'package:openzo_frontend/src/bottomNavigationBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  String? token;
  MyApp({
    super.key,
    required this.settingsController,
    required this.token,
  });

  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
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

handleUserData(String fcmToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? userDataId = prefs.getInt('user_data_id');
  if (userDataId == null) {
    Position position = await getLocation();
    UserData userData = UserData(
      id: 0,
      userId: 0,
      latitude: position.latitude.toString(),
      longitude: position.longitude.toString(),
      address: '0',
      pincode: '0',
      city: '0',
      state: '0',
      country: '0',
      notificationToken: fcmToken,
    );
    UserData.createUserData(userData);
  } else {
    log('User data already exists');
  }
}

class _MyAppState extends State<MyApp> {
  String _lastMessage = "";
  _MyAppState() {
    messageStreamController.listen((message) {
      setState(() {
        if (message.notification != null) {
          _lastMessage = 'Received a notification message:'
              '\nTitle=${message.notification?.title},'
              '\nBody=${message.notification?.body},'
              '\nData=${message.data}';
        } else {
          _lastMessage = 'Received a data message: ${message.data}';
        }
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    handleUserData(widget.token!);
  }

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.grey.shade50,
            dividerColor: Colors.grey.shade100,
            iconButtonTheme: const IconButtonThemeData(),
            dividerTheme: DividerThemeData(
              space: 0,
              thickness: 0.7,
              color: Colors.grey.shade300,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: GlobalStyle.primaryColor,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              centerTitle: true,
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            colorScheme: ColorScheme.fromSeed(
                seedColor: GlobalStyle.primaryColor,
                secondary: GlobalStyle.primaryColor,
                brightness: Brightness.light),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                // backgroundColor: GlobalStyle.primaryColor,
                backgroundColor: GlobalStyle.secondaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: GlobalStyle.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              foregroundColor: Colors.white,
            ),
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
          ),

          // darkTheme: ThemeData.dark(),
          themeMode: widget.settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: widget.settingsController);

                  default:
                    return const BottomNavBar();
                }
              },
            );
          },
        );
      },
    );
  }
}
