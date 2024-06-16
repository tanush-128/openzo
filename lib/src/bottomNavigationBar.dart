import 'package:flutter/material.dart';
import 'package:openzo_frontend/constants/styles.dart';
import 'package:openzo_frontend/src/bytes/bytes_page.dart';
import 'package:openzo_frontend/src/cart/carts_page.dart';
import 'package:openzo_frontend/src/categories_page.dart';
import 'package:openzo_frontend/src/home_page/home_page.dart';
import 'package:openzo_frontend/src/marketplace/marketplacePage.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  List<Widget> pages = <Widget>[
    const HomePage(),
    const CategoriesPage(),
    const BytesPage(),
    const CartsPage(),
    MarketplacePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            // icon: Icon(Icons.home),
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
            label: 'profile',
          ),
        ],
      ),
    );
  }
}
