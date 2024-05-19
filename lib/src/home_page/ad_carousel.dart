import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/ad.dart';

class AdSpace extends StatefulWidget {
  const AdSpace({super.key});

  @override
  State<AdSpace> createState() => _AdSpaceState();
}

class _AdSpaceState extends State<AdSpace> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Ad.fetchMany("123456"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200.0,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 0.1,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                    // image: DecorationImage(
                    //     image: NetworkImage(ad.image), fit: BoxFit.cover),

                    borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.grey.shade500,
                  ),
                )),
          ));
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No ads found'),
          );
        }
        return CarouselSlider(
          options: CarouselOptions(
              height: 200.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 1600),
              autoPlayCurve: Curves.fastOutSlowIn,
              pauseAutoPlayOnTouch: true,
              aspectRatio: 3,
              // padEnds: true,
              viewportFraction: 1,
              // enlargeCenterPage: true,
              scrollDirection: Axis.horizontal),
          items: snapshot.data?.map((ad) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0.1,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                        image: DecorationImage(
                            image: NetworkImage(ad.image), fit: BoxFit.cover),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16))),
                    child: Center(
                      child: Text(
                        ad.name,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
