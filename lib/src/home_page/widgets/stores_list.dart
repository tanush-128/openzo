import 'package:flutter/material.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/src/home_page/widgets/store_card.dart';
import 'package:openzo_frontend/src/home_page/widgets/store_card_skeleton.dart';

class StoresList extends StatelessWidget {
  const StoresList({
    super.key,
    required this.future,
  });
  final Future<List<Store>> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Store>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5, // Number of skeleton cards
            itemBuilder: (context, index) => const StoreCardSkeleton(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString(),
                style: const TextStyle(color: Colors.red)),
          );
        }
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No stores found'),
          );
        }
        List<Store> stores = snapshot.data!;
        List<Store> foodStores =
            stores.where((store) => store.storeType == StoreType.food).toList();
        List<Store> productsStores = stores
            .where((store) => store.storeType == StoreType.store)
            .toList();
        List<Store> serviceStores = stores
            .where((store) => store.storeType == StoreType.service)
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("Top places to find food"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var store in foodStores) StoreCard(store: store),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildHeader("Top stores near you"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var store in productsStores) StoreCard(store: store),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildHeader("Top services near you"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var store in serviceStores) StoreCard(store: store),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildHeader("New Businesses near you"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var store in stores) StoreCard(store: store),
                ],
              ),
            ),
          ],
        );

        // return ListView.builder(
        //   shrinkWrap: true,
        //   physics: const NeverScrollableScrollPhysics(),
        //   itemCount: snapshot.data!.length,
        //   itemBuilder: (context, index) {
        //     return StoreCard(store: snapshot.data![index]);
        //   },
        // );
      },
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
