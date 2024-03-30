import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openzo_frontend/constants/constants.dart';

class StoreCategoryTile extends StatelessWidget {
  StoreCategory storeCategory;
  StoreCategoryTile({
    super.key,
    required this.storeCategory,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
       
        context.go('/store?category=${storeCategory.categoryName}');
      },
      child: SizedBox(
        height: 130,
        width: 100,
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image:
                        AssetImage("assets/images/${storeCategory.imageName}"),
                    scale: 2),
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
              storeCategory.categoryName,
              textAlign: TextAlign.center,
              // overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
