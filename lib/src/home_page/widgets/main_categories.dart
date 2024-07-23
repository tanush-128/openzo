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
          crossAxisCount: 4, mainAxisSpacing: 15),
      children: [
        const MainCategoryTile(title: 'Food delivery', route: '/food-delivery'),
        const MainCategoryTile(title: 'Service stores', route: '/services'),
        const MainCategoryTile(title: 'Stores', route: '/stores'),
        const MainCategoryTile(
            title: 'Grocery delivery', route: '/grocery-delivery'),
        const MainCategoryTile(title: 'Services', route: '/home-services'),
        const MainCategoryTile(title: 'Hotel rooms', route: '/hotel-rooms'),
        // const MainCategoryTile(title: 'Food'),
        const MainCategoryTile(title: 'MIT Campus only', route: '/campus-only'),
        InkWell(
          onTap: () {
            context.go('/category');
          },
          child: Column(
            children: [
              Container(
                width: 70,
                height: 70,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Colors.white,
                ),
                child: const Icon(Icons.arrow_right_alt_rounded),
              ),
              const Text("More", style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
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
            width: 64,
            height: 54,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.white,
            ),
            child: Image.asset('assets/images/home page icons/$title.png'),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
