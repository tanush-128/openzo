import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/main.dart';
import 'package:openzo_frontend/src/router.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
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
    // handleUserData(widget.token!);
  }

  // Initialize the router
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      restorationScopeId: 'app',

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        dividerColor: Colors.grey.shade100,
        iconButtonTheme: const IconButtonThemeData(),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: GlobalStyle.primaryColor,
          unselectedItemColor: Colors.black87,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          selectedIconTheme: IconThemeData(size: 24),
          unselectedIconTheme: IconThemeData(size: 24),
          elevation: 10,
          selectedLabelStyle:
              TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        dividerTheme: DividerThemeData(
          space: 0,
          thickness: 0.7,
          color: Colors.grey.shade300,
        ),
        appBarTheme: AppBarTheme(
          // backgroundColor: GlobalStyle.primaryColor,
          elevation: 1,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.grey.shade200,
          // iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        colorScheme: ColorScheme.fromSeed(
            seedColor: GlobalStyle.primaryColor,
            secondary: GlobalStyle.primaryColor,
            brightness: Brightness.light),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: GlobalStyle.primaryColor,
            // backgroundColor: GlobalStyle.secondaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
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

      // Define a function to handle named routes in order to support
      // Flutter web url navigation and deep linking.
      routeInformationParser: _appRouter.router.routeInformationParser,
      routerDelegate: _appRouter.router.routerDelegate,
      routeInformationProvider: _appRouter.router.routeInformationProvider,
    );
  }
}
// Remove the incomplete code block
