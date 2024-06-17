import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/src/booking/bookingPage.dart';
import 'package:openzo_frontend/src/bottomNavigationBar.dart';
import 'package:openzo_frontend/src/cart/cart_page.dart';
import 'package:openzo_frontend/src/login/loginPage.dart';
import 'package:openzo_frontend/src/product/productPage/productPage.dart';
import 'package:openzo_frontend/src/store_page/store_page.dart';

class AppRouter {
  final GoRouter router;

  AppRouter()
      : router = GoRouter(
          initialLocation: '/login',
          routes: <RouteBase>[
            GoRoute(
              path: '/',
              builder: (context, state) => const BottomNavBar(),
              routes: [
                GoRoute(
                  path: 'cart/:storeID',
                  builder: (context, state) =>
                      CartPage(id: state.pathParameters['storeID'] ?? ''),
                ),
                GoRoute(
                    path: 'store/:storeID',
                    builder: (context, state) => StorePage(
                        storeId: state.pathParameters['storeID'] ?? ''),
                    routes: [
                      GoRoute(
                        path: 'product/:productID',
                        builder: (context, state) {
                          final productId = state.pathParameters['productID']!;
                          return ProductPage(productId: productId);
                        },
                      )
                    ]),
                GoRoute(
                  path: 'login',
                  builder: (context, state) => PhoneAuthPage(),
                ),
                GoRoute(
                  path: 'booking',
                  builder: (context, state) => const BookingPage(),
                ),
              ],
            ),
          ],
        );
}
