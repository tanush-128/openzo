import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainCategories extends StatelessWidget {
  const MainCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 0,
          crossAxisSpacing: 24,
          childAspectRatio: 0.86),
      children: const [
        MainCategoryTile(title: 'Food delivery', route: '/food-delivery'),
        MainCategoryTile(title: 'Service stores', route: '/services'),
        MainCategoryTile(title: 'Stores', route: '/stores'),
        MainCategoryTile(title: 'Grocery delivery', route: '/grocery-delivery'),
        MainCategoryTile(title: 'Services', route: '/home-services'),
        // const MainCategoryTile(title: 'Hotel rooms', route: '/hotel-rooms'),
        MainCategoryTile(title: 'MIT Campus only', route: '/campus-only'),
        // InkWell(
        //   onTap: () {
        //     context.go('/category');
        //   },
        //   child: Column(
        //     children: [
        //       Container(
        //         width: 70,
        //         height: 70,
        //         padding: const EdgeInsets.all(10),
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(100.0),
        //           color: Colors.white,
        //         ),
        //         child: const Icon(Icons.arrow_right_alt_rounded),
        //       ),
        //       const Text("More", style: TextStyle(fontSize: 12)),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}

class MainCategoryTile extends StatelessWidget {
  final String title;
  final String? route;
  const MainCategoryTile({
    super.key,
    required this.title,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (route != null) {
          context.go(route!);
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.white,
            ),
            child: Image.asset('assets/images/home page icons/$title.png'),
          ),
          // Text(
          //   title,
          //   style: const TextStyle(fontSize: 12),
          //   textAlign: TextAlign.center,
          // ),
        ],
      ),
    );
  }
}
