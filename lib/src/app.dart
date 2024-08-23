import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openzo_frontend/main.dart';
import 'package:openzo_frontend/providers/sales_provider.dart';
import 'package:openzo_frontend/src/router.dart';
import 'package:openzo_frontend/utils/notification.dart';
import 'package:openzo_frontend/utils/theme.dart';
import 'package:openzo_frontend/utils/user_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _isLoading = false;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }
      String? orderId = message.data['order_id'];
      if (orderId != null) {
        _appRouter.router.go("/cart/$orderId");
      }
      messageStreamController.sink.add(message);
    });

    FirebaseMessaging.onMessage.listen(foregroundMessageHandler(context));

    setUpAwesomeNotif(_appRouter);

    super.initState();
    _checkExistingUser();
  }

  Future<void> _handleUserAuthentication() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      await handleUserData(context);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Welcome back!')),
      // );

      _fetchOrdersAndNavigate();

      FirebaseAnalytics.instance.logLogin();
      // FirebaseAnalytics.instance.setUserProperty(
      //   name: 'phone_number',
      //   // value: _phoneController.text,
      // );
    } catch (error) {
      print('Error handling user authentication: $error');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('There was an error signing in')),
      // );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  _fetchOrdersAndNavigate() {
    try {
      Provider.of<SalesProvider>(context, listen: false).getOrders();
    } catch (error) {
      print('Error fetching orders: $error');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Failed to fetch orders')),
      // );
    }
  }

  Future<void> _checkExistingUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      await _handleUserAuthentication();
    } else {
      setState(() {
        _appRouter.router.go('/login');
      });
    }
  }

  // Initialize the router
  final AppRouter _appRouter = AppRouter();

  //when app is opened from background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("App state: $state");
    if (state == AppLifecycleState.resumed) {
      Provider.of<SalesProvider>(context, listen: false).getOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0),
            ),
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              restorationScopeId: 'app',
              theme: appTheme(context),
              routeInformationParser: _appRouter.router.routeInformationParser,
              routerDelegate: _appRouter.router.routerDelegate,
              routeInformationProvider:
                  _appRouter.router.routeInformationProvider,
            ));
      },
    );
  }
}
