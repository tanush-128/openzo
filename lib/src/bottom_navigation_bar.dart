import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/services/connectivity_service.dart';
import 'package:openzo_frontend/services/user_service.dart';
import 'package:openzo_frontend/src/bytes/bytes_page.dart';
import 'package:openzo_frontend/viewmodels/user_provider.dart';
import 'package:openzo_frontend/views/activity/activity_page_view.dart';
import 'package:openzo_frontend/views/categories_page_view.dart';
import 'package:openzo_frontend/views/home_page/home_page_view.dart';
import 'package:openzo_frontend/views/login/loading_screen.dart';
import 'package:openzo_frontend/views/marketplace/marketplace_page_view.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  bool _internet = true; // Assume true initially
  final ConnectivityService _connectivityService = ConnectivityService();
  late UserService _userService;

  @override
  initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const CategoriesPage(),
      const BytesPage(),
      const ActivityPage(),
      MarketplacePage(),
    ];

    _userService = Provider.of<UserService>(context, listen: false);
    _initialize();
  }

  Future<void> _initialize() async {
    await _checkInternetConnection();
    if (_internet) {
      await _checkAuthentication();
    } else {
      if (mounted) {
        context.go('/no-internet');
      }
    }
  }

  Future<void> _checkInternetConnection() async {
    _internet = await _connectivityService.hasInternetConnection();
    setState(() {});
  }

  Future<void> _checkAuthentication() async {
    bool isAuthenticated = await _userService.isUserAuthenticated();
    if (isAuthenticated) {
      log("Checking authentication");

      await _userService.handleUserAuthentication(
        onPermissionDenied: () => _showLocationPermissionDialog(context),
      );
      // Fetch orders if necessary
    } else {
      if (mounted) {
        context.go('/login');
      }
    }
  }

  Future<void> _showLocationPermissionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'This app needs location access to function properly. Please grant location permission.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Geolocator.requestPermission();
            },
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (!_internet) {
          return const LoadingScreen();
        }

        if (!userProvider.isLoggedIn) {
          // User is not logged in
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
                icon:
                    ImageIcon(AssetImage('assets/icons/Local marketplace.png')),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
