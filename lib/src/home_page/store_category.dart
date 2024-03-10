import 'package:flutter/material.dart';

class StoreCategory extends StatelessWidget {
  String imageName;
  String categoryName;
  StoreCategory({
    super.key,
    required this.imageName,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: SizedBox(
        height: 120,
        width: 100,
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/$imageName"), scale: 2),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 0.1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 0.1,
                    blurRadius: 2,
                    offset: const Offset(-2, -1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              categoryName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                // fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
