import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/src/booking/bookingPage.dart';
import 'package:openzo_frontend/src/bottomNavigationBar.dart';
import 'package:openzo_frontend/src/cart/cart_page.dart';
import 'package:openzo_frontend/src/categories_page.dart';
import 'package:openzo_frontend/src/home_page/pages/food_delivery.dart';
import 'package:openzo_frontend/src/login/loginPage.dart';
import 'package:openzo_frontend/src/product/productPage/product_page.dart';
import 'package:openzo_frontend/src/store_page/store_page.dart';
import 'package:openzo_frontend/src/stores_of_category/storesByCategory.dart';
import 'package:openzo_frontend/src/user/account_page.dart';
import 'package:openzo_frontend/src/webview/web_view.dart';

class AppRouter {
  final GoRouter router;

  AppRouter()
      : router = GoRouter(
          initialLocation: '/login',
          // initialLocation: '/webview',
          observers: [
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
          ],
          routes: <RouteBase>[
            GoRoute(
              path: '/',
              builder: (context, state) => const BottomNavBar(),
              routes: [
                GoRoute(
                    path: 'webview',
                    builder: (context, state) {
                      return WebViewC();
                    }),
                GoRoute(
                  path: 'account',
                  builder: (context, state) => const AccountPage(),
                ),
                GoRoute(
                    path: 'food-delivery',
                    builder: (context, state) {
                      return StoresByCategory(
                        category: GlobalConsts.categories.firstWhere(
                            (element) => element.name == 'Food',
                            orElse: () => GlobalConsts.categories.first),
                        deliveryOnly: true,
                        showSubCategories: false,
                      );
                    }),
                GoRoute(
                    path: 'grocery-delivery',
                    builder: (context, state) {
                      return StoresByCategory(
                        category: GlobalConsts.categories.firstWhere(
                            (element) => element.name == 'Stores',
                            orElse: () => GlobalConsts.categories.first),
                        subCategory: GlobalConsts.categories.first.subCategories
                            .firstWhere(
                                (element) => element.name == 'Grocery stores',
                                orElse: () => GlobalConsts
                                    .categories.first.subCategories.first),
                        deliveryOnly: true,
                        showSubCategories: false,
                      );
                    }),
                GoRoute(
                    path: 'services',
                    builder: (context, state) {
                      return StoresByCategory(
                        category: GlobalConsts.categories.firstWhere(
                            (element) => element.name == 'Services',
                            orElse: () => GlobalConsts.categories.first),
                      );
                    }),
                GoRoute(
                    path: 'stores',
                    builder: (context, state) {
                      return StoresByCategory(
                        category: GlobalConsts.categories.firstWhere(
                            (element) => element.name == 'Stores',
                            orElse: () => GlobalConsts.categories.first),
                      );
                    }),
                GoRoute(
                    path: 'home-services',
                    builder: (context, state) {
                      return StoresByCategory(
                        category: GlobalConsts.categories.firstWhere(
                            (element) => element.name == 'Home Services',
                            orElse: () => GlobalConsts.categories.first),
                      );
                    }),
                GoRoute(
                    path: 'hotel-rooms',
                    builder: (context, state) {
                      return StoresByCategory(
                        category: GlobalConsts.categories.firstWhere(
                            (element) => element.name == 'Hotel',
                            orElse: () => GlobalConsts.categories.first),
                        showSubCategories: false,
                      );
                    }),
                GoRoute(
                    path: 'ride-hire',
                    builder: (context, state) {
                      return StoresByCategory(
                        category: GlobalConsts.categories.firstWhere(
                            (element) => element.name == 'Ride hire',
                            orElse: () => GlobalConsts.categories.first),
                        showSubCategories: false,
                      );
                    }),
                GoRoute(
                  path: 'cart/:storeID',
                  builder: (context, state) =>
                      CartPage(id: state.pathParameters['storeID'] ?? ''),
                ),
                GoRoute(
                  path: 'category',
                  builder: (context, state) => const CategoriesPage(),
                ),
                GoRoute(
                    path: 'category/:categoryID',
                    builder: (context, state) {
                      final categoryID = state.pathParameters['categoryID']!;
                      // '/category/${category.name}?subCategory=${e.name}');
                      final category = GlobalConsts.categories.firstWhere(
                          (element) => element.name == categoryID,
                          orElse: () => GlobalConsts.categories.first);
                      final subCategory =
                          state.uri.queryParameters['subCategory'];

                      return StoresByCategory(
                        category: category,
                        subCategory: subCategory != null
                            ? category.subCategories.firstWhere(
                                (element) => element.name == subCategory,
                                orElse: () => category.subCategories.first)
                            : null,
                      );
                    }),
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
