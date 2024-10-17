import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:openzo_frontend/models/user.dart';
import 'package:openzo_frontend/viewmodels/sales_provider.dart';
import 'package:openzo_frontend/viewmodels/user_provider.dart';
import 'package:openzo_frontend/src/bytes/bytes_page.dart';
import 'package:openzo_frontend/src/cart/carts/carts_page.dart';
import 'package:openzo_frontend/src/categories_page.dart';
import 'package:openzo_frontend/src/home_page/home_page.dart';
import 'package:openzo_frontend/src/login/loading_screen.dart';
import 'package:openzo_frontend/src/marketplace/marketplacePage.dart';
import 'package:openzo_frontend/src/utils/user_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  bool _internet = false;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const CategoriesPage(),
      const BytesPage(),
      const CartsPage(),
      MarketplacePage(),
    ];

    _checkInternetAndAuthenticate();
  }

  // Check for internet connection and user authentication
  Future<void> _checkInternetAndAuthenticate() async {
    bool internetConnected = await InternetConnection().hasInternetAccess;

    setState(() {
      _internet = internetConnected;
    });

    if (internetConnected) {
      await _checkExistingUser();
    } else {
      context.go('/no-internet');
    }
  }

  // Check if the user already exists and handle authentication
  Future<void> _checkExistingUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      await _handleUserAuthentication();
    } else {
      context.go('/login');
    }
  }

  // Handle user authentication and navigate
  Future<void> _handleUserAuthentication() async {
    try {
      await handleUserData(context);
      await _fetchOrdersAndNavigate();
      FirebaseAnalytics.instance.logLogin();
    } catch (error) {
      _handleAuthenticationError(error);
    } finally {
      setState(() {
        _loggedIn = true;
      });
    }
  }

  // Fetch user orders and navigate based on user data
  Future<void> _fetchOrdersAndNavigate() async {
    try {
      await Provider.of<SalesProvider>(context, listen: false).getOrders();
      User user = Provider.of<UserProvider>(context, listen: false).user;

      if (user.id.isNotEmpty) {
        if (user.name == null || user.name!.isEmpty) {
          context.go('/name-reg');
        }
      }
    } catch (error) {
      _showErrorSnackbar('Failed to fetch orders');
    }
  }

  // Handle authentication error
  Future<void> _handleAuthenticationError(dynamic error) async {
    print('Error handling user authentication: $error');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _showErrorSnackbar('There was an error signing in');
  }

  // Display error messages via Snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_internet || !_loggedIn) {
      _checkInternetAndAuthenticate();
      return const LoadingScreen();
    }

    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/Home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/Categories.png')),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/Bytes.png')),
            label: 'Bytes',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/Bags.png')),
            label: 'Carts',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/Local marketplace.png')),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
