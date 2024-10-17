import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:openzo_frontend/main.dart';
import 'package:openzo_frontend/models/user.dart';
import 'package:openzo_frontend/viewmodels/sales_provider.dart';
import 'package:openzo_frontend/viewmodels/user_provider.dart';
import 'package:openzo_frontend/src/router.dart';
import 'package:openzo_frontend/src/utils/notification.dart';
import 'package:openzo_frontend/src/utils/theme.dart';
import 'package:openzo_frontend/src/utils/user_util.dart';
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
