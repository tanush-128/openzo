import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/main.dart';
import 'package:openzo_frontend/providers/sales_provider.dart';
import 'package:openzo_frontend/src/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

void showNotification(RemoteMessage message) {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: 10,
    payload: {
      'order_id': message.data["order_id"],
      'status': message.data["status"],
    },
    channelKey: 'basic_channel',
    actionType: ActionType.Default,
    notificationLayout: NotificationLayout.Default,
    wakeUpScreen: true,
    displayOnForeground: true,
    displayOnBackground: true,
    backgroundColor: GlobalStyle.primaryColor,
    color: Colors.green,
    ticker: 'ticker',
    autoDismissible: true,
    title: message.notification?.title ?? 'Notification',
    body: message.notification?.body ?? 'Order status updated',
  ));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  showNotification(message);
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {}
}

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
      }
      messageStreamController.sink.add(message);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Handling a foreground message: ${message.messageId}');
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
      }

      if (message.data['order_id'] != null && message.data['status'] != null) {
        Provider.of<SalesProvider>(context, listen: false).updateOrderStatus(
          message.data['order_id'],
          message.data['status'],
        );
      }
      showNotification(message);

      messageStreamController.sink.add(message);
    });
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    super.initState();
  }

  // Initialize the router
  final AppRouter _appRouter = AppRouter();

  //when app is opened from background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Provider.of<SalesProvider>(context, listen: false).getOrders();
    super.didChangeAppLifecycleState(state);
  }

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
      routeInformationParser: _appRouter.router.routeInformationParser,
      routerDelegate: _appRouter.router.routerDelegate,
      routeInformationProvider: _appRouter.router.routeInformationProvider,
    );
  }
}
