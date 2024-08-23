import 'package:flutter/material.dart';
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
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return StoreCard(store: snapshot.data![index]);
          },
        );
      },
    );
  }
}
