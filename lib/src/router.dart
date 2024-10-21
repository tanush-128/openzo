import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/viewmodels/phone_auth_view_model.dart';
import 'package:openzo_frontend/viewmodels/user_provider.dart';
import 'package:openzo_frontend/views/booking/bookingPage.dart';
import 'package:openzo_frontend/src/bottom_navigation_bar.dart';
import 'package:openzo_frontend/views/cart/cart_page_view.dart';
import 'package:openzo_frontend/views/categories_page_view.dart';
import 'package:openzo_frontend/views/coming_soon_page_view.dart';
import 'package:openzo_frontend/views/login/login_page_view.dart';
import 'package:openzo_frontend/views/login/name_reg.dart';
import 'package:openzo_frontend/views/no_internet_page.dart';
import 'package:openzo_frontend/views/product/product_page_view.dart';

import 'package:openzo_frontend/views/store/store_page_view.dart';
import 'package:openzo_frontend/views/category_list/category_list_view.dart';
import 'package:openzo_frontend/views/user/account_page_view.dart';
import 'package:openzo_frontend/src/webview/web_view.dart';
import 'package:provider/provider.dart';

class AppRouterListenable extends ChangeNotifier {
  AppRouterListenable();
}

class AppRouter {
  final GoRouter router;

  AppRouter()
      : router = GoRouter(
          initialLocation: '/',

          observers: [
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
          ],
          redirect: (context, state) async {
            bool result = await InternetConnection().hasInternetAccess;
            if (!result) {
              return '/no-internet';
            }
            if (state.uri.pathSegments.isEmpty) {
              return '/';
            }
            return state.path;
          },
          // redirect: (context, state) async {
          //   final user = Provider.of<UserProvider>(context, listen: false).user;
          //   final loggedIn = user.id.isNotEmpty;
          //   final loggingIn = state.matchedLocation == 'login';
          //   if (!loggedIn) return "/login";
          //   return null;
          // },
          // refreshListenable: ,
          routes: <RouteBase>[
            GoRoute(
              path: '/',
              builder: (context, state) => const BottomNavBar(),
              routes: [
                GoRoute(
                  path: 'login',
                  builder: (context, state) => const PhoneAuthPage(),
                  onExit: (context) {
                    return Provider.of<UserProvider>(context, listen: false)
                        .isLoggedIn;
                  },
                ),
                // no internet
                GoRoute(
                    path: 'no-internet',
                    builder: (context, state) => NoInternet()),
                GoRoute(
                    path: 'privacy-policy',
                    builder: (context, state) {
                      return const WebViewC(
                        url: 'https://www.openzo.in/privacy-policy',
                      );
                    }),
                GoRoute(
                  path: 'name-reg',
                  builder: (context, state) {
                    final viewModel = state.extra as PhoneAuthViewModel;
                    return NameReg(viewModel: viewModel);
                  },
                ),
                GoRoute(
                    path: 'coming-soon',
                    builder: (context, state) {
                      return const ComingSoonPage();
                    }),
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
                      return CategoryList(
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
                      return CategoryList(
                        category: GlobalConsts.categories.firstWhere(
                            (element) => element.name == 'Stores',
                            orElse: () => GlobalConsts.categories.first),
                        subCategory: GlobalConsts.categories.first.subCategories
                            .firstWhere(
                          (element) => element.name == 'Grocery stores',
                          orElse: () =>
                              GlobalConsts.categories.first.subCategories.first,
                        ),
                        deliveryOnly: true,
                        showSubCategories: false,
                      );
                    }),
                GoRoute(
                    path: 'services',
                    builder: (context, state) {
                      return CategoryList(
                        category: GlobalConsts.categories.firstWhere(
                            (element) => element.name == 'Services',
                            orElse: () => GlobalConsts.categories.first),
                      );
                    }),
                GoRoute(
                    path: 'stores',
                    builder: (context, state) {
                      return CategoryList(
                        category: GlobalConsts.categories.firstWhere(
                            (element) => element.name == 'Stores',
                            orElse: () => GlobalConsts.categories.first),
                      );
                    }),
                GoRoute(
                    path: 'home-services',
                    builder: (context, state) {
                      return CategoryList(
                        category: GlobalConsts.categories.firstWhere(
                            (element) => element.name == 'Home Services',
                            orElse: () => GlobalConsts.categories.first),
                      );
                    }),
                GoRoute(
                    path: 'hotel-rooms',
                    builder: (context, state) {
                      return CategoryList(
                        category: GlobalConsts.categories.firstWhere(
                            (element) => element.name == 'Hotel',
                            orElse: () => GlobalConsts.categories.first),
                        showSubCategories: false,
                      );
                    }),
                GoRoute(
                    path: 'ride-hire',
                    builder: (context, state) {
                      return CategoryList(
                        category: GlobalConsts.categories.firstWhere(
                            (element) => element.name == 'Ride hire',
                            orElse: () => GlobalConsts.categories.first),
                        showSubCategories: false,
                      );
                    }),
                GoRoute(
                  path: 'campus-only',
                  builder: (context, state) {
                    return CategoryList(
                      category: GlobalConsts.categories.firstWhere(
                          (element) => element.name == 'Food',
                          orElse: () => GlobalConsts.categories.first),
                      deliveryOnly: true,
                      showSubCategories: false,
                      campusOnly: true,
                    );
                  },
                ),
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
                      final category = GlobalConsts.categories.firstWhere(
                          (element) => element.name == categoryID,
                          orElse: () => GlobalConsts.categories.first);
                      final subCategory =
                          state.uri.queryParameters['subCategory'];

                      return CategoryList(
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
                // GoRoute(
                //   path: 'login',
                //   builder: (context, state) => const PhoneAuthPage(),
                // ),
                GoRoute(
                  path: 'booking',
                  builder: (context, state) => const BookingPage(),
                ),
              ],
            ),
          ],
        );
}
