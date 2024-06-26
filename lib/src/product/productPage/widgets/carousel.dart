import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:openzo_frontend/models/product.dart';
class ProductImagesCarousel extends StatelessWidget {
  final List<ProductImage> images;

  ProductImagesCarousel({required this.images});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: images.map((image) {
        return Image.network(image.image,
            fit: BoxFit.contain, width: MediaQuery.of(context).size.width,
            errorBuilder: (context, error, stackTrace) {
          return const Image(
            image: AssetImage('assets/images/placeholder.png'),
            fit: BoxFit.contain,
            width: 400,
            height: 400,
          );
        });
      }).toList(),
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 1,
        viewportFraction: 1,
        // enlargeCenterPage: true,
        // enlargeStrategy: CenterPageEnlargeStrategy.height,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
